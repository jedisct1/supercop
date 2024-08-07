#include "params.h"
#include "packing.h"
#include "poly.h"
#include <string.h>

#ifdef DBENCH
#include "test/cpucycles.h"
extern const uint64_t timing_overhead;
extern uint64_t *tred, *tadd, *tmul, *tround, *tsample, *tpack;
#define DBENCH_START() uint64_t time = cpucycles()
#define DBENCH_STOP(t) t += cpucycles() - time - timing_overhead
#else
#define DBENCH_START()
#define DBENCH_STOP(t)
#endif

void polyeta_pack(uint8_t *r, const poly *a)
{
	unsigned int i, nbytes;
	uint8_t t[8];
	DBENCH_START();

#if N == 1152
	nbytes = 144;
#elif N == 1536
	nbytes = 192;
#elif N == 2304
	nbytes = 288;
#endif

	for(i = 0 ; i < nbytes ; i++)
	{
		t[0] = ETA - a->coeffs[8*i+0];
		t[1] = ETA - a->coeffs[8*i+1];
		t[2] = ETA - a->coeffs[8*i+2];
		t[3] = ETA - a->coeffs[8*i+3];
		t[4] = ETA - a->coeffs[8*i+4];
		t[5] = ETA - a->coeffs[8*i+5];
		t[6] = ETA - a->coeffs[8*i+6];
		t[7] = ETA - a->coeffs[8*i+7];

		r[3*i+0]  = (t[0] >> 0) | (t[1] << 3) | (t[2] << 6);
		r[3*i+1]  = (t[2] >> 2) | (t[3] << 1) | (t[4] << 4) | (t[5] << 7);
		r[3*i+2]  = (t[5] >> 1) | (t[6] << 2) | (t[7] << 5);
	}
	DBENCH_STOP(*tpack);
}

void polyeta_unpack(poly *r, const uint8_t *a)
{
	unsigned int i, nbytes;
	DBENCH_START();

#if N == 1152
	nbytes = 144;
#elif N == 1536
	nbytes = 192;
#elif N == 2304
	nbytes = 288;
#endif

	for(i = 0 ; i < nbytes ; i++)
	{
		r->coeffs[8*i+0] =  (a[3*i+0] >> 0) & 7;
		r->coeffs[8*i+1] =  (a[3*i+0] >> 3) & 7;
		r->coeffs[8*i+2] = ((a[3*i+0] >> 6) | (a[3*i+1] << 2)) & 7;
		r->coeffs[8*i+3] =  (a[3*i+1] >> 1) & 7;
		r->coeffs[8*i+4] =  (a[3*i+1] >> 4) & 7;
		r->coeffs[8*i+5] = ((a[3*i+1] >> 7) | (a[3*i+2] << 1)) & 7;
		r->coeffs[8*i+6] =  (a[3*i+2] >> 2) & 7;
		r->coeffs[8*i+7] =  (a[3*i+2] >> 5) & 7;

		r->coeffs[8*i+0] = ETA - r->coeffs[8*i+0];
		r->coeffs[8*i+1] = ETA - r->coeffs[8*i+1];
		r->coeffs[8*i+2] = ETA - r->coeffs[8*i+2];
		r->coeffs[8*i+3] = ETA - r->coeffs[8*i+3];
		r->coeffs[8*i+4] = ETA - r->coeffs[8*i+4];
		r->coeffs[8*i+5] = ETA - r->coeffs[8*i+5];
		r->coeffs[8*i+6] = ETA - r->coeffs[8*i+6];
		r->coeffs[8*i+7] = ETA - r->coeffs[8*i+7];
	}
	DBENCH_STOP(*tpack);
}

