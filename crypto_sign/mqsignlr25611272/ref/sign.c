#include <stdlib.h>
#include <string.h>

#include "mqs_config.h"
#include "mqs_keypair.h"
#include "mqs.h"

#include "api.h"

#include "utils_hash.h"

#include "rng.h"

#if defined(SUPERCOP)
#include "crypto_sign.h"
#endif


int
crypto_sign_keypair(unsigned char *pk, unsigned char *sk)
{
	unsigned char sk_seed[LEN_SKSEED];
	randombytes(sk_seed, LEN_SKSEED);

	memset(pk,0,_PUB_KEY_LEN);
	memset(sk,0,_SEC_KEY_LEN);

	return generate_keypair_mqlr((pk_mqs*)pk, (sk_mqlr*)sk, sk_seed);
}


int
crypto_sign(unsigned char *sm, unsigned long long *smlen, const unsigned char *m, unsigned long long mlen, const unsigned char *sk)
{
	unsigned char digest[_HASH_LEN];

	hash_msg( digest , _HASH_LEN , m , mlen );

	memcpy( sm , m , mlen );
	smlen[0] = mlen + _SIGNATURE_BYTE;
	return mqlr_sign(sm + mlen, (sk_mqlr*)sk, m, (uint32_t) mlen);
}



int
crypto_sign_open(unsigned char *m, unsigned long long *mlen,const unsigned char *sm, unsigned long long smlen,const unsigned char *pk)
{
	if( _SIGNATURE_BYTE > smlen ) return -1;

	
	mlen[0] = smlen-_SIGNATURE_BYTE;
	
	if (mqlr_verify(sm, (uint32_t) mlen[0], sm + smlen - _SIGNATURE_BYTE, pk)) return -1;
memmove( m , sm , smlen-_SIGNATURE_BYTE );
return 0;
}