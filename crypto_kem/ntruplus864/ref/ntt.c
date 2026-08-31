#include <stdint.h>
#include "crypto_int16.h"
#include "crypto_declassify.h"
#include "params.h"
#include "ntt.h"

#define NTRUPLUS_R            -147 // R = 2^16 mod q
#define NTRUPLUS_RINV         -682 // (R)^(-1) mod q
#define NTRUPLUS_RSQ           867 // (R^2) mod q
#define NTRUPLUS_QINV        12929 // (q)^(-1) mod (2^16)

#define NTRUPLUS_OMEGA        -886 // (omega * R) mod q
#define NTRUPLUS_ZMINUSZ5INV -1665 // (z - z^5)^(-1) * R mod q
                                   // where z = zeta^((n/d)/6)

#define NTRUPLUS_NINV        -1693 // (n/d)^(-1) * R mod q
#define NTRUPLUS_2NINV          71 // 2 * (n/d)^(-1) * R mod q

// zetas: Montgomery-form twiddle factors
const int16_t zetas[288] = {
	 -147, -1033, -1265,   708,   460,  1265,  -467,   727,
	  556,  1307,  -773,  -161,  1200, -1612,   570,  1529,
	 1135,  -556,  1120,   298,  -822, -1556,   -93,  1463,
	  532,  -377,  -909,    58,  -392,  -450,  1722,  1236,
	 -486,  -491, -1569, -1078,    36,  1289, -1443,  1628,
	 1664,  -725,  -952,    99, -1020,   353,  -599,  1119,
	  592,   839,  1622,   652,  1244,  -783, -1085,  -726,
	  566,  -284, -1369, -1292,   268,  -391,   781,  -172,
	   96, -1172,   211,   737,   473,  -445,  -234,   264,
	-1536,  1467,  -676, -1542,  -170,   635,  -705, -1332,
	 -658,   831, -1712,  1311,  1488,  -881,  1087, -1315,
	 1245,   -75,   791,    -6,  -875,  -697,   -70, -1162,
	  287,  -767,  -945,  1598,  -882,  1261,   206,   654,
	-1421,   -81,   716, -1251,   838, -1300,  1035,  -104,
	  966,  -558,   -61, -1704,   404,  -899,   862, -1593,
	-1460,   -37,  1266,   965, -1584, -1404,  -265,  -942,
	  905,  1195,  -619,   787,   118,   576,   286, -1475,
	 -194,   928,  1229, -1032,  1608,  1111, -1669,   642,
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
	
	t = (int16_t)a * NTRUPLUS_QINV;
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
	t *= NTRUPLUS_Q;
	return a - t;
}

/*************************************************
* Name:        fqmul
*
* Description: Multiplication followed by Montgomery reduction.
*
* Arguments:   - int16_t a: first factor
*              - int16_t b: second factor
*
* Returns:     16-bit integer congruent to a*b*R^-1 mod q.
**************************************************/
static inline int16_t fqmul(int16_t a, int16_t b)
{
    return montgomery_reduce((int32_t)a * b);
}

/*************************************************
* Name:        fqinv
*
* Description: Computes the multiplicative inverse in Z_q using Fermat's
*              little theorem. The exponent q-2 = 3455 is evaluated using
*              a shortest addition chain of length 15 (OEIS A003313).
*
* Arguments:   - int16_t a: input value a mod q
*
* Returns:     16-bit integer congruent to a^{-1} mod q.
**************************************************/
static inline int16_t fqinv(int16_t a)
{
	int16_t t0, t1;

	t0 = fqmul(a, a);    // 10
	t0 = fqmul(t0, t0);  // 100
	t0 = fqmul(t0, t0);  // 1000
	t0 = fqmul(t0, t0);  // 10000
	t1 = fqmul(t0, a);   // 10001

	t0 = fqmul(t0, t0);  // 100000
	t0 = fqmul(t0, t0);  // 1000000
	t0 = fqmul(t0, t0);  // 10000000
	t1 = fqmul(t0, t1);  // 10010001

	t0 = fqmul(t1, t0);  // 100010001
	t1 = fqmul(t0, t1);  // 110100010
	t1 = fqmul(t1, t0);  // 1010110011
	t0 = fqmul(t1, t1);  // 10101100110
	t0 = fqmul(t0, t0);  // 101011001100
	t0 = fqmul(t0, t1);  // 110101111111

	return fqmul(NTRUPLUS_RINV, t0);
}

