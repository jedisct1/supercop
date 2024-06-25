#include "gf16.h"
#include "blas_config.h"
#include "gf16_sse.h"
#include "blas_sse.h"
#include "blas_comm.h"
#include "blas_matrix_sse.h"
#include "assert.h"

#include <emmintrin.h>
#include <tmmintrin.h>
#include "string.h"


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


void gf256mat_prod_multab_sse( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * multab ) {
	assert( n_A_vec_byte <= 64*64 );

	__m128i r[64*64/16];
	unsigned n_xmm = ((n_A_vec_byte + 15)>>4);
	for(unsigned i=0;i<n_xmm;i++) r[i] = _mm_setzero_si128();

	if(0==n_A_width) { gf256v_set_zero(c,n_A_vec_byte);  return; }
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
	for(unsigned j=0;j<n_16;j++) _mm_storeu_si128( (__m128i*)(c + j*16) , r[j] );
	if( n_16_rem ) _store_xmm( c + n_16*16 , n_16_rem , r[n_16] );
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




static
unsigned _gf256mat_gauss_elim_sse( uint8_t * mat , unsigned h , unsigned w )
{
	assert( 0 == (w&15) );
	unsigned n_xmm = w>>4;

	__m128i mask_0 = _mm_setzero_si128();

	uint8_t rr8 = 1;
	for(unsigned i=0;i<h;i++) {
		unsigned char i_r = i&0xf;
		unsigned i_d = i>>4;

		uint8_t * mi = mat+i*w;

		for(unsigned j=i+1;j<h;j++) {
			__m128i piv_i = _mm_load_si128( (__m128i*)( mi + i_d*16 ) );
			uint8_t * mj = mat+j*w;
			__m128i piv_j = _mm_load_si128( (__m128i*)( mj + i_d*16 ) );

			__m128i is_madd = _mm_cmpeq_epi8( piv_i , mask_0 ) ^ _mm_cmpeq_epi8( piv_j , mask_0 );
			__m128i madd_mask = _mm_shuffle_epi8( is_madd , _mm_set1_epi8(i_r) );

			piv_i ^= madd_mask&piv_j;
			_mm_store_si128( (__m128i*)( mi+ i_d*16 ) , piv_i );
			for(unsigned k=i_d+1;k<n_xmm;k++) {
				piv_i = _mm_load_si128( (__m128i*)( mi + k*16 ) );
				piv_j = _mm_load_si128( (__m128i*)( mj + k*16 ) );

				piv_i ^= madd_mask&piv_j;
				_mm_store_si128( (__m128i*)( mi+ k*16 ) , piv_i );
			}
		}
		rr8 &= gf256_is_nonzero( mi[i] );

		__m128i _pivot = _mm_set1_epi8( mi[i] );
		__m128i _ip = tbl_gf256_inv( _pivot );
		for(unsigned k=i_d;k<n_xmm;k++) {
			__m128i rowi = _mm_load_si128( (__m128i*)(mi+k*16) );
			rowi = tbl_gf256_mul( rowi , _ip );
			_mm_store_si128( (__m128i*)(mi+k*16) , rowi );
		}

		for(unsigned j=0;j<h;j++) {
			if(i==j) continue;

			uint8_t * mj = mat+j*w;
			__m128i mm = _mm_set1_epi8( mj[i] );

			for(unsigned k=i_d;k<n_xmm;k++) {
				__m128i rowi = _mm_load_si128( (__m128i*)(mi+k*16) );
				rowi = tbl_gf256_mul( rowi , mm );
				rowi ^= _mm_load_si128( (__m128i*)(mj+k*16) );
				_mm_store_si128( (__m128i*)(mj+k*16) , rowi );
			}
		}
	}
	return rr8;
}




///////////////////////////////////////


unsigned gf256mat_inv_32x32_sse( uint8_t * inv_a , const uint8_t * mat_a )
{
	const unsigned h = 32;
	const unsigned vec_len = 64;

	uint8_t mat[32*64] __attribute__((aligned(32))) = {0};
	for(unsigned i=0;i<h;i++) {
		memcpy( mat+i*vec_len , mat_a+i*h , h );
		mat[i*vec_len + h + i] = 1;
	}
	unsigned r = _gf256mat_gauss_elim_sse( mat , h , vec_len );
	for(unsigned i=0;i<h;i++) memcpy( inv_a+i*h , mat+i*vec_len+h , h );

	gf256v_set_zero( mat , h*vec_len );
	return r;
}

unsigned gf256mat_solve_linear_eq_48x48_sse( uint8_t * sol , const uint8_t * mat_a , const uint8_t * c_terms )
{
	const unsigned h = 48;
	const unsigned vec_len = 96;

	uint8_t mat[48*96] __attribute__((aligned(32))) = {0};
	for(unsigned i=0;i<h;i++) {
		memcpy( mat+i*vec_len , mat_a+i*h , h );
		mat[i*vec_len + h + i] = 1;
	}
	unsigned r = _gf256mat_gauss_elim_sse( mat , h , vec_len );
	for(unsigned i=0;i<h;i++) memcpy( mat+i*h , mat+i*vec_len+h , h );
	gf256mat_prod_sse( sol , mat , h , h , c_terms );

	gf256v_set_zero( mat , h*vec_len );
	return r;
}


////////////////////////////////////////


unsigned gf256mat_inv_36x36_sse( uint8_t * inv_a , const uint8_t * mat_a )
{
	const unsigned h = 36;
	const unsigned vec_len = 80;

	uint8_t mat[36*80] __attribute__((aligned(32))) = {0};
	for(unsigned i=0;i<h;i++) {
		memcpy( mat+i*vec_len , mat_a+i*h , h );
		mat[i*vec_len + h + i] = 1;
	}
	unsigned r = _gf256mat_gauss_elim_sse( mat , h , vec_len );
	for(unsigned i=0;i<h;i++) memcpy( inv_a+i*h , mat+i*vec_len+h , h );

	gf256v_set_zero( mat , h*vec_len );
	return r;
}

unsigned gf256mat_solve_linear_eq_64x64_sse( uint8_t * sol , const uint8_t * mat_a , const uint8_t * c_terms )
{
	const unsigned h = 64;
	const unsigned vec_len = 128;

	uint8_t mat[64*128] __attribute__((aligned(32))) = {0};
	for(unsigned i=0;i<h;i++) {
		memcpy( mat+i*vec_len , mat_a+i*h , h );
		mat[i*vec_len + h + i] = 1;
	}
	unsigned r = _gf256mat_gauss_elim_sse( mat , h , vec_len );
	for(unsigned i=0;i<h;i++) memcpy( mat+i*h , mat+i*vec_len+h , h );
	gf256mat_prod_sse( sol , mat , h , h , c_terms );

	gf256v_set_zero( mat , h*vec_len );
	return r;
}


