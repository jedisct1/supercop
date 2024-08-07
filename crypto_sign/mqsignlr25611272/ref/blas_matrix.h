#ifndef _BLAS_MATRIX_H_
#define _BLAS_MATRIX_H_

#include <stdint.h>

#ifdef  __cplusplus
extern  "C" {
#endif

void gf256mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b);
unsigned gf256mat_inv(uint8_t* inv_a, const uint8_t* mat_a, const unsigned h);

unsigned gf256mat_gaussian_elim(uint8_t* sqmat_a, uint8_t* constant, unsigned len);
void gf256mat_back_substitute(uint8_t* constant, const uint8_t* sqmat_a, unsigned len);

void gf256mat_mul(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec);

unsigned gf256mat_solve_linear_eq(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv);

#ifdef  __cplusplus
}
#endif

#endif

