#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "api.h"
#include "common.h"
#include "crypto_aead.h"
#include "crypto_declassify.h"
#include "crypto_verify_16.h"
#include "crypto_verify_32.h"

#include "aes-bs16.h"

#define RATE      64
#define ALIGNMENT 32

static void
aegis_round_packed(AesBlocks st, const AesBlocks constant_input)
{
    AesBlocks st1;

    memcpy(st1, st, sizeof(AesBlocks));
    aes_round(st1);
    blocks_rotr(st1);
    blocks_xor(st, st1);
    blocks_xor(st, constant_input);
}

static void
aegis_pack_constant_input(AesBlocks st, const AesBlock m0, const AesBlock m1)
{
    size_t i;

    memset(st, 0, sizeof(AesBlocks));
    for (i = 0; i < 4; i++) {
        st[word_idx(0, i)] = m0[i];
    }
    for (i = 0; i < 4; i++) {
        st[word_idx(4, i)] = m1[i];
    }
    pack04(st);
}

static void
aegis_unpack_state(AesBlocks unpacked, const AesBlocks packed)
{
    memcpy(unpacked, packed, sizeof(AesBlocks));
    unpack2(unpacked);
}

static void
aegis128x2_keystream_packed(AesBlock z0, AesBlock z1, const AesBlocks st)
{
    AesBlocks z;
    size_t    i;

    for (i = 0; i < 32; i++) {
        const uint64_t x = st[i];

        z[i] = ((x & 0x0202020202020202) << 6) ^ ((x & 0x4040404040404040) << 1) ^
               (((x & 0x2020202020202020) << 2) & ((x & 0x1010101010101010) << 3)) ^
               ((x & 0x2020202020202020) >> 2) ^ ((x & 0x0404040404040404) << 1) ^
               (((x & 0x0202020202020202) << 2) & ((x & 0x0101010101010101) << 3));
    }
    unpack04(z);
    for (i = 0; i < 4; i++) {
        z0[i] = z[word_idx(0, i)];
        z1[i] = z[word_idx(4, i)];
    }
}

static void
aegis128x2_init(const uint8_t *key, const uint8_t *nonce, AesBlocks st)
{
    const AesBlock c0 = { 0x0201010002010100, 0x0d0805030d080503, 0x5937221559372215,
                          0x6279e9906279e990 };
    const AesBlock c1 = { 0x55183ddb55183ddb, 0xf12fc26df12fc26d, 0x4231112042311120,
                          0xdd28b573dd28b573 };
    AesBlock       k, n, kn, kc0, kc1;
    int            i;

    block_from_broadcast(k, key);
    block_from_broadcast(n, nonce);
    block_xor(kn, k, n);
    block_xor(kc0, k, c0);
    block_xor(kc1, k, c1);

    blocks_put(st, kn, 0);
    blocks_put(st, c1, 1);
    blocks_put(st, c0, 2);
    blocks_put(st, c1, 3);
    blocks_put(st, kn, 4);
    blocks_put(st, kc0, 5);
    blocks_put(st, kc1, 6);
    blocks_put(st, kc0, 7);

    {
        const AesBlocks constant_ctx_mask = { 0x0, 0x0, 0x0, 0x0, 0x0,  0x0,          0x0, 0x0,
                                              0x0, 0x0, 0x0, 0x0, 0x0,  0x0,          0x0, 0x0,
                                              0x0, 0x0, 0x0, 0x0, 0x0,  0x0,          0x0, 0x0,
                                              0x0, 0x0, 0x0, 0x0, 0x11, 0x1100000011, 0x0, 0x0 };
        AesBlocks       constant_input;

        aegis_pack_constant_input(constant_input, n, k);
        pack2(st);
        for (i = 0; i < 10; i++) {
            blocks_xor(st, constant_ctx_mask);
            aegis_round_packed(st, constant_input);
        }
    }
}

