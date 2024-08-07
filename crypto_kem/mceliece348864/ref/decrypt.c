// 20240806 djb: some automated conversion to cryptoint
/*
  This file is for Niederreiter decryption
*/
// 20240530 djb: remove #ifdef KAT ... #endif

#include <stdio.h>
#include "decrypt.h"

#include "params.h"
#include "benes.h"
#include "util.h"
#include "synd.h"
#include "root.h"
#include "gf.h"
#include "bm.h"
#include "crypto_int64.h"

/* Niederreiter decryption with the Berlekamp decoder */
/* intput: sk, secret key */
/*         c, ciphertext */
/* output: e, error vector */
/* return: 0 for success; 1 for failure */
int decrypt(unsigned char *e, const unsigned char *sk, const unsigned char *c)
{
	int i, w = 0; 
	uint16_t check;	

	unsigned char r[ SYS_N/8 ];

	gf g[ SYS_T+1 ];
	gf L[ SYS_N ];

	gf s[ SYS_T*2 ];
	gf s_cmp[ SYS_T*2 ];
	gf locator[ SYS_T+1 ];
	gf images[ SYS_N ];

	gf t;

	//

	for (i = 0; i < SYND_BYTES; i++)       r[i] = c[i];
	for (i = SYND_BYTES; i < SYS_N/8; i++) r[i] = 0;

	for (i = 0; i < SYS_T; i++) { g[i] = load_gf(sk); sk += 2; } g[ SYS_T ] = 1;

	support_gen(L, sk);

	synd(s, g, L, r);

	bm(locator, s);

	root(images, locator, L);

	//
	
	for (i = 0; i < SYS_N/8; i++) 
		e[i] = 0;

	for (i = 0; i < SYS_N; i++)
	{
		t = crypto_int64_bottombit_01(gf_iszero(images[i]));

		e[ i/8 ] |= t << (i%8);
		w += t;

	}

	synd(s_cmp, g, L, e);

	//

	check = w;
	check ^= SYS_T;

	for (i = 0; i < SYS_T*2; i++)
		check |= s[i] ^ s_cmp[i]; 

	check -= 1;
	check >>= 15;

	return check ^ 1;
}

