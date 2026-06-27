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

#define RATE      16
#define ALIGNMENT 16

static void
aegis_round_packed(AesBlocks st, const AesBlocks constant_input)
{
    AesBlocks st1;

    memcpy(st1, st, sizeof(AesBlocks));
    aes_round(st1);
    blocks_rotr6(st1);
    blocks_xor(st, st1);
    blocks_xor(st, constant_input);
}

static void
aegis_pack_constant_input(AesBlocks st, const AesBlock m)
{
    memset(st, 0, sizeof(AesBlocks));

    st[word_idx(0, 0)] = m[0];
    st[word_idx(0, 1)] = m[1];
    st[word_idx(0, 2)] = m[2];
    st[word_idx(0, 3)] = m[3];

    pack04_6(st);
}

static void
aegis_unpack_state(AesBlocks unpacked, const AesBlocks packed)
{
    memcpy(unpacked, packed, sizeof(AesBlocks));
    unpack2_6(unpacked);
}

static void
aegis256_keystream_packed(AesBlock z, const AesBlocks st)
{
    AesBlocks z_packed;
    size_t    i;

    for (i = 0; i < 32; i++) {
        const uint32_t x = st[i];

        z_packed[i] = ((x & 0x40404040) << 1) ^ ((x & 0x08080808) << 4) ^ ((x & 0x04040404) << 5) ^
                      (((x & 0x20202020) << 2) & ((x & 0x10101010) << 3));
    }
    unpack04_6(z_packed);
    for (i = 0; i < 4; i++) {
        z[i] = z_packed[word_idx(0, i)];
    }
}

static void
aegis256_init(const uint8_t *key, const uint8_t *nonce, AesBlocks st)
{
    const AesBlock c0 = { 0x02010100, 0x0d080503, 0x59372215, 0x6279e990 };
    const AesBlock c1 = { 0x55183ddb, 0xf12fc26d, 0x42311120, 0xdd28b573 };
    AesBlock       k0, k1, n0, n1, k0n0, k1n1, k0c0, k1c1;
    int            i;

    block_from_bytes(k0, key);
    block_from_bytes(k1, key + 16);
    block_from_bytes(n0, nonce);
    block_from_bytes(n1, nonce + 16);
    block_xor(k0n0, k0, n0);
    block_xor(k1n1, k1, n1);
    block_xor(k0c0, k0, c0);
    block_xor(k1c1, k1, c1);

    memset(st, 0, sizeof(AesBlocks));
    blocks_put(st, k0n0, 0);
    blocks_put(st, k1n1, 1);
    blocks_put(st, c1, 2);
    blocks_put(st, c0, 3);
    blocks_put(st, k0c0, 4);
    blocks_put(st, k1c1, 5);

    {
        AesBlocks constant_input_k0, constant_input_k1, constant_input_k0n0, constant_input_k1n1;

        aegis_pack_constant_input(constant_input_k0, k0);
        aegis_pack_constant_input(constant_input_k1, k1);
        aegis_pack_constant_input(constant_input_k0n0, k0n0);
        aegis_pack_constant_input(constant_input_k1n1, k1n1);
        pack2_6(st);
        for (i = 0; i < 4; i++) {
            aegis_round_packed(st, constant_input_k0);
            aegis_round_packed(st, constant_input_k1);
            aegis_round_packed(st, constant_input_k0n0);
            aegis_round_packed(st, constant_input_k1n1);
        }
    }
}

static void
aegis256_absorb_packed(const uint8_t *const src, AesBlocks st)
{
    AesBlocks constant_input;
    AesBlock  msg;

    block_from_bytes(msg, src);
    aegis_pack_constant_input(constant_input, msg);
    aegis_round_packed(st, constant_input);
}

static void
aegis256_enc(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock t, z;
    AesBlock out;

    aegis256_keystream_packed(z, st);
    block_from_bytes(t, src);
    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, t);
        aegis_round_packed(st, constant_input);
    }
    block_xor(out, t, z);
    block_to_bytes(dst, out);
}

static void
aegis256_dec(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock msg;
    AesBlock z;

    block_from_bytes(msg, src);
    aegis256_keystream_packed(z, st);
    block_xor(msg, msg, z);
    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, msg);
        aegis_round_packed(st, constant_input);
    }
    block_to_bytes(dst, msg);
}

