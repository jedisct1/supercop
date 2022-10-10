#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include "skinny128.h"
#include "tk_schedule.h"
#include "crypto_hash.h"

void hirose_128_128_256
	(unsigned char* h,
	 unsigned char* g,
	 const unsigned char* m) {

	uint8_t hh[BLOCKBYTES];
	int i;
    uint32_t rtk_1[BLOCKBYTES*SKINNY128_384_ROUNDS/4];
    uint32_t rtk_23[BLOCKBYTES*SKINNY128_384_ROUNDS/4];

    // precompute the round tweakeys
    tk_schedule_23(rtk_23, m, m+BLOCKBYTES);
   	tk_schedule_1(rtk_1, g);

	for (i = 0; i < BLOCKBYTES; i++) { 	// assign the key for the hirose compression function
		g[i]   = h[i];
		hh[i]  = h[i];
	}
	g[0] ^= 0x01;

	// run skinny-128-384+
	skinny128_384_plus(h, h, rtk_1, rtk_23);
	skinny128_384_plus(g, g, rtk_1, rtk_23);

	for(i = 0; i < BLOCKBYTES*SKINNY128_384_ROUNDS/4; i++)
		rtk_23[i] = 0x00000000;

	for (i = 0; i < BLOCKBYTES; i++) {
		h[i] ^= hh[i];
		g[i] ^= hh[i];
	}
	g[0] ^= 0x01;
}

void initialize
	(unsigned char* h,
	 unsigned char* g) {

 	 unsigned char i;
	for (i = 0; i < BLOCKBYTES; i++) {
		h[i] = 0;
		g[i] = 0;
	}
}

void pad(const unsigned char* m, unsigned char* mp, int l, int len8) {
	int i;
	for (i = 0; i < l; i++) {
		if (i < len8)
			mp[i] = m[i];
		else if (i == l - 1)
      		mp[i] = (len8 & 0x1f);
		else
			mp[i] = 0x00;
	}
}

int crypto_hash
	(unsigned char *out,
	 const unsigned char *in,
	 unsigned long long inlen) {

	unsigned char h[BLOCKBYTES];
	unsigned char g[BLOCKBYTES];
	unsigned char p[2*BLOCKBYTES];
	unsigned char i;

	initialize(h,g);
	
	while (inlen >= 2*BLOCKBYTES) { // Normal loop
		hirose_128_128_256(h,g,in);
		in += 2*BLOCKBYTES;
		inlen -= 2*BLOCKBYTES;
	}

	pad(in,p,2*BLOCKBYTES,inlen);
	h[0] ^= 2;
	hirose_128_128_256(h,g,p);

	for (i = 0; i < BLOCKBYTES; i++) { // Assign the output tag
		out[i] = h[i];
		out[i+BLOCKBYTES] = g[i];
	}
	return 0;
}
