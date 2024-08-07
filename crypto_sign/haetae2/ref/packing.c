// 20240806 djb: some automated conversion to cryptoint
#include "packing.h"
#include "encoding.h"
#include "params.h"
#include "poly.h"
#include "polymat.h"
#include "polyvec.h"
#include "crypto_int8.h"
#include <string.h>

/*************************************************
 * Name:        pack_pk
 *
 * Description: Bit-pack public key pk = (seed, b).
 *
 * Arguments:   - uint8_t pk[]: output byte array
 *              - const polyveck *b: polynomial vector of length K containg b
 *              - const uint8_t seed[]: seed for A'
 **************************************************/
void pack_pk(uint8_t pk[crypto_PUBLICKEYBYTES], polyveck *b,
             const uint8_t seed[SEEDBYTES]) {
    unsigned int i;

    memcpy(pk, seed, SEEDBYTES);

    pk += SEEDBYTES;
    for (i = 0; i < K; ++i) {
        polyq_pack(pk + i * POLYQ_PACKEDBYTES, &b->vec[i]);
    }
}

/*************************************************
 * Name:        unpack_pk
 *
 * Description: Unpack public key pk = (seed, b).
 *
 * Arguments:   - uint8_t seed[]: seed for A'
 *              - polyveck *b: polynomial vector of length K containg b
 *              - const uint8_t pk[]: output byte array
 **************************************************/
void unpack_pk(polyveck *b, uint8_t seed[SEEDBYTES],
               const uint8_t pk[crypto_PUBLICKEYBYTES]) {
    unsigned int i;

    memcpy(seed, pk, SEEDBYTES);

    pk += SEEDBYTES;
    for (i = 0; i < K; ++i) {
        polyq_unpack(&b->vec[i], pk + i * POLYQ_PACKEDBYTES);
    }
}

/*************************************************
 * Name:        pack_sk
 *
 * Description: Bit-pack secret key sk = (pk, s).
 *
 * Arguments:   - uint8_t sk[]: output byte array
 *              - const uint8_t pk[PUBLICKEYBYTES]: packed pk
 *              - const polyvecl *s0: polyvecl pointer containing s0 (encoding
 *starting at offset 1)
 *              - const polyveck *s1: polyveck pointer containing s1
 **************************************************/
void pack_sk(uint8_t sk[crypto_SECRETKEYBYTES],
             const uint8_t pk[crypto_PUBLICKEYBYTES], const polyvecm *s0,
             const polyveck *s1, const uint8_t key[SEEDBYTES]) {
    unsigned int i;
    memcpy(sk, pk, crypto_PUBLICKEYBYTES);

    sk += crypto_PUBLICKEYBYTES;
    for (i = 0; i < M; ++i)
        polyeta_pack(sk + i * POLYETA_PACKEDBYTES, &s0->vec[i]);

    sk += (L - 1) * POLYETA_PACKEDBYTES;
#if D == 1
    for (i = 0; i < K; ++i)
        poly2eta_pack(sk + i * POLY2ETA_PACKEDBYTES, &s1->vec[i]);
    sk += K * POLY2ETA_PACKEDBYTES;
#elif D == 0
    for (i = 0; i < K; ++i)
        polyeta_pack(sk + i * POLYETA_PACKEDBYTES, &s1->vec[i]);
    sk += K * POLYETA_PACKEDBYTES;
#else
#error "Not yet implemented."
#endif
    memcpy(sk, key, SEEDBYTES);
}

/*************************************************
 * Name:        unpack_sk
 *
 * Description: Unpack secret key sk = (A, s).
 *
 * Arguments:   - polyvecl A[K]: output polyvecl array for A
 *              - polyvecl s0: output polyvecl pointer for s0
 *              - polyveck s1: output polyveck pointer for s1
 *              - const uint8_t sk[]: byte array containing bit-packed sk
 **************************************************/
void unpack_sk(polyvecl A[K], polyvecm *s0, polyveck *s1, uint8_t *key,
               const uint8_t sk[crypto_SECRETKEYBYTES]) {
    unsigned int i;
    uint8_t rhoprime[SEEDBYTES];
    polyveck b1;
#if D > 0
    polyveck a;
#endif

    unpack_pk(&b1, rhoprime, sk);

    sk += crypto_PUBLICKEYBYTES;
    for (i = 0; i < M; ++i)
        polyeta_unpack(&s0->vec[i], sk + i * POLYETA_PACKEDBYTES);

    sk += M * POLYETA_PACKEDBYTES;
#if D == 1
    for (i = 0; i < K; ++i)
        poly2eta_unpack(&s1->vec[i], sk + i * POLY2ETA_PACKEDBYTES);

    sk += K * POLY2ETA_PACKEDBYTES;
#elif D == 0
    for (i = 0; i < K; ++i)
        polyeta_unpack(&s1->vec[i], sk + i * POLYETA_PACKEDBYTES);

    sk += K * POLYETA_PACKEDBYTES;
#else
#error "Not yet implemented."
#endif
    memcpy(key, sk, SEEDBYTES);

    // A' = PRG(rhoprime)
    polymatkl_expand(A, rhoprime);
    polymatkl_double(A);
#if D > 0
    polyveck_expand(&a, rhoprime);
#endif

#if D == 1
    // first column of A = 2(a-b1*2^d)
    polyveck_double(&b1);
    polyveck_sub(&b1, &a, &b1);
    polyveck_double(&b1);
    polyveck_ntt(&b1);
#elif D == 0
#else
#error "Not yet implemented."
#endif
    // append b into A
    for (i = 0; i < K; ++i) {
        A[i].vec[0] = b1.vec[i];
    }
}