static void
aegis256_declast(uint8_t *const dst, const uint8_t *const src, size_t len, AesBlocks st)
{
    uint8_t  pad[RATE];
    AesBlock msg;
    AesBlock z;

    memset(pad, 0, sizeof pad);
    memcpy(pad, src, len);

    block_from_bytes(msg, pad);
    aegis256_keystream_packed(z, st);
    block_xor(msg, msg, z);
    block_to_bytes(pad, msg);
    memset(pad + len, 0, sizeof pad - len);
    memcpy(dst, pad, len);
    block_from_bytes(msg, pad);
    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, msg);
        aegis_round_packed(st, constant_input);
    }
}

static void
aegis256_mac(uint8_t *mac, size_t maclen, size_t adlen, size_t mlen, AesBlocks st)
{
    AesBlocks unpacked;
    AesBlock  tmp;
    size_t    i;

    tmp[0] = (uint32_t) (adlen << 3);
    tmp[1] = (uint32_t) (adlen >> (32 - 3));
    tmp[2] = (uint32_t) (mlen << 3);
    tmp[3] = (uint32_t) (mlen >> (32 - 3));

    aegis_unpack_state(unpacked, st);
    tmp[0] ^= unpacked[word_idx(3, 0)];
    tmp[1] ^= unpacked[word_idx(3, 1)];
    tmp[2] ^= unpacked[word_idx(3, 2)];
    tmp[3] ^= unpacked[word_idx(3, 3)];

    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, tmp);
        for (i = 0; i < 7; i++) {
            aegis_round_packed(st, constant_input);
        }
        unpack2_6(st);
    }

    if (maclen == 16) {
        for (i = 0; i < 4; i++) {
            tmp[i] = st[word_idx(0, i)] ^ st[word_idx(1, i)] ^ st[word_idx(2, i)] ^
                     st[word_idx(3, i)] ^ st[word_idx(4, i)] ^ st[word_idx(5, i)];
        }
        block_to_bytes(mac, tmp);
    } else if (maclen == 32) {
        for (i = 0; i < 4; i++) {
            tmp[i] = st[word_idx(0, i)] ^ st[word_idx(1, i)] ^ st[word_idx(2, i)];
        }
        block_to_bytes(mac, tmp);
        for (i = 0; i < 4; i++) {
            tmp[i] = st[word_idx(3, i)] ^ st[word_idx(4, i)] ^ st[word_idx(5, i)];
        }
        block_to_bytes(mac + 16, tmp);
    } else {
        memset(mac, 0, maclen);
    }
}

static int
aegis256_encrypt_detached(uint8_t *c, uint8_t *mac, size_t maclen, const uint8_t *m, size_t mlen,
                          const uint8_t *ad, size_t adlen, const uint8_t *npub, const uint8_t *k)
{
    AesBlocks                       state;
    CRYPTO_ALIGN(ALIGNMENT) uint8_t src[RATE];
    CRYPTO_ALIGN(ALIGNMENT) uint8_t dst[RATE];
    size_t                          i;

    aegis256_init(k, npub, state);

    for (i = 0; i + RATE <= adlen; i += RATE) {
        aegis256_absorb_packed(ad + i, state);
    }
    if (adlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, ad + i, adlen % RATE);
        aegis256_absorb_packed(src, state);
    }
    for (i = 0; i + RATE <= mlen; i += RATE) {
        aegis256_enc(c + i, m + i, state);
    }
    if (mlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, m + i, mlen % RATE);
        aegis256_enc(dst, src, state);
        memcpy(c + i, dst, mlen % RATE);
    }
    aegis256_mac(mac, maclen, adlen, mlen, state);

    return 0;
}

static int
aegis256_decrypt_detached(uint8_t *m, const uint8_t *c, size_t clen, const uint8_t *mac,
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

    aegis256_init(k, npub, state);

    for (i = 0; i + RATE <= adlen; i += RATE) {
        aegis256_absorb_packed(ad + i, state);
    }
    if (adlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, ad + i, adlen % RATE);
        aegis256_absorb_packed(src, state);
    }
    if (m != NULL) {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis256_dec(m + i, c + i, state);
        }
    } else {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis256_dec(dst, c + i, state);
        }
    }
    if (mlen % RATE) {
        if (m != NULL) {
            aegis256_declast(m + i, c + i, mlen % RATE, state);
        } else {
            aegis256_declast(dst, c + i, mlen % RATE, state);
        }
    }
    aegis256_mac(computed_mac, maclen, adlen, mlen, state);
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
    if (aegis256_encrypt_detached((uint8_t *) c, c + (size_t) mlen, CRYPTO_ABYTES,
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
    if (aegis256_decrypt_detached((uint8_t *) m, (const uint8_t *) c,
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