static void
aegis128x2_absorb_packed(const uint8_t *const src, AesBlocks st)
{
    AesBlocks constant_input;
    AesBlock  msg0, msg1;

    block_from_bytes(msg0, src);
    block_from_bytes(msg1, src + AES_BLOCK_LENGTH);
    aegis_pack_constant_input(constant_input, msg0, msg1);
    aegis_round_packed(st, constant_input);
}

static void
aegis128x2_enc(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock t0, t1;
    AesBlock z0, z1;
    AesBlock out0, out1;

    aegis128x2_keystream_packed(z0, z1, st);
    block_from_bytes(t0, src);
    block_from_bytes(t1, src + AES_BLOCK_LENGTH);
    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, t0, t1);
        aegis_round_packed(st, constant_input);
    }
    block_xor(out0, t0, z0);
    block_xor(out1, t1, z1);
    block_to_bytes(dst, out0);
    block_to_bytes(dst + AES_BLOCK_LENGTH, out1);
}

static void
aegis128x2_dec(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock msg0, msg1;
    AesBlock z0, z1;

    block_from_bytes(msg0, src);
    block_from_bytes(msg1, src + AES_BLOCK_LENGTH);
    aegis128x2_keystream_packed(z0, z1, st);
    block_xor(msg0, msg0, z0);
    block_xor(msg1, msg1, z1);
    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, msg0, msg1);
        aegis_round_packed(st, constant_input);
    }
    block_to_bytes(dst, msg0);
    block_to_bytes(dst + AES_BLOCK_LENGTH, msg1);
}

static void
aegis128x2_declast(uint8_t *const dst, const uint8_t *const src, size_t len, AesBlocks st)
{
    uint8_t  pad[RATE];
    AesBlock msg0, msg1;
    AesBlock z0, z1;

    memset(pad, 0, sizeof pad);
    memcpy(pad, src, len);

    block_from_bytes(msg0, pad);
    block_from_bytes(msg1, pad + AES_BLOCK_LENGTH);
    aegis128x2_keystream_packed(z0, z1, st);
    block_xor(msg0, msg0, z0);
    block_xor(msg1, msg1, z1);
    block_to_bytes(pad, msg0);
    block_to_bytes(pad + AES_BLOCK_LENGTH, msg1);
    memset(pad + len, 0, sizeof pad - len);
    memcpy(dst, pad, len);
    block_from_bytes(msg0, pad);
    block_from_bytes(msg1, pad + AES_BLOCK_LENGTH);
    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, msg0, msg1);
        aegis_round_packed(st, constant_input);
    }
}

static void
aegis128x2_mac(uint8_t *mac, size_t maclen, size_t adlen, size_t mlen, AesBlocks st)
{
    AesBlocks         unpacked;
    AesBlock          tmp;
    AesBlockBytesBase sizes;
    size_t            i;

    STORE64_LE(sizes, ((uint64_t) adlen) * 8);
    STORE64_LE(sizes + 8, ((uint64_t) mlen) * 8);
    block_from_broadcast(tmp, sizes);

    aegis_unpack_state(unpacked, st);
    for (i = 0; i < 4; i++) {
        tmp[i] ^= unpacked[word_idx(2, i)];
    }

    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, tmp, tmp);
        for (i = 0; i < 7; i++) {
            aegis_round_packed(st, constant_input);
        }
        unpack2(st);
    }

    if (maclen == 16) {
        for (i = 0; i < 4; i++) {
            tmp[i] = st[word_idx(0, i)] ^ st[word_idx(1, i)] ^ st[word_idx(2, i)] ^
                     st[word_idx(3, i)] ^ st[word_idx(4, i)] ^ st[word_idx(5, i)] ^
                     st[word_idx(6, i)];
        }
        fold_base_block_to_bytes(mac, tmp);
    } else if (maclen == 32) {
        for (i = 0; i < 4; i++) {
            tmp[i] =
                st[word_idx(0, i)] ^ st[word_idx(1, i)] ^ st[word_idx(2, i)] ^ st[word_idx(3, i)];
        }
        fold_base_block_to_bytes(mac, tmp);

        for (i = 0; i < 4; i++) {
            tmp[i] =
                st[word_idx(4, i)] ^ st[word_idx(5, i)] ^ st[word_idx(6, i)] ^ st[word_idx(7, i)];
        }
        fold_base_block_to_bytes(mac + 16, tmp);
    } else {
        memset(mac, 0, maclen);
    }
}

