#include "util.h"
#include "crypto_kem.h"
#include <stddef.h>
#include <stdint.h>
#include "crypto_uint64.h"
#include "api.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "fips202.h"
#include "randombytes.h"

#ifdef SUPERCOP
#include "crypto_declassify.h"
#define ntruplus_declassify crypto_declassify
#else
#define ntruplus_declassify(x, xlen) ((void)(x), (void)(xlen))
#endif

static int declassify_poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{
  int result = poly_frombytes(r,a);
  ntruplus_declassify(&result,sizeof result);
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

    return crypto_uint64_nonzero_01(acc);
}

/*************************************************
* Name:        genf_derand
*
* Description: Deterministically generates a secret polynomial f and its
*              multiplicative inverse finv in the NTT domain.
*
* Arguments:   - poly *f:     output polynomial f (NTT domain)
*              - poly *finv:  output multiplicative inverse of f
*                              in the NTT domain
*              - uint8_t *buf: workspace of NTRUPLUS_N/4 bytes
*              - const uint8_t *coins: 32-byte deterministic seed
*
* Returns 0 on success; non-zero if f is not invertible in the NTT domain.
**************************************************/
static inline int genf_derand(poly *f, poly *finv,
                              uint8_t buf[NTRUPLUS_N / 4],
                              const uint8_t *coins)
{
    shake256(buf, NTRUPLUS_N / 4, coins, 32);

    poly_cbd1(f, buf);
    poly_triple(f);
    f->coeffs[0] += 1;

    poly_ntt(f);

    return poly_baseinv(finv, f);
}

