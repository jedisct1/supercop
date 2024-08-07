#include "params.h"
#include "reduce.h"
#include "ntt.h"

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
    -1586,   637,  -680,  -917,   644,  -372, -1193, -1136};

/*************************************************
* Name:        fqmul
*
* Description: Multiplication followed by Montgomery reduction
*
* Arguments:   - int16_t a: first factor
*              - int16_t b: second factor
*
* Returns 16-bit integer congruent to a*b*R^{-1} mod q
**************************************************/
static int16_t fqmul(int16_t a, int16_t b)
{
  return montgomery_reduce((int32_t)a*b);
}

/*************************************************
* Name:        fqinv
*
* Description: Inversion
*
* Arguments:   - int16_t a: first factor a = x * R^2 mod q
*
* Returns 16-bit integer congruent to x^{-1} * R^4 mod q
**************************************************/
static int16_t fqinv(int16_t a)
{
	int16_t t = a;

	for(int i = 1; i <= 11; i++)
	{
		t = fqmul(t, t);
		if(i != 2 && i != 4) t = fqmul(t, a);
	}

	return t;
}

/*************************************************
* Name:        ntt
*
* Description: number-theoretic transform (NTT) in Rq.
*
* Arguments:   - int16_t b[NTRUPLUS_N]: pointer to output vector of elements of Zq
*              - int16_t a[NTRUPLUS_N]: pointer to input vector of elements of Zq
**************************************************/
void ntt(int16_t b[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3;
	int16_t zeta1,zeta2;
	int k = 1;

	zeta1 = zetas[k++];

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = fqmul(zeta1, a[i + NTRUPLUS_N/2]);

		b[i + NTRUPLUS_N/2] = a[i] + a[i + NTRUPLUS_N/2] - t1;
		b[i               ] = a[i]                       + t1;
	}

	for(int step = NTRUPLUS_N/6; step >= 48; step = step/3)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta1 = zetas[k++];
			zeta2 = zetas[k++];

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, b[i +   step]);
				t2 = fqmul(zeta2, b[i + 2*step]);
				t3 = fqmul(2571, t1 - t2);
	
				b[i + 2*step] = b[i] - t1 - t3;
				b[i +   step] = b[i] - t2 + t3;
				b[i         ] = b[i] + t1 + t2;
			}
		}
	}

	for(int step = 24; step >= 3; step >>= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k++];

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(zeta1, b[i + step]);
				
				b[i + step] = b[i] - t1;
				b[i       ] = b[i] + t1;
			}
		}
	}
}

/*************************************************
* Name:        invntt
*
* Description: inverse number-theoretic transform in Rq and
*              multiplication by Montgomery factor R = 2^16.
*
* Arguments:   - int16_t b[NTRUPLUS_N]: pointer to output vector of elements of Zq
*              - int16_t a[NTRUPLUS_N]: pointer to input vector of elements of Zq
**************************************************/
void invntt(int16_t r[NTRUPLUS_N], const int16_t a[NTRUPLUS_N])
{
	int16_t t1,t2,t3;
	int16_t zeta1,zeta2;
	int k = 287;

	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		r[i] = a[i];
	}

	for(int step = 3; step <= 24; step <<= 1)
	{
		for(int start = 0; start < NTRUPLUS_N; start += (step << 1))
		{
			zeta1 = zetas[k--];

			for(int i = start; i < start + step; i++)
			{
				t1 = r[i + step];

				r[i + step] = barrett_reduce(fqmul(zeta1, t1 - r[i]));
				r[i       ] = barrett_reduce(r[i] + t1);
			}
		}
	}

	for(int step = 48; step <= NTRUPLUS_N/6; step = 3*step)
	{
		for(int start = 0; start < NTRUPLUS_N; start += 3*step)
		{
			zeta2 = zetas[k--];
			zeta1 = zetas[k--];

			for(int i = start; i < start + step; i++)
			{
				t1 = fqmul(2571,  r[i +   step] - r[i]);
				t2 = fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
				t3 = fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
				
				r[i         ] = r[i] + r[i + step] + r[i + 2*step];
				r[i +   step] = t2;			
				r[i + 2*step] = t3;
			}			
		}
	}
	
	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = r[i] + r[i + NTRUPLUS_N/2];
		t2 = fqmul(1792, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = fqmul(3424, t1 - t2);
		r[i + NTRUPLUS_N/2] = fqmul(3391, t2);	
	}
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^3-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t c[3]: pointer to the output polynomial
*              - const int16_t a[3]: pointer to the first factor
*              - const int16_t b[3]: pointer to the second factor
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
void basemul(int16_t c[3], const int16_t a[3], const int16_t b[3], int16_t zeta)
{
	c[0]  = fqmul(a[2], b[1]);
	c[0] += fqmul(a[1], b[2]);
	c[0]  = fqmul(c[0], zeta);
	c[0] += fqmul(a[0], b[0]);

	c[1]  = fqmul(a[2], b[2]);
	c[1]  = fqmul(c[1], zeta);
	c[1] += fqmul(a[0], b[1]);
	c[1] += fqmul(a[1], b[0]);
	c[1]  = barrett_reduce(c[1]);

	c[2]  = fqmul(a[2], b[0]);
	c[2] += fqmul(a[1], b[1]);
	c[2] += fqmul(a[0], b[2]);
	c[2]  = barrett_reduce(c[2]);
}

/*************************************************
* Name:        baseinv
*
* Description: Inversion of polynomial in Zq[X]/(X^3-zeta)
*              used for inversion of element in Rq in NTT domain
*
* Arguments:   - int16_t b[3]: pointer to the output polynomial
*              - const int16_t a[3]: pointer to the input polynomial
*              - int16_t zeta: integer defining the reduction polynomial
**************************************************/
int baseinv(int16_t b[3], const int16_t a[3], int16_t zeta)
{
	int16_t det, t;
	int r;

	b[0]  = fqmul(a[0], a[0]);
	t     = fqmul(a[1], a[2]);
	t     = fqmul(t, zeta);
	b[0] -= t;

	b[1]  = fqmul(a[2], a[2]);
	b[1]  = fqmul(b[1], zeta);
	t     = fqmul(a[0], a[1]);
	b[1] -= t;

	b[2]  = fqmul(a[1], a[1]);
	t     = fqmul(a[0], a[2]);
	b[2] -= t;

	det   = fqmul(b[2], a[1]);
	t     = fqmul(b[1], a[2]);
	det  += t;
	det   = fqmul(det, zeta); 
	t     = fqmul(b[0], a[0]);
	det  += t;

	det   = fqinv(det);
	b[0]  = fqmul(b[0], det);
	b[1]  = fqmul(b[1], det);
	b[2]  = fqmul(b[2], det);

	r = (uint16_t)det;
	r = (uint32_t)(-r) >> 31;

	return r - 1;
}
