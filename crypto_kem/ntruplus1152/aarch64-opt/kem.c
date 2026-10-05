#include "crypto_kem.h"
#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "pack.h"
#include "inverse.h"
#include "unpack.h"
#include "secure_clear.h"
#include "randombytes.h"

#include "fips202.h"

static int declassify_poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{
    int result = poly_frombytes(r, a);
    ntruplus_declassify(&result, sizeof result);
    return result;
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
* Arguments:   - poly *f:     output polynomial f (NTT domain)
*              - poly *finv:  output multiplicative inverse of f
*                              in the NTT domain
*              - const uint8_t *buf: NTRUPLUS_N/4-byte CBD sample buffer
*
* Returns 0 on success; non-zero if f is not invertible in the NTT domain.
**************************************************/
static inline int genf_from_seed(poly *f, poly *finv, const uint8_t buf[NTRUPLUS_N / 4])
{
    poly_cbd1(f, buf);
    poly_triple(f, f);
    f->coeffs[0] += 1;

    poly_ntt(f, f);

    return poly_baseinv(finv, f);
}

/*************************************************
* Name:        geng_from_seed
*
* Description: Deterministically generates a secret polynomial g and its
*              multiplicative inverse ginv in the NTT domain.
*
* Arguments:   - poly *g:      output polynomial g (NTT domain)
*              - poly *ginv:   output multiplicative inverse of g
*                               in the NTT domain
*              - const uint8_t *buf: NTRUPLUS_N/4-byte CBD sample buffer
*
* Returns 0 on success; non-zero if g is not invertible in the NTT domain.
**************************************************/
static inline int geng_from_seed(poly *g, poly *ginv, const uint8_t buf[NTRUPLUS_N / 4])
{
    poly_cbd1(g, buf);
    poly_triple(g, g);

    poly_ntt(g, g);

    return poly_baseinv(ginv, g);
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
                                             const poly *f,  const poly *finv,
                                             const poly *g,  const poly *ginv)
{
    poly h;

    poly_basemul(&h, g, finv);
    poly_tobytes_small(pk, &h);

    poly_basemul(&h, f, ginv);
    /* D1 outputs fit (-q,q); the direct Forward result f does not. */
    poly_tobytes(sk, f);
    poly_tobytes_small(sk + NTRUPLUS_POLYBYTES, &h);
    hash_f(sk + 2 * NTRUPLUS_POLYBYTES, pk);
    secure_clear(&h, sizeof h);
}

/*************************************************
* Name:        crypto_kem_keypair
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
int crypto_kem_keypair(uint8_t *pk, uint8_t *sk)
{
    /*
     * Coins are drawn and consumed in stream order, exactly as one draw per f
     * attempt and then one per g attempt: while f is being tried, the next
     * draw is certain to be used (by an f retry or by g), so it is drawn up
     * front and both seeds are expanded in one two-state SHAKE256.
     * randombytes sees the same calls in the same order.
     */
    uint8_t coins[2][NTRUPLUS_SYMBYTES];
    /* Fully overwritten by SHAKE, erased on exit. */
    uint8_t buf[2][NTRUPLUS_N / 4];
    unsigned cur = 0;
    int r;

    poly f, finv;
    poly g, ginv;

    randombytes(coins[0], sizeof coins[0]);
    randombytes(coins[1], sizeof coins[1]);
    shake256_x2(buf[0], buf[1], NTRUPLUS_N / 4, coins[0], coins[1], 32);

    for (;;) {
        r = genf_from_seed(&f, &finv, buf[cur]);
        ntruplus_declassify(&r, sizeof r);
        if (!r)
            break;
        cur ^= 1;
        randombytes(coins[cur ^ 1], sizeof coins[0]);
        shake256(buf[cur ^ 1], NTRUPLUS_N / 4, coins[cur ^ 1], 32);
    }
    cur ^= 1;
    for (;;) {
        r = geng_from_seed(&g, &ginv, buf[cur]);
        ntruplus_declassify(&r, sizeof r);
        if (!r)
            break;
        randombytes(coins[cur], sizeof coins[0]);
        shake256(buf[cur], NTRUPLUS_N / 4, coins[cur], 32);
    }

    crypto_kem_keypair_derand(pk, sk, &f, &finv, &g, &ginv);
    secure_clear(coins, sizeof coins);
    secure_clear(buf, sizeof buf);
    secure_clear(&f, sizeof f);
    secure_clear(&finv, sizeof finv);
    secure_clear(&g, sizeof g);
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
    poly c, h, r, m;

    if (poly_frombytes(&h,pk)) {
        memset(ct,0,NTRUPLUS_CIPHERTEXTBYTES);
        secure_clear(ss,NTRUPLUS_SSBYTES);
        return 1;
    }

    for (size_t i = 0; i < NTRUPLUS_N / 8; i++)
        msg[i] = coins[i];

    hash_f(msg + NTRUPLUS_N / 8, pk);
    hash_h(buf1, msg);

    poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES);
    poly_ntt(&r, &r);

    /* Serialize directly into the prefixed hash input. */
    hash_g_fr0(ct, r.coeffs);
    poly_sotp_encode(&m, msg, ct);
    poly_ntt(&m, &m);

    poly_basemul_add(&c, &h, &r, &m);
    poly_tobytes_small(ct, &c);

    for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
        ss[i] = buf1[i];

    secure_clear(msg,sizeof msg);
    secure_clear(buf1,sizeof buf1);
    secure_clear(&r,sizeof r);
    secure_clear(&m,sizeof m);
    return 0;
}

