#include "util.h"
#include <string.h>
#include <stdint.h>
#include "crypto_int16.h"
#include "crypto_uint32.h"
#include "crypto_declassify.h"
#include "params.h"
#include "poly.h"
#include "symmetric.h"

#define NTRUPLUS_R           0x0012F51Eu
#define NTRUPLUS_RINVSQ      0x35774C7Fu
#define NTRUPLUS_RSQ         0xBFCBDDF0u
#define NTRUPLUS_QINV        0x74563281u

#define NTRUPLUS_OMEGA       0xCA75BE64u
#define NTRUPLUS_ZMINUSZ5INV 0x790084B4u
#define NTRUPLUS_ZETA1       -722

#define NTRUPLUS_NINV        0xC3F17C56u
#define NTRUPLUS_2NINV       0x87E2F8ACu

static const uint32_t zetas[192] = {
	0x0012F51Eu, 0xCA88B381u, 0x8BA9CD80u, 0xECF7EDA3u, 0xACC3CB93u, 0x74563281u, 0xCD7F0013u, 0x6FD1CA89u,
	0xA252CA76u, 0xB380ECF8u, 0xBE63ACC4u, 0x0AE2BFCCu, 0x80FFED0Bu, 0x3C346DE5u, 0x08125D75u, 0xAD358A42u,
	0x2E35774Du, 0x34221071u, 0x5D745633u, 0x8A419C54u, 0x774C7F14u, 0x10708F5Eu, 0x6DE4E591u, 0x12F51D41u,
	0xC346DE4Fu, 0xF0012F52u, 0xF70A252Du, 0xC7F13082u, 0xE63ACC3Du, 0x45632810u, 0x42210709u, 0x1CA88B39u,
	0xD358A41Au, 0x7EDA28BBu, 0xAE2BFCBEu, 0x4E5902E4u, 0xC533C347u, 0x9CD7F002u, 0xDEF8F70Bu, 0x5774C7F2u,
	0xA75BE63Bu, 0x25D74564u, 0xD4034222u, 0xA6FD1CA9u, 0xF5DAD359u, 0x0ECF7EDBu, 0xFED0AE2Cu, 0x46DE4E5Au,
	0x23D76B4Eu, 0xE03B3DFCu, 0x3FFB42B9u, 0x0D1B793Au, 0x40B8D5DEu, 0x00D08842u, 0xD6F98EB4u, 0x75D158CBu,
	0x22CE03B4u, 0xBE3DC28Au, 0x4CF0D1B8u, 0x35FC004Cu, 0x47500D09u, 0xC69BF473u, 0x04975D16u, 0x4D629068u,
	0xF77BE3DDu, 0x8D5DD320u, 0xEA735FC1u, 0x98EB30F3u, 0x486C69C0u, 0xB42B8B00u, 0x76B4D62Au, 0xB3DFB68Bu,
	0xE3DC2895u, 0xD31FC4C3u, 0x5FC004BEu, 0x30F2E487u, 0x69BF472Bu, 0x8AFF2F78u, 0xD6290672u, 0xB68A2EA8u,
	0xD5DD31FDu, 0x8841C23Eu, 0x8EB30F2Fu, 0x58CA0400u, 0x42B8AFF3u, 0x7939640Cu, 0x3DFB68A3u, 0x94B29D70u,
	0x0D08841Du, 0xF472A22Du, 0x5D158CA1u, 0x906714D0u, 0xD1B79397u, 0x004BD476u, 0xC2894B2Au, 0xFC4C204Au,
	0x01A11084u, 0x7E8E5446u, 0xEBA2B195u, 0x520CE29Au, 0x1A36F273u, 0x80097A8Fu, 0xB8512966u, 0x3F89840Au,
	0x5A6B1484u, 0xEFDB4518u, 0x15C57F98u, 0xC9CB205Du, 0xAEE98FE3u, 0x420E11ECu, 0x75987973u, 0xC6501FFEu,
	0x4BAE8AC7u, 0xB148338Bu, 0x4DFA3952u, 0x57F97BBEu, 0x1EE144A6u, 0x98FE2611u, 0xFE0025EBu, 0x87972437u,
	0x685715FFu, 0x6F272C82u, 0x67BF6D15u, 0x129653AEu, 0x31D661E6u, 0x2B194080u, 0x11083848u, 0xE54459C1u,
	0x8D37E8E6u, 0x715FE5EFu, 0x9AC520CFu, 0xF6D145D5u, 0x6BF80098u, 0x661E5C91u, 0xBA63F899u, 0x83847AEEu,
	0x1D9EFDB5u, 0x144A594Fu, 0x8DBC9CB3u, 0x025EA3A9u, 0x684420E2u, 0xA3951168u, 0xE8AC6502u, 0x8338A679u,
	0xC8171ABCu, 0xA01A1109u, 0x3ADF31D7u, 0x2EBA2B1Au, 0x07FF6858u, 0xE1A36F28u, 0x9C0767C0u, 0x7B851297u,
	0x61024BAFu, 0xB5A6B149u, 0x43634DFBu, 0xA15C57FAu, 0xBBDF1EE2u, 0x6AEE98FFu, 0x539AFE01u, 0xC7598798u,
	0x94EB7CC8u, 0x24BAE8ADu, 0x3A806845u, 0x34DFA396u, 0x16701D9Fu, 0xF1EE144Bu, 0x67868DBDu, 0xAFE0025Fu,
	0xC90D8D38u, 0xF6857160u, 0xAED69AC6u, 0x767BF6D2u, 0x5D4E6BF9u, 0xF31D661Fu, 0x71ABBA64u, 0xA1108385u,
	0xA8EA01A2u, 0xD8D37E8Fu, 0x4092EBA3u, 0x69AC520Du, 0x299E1A37u, 0xE6BF800Au, 0xF7C7B852u, 0xBBA63F8Au,
	0x1EBB5A6Cu, 0x01D9EFDCu, 0xFFDA15C6u, 0x68DBC9CCu, 0x05C6AEEAu, 0x0684420Fu, 0xB7CC7599u, 0xAE8AC651u
};

