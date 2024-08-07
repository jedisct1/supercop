#include "mqs_keypair.h"
#include "mqs_keypair_computation.h"
#include "blas_comm.h"
#include "blas.h"
#include "mqs_blas.h"

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "utils_prng.h"
#include "utils_malloc.h"
#include "utils_hash.h"

#if 64 < _V1
#define _MALLOC_
#endif

static
void generate_T_part(unsigned char* t, prng_t* prng0)
{
	sk_mqrr* _sk;
	unsigned size;

	size = sizeof(_sk->mat_t);
	prng_gen(prng0, t, size); // T part
}

static
void generate_F(unsigned char* sk, prng_t* prng0)
{
	sk_mqrr* _sk;
	unsigned size;

	size = sizeof(_sk->Fq1);
	prng_gen(prng0, sk, size);
	sk += size;

	size = sizeof(_sk->Fq2);
	prng_gen(prng0, sk, size);
	sk += size;
}

static
void _generate_sk_mqrr(sk_mqrr* sk, const unsigned char* sk_seed)
{
	memcpy(sk->sk_seed, sk_seed, LEN_SKSEED);

	prng_t prng0;
	prng_set(&prng0, sk_seed, LEN_SKSEED);

	// generating secret key with prng.
	generate_T_part(sk->mat_t, &prng0);
	generate_F(sk->Fq1, &prng0);

	// clean prng
	memset(&prng0, 0, sizeof(prng_t));
}

int generate_keypair_mqrr(pk_mqs* rpk, sk_mqrr* sk, const unsigned char* sk_seed)
{
	_generate_sk_mqrr(sk, sk_seed);

#if defined(_MALLOC_)
	ext_pk* pk = malloc(sizeof(ext_pk));
	if (NULL == pk) return -1;
#else
	ext_pk _pk;
	ext_pk* pk = &_pk;
#endif

	cal_ext_pk_mqrr(pk, sk, sk);

	extpk_to_pk(rpk, pk);     // convert the public key from ext_pk to pk

	hash_msg(sk->ph, _HASH_LEN, rpk->pk, MQRR_PK_LEN);
	memcpy(rpk->ph, sk->ph, _HASH_LEN);

#if defined(_MALLOC_)
	free(pk);
#endif

	return 0;
}
