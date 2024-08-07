#ifndef _BLAS_MATRIX_SSE_H_
#define _BLAS_MATRIX_SSE_H_

#include <stdint.h>

#ifdef  __cplusplus
extern  "C" {
#endif

void gf256mat_prod_add_multab_sse( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * multab );

void gf256mat_prod_add_sse( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );

void gf256mat_prod_sse( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );

#ifdef  __cplusplus
}
#endif


#endif

