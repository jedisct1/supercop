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

#define RATE      32
#define ALIGNMENT 32

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
    size_t i;

    memset(st, 0, sizeof(AesBlocks));
    for (i = 0; i < 4; i++) {
        st[word_idx(0, i)] = m[i];
    }
    pack04_6(st);
}

static void
aegis_unpack_state(AesBlocks unpacked, const AesBlocks packed)
{
    memcpy(unpacked, packed, sizeof(AesBlocks));
    unpack2_6(unpacked);
}

static void
aegis256x2_keystream_packed(AesBlock z, const AesBlocks st)
{
    AesBlocks z_packed;
    size_t    i;

    for (i = 0; i < 32; i++) {
        const uint64_t x = st[i];

        z_packed[i] = ((x & 0x4040404040404040) << 1) ^ ((x & 0x0808080808080808) << 4) ^
                      ((x & 0x0404040404040404) << 5) ^
                      (((x & 0x2020202020202020) << 2) & ((x & 0x1010101010101010) << 3));
    }
    unpack04_6(z_packed);
    for (i = 0; i < 4; i++) {
        z[i] = z_packed[word_idx(0, i)];
    }
}

static void
aegis256x2_init(const uint8_t *key, const uint8_t *nonce, AesBlocks st)
{
    const AesBlock c0 = { 0x0201010002010100, 0x0d0805030d080503, 0x5937221559372215,
                          0x6279e9906279e990 };
    const AesBlock c1 = { 0x55183ddb55183ddb, 0xf12fc26df12fc26d, 0x4231112042311120,
                          0xdd28b573dd28b573 };
    AesBlock       k0, k1, n0, n1, k0n0, k1n1, k0c0, k1c1;
    int            i;

    block_from_broadcast(k0, key);
    block_from_broadcast(k1, key + 16);
    block_from_broadcast(n0, nonce);
    block_from_broadcast(n1, nonce + 16);
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
        const AesBlocks constant_ctx_mask = { 0x0, 0x0, 0x0, 0x0, 0x0,  0x0,          0x0, 0x0,
                                              0x0, 0x0, 0x0, 0x0, 0x0,  0x0,          0x0, 0x0,
                                              0x0, 0x0, 0x0, 0x0, 0x0,  0x0,          0x0, 0x0,
                                              0x0, 0x0, 0x0, 0x0, 0x14, 0x1400000014, 0x0, 0x0 };
        AesBlocks constant_input_k0, constant_input_k1, constant_input_k0n0, constant_input_k1n1;

        aegis_pack_constant_input(constant_input_k0, k0);
        aegis_pack_constant_input(constant_input_k1, k1);
        aegis_pack_constant_input(constant_input_k0n0, k0n0);
        aegis_pack_constant_input(constant_input_k1n1, k1n1);
        pack2_6(st);
        for (i = 0; i < 4; i++) {
            blocks_xor(st, constant_ctx_mask);
            aegis_round_packed(st, constant_input_k0);
            blocks_xor(st, constant_ctx_mask);
            aegis_round_packed(st, constant_input_k1);
            blocks_xor(st, constant_ctx_mask);
            aegis_round_packed(st, constant_input_k0n0);
            blocks_xor(st, constant_ctx_mask);
            aegis_round_packed(st, constant_input_k1n1);
        }
    }
}

static void
aegis256x2_absorb_packed(const uint8_t *const src, AesBlocks st)
{
    AesBlocks constant_input;
    AesBlock  msg;

    block_from_bytes(msg, src);
    aegis_pack_constant_input(constant_input, msg);
    aegis_round_packed(st, constant_input);
}

