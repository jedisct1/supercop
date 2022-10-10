/**
 * Romulus-H implementation following the SUPERCOP API.
 * 
 * @author      Alexandre Adomnicai
 *              alex.adomnicai@gmail.com
 * 
 * @date        March 2022
 */
#include "skinny128.h"
#include "crypto_hash.h"

static void hirose_128_128_256
	(unsigned char* h,
	 unsigned char* g,
	 const unsigned char* m)
{
	int i;
	uint8_t hh[BLOCKBYTES];
	uint8_t rtk_1[16*BLOCKBYTES];
    uint8_t rtk_23[16*SKINNY128_384_ROUNDS];

    // precompute round tweakeys
    tk_schedule_123(rtk_1, rtk_23, g, m, m+BLOCKBYTES);

 	// assign the key for the hirose compression function
	for (i = 0; i < BLOCKBYTES; i++) {
		g[i]   = h[i];
		hh[i]  = h[i];
	}
	g[0] ^= 0x01;

	// hirose compression function
    skinny128_384_plus(h, h, rtk_1, rtk_23);
    skinny128_384_plus(g, g, rtk_1, rtk_23);

    for(i = 0; i < 16*SKINNY128_384_ROUNDS; i++)
    	rtk_23[i] = 0x00;

	for (i = 0; i < BLOCKBYTES; i++) {
		h[i] ^= hh[i];
		g[i] ^= hh[i];
	}
	g[0] ^= 0x01;
}

static void initialize
	(unsigned char* h,
	unsigned char* g)
{
	unsigned char i;
	for (i = 0; i < BLOCKBYTES; i++) {
		h[i] = 0;
		g[i] = 0;
	}
}

static void pad(const unsigned char* m, unsigned char* mp, int l, int len8)
{
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
	 unsigned long long inlen)
{

	unsigned char h[BLOCKBYTES];
	unsigned char g[BLOCKBYTES];
	unsigned char p[2*BLOCKBYTES];
	unsigned char i;

	initialize(h, g);
	
	// treats input blocks by pair
	while (inlen >= 2*BLOCKBYTES) {
		hirose_128_128_256(h, g, in);
		in 		+= 2*BLOCKBYTES;
		inlen 	-= 2*BLOCKBYTES;
	}

	pad(in, p, 2*BLOCKBYTES, inlen);
	h[0] ^= 2;
	hirose_128_128_256(h, g, p);

 	// Assign the output tag
	for (i = 0; i < BLOCKBYTES; i++) {
		out[i] = h[i];
		out[i+BLOCKBYTES] = g[i];
	}
	return 0;
}
