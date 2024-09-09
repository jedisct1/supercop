#define RATE 64

static void
aegis256x4_init(const uint8_t *key, const uint8_t *nonce, aes_block_t *const state)
{
    static CRYPTO_ALIGN(AES_BLOCK_LENGTH) const uint8_t c0_[AES_BLOCK_LENGTH] = {
        0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d, 0x15, 0x22, 0x37, 0x59, 0x90,
        0xe9, 0x79, 0x62, 0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d, 0x15, 0x22,
        0x37, 0x59, 0x90, 0xe9, 0x79, 0x62, 0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08,
        0x0d, 0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62, 0x00, 0x01, 0x01, 0x02,
        0x03, 0x05, 0x08, 0x0d, 0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62,
    };
    static CRYPTO_ALIGN(AES_BLOCK_LENGTH) const uint8_t c1_[AES_BLOCK_LENGTH] = {
        0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1, 0x20, 0x11, 0x31, 0x42, 0x73,
        0xb5, 0x28, 0xdd, 0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1, 0x20, 0x11,
        0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd, 0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f,
        0xf1, 0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd, 0xdb, 0x3d, 0x18, 0x55,
        0x6d, 0xc2, 0x2f, 0xf1, 0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd,
    };

    const aes_block_t c0 = AES_BLOCK_LOAD(c0_);
    const aes_block_t c1 = AES_BLOCK_LOAD(c1_);
    uint8_t           tmp[4 * 16];
    uint8_t           context_bytes[AES_BLOCK_LENGTH];
    aes_block_t       context;
    aes_block_t       k0, k1;
    aes_block_t       n0, n1;
    aes_block_t       k0_n0, k1_n1;
    int               i;

    memcpy(tmp, key, 16);
    memcpy(tmp + 16, key, 16);
    memcpy(tmp + 32, key, 16);
    memcpy(tmp + 48, key, 16);
    k0 = AES_BLOCK_LOAD(tmp);
    memcpy(tmp, key + 16, 16);
    memcpy(tmp + 16, key + 16, 16);
    memcpy(tmp + 32, key + 16, 16);
    memcpy(tmp + 48, key + 16, 16);
    k1 = AES_BLOCK_LOAD(tmp);

    memcpy(tmp, nonce, 16);
    memcpy(tmp + 16, nonce, 16);
    memcpy(tmp + 32, nonce, 16);
    memcpy(tmp + 48, nonce, 16);
    n0 = AES_BLOCK_LOAD(tmp);
    memcpy(tmp, nonce + 16, 16);
    memcpy(tmp + 16, nonce + 16, 16);
    memcpy(tmp + 32, nonce + 16, 16);
    memcpy(tmp + 48, nonce + 16, 16);
    n1 = AES_BLOCK_LOAD(tmp);

    k0_n0 = AES_BLOCK_XOR(k0, n0);
    k1_n1 = AES_BLOCK_XOR(k1, n1);

    memset(context_bytes, 0, sizeof context_bytes);
    context_bytes[0 * 16]     = 0x00;
    context_bytes[0 * 16 + 1] = 0x03;
    context_bytes[1 * 16]     = 0x01;
    context_bytes[1 * 16 + 1] = 0x03;
    context_bytes[2 * 16]     = 0x02;
    context_bytes[2 * 16 + 1] = 0x03;
    context_bytes[3 * 16]     = 0x03;
    context_bytes[3 * 16 + 1] = 0x03;
    context                   = AES_BLOCK_LOAD(context_bytes);

    state[0] = k0_n0;
    state[1] = k1_n1;
    state[2] = c1;
    state[3] = c0;
    state[4] = AES_BLOCK_XOR(k0, c0);
    state[5] = AES_BLOCK_XOR(k1, c1);
    for (i = 0; i < 4; i++) {
        state[3] = AES_BLOCK_XOR(state[3], context);
        state[5] = AES_BLOCK_XOR(state[5], context);
        aegis256x4_update(state, k0);
        state[3] = AES_BLOCK_XOR(state[3], context);
        state[5] = AES_BLOCK_XOR(state[5], context);
        aegis256x4_update(state, k1);
        state[3] = AES_BLOCK_XOR(state[3], context);
        state[5] = AES_BLOCK_XOR(state[5], context);
        aegis256x4_update(state, k0_n0);
        state[3] = AES_BLOCK_XOR(state[3], context);
        state[5] = AES_BLOCK_XOR(state[5], context);
        aegis256x4_update(state, k1_n1);
    }
}