/*************************************************
* Name:        plantard_reduce
*
* Description: Plantard reduction; given a 32-bit integer a, computes
*              a 16-bit integer congruent to a * R^-1 mod q,
*              where R = -2^32.
*
* Arguments:   - int32_t a: input integer to be reduced;
*                           must lie in {-q^2*64, ..., q^2*64}
*
* Returns:     an integer in {-(q+1)/2, ..., (q-1)/2} congruent to
*              a * R^-1 mod q.
**************************************************/
static inline int16_t plantard_reduce(uint32_t a)
{
	int32_t t = (int32_t)(a * NTRUPLUS_QINV) >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;
}

/*************************************************
* Name:        plantard_reduce_acc
*
* Description: Plantard reduction for accumulated values; given a
*              32-bit integer a = x*qinv that is already multiplied by
*              qinv, computes a 16-bit integer congruent to x * R^-1
*              mod q, where R = -2^32. The value x must lie in the
*              range {-q^2*64, ..., q^2*64}.
*
* Arguments:   - int32_t a: value x*qinv to be reduced
*
* Returns:     an integer in {-(q+1)/2, ..., (q-1)/2} congruent to
*              x * R^-1 mod q.
**************************************************/
static inline int16_t plantard_reduce_acc(uint32_t a)
{
	int32_t t = (int32_t)a >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;
}

/*************************************************
* Name:        plantard_mul
*
* Description: Plantard multiplication; given 32-bit integers a and b,
*              where one operand is of the form x*qinv (precomputed)
*              and the other is y, computes a 16-bit integer congruent
*              to x * y * R^-1 mod q, where R = -2^32. The product x*y
*              must lie in the range {-q^2*64, ..., q^2*64}.
*
* Arguments:   - uint32_t a: first operand (x*qinv or y)
*              - uint32_t b: second operand (y or x*qinv)
*
* Returns:     an integer in {-(q+1)/2, ..., (q-1)/2} congruent to
*              x * y * R^-1 mod q.
**************************************************/
static inline int16_t plantard_mul(uint32_t a, uint32_t b)
{
	int32_t t = (int32_t)(a * b) >> 16;
	t = ((t+8)*NTRUPLUS_Q) >> 16;
	return t;
}

#define NTRUPLUS_R_MONT            -147
#define NTRUPLUS_RSQ_MONT           867
#define NTRUPLUS_QINV_MONT        12929

static const int16_t zetas_mont[96] = {
	  223,  1138, -1059,  -397,  -183,  1655,   559, -1674,
	  277,   933,  1723,   437, -1514,   242,  1640,   432,
	-1583,   696,   774,  1671,   927,   514,   512,   489,
	  297,   601,  1473,  1130,  1322,   871,   760,  1212,
	 -312,  -352,   443,   943,     8,  1250,  -100,  1660,
	  -31,  1206, -1341, -1247,   444,   235,  1364, -1209,
	  361,   230,   673,   582,  1409,  1501,  1401,   251,
	 1022, -1063,  1053,  1188,   417, -1391,   -27, -1626,
	 1685,  -315,  1408, -1248,   400,   274, -1543,    32,
	-1550,  1531, -1367,  -124,  1458,  1379,  -940, -1681,
	   22,  1709,  -275,  1108,   354, -1728,  -968,   858,
	 1221,  -218,   294,  -732, -1095,   892,  1588,  -779
};

/*************************************************
* Name:        montgomery_reduce
*
* Description: Montgomery reduction; given a 32-bit integer a, computes
*              a 16-bit integer congruent to a * R^-1 mod q,
*              where R = 2^16.
*
* Arguments:   - int32_t a: input integer to be reduced;
*                           must lie in {-q*2^15, ..., q*2^15-1}
*
* Returns:     an integer in {-q+1, ..., q-1} congruent to
*              a * R^-1 mod q.
**************************************************/
static inline int16_t montgomery_reduce(int32_t a)
{
	int16_t t;

	t = (int16_t)a * NTRUPLUS_QINV_MONT;
	t = (a - (int32_t)t * NTRUPLUS_Q) >> 16;
	return t;
}

