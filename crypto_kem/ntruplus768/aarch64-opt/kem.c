#include "namespace.h"
#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "symmetric.h"

#include "poly.h"
#include "randombytes.h"
#include "decap.h"
#include "keygen.h"
#include "encap.h"
#include "util.h"

typedef gt_cq_poly keygen_poly;

#include "fips202.h"

static inline void encap_basemul_add_tobytes(uint8_t *ct, const poly *h,
                                             const poly *r, poly *m)
{
    /*
     * The encap-only assembly contract loads each 64-byte m block before
     * overwriting that same output block.  Reuse m as the ciphertext
     * polynomial to avoid a separate 1,536-byte stack object and clear.
     */
    poly_basemul_add_encap(m, h, r, m);
    poly_tobytes_encap(ct, m);
}

static inline void keygen_ntt_mul3_add1(keygen_poly *out)
{
    poly_triple(&out->storage, &out->storage);
    out->storage.coeffs[0] += 1;
    poly_ntt_keygen_cq(out, &out->storage);
}

static inline void keygen_ntt_mul3(keygen_poly *out)
{
    poly_triple(&out->storage, &out->storage);
    poly_ntt_keygen_cq(out, &out->storage);
}

/*************************************************
* Name:        verify
*
* Description: Compares two byte arrays for equality in constant time.
*
* Arguments:   - const uint8_t *a: first byte array
*              - const uint8_t *b: second byte array
*              - size_t len:      length of the arrays
*
* Returns 0 if the arrays are equal, 1 otherwise.
**************************************************/
static inline int verify(const uint8_t *a, const uint8_t *b, size_t len)
{
    uint8_t acc = 0;

    for (size_t i = 0; i < len; i++)
        acc |= (uint8_t)(a[i] ^ b[i]);

    return (-(uint64_t)acc) >> 63;
}

/*************************************************
* Name:        genf_from_seed
*
* Description: Deterministically generates a secret polynomial f and its
*              multiplicative inverse finv in the NTT domain.
*
* Arguments:   - keygen_poly *f:    output polynomial f (NTT domain, CQ)
*              - keygen_poly *finv: output multiplicative inverse of f
*                              in the NTT domain
*              - uint8_t *buf:         NTRUPLUS_N/4-byte CBD sample buffer
*
* Returns 0 on success; non-zero if f is not invertible in the NTT domain.
**************************************************/
static inline int genf_from_seed(keygen_poly *f,
                                 keygen_poly *finv,
                                 const uint8_t buf[NTRUPLUS_N / 4])
{
    int result;

    poly_cbd1(&f->storage, buf);
    keygen_ntt_mul3_add1(f);

    result = poly_baseinv_keygen_cq_scaled_r(finv, f);
    return result;
}

/*************************************************
* Name:        geng_from_seed
*
* Description: Deterministically generates a secret polynomial g and its
*              multiplicative inverse ginv in the NTT domain.
*
* Arguments:   - keygen_poly *g:    output polynomial g (NTT domain, CQ)
*              - keygen_poly *ginv: output multiplicative inverse of g
*                               in the NTT domain
*              - uint8_t *buf:         NTRUPLUS_N/4-byte CBD sample buffer
*
* Returns 0 on success; non-zero if g is not invertible in the NTT domain.
**************************************************/
static inline int geng_from_seed(keygen_poly *g,
                                 keygen_poly *ginv,
                                 const uint8_t buf[NTRUPLUS_N / 4])
{
    int result;

    poly_cbd1(&g->storage, buf);
    keygen_ntt_mul3(g);

    result = poly_baseinv_keygen_cq_scaled_r(ginv, g);
    return result;
}

/*************************************************
* Name:        crypto_kem_keypair_derand
*
* Description: Computes the deterministic public and secret key pair from
*              the secret polynomials f and g and their multiplicative
*              inverses finv and ginv in the NTT domain.
*
* Arguments:   - uint8_t *pk:   output public key
*              - uint8_t *sk:   output secret key
*              - const poly *f:     secret polynomial f (NTT domain)
*              - const poly *finv:  multiplicative inverse of f (NTT domain)
*              - const poly *g:     secret polynomial g (NTT domain)
*              - const poly *ginv:  multiplicative inverse of g (NTT domain)
*
* Returns:     void
**************************************************/
static inline void crypto_kem_keypair_derand(uint8_t *pk, uint8_t *sk,
                                             const keygen_poly *f,
                                             const keygen_poly *finv,
                                             const keygen_poly *g,
                                             const keygen_poly *ginv)
{
    keygen_poly h;

    poly_basemul_keygen_cq_scaled_r(&h, g, finv);

    poly_tobytes_keygen_cq(pk, &h);
    poly_tobytes_keygen_cq(sk, f);
    poly_basemul_keygen_cq_scaled_r(&h, f, ginv);
    poly_tobytes_keygen_cq(sk + NTRUPLUS_POLYBYTES, &h);
    hash_f(sk + 2 * NTRUPLUS_POLYBYTES, pk);
    secure_clear(&h, sizeof h);

}

