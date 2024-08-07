#include <stdint.h>
#include "params.h"
#include "sign.h"
#include "packing.h"
#include "poly.h"
#include "randombytes.h"
#include "symmetric.h"
#include "fips202.h"
#include "stdio.h"
#include <stdlib.h>
#include "crypto_declassify.h"
#include "crypto_uint32.h"

int crypto_sign_keypair(unsigned char *pk, unsigned char *sk) {
	unsigned char zeta[SEEDBYTES];
	unsigned char seedbuf[3 * SEEDBYTES];
	unsigned char tr[SEEDBYTES];
	const unsigned char *xi_1, *xi_2, *key;

	poly mat;
	poly s1, s1hat, s2, t1, t0;

	randombytes(zeta, SEEDBYTES);
	randombytes(seedbuf, SEEDBYTES);
	shake256(seedbuf, 3 * SEEDBYTES, seedbuf, SEEDBYTES);
	xi_1 = seedbuf;
	xi_2 = seedbuf + SEEDBYTES;
	key = seedbuf + 2 * SEEDBYTES;

	poly_uniform(&mat, zeta, 0);
	poly_uniform_eta(&s1, xi_1, 0);
	poly_uniform_eta(&s2, xi_2, 0);

	ntt(s1hat.coeffs, s1.coeffs);
	poly_base_mul(&t1, &s1hat, &mat);
	invntt_tomont(t1.coeffs, t1.coeffs);
	poly_caddq(&t1);

	poly_add(&t1, &t1, &s2);
	poly_caddq(&t1);

	poly_power2round(&t1, &t0, &t1);

	pack_pk(pk, zeta, &t1);

	shake256(tr, SEEDBYTES, pk, crypto_PUBLICKEYBYTES);

	pack_sk(sk, zeta, tr, key, &t0, &s1, &s2);

	return 0;
}

int crypto_sign_signature(unsigned char *sig,
                        	unsigned long long *siglen,
                        	const unsigned char *m,
                        	unsigned long long mlen,
                        	const unsigned char *sk)
{
	unsigned int n;
	unsigned char seedbuf[3 * SEEDBYTES + 2 * CRHBYTES];
	unsigned char *zeta, *tr, *key, *mu, *rho;
	uint16_t nonce = 0;
	poly mat, s1, y, z, t0, s2, w1, w0, h;
	poly cp;
	keccak_state state;
	int rejcond;

	zeta = seedbuf;
	tr = zeta + SEEDBYTES;
	key = tr + SEEDBYTES;
	mu = key + SEEDBYTES;
	rho = mu + CRHBYTES;
	unpack_sk(zeta, tr, key, &t0, &s1, &s2, sk);

	shake256_init(&state);
	shake256_absorb(&state, tr, SEEDBYTES);
	shake256_absorb(&state, m, mlen);
	shake256_finalize(&state);
	shake256_squeeze(mu, CRHBYTES, &state);

#ifdef NIMS_RANDOMIZED_SIGNING
	randombytes(rho, CRHBYTES);
#else
	shake256(rho, CRHBYTES, key, SEEDBYTES + CRHBYTES);
#endif

	poly_uniform(&mat, zeta, 0);

	ntt(s1.coeffs, s1.coeffs);
	ntt(s2.coeffs, s2.coeffs);
	ntt(t0.coeffs, t0.coeffs);

rej:
	poly_uniform_gamma1(&y, rho, nonce++);
	z = y;

	ntt(z.coeffs, z.coeffs);
	poly_base_mul(&w1, &z, &mat);
	invntt_tomont(w1.coeffs, w1.coeffs);
	poly_caddq(&w1);

	poly_decompose(&w1, &w0, &w1);

	polyw1_pack(sig, &w1);

	shake256_init(&state);
	shake256_absorb(&state, mu, CRHBYTES);
	shake256_absorb(&state, sig, POLYW1_PACKEDBYTES);
	shake256_finalize(&state);
	shake256_squeeze(sig, SEEDBYTES, &state);
	poly_challenge(&cp, sig);

	ntt(cp.coeffs, cp.coeffs);
	poly_base_mul(&z, &cp, &s1);
	invntt_tomont(z.coeffs, z.coeffs);
	poly_caddq(&z);

	poly_add(&z, &z, &y);
  	poly_reduce(&z);
	rejcond = poly_chknorm(&z, GAMMA1 - BETA);	// patch
	crypto_declassify(&rejcond,sizeof rejcond);
	if (rejcond) {
 		goto rej;
 	}
//	if (poly_chknorm(&z, GAMMA1 - BETA)){
//		goto rej;
//	}

	poly_base_mul(&h, &cp, &s2);
	invntt_tomont(h.coeffs, h.coeffs);
	poly_caddq(&h);

	poly_sub(&w0, &w0, &h);
  	poly_reduce(&w0);
	rejcond = poly_chknorm(&w0, GAMMA2 - BETA);	// patch
	crypto_declassify(&rejcond,sizeof rejcond);
	if (rejcond) {
 		goto rej;
 	}
//	if (poly_chknorm(&w0, GAMMA2 - BETA)){
//		goto rej;
//	}

	poly_base_mul(&h, &cp, &t0);
	invntt_tomont(h.coeffs, h.coeffs);
	poly_caddq(&h);

	poly_reduce(&h);
	rejcond = poly_chknorm(&h, GAMMA2);	// patch
	crypto_declassify(&rejcond,sizeof rejcond);
	if (rejcond) {
 		goto rej;
 	}
//	if (poly_chknorm(&h, GAMMA2)){
//		goto rej;
//	}

	poly_add(&w0, &w0, &h);

	n = poly_make_hint(&h, &w0, &w1);
	rejcond = crypto_uint32_smaller_mask(OMEGA,n);
	crypto_declassify(&rejcond,sizeof rejcond);
	if(rejcond)
	{
	        goto rej;
	}

	pack_sig(sig, sig, &z, &h);
	*siglen = crypto_BYTES;
	return 0;
}