/*************************************************
* Name:        ntt
*
* Description: Number-theoretic transform (NTT) in R_q. Transforms the
*              coefficient representation of r into a representation
*              where each block of 3 coefficients corresponds to an
*              element of Zq[X]/(X^3 - zeta_i).
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to input/output vector;
*                                       input coefficients of r in R_q,
*                                       output NTT representation in the
*                                       product ring Zq[X]/(X^3 - zeta_i)
*
* Returns:     none.
**************************************************/
void ntt(int16_t r[NTRUPLUS_N])
{
	int16_t t1, t2, t3;
	int16_t zeta1, zeta2;
	
	int k = 1;

	zeta1 = zetas[k++];

	for (int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = fqmul(zeta1, r[i + NTRUPLUS_N/2]);

		r[i + NTRUPLUS_N/2] = r[i] + r[i + NTRUPLUS_N/2] - t1;
		r[i               ] = r[i]                       + t1;
	}

	for (int step = NTRUPLUS_N/6; step >= 48; step = step/3)
	{
		for (int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta1 = zetas[k++];
			zeta2 = zetas[k++];

			for (int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, r[i +   step]);
				t2 = fqmul(zeta2, r[i + 2*step]);
				t3 = fqmul(NTRUPLUS_OMEGA, t1 - t2);
	
				r[i + 2*step] = r[i] - t1 - t3;
				r[i +   step] = r[i] - t2 + t3;
				r[i         ] = r[i] + t1 + t2;
			}
		}
	}

	for (int step = 24; step >= 3; step >>= 1)
	{
		for (int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k++];

			for (int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, r[i + step]);
				
				r[i + step] = barrett_reduce(r[i] - t1);
				r[i       ] = barrett_reduce(r[i] + t1);
			}
		}
	}
}

/*************************************************
* Name:        invntt
*
* Description: Inverse number-theoretic transform (NTT) in R_q. Transforms
*              the NTT representation in r, where each block of 3
*              coefficients corresponds to an element of Zq[X]/(X^3 - zeta_i),
*              back to the coefficient representation in R_q.
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to input/output vector;
*                                       input NTT representation in the
*                                       product ring Zq[X]/(X^3 - zeta_i),
*                                       output coefficient representation
*                                       in R_q
*
* Returns:     none.
**************************************************/
void invntt(int16_t r[NTRUPLUS_N])
{
	int16_t t1,t2,t3;
	int16_t zeta1,zeta2;
	int k = 287;

	for (int step = 3; step <= 24; step <<= 1)
	{
		for (int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k--];

			for (int i = start; i < start + step; i++)
			{
				t1 = r[i + step];

				r[i + step] = fqmul(zeta1, t1 - r[i]);
				r[i       ] = barrett_reduce(r[i] + t1);
			}
		}
	}

	for (int step = 48; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for (int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta2 = zetas[k--];
			zeta1 = zetas[k--];

			for (int i = start; i < start + step; i++)
			{
				t1 = fqmul(NTRUPLUS_OMEGA, r[i +   step] - r[i]);
				t2 = fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
				t3 = fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
				
				r[i         ] = barrett_reduce(r[i] + r[i + step] + r[i + 2*step]);
				r[i +   step] = t2;			
				r[i + 2*step] = t3;
			}			
		}
	}
	
	for (int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = r[i] + r[i + NTRUPLUS_N/2];
		t2 = fqmul(NTRUPLUS_ZMINUSZ5INV, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = fqmul(NTRUPLUS_NINV, t1 - t2);
		r[i + NTRUPLUS_N/2] = fqmul(NTRUPLUS_2NINV, t2);
	}
}

