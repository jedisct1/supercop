// 20241017 djb: eliminate cpucycles() and main()

/*
 * hector/src/hector_dh.c version 20080403
 * Peter Schwabe & Peter Birkner
 * Public domain
*/

#include <stdio.h>
#include <gmp.h>

#include "sizes.h"
#include "config.h"
#include "curve.h"
#include "generator.h"
#include "divclass.h"
#include "conversion.h"
#include "common.h"
#include "crypto_dh.h"


int crypto_dh(
		unsigned char *s,
		const unsigned char *pk,
		const unsigned char *sk
		)
{
	init_all();

	divclass Q;
	divclass R;
	divclass_init(Q);
	divclass_init(R);

	// Write sk to mpz_t:
	mpz_t skey;
	mpz_init(skey);
	bytearray_to_mpz_t(skey, sk, SECRETKEY_BYTES);

	// Compute shared key:
	bytearray_to_divclass(Q, pk);

	divclass_multiply(R, Q, skey);

	divclass_to_bytearray(s, R);

	mpz_clear(skey);
	clear_all();

	return 0;
}

