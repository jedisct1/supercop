/// @file blas_u64.h
/// @brief Inlined functions for implementing basic linear algebra functions for uint64 arch.
///

#ifndef _BLAS_U64_H_
#define _BLAS_U64_H_

#include <stdint.h>
#include <stdio.h>



#include <stdint.h>

#include "gf16.h"

#include "gf16_u64.h"

#include "blas_u32.h"

#include "assert.h"


#ifdef  __cplusplus
extern  "C" {
#endif




static inline
void _gf256v_add_u64( uint8_t * accu_b, const uint8_t * a , unsigned _num_byte ) {
	if( ((size_t)accu_b&7)||((size_t)a&7) ){ _gf256v_add_u32(accu_b,a,_num_byte); return; }
	unsigned n_u64 = _num_byte >> 3;
	uint64_t * b_u64 = (uint64_t *)accu_b;
	const uint64_t * a_u64 = (const uint64_t *)a;
	for(unsigned i=0;i<n_u64;i++) b_u64[i] ^= a_u64[i];

	a += (n_u64<<3);
	accu_b += (n_u64<<3);
	unsigned rem = _num_byte & 7;
	if( rem )_gf256v_add_u32( accu_b , a , rem );
}


static inline
void _gf256v_predicated_add_u64( uint8_t * accu_b, uint8_t predicate , const uint8_t * a , unsigned _num_byte ) {
	if( ((size_t)accu_b&7)||((size_t)a&7) ){ _gf256v_predicated_add_u32(accu_b,predicate,a,_num_byte); return; }
	uint64_t pr_u64 = ((uint64_t)0)-((uint64_t)predicate);

	unsigned n_u64 = _num_byte >> 3;
	uint64_t * b_u64 = (uint64_t *)accu_b;
	const uint64_t * a_u64 = (const uint64_t *)a;
	for(unsigned i=0;i<n_u64;i++) b_u64[i] ^= (a_u64[i]&pr_u64);

	a += (n_u64<<3);
	accu_b += (n_u64<<3);
	unsigned rem = _num_byte & 7;
	if( rem ) _gf256v_predicated_add_u32( accu_b , predicate , a , rem );
}



///////////////////////////////////////////////////



static inline
void _gf16v_mul_scalar_u64( uint8_t * a, uint8_t b , unsigned _num_byte ) {
	if( (size_t)a&7 ) { _gf16v_mul_scalar_u32(a,b,_num_byte); return; }
	unsigned _num = _num_byte>>3;
	uint64_t * a64 = (uint64_t*) a;
	for(unsigned i=0;i<_num;i++) {
		a64[i] = gf16v_mul_u64(a64[i],b);
	}

	unsigned _num_b = _num_byte&0x7;
	unsigned st = _num<<3;
	a += st;
	if( _num_b ) _gf16v_mul_scalar_u32( a , b , _num_b );
}


static inline
void _gf256v_mul_scalar_u64( uint8_t *a, uint8_t b, unsigned _num_byte ) {
	if( (size_t)a&7 ) { _gf256v_mul_scalar_u32(a,b,_num_byte); return; }
	unsigned _num = _num_byte>>3;
	uint64_t * a64 = (uint64_t*) a;
	for(unsigned i=0;i<_num;i++) {
		a64[i] = gf256v_mul_u64(a64[i],b);
	}
	unsigned _num_b = _num_byte&0x7;
	unsigned st = _num<<3;
	if( _num_b ) _gf256v_mul_scalar_u32( a+st , b , _num_b );
}


//////////////////////////////////////////////

static inline
void _gf16v_madd_u64( uint8_t * accu_c, const uint8_t * a , uint8_t b, unsigned _num_byte ) {
	if( ((size_t)a&7)||((size_t)accu_c&7) ) { _gf16v_madd_u32(accu_c,a,b,_num_byte); return; }
	unsigned _num = _num_byte>>3;
	const uint64_t * a64 = (const uint64_t*) a;
	uint64_t * c64 = (uint64_t*) accu_c;
	for(unsigned i=0;i<_num;i++) {
		c64[i] ^= gf16v_mul_u64(a64[i],b);
	}

	unsigned _num_b = _num_byte&0x7;
	unsigned st = _num<<3;
	if( _num_b ) _gf16v_madd_u32( accu_c + st , a + st , b , _num_b );
}



static inline
void _gf256v_madd_u64( uint8_t * accu_c, const uint8_t * a , uint8_t b, unsigned _num_byte ) {
	if( ((size_t)a&7)||((size_t)accu_c&7) ) { _gf256v_madd_u32(accu_c,a,b,_num_byte); return; }
	unsigned _num = _num_byte>>3;
	const uint64_t * a64 = (const uint64_t*) a;
	uint64_t * c64 = (uint64_t*) accu_c;
	for(unsigned i=0;i<_num;i++) {
		c64[i] ^= gf256v_mul_u64(a64[i],b);
	}
	unsigned _num_b = _num_byte&0x7;
	unsigned st = _num<<3;
	if( _num_b ) _gf256v_madd_u32( accu_c + st , a + st , b , _num_b );
}





///////////////////////////////////////



static inline
uint8_t _gf16v_dot_u64( const uint8_t * a, const uint8_t * b , unsigned _num_byte ) {
	unsigned n_u64 = _num_byte >> 3;
	const uint64_t * a_u64 = (const uint64_t *)a;
	const uint64_t * b_u64 = (const uint64_t *)b;
	uint64_t r = 0;
	for(unsigned i=0;i<n_u64;i++) r ^= gf16v_mul_u64_u64( a_u64[i] , b_u64[i] );

	unsigned rem = _num_byte & 7;
	if( rem ) {
		union tmp_64 {
			uint8_t u8[8];
			uint64_t u64;
		} ta,tb;
		ta.u64 = 0;
		tb.u64 = 0;
		for(unsigned i=0;i<rem;i++) ta.u8[i] = a[(n_u64<<3)+i];
		for(unsigned i=0;i<rem;i++) tb.u8[i] = b[(n_u64<<3)+i];
		r ^= gf16v_mul_u64_u64( ta.u64 , tb.u64 );
	}
	return gf16v_reduce_u64( r );
}







#ifdef  __cplusplus
}
#endif



#endif // _BLAS_U64_H_


