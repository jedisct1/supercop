#include <stdint.h>
#include "crypto_int16.h"
#include "crypto_uint32.h"
#include "crypto_declassify.h"
#include <string.h>
#include "params.h"
#include "poly.h"
#include "ntt.h"
#include "symmetric.h"

/*************************************************
* Name:        crepmod3
*
* Description: Compute modulus 3 operation
*
* Arguments: - poly *a: pointer to intput integer to be reduced
*
* Returns:     integer in {-1,0,1} congruent to a modulo 3.
**************************************************/
static inline int16_t crepmod3(int16_t a)
{
	int16_t t;
	const int16_t v = ((1<<15) + 3/2)/3;

	a += crypto_int16_negative_mask(a) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q+1)/2;
	a += crypto_int16_negative_mask(a) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q-1)/2;

	t  = ((int32_t)v*a + (1<<14)) >> 15;
	t *= 3;
	return a - t;
}

/*************************************************
* Name:        poly_tobytes
*
* Description: Serialization of a polynomial
*
* Arguments:   - uint8_t *r: pointer to output byte array
*                            (needs space for NTRUPLUS_POLYBYTES bytes)
*              - poly *a:    pointer to input polynomial
**************************************************/
void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{
	int16_t t[2];

	for(size_t i = 0; i < NTRUPLUS_N/2; i++)
	{
		t[0] = a->coeffs[2*i];
		t[0] += crypto_int16_negative_mask(t[0]) & NTRUPLUS_Q;
		t[1] = a->coeffs[2*i+1];
		t[1] += crypto_int16_negative_mask(t[1]) & NTRUPLUS_Q;

		r[3*i+0] = (t[0] >> 0);
		r[3*i+1] = (t[0] >> 8) | (t[1] << 4);
		r[3*i+2] = (t[1] >> 4);
	}
}

/*************************************************
* Name:        poly_frombytes
*
* Description: De-serialization of a polynomial;
*              inverse of poly_tobytes
*
* Arguments:   - poly *r:          pointer to output polynomial
*              - const uint8_t *a: pointer to input byte array
*                                  (of NTRUPLUS_POLYBYTES bytes)
*
* Returns 0 on success, 1 if any coefficient is greater than or equal to q.
**************************************************/
int poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{
	uint32_t fail = 0;

	for(size_t i = 0; i < NTRUPLUS_N/2; i++)
	{
		const uint16_t t0 = ((a[3*i+0] >> 0) | ((uint16_t)a[3*i+1] << 8)) & 0xFFF;
		const uint16_t t1 = ((a[3*i+1] >> 4) | ((uint16_t)a[3*i+2] << 4)) & 0xFFF;

		r->coeffs[2*i]   = t0;
		r->coeffs[2*i+1] = t1;
		fail |= (uint32_t)(NTRUPLUS_Q - 1) - t0;
		fail |= (uint32_t)(NTRUPLUS_Q - 1) - t1;
	}

	return crypto_uint32_topbit_01(fail);
}

/*************************************************
* Name:        poly_cbd1
*
* Description: Sample a polynomial deterministically from a random,
*              with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *buf: pointer to input random
*                                     (of length NTRUPLUS_N/4 bytes)
**************************************************/
void poly_cbd1(poly *r, const unsigned char buf[NTRUPLUS_N/4])
{
	uint8_t t1, t2;

	for(size_t i = 0; i < NTRUPLUS_N / 8; i++)
	{
		t1 = buf[i];
		t2 = buf[i + NTRUPLUS_N / 8];

		for(size_t j = 0; j < 8; j++)
		{
			r->coeffs[8*i + j] = crypto_int16_bottombit_01(t1) - crypto_int16_bottombit_01(t2);

			t1 >>= 1;   
			t2 >>= 1;
		}
	}
}

/*************************************************
* Name:        poly_sotp_encode
*
* Description: Encode a message deterministically using SOTP and a random,
			   with output polynomial close to centered binomial distribution
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *msg: pointer to input message
*              - const uint8_t *buf: pointer to input random
**************************************************/
void poly_sotp_encode(poly *r, const uint8_t msg[NTRUPLUS_N/8], const uint8_t buf[NTRUPLUS_N/4])
{
    uint8_t tmp[NTRUPLUS_N/4];

    for(int i = 0; i < NTRUPLUS_N/8; i++)
    {
         tmp[i] = buf[i]^msg[i];
    }

    for(int i = NTRUPLUS_N/8; i < NTRUPLUS_N/4; i++)
    {
         tmp[i] = buf[i];
    }

	poly_cbd1(r, tmp);
}