/*************************************************
* Name:        crypto_kem_keypair_internal
*
* Description: Generates an NTRU+ public/secret key pair for the
*              CCA-secure key encapsulation mechanism. Secret
*              polynomials f and g and their NTT-domain inverses
*              are sampled internally using fresh randomness.
*
* Arguments:   - uint8_t *pk: output public key
*                (array of CRYPTO_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: output secret key
*                (array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 on success.
**************************************************/
int crypto_kem_keypair_internal(uint8_t *pk, uint8_t *sk)
{
    /*
     * Coins are drawn and consumed in stream order, exactly as one draw per f
     * attempt and then one per g attempt: while f is being tried, the next
     * draw is certain to be used (by an f retry or by g), so it is drawn up
     * front and both seeds are expanded in one two-state SHAKE256.
     * randombytes sees the same calls in the same order.
     */
    uint8_t coins[2][NTRUPLUS_SYMBYTES];
    uint8_t buf[2][NTRUPLUS_N / 4];
    unsigned cur = 0;

    keygen_poly f, g;
    keygen_poly finv, ginv;

    randombytes(coins[0], sizeof coins[0]);
    randombytes(coins[1], sizeof coins[1]);
    shake256_x2(buf[0], buf[1], NTRUPLUS_N / 4, coins[0], coins[1], 32);

    while (genf_from_seed(&f, &finv, buf[cur])) {
        cur ^= 1;
        randombytes(coins[cur ^ 1], sizeof coins[0]);
        shake256(buf[cur ^ 1], NTRUPLUS_N / 4, coins[cur ^ 1], 32);
    }
    cur ^= 1;
    while (geng_from_seed(&g, &ginv, buf[cur])) {
        randombytes(coins[cur], sizeof coins[0]);
        shake256(buf[cur], NTRUPLUS_N / 4, coins[cur], 32);
    }

    crypto_kem_keypair_derand(pk, sk, &f, &finv, &g, &ginv);
    secure_clear(buf, sizeof buf);
    secure_clear(coins, sizeof coins);
    secure_clear(&f, sizeof f);
    secure_clear(&g, sizeof g);
    secure_clear(&finv, sizeof finv);
    secure_clear(&ginv, sizeof ginv);
    return 0;
}

/*************************************************
* Name:        crypto_kem_enc_derand
*
* Description: Deterministically performs NTRU+ KEM encapsulation using
*              the public key pk and the supplied randomness coins,
*              producing a ciphertext ct and shared secret ss.
*
* Arguments:   - uint8_t *ct:      output ciphertext
*              - uint8_t *ss:      output shared secret
*              - const uint8_t *pk:    input public key
*              - const uint8_t *coins: input randomness for
*                                      deterministic encapsulation
*
* Returns 0 on success.
**************************************************/
static inline int crypto_kem_enc_derand(uint8_t *ct, uint8_t *ss,
                                        const uint8_t *pk,
                                        const uint8_t *coins)
{
    uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES];
    uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N / 4];

    poly h, r, m;

    if (poly_frombytes_encap(&h, pk)) {
        for (size_t i = 0; i < NTRUPLUS_CIPHERTEXTBYTES; i++) ct[i] = 0;
        secure_clear(ss, NTRUPLUS_SSBYTES);

        return 1;
    }

    for (size_t i = 0; i < NTRUPLUS_N / 8; i++)
        msg[i] = coins[i];

    hash_f(msg + NTRUPLUS_N / 8, pk);
    hash_h(buf1, msg);

    poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES);
    poly_ntt_encap_small_lazy(&r, &r);

    poly_tobytes_encap_loose(ct, &r);
    hash_g(ct, ct);
    poly_sotp_encode(&m, msg, ct);
    poly_ntt_encap_small_lazy(&m, &m);

    encap_basemul_add_tobytes(ct, &h, &r, &m);

    for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
        ss[i] = buf1[i];

    secure_clear(msg, sizeof msg);
    secure_clear(buf1, sizeof buf1);

    secure_clear(&r, sizeof r);
    secure_clear(&m, sizeof m);
    return 0;
}

