#include <stddef.h>
#include "crypto_kem.h"
#include <stdint.h>
#include "kem.h"
#include "params.h"
#include "symmetric.h"
#include "poly.h"
#include "verify.h"
#include "fips202.h"
#include "randombytes.h"
#include "crypto_declassify.h"

/*************************************************
* Name:        crypto_kem_keypair
*
* Description: Generates public and private key
*              for CCA-secure NTRU+ key encapsulation mechanism
*
* Arguments:   - unsigned char *pk: pointer to output public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*              - unsigned char *sk: pointer to output private key
*                (an already allocated array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_kem_keypair(unsigned char *pk, unsigned char *sk)
{
	uint8_t buf[NTRUPLUS_N / 4];
	
	poly f, finv;
	poly g;
	poly h, hinv;

	int r;

	do {
		randombytes(buf, 32);
		shake256(buf, NTRUPLUS_N / 4, buf, 32);
		
		poly_cbd1(&f, buf);
		poly_triple(&f, &f);
		f.coeffs[0] += 1;
		poly_ntt(&f, &f);
		r = poly_baseinv(&finv, &f);
		crypto_declassify(&r, sizeof r);
	} while(r);

	do {
		randombytes(buf, 32);
		shake256(buf, NTRUPLUS_N / 4, buf, 32);

		poly_cbd1(&g, buf); 
		poly_triple(&g, &g);
		poly_ntt(&g, &g);
		poly_basemul(&h, &g, &finv);
		r = poly_baseinv(&hinv, &h);
		crypto_declassify(&r, sizeof r);
	} while(r);
	
	//pk
	poly_tobytes(pk, &h);
	
	//sk
	poly_tobytes(sk, &f);
	poly_tobytes(sk + NTRUPLUS_POLYBYTES, &hinv);	
	hash_f(sk + 2 * NTRUPLUS_POLYBYTES, pk); 
	
	return 0;
}

/*************************************************
* Name:        crypto_kem_enc
*
* Description: Generates cipher text and shared
*              secret for given public key
*
* Arguments:   - unsigned char *ct: pointer to output cipher text
*                (an already allocated array of CRYPTO_CIPHERTEXTBYTES bytes)
*              - unsigned char *ss: pointer to output shared secret
*                (an already allocated array of CRYPTO_BYTES bytes)
*              - const unsigned char *pk: pointer to input public key
*                (an already allocated array of CRYPTO_PUBLICKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_kem_enc(unsigned char *ct,
                   unsigned char *ss,
                   const unsigned char *pk)
{
	uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES];
	uint8_t buf1[NTRUPLUS_SYMBYTES + NTRUPLUS_N / 4];
	uint8_t buf2[NTRUPLUS_POLYBYTES];
	
	poly c, h, r, m;
	
	randombytes(msg, NTRUPLUS_N / 8);
	hash_f(msg + NTRUPLUS_N / 8, pk);
	hash_h_kem(buf1, msg);
	
	poly_cbd1(&r, buf1 + NTRUPLUS_SYMBYTES);
	poly_ntt(&r, &r);
	
	poly_tobytes(buf2, &r);
	hash_g(buf2, buf2);
	
	poly_sotp(&m, msg, buf2);  
	poly_ntt(&m, &m);
	
	poly_frombytes(&h, pk);
	poly_basemul(&c, &h, &r);
	poly_add(&c, &c, &m);
	poly_tobytes(ct, &c);
	
	for (int i = 0; i < NTRUPLUS_SSBYTES; i++)
	{
		ss[i] = buf1[i];
	}
	
	return 0;
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
	uint8_t msg[NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES];
	uint8_t buf1[NTRUPLUS_POLYBYTES];
	uint8_t buf2[NTRUPLUS_POLYBYTES];
	uint8_t buf3[NTRUPLUS_POLYBYTES+NTRUPLUS_SYMBYTES] = {0};
	
	int8_t fail;
	
	poly c, f, hinv;
	poly r1, r2;
	poly m1, m2;
	
	poly_frombytes(&c, ct);
	poly_frombytes(&f, sk);
	poly_frombytes(&hinv, sk + NTRUPLUS_POLYBYTES);
	
	poly_basemul(&m1, &c, &f);
	poly_invntt(&m1, &m1);
	poly_crepmod3(&m1, &m1);
	
	poly_ntt(&m2, &m1);
	poly_sub(&c, &c, &m2);
	poly_basemul(&r2, &c, &hinv);
	poly_tobytes(buf1, &r2);
	
	hash_g(buf2, buf1);
	fail = poly_sotp_inv(msg, &m1, buf2);
	
	for (int i = 0; i < NTRUPLUS_SYMBYTES; i++)
	{
		msg[i + NTRUPLUS_N / 8] = sk[i + 2 * NTRUPLUS_POLYBYTES]; 
	}
	
	hash_h_kem(buf3, msg);
	
	poly_cbd1(&r1, buf3 + NTRUPLUS_SSBYTES);
	poly_ntt(&r1, &r1);
	poly_tobytes(buf2, &r1);
	
	fail |= verify(buf1, buf2, NTRUPLUS_POLYBYTES);
	
	for(int i = 0; i < NTRUPLUS_SSBYTES; i++)
	{
		ss[i] = buf3[i] & ~(-fail);
	}
	
	return fail;
}