void polyt1_pack(uint8_t *r, const poly *a)
{
	unsigned int i;
	DBENCH_START();

#if N == 1152
	for(i = 0 ; i < 576 ; i++)
	{
		r[3*i+0] = (a->coeffs[2*i] >> 0);
		r[3*i+1] = (a->coeffs[2*i] >> 8) | (a->coeffs[2*i+1] << 4);
		r[3*i+2] = (a->coeffs[2*i+1] >> 4);
	}
#elif N == 1536
	for(i = 0 ; i < 768 ; i++)
	{
		r[3*i+0] = (a->coeffs[2*i] >> 0);
		r[3*i+1] = (a->coeffs[2*i] >> 8) | (a->coeffs[2*i+1] << 4);
		r[3*i+2] = (a->coeffs[2*i+1] >> 4);
	}
#elif N == 2304
	for(i = 0 ; i < 288 ; i++)
	{ //11
		r[11*i+ 0] = (a->coeffs[8*i+0] >>  0);
		r[11*i+ 1] = (a->coeffs[8*i+0] >>  8) | (a->coeffs[8*i+1] << 3);
		r[11*i+ 2] = (a->coeffs[8*i+1] >>  5) | (a->coeffs[8*i+2] << 6);
		r[11*i+ 3] = (a->coeffs[8*i+2] >>  2);
		r[11*i+ 4] = (a->coeffs[8*i+2] >> 10) | (a->coeffs[8*i+3] << 1);
		r[11*i+ 5] = (a->coeffs[8*i+3] >>  7) | (a->coeffs[8*i+4] << 4);
		r[11*i+ 6] = (a->coeffs[8*i+4] >>  4) | (a->coeffs[8*i+5] << 7);
		r[11*i+ 7] = (a->coeffs[8*i+5] >>  1);
		r[11*i+ 8] = (a->coeffs[8*i+5] >>  9) | (a->coeffs[8*i+6] << 2);
		r[11*i+ 9] = (a->coeffs[8*i+6] >>  6) | (a->coeffs[8*i+7] << 5);
		r[11*i+10] = (a->coeffs[8*i+7] >>  3);
	}
	#endif

	DBENCH_STOP(*tpack);
}

void polyt1_unpack(poly *r, const uint8_t *a)
{
	unsigned int i;
	DBENCH_START();

#if N == 1152
	for(i = 0 ; i < 576 ; i++)
	{
		r->coeffs[2*i+0] = ((a[3*i+0] >> 0) | ((uint32_t)a[3*i+1] << 8)) & 0xFFF;
		r->coeffs[2*i+1] = ((a[3*i+1] >> 4) | ((uint32_t)a[3*i+2] << 4)) & 0xFFF;
	}
#elif N == 1536
	for(i = 0 ; i < 768 ; i++)
	{
		r->coeffs[2*i+0] = ((a[3*i+0] >> 0) | ((uint32_t)a[3*i+1] << 8)) & 0xFFF;
		r->coeffs[2*i+1] = ((a[3*i+1] >> 4) | ((uint32_t)a[3*i+2] << 4)) & 0xFFF;
	}
#elif N == 2304
	for(i = 0 ; i < 288 ; i++)
	{
		r->coeffs[8*i+0] = ((a[11*i+0] >> 0) | ((uint32_t)a[11*i+ 1] << 8)) & 0x7FF;
		r->coeffs[8*i+1] = ((a[11*i+1] >> 3) | ((uint32_t)a[11*i+ 2] << 5)) & 0x7FF;
		r->coeffs[8*i+2] = ((a[11*i+2] >> 6) | ((uint32_t)a[11*i+ 3] << 2) | ((uint32_t)a[11*i+4] << 10 )) & 0x7FF;
		r->coeffs[8*i+3] = ((a[11*i+4] >> 1) | ((uint32_t)a[11*i+ 5] << 7)) & 0x7FF;
		r->coeffs[8*i+4] = ((a[11*i+5] >> 4) | ((uint32_t)a[11*i+ 6] << 4)) & 0x7FF;
		r->coeffs[8*i+5] = ((a[11*i+6] >> 7) | ((uint32_t)a[11*i+ 7] << 1) | ((uint32_t)a[11*i+8] <<  9)) & 0x7FF;
		r->coeffs[8*i+6] = ((a[11*i+8] >> 2) | ((uint32_t)a[11*i+ 9] << 6)) & 0x7FF;
		r->coeffs[8*i+7] = ((a[11*i+9] >> 5) | ((uint32_t)a[11*i+10] << 3)) & 0x7FF;
	}
#endif
	DBENCH_STOP(*tpack);
}