int crypto_sign(unsigned char *sm,
              	unsigned long long *smlen,
              	const unsigned char *m,
              	unsigned long long mlen,
              	const unsigned char *sk)
{
	unsigned long long i;

	for (i = 0; i < mlen; ++i)
		sm[crypto_BYTES + mlen - 1 - i] = m[mlen - 1 - i];
	crypto_sign_signature(sm, smlen, sm + crypto_BYTES, mlen, sk);
	*smlen += mlen;
	return 0;
}

int crypto_sign_verify(const unsigned char *sig,
                       unsigned long long siglen,
                       const unsigned char *m,
                       unsigned long long mlen,
                       const unsigned char *pk)
{
	unsigned int i;
	unsigned char buf[POLYW1_PACKEDBYTES];
	unsigned char zeta[SEEDBYTES];
	unsigned char mu[CRHBYTES];
	unsigned char c[SEEDBYTES];
	unsigned char c2[SEEDBYTES];

	poly cp, mat, z, t1, t11, w1, h;
	keccak_state state;

	if (siglen != crypto_BYTES)
		return -1;
	unpack_pk(zeta, &t1, pk);

	if (unpack_sig(c, &z, &h, sig))
		return -1;

	if (poly_chknorm(&z, GAMMA1 - BETA))
		return -1;

	shake256(mu, SEEDBYTES, pk, crypto_PUBLICKEYBYTES);
	shake256_init(&state);
	shake256_absorb(&state, mu, SEEDBYTES);
	shake256_absorb(&state, m, mlen);
	shake256_finalize(&state);
	shake256_squeeze(mu, CRHBYTES, &state);
	poly_challenge(&cp, c);

	poly_uniform(&mat, zeta, 0);

	ntt(z.coeffs, z.coeffs);
	poly_base_mul(&w1, &z, &mat);
	invntt_tomont(w1.coeffs, w1.coeffs);
	poly_caddq(&w1);

	poly_shiftl(&t1);

	ntt(t11.coeffs, t1.coeffs);
	ntt(cp.coeffs, cp.coeffs);
	poly_base_mul(&t1, &cp, &t11);
	invntt_tomont(t1.coeffs, t1.coeffs);
	poly_caddq(&t1);
	poly_sub(&w1, &w1, &t1);
	poly_caddq(&w1);

	poly_use_hint(&w1, &w1, &h);
	polyw1_pack(buf, &w1);

	shake256_init(&state);
	shake256_absorb(&state, mu, CRHBYTES);
	shake256_absorb(&state, buf, POLYW1_PACKEDBYTES);
	shake256_finalize(&state);
	shake256_squeeze(c2, SEEDBYTES, &state);

	for (i = 0; i < SEEDBYTES; ++i)
		if (c[i] != c2[i])
			return -1;

	return 0;
}

int crypto_sign_open(unsigned char *m,
                     unsigned long long *mlen,
                     const unsigned char *sm,
                     unsigned long long smlen,
                     const unsigned char *pk)
{
	unsigned long long i;

	if (smlen < crypto_BYTES)
		goto badsig;

	*mlen = smlen - crypto_BYTES;
	if (crypto_sign_verify(sm, crypto_BYTES, sm + crypto_BYTES, *mlen, pk))
		goto badsig;
	else {
		for (i = 0; i < *mlen; ++i)
			m[i] = sm[crypto_BYTES + i];
		return 0;
	}

badsig:
	/* Signature verification failed */
	*mlen = -1;
	for (i = 0; i < smlen; ++i)
		m[i] = 0;

	return -1;
}
