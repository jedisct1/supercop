#ifndef _BLAS_MATRIX_AVX2_H_
#define _BLAS_MATRIX_AVX2_H_

#include "stdint.h"

#ifdef  __cplusplus
extern  "C" {
#endif

void gf256mat_prod_multab_avx2( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b_multab );

void gf256mat_prod_multab_sparse_ov_avx2(uint8_t* c, const uint8_t* matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t* b_multab);

void gf256mat_prod_avx2( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );

void gf256mat_mul(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec);
unsigned gf256mat_inv_avx2( uint8_t * inv_a , const uint8_t * mat_a , const unsigned h);
unsigned gf256mat_solve_linear_eq_avx2(uint8_t *output, const uint8_t *mat, const unsigned H, const uint8_t* vec,uint8_t depth);
unsigned gf256mat_solve_linear_eq_avx2_modify(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv);
unsigned gf256mat_solve_linear_CORE(uint8_t* sol, const uint8_t* mat_a, const uint8_t* c_terms, const unsigned h);

unsigned gf256mat_gaussian_elim_avx2(uint8_t* sqmat_a, uint8_t* constant, unsigned len);
void gf256mat_back_substitute_avx2(uint8_t* constant, const uint8_t* sq_row_mat_a, unsigned len);

void gf256mat_mul_avx2(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec);
void gf256mat_prod_circ_avx2(uint8_t* c, const uint8_t* ext_circ, unsigned len, const uint8_t* b);
void gf256mat_mul_circ_avx2(uint8_t* c, const uint8_t* a, const uint8_t* circ, unsigned len_vec);

uint8_t degree_check(uint8_t *poly);
void gf256poly_mult_avx2(uint8_t* acc_poly, uint8_t* poly1, uint8_t* poly2);
uint8_t gf256poly_euclidean_avx2(uint8_t* p, uint8_t* q, uint8_t* s0, uint8_t* s1);
uint8_t gf256mat_inv_circ_avx2(uint8_t* inv_circ, uint8_t* circ);
unsigned gf256mat_solve_linear_eq_avx2_circA(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth);
uint8_t _get_oil_avx(uint8_t* oil, uint8_t* con, uint8_t* a, uint8_t* b, uint8_t* c, uint8_t* d, unsigned o_len);


#ifdef  __cplusplus
}
#endif



#endif

