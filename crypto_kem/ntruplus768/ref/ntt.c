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

#define NTRUPLUS_NINV         -811 // (n/d)^(-1) * R mod q
#define NTRUPLUS_2NINV       -1622 // 2 * (n/d)^(-1) * R mod q

// zetas: Montgomery-form twiddle factors
const int16_t zetas[192] = {
	 -147, -1033,  -682,  -248,  -708,   682,     1,  -722,
	 -723,  -257, -1124,  -867,  -256,  1484,  1262, -1590,
	 1611,   222,  1164, -1346,  1716, -1521,  -357,   395,
	 -455,   639,   502,   655,  -699,   541,    95, -1577,
	-1241,   550,   -44,    39,  -820,  -216,  -121,  -757,
	 -348,   937,   893,   387,  -603,  1713, -1105,  1058,
	 1449,   837,   901,  1637,  -569, -1617, -1530,  1199,
	   50,  -830,  -625,     4,   176,  -156,  1257, -1507,
	 -380,  -606,  1293,   661,  1428, -1580,  -565,  -992,
	  548,  -800,    64,  -371,   961,   641,    87,   630,
	  675,  -834,   205,    54, -1081,  1351,  1413, -1331,
	-1673, -1267, -1558,   281, -1464,  -588,  1015,   436,
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
*              where each block of 4 coefficients corresponds to an
*              element of Zq[X]/(X^4 - zeta_i).
*
* Arguments:   - int16_t r[NTRUPLUS_N]: pointer to input/output vector;
*                                       input coefficients of r in R_q,
*                                       output NTT representation in the
*                                       product ring Zq[X]/(X^4 - zeta_i)
*
* Returns:     none.
**************************************************/
void ntt(int16_t r[NTRUPLUS_N])
{
	int16_t t1, t2, t3;
	int16_t zeta1, zeta2;
	int k = 1;

	zeta1 = zetas[k++];

	for (int i = 0; i < NTRUPLUS_N / 2; i++)
	{
		t1 = fqmul(zeta1, r[i + NTRUPLUS_N / 2]);

		r[i + NTRUPLUS_N / 2] = r[i] + r[i + NTRUPLUS_N / 2] - t1;
		r[i                 ] = r[i]                         + t1;
	}

	for (int start = 0; start < NTRUPLUS_N; start += 384)
	{
		zeta1 = zetas[k++];
		zeta2 = zetas[k++];

		for (int i = start; i < start + 128; i++)
		{
			t1 = fqmul(zeta1, r[i + 128]);
			t2 = fqmul(zeta2, r[i + 256]);
			t3 = fqmul(NTRUPLUS_OMEGA, t1 - t2);

			r[i + 256] = r[i] - t1 - t3;
			r[i + 128] = r[i] - t2 + t3;
			r[i      ] = r[i] + t1 + t2;
		}		
	}

	for (int step = 64; step >= 4; step >>= 1)
	{
		for (int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k++];

			for (int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, r[i + step]);
				
				r[i + step] = r[i] - t1;
				r[i       ] = r[i] + t1;
			}
		}
	}

	for (int i = 0; i < NTRUPLUS_N; i++)
		r[i] = barrett_reduce(r[i]);
}