/*************************************************
* Name:        baseinv
*
* Description: Inversion of a polynomial in Zq[X]/(X^3 - zeta), used as
*              a building block for inversion of elements in R_q in the
*              NTT domain.
*
* Arguments:   - int16_t r[3]:        pointer to the output polynomial
*              - const int16_t a[3]:  pointer to the input polynomial
*              - const int16_t zeta:  parameter defining X^3 - zeta
*
* Returns:     0 if a is invertible, 1 otherwise.
**************************************************/
int baseinv(int16_t r[3], const int16_t a[3], int16_t zeta)
{
	int16_t t;

	r[0] = montgomery_reduce(a[1]*a[2]);		   // R^-1
	r[1] = montgomery_reduce(a[2]*a[2]);		   // R^-1
	r[2] = montgomery_reduce(a[1]*a[1]-a[0]*a[2]); // R^-1
	r[0] = montgomery_reduce(a[0]*a[0]-r[0]*zeta); // R^-1
	r[1] = montgomery_reduce(r[1]*zeta-a[0]*a[1]); // R^-1

	t    = montgomery_reduce(r[2]*a[1]+r[1]*a[2]); // R^-2
	t    = montgomery_reduce(t*zeta+r[0]*a[0]);    // R^-2

	{ crypto_int16 iszero = crypto_int16_zero_mask(t);
	crypto_declassify(&iszero,sizeof iszero);
	if (iszero) return 1;
      }

	t   = fqinv(t); // R^4
	
	r[0]  = montgomery_reduce(r[0]*t); // R^0
	r[1]  = montgomery_reduce(r[1]*t); // R^0
	r[2]  = montgomery_reduce(r[2]*t); // R^0

	return 0;
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^3 - zeta),
*              used for multiplication of elements in R_q in the NTT domain.
*
* Arguments:   - int16_t r[3]:        pointer to the output polynomial
*              - const int16_t a[3]:  pointer to the first factor
*              - const int16_t b[3]:  pointer to the second factor
*              - const int16_t zeta:  parameter defining X^3 - zeta
*
* Returns:     none.
**************************************************/
void basemul(int16_t r[3], const int16_t a[3], const int16_t b[3], int16_t zeta)
{
	r[0] = montgomery_reduce(a[2]*b[1]+a[1]*b[2]); // R^-1
	r[1] = montgomery_reduce(a[2]*b[2]);		   // R^-1

	r[0] = montgomery_reduce(r[0]*zeta+a[0]*b[0]);		 	 // R^-1
	r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]); // R^-1
	r[2] = montgomery_reduce(a[2]*b[0]+a[1]*b[1]+a[0]*b[2]); // R^-1

	r[0] = montgomery_reduce(r[0]*NTRUPLUS_RSQ); // R^0
	r[1] = montgomery_reduce(r[1]*NTRUPLUS_RSQ); // R^0
	r[2] = montgomery_reduce(r[2]*NTRUPLUS_RSQ);	// R^0
}

/*************************************************
* Name:        basemul_add
*
* Description: Multiplication then addition of polynomials in
*              Zq[X]/(X^3 - zeta), used for multiplication of
*              elements in R_q in the NTT domain.
*
* Arguments:   - int16_t r[3]:        pointer to the output polynomial
*              - const int16_t a[3]:  pointer to the first factor
*              - const int16_t b[3]:  pointer to the second factor
*              - const int16_t c[3]:  pointer to the third factor
*              - const int16_t zeta:  parameter defining X^3 - zeta
*
* Returns:     none.
**************************************************/
void basemul_add(int16_t r[3], const int16_t a[3], const int16_t b[3], const int16_t c[3], int16_t zeta)
{
	r[0] = montgomery_reduce(a[2]*b[1]+a[1]*b[2]); // R^-1
	r[1] = montgomery_reduce(a[2]*b[2]);		   // R^-1

	r[0] = montgomery_reduce(r[0]*zeta+a[0]*b[0]);		 	 // R^-1
	r[1] = montgomery_reduce(r[1]*zeta+a[0]*b[1]+a[1]*b[0]); // R^-1
	r[2] = montgomery_reduce(a[2]*b[0]+a[1]*b[1]+a[0]*b[2]); // R^-1

	r[0] = montgomery_reduce(c[0]*NTRUPLUS_R + r[0]*NTRUPLUS_RSQ); // R^0
	r[1] = montgomery_reduce(c[1]*NTRUPLUS_R + r[1]*NTRUPLUS_RSQ); // R^0
	r[2] = montgomery_reduce(c[2]*NTRUPLUS_R + r[2]*NTRUPLUS_RSQ); // R^0
}