/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a, const uint8_t buf[NTRUPLUS_N/4])
{
	uint8_t t1, t2, t3;
	uint16_t t4;
	uint32_t r = 0;
	volatile uint8_t mask;

	for(size_t i = 0; i < NTRUPLUS_N / 8; i++)
	{
		t1 = buf[i                 ];
		t2 = buf[i + NTRUPLUS_N / 8];
		t3 = 0;

		for(int j = 0; j < 8; j++)
		{
			t4 = t2 & 0x1;
			t4 += a->coeffs[8*i + j];
			r |= t4;
			t4 = crypto_int16_bottombit_01(t4 ^ t1);
			t3 ^= (uint8_t)(t4 << j);

			t1 >>= 1;
			t2 >>= 1;
		}

		msg[i] = t3;
	}

	r = r >> 1;
	r = crypto_uint32_topbit_01(r);

	mask = (uint8_t)(r - 1);

	for (size_t i = 0; i < NTRUPLUS_N / 8; i++)
		msg[i] &= mask;

	return r;
}

/*************************************************
* Name:        poly_ntt
*
* Description: Computes number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to input/output polynomial
**************************************************/
void poly_ntt(poly *r)
{
	ntt(r->coeffs);
}

/*************************************************
* Name:        poly_invntt
*
* Description: Computes inverse of number-theoretic transform (NTT)
*
* Arguments:   - poly *r: pointer to input/output polynomial
**************************************************/
void poly_invntt(poly *r)
{
	invntt(r->coeffs);
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
* 
* Returns:     integer
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
	for(int i = 0; i < NTRUPLUS_N/6; ++i)
	{
		if(baseinv(r->coeffs+6*i, a->coeffs+6*i, zetas[144+i]))
		{
			for (size_t j = 0; j < NTRUPLUS_N; ++j)
				r->coeffs[j] = 0;

			return 1;
		}

		if(baseinv(r->coeffs+6*i+3, a->coeffs+6*i+3, -zetas[144+i]))
		{
			for (size_t j = 0; j < NTRUPLUS_N; ++j)
				r->coeffs[j] = 0;

			return 1;
		}
	 }

	return 0;
}

/*************************************************
* Name:        poly_basemul
*
* Description: Multiplication of two polynomials in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to first input polynomial
*              - const poly *b: pointer to second input polynomial
**************************************************/
void poly_basemul(poly *r, const poly *a, const poly *b)
{
	for(int i = 0; i < NTRUPLUS_N/6; i++)
	{
		basemul(r->coeffs+6*i,   a->coeffs+6*i,   b->coeffs+6*i,    zetas[144+i]);
		basemul(r->coeffs+6*i+3, a->coeffs+6*i+3, b->coeffs+6*i+3, -zetas[144+i]);
	}
}

/*************************************************
* Name:        poly_basemul_add
*
* Description: Multiplication then addition of three polynomials in NTT domain
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to first input polynomial
*              - const poly *b: pointer to second input polynomial
*              - const poly *c: pointer to third input polynomial
**************************************************/
void poly_basemul_add(poly *r, const poly *a, const poly *b, const poly *c)
{
	for(int i = 0; i < NTRUPLUS_N/6; i++)
	{
		basemul_add(r->coeffs+6*i,   a->coeffs+6*i,   b->coeffs+6*i,   c->coeffs+6*i,    zetas[144+i]);
		basemul_add(r->coeffs+6*i+3, a->coeffs+6*i+3, b->coeffs+6*i+3, c->coeffs+6*i+3, -zetas[144+i]);
	}
}

/*************************************************
* Name:        poly_sub
*
* Description: Subtract two polynomials; no modular reduction is performed
*
* Arguments: - poly *r: pointer to output polynomial
*            - const poly *a: pointer to first input polynomial
*            - const poly *b: pointer to second input polynomial
**************************************************/
void poly_sub(poly *r, const poly *a, const poly *b)
{
	for(int i = 0; i < NTRUPLUS_N; ++i)
		r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

/*************************************************
* Name:        poly_triple
*
* Description: Multiply polynomial by 3; no modular reduction is performed
*
* Arguments: - poly *r: pointer to input/output polynomial
**************************************************/
void poly_triple(poly *r) 
{
	for(int i = 0; i < NTRUPLUS_N; ++i)
		r->coeffs[i] *= 3;
}

/*************************************************
* Name:        poly_crepmod3
*
* Description: Compute modulus 3 operation to polynomial
*
* Arguments: - poly *r: pointer to input/output polynomial
**************************************************/
void poly_crepmod3(poly *r)
{
	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] = crepmod3(r->coeffs[i]);
}