void polyt0_pack(uint8_t *r, const poly *a)
{
	unsigned int i;
#if N == 2304
	uint32_t t[8];
#else
	uint32_t t[2];
#endif
	DBENCH_START();
#if N == 1152
	for(i = 0 ; i < 576 ; i++)
	{
		t[0] = (1 << 11) - a->coeffs[2*i+0];
		t[1] = (1 << 11) - a->coeffs[2*i+1];

		r[3*i+0] = (t[0] >> 0);
		r[3*i+1] = (t[0] >> 8) | (t[1] << 4);
		r[3*i+2] = (t[1] >> 4);
	}
#elif N == 1536
	for(i = 0 ; i < 768 ; i++)
	{
		t[0] = (1 << 11) - a->coeffs[2*i+0];
		t[1] = (1 << 11) - a->coeffs[2*i+1];

		r[3*i+0] = (t[0] >> 0);
		r[3*i+1] = (t[0] >> 8) | (t[1] << 4);
		r[3*i+2] = (t[1] >> 4);
	}
#elif N == 2304
	for(i = 0 ; i < 288 ; i++)
	{
		t[0] = (1 << 12) - a->coeffs[8*i+0];
		t[1] = (1 << 12) - a->coeffs[8*i+1];
		t[2] = (1 << 12) - a->coeffs[8*i+2];
		t[3] = (1 << 12) - a->coeffs[8*i+3];
		t[4] = (1 << 12) - a->coeffs[8*i+4];
		t[5] = (1 << 12) - a->coeffs[8*i+5];
		t[6] = (1 << 12) - a->coeffs[8*i+6];
		t[7] = (1 << 12) - a->coeffs[8*i+7];

		r[13*i+ 0] = (t[0] >>  0);
		r[13*i+ 1] = (t[0] >>  8) | (t[1] << 5);
		r[13*i+ 2] = (t[1] >>  3);
		r[13*i+ 3] = (t[1] >> 11) | (t[2] << 2);
		r[13*i+ 4] = (t[2] >>  6) | (t[3] << 7);
		r[13*i+ 5] = (t[3] >>  1);
		r[13*i+ 6] = (t[3] >>  9) | (t[4] << 4);
		r[13*i+ 7] = (t[4] >>  4);
		r[13*i+ 8] = (t[4] >> 12) | (t[5] << 1);
		r[13*i+ 9] = (t[5] >>  7) | (t[6] << 6);
		r[13*i+10] = (t[6] >>  2);
		r[13*i+11] = (t[6] >> 10) | (t[7] << 3);
		r[13*i+12] = (t[7] >>  5);
	}
#endif
	DBENCH_STOP(*tpack);
}