static void
aegis256x4_mac(uint8_t *mac, size_t maclen, size_t adlen, size_t mlen, aes_block_t *const state)
{
    uint8_t     mac_multi_0[AES_BLOCK_LENGTH];
    uint8_t     mac_multi_1[AES_BLOCK_LENGTH];
    aes_block_t tmp;
    int         i;

    tmp = AES_BLOCK_LOAD_64x2(((uint64_t) mlen) << 3, ((uint64_t) adlen) << 3);
    tmp = AES_BLOCK_XOR(tmp, state[3]);

    for (i = 0; i < 7; i++) {
        aegis256x4_update(state, tmp);
    }

    if (maclen == 16) {
        tmp = AES_BLOCK_XOR(state[5], state[4]);
        tmp = AES_BLOCK_XOR(tmp, AES_BLOCK_XOR(state[3], state[2]));
        tmp = AES_BLOCK_XOR(tmp, AES_BLOCK_XOR(state[1], state[0]));
        AES_BLOCK_STORE(mac_multi_0, tmp);
        for (i = 0; i < 16; i++) {
            mac[i] = mac_multi_0[i] ^ mac_multi_0[1 * 16 + i] ^ mac_multi_0[2 * 16 + i] ^
                     mac_multi_0[3 * 16 + i];
        }
    } else if (maclen == 32) {
        tmp = AES_BLOCK_XOR(state[2], AES_BLOCK_XOR(state[1], state[0]));
        AES_BLOCK_STORE(mac_multi_0, tmp);
        for (i = 0; i < 16; i++) {
            mac[i] = mac_multi_0[i] ^ mac_multi_0[1 * 16 + i] ^ mac_multi_0[2 * 16 + i] ^
                     mac_multi_0[3 * 16 + i];
        }

        tmp = AES_BLOCK_XOR(state[5], AES_BLOCK_XOR(state[4], state[3]));
        AES_BLOCK_STORE(mac_multi_1, tmp);
        for (i = 0; i < 16; i++) {
            mac[i + 16] = mac_multi_1[i] ^ mac_multi_1[1 * 16 + i] ^ mac_multi_1[2 * 16 + i] ^
                          mac_multi_1[3 * 16 + i];
        }
    } else {
        memset(mac, 0, maclen);
    }
}

static inline void
aegis256x4_absorb(const uint8_t *const src, aes_block_t *const state)
{
    aes_block_t msg;

    msg = AES_BLOCK_LOAD(src);
    aegis256x4_update(state, msg);
}

static inline void
aegis256x4_absorb2(const uint8_t *const src, aes_block_t *const state)
{
    aes_block_t msg0, msg1;

    msg0 = AES_BLOCK_LOAD(src + 0 * AES_BLOCK_LENGTH);
    msg1 = AES_BLOCK_LOAD(src + 1 * AES_BLOCK_LENGTH);
    aegis256x4_update(state, msg0);
    aegis256x4_update(state, msg1);
}

static void
aegis256x4_enc(uint8_t *const dst, const uint8_t *const src, aes_block_t *const state)
{
    aes_block_t msg;
    aes_block_t tmp;

    msg = AES_BLOCK_LOAD(src);
    tmp = AES_BLOCK_XOR(msg, state[5]);
    tmp = AES_BLOCK_XOR(tmp, state[4]);
    tmp = AES_BLOCK_XOR(tmp, state[1]);
    tmp = AES_BLOCK_XOR(tmp, AES_BLOCK_AND(state[2], state[3]));
    AES_BLOCK_STORE(dst, tmp);

    aegis256x4_update(state, msg);
}

static void
aegis256x4_dec(uint8_t *const dst, const uint8_t *const src, aes_block_t *const state)
{
    aes_block_t msg;

    msg = AES_BLOCK_LOAD(src);
    msg = AES_BLOCK_XOR(msg, state[5]);
    msg = AES_BLOCK_XOR(msg, state[4]);
    msg = AES_BLOCK_XOR(msg, state[1]);
    msg = AES_BLOCK_XOR(msg, AES_BLOCK_AND(state[2], state[3]));
    AES_BLOCK_STORE(dst, msg);

    aegis256x4_update(state, msg);
}

static void
aegis256x4_declast(uint8_t *const dst, const uint8_t *const src, size_t len,
                   aes_block_t *const state)
{
    uint8_t     pad[RATE];
    aes_block_t msg;

    memset(pad, 0, sizeof pad);
    memcpy(pad, src, len);

    msg = AES_BLOCK_LOAD(pad);
    msg = AES_BLOCK_XOR(msg, state[5]);
    msg = AES_BLOCK_XOR(msg, state[4]);
    msg = AES_BLOCK_XOR(msg, state[1]);
    msg = AES_BLOCK_XOR(msg, AES_BLOCK_AND(state[2], state[3]));
    AES_BLOCK_STORE(pad, msg);

    memset(pad + len, 0, sizeof pad - len);
    memcpy(dst, pad, len);

    msg = AES_BLOCK_LOAD(pad);

    aegis256x4_update(state, msg);
}

