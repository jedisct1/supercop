#ifndef _BLAS_MATRIX_SSE_H_
#define _BLAS_MATRIX_SSE_H_

#include "stdint.h"

#ifdef  __cplusplus
extern  "C" {
#endif

void gf256mat_prod_add_multab_sse( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * multab );

void gf256mat_prod_multab_sse( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * multab );

void gf256mat_prod_add_sse( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );

void gf256mat_prod_sse( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );

unsigned gf256mat_solve_linear_eq_48x48_sse( uint8_t * sol , const uint8_t * inp_mat , const uint8_t * c_terms );

unsigned gf256mat_inv_32x32_sse( uint8_t * inv_a , const uint8_t * mat_a );

unsigned gf256mat_solve_linear_eq_64x64_sse( uint8_t * sol , const uint8_t * inp_mat , const uint8_t * c_terms );

unsigned gf256mat_inv_36x36_sse( uint8_t * inv_a , const uint8_t * mat_a );


#ifdef  __cplusplus
}
#endif


#endif