static void
aegis256x2_enc(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock t;
    AesBlock z;
    AesBlock out;

    aegis256x2_keystream_packed(z, st);
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
aegis256x2_dec(uint8_t *const dst, const uint8_t *const src, AesBlocks st)
{
    AesBlock msg;
    AesBlock z;

    block_from_bytes(msg, src);
    aegis256x2_keystream_packed(z, st);
    block_xor(msg, msg, z);
    {
        AesBlocks constant_input;

        aegis_pack_constant_input(constant_input, msg);
        aegis_round_packed(st, constant_input);
    }
    block_to_bytes(dst, msg);
}

static void
aegis256x2_declast(uint8_t *const dst, const uint8_t *const src, size_t len, AesBlocks st)
{
    uint8_t  pad[RATE];
    AesBlock msg;
    AesBlock z;

    memset(pad, 0, sizeof pad);
    memcpy(pad, src, len);

    block_from_bytes(msg, pad);
    aegis256x2_keystream_packed(z, st);
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
aegis256x2_mac(uint8_t *mac, size_t maclen, size_t adlen, size_t mlen, AesBlocks st)
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
        tmp[i] ^= unpacked[word_idx(3, i)];
    }

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
        fold_base_block_to_bytes(mac, tmp);
    } else if (maclen == 32) {
        for (i = 0; i < 4; i++) {
            tmp[i] = st[word_idx(0, i)] ^ st[word_idx(1, i)] ^ st[word_idx(2, i)];
        }
        fold_base_block_to_bytes(mac, tmp);

        for (i = 0; i < 4; i++) {
            tmp[i] = st[word_idx(3, i)] ^ st[word_idx(4, i)] ^ st[word_idx(5, i)];
        }
        fold_base_block_to_bytes(mac + 16, tmp);
    } else {
        memset(mac, 0, maclen);
    }
}

static void
aegis256x2_absorb_ad(AesBlocks st, uint8_t tmp[RATE], const uint8_t *ad, const size_t adlen)
{
    size_t i;

    for (i = 0; i + RATE <= adlen; i += RATE) {
        aegis256x2_absorb_packed(ad + i, st);
    }
    if (adlen % RATE) {
        memset(tmp, 0, RATE);
        memcpy(tmp, ad + i, adlen % RATE);
        aegis256x2_absorb_packed(tmp, st);
    }
}

static int
aegis256x2_encrypt_detached(uint8_t *c, uint8_t *mac, size_t maclen, const uint8_t *m, size_t mlen,
                            const uint8_t *ad, size_t adlen, const uint8_t *npub, const uint8_t *k)
{
    AesBlocks                       state;
    CRYPTO_ALIGN(ALIGNMENT) uint8_t src[RATE];
    CRYPTO_ALIGN(ALIGNMENT) uint8_t dst[RATE];
    size_t                          i;

    aegis256x2_init(k, npub, state);

    if (adlen > 0) {
        aegis256x2_absorb_ad(state, src, ad, adlen);
    }
    for (i = 0; i + RATE <= mlen; i += RATE) {
        aegis256x2_enc(c + i, m + i, state);
    }
    if (mlen % RATE) {
        memset(src, 0, RATE);
        memcpy(src, m + i, mlen % RATE);
        aegis256x2_enc(dst, src, state);
        memcpy(c + i, dst, mlen % RATE);
    }
    aegis256x2_mac(mac, maclen, adlen, mlen, state);

    return 0;
}

static int
aegis256x2_decrypt_detached(uint8_t *m, const uint8_t *c, size_t clen, const uint8_t *mac,
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

    aegis256x2_init(k, npub, state);

    if (adlen > 0) {
        aegis256x2_absorb_ad(state, src, ad, adlen);
    }
    if (m != NULL) {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis256x2_dec(m + i, c + i, state);
        }
    } else {
        for (i = 0; i + RATE <= mlen; i += RATE) {
            aegis256x2_dec(dst, c + i, state);
        }
    }
    if (mlen % RATE) {
        if (m != NULL) {
            aegis256x2_declast(m + i, c + i, mlen % RATE, state);
        } else {
            aegis256x2_declast(dst, c + i, mlen % RATE, state);
        }
    }
    aegis256x2_mac(computed_mac, maclen, adlen, mlen, state);
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
    if (aegis256x2_encrypt_detached((uint8_t *) c, c + (size_t) mlen, CRYPTO_ABYTES,
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
    if (aegis256x2_decrypt_detached((uint8_t *) m, (const uint8_t *) c,
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