/*************************************************
* Name:        geng_derand
*
* Description: Deterministically generates a secret polynomial g and its
*              multiplicative inverse ginv in the NTT domain.
*
* Arguments:   - poly *g:      output polynomial g (NTT domain)
*              - poly *ginv:   output multiplicative inverse of g
*                               in the NTT domain
*              - uint8_t *buf: workspace of NTRUPLUS_N/4 bytes
*              - const uint8_t *coins: 32-byte deterministic seed
*
* Returns 0 on success; non-zero if g is not invertible in the NTT domain.
**************************************************/
static inline int geng_derand(poly *g, poly *ginv,
                              uint8_t buf[NTRUPLUS_N / 4],
                              const uint8_t *coins)
{
    shake256(buf, NTRUPLUS_N / 4, coins, 32);

    poly_cbd1(g, buf);
    poly_triple(g);

    poly_ntt(g);

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
    poly_tobytes(pk, &h);

    poly_basemul(&h, f, ginv);
    poly_tobytes(sk, f);
    poly_tobytes(sk + NTRUPLUS_POLYBYTES, &h);
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
int crypto_kem_keypair(unsigned char *pk, unsigned char *sk)
{
    uint8_t coins[NTRUPLUS_SYMBYTES];
    uint8_t buf[NTRUPLUS_N / 4];
    int r;

    poly f, finv;
    poly g, ginv;

    do {
        randombytes(coins, sizeof coins);
        r = genf_derand(&f, &finv, buf, coins);
        ntruplus_declassify(&r, sizeof r);
    } while (r);

    do {
        randombytes(coins, sizeof coins);
        r = geng_derand(&g, &ginv, buf, coins);
        ntruplus_declassify(&r, sizeof r);
    } while (r);

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
* Returns 0 on success. If pk contains a non-canonical coefficient, ct and ss
* are set to all zero bytes and 1 is returned.
**************************************************/
static inline int crypto_kem_enc_derand(uint8_t *ct, uint8_t *ss,
                                        const uint8_t *pk,
                                        const uint8_t *coins)
{
    uint8_t msg[HASH_H_INBYTES];
    uint8_t buf[HASH_H_OUTBYTES];

    poly c, h, r, m;

    if(poly_frombytes(&h, pk))
    {
        for (size_t i = 0; i < NTRUPLUS_CIPHERTEXTBYTES; i++)
            ct[i] = 0;
        secure_clear(ss, NTRUPLUS_SSBYTES);

        return 1;
    }
    
    for (size_t i = 0; i < NTRUPLUS_N / 8; i++)
        msg[i] = coins[i];

    hash_f(msg + NTRUPLUS_N / 8, pk);
    hash_h(buf, msg);
    
    poly_cbd1(&r, buf + NTRUPLUS_SYMBYTES);
    poly_ntt(&r);
    
    poly_tobytes(ct, &r);
    hash_g(ct, ct);
    poly_sotp_encode(&m, msg, ct);
    poly_ntt(&m);
    
    poly_basemul(&c, &h, &r);
    poly_add(&c, &c, &m);
    poly_tobytes(ct, &c);

    for (size_t i = 0; i < NTRUPLUS_SSBYTES; i++)
        ss[i] = buf[i];

    secure_clear(msg, sizeof msg);
    secure_clear(buf, sizeof buf);
    secure_clear(&r, sizeof r);
    secure_clear(&m, sizeof m);
    
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
* Returns 0 on success. If pk contains a non-canonical coefficient, ct and ss
* are set to all zero bytes and 1 is returned.
**************************************************/
int crypto_kem_enc(unsigned char *ct, unsigned char *ss,
                   const unsigned char *pk)
{
    uint8_t coins[NTRUPLUS_N / 8];
    int ret;

    randombytes(coins, sizeof coins);
    ret = crypto_kem_enc_derand(ct, ss, pk, coins);
    secure_clear(coins, sizeof coins);
    return ret;
}

/*************************************************
* Name:        crypto_kem_dec
*
* Description: Generates shared secret for given
*              cipher text and private key
*
* Arguments:   - unsigned char *ss: pointer to output shared secret
*                (an already allocated array of CRYPTO_BYTES bytes)
*              - const unsigned char *ct: pointer to input cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - const unsigned char *sk: pointer to input private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success) or 1 (failure)
*
* On failure, ss will contain zero values.
**************************************************/
int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk)
{
	uint8_t msg[HASH_H_INBYTES];
	uint8_t buf1[HASH_G_INBYTES];
	uint8_t buf2[HASH_G_INBYTES];
	uint8_t buf3[HASH_H_OUTBYTES];
	
	int8_t fail = 1;
	
	poly c, f, hinv, m;

	if(poly_frombytes(&c, ct) ||
	   declassify_poly_frombytes(&f, sk) ||
	   declassify_poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES))
	{
		secure_clear(ss, NTRUPLUS_SSBYTES);

		goto cleanup;
	}
	
	poly_basemul_scale(&m, &c, &f);
	poly_invntt_scale(&m);
	poly_crepmod3(&m);
	
	f = m;
	poly_ntt(&f);
	poly_sub(&c, &c, &f);
	poly_basemul(&f, &c, &hinv);
	poly_tobytes(buf1, &f);
	
	hash_g(buf2, buf1);
	fail = poly_sotp_decode(msg, &m, buf2);
	
	for (int i = 0; i < HASH_F_OUTBYTES; i++)
		msg[i + NTRUPLUS_N / 8] = sk[i + 2 * NTRUPLUS_POLYBYTES]; 

	hash_h(buf3, msg);
	
	poly_cbd1(&f, buf3 + NTRUPLUS_SSBYTES);
	poly_ntt(&f);
	poly_tobytes(buf2, &f);
	
	fail |= verify(buf1, buf2, NTRUPLUS_POLYBYTES);
	
	for(int i = 0; i < NTRUPLUS_SSBYTES; i++)
		ss[i] = buf3[i] & ~(-fail);

cleanup:
	secure_clear(msg, sizeof msg);
	secure_clear(buf1, sizeof buf1);
	secure_clear(buf2, sizeof buf2);
	secure_clear(buf3, sizeof buf3);
	secure_clear(&c, sizeof c);
	secure_clear(&f, sizeof f);
	secure_clear(&hinv, sizeof hinv);
	secure_clear(&m, sizeof m);

	return fail;
}
