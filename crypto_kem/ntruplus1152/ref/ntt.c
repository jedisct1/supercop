#include "params.h"
#include "reduce.h"
#include "ntt.h"

const int16_t zetas[384] = {
	 -147, -1033, -1265,   708,   460,  1265,   722,   723,
        1,  -867,   257,  1124,  1590,  1262,  -222,  1611,
     -256,  1484,  -357,   395, -1346, -1164, -1521, -1716,
     1577,    95,   699,  -541,    39,    44, -1241,   550,
     -455,   639,  -502,  -655,   603, -1713, -1105,  1058,
     -121,  -757,   216,  -820,  -893,  -387,   937,   348,
     1507,  1257,  -176,   156,  -830,   -50,    -4,  -625,
      565,   992, -1580, -1428,  -380,  -606, -1293,  -661,
    -1449,  -837,   901,  1637,  1617,  -569,  1199,  1530,
     1267, -1673,   281,  1558, -1464,  -588, -1015,  -436,
     -961,  -641,    87,   630,   371,    64,  -548,   800,
     1351,  1081,  1331,  1413,  -205,   -54,  -834,  -675,
    -1212,   760, -1322,  -871,   601,  -297, -1130,  1473,
     -774, -1671,   696,  1583,  -489,   512,  -927,  -514,
     -235,   444, -1209, -1364, -1341, -1247, -1206,   -31,
      312,   352,   443,   943, -1250,     8,  1660,   100,
    -1138,   223,  -397,  1059,  -183,  1655,  -559,  1674,
      437, -1723,   277,   933, -1640,  -432,   242,  1514,
    -1108,  -275,   -22, -1709,  -968,   858,  1728,   354,
    -1221,   218,   294,  -732,  -892, -1095,  -779, -1588,
     1063,  1022,  1188, -1053,   417, -1391,    27,  1626,
      251, -1401,  1409,  1501,  -230,   361,   582,  -673,
     1367,   124,  1531,  1550,  1681,  -940, -1458, -1379,
      274,  -400,   -32, -1543, -1408,  1248,  -315, -1685,
      664,    40,  1386,   500, -1242,  1258, -1697, -1560,
      869,    94, -1237,  1175,   884,  -155,   679,  -209,
    -1025,  -270,  -713,    82,  -259,   151, -1509,   159,
      184,  1094, -1157,  -153,   947,   182,  -262, -1182,
       83,     5,  -691, -1666,   709,  -707,   220,  -195,
     1405,   876, -1451,   579, -1618,  1277,   517,   406,
      304,  -898,   343,  -854,  1264,   451, -1485,   452,
       23,  1001, -1441,   413, -1178,   887,  -897, -1012,
    -1286,  1297,  1210,   656,  1385,  1208, -1701,  1272,
     1472, -1619,  1115, -1224,   662,  1456,  1361,   915,
       38,   752,   475,  -971,   158, -1240, -1482, -1672,
      435,  -307,   252,  1348,   717,   543,   320,  1602,
      977,  -316,   113,  -493,  1515,  -950,   -76, -1504,
     1086, -1434,  -253,  -640,  -761,  -504,  -870,   614,
     -545, -1324, -1627,   735,  1009,  1227,   513,  -219,
     1312,  1037,  -885,   863,  -913,   -55,   687,  1041,
     -310,  1689,  -418, -1358, -1107,  -983,  1719,  -188,
     1000,   685, -1328,   -80,   337,   -63,  -973,   941,
      364,  1563,  1093,   524,  -306, -1143,  -368,  1269,
      164,  1426, -1407,   540,   318,  -439,   518,  -302,
     -903,  -221,   812, -1034,  1158,  -555,   647,  1705,
      125,  1382,  -166,   -10,  -390,  -440, -1418,  1414,
    -1683, -1101,  1433, -1663,   826,  -575,   -46,  1455,
    -1708,  -686,  -608, -1661,   904,  -487,   929,  -902};

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
* Arguments:   - int16_t a: first factor a = x * R mod q
*
* Returns 16-bit integer congruent to x^{-1} * R^3 mod q
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

	for(int start = 0; start < NTRUPLUS_N; start += 576)
	{
		zeta1 = zetas[k++];
		zeta2 = zetas[k++];

		for(int i = start; i < start + 192; i++)
		{
			t1 = fqmul(zeta1, b[i + 192]);
			t2 = fqmul(zeta2, b[i + 384]);
			t3 = fqmul(2571, t1 - t2);

			b[i + 384] = b[i] - t1 - t3;
			b[i + 192] = b[i] - t2 + t3;
			b[i      ] = b[i] + t1 + t2;
		}		
	}

	for(int step = 96; step >= 3; step >>= 1)
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
	int k = 383;

	for(int i = 0; i < NTRUPLUS_N; i++)
	{
		r[i] = a[i];
	}

	for(int step = 3; step <= 96; step <<= 1)
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

	for(int start = 0; start < NTRUPLUS_N; start += 576)
	{
		zeta2 = zetas[k--];
		zeta1 = zetas[k--];

		for(int i = start; i < start + 192; i++)
		{
			t1 = fqmul(2571,  r[i + 192] - r[i]);
			t2 = fqmul(zeta1, r[i + 384] - r[i]       + t1);
			t3 = fqmul(zeta2, r[i + 384] - r[i + 192] - t1);
			
			r[i      ] = r[i] + r[i + 192] + r[i + 384];
			r[i + 192] = t2;			
			r[i + 384] = t3;
		}
	}

	for(int i = 0; i < NTRUPLUS_N/2; i++)
	{
		t1 = r[i] + r[i + NTRUPLUS_N/2];
		t2 = fqmul(1792, r[i] - r[i + NTRUPLUS_N/2]);

		r[i               ] = fqmul(2568, t1 - t2);
		r[i + NTRUPLUS_N/2] = fqmul(1679, t2);	
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
* Name:        basemul
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