/*************************************************
* Name:        invntt
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
*                                       in R_q
*
* Returns:     none.
**************************************************/
void invntt(int16_t r[NTRUPLUS_N])
{
	int16_t t1, t2, t3;
	int16_t zeta1, zeta2;
	int k = 191;

	for (int step = 4; step <= 64; step <<= 1)
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

	for (int start = 0; start < NTRUPLUS_N; start += 384)
	{
		zeta2 = zetas[k--];
		zeta1 = zetas[k--];

		for (int i = start; i < start + 128; i++)
		{
			t1 = fqmul(NTRUPLUS_OMEGA, r[i + 128] - r[i]);
			t2 = fqmul(zeta1, r[i + 256] - r[i]       + t1);
			t3 = fqmul(zeta2, r[i + 256] - r[i + 128] - t1);
			
			r[i      ] = r[i] + r[i + 128] + r[i + 256];
			r[i + 128] = t2;			
			r[i + 256] = t3;
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
* Description: Inversion of a polynomial in Zq[X]/(X^4 - zeta), used as
*              a building block for inversion of elements in R_q in the
*              NTT domain.
*
* Arguments:   - int16_t r[4]:        pointer to the output polynomial
*              - const int16_t a[4]:  pointer to the input polynomial
*              - const int16_t zeta:  parameter defining X^4 - zeta
*
* Returns:     0 if a is invertible, 1 otherwise.
**************************************************/
int baseinv(int16_t r[4], const int16_t a[4], const int16_t zeta)
{
	int16_t t0, t1, t2, t3;
	
	t0 = montgomery_reduce(a[2]*a[2] - 2*a[1]*a[3]);            // R^-1
	t1 = montgomery_reduce(a[3]*a[3]);                          // R^-1
	t0 = montgomery_reduce(a[0]*a[0] + t0*zeta);                // R^-1
	t1 = montgomery_reduce(a[1]*a[1] + t1*zeta - 2*a[0]*a[2]);  // R^-1
	t2 = montgomery_reduce(t1*zeta);                            // R^-1
	
	t3 = montgomery_reduce(t0*t0 - t1*t2);  // R^-3

	{ crypto_int16 iszero = crypto_int16_zero_mask(t3);
	crypto_declassify(&iszero,sizeof iszero);
	if (iszero) return 1;
       }

	r[0] = montgomery_reduce(a[0]*t0 + a[2]*t2); // R^-2
	r[1] = montgomery_reduce(a[3]*t2 + a[1]*t0); // R^-2
	r[2] = montgomery_reduce(a[2]*t0 + a[0]*t1); // R^-2
	r[3] = montgomery_reduce(a[1]*t1 + a[3]*t0); // R^-2

	t3 = fqinv(t3); // R^5

	r[0] =  montgomery_reduce(r[0]*t3); // R^0
	r[1] = -montgomery_reduce(r[1]*t3); // R^0
	r[2] =  montgomery_reduce(r[2]*t3); // R^0
	r[3] = -montgomery_reduce(r[3]*t3); // R^0

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
void basemul(int16_t r[4], const int16_t a[4], const int16_t b[4], const int16_t zeta)
{
	int16_t t0 = montgomery_reduce(a[1]*b[3]+a[2]*b[2]+a[3]*b[1]); // R^-1
	int16_t t1 = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);           // R^-1
	int16_t t2 = montgomery_reduce(a[3]*b[3]);                     // R^-1

	int16_t c0 = montgomery_reduce(t0*zeta+a[0]*b[0]);                       // R^-1
	int16_t c1 = montgomery_reduce(t1*zeta+a[0]*b[1]+a[1]*b[0]);             // R^-1
	int16_t c2 = montgomery_reduce(t2*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]);   // R^-1
	int16_t c3 = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]); // R^-1

	r[0] = montgomery_reduce(c0*NTRUPLUS_RSQ); // R^0
	r[1] = montgomery_reduce(c1*NTRUPLUS_RSQ); // R^0
	r[2] = montgomery_reduce(c2*NTRUPLUS_RSQ); // R^0
	r[3] = montgomery_reduce(c3*NTRUPLUS_RSQ); // R^0
}

/*************************************************
* Name:        basemul_add
*
* Description: Multiplication then addition of polynomials in
*              Zq[X]/(X^4 - zeta), used for multiplication of
*              elements in R_q in the NTT domain.
*
* Arguments:   - int16_t r[4]:        pointer to the output polynomial
*              - const int16_t a[4]:  pointer to the first factor
*              - const int16_t b[4]:  pointer to the second factor
*              - const int16_t c[4]:  pointer to the third factor
*              - const int16_t zeta:  parameter defining X^4 - zeta
*
* Returns:     none.
**************************************************/
void basemul_add(int16_t r[4], const int16_t a[4], const int16_t b[4], const int16_t c[4], const int16_t zeta)
{
	int16_t t0 = montgomery_reduce(a[1]*b[3]+a[2]*b[2]+a[3]*b[1]); // R^-1
	int16_t t1 = montgomery_reduce(a[2]*b[3]+a[3]*b[2]);           // R^-1
	int16_t t2 = montgomery_reduce(a[3]*b[3]);                     // R^-1

	int16_t c0 = montgomery_reduce(t0*zeta+a[0]*b[0]);                       // R^-1
	int16_t c1 = montgomery_reduce(t1*zeta+a[0]*b[1]+a[1]*b[0]);             // R^-1
	int16_t c2 = montgomery_reduce(t2*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]);   // R^-1
	int16_t c3 = montgomery_reduce(a[0]*b[3]+a[1]*b[2]+a[2]*b[1]+a[3]*b[0]); // R^-1

	r[0] = montgomery_reduce(c[0]*NTRUPLUS_R + c0*NTRUPLUS_RSQ); // R^0
	r[1] = montgomery_reduce(c[1]*NTRUPLUS_R + c1*NTRUPLUS_RSQ); // R^0
	r[2] = montgomery_reduce(c[2]*NTRUPLUS_R + c2*NTRUPLUS_RSQ); // R^0
	r[3] = montgomery_reduce(c[3]*NTRUPLUS_R + c3*NTRUPLUS_RSQ); // R^0
}
