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

#define NTRUPLUS_NINV        0x82A0FD8Fu
#define NTRUPLUS_2NINV       0x0541FB1Du

static const uint32_t zetas[288] = {
	0x0012F51Eu, 0xCA88B381u, 0x8F70A253u, 0x533C346Eu, 0x40342211u, 0x708F5DAEu, 0x2152DD6Bu, 0x93A935D7u,
	0x4FD4292Du, 0x276560CAu, 0x7F84C6C2u, 0xC320F414u, 0x435058DDu, 0x044B88A1u, 0x8CC62A36u, 0x5B87713Au,
	0x1611540Du, 0xB02BD6D4u, 0x0BA052F1u, 0x35D61612u, 0x2A35C321u, 0xF8138CC7u, 0x58DCF91Du, 0x60C96C57u,
	0x0BEC2766u, 0x5FF8E416u, 0x540CBCB0u, 0x8EC6044Cu, 0x5587E2F9u, 0xC6C1DEAEu, 0x48467F85u, 0x292C5B88u,
	0xE0E5DC03u, 0xDD6ADBA4u, 0x88A08BD0u, 0xAB35B02Cu, 0xE5DC02ABu, 0xB4775F75u, 0xAD229525u, 0xD3A4788Fu,
	0xB9807B3Au, 0x0754CA50u, 0xCFB7B981u, 0x781D0755u, 0x39FBB478u, 0x5C1F1A24u, 0x2BD6D3A5u, 0x3E2152DEu,
	0x35B02BD7u, 0x7B393E22u, 0x02AA781Eu, 0x5F743049u, 0x95245C20u, 0x788EC605u, 0x0CBCAFA8u, 0x39D5CA3Du,
	0x56CA29EAu, 0x071BEAF9u, 0x13D89AA0u, 0xE30BA053u, 0x20F413D9u, 0x2306E30Cu, 0xEC7339D6u, 0xEEABF344u,
	0x0FA0071Cu, 0x3693A936u, 0x5FAD0FA1u, 0x9A9F3694u, 0xAFA72307u, 0xCA3CDF0Cu, 0x29E9EEACu, 0xEAF8138Du,
	0x05FF8E42u, 0x96C56CA3u, 0x5CA3CDF1u, 0x35058DD0u, 0x89A9F36Au, 0xBA052F06u, 0x1540CBCBu, 0xC7339D5Du,
	0xCF91CF46u, 0x0F413D8Au, 0xBEAF8139u, 0x5D616116u, 0x72306E31u, 0xCDF0BEC3u, 0x8E41507Fu, 0x6CA29E9Fu,
	0x62A35C33u, 0xCBCAFA73u, 0xF3693A94u, 0x2F05FF8Fu, 0x9EEABF35u, 0x8138CC63u, 0xCF45FAD1u, 0x3D89A9F4u,
	0x61611541u, 0x507EC734u, 0x6E30BA06u, 0xBEC27657u, 0x0071BEB0u, 0x3A935D62u, 0x5C320F42u, 0xFA72306Fu,
	0x560C96C6u, 0xFAD0FA01u, 0xBF343506u, 0xCC62A35Du, 0xADBA3E0Fu, 0x77139FBCu, 0xD0754CA5u, 0x8467F84Du,
	0x6D3A4789u, 0x152DD6AEu, 0x08BCFB7Cu, 0x2AA781D1u, 0x4C6C1DEBu, 0x5B02BD6Eu, 0xF1A23FD6u, 0x44B88A09u,
	0x07B393E3u, 0x4CA4FD43u, 0x3E0E5DC1u, 0x9FBB4776u, 0x7E2F8AB4u, 0xFB7B9808u, 0x4788EC61u, 0xD6ADBA3Fu,
	0x75F74305u, 0x3FD5587Fu, 0x1DEAD22Au, 0xBD6D3A48u, 0xB88A08BDu, 0x5DC02AA8u, 0x93E2152Eu, 0xFD4292C6u,
	0x45C1F1A3u, 0xEC6044B9u, 0x8AB35B03u, 0x9807B394u, 0xC5B87714u, 0xD2295246u, 0x43048468u, 0x587E2F8Bu,
	0x00AA9E08u, 0xD7DD0C13u, 0x0A4B16E2u, 0x77AB48A6u, 0xE2ACD6C1u, 0xE601ECE5u, 0x3B18112Fu, 0x6E8F8398u,
	0xE4F8854Cu, 0x3F50A4B2u, 0x97700AAAu, 0xD1DD7DD1u, 0xA5491708u, 0x1E23B182u, 0xF8BE2ACEu, 0xEDEE601Fu,
	0x8112E229u, 0xF8397701u, 0x1ECE4F89u, 0x3293F50Bu, 0xD0C1211Au, 0x561F8BE3u, 0xB48A5492u, 0x4E91E23Cu,
	0x8F839771u, 0xE7EED1DEu, 0x53293F51u, 0xFE131B08u, 0x5561F8BFu, 0x22F3EDEFu, 0xB4E91E24u, 0x54B75AB7u,
	0xEE601ECFu, 0x41D53294u, 0xB6E8F83Au, 0xDC4E7EEEu, 0x077AB48Bu, 0xAF5B4E92u, 0x8FF55620u, 0x22822F3Fu,
	0x91E23B19u, 0x75AB6E90u, 0x3EDEE602u, 0xE0741D54u, 0xED1DD7DEu, 0xC688FF56u, 0x31B077ACu, 0x6C0AF5B5u,
	0xB75AB6E9u, 0x16E1DC4Fu, 0x9E0741D6u, 0x0C1211A0u, 0x7C688FF6u, 0x112E2283u, 0xD6C0AF5Cu, 0xECE4F886u,
	0x822F3EDFu, 0x0AA9E075u, 0x854B75ACu, 0xA4B16E1Eu, 0x9FE131B1u, 0x2ACD6C0Bu, 0x1707C689u, 0xB18112E3u,
	0x0AF5B4EAu, 0x4F8854B8u, 0xE22822F4u, 0x7700AA9Fu, 0x1DC4E7EFu, 0x5491707Du, 0x2119FE14u, 0x8BE2ACD7u,
	0x14BC17FFu, 0x58325B16u, 0xCE757290u, 0xFCD0D417u, 0x6FABE04Fu, 0xD7585846u, 0x83D04F63u, 0x8C1B8C2Fu,
	0x455032F3u, 0xB1CCE758u, 0x2E814BC2u, 0x9D958326u, 0x16373E48u, 0x70C83D05u, 0x01C6FABFu, 0xEA4D7586u,
	0x04F626A8u, 0xB8C2E815u, 0x85845504u, 0x41FB1CCFu, 0x25B15B29u, 0x3E801C70u, 0x0D416374u, 0xA8D70C84u,
	0x1B8C2E82u, 0x2FB09D96u, 0x541FB1CDu, 0xA7A7BAB0u, 0x43E801C7u, 0xCDA4EA4Eu, 0x8A8D70C9u, 0x2F2BE9C9u,
	0x4D758585u, 0x390541FCu, 0xC8C1B8C3u, 0x37C2FB0Au, 0xAFCD0D42u, 0x3318A8D8u, 0x7EB43E81u, 0x6A7CDA4Fu,
	0xD70C83D1u, 0xBE9C8C1Cu, 0x4EA4D759u, 0x7FE39055u, 0x09D95833u, 0x3D17EB44u, 0x7BAAFCD1u, 0x04E3318Bu,
	0x2BE9C8C2u, 0x728F37C3u, 0x17FE3906u, 0x5B15B28Bu, 0x73D17EB5u, 0x4F626A7Du, 0xE04E3319u, 0x58455033u,
	0x7CDA4EA5u, 0x4BC17FE4u, 0x32F2BE9Du, 0xE75728F4u, 0x8A7A7BABu, 0xFABE04E4u, 0x3E473D18u, 0x3D04F627u,
	0xE3318A8Eu, 0x55032F2Cu, 0x26A7CDA5u, 0xE814BC18u, 0xF37C2FB1u, 0x6373E474u, 0x5B28A7A8u, 0x1C6FABE1u
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

static const int16_t zetas_mont[144] = {
	-1323,   163,   309,   981,  -557,  -258,   232, -1680,
	-1657, -1233,   144,  1699,   311, -1060,   578,  1298,
	 -403,  1607,  1074,  -148,   447, -1568,  1142,  -402,
	-1412,  -623,   855,   365,   -98,  -244,   407,  1225,
	  416,   683,  -105,  1714, -1019,  1061,  1163,   638,
	  798,  1493,  -351,   396,  -542,    -9,  1616,  -139,
	 -987,  -482,   889,   238, -1513,   466, -1089,  -101,
	  849,  -426,  1589,  1487,   671,  1459,  -776,   255,
	-1014,  1144,   472, -1153,  -325,  1519,   -26, -1123,
	  324,  1230,  1547,  -593,  -428,  1192,  1072, -1564,
	  688,  -333,  1023, -1686,   841,   824,   -71,  1587,
	  522,  -323,  1148,   389,  1231,   384,  1343,   169,
	  628, -1329, -1056,  -936,    24,  -293,  1523,  -300,
	-1654,   891,  -962,   -67,   179, -1177,   844,  -509,
	-1677, -1565,  -549, -1508,  1191,  -280,   -43,   669,
	 -746,   753,   770, -1046,  1711,  1438,   690,  1083,
	 1062,  1727,  -883,   553,  1670,    66,   825,  -133,
	-1586,   637,  -680,  -917,   644,  -372, -1193, -1136
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
			t4 = crypto_uint32_bottombit_01(t2);
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
	r = crypto_uint32_nonzero_01(r);

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
		int16_t *ri = r + 576*j;

		for(int i = 0; i < 192; i++)
		{
			const int16_t t1 = plantard_mul(zeta0, ri[i + 192]);
			const int16_t t2 = plantard_mul(zeta1, ri[i + 384]);
			const int16_t t3 = plantard_mul(NTRUPLUS_OMEGA, t1 - t2);

			ri[i + 384] = ri[i] - t1 - t3;
			ri[i + 192] = ri[i] - t2 + t3;
			ri[i]       = ri[i] + t1 + t2;
		}
	}

	for(int j = 0; j < 6; j++)
	{
		const uint32_t zeta0 = zetas[6+2*j];
		const uint32_t zeta1 = zetas[7+2*j];
		const uint32_t zeta2 = zetas[18+3*j];
		const uint32_t zeta3 = zetas[19+3*j];
		const uint32_t zeta4 = zetas[20+3*j];

		for(int i = 0; i < 32; i++)
		{
			int16_t *ri = r + 192*j + i;
			int32_t v0 = ri[0*32];
			int32_t v1 = ri[1*32];
			int32_t v2 = ri[2*32];
			int32_t v3 = ri[3*32];
			int32_t v4 = ri[4*32];
			int32_t v5 = ri[5*32];

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

			ri[0*32] = v0;
			ri[1*32] = v1;
			ri[2*32] = v2;
			ri[3*32] = v3;
			ri[4*32] = v4;
			ri[5*32] = v5;
		}
	}

	for(int j = 0; j < 36; j++)
	{
		const uint32_t zeta0 = zetas[36+j];
		const uint32_t zeta1 = zetas[72+2*j];
		const uint32_t zeta2 = zetas[73+2*j];
		const uint32_t zeta3 = zetas[144+4*j];
		const uint32_t zeta4 = zetas[145+4*j];
		const uint32_t zeta5 = zetas[146+4*j];
		const uint32_t zeta6 = zetas[147+4*j];

		for(int i = 0; i < 4; i++)
		{
			int16_t *ri = r + 32*j + i;
			int32_t v0 = ri[0*4];
			int32_t v1 = ri[1*4];
			int32_t v2 = ri[2*4];
			int32_t v3 = ri[3*4];
			int32_t v4 = ri[4*4];
			int32_t v5 = ri[5*4];
			int32_t v6 = ri[6*4];
			int32_t v7 = ri[7*4];

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
				const uint32_t a0 = v0*NTRUPLUS_R;
				const uint32_t b0 = v1*zeta3;
				const uint32_t a1 = v2*NTRUPLUS_R;
				const uint32_t b1 = v3*zeta4;
				const uint32_t a2 = v4*NTRUPLUS_R;
				const uint32_t b2 = v5*zeta5;
				const uint32_t a3 = v6*NTRUPLUS_R;
				const uint32_t b3 = v7*zeta6;

				v1 = plantard_reduce_acc(a0 - b0);
				v0 = plantard_reduce_acc(a0 + b0);
				v3 = plantard_reduce_acc(a1 - b1);
				v2 = plantard_reduce_acc(a1 + b1);
				v5 = plantard_reduce_acc(a2 - b2);
				v4 = plantard_reduce_acc(a2 + b2);
				v7 = plantard_reduce_acc(a3 - b3);
				v6 = plantard_reduce_acc(a3 + b3);
			}

			ri[0*4] = v0;
			ri[1*4] = v1;
			ri[2*4] = v2;
			ri[3*4] = v3;
			ri[4*4] = v4;
			ri[5*4] = v5;
			ri[6*4] = v6;
			ri[7*4] = v7;
		}
	}
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
	int16_t t1,t2,t3;
	uint32_t zeta[7];
	int16_t v[8];

	for(int j = 0; j < 36; j++)
	{
		zeta[0] = zetas[287-4*j];
		zeta[1] = zetas[286-4*j];
		zeta[2] = zetas[285-4*j];
		zeta[3] = zetas[284-4*j];
		zeta[4] = zetas[143-2*j];
		zeta[5] = zetas[142-2*j];
		zeta[6] = zetas[71-j];

		for(int i = 0; i < 4; i++)
		{
			for(int k = 0; k < 8; k++)
			{
				v[k] = r[4*k+i+32*j];
			}

			t1 = v[1];
			v[1] = plantard_mul(zeta[0], t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];
			v[3] = plantard_mul(zeta[1], t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[5];
			v[5] = plantard_mul(zeta[2], t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];
			v[7] = plantard_mul(zeta[3], t1 - v[6]);
			v[6] = v[6] + t1;

			t1 = v[2];
			v[2] = plantard_mul(zeta[4], t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];
			v[3] = plantard_mul(zeta[4], t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];
			v[6] = plantard_mul(zeta[5], t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = v[7];
			v[7] = plantard_mul(zeta[5], t1 - v[5]);
			v[5] = v[5] + t1;

			t1 = v[4];
			v[4] = plantard_mul(zeta[6], t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[5];
			v[5] = plantard_mul(zeta[6], t1 - v[1]);
			v[1] = v[1] + t1;

			t1 = v[6];
			v[6] = plantard_mul(zeta[6], t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[7];
			v[7] = plantard_mul(zeta[6], t1 - v[3]);
			v[3] = v[3] + t1;

			for(int k = 0; k < 8; k++)
			{
				r[4*k+i+32*j] = v[k];
			}
		}
	}

	for(int j = 0; j < 6; j++)
	{
		zeta[0] = zetas[35-3*j];
		zeta[1] = zetas[34-3*j];
		zeta[2] = zetas[33-3*j];
		zeta[3] = zetas[16-2*j];
		zeta[4] = zetas[17-2*j];

		for(int i = 0; i < 32; i++)
		{
			for(int k = 0; k < 6; k++)
			{
				v[k] = r[32*k+i+192*j];
			}

			t1 = v[1];
			v[1] = plantard_mul(zeta[0], t1 - v[0]);
			v[0] = v[0] + t1;

			t1 = v[3];
			v[3] = plantard_mul(zeta[1], t1 - v[2]);
			v[2] = v[2] + t1;

			t1 = v[5];
			v[5] = plantard_mul(zeta[2], t1 - v[4]);
			v[4] = v[4] + t1;

			t1 = plantard_mul(NTRUPLUS_OMEGA, v[2] - v[0]);
			t2 = plantard_mul(zeta[3], v[4] - v[0] + t1);
			t3 = plantard_mul(zeta[4], v[4] - v[2] - t1);
			v[0] = plantard_mul((int32_t)v[0] + (int32_t)v[2] + (int32_t)v[4], NTRUPLUS_R);
			v[2] = t2;
			v[4] = t3;

			t1 = plantard_mul(NTRUPLUS_OMEGA, v[3] - v[1]);
			t2 = plantard_mul(zeta[3], v[5] - v[1] + t1);
			t3 = plantard_mul(zeta[4], v[5] - v[3] - t1);
			v[1] = plantard_mul((int32_t)v[1] + (int32_t)v[3] + (int32_t)v[5], NTRUPLUS_R);
			v[3] = t2;
			v[5] = t3;

			for(int k = 0; k < 6; k++)
			{
				r[32*k+i+192*j] = v[k];
			}
		}
	}

	zeta[0] = zetas[4];
	zeta[1] = zetas[5];
	zeta[2] = zetas[2];
	zeta[3] = zetas[3];

	for(int j = 0; j < 192; j++)
	{
		for(int i = 0; i < 6; i++)
		{
			v[i] = r[192*i+j];
		}

		t1 = plantard_mul(NTRUPLUS_OMEGA, v[1] - v[0]);
		t2 = plantard_mul(zeta[0], v[2] - v[0] + t1);
		t3 = plantard_mul(zeta[1], v[2] - v[1] - t1);
		v[0] = v[0] + v[1] + v[2];
		v[1] = t2;
		v[2] = t3;

		t1 = plantard_mul(NTRUPLUS_OMEGA, v[4] - v[3]);
		t2 = plantard_mul(zeta[2], v[5] - v[3] + t1);
		t3 = plantard_mul(zeta[3], v[5] - v[4] - t1);
		v[3] = v[3] + v[4] + v[5];
		v[4] = t2;
		v[5] = t3;

		t1 = v[0] + v[3];
		t2 = plantard_mul(NTRUPLUS_ZMINUSZ5INV, v[0] - v[3]);
		v[0] = plantard_mul(NTRUPLUS_NINV, t1 - t2);
		v[3] = plantard_mul(NTRUPLUS_2NINV, t2);

		t1 = v[1] + v[4];
		t2 = plantard_mul(NTRUPLUS_ZMINUSZ5INV, v[1] - v[4]);
		v[1] = plantard_mul(NTRUPLUS_NINV, t1 - t2);
		v[4] = plantard_mul(NTRUPLUS_2NINV, t2);

		t1 = v[2] + v[5];
		t2 = plantard_mul(NTRUPLUS_ZMINUSZ5INV, v[2] - v[5]);
		v[2] = plantard_mul(NTRUPLUS_NINV, t1 - t2);
		v[5] = plantard_mul(NTRUPLUS_2NINV, t2);

		for(int i = 0; i < 6; i++)
		{
			r[192*i+j] = v[i];
		}
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

		fail |= baseinv_1(ri, den + 2*i, ai, zetas[144 + i]);
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