/*************************************************
* Name:        crypto_kem_enc_internal
*
* Description: Generates an NTRU+ KEM ciphertext ct and shared secret ss
*              using the public key pk. Fresh randomness is internally
*              sampled and used for encapsulation.
*
* Arguments:   - uint8_t *ct: output ciphertext
*                (array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - uint8_t *ss: output shared secret
*                (array of CRYPTO_BYTES bytes)
*              - const uint8_t *pk: input public key
*                (array of CRYPTO_PUBLICKEYBYTES bytes)
*
* Returns 0 on success.
**************************************************/
int crypto_kem_enc_internal(uint8_t *ct, uint8_t *ss, const uint8_t *pk)
{
    uint8_t coins[NTRUPLUS_N / 8];
    int result;

    randombytes(coins, sizeof coins);
    result = crypto_kem_enc_derand(ct, ss, pk, coins);
    secure_clear(coins, sizeof coins);
    return result;
}

/*************************************************
* Name:        crypto_kem_dec_internal
*
* Description: Performs NTRU+ KEM decapsulation. Given a ciphertext ct
*              and a secret key sk, computes the shared secret ss. If
*              decapsulation fails, ss is set to all zero bytes.
*
* Arguments:   - uint8_t *ss:  output shared secret
*                (array of CRYPTO_BYTES bytes)
*              - const uint8_t *ct: input ciphertext
*                (array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - const uint8_t *sk: input secret key
*                (array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 on success, 1 on failure.
**************************************************/
int crypto_kem_dec_internal(uint8_t *ss, const uint8_t *ct,
                            const uint8_t *sk)
{
    struct {
        uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES];
        /* The inverse's working area is dead before buf1/buf2 are first
         * written, and is cleared with the rest of scratch. */
        union {
            struct {
                uint8_t buf1[NTRUPLUS_POLYBYTES];
                uint8_t buf2[NTRUPLUS_POLYBYTES];
            } b;
            uint8_t invntt[POLY_INVNTT_TERNARY_DECAP_SCRATCHBYTES];
        } io __attribute__((aligned(16)));
        poly c;
        poly hinv;
        union {
            poly forward;
            uint8_t buf3[NTRUPLUS_N / 4 + NTRUPLUS_SYMBYTES];
        } slot;
        poly m_then_r;
    } scratch;
    poly *forward = &scratch.slot.forward;
    poly *m_r = &scratch.m_then_r;
    int8_t fail;

    /*
     * Decode and validate ct/f in one 64-coefficient/two-group pipeline.
     * ct is retained in Decap QSoA layout; packed f is consumed directly
     * and is never materialized in the scratch object.
     */
    fail = (int8_t)poly_frombytes_basemul_decap_scale(
        m_r, &scratch.c, ct, sk);
    fail |= (int8_t)poly_frombytes_decap(
        &scratch.hinv, sk + NTRUPLUS_POLYBYTES);
    /* Whether ct, f and hinv decoded canonically is public (Official
     * declassifies the same decode results before branching). */
    ntruplus_declassify(&fail, sizeof fail);
    if (fail) {
        secure_clear(ss, NTRUPLUS_SSBYTES);
        goto cleanup;
    }

    poly_invntt_ternary_decap(m_r, scratch.io.invntt);

    poly_ntt_decap(forward, m_r);
    poly_sub(&scratch.c, &scratch.c, forward);
    poly_basemul_decap(
        forward, &scratch.c, &scratch.hinv);
    poly_tobytes_decap(scratch.io.b.buf1, forward);

    hash_g(scratch.io.b.buf2, scratch.io.b.buf1);
    fail = (int8_t)poly_sotp_decode(scratch.msg, m_r, scratch.io.b.buf2);

    for (size_t i = 0; i < NTRUPLUS_SYMBYTES; i++)
        scratch.msg[i + NTRUPLUS_N / 8] =
            sk[i + 2 * NTRUPLUS_POLYBYTES];

    hash_h(scratch.slot.buf3, scratch.msg);

    poly_cbd1(m_r, scratch.slot.buf3 + NTRUPLUS_SSBYTES);
    poly_ntt_decap(&scratch.c, m_r);
    poly_tobytes_decap(scratch.io.b.buf2, &scratch.c);

    fail |= verify(scratch.io.b.buf1, scratch.io.b.buf2, NTRUPLUS_POLYBYTES);

    for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
        ss[i] = scratch.slot.buf3[i] & ~(-fail);

cleanup:
    secure_clear(&scratch, sizeof scratch);
    return fail;
}
