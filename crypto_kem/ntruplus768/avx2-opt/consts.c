/*
 * NTRU+768 AVX2 (avx2-opt): constant vectors and twiddle tables.
 * Official NTRU+ AVX2 consts.c without the vectors no kernel of this
 * package reads; zetas and zetas_inv keep only
 * the entries a kernel reads, in the layout described above each table.
 */
#include <stdint.h>
#include "params.h"
#include "consts.h"

#define QINV 12929
#define LOW ((1U << 12) - 1)
#define BARRETT_V(q) (((1U << 15) + (q)/2)/(q))
#define V BARRETT_V(NTRUPLUS_Q)

#define WQINV 13706
#define W -886
#define ZETA1 -722

#define NINV_SCALE 1679
#define NINV_SCALE_QINV 15375

#define MASK_5555 0x5555
#define MASK_0303 0x0303
#define MASK_0101 0x0101

#define FILL_16(x) { x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x }

const int16_t _low_mask[16]    __attribute__((aligned(32))) = FILL_16(LOW);
const int16_t _16xv[16]        __attribute__((aligned(32))) = FILL_16(V);
const int16_t _16xq[16]        __attribute__((aligned(32))) = FILL_16(NTRUPLUS_Q);
const int16_t _16xqm1[16]      __attribute__((aligned(32))) = FILL_16(NTRUPLUS_Q - 1);
const int16_t _16xzeta1[16]    __attribute__((aligned(32))) = FILL_16(ZETA1);
const int16_t _16xqinv[16]     __attribute__((aligned(32))) = FILL_16(QINV);
const int16_t _16xw[16]        __attribute__((aligned(32))) = FILL_16(W);
const int16_t _16xwqinv[16]    __attribute__((aligned(32))) = FILL_16(WQINV);
const int16_t _16xNinv_scale[16]     __attribute__((aligned(32))) = FILL_16(NINV_SCALE);
const int16_t _16xNinv_scaleqinv[16] __attribute__((aligned(32))) = FILL_16(NINV_SCALE_QINV);

const int16_t _16x5555[16]     __attribute__((aligned(32))) = FILL_16(MASK_5555);
const int16_t _16x0303[16]     __attribute__((aligned(32))) = FILL_16(MASK_0303);
const int16_t _16x0101[16]     __attribute__((aligned(32))) = FILL_16(MASK_0101);

/*
 * zetas: the 216 of Official's 816 entries that a kernel reads; no
 * kernel reads the others (docs/IMPLEMENTATION.md, section 12):
 *   [0, 192) = Official zetas[624..815]:
 *       poly_basemul_montgomery, poly_basemul_scale and poly_baseinv_1: per
 *       loop iteration (128 coefficients) 32 entries, 16 x zeta*qinv then 16 x
 *       zeta
 *   [192, 216) = Official zetas[20..43]:
 *       poly_ntt level 2: per iteration two broadcast dwords, zeta*qinv twice,
 *       then zeta twice
 */
const int16_t zetas[216] __attribute__((aligned(32))) = {
	  -417, -32398,   5213, -21005,  -6711,  32759,  18351, -16266,
	-23147,   4133,  -5573,  13877,  20758, -16910, -30104,  14768,
	   223,   1138,  -1059,   -397,   -183,   1655,    559,  -1674,
	   277,    933,   1723,    437,  -1514,    242,   1640,    432,
	-19375,  20152, -19962, -22521,  -7905,  26370,    512,  30825,
	-26711, -28455, -26559,  -4758, -12758, -11033,  -4360,   6844,
	 -1583,    696,    774,   1671,    927,    514,    512,    489,
	   297,    601,   1473,   1130,   1322,    871,    760,   1212,
	 29384, -29024,  25915,   2351, -27640, -26142,  17820,  31868,
	 -7583,  -5194,  29251,   -607, -26692,  23659,   5972,  31943,
	  -312,   -352,    443,    943,      8,   1250,   -100,   1660,
	   -31,   1206,  -1341,  -1247,    444,    235,   1364,  -1209,
	 14313,  24550, -15071, -11962,  -2047,   7773,  25593, -31621,
	-24834,  19033, -17251,  24228,  17441, -27375, -21403,  14502,
	   361,    230,    673,    582,   1409,   1501,   1401,    251,
	  1022,  -1063,   1053,   1188,    417,  -1391,    -27,  -1626,
	 27413,  -9403, -14976, -13536,  -5744,   3602, -26503,  20512,
	 14066,   2427,  20777, -30332, -23886,   3299, -29100,  24303,
	  1685,   -315,   1408,  -1248,    400,    274,  -1543,     32,
	 -1550,   1531,  -1367,   -124,   1458,   1379,   -940,  -1681,
	 22294,  10029, -16531, -27052, -10654,   6464,   2104,  17498,
	 -7867,   -474,     38, -26844,  -1479,  -1668,  18484,  20853,
	    22,   1709,   -275,   1108,    354,  -1728,   -968,    858,
	  1221,   -218,    294,   -732,  -1095,    892,   1588,   -779,
	 12929,  12929,      1,      1, -28626, -28626,   -722,   -722,
	 23981,  23981,   -723,   -723,  19583,  19583,   -257,   -257,
	 16796,  16796,  -1124,  -1124,  -2787,  -2787,   -867,   -867
};

/*
 * zetas_inv: the 4 of Official's 816 entries that a kernel reads; no
 * kernel reads the others (docs/IMPLEMENTATION.md, section 12):
 *   [0, 4) = Official zetas_inv[808..811]:
 *       poly_invntt_crepmod3 level 0: two broadcast dwords, (z-z^5)^-1*qinv
 *       twice, then (z-z^5)^-1 twice
 */
const int16_t zetas_inv[4] __attribute__((aligned(32))) = {
	-30977, -30977,  -1665,  -1665
};
