// 20221230 djb: add linker lines
// 20221230 djb: split out of operations.c

// linker define operation_keypair
// linker use controlbitsfrompermutation genpoly_gen pk_gen

#include "operations.h"

#include "controlbits.h"
#include "randombytes.h"
#include "hash.h"
#include "params.h"
#include "sk_gen.h"
#include "pk_gen.h"
#include "util.h"

#include <stdint.h>
#include <string.h>

void operation_keypair
(
       unsigned char *pk,
       unsigned char *sk 
)
{
	int i;
	unsigned char seed[ 33 ] = {64};
	unsigned char r[ SYS_N/8 + (1 << GFBITS)*sizeof(uint32_t) + SYS_T*2 + 32 ];
	unsigned char *rp, *skp;

	gf f[ SYS_T ]; // element in GF(2^mt)
	gf irr[ SYS_T ]; // Goppa polynomial
	uint32_t perm[ 1 << GFBITS ]; // random permutation as 32-bit integers
	int16_t pi[ 1 << GFBITS ]; // random permutation

	randombytes(seed+1, 32);

	while (1)
	{
		rp = &r[ sizeof(r)-32 ];
		skp = sk;

		// expanding and updating the seed

		shake(r, sizeof(r), seed, 33);
		memcpy(skp, seed+1, 32);
		skp += 32 + 8;
		memcpy(seed+1, &r[ sizeof(r)-32 ], 32);

		// generating irreducible polynomial

		rp -= sizeof(f); 

		for (i = 0; i < SYS_T; i++) 
			f[i] = load_gf(rp + i*2); 

		if (genpoly_gen(irr, f)) 
			continue;

		for (i = 0; i < SYS_T; i++)
			store_gf(skp + i*2, irr[i]);

		skp += IRR_BYTES;

		// generating permutation

		rp -= sizeof(perm);

		for (i = 0; i < (1 << GFBITS); i++) 
			perm[i] = load4(rp + i*4); 

		if (pk_gen(pk, skp - IRR_BYTES, perm, pi))
			continue;

		controlbitsfrompermutation(skp, pi, GFBITS, 1 << GFBITS);
		skp += COND_BYTES;

		// storing the random string s

		rp -= SYS_N/8;
		memcpy(skp, rp, SYS_N/8);

		// storing positions of the 32 pivots

		store8(sk + 32, 0xFFFFFFFF);

		break;
	}
}

