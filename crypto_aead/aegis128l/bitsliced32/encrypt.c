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

#include "aes-bs8.h"

#define RATE      32
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
    memset(st, 0, sizeof(AesBlocks));

    st[word_idx(0, 0)] = m0[0];
    st[word_idx(0, 1)] = m0[1];
    st[word_idx(0, 2)] = m0[2];
    st[word_idx(0, 3)] = m0[3];

    st[word_idx(4, 0)] = m1[0];
    st[word_idx(4, 1)] = m1[1];
    st[word_idx(4, 2)] = m1[2];
    st[word_idx(4, 3)] = m1[3];

    pack04(st);
}

static void
aegis_unpack_state(AesBlocks unpacked, const AesBlocks packed)
{
    memcpy(unpacked, packed, sizeof(AesBlocks));
    unpack(unpacked);
}

static void
aegis128l_keystream_packed(AesBlock z0, AesBlock z1, const AesBlocks st)
{
    AesBlocks z;
    size_t    i;

    for (i = 0; i < 32; i++) {
        const uint32_t x = st[i];

        z[i] = ((x & 0x02020202) << 6) ^ ((x & 0x40404040) << 1) ^
               (((x & 0x20202020) << 2) & ((x & 0x10101010) << 3)) ^ ((x & 0x20202020) >> 2) ^
               ((x & 0x04040404) << 1) ^ (((x & 0x02020202) << 2) & ((x & 0x01010101) << 3));
    }
    unpack04(z);
    for (i = 0; i < 4; i++) {
        z0[i] = z[word_idx(0, i)];
        z1[i] = z[word_idx(4, i)];
    }
}

static void
aegis128l_init(const uint8_t *key, const uint8_t *nonce, AesBlocks st)
{
    const AesBlock c0 = { 0x02010100, 0x0d080503, 0x59372215, 0x6279e990 };
    const AesBlock c1 = { 0x55183ddb, 0xf12fc26d, 0x42311120, 0xdd28b573 };
    AesBlock       k, n, kn, kc0, kc1;
    int            i;

    block_from_bytes(k, key);
    block_from_bytes(n, nonce);
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
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, n, k);
        pack2(st);
        for (i = 0; i < 10; i++) {
            aegis_round_packed(st, constant_input);
        }
    }
}

static void
aegis128l_absorb_packed(const uint8_t *const src, AesBlocks st)
{
    AesBlocks constant_input;
    AesBlock  msg0, msg1;

    block_from_bytes(msg0, src);
    block_from_bytes(msg1, src + AES_BLOCK_LENGTH);
    aegis_pack_constant_input(constant_input, msg0, msg1);
    aegis_round_packed(st, constant_input);
}

static void
aegis128l_enc(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock t0, t1;
    AesBlock z0, z1;
    AesBlock out0, out1;

    aegis128l_keystream_packed(z0, z1, st);
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
aegis128l_dec(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock msg0, msg1;
    AesBlock z0, z1;

    block_from_bytes(msg0, src);
    block_from_bytes(msg1, src + AES_BLOCK_LENGTH);
    aegis128l_keystream_packed(z0, z1, st);
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
aegis128l_declast(uint8_t *const dst, const uint8_t *const src, size_t len, AesBlocks st)
{
    uint8_t  pad[RATE];
    AesBlock msg0, msg1;
    AesBlock z0, z1;

    memset(pad, 0, sizeof pad);
    memcpy(pad, src, len);

    block_from_bytes(msg0, pad);
    block_from_bytes(msg1, pad + AES_BLOCK_LENGTH);
    aegis128l_keystream_packed(z0, z1, st);
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
aegis128l_mac(uint8_t *mac, size_t maclen, size_t adlen, size_t mlen, AesBlocks st)
{
    AesBlocks unpacked;
    AesBlock  tmp;
    size_t    i;

    tmp[0] = (uint32_t) (adlen << 3);
    tmp[1] = (uint32_t) (adlen >> (32 - 3));
    tmp[2] = (uint32_t) (mlen << 3);
    tmp[3] = (uint32_t) (mlen >> (32 - 3));

    aegis_unpack_state(unpacked, st);
    tmp[0] ^= unpacked[word_idx(2, 0)];
    tmp[1] ^= unpacked[word_idx(2, 1)];
    tmp[2] ^= unpacked[word_idx(2, 2)];
    tmp[3] ^= unpacked[word_idx(2, 3)];

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
        block_to_bytes(mac, tmp);
    } else if (maclen == 32) {
        for (i = 0; i < 4; i++) {
            tmp[i] =
                st[word_idx(0, i)] ^ st[word_idx(1, i)] ^ st[word_idx(2, i)] ^ st[word_idx(3, i)];
        }
        block_to_bytes(mac, tmp);
        for (i = 0; i < 4; i++) {
            tmp[i] =
                st[word_idx(4, i)] ^ st[word_idx(5, i)] ^ st[word_idx(6, i)] ^ st[word_idx(7, i)];
        }
        block_to_bytes(mac + 16, tmp);
    } else {
        memset(mac, 0, maclen);
    }
}

static void
aegis128l_absorb_ad(AesBlocks st, uint8_t tmp[RATE], const uint8_t *ad, const size_t adlen)
{
    size_t i;

    for (i = 0; i + RATE <= adlen; i += RATE) {
        aegis128l_absorb_packed(ad + i, st);
    }
    if (adlen % RATE) {
        memset(tmp, 0, RATE);
        memcpy(tmp, ad + i, adlen % RATE);
        aegis128l_absorb_packed(tmp, st);
    }
}

static int
aegis128l_encrypt_detached(uint8_t *c, uint8_t *mac, size_t maclen, const uint8_t *m, size_t mlen,
                           const uint8_t *ad, size_t adlen, const uint8_t *npub, const uint8_t *k)
{
    AesBlocks                       state;
    CRYPTO_ALIGN(ALIGNMENT) uint8_t src[RATE];
    CRYPTO_ALIGN(ALIGNMENT) uint8_t dst[RATE];
    size_t                          i;

    aegis128l_init(k, npub, state);

    if (adlen > 0) {
        aegis128l_absorb_ad(state, src, ad, adlen);
    }
    for (i = 0; i + RATE <= mlen; i += RATE) {
        aegis128l_enc(c + i, m + i, state);
    }
    if (mlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, m + i, mlen % RATE);
        aegis128l_enc(dst, src, state);
        memcpy(c + i, dst, mlen % RATE);
    }
    aegis128l_mac(mac, maclen, adlen, mlen, state);

    return 0;
}

static int
aegis128l_decrypt_detached(uint8_t *m, const uint8_t *c, size_t clen, const uint8_t *mac,
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

    aegis128l_init(k, npub, state);

    if (adlen > 0) {
        aegis128l_absorb_ad(state, src, ad, adlen);
    }
    if (m != NULL) {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis128l_dec(m + i, c + i, state);
        }
    } else {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis128l_dec(dst, c + i, state);
        }
    }
    if (mlen % RATE) {
        if (m != NULL) {
            aegis128l_declast(m + i, c + i, mlen % RATE, state);
        } else {
            aegis128l_declast(dst, c + i, mlen % RATE, state);
        }
    }
    aegis128l_mac(computed_mac, maclen, adlen, mlen, state);
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
    if (aegis128l_encrypt_detached((uint8_t *) c, c + (size_t) mlen, CRYPTO_ABYTES,
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
    if (aegis128l_decrypt_detached((uint8_t *) m, (const uint8_t *) c,
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