static void
aegis128x2_absorb_ad(AesBlocks st, uint8_t tmp[RATE], const uint8_t *ad, const size_t adlen)
{
    size_t i;

    for (i = 0; i + RATE <= adlen; i += RATE) {
        aegis128x2_absorb_packed(ad + i, st);
    }
    if (adlen % RATE) {
        memset(tmp, 0, RATE);
        memcpy(tmp, ad + i, adlen % RATE);
        aegis128x2_absorb_packed(tmp, st);
    }
}

static int
aegis128x2_encrypt_detached(uint8_t *c, uint8_t *mac, size_t maclen, const uint8_t *m, size_t mlen,
                            const uint8_t *ad, size_t adlen, const uint8_t *npub, const uint8_t *k)
{
    AesBlocks                       state;
    CRYPTO_ALIGN(ALIGNMENT) uint8_t src[RATE];
    CRYPTO_ALIGN(ALIGNMENT) uint8_t dst[RATE];
    size_t                          i;

    aegis128x2_init(k, npub, state);

    if (adlen > 0) {
        aegis128x2_absorb_ad(state, src, ad, adlen);
    }
    for (i = 0; i + RATE <= mlen; i += RATE) {
        aegis128x2_enc(c + i, m + i, state);
    }
    if (mlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, m + i, mlen % RATE);
        aegis128x2_enc(dst, src, state);
        memcpy(c + i, dst, mlen % RATE);
    }
    aegis128x2_mac(mac, maclen, adlen, mlen, state);

    return 0;
}

static int
aegis128x2_decrypt_detached(uint8_t *m, const uint8_t *c, size_t clen, const uint8_t *mac,
                            size_t maclen, const uint8_t *ad, size_t adlen, const uint8_t *npub,
                            const uint8_t *k)
{
    AesBlocks                       state;
    CRYPTO_ALIGN(ALIGNMENT) uint8_t src[RATE];
    CRYPTO_ALIGN(ALIGNMENT) uint8_t dst[RATE];
    CRYPTO_ALIGN(16) uint8_t        computed_mac[32];
    const size_t                    mlen = clen;
    size_t                          i;
    int                             ret;

    aegis128x2_init(k, npub, state);

    if (adlen > 0) {
        aegis128x2_absorb_ad(state, src, ad, adlen);
    }
    if (m != NULL) {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis128x2_dec(m + i, c + i, state);
        }
    } else {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis128x2_dec(dst, c + i, state);
        }
    }
    if (mlen % RATE) {
        if (m != NULL) {
            aegis128x2_declast(m + i, c + i, mlen % RATE, state);
        } else {
            aegis128x2_declast(dst, c + i, mlen % RATE, state);
        }
    }
    aegis128x2_mac(computed_mac, maclen, adlen, mlen, state);
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
    if (aegis128x2_encrypt_detached((uint8_t *) c, c + (size_t) mlen, CRYPTO_ABYTES,
                                    (const uint8_t *) m, (size_t) mlen, (const uint8_t *) ad,
                                    (size_t) adlen, (const uint8_t *) npub,
                                    (const uint8_t *) k) != 0) {
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
    if (aegis128x2_decrypt_detached((uint8_t *) m, (const uint8_t *) c,
                                    (size_t) clen - CRYPTO_ABYTES,
                                    (const uint8_t *) c + (size_t) clen - CRYPTO_ABYTES,
                                    CRYPTO_ABYTES, (const uint8_t *) ad, (size_t) adlen,
                                    (const uint8_t *) npub, (const uint8_t *) k) != 0) {
        return -1;
    }
    if (mlen != NULL) {
        *mlen = clen - CRYPTO_ABYTES;
    }
    return 0;
}