/*************************************************
* Name:        crypto_kem_enc
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
int crypto_kem_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk)
{
    uint8_t coins[NTRUPLUS_N / 8];

    randombytes(coins, sizeof coins);
    int ret=crypto_kem_enc_derand(ct, ss, pk, coins);
    secure_clear(coins,sizeof coins);
    return ret;
}

/*************************************************
* Name:        crypto_kem_dec
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
int crypto_kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk)
{
	uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES];
	uint8_t buf2[NTRUPLUS_N / 4];
	/* buf1 and buf3 are first written after the inverse, so they also hold
	 * its working area, which is cleared with them on exit. */
	union {
		struct {
			uint8_t buf1[NTRUPLUS_POLYBYTES];
			uint8_t buf3[NTRUPLUS_POLYBYTES + NTRUPLUS_SYMBYTES];
		} b;
		uint8_t invntt[POLY_INVNTT_TERNARY_SCRATCHBYTES];
	} io __attribute__((aligned(16)));
	_Static_assert(sizeof io.b >= sizeof io.invntt, "clearing buf1 and buf3 must clear the inverse scratch");
	uint8_t *buf1 = io.b.buf1, *buf3 = io.b.buf3;

    int8_t fail=1;

    /* Four-slot lifetime ABI: c, reusable f/work, hinv, and natural m. */
    poly c, f, hinv, m;

    /* Same rejection order as the selected Official.  Secret-key validity is
     * released as a status bit, declassified as Official does. */
    if (poly_frombytes(&c,ct) ||
        declassify_poly_frombytes(&f,sk) ||
        declassify_poly_frombytes(&hinv,sk+NTRUPLUS_POLYBYTES)) {
        secure_clear(ss,NTRUPLUS_SSBYTES);
        goto cleanup;
    }

    /* Only this product uses R^-1; the paired inverse restores natural R0. */
    poly_basemul_rinv(m.coeffs, c.coeffs, f.coeffs);
    poly_invntt_ternary(&m, &m, io.invntt);

    /* f is dead after the decrypting BaseMul and becomes the work slot. */
    poly_ntt(&f, &m);
    poly_sub(&c, &c, &f);
    poly_basemul(&f, &c, &hinv);

    poly_tobytes_small(buf1, &f);
    hash_g(buf2, buf1);
    fail = poly_sotp_decode(msg, &m, buf2);

    for (size_t i = 0; i < NTRUPLUS_SYMBYTES; i++)
        msg[i + NTRUPLUS_N / 8] = sk[i + 2 * NTRUPLUS_POLYBYTES];

    hash_h(buf3, msg);

    poly_cbd1(&f, buf3 + NTRUPLUS_SSBYTES);
    poly_ntt(&f, &f);

    /*
     * Re-encrypt and compare, the arrangement NTRU+864 already uses.  The
     * serialized ciphertext goes into the tail of buf3, which is exactly
     * NTRUPLUS_POLYBYTES long once the shared-secret prefix is excluded, and
     * whose seed bytes poly_cbd1 has just consumed.  The leading
     * NTRUPLUS_SSBYTES are untouched, so ss can still be read from them below,
     * and buf3 is cleared on the way out either way.
     *
     * A compare fused into the serializer is 0.44% faster on Cortex-A76, where
     * its scattered narrow loads are nearly free, but 0.76% slower on M2.
     */
    poly_tobytes(buf3 + NTRUPLUS_SSBYTES, &f);
    fail |= verify(buf1, buf3 + NTRUPLUS_SSBYTES, NTRUPLUS_POLYBYTES);

    for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
        ss[i] = buf3[i] & ~(-fail);

cleanup:
    secure_clear(msg,sizeof msg);
    secure_clear(&io,sizeof io);
    secure_clear(buf2,sizeof buf2);
    secure_clear(&c,sizeof c);
    secure_clear(&f,sizeof f);
    secure_clear(&hinv,sizeof hinv);
    secure_clear(&m,sizeof m);
    return fail;
}