/*************************************************
* Name:        barrett_reduce
*
* Description: Barrett reduction; given a 16-bit integer a, computes a
*              centered representative congruent to a mod q in
*              {-(q+1)/2, ..., (q+1)/2}.
*
* Arguments:   - int16_t a: input integer to be reduced
*
* Returns:     integer in {-(q+1)/2, ..., (q+1)/2} congruent to a mod q.
**************************************************/
static inline int16_t barrett_reduce(int16_t a)
{
	int16_t t;
	const int16_t v = ((1<<26) + NTRUPLUS_Q/2) / NTRUPLUS_Q;

	t  = ((int32_t)v*a + (1<<25)) >> 26;
	return a - t*NTRUPLUS_Q;
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
void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N/4])
{
	uint8_t t1, t2;

	for(size_t i = 0; i < NTRUPLUS_N/8; i++)
	{
		t1 = buf[i];
		t2 = buf[i + NTRUPLUS_N/8];

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
		tmp[i] = buf[i] ^ msg[i];
	}

	for(int i = NTRUPLUS_N/8; i < NTRUPLUS_N/4; i++)
	{
		tmp[i] = buf[i];
	}

	poly_cbd1(r, tmp);
	secure_clear(tmp, sizeof tmp);
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

	for(size_t i = 0; i < NTRUPLUS_N/8; i++)
	{
		t1 = buf[i];
		t2 = buf[i + NTRUPLUS_N/8];
		t3 = 0;

		for(size_t j = 0; j < 8; j++)
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

	for(size_t i = 0; i < NTRUPLUS_N/8; i++)
		msg[i] &= mask;

	return r;
}

/*************************************************
* Name:        ntt
*
* Description: Number-theoretic transform (NTT) in R_q. Transforms the
*              coefficient representation of a into a representation
*              where each block of 4 coefficients corresponds to an
*              element of Zq[X]/(X^4 - zeta_i).
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to output vector; NTT
*                                       representation of a in the
*                                       product ring Zq[X]/(X^4 - zeta_i)
*              - const int16_t a[NTRUPLUS_N]: pointer to input vector of
*                                            coefficients of a in R_q
*
* Returns:     none.
**************************************************/
static inline void ntt(int16_t r[NTRUPLUS_N])
{
	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		const int16_t t = NTRUPLUS_ZETA1 * r[i + NTRUPLUS_N/2];

		r[i + NTRUPLUS_N/2] = r[i] + r[i + NTRUPLUS_N/2] - t;
		r[i]                 = r[i] + t;
	}

	for(int j = 0; j < 2; j++)
	{
		const uint32_t zeta0 = zetas[2+2*j];
		const uint32_t zeta1 = zetas[3+2*j];
		const uint32_t zeta2 = zetas[6+3*j];
		const uint32_t zeta3 = zetas[7+3*j];
		const uint32_t zeta4 = zetas[8+3*j];

		for(int i = 0; i < 64; i++)
		{
			int16_t *ri = r + 384*j + i;
			int32_t v0 = ri[0*64];
			int32_t v1 = ri[1*64];
			int32_t v2 = ri[2*64];
			int32_t v3 = ri[3*64];
			int32_t v4 = ri[4*64];
			int32_t v5 = ri[5*64];

			{
				const int16_t a0 = plantard_mul(zeta0, v2);
				const int16_t b0 = plantard_mul(zeta1, v4);
				const int16_t a1 = plantard_mul(zeta0, v3);
				const int16_t b1 = plantard_mul(zeta1, v5);
				const int16_t c0 = plantard_mul(NTRUPLUS_OMEGA, a0 - b0);
				const int16_t c1 = plantard_mul(NTRUPLUS_OMEGA, a1 - b1);

				v4 = v0 - a0;
				v2 = v0 - b0;
				v0 = v0 + a0 + b0;
				v5 = v1 - a1;
				v3 = v1 - b1;
				v1 = v1 + a1 + b1;

				v4 = v4 - c0;
				v2 = v2 + c0;
				v5 = v5 - c1;
				v3 = v3 + c1;
			}

			{
				const int16_t u0 = plantard_mul(zeta2, v1);
				const int16_t u1 = plantard_mul(zeta3, v3);
				const int16_t u2 = plantard_mul(zeta4, v5);

				v1 = v0 - u0;
				v0 = v0 + u0;
				v3 = v2 - u1;
				v2 = v2 + u1;
				v5 = v4 - u2;
				v4 = v4 + u2;
			}

			ri[0*64] = v0;
			ri[1*64] = v1;
			ri[2*64] = v2;
			ri[3*64] = v3;
			ri[4*64] = v4;
			ri[5*64] = v5;
		}
	}

	for(int j = 0; j < 12; j++)
	{
		const uint32_t zeta0 = zetas[12+j];
		const uint32_t zeta1 = zetas[24+2*j];
		const uint32_t zeta2 = zetas[25+2*j];
		const uint32_t zeta3 = zetas[48+4*j];
		const uint32_t zeta4 = zetas[49+4*j];
		const uint32_t zeta5 = zetas[50+4*j];
		const uint32_t zeta6 = zetas[51+4*j];

		for(int i = 0; i < 8; i++)
		{
			int16_t *ri = r + 64*j + i;
			int32_t v0 = ri[0*8];
			int32_t v1 = ri[1*8];
			int32_t v2 = ri[2*8];
			int32_t v3 = ri[3*8];
			int32_t v4 = ri[4*8];
			int32_t v5 = ri[5*8];
			int32_t v6 = ri[6*8];
			int32_t v7 = ri[7*8];

			{
				const int16_t u0 = plantard_mul(zeta0, v4);
				const int16_t u1 = plantard_mul(zeta0, v5);
				const int16_t u2 = plantard_mul(zeta0, v6);
				const int16_t u3 = plantard_mul(zeta0, v7);

				v4 = v0 - u0;
				v0 = v0 + u0;
				v5 = v1 - u1;
				v1 = v1 + u1;
				v6 = v2 - u2;
				v2 = v2 + u2;
				v7 = v3 - u3;
				v3 = v3 + u3;
			}

			{
				const int16_t u0 = plantard_mul(zeta1, v2);
				const int16_t u1 = plantard_mul(zeta1, v3);
				const int16_t u2 = plantard_mul(zeta2, v6);
				const int16_t u3 = plantard_mul(zeta2, v7);

				v2 = v0 - u0;
				v0 = v0 + u0;
				v3 = v1 - u1;
				v1 = v1 + u1;
				v6 = v4 - u2;
				v4 = v4 + u2;
				v7 = v5 - u3;
				v5 = v5 + u3;
			}

			{
				const int16_t u0 = plantard_mul(zeta3, v1);
				const int16_t u1 = plantard_mul(zeta4, v3);
				const int16_t u2 = plantard_mul(zeta5, v5);
				const int16_t u3 = plantard_mul(zeta6, v7);

				v1 = v0 - u0;
				v0 = v0 + u0;
				v3 = v2 - u1;
				v2 = v2 + u1;
				v5 = v4 - u2;
				v4 = v4 + u2;
				v7 = v6 - u3;
				v6 = v6 + u3;
			}

			ri[0*8] = v0;
			ri[1*8] = v1;
			ri[2*8] = v2;
			ri[3*8] = v3;
			ri[4*8] = v4;
			ri[5*8] = v5;
			ri[6*8] = v6;
			ri[7*8] = v7;
		}
	}

	for(int j = 0; j < 96; j++)
	{
		const uint32_t zeta0 = zetas[96+j];
		int16_t *ri = r + 8*j;

		for(int i = 0; i < 4; i++)
		{
			const int16_t t = plantard_mul(zeta0, ri[i + 4]);
			ri[i + 4] = ri[i] - t;
			ri[i]     = ri[i] + t;
		}
	}

	for(int i = 0; i < NTRUPLUS_N; i++)
		r[i] = barrett_reduce(r[i]);
}