void polyt0_unpack(poly *r, const uint8_t *a)
{
	unsigned int i;
	DBENCH_START();
#if N == 1152
	for(i = 0 ; i < 576 ; i++)
	{
		r->coeffs[2*i+0] = ((a[3*i+0] >> 0) | ((uint32_t)a[3*i+1] << 8)) & 0xFFF;
		r->coeffs[2*i+1] = ((a[3*i+1] >> 4) | ((uint32_t)a[3*i+2] << 4)) & 0xFFF;

		r->coeffs[2*i+0] = (1 << 11) - r->coeffs[2*i+0];
		r->coeffs[2*i+1] = (1 << 11) - r->coeffs[2*i+1];
	}
#elif N == 1536
	for(i = 0 ; i < 768 ; i++)
	{
		r->coeffs[2*i+0] = ((a[3*i+0] >> 0) | ((uint32_t)a[3*i+1] << 8)) & 0xFFF;
		r->coeffs[2*i+1] = ((a[3*i+1] >> 4) | ((uint32_t)a[3*i+2] << 4)) & 0xFFF;

		r->coeffs[2*i+0] = (1 << 11) - r->coeffs[2*i+0];
		r->coeffs[2*i+1] = (1 << 11) - r->coeffs[2*i+1];
	}
#elif N == 2304
	for(i = 0 ; i < 288 ; i++)
	{
		r->coeffs[8*i+0] = ((a[13*i+ 0] >> 0) | ((uint32_t)a[13*i+ 1] << 8)) & 0x1FFF;
		r->coeffs[8*i+1] =(((a[13*i+ 1] >> 5) | ((uint32_t)a[13*i+ 2] << 3)) | ((uint32_t)a[13*i+ 3] << 11)) & 0x1FFF;
		r->coeffs[8*i+2] = ((a[13*i+ 3] >> 2) | ((uint32_t)a[13*i+ 4] << 6)) & 0x1FFF;
		r->coeffs[8*i+3] =(((a[13*i+ 4] >> 7) | ((uint32_t)a[13*i+ 5] << 1)) | ((uint32_t)a[13*i+ 6] <<  9)) & 0x1FFF;
		r->coeffs[8*i+4] =(((a[13*i+ 6] >> 4) | ((uint32_t)a[13*i+ 7] << 4)) | ((uint32_t)a[13*i+ 8] << 12)) & 0x1FFF;
		r->coeffs[8*i+5] = ((a[13*i+ 8] >> 1) | ((uint32_t)a[13*i+ 9] << 7)) & 0x1FFF;
		r->coeffs[8*i+6] =(((a[13*i+ 9] >> 6) | ((uint32_t)a[13*i+10] << 2)) | ((uint32_t)a[13*i+11] << 10)) & 0x1FFF;
		r->coeffs[8*i+7] = ((a[13*i+11] >> 3) | ((uint32_t)a[13*i+12] << 5)) & 0x1FFF;

		r->coeffs[8*i+0] = (1 << 12) - r->coeffs[8*i+0];
		r->coeffs[8*i+1] = (1 << 12) - r->coeffs[8*i+1];
		r->coeffs[8*i+2] = (1 << 12) - r->coeffs[8*i+2];
		r->coeffs[8*i+3] = (1 << 12) - r->coeffs[8*i+3];
		r->coeffs[8*i+4] = (1 << 12) - r->coeffs[8*i+4];
		r->coeffs[8*i+5] = (1 << 12) - r->coeffs[8*i+5];
		r->coeffs[8*i+6] = (1 << 12) - r->coeffs[8*i+6];
		r->coeffs[8*i+7] = (1 << 12) - r->coeffs[8*i+7];
	}
#endif
	DBENCH_STOP(*tpack);
}