/*************************************************
 * Name:        pack_sig
 *
 * Description: Bit-pack signature sig = (c, LB(z1), len(x), len(y), x =
 *Enc(HB(z1)), y = Enc(h)), Zeropadding.
 *
 * Arguments:   - uint8_t sig[]: output byte array
 *              - const poly *c: pointer to challenge polynomial
 *              - const polyvecl *lowbits_z1: pointer to vector LowBits(z1) of
 *length L
 *              - const polyvecl *highbits_z1: pointer to vector HighBits(z1) of
 *length L
 *              - const polyveck *h: pointer t vector h of length K
 * Returns 1 in case the signature packing failed; otherwise 0.
 **************************************************/
int pack_sig(uint8_t sig[crypto_BYTES], const poly *c,
             const polyvecl *lowbits_z1, const polyvecl *highbits_z1,
             const polyveck *h) {

    uint8_t encoded_h[N * K];
    uint8_t encoded_hb_z1[N * L];
    uint16_t size_enc_h, size_enc_hb_z1;
    uint8_t offset_enc_h, offset_enc_hb_z1;

    // init/padding with zeros:
    memset(sig, 0, crypto_BYTES);
    
    // encode challenge
    for (size_t i = 0; i < N; i++)
    {
      sig[i/8] |= c->coeffs[i] << (i%8);
    }
    sig += N / 8;

    for (int i = 0; i < L; ++i)
        poly_decomposed_pack(sig + N * i, &lowbits_z1->vec[i]);
    sig += L * N;

    size_enc_hb_z1 =
        encode_hb_z1(encoded_hb_z1, &highbits_z1->vec[0].coeffs[0]);
    size_enc_h = encode_h(encoded_h, &h->vec[0].coeffs[0]);

    if (size_enc_h == 0 || size_enc_hb_z1 == 0) {
        return 1; // encoding failed
    }

    // The size of the encoded h and HB(z1) does not always fit in one byte,
    // thus we output a one byte offset to a fixed baseline
    if (size_enc_h < BASE_ENC_H || size_enc_hb_z1 < BASE_ENC_HB_Z1 ||
        size_enc_h > BASE_ENC_H + 255 ||
        size_enc_hb_z1 > BASE_ENC_HB_Z1 + 255) {
        return 1; // encoding size offset out of range
    }

    offset_enc_hb_z1 = size_enc_hb_z1 - BASE_ENC_HB_Z1;
    offset_enc_h = size_enc_h - BASE_ENC_H;

    if (SEEDBYTES + L * N + 2 + size_enc_hb_z1 + size_enc_h > crypto_BYTES) {
        return 1; // signature too big
    }

    sig[0] = offset_enc_hb_z1;
    sig[1] = offset_enc_h;
    sig += 2;

    memcpy(sig, encoded_hb_z1, size_enc_hb_z1);
    sig += size_enc_hb_z1;

    memcpy(sig, encoded_h, size_enc_h);
    sig += size_enc_h;

    return 0;
}

/*************************************************
 * Name:        unpack_sig
 *
 * Description: Unpack signature sig = (c, LB(z1), len(x), len(y), x =
 *Enc(HB(z1)), y = Enc(h)), Zeropadding.
 *
 * Arguments:   - poly *c: pointer to challenge polynomial
 *              - polyvecl *lowbits_z1: pointer to output vector LowBits(z1)
 *              - polyvecl *highbits_z1: pointer to output vector HighBits(z1)
 *              - polyveck *h: pointer to output vector h
 *              - const uint8_t sig[]: byte array containing
 *                bit-packed signature
 *
 * Returns 1 in case of malformed signature; otherwise 0.
 **************************************************/
int unpack_sig(poly *c, polyvecl *lowbits_z1,
               polyvecl *highbits_z1, polyveck *h,
               const uint8_t sig[crypto_BYTES]) {

    unsigned int i;
    uint16_t size_enc_hb_z1, size_enc_h;

    for (i = 0; i < N; i++)
    {
      c->coeffs[i] = crypto_int8_bitmod_01(sig[i/8],i);
    }
    sig += N / 8;

    for (i = 0; i < L; ++i)
        poly_decomposed_unpack(&lowbits_z1->vec[i], sig + N * i);
    sig += L * N;

    size_enc_hb_z1 = (uint16_t)sig[0] + BASE_ENC_HB_Z1;
    size_enc_h = (uint16_t)sig[1] + BASE_ENC_H;
    sig += 2;

    if (crypto_BYTES < (2 + L * N + SEEDBYTES + size_enc_h + size_enc_hb_z1))
        return 1; // invalid size_enc_h and/or size_enc_hb_z1

    if (decode_hb_z1(&highbits_z1->vec[0].coeffs[0], sig, size_enc_hb_z1)) {
        return 1; // decoding failed
    }

    sig += size_enc_hb_z1;

    if (decode_h(&h->vec[0].coeffs[0], sig, size_enc_h)) {
        return 1; // decoding failed
    }

    sig += size_enc_h;

    for (int i = 0; i < crypto_BYTES - (SEEDBYTES + L * N + 2 + size_enc_hb_z1 +
                                        size_enc_h);
         i++)
        if (sig[i] != 0)
            return 1; // verify zero padding

    return 0;
}
