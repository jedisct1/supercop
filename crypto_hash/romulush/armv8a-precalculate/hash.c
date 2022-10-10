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

static void hirose_128_128_256(
  unsigned char h[],
  unsigned char g[],
  const unsigned char m[])
{
  uint8_t i;
  uint8_t tmp[BLOCKBYTES];
  uint8_t rtk_23[SKINNY128_384_ROUNDS*BLOCKBYTES/2];

  tk_schedule_23(rtk_23, m, m+BLOCKBYTES);
  skinny128_384_plus(tmp, h, g, rtk_23);
  h[0] ^= 0x01;
  skinny128_384_plus(g, h, g, rtk_23);

  for(i = 0;  i < SKINNY128_384_ROUNDS*BLOCKBYTES/2; i++)
  	rtk_23[i] = 0x00;

  for (i = 0; i < BLOCKBYTES; i++) {
    g[i] ^= h[i];
    h[i] ^= tmp[i];
  }
  h[0] ^= 0x01;
}

void initialize
	(unsigned char* h,
	 unsigned char* g)
{
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