void polyz_pack(uint8_t *r, const poly *a)
{
	unsigned int i;
	DBENCH_START();

#if N == 1152
	uint32_t t[8];

	for(i = 0 ; i < 144 ; i++)
	{
		t[0] = GAMMA1 - a->coeffs[8*i+0];
		t[1] = GAMMA1 - a->coeffs[8*i+1];
		t[2] = GAMMA1 - a->coeffs[8*i+2];
		t[3] = GAMMA1 - a->coeffs[8*i+3];
		t[4] = GAMMA1 - a->coeffs[8*i+4];
		t[5] = GAMMA1 - a->coeffs[8*i+5];
		t[6] = GAMMA1 - a->coeffs[8*i+6];
		t[7] = GAMMA1 - a->coeffs[8*i+7];

		r[19*i+0] = (t[0] >> 0);
		r[19*i+1] = (t[0] >> 8);
		r[19*i+2] = (t[0] >> 16) | (t[1] << 3);
		r[19*i+3] = (t[1] >> 5);
		r[19*i+4] = (t[1] >> 13) | (t[2] << 6);
		r[19*i+5] = (t[2] >> 2);
		r[19*i+6] = (t[2] >> 10);
		r[19*i+7] = (t[2] >> 18) | (t[3] << 1);
		r[19*i+8] = (t[3] >> 7);
		r[19*i+9] = (t[3] >> 15) | (t[4] << 4);
		r[19*i+10] = (t[4] >> 4);
		r[19*i+11] = (t[4] >> 12) | (t[5] << 7);
		r[19*i+12] = (t[5] >> 1);
		r[19*i+13] = (t[5] >> 9);
		r[19*i+14] = (t[5] >> 17) | (t[6] << 2);
		r[19*i+15] = (t[6] >> 6);
		r[19*i+16] = (t[6] >> 14) | (t[7] << 5);
		r[19*i+17] = (t[7] >> 3);
		r[19*i+18] = (t[7] >> 11);
	}
#elif N == 1536
	uint32_t t[8];

	for(i = 0 ; i < 192 ; i++)
	{
		t[0] = GAMMA1 - a->coeffs[8*i+0];
		t[1] = GAMMA1 - a->coeffs[8*i+1];
		t[2] = GAMMA1 - a->coeffs[8*i+2];
		t[3] = GAMMA1 - a->coeffs[8*i+3];
		t[4] = GAMMA1 - a->coeffs[8*i+4];
		t[5] = GAMMA1 - a->coeffs[8*i+5];
		t[6] = GAMMA1 - a->coeffs[8*i+6];
		t[7] = GAMMA1 - a->coeffs[8*i+7];

		r[19*i+0] = (t[0] >> 0);
		r[19*i+1] = (t[0] >> 8);
		r[19*i+2] = (t[0] >> 16) | (t[1] << 3);
		r[19*i+3] = (t[1] >> 5);
		r[19*i+4] = (t[1] >> 13) | (t[2] << 6);
		r[19*i+5] = (t[2] >> 2);
		r[19*i+6] = (t[2] >> 10);
		r[19*i+7] = (t[2] >> 18) | (t[3] << 1);
		r[19*i+8] = (t[3] >> 7);
		r[19*i+9] = (t[3] >> 15) | (t[4] << 4);
		r[19*i+10] = (t[4] >> 4);
		r[19*i+11] = (t[4] >> 12) | (t[5] << 7);
		r[19*i+12] = (t[5] >> 1);
		r[19*i+13] = (t[5] >> 9);
		r[19*i+14] = (t[5] >> 17) | (t[6] << 2);
		r[19*i+15] = (t[6] >> 6);
		r[19*i+16] = (t[6] >> 14) | (t[7] << 5);
		r[19*i+17] = (t[7] >> 3);
		r[19*i+18] = (t[7] >> 11);
	}
#elif N == 2304
	uint32_t t[2];

	for(i = 0 ; i < 1152 ; i++)
	{
		t[0] = GAMMA1 - a->coeffs[2*i+0];
		t[1] = GAMMA1 - a->coeffs[2*i+1];

		r[5*i+0] = (t[0] >> 0);
		r[5*i+1] = (t[0] >> 8);
		r[5*i+2] = (t[0] >> 16) | (t[1] << 4);
		r[5*i+3] = (t[1] >> 4);
		r[5*i+4] = (t[1] >> 12);
	}
#endif
	DBENCH_STOP(*tpack);
}