static int
encrypt_detached(uint8_t *c, uint8_t *mac, size_t maclen, const uint8_t *m, size_t mlen,
                 const uint8_t *ad, size_t adlen, const uint8_t *npub, const uint8_t *k)
{
    aes_block_t                state[6];
    CRYPTO_ALIGN(RATE) uint8_t src[RATE];
    CRYPTO_ALIGN(RATE) uint8_t dst[RATE];
    size_t                     i;

    aegis256x4_init(k, npub, state);

    for (i = 0; i + RATE * 2 <= adlen; i += RATE * 2) {
        aegis256x4_absorb2(ad + i, state);
    }
    for (; i + RATE <= adlen; i += RATE) {
        aegis256x4_absorb(ad + i, state);
    }
    if (adlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, ad + i, adlen % RATE);
        aegis256x4_absorb(src, state);
    }
    for (i = 0; i + RATE <= mlen; i += RATE) {
        aegis256x4_enc(c + i, m + i, state);
    }
    if (mlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, m + i, mlen % RATE);
        aegis256x4_enc(dst, src, state);
        memcpy(c + i, dst, mlen % RATE);
    }

    aegis256x4_mac(mac, maclen, adlen, mlen, state);

    return 0;
}

static int
decrypt_detached(uint8_t *m, const uint8_t *c, size_t clen, const uint8_t *mac, size_t maclen,
                 const uint8_t *ad, size_t adlen, const uint8_t *npub, const uint8_t *k)
{
    aes_block_t                state[6];
    CRYPTO_ALIGN(RATE) uint8_t src[RATE];
    CRYPTO_ALIGN(RATE) uint8_t dst[RATE];
    CRYPTO_ALIGN(16) uint8_t   computed_mac[32];
    const size_t               mlen = clen;
    size_t                     i;
    int                        ret;

    aegis256x4_init(k, npub, state);

    for (i = 0; i + RATE * 2 <= adlen; i += RATE * 2) {
        aegis256x4_absorb2(ad + i, state);
    }
    for (; i + RATE <= adlen; i += RATE) {
        aegis256x4_absorb(ad + i, state);
    }
    if (adlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, ad + i, adlen % RATE);
        aegis256x4_absorb(src, state);
    }
    if (m != NULL) {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis256x4_dec(m + i, c + i, state);
        }
    } else {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis256x4_dec(dst, c + i, state);
        }
    }
    if (mlen % RATE) {
        if (m != NULL) {
            aegis256x4_declast(m + i, c + i, mlen % RATE, state);
        } else {
            aegis256x4_declast(dst, c + i, mlen % RATE, state);
        }
    }

    aegis256x4_mac(computed_mac, maclen, adlen, mlen, state);
    ret = -1;
    if (maclen == 16) {
        ret = crypto_verify_16(computed_mac, mac);
    } else if (maclen == 32) {
        ret = crypto_verify_32(computed_mac, mac);
    }
    crypto_declassify(&ret, sizeof ret);
    if (ret != 0 && m != NULL) {
        memset(m, 0, mlen);
    }
    return ret;
}

// Supercop API

int
crypto_aead_encrypt(unsigned char *c, unsigned long long *clen, const unsigned char *m,
                    unsigned long long mlen, const unsigned char *ad, unsigned long long adlen,
                    const unsigned char *nsec, const unsigned char *npub, const unsigned char *k)
{
    (void) nsec;

    if (clen != NULL) {
        *clen = 0;
    }
    if (mlen > SIZE_MAX - CRYPTO_ABYTES || adlen > SIZE_MAX) {
        return -1;
    }
    if (encrypt_detached((uint8_t *) c, c + (size_t) mlen, CRYPTO_ABYTES, (const uint8_t *) m,
                         (size_t) mlen, (const uint8_t *) ad, (size_t) adlen,
                         (const uint8_t *) npub, (const uint8_t *) k) != 0) {
        return -1;
    }
    if (clen != NULL) {
        *clen = mlen + CRYPTO_ABYTES;
    }
    return 0;
}

int
crypto_aead_decrypt(unsigned char *m, unsigned long long *mlen, unsigned char *nsec,
                    const unsigned char *c, unsigned long long clen, const unsigned char *ad,
                    unsigned long long adlen, const unsigned char *npub, const unsigned char *k)
{
    (void) nsec;

    if (mlen != NULL) {
        *mlen = 0;
    }
    if (clen < CRYPTO_ABYTES) {
        return -1;
    }
    if (decrypt_detached((uint8_t *) m, (const uint8_t *) c, (size_t) clen - CRYPTO_ABYTES,
                         (const uint8_t *) c + (size_t) clen - CRYPTO_ABYTES, CRYPTO_ABYTES,
                         (const uint8_t *) ad, (size_t) adlen, (const uint8_t *) npub,
                         (const uint8_t *) k) != 0) {
        return -1;
    }
    if (mlen != NULL) {
        *mlen = clen - CRYPTO_ABYTES;
    }
    return 0;
}
