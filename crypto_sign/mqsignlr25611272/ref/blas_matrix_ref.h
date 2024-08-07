#ifndef _BLAS_MATRIX_REF_H_
#define _BLAS_MATRIX_REF_H_

#include <stdint.h>

#ifdef  __cplusplus
extern  "C" {
#endif

void gf256mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b);
unsigned gf256mat_inv_ref(uint8_t* inv_a, const uint8_t* a, unsigned h);

unsigned gf256mat_gaussian_elim_ref(uint8_t* sqmat_a, uint8_t* constant, unsigned len);
void gf256mat_back_substitute_ref(uint8_t* constant, const uint8_t* sqmat_a, unsigned len);

void gf256mat_mul_ref(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec);

unsigned gf256mat_solve_linear_eq_ref(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth);
unsigned gf256mat_solve_linear_eq_ref_modify(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv);

unsigned gf256mat_solve_linear_CORE_ref(uint8_t* sol, const uint8_t* inp_mat, const uint8_t* c_terms, const unsigned h);

void gf256mat_submat(uint8_t* mat2, unsigned w2, unsigned st, const uint8_t* mat, unsigned w, unsigned h);


#ifdef  __cplusplus
}
#endif

#endif 