void polyz_unpack(poly *r, const uint8_t *a)
{
	unsigned int i;
	DBENCH_START();

#if N == 1152
	for(i = 0 ; i < 144 ; i++)
	{
		r->coeffs[8*i+0] = ((a[19*i+ 0] >> 0) | ((uint32_t)a[19*i+ 1] << 8) | ((uint32_t)a[19*i+ 2] << 16)) & 0x7FFFF;
		r->coeffs[8*i+1] = ((a[19*i+ 2] >> 3) | ((uint32_t)a[19*i+ 3] << 5) | ((uint32_t)a[19*i+ 4] << 13)) & 0x7FFFF;
		r->coeffs[8*i+2] = ((a[19*i+ 4] >> 6) | ((uint32_t)a[19*i+ 5] << 2) | ((uint32_t)a[19*i+ 6] << 10) | ((uint32_t)a[19*i+ 7] << 18)) & 0x7FFFF;
		r->coeffs[8*i+3] = ((a[19*i+ 7] >> 1) | ((uint32_t)a[19*i+ 8] << 7) | ((uint32_t)a[19*i+ 9] << 15)) & 0x7FFFF;
		r->coeffs[8*i+4] = ((a[19*i+ 9] >> 4) | ((uint32_t)a[19*i+10] << 4) | ((uint32_t)a[19*i+11] << 12)) & 0x7FFFF;
		r->coeffs[8*i+5] = ((a[19*i+11] >> 7) | ((uint32_t)a[19*i+12] << 1) | ((uint32_t)a[19*i+13] <<  9) | ((uint32_t)a[19*i+14] << 17)) & 0x7FFFF;
		r->coeffs[8*i+6] = ((a[19*i+14] >> 2) | ((uint32_t)a[19*i+15] << 6) | ((uint32_t)a[19*i+16] << 14)) & 0x7FFFF;
		r->coeffs[8*i+7] = ((a[19*i+16] >> 5) | ((uint32_t)a[19*i+17] << 3) | ((uint32_t)a[19*i+18] << 11)) & 0x7FFFF;

		r->coeffs[8*i+0] = GAMMA1 - r->coeffs[8*i+0];
		r->coeffs[8*i+1] = GAMMA1 - r->coeffs[8*i+1];
		r->coeffs[8*i+2] = GAMMA1 - r->coeffs[8*i+2];
		r->coeffs[8*i+3] = GAMMA1 - r->coeffs[8*i+3];
		r->coeffs[8*i+4] = GAMMA1 - r->coeffs[8*i+4];
		r->coeffs[8*i+5] = GAMMA1 - r->coeffs[8*i+5];
		r->coeffs[8*i+6] = GAMMA1 - r->coeffs[8*i+6];
		r->coeffs[8*i+7] = GAMMA1 - r->coeffs[8*i+7];
	}
#elif N == 1536
	for(i = 0 ; i < 192 ; i++)
	{
		r->coeffs[8*i+0] = ((a[19*i+ 0] >> 0) | ((uint32_t)a[19*i+ 1] << 8) | ((uint32_t)a[19*i+ 2] << 16)) & 0x7FFFF;
		r->coeffs[8*i+1] = ((a[19*i+ 2] >> 3) | ((uint32_t)a[19*i+ 3] << 5) | ((uint32_t)a[19*i+ 4] << 13)) & 0x7FFFF;
		r->coeffs[8*i+2] = ((a[19*i+ 4] >> 6) | ((uint32_t)a[19*i+ 5] << 2) | ((uint32_t)a[19*i+ 6] << 10) | ((uint32_t)a[19*i+ 7] << 18)) & 0x7FFFF;
		r->coeffs[8*i+3] = ((a[19*i+ 7] >> 1) | ((uint32_t)a[19*i+ 8] << 7) | ((uint32_t)a[19*i+ 9] << 15)) & 0x7FFFF;
		r->coeffs[8*i+4] = ((a[19*i+ 9] >> 4) | ((uint32_t)a[19*i+10] << 4) | ((uint32_t)a[19*i+11] << 12)) & 0x7FFFF;
		r->coeffs[8*i+5] = ((a[19*i+11] >> 7) | ((uint32_t)a[19*i+12] << 1) | ((uint32_t)a[19*i+13] <<  9) | ((uint32_t)a[19*i+14] << 17)) & 0x7FFFF;
		r->coeffs[8*i+6] = ((a[19*i+14] >> 2) | ((uint32_t)a[19*i+15] << 6) | ((uint32_t)a[19*i+16] << 14)) & 0x7FFFF;
		r->coeffs[8*i+7] = ((a[19*i+16] >> 5) | ((uint32_t)a[19*i+17] << 3) | ((uint32_t)a[19*i+18] << 11)) & 0x7FFFF;

		r->coeffs[8*i+0] = GAMMA1 - r->coeffs[8*i+0];
		r->coeffs[8*i+1] = GAMMA1 - r->coeffs[8*i+1];
		r->coeffs[8*i+2] = GAMMA1 - r->coeffs[8*i+2];
		r->coeffs[8*i+3] = GAMMA1 - r->coeffs[8*i+3];
		r->coeffs[8*i+4] = GAMMA1 - r->coeffs[8*i+4];
		r->coeffs[8*i+5] = GAMMA1 - r->coeffs[8*i+5];
		r->coeffs[8*i+6] = GAMMA1 - r->coeffs[8*i+6];
		r->coeffs[8*i+7] = GAMMA1 - r->coeffs[8*i+7];
	}
#elif N == 2304
	for(i = 0 ; i < 1152 ; i++)
	{
		r->coeffs[2*i+0] = ((a[5*i+0] >> 0) | ((uint32_t)a[5*i+1] << 8) | ((uint32_t)a[5*i+2] << 16)) & 0xFFFFF;
		r->coeffs[2*i+1] = ((a[5*i+2] >> 4) | ((uint32_t)a[5*i+3] << 4) | ((uint32_t)a[5*i+4] << 12)) & 0xFFFFF;

		r->coeffs[2*i+0] = GAMMA1 - r->coeffs[2*i+0];
		r->coeffs[2*i+1] = GAMMA1 - r->coeffs[2*i+1];
	}
#endif
	DBENCH_STOP(*tpack);
}