/*************************************************
* Name:        poly_ntt
*
* Description: Computes the number-theoretic transform (NTT) for a polynomial
*              whose coefficients are in the range [-3, 4].
*
* Arguments:   - poly *r: pointer to input/output polynomial
**************************************************/
void poly_ntt(poly *r)
{
	ntt(r->coeffs);
}

/*************************************************
* Name:        invntt_scaled
*
* Description: Inverse number-theoretic transform (NTT) in R_q. Transforms
*              the NTT representation in r, where each block of 4
*              coefficients corresponds to an element of Zq[X]/(X^4 - zeta_i),
*              back to the coefficient representation in R_q.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to input/output vector;
*                                       input NTT representation in the
*                                       product ring Zq[X]/(X^4 - zeta_i),
*                                       output coefficient representation
*                                       in R_q. The input carries the
*                                       Montgomery R^-1 scale
*
* Returns:     none.
**************************************************/
static inline void invntt_scaled(int16_t r[NTRUPLUS_N])
{
	int16_t v[8];

	for(int j = 0; j < 48; j++)
	{
		int16_t t1;

		uint32_t zeta0 = zetas[191-2*j];
		uint32_t zeta1 = zetas[190-2*j];
		uint32_t zeta2 = zetas[95-j];

		for(int i = 0; i < 2; i++)
		{
			for(int k = 0; k < 8; k++)
			{
				v[k] = r[2*k+i+16*j];
			}

			t1 = v[2];
			v[2] = plantard_mul(zeta0, t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];
			v[3] = plantard_mul(zeta0, t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];
			v[6] = plantard_mul(zeta1, t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];
			v[7] = plantard_mul(zeta1, t1 - v[5]);
			v[5] = v[5] + t1;

			t1 = v[4];
			v[4] = plantard_mul(zeta2, t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[5];
			v[5] = plantard_mul(zeta2, t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];
			v[6] = plantard_mul(zeta2, t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[7];
			v[7] = plantard_mul(zeta2, t1 - v[3]);
			v[3] = v[3] + t1;

			for(int k = 0; k < 8; k++)
			{
				r[2*k+i+16*j] = v[k];
			}
		}
	}

	for(int j = 0; j < 12; j++)
	{
		int16_t t1;

		uint32_t zeta0 = zetas[47-2*j];
		uint32_t zeta1 = zetas[46-2*j];
		uint32_t zeta2 = zetas[23-j];

		for(int i = 0; i < 8; i++)
		{
			for(int k = 0; k < 8; k++)
			{
				v[k] = r[8*k+i+64*j];
			}

			t1 = v[2];
			v[2] = plantard_mul(zeta0, t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];
			v[3] = plantard_mul(zeta0, t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];
			v[6] = plantard_mul(zeta1, t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];
			v[7] = plantard_mul(zeta1, t1 - v[5]);
			v[5] = v[5] + t1;

			t1 = v[4];
			v[4] = plantard_mul(zeta2, t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[5];
			v[5] = plantard_mul(zeta2, t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];
			v[6] = plantard_mul(zeta2, t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[7];
			v[7] = plantard_mul(zeta2, t1 - v[3]);
			v[3] = v[3] + t1;

			for(int k = 0; k < 8; k++)
			{
				r[8*k+i+64*j] = v[k];
			}
		}
	}

	for(int j = 0; j < 2; j++)
	{
		int16_t t1,t2,t3;

		uint32_t T1,T2;

		uint32_t zeta0 = zetas[11-3*j];
		uint32_t zeta1 = zetas[10-3*j];
		uint32_t zeta2 = zetas[ 9-3*j];
		uint32_t zeta3 = zetas[ 4-2*j];
		uint32_t zeta4 = zetas[ 5-2*j];

		for(int i = 0; i < 64; i++)
		{
			for(int k = 0; k < 6; k++)
			{
				v[k] = r[64*k+i+384*j];
			}

			T1 = (int32_t)v[1] - (int32_t)v[0];
			T2 = (int32_t)v[1] + (int32_t)v[0];
			v[1] = plantard_mul(zeta0, T1);
			v[0] = plantard_mul(NTRUPLUS_R, T2);

			T1 = (int32_t)v[3] - (int32_t)v[2];
			T2 = (int32_t)v[3] + (int32_t)v[2];
			v[3] = plantard_mul(zeta1, T1);
			v[2] = plantard_mul(NTRUPLUS_R, T2);

			T1 = (int32_t)v[5] - (int32_t)v[4];
			T2 = (int32_t)v[5] + (int32_t)v[4];
			v[5] = plantard_mul(zeta2, T1);
			v[4] = plantard_mul(NTRUPLUS_R, T2);

			t1 = plantard_mul(NTRUPLUS_OMEGA, v[2] - v[0]);
			t2 = plantard_mul(zeta3, v[4] - v[0] + t1);
			t3 = plantard_mul(zeta4, v[4] - v[2] - t1);
			v[0] = v[0] + v[2] + v[4];
			v[2] = t2;
			v[4] = t3;

			t1 = plantard_mul(NTRUPLUS_OMEGA, v[3] - v[1]);
			t2 = plantard_mul(zeta3, v[5] - v[1] + t1);
			t3 = plantard_mul(zeta4, v[5] - v[3] - t1);
			v[1] = v[1] + v[3] + v[5];
			v[3] = t2;
			v[5] = t3;

			for(int k = 0; k < 6; k++)
			{
				r[64*k+i+384*j] = v[k];
			}
		}
	}

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		int16_t t1 = r[i] + r[i + NTRUPLUS_N/2];
		int16_t t2 = plantard_mul(NTRUPLUS_ZMINUSZ5INV, r[i] - r[i + NTRUPLUS_N/2]);

		r[i]                 = plantard_mul(NTRUPLUS_NINV, t1 - t2);
		r[i + NTRUPLUS_N/2] = plantard_mul(NTRUPLUS_2NINV, t2);
	}

	secure_clear(v, sizeof v);
}

/*************************************************
* Name:        poly_invntt_scaled
*
* Description: Computes the inverse NTT for an input carrying the Montgomery
*              R^-1 scale produced by poly_basemul_scaled.
*
* Arguments:   - poly *r: pointer to input/output polynomial
**************************************************/
void poly_invntt_scaled(poly *r)
{
	invntt_scaled(r->coeffs);
}

/*************************************************
* Name:        baseinv
*
* Description: Simultaneous inversion of polynomials in
*              Z_q[X]/(X^4 - zeta) and Z_q[X]/(X^4 + zeta), used as
*              a building block for inversion of elements in R_q in the
*              NTT domain. The input array a encodes two degree-3
*              polynomials:
*                a[0..3] for X^4 - zeta,
*                a[4..7] for X^4 + zeta.
*              On success, r[0..3] and r[4..7] contain their inverses.
*
* Arguments:   - int16_t r[8]:       pointer to the output polynomials
*              - const int16_t a[8]: pointer to the input polynomials
*              - uint32_t zeta:      parameter defining X^4 ± zeta
*
* Returns:     0 if both polynomials are invertible, 1 otherwise.
**************************************************/
static inline int baseinv_1(int16_t r[2*NTRUPLUS_D], int16_t den[2],
		const int16_t a[2*NTRUPLUS_D], uint32_t zeta)
{
	int16_t t0, t1, t2, t3;
	int16_t s0, s1, s2, s3;
	uint32_t A0, A1, A2, A3;
	uint32_t B0, B1, B2, B3;
	uint32_t zeta1, zeta2;

	zeta1 = zeta;
	zeta2 = -zeta;

	A0 = (int32_t)a[0]*NTRUPLUS_QINV;
	A1 = (int32_t)a[1]*NTRUPLUS_QINV;
	A2 = (int32_t)a[2]*NTRUPLUS_QINV;
	A3 = (int32_t)a[3]*NTRUPLUS_QINV;
	B0 = (int32_t)a[4]*NTRUPLUS_QINV;
	B1 = (int32_t)a[5]*NTRUPLUS_QINV;
	B2 = (int32_t)a[6]*NTRUPLUS_QINV;
	B3 = (int32_t)a[7]*NTRUPLUS_QINV;

	t0 = plantard_reduce_acc(a[2]*A2 - 2*a[1]*A3);
	s0 = plantard_reduce_acc(a[6]*B2 - 2*a[5]*B3);
	t1 = plantard_reduce_acc(a[3]*A3);
	s1 = plantard_reduce_acc(a[7]*B3);
	t0 = plantard_reduce_acc(a[0]*A0 + t0*zeta1);
	s0 = plantard_reduce_acc(a[4]*B0 + s0*zeta2);
	t1 = plantard_reduce_acc(a[1]*A1 + t1*zeta1 - 2*a[0]*A2);
	s1 = plantard_reduce_acc(a[5]*B1 + s1*zeta2 - 2*a[4]*B2);
	t2 = plantard_reduce_acc(t1*zeta1);
	s2 = plantard_reduce_acc(s1*zeta2);

	t3 = plantard_reduce(t0*t0 - t1*t2);
	s3 = plantard_reduce(s0*s0 - s1*s2);

	r[0] = plantard_reduce_acc(A0*t0 + A2*t2);
	r[1] = plantard_reduce_acc(A3*t2 + A1*t0);
	r[2] = plantard_reduce_acc(A2*t0 + A0*t1);
	r[3] = plantard_reduce_acc(A1*t1 + A3*t0);
	r[4] = plantard_reduce_acc(B0*s0 + B2*s2);
	r[5] = plantard_reduce_acc(B3*s2 + B1*s0);
	r[6] = plantard_reduce_acc(B2*s0 + B0*s1);
	r[7] = plantard_reduce_acc(B1*s1 + B3*s0);

	den[0] = t3; // R^-3
	den[1] = s3; // R^-3

	return (t3 == 0) | (s3 == 0);
}

/*************************************************
* Name:        fqinv
*
* Description: Computes the multiplicative inverse of a value in the
*              finite field Z_q.
*              The exponent q-2 = 3455 is evaluated using a shortest
*              addition chain of length 15 (OEIS A003313).
*
* Arguments:   - int16_t a: input value in {-(q+1)/2, ..., (q-1)/2}
*
* Returns:     an integer in {-(q+1)/2, ..., (q-1)/2} congruent to
*              a^{-1} mod q.
**************************************************/
static inline int16_t fqinv(int16_t a)
{
	int16_t t0, t1;
	uint32_t A, T;

	A = a*NTRUPLUS_QINV;
	t0 = plantard_reduce_acc(a*A);      // 10
	t0 = plantard_reduce(t0*t0);        // 100
	t0 = plantard_reduce(t0*t0);        // 1000
	t0 = plantard_reduce(t0*t0);        // 10000
	t1 = plantard_reduce_acc(t0*A);     // 10001

	t0 = plantard_reduce(t0*t0);        // 100000
	t0 = plantard_reduce(t0*t0);        // 1000000
	t0 = plantard_reduce(t0*t0);        // 10000000
	t1 = plantard_reduce(t0*t1);        // 10010001

	T = t1*NTRUPLUS_QINV;
	t0 = plantard_reduce_acc(t0*T);     // 100010001
	t1 = plantard_reduce_acc(t0*T);     // 110100010
	t1 = plantard_reduce(t1*t0);        // 1010110011
	t0 = plantard_reduce(t1*t1);        // 10101100110
	t0 = plantard_reduce(t0*t0);        // 101011001100

	T = t1*NTRUPLUS_RINVSQ; // below 64*q^2 for centered fqinv inputs.
	return plantard_reduce_acc(t0*T);   // 110101111111
}

/*************************************************
* Name:        fqinv_batch
*
* Description: Inverts a batch of field elements using one call to fqinv.
*              Eight independent product and recovery chains are combined
*              hierarchically to expose ILP while retaining Montgomery's trick.
*
* Reference:   J. Kim, H. Cho, and J. H. Park, "Accelerating NTRU+ Key
*              Generation via Hierarchical Batch Inversion," IACR ePrint
*              2026/1191, https://eprint.iacr.org/2026/1191.
*
* Arguments:   - int16_t *r: input/output array of field elements
**************************************************/
static inline void fqinv_batch(int16_t *r)
{
	const int chunk = NTRUPLUS_N/(NTRUPLUS_D * 8);
	const int off0  = 0 * chunk;
	const int off1  = 1 * chunk;
	const int off2  = 2 * chunk;
	const int off3  = 3 * chunk;
	const int off4  = 4 * chunk;
	const int off5  = 5 * chunk;
	const int off6  = 6 * chunk;
	const int off7  = 7 * chunk;

	int16_t  pc0[NTRUPLUS_N/NTRUPLUS_D];
	uint32_t R[NTRUPLUS_N/NTRUPLUS_D];

	pc0[off0] = r[off0];
	pc0[off1] = r[off1];
	pc0[off2] = r[off2];
	pc0[off3] = r[off3];
	pc0[off4] = r[off4];
	pc0[off5] = r[off5];
	pc0[off6] = r[off6];
	pc0[off7] = r[off7];

	for(int i = 1; i < chunk; i++)
	{
		R[off0 + i] = (uint32_t)r[off0 + i] * NTRUPLUS_QINV;
		R[off1 + i] = (uint32_t)r[off1 + i] * NTRUPLUS_QINV;
		R[off2 + i] = (uint32_t)r[off2 + i] * NTRUPLUS_QINV;
		R[off3 + i] = (uint32_t)r[off3 + i] * NTRUPLUS_QINV;
		R[off4 + i] = (uint32_t)r[off4 + i] * NTRUPLUS_QINV;
		R[off5 + i] = (uint32_t)r[off5 + i] * NTRUPLUS_QINV;
		R[off6 + i] = (uint32_t)r[off6 + i] * NTRUPLUS_QINV;
		R[off7 + i] = (uint32_t)r[off7 + i] * NTRUPLUS_QINV;

		pc0[off0 + i] = plantard_mul(pc0[off0 + i - 1], R[off0 + i]);
		pc0[off1 + i] = plantard_mul(pc0[off1 + i - 1], R[off1 + i]);
		pc0[off2 + i] = plantard_mul(pc0[off2 + i - 1], R[off2 + i]);
		pc0[off3 + i] = plantard_mul(pc0[off3 + i - 1], R[off3 + i]);
		pc0[off4 + i] = plantard_mul(pc0[off4 + i - 1], R[off4 + i]);
		pc0[off5 + i] = plantard_mul(pc0[off5 + i - 1], R[off5 + i]);
		pc0[off6 + i] = plantard_mul(pc0[off6 + i - 1], R[off6 + i]);
		pc0[off7 + i] = plantard_mul(pc0[off7 + i - 1], R[off7 + i]);
	}

	// product chain - level 1
	int16_t  r1[8];
	uint32_t R1[8];

	r1[0] = pc0[off0 + chunk - 1];
	r1[1] = pc0[off1 + chunk - 1];
	r1[2] = pc0[off2 + chunk - 1];
	r1[3] = pc0[off3 + chunk - 1];
	r1[4] = pc0[off4 + chunk - 1];
	r1[5] = pc0[off5 + chunk - 1];
	r1[6] = pc0[off6 + chunk - 1];
	r1[7] = pc0[off7 + chunk - 1];

	R1[0] = (uint32_t)r1[0] * NTRUPLUS_QINV;
	R1[1] = (uint32_t)r1[1] * NTRUPLUS_QINV;
	R1[2] = (uint32_t)r1[2] * NTRUPLUS_QINV;
	R1[3] = (uint32_t)r1[3] * NTRUPLUS_QINV;
	R1[4] = (uint32_t)r1[4] * NTRUPLUS_QINV;
	R1[5] = (uint32_t)r1[5] * NTRUPLUS_QINV;
	R1[6] = (uint32_t)r1[6] * NTRUPLUS_QINV;
	R1[7] = (uint32_t)r1[7] * NTRUPLUS_QINV;

	int16_t  r2[4];
	uint32_t R2[4];

	r2[0] = plantard_mul(r1[0], R1[1]);
	r2[1] = plantard_mul(r1[2], R1[3]);
	r2[2] = plantard_mul(r1[4], R1[5]);
	r2[3] = plantard_mul(r1[6], R1[7]);

	R2[0] = (uint32_t)r2[0] * NTRUPLUS_QINV;
	R2[1] = (uint32_t)r2[1] * NTRUPLUS_QINV;
	R2[2] = (uint32_t)r2[2] * NTRUPLUS_QINV;
	R2[3] = (uint32_t)r2[3] * NTRUPLUS_QINV;

	// product chain - level 2
	int16_t  r3[2];
	uint32_t R3[2];

	r3[0] = plantard_mul(r2[0], R2[1]);
	r3[1] = plantard_mul(r2[2], R2[3]);

	R3[0] = (uint32_t)r3[0] * NTRUPLUS_QINV;
	R3[1] = (uint32_t)r3[1] * NTRUPLUS_QINV;

	// product chain - level 3
	int16_t inv = plantard_mul(r3[0], R3[1]);

	//fqinv
	inv = fqinv(inv);

	// derive_fqinv - level 3
	int16_t inv2[2];

	inv2[1] = plantard_mul(inv, R3[0]);

	inv2[0] = plantard_mul(inv, R3[1]);

	secure_clear(&inv, sizeof inv);
	secure_clear(r3, sizeof r3);
	secure_clear(R3, sizeof R3);

	// derive_fqinv - level 2
	int16_t inv1[4];

	inv1[1] = plantard_mul(inv2[0], R2[0]);
	inv1[3] = plantard_mul(inv2[1], R2[2]);

	inv1[0] = plantard_mul(inv2[0], R2[1]);
	inv1[2] = plantard_mul(inv2[1], R2[3]);

	secure_clear(inv2, sizeof inv2);
	secure_clear(r2, sizeof r2);
	secure_clear(R2, sizeof R2);

	// derive_fqinv - level 1
	int16_t inv0[8];

	inv0[1] = plantard_mul(inv1[0], R1[0]);
	inv0[3] = plantard_mul(inv1[1], R1[2]);
	inv0[5] = plantard_mul(inv1[2], R1[4]);
	inv0[7] = plantard_mul(inv1[3], R1[6]);

	inv0[0] = plantard_mul(inv1[0], R1[1]);
	inv0[2] = plantard_mul(inv1[1], R1[3]);
	inv0[4] = plantard_mul(inv1[2], R1[5]);
	inv0[6] = plantard_mul(inv1[3], R1[7]);

	secure_clear(inv1, sizeof inv1);
	secure_clear(r1, sizeof r1);
	secure_clear(R1, sizeof R1);

	for(int i = chunk - 1; i > 0; i--)
	{
		r[off0 + i] = plantard_reduce(pc0[off0 + i - 1]*inv0[0]);
		r[off1 + i] = plantard_reduce(pc0[off1 + i - 1]*inv0[1]);
		r[off2 + i] = plantard_reduce(pc0[off2 + i - 1]*inv0[2]);
		r[off3 + i] = plantard_reduce(pc0[off3 + i - 1]*inv0[3]);
		r[off4 + i] = plantard_reduce(pc0[off4 + i - 1]*inv0[4]);
		r[off5 + i] = plantard_reduce(pc0[off5 + i - 1]*inv0[5]);
		r[off6 + i] = plantard_reduce(pc0[off6 + i - 1]*inv0[6]);
		r[off7 + i] = plantard_reduce(pc0[off7 + i - 1]*inv0[7]);

		inv0[0] = plantard_mul(inv0[0], R[off0 + i]);
		inv0[1] = plantard_mul(inv0[1], R[off1 + i]);
		inv0[2] = plantard_mul(inv0[2], R[off2 + i]);
		inv0[3] = plantard_mul(inv0[3], R[off3 + i]);
		inv0[4] = plantard_mul(inv0[4], R[off4 + i]);
		inv0[5] = plantard_mul(inv0[5], R[off5 + i]);
		inv0[6] = plantard_mul(inv0[6], R[off6 + i]);
		inv0[7] = plantard_mul(inv0[7], R[off7 + i]);
	}

	r[off0] = inv0[0];
	r[off1] = inv0[1];
	r[off2] = inv0[2];
	r[off3] = inv0[3];
	r[off4] = inv0[4];
	r[off5] = inv0[5];
	r[off6] = inv0[6];
	r[off7] = inv0[7];

	secure_clear(pc0, sizeof pc0);
	secure_clear(R, sizeof R);
	secure_clear(inv0, sizeof inv0);
}

static inline void baseinv_2(int16_t r[NTRUPLUS_D], int16_t den[1])
{
	uint32_t T;

	T = den[0]*NTRUPLUS_QINV;

	r[0] =  plantard_reduce_acc(r[0]*T);
	r[1] = -plantard_reduce_acc(r[1]*T);
	r[2] =  plantard_reduce_acc(r[2]*T);
	r[3] = -plantard_reduce_acc(r[3]*T);
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain. baseinv_1 exposes all
*              base denominators, fqinv_batch inverts them hierarchically,
*              and baseinv_2 applies the inverses to complete each base inverse.
*
* Reference:   J. Kim, H. Cho, and J. H. Park, "Accelerating NTRU+ Key
*              Generation via Hierarchical Batch Inversion," IACR ePrint
*              2026/1191, https://eprint.iacr.org/2026/1191.
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
*
* Returns:     1 if the polynomial is not invertible; otherwise 0.
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
	int16_t den[NTRUPLUS_N/NTRUPLUS_D];
	int fail = 0;

	for(int i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
	{
		int16_t *ri = r->coeffs + 2*NTRUPLUS_D*i;
		const int16_t *ai = a->coeffs + 2*NTRUPLUS_D*i;

		fail |= baseinv_1(ri, den + 2*i, ai, zetas[96 + i]);
	}

	crypto_declassify(&fail,sizeof fail);
	if (fail)
	{
		memset(r->coeffs, 0, NTRUPLUS_N*sizeof(int16_t));
		secure_clear(den, sizeof den);
		return 1;
	}

	fqinv_batch(den);

	for(int i = 0; i < NTRUPLUS_N/NTRUPLUS_D; i++)
		baseinv_2(r->coeffs + NTRUPLUS_D*i, den + i);

	secure_clear(den, sizeof den);

	return 0;
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^4 - zeta),
*              used for multiplication of elements in R_q in the NTT domain.
*
* Arguments:   - int16_t r[4]:        pointer to the output polynomial
*              - const int16_t a[4]:  pointer to the first factor
*              - const int16_t b[4]:  pointer to the second factor
*              - const int16_t zeta:  parameter defining X^4 - zeta
*
* Returns:     none.
**************************************************/
static inline void basemul(int16_t r[NTRUPLUS_D], const int16_t a[NTRUPLUS_D],
		const int16_t b[NTRUPLUS_D], const int16_t zeta)
{
	int16_t t0 = montgomery_reduce(a[1]*b[3] + a[2]*b[2] + a[3]*b[1]); // R^-1
	int16_t t1 = montgomery_reduce(a[2]*b[3] + a[3]*b[2]);           // R^-1
	int16_t t2 = montgomery_reduce(a[3]*b[3]);                       // R^-1

	int16_t c0 = montgomery_reduce(t0*zeta + a[0]*b[0]);                         // R^-1
	int16_t c1 = montgomery_reduce(t1*zeta + a[0]*b[1] + a[1]*b[0]);             // R^-1
	int16_t c2 = montgomery_reduce(t2*zeta + a[0]*b[2] + a[1]*b[1] + a[2]*b[0]); // R^-1
	int16_t c3 = montgomery_reduce(a[0]*b[3] + a[1]*b[2] + a[2]*b[1] + a[3]*b[0]); // R^-1

	r[0] = c0;
	r[1] = c1;
	r[2] = c2;
	r[3] = c3;
}

/*************************************************
* Name:        poly_basemul
*
* Description: Multiplication of two polynomials in NTT domain
*
* Arguments:   - poly *r:       pointer to the output polynomial
*              - const poly *a: pointer to the first input polynomial
*              - const poly *b: pointer to the second input polynomial
**************************************************/
void poly_basemul(poly *r, const poly *a, const poly *b)
{
	for(int i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
	{
		int16_t *ri = r->coeffs + 2*NTRUPLUS_D*i;
		const int16_t *ai = a->coeffs + 2*NTRUPLUS_D*i;
		const int16_t *bi = b->coeffs + 2*NTRUPLUS_D*i;

		basemul(ri, ai, bi, zetas_mont[i]);
		basemul(ri + NTRUPLUS_D, ai + NTRUPLUS_D,
				bi + NTRUPLUS_D, -zetas_mont[i]);
	}

	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] = montgomery_reduce(r->coeffs[i]*NTRUPLUS_RSQ_MONT);
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
	for(int i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
	{
		int16_t *ri = r->coeffs + 2*NTRUPLUS_D*i;
		const int16_t *ai = a->coeffs + 2*NTRUPLUS_D*i;
		const int16_t *bi = b->coeffs + 2*NTRUPLUS_D*i;

		basemul(ri, ai, bi, zetas_mont[i]);
		basemul(ri + NTRUPLUS_D, ai + NTRUPLUS_D,
				bi + NTRUPLUS_D, -zetas_mont[i]);
	}

	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] = montgomery_reduce(c->coeffs[i]*NTRUPLUS_R_MONT + r->coeffs[i]*NTRUPLUS_RSQ_MONT);
}

/*************************************************
* Name:        poly_basemul_scaled
*
* Description: Multiplication of two polynomials in the NTT domain. The
*              output carries the Montgomery R^-1 scale consumed by
*              poly_invntt_scaled.
*
* Arguments:   - poly *r:       pointer to the output polynomial
*              - const poly *a: pointer to the first input polynomial
*              - const poly *b: pointer to the second input polynomial
**************************************************/
void poly_basemul_scaled(poly *r, const poly *a, const poly *b)
{
	for(int i = 0; i < NTRUPLUS_N/(2*NTRUPLUS_D); i++)
	{
		int16_t *ri = r->coeffs + 2*NTRUPLUS_D*i;
		const int16_t *ai = a->coeffs + 2*NTRUPLUS_D*i;
		const int16_t *bi = b->coeffs + 2*NTRUPLUS_D*i;

		basemul(ri, ai, bi, zetas_mont[i]);
		basemul(ri + NTRUPLUS_D, ai + NTRUPLUS_D,
				bi + NTRUPLUS_D, -zetas_mont[i]);
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
	for(int i = 0; i < NTRUPLUS_N; i++)
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
	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] *= 3;
}

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
