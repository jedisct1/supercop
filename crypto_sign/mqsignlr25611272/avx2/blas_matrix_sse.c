#include "gf16.h"
#include "blas_config.h"
#include "gf16_sse.h"
#include "blas_sse.h"
#include "blas_comm.h"
#include "blas_matrix_sse.h"
#include "assert.h"

#include <emmintrin.h>
#include <tmmintrin.h>
#include <string.h>


void gf256mat_prod_add_multab_sse( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * multab ) {
	__m128i mask_f = _mm_set1_epi8(0xf);
	unsigned n_xmm = ((n_A_vec_byte + 15)>>4);

	for(unsigned i=n_A_width;i>0;i--) {
		__m128i ml = _mm_load_si128( (__m128i*)( multab ) );
		__m128i mh = _mm_load_si128( (__m128i*)( multab + 16) );
		for(unsigned j=0;j<n_xmm;j++) {
			__m128i inp = _mm_loadu_si128( (__m128i*)(matA+j*16) );
			r[j] ^= linear_transform_8x8_128b( ml , mh , inp , mask_f );
		}
		multab += 32;
		matA += n_A_vec_byte;
	}
}

void gf256mat_prod_add_sse( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b ) {

	uint8_t multab[16*16*2] __attribute__((aligned(32)));
	while( 16 < n_A_width ){
		gf256v_generate_multab_sse( multab , b , 16 );
		gf256mat_prod_add_multab_sse( r , matA , n_A_vec_byte , 16 , multab );
		matA += n_A_vec_byte*16;
		b += 16;
		n_A_width -= 16;
	}
	// last 16 column
	uint8_t b_16[32] __attribute__((aligned(32)));
	for(unsigned i=0;i<n_A_width;i++) b_16[i]=b[i];
	gf256v_generate_multab_sse( multab , b_16 , 16 );
	if(0 == n_A_width ){ return; }
	if(1 < n_A_width) gf256mat_prod_add_multab_sse( r , matA, n_A_vec_byte , n_A_width - 1 , multab );
	// last column
	__m128i mask_f = _mm_set1_epi8(0xf);
	unsigned n_16 = (n_A_vec_byte>>4);
	unsigned n_16_rem = n_A_vec_byte&0xf;
	unsigned i=n_A_width-1;
	__m128i ml = _mm_load_si128( (__m128i*)( multab + i*32) );
	__m128i mh = _mm_load_si128( (__m128i*)( multab + i*32+16) );
	matA += i*n_A_vec_byte;
	for(unsigned j=0;j<n_16;j++) {
		__m128i inp = _mm_loadu_si128( (__m128i*)(matA+j*16) );
		r[j] ^= linear_transform_8x8_128b( ml , mh , inp , mask_f );
	}
	if( n_16_rem ) {
		__m128i inp = _load_xmm( matA + n_16*16 , n_16_rem );
		r[n_16] ^= linear_transform_8x8_128b( ml , mh , inp , mask_f );
	}
}

void gf256mat_prod_sse( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b ) {
	assert( n_A_vec_byte <= 48*48 );

	__m128i r[48*48/16];
	unsigned n_xmm = ((n_A_vec_byte + 15)>>4);
	for(unsigned i=0;i<n_xmm;i++) r[i] = _mm_setzero_si128();

	gf256mat_prod_add_sse( r , matA , n_A_vec_byte , n_A_width , b );

	unsigned n_16 = (n_A_vec_byte>>4);
	unsigned n_16_rem = n_A_vec_byte&0xf;
	for(unsigned i=0;i<n_16;i++) _mm_storeu_si128( (__m128i*)(c + i*16) , r[i] );
	if( n_16_rem ) _store_xmm( c + n_16*16 , n_16_rem , r[n_16] );
	}