void polyw1_pack(uint8_t *r, const poly *a)
{
	unsigned int i;
	DBENCH_START();

#if N == 1152
	for(i = 0 ; i < 144 ; i++)
	{
		r[5*i+0]  = (a->coeffs[8*i+0] >> 0) | (a->coeffs[8*i+1] << 5);
		r[5*i+1]  = (a->coeffs[8*i+1] >> 3) | (a->coeffs[8*i+2] << 2) | (a->coeffs[8*i+3] << 7);
		r[5*i+2]  = (a->coeffs[8*i+3] >> 1) | (a->coeffs[8*i+4] << 4);
		r[5*i+3]  = (a->coeffs[8*i+4] >> 4) | (a->coeffs[8*i+5] << 1) | (a->coeffs[8*i+6] << 6);
		r[5*i+4]  = (a->coeffs[8*i+6] >> 2) | (a->coeffs[8*i+7] << 3);
	}
#elif N == 1536
	for(i = 0 ; i < 192 ; i++)
	{
		r[5*i+0]  = (a->coeffs[8*i+0] >> 0) | (a->coeffs[8*i+1] << 5);
		r[5*i+1]  = (a->coeffs[8*i+1] >> 3) | (a->coeffs[8*i+2] << 2) | (a->coeffs[8*i+3] << 7);
		r[5*i+2]  = (a->coeffs[8*i+3] >> 1) | (a->coeffs[8*i+4] << 4);
		r[5*i+3]  = (a->coeffs[8*i+4] >> 4) | (a->coeffs[8*i+5] << 1) | (a->coeffs[8*i+6] << 6);
		r[5*i+4]  = (a->coeffs[8*i+6] >> 2) | (a->coeffs[8*i+7] << 3);
	}
#elif N == 2304
	for(i = 0 ; i < 1152 ; i++)
	{
		r[i]  = (a->coeffs[2*i+0] >> 0) | (a->coeffs[2*i+1] << 4);
	}
#endif
	DBENCH_STOP(*tpack);
}

void pack_pk(uint8_t pk[crypto_PUBLICKEYBYTES],
				const uint8_t zeta[SEEDBYTES],
				const poly *t1)
{
	unsigned int i;

	for(i = 0 ; i < SEEDBYTES ; i++)
		pk[i] = zeta[i];
	pk += SEEDBYTES;

	polyt1_pack(pk, t1);
}

void unpack_pk(uint8_t zeta[SEEDBYTES],
				poly *t1,
				const uint8_t pk[crypto_PUBLICKEYBYTES])
{
	unsigned int i;

	for(i = 0 ; i < SEEDBYTES ; i++)
		zeta[i] = pk[i];
	pk += SEEDBYTES;

	polyt1_unpack(t1, pk);
}

