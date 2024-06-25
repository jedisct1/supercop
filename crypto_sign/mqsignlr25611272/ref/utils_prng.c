/// @file utils_prng.c
/// @brief The implementation of PRNG related functions.
///

#include "utils_prng.h"

#include <stdlib.h>
#include <string.h>

// int hash_msg( unsigned char * digest , unsigned len_digest , const unsigned char * m , unsigned long long mlen );
#include "utils_hash.h"

#ifndef _DEBUG_

#include "rng.h"


#define NDEBUG
#include <assert.h>

//////////////////////////////////

#define _BUFFER_SIZE 4096*128

static unsigned n_generated = 0;
static unsigned char _generated[_BUFFER_SIZE];

static unsigned user_source = 0;
static unsigned char _source[_BUFFER_SIZE];


/////////////////////////////////

static unsigned prng_record = 0;

static unsigned prng_n_gen = 0;

static unsigned prng_buffer_size = 0;

static unsigned char * prng_generated = NULL;

void prng_expand_buffer(void)
{
	prng_buffer_size += _BUFFER_SIZE;
	prng_generated = realloc(prng_generated, prng_buffer_size);
	if( NULL == prng_generated ) {
		printf("alloc for recording randomness fail.\n");
		exit(-1);
	}
}

void prng_dump_set( unsigned is_record )
{
	prng_record = is_record;
}

unsigned prng_dump( unsigned char ** ptr_rnd_generated )
{
	ptr_rnd_generated[0] = prng_generated;
	return prng_n_gen;
}

int userrand_source_file( const char * file_name )
{
	FILE * fp = fopen( file_name , "rb" );
	if( NULL == fp ) return -1;

	if( 0 != strcmp( "/dev/random" , file_name ) ) {
		printf("reading randomness %d bytes from: %s", _BUFFER_SIZE , file_name );
		user_source = fread( _source , 1 , _BUFFER_SIZE , fp );
		printf(" .... %d bytes read.\n", user_source );
	}

	fclose( fp );
	return 0;
}

unsigned userrand_dump_generated( unsigned char * buffer , unsigned size_buffer )
{
	unsigned r = 0;
	for(unsigned i=0;i<n_generated;i++) {
		if( size_buffer == i ) break;
		buffer[i] = _generated[i];
		r++;
	}
	return r;
}


int prng_set(prng_t *ctx, const void *prng_seed, unsigned long prng_seedlen)
{
    unsigned char seed[48];
    if( prng_seedlen >= 48 ) {
        memcpy( seed , prng_seed , 48 );
    } else {
        memcpy( seed , prng_seed , prng_seedlen );
        hash_msg( seed + prng_seedlen , 48-prng_seedlen , (const unsigned char *)prng_seed, prng_seedlen);
    }

    randombytes_init_with_state( ctx , seed );

    return 0;
}

int prng_gen(prng_t *ctx, unsigned char *out, unsigned long outlen)
{
    return randombytes_with_state( ctx , out, outlen);
}





#else



int prng_set(prng_t *ctx, const void *prng_seed, unsigned long prng_seedlen)
{
    memset(ctx, 0, sizeof (prng_t));

    hash_msg(ctx->buf, _HASH_LEN , (const unsigned char *)prng_seed, prng_seedlen);

    return 0;
}

int prng_gen(prng_t *ctx, unsigned char *out, unsigned long outlen) {

   while( outlen ) {
      if( _HASH_LEN == ctx->used ) { hash_msg(ctx->buf, _HASH_LEN , ctx->buf, _HASH_LEN); ctx->used = 0; }
      out[0] = ctx->buf[ctx->used];
      out++;
      ctx->used++;
      outlen--;
   }
   return 0;
}

#endif