void pack_sk(uint8_t sk[crypto_SECRETKEYBYTES],
				const uint8_t zeta[SEEDBYTES],
				const uint8_t tr[SEEDBYTES],
				const uint8_t key[SEEDBYTES],
				const poly *t0,
				const poly *s1,
				const poly *s2)
{
	unsigned int i;

	for(i = 0 ; i < SEEDBYTES ; i++)
		sk[i] = zeta[i];
	sk += SEEDBYTES;

	for(i = 0 ; i < SEEDBYTES ; i++)
		sk[i] = key[i];
	sk += SEEDBYTES;

	for(i = 0 ; i < SEEDBYTES ; i++)
		sk[i] = tr[i];
	sk += SEEDBYTES;

	polyeta_pack(sk, s1);
	sk += POLYETA_PACKEDBYTES;

	polyeta_pack(sk, s2);
	sk += POLYETA_PACKEDBYTES;

	polyt0_pack(sk, t0);
}

void unpack_sk(uint8_t zeta[SEEDBYTES],
				uint8_t tr[SEEDBYTES],
				uint8_t key[SEEDBYTES],
				poly *t0,
				poly *s1,
				poly *s2,
				const uint8_t sk[crypto_SECRETKEYBYTES])
{
	unsigned int i;

	for(i = 0 ; i < SEEDBYTES ; i++)
		zeta[i] = sk[i];
	sk += SEEDBYTES;

	for(i = 0 ; i < SEEDBYTES ; i++)
		key[i] = sk[i];
	sk += SEEDBYTES;

	for(i = 0 ; i < SEEDBYTES ; i++)
		tr[i] = sk[i];
	sk += SEEDBYTES;

	polyeta_unpack(s1, sk);
	sk += POLYETA_PACKEDBYTES;

	polyeta_unpack(s2, sk);
	sk += POLYETA_PACKEDBYTES;

	polyt0_unpack(t0, sk);
}

void pack_sig(uint8_t sig[crypto_BYTES],
				const uint8_t c[SEEDBYTES],
				const poly *z,
				const poly *h)
{
	unsigned int i;

	for(i = 0 ; i < SEEDBYTES ; i++)
		sig[i] = c[i];
	sig += SEEDBYTES;

	polyz_pack(sig, z);
	sig += POLYZ_PACKEDBYTES;

	/* Encode h */
	for(i = 0 ; i < POLYH_PACKEDBYTES ; i++)
	{
		sig[i]  = (h->coeffs[8*i+0] << 0);
		sig[i] |= (h->coeffs[8*i+1] << 1);
		sig[i] |= (h->coeffs[8*i+2] << 2);
		sig[i] |= (h->coeffs[8*i+3] << 3);
		sig[i] |= (h->coeffs[8*i+4] << 4);
		sig[i] |= (h->coeffs[8*i+5] << 5);
		sig[i] |= (h->coeffs[8*i+6] << 6);
		sig[i] |= (h->coeffs[8*i+7] << 7);
	}
}

int unpack_sig(uint8_t c[SEEDBYTES],
				poly *z,
				poly *h,
				const uint8_t sig[crypto_BYTES])
{
	unsigned int i;

	for(i = 0 ; i < SEEDBYTES ; i++)
		c[i] = sig[i];
	sig += SEEDBYTES;

	polyz_unpack(z, sig);
	sig += POLYZ_PACKEDBYTES;

	/* Decode h */
	for(i = 0 ; i < POLYH_PACKEDBYTES ; i++)
	{
		h->coeffs[8 * i + 0] = (sig[i] >> 0) & 0x1;
		h->coeffs[8 * i + 1] = (sig[i] >> 1) & 0x1;
		h->coeffs[8 * i + 2] = (sig[i] >> 2) & 0x1;
		h->coeffs[8 * i + 3] = (sig[i] >> 3) & 0x1;
		h->coeffs[8 * i + 4] = (sig[i] >> 4) & 0x1;
		h->coeffs[8 * i + 5] = (sig[i] >> 5) & 0x1;
		h->coeffs[8 * i + 6] = (sig[i] >> 6) & 0x1;
		h->coeffs[8 * i + 7] = (sig[i] >> 7) & 0x1;
	}

	return 0;
}
