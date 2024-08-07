#include "blas_comm.h"
#include "blas_matrix.h"
#include "blas.h"
#include "mqs_config.h"

#include "blas_matrix_avx2.h"
#define gf256mat_prod_impl					gf256mat_prod_avx2
#define gf256mat_mul_impl					gf256mat_mul_avx2

#define gf256mat_prod_multab_impl     		gf256mat_prod_multab_avx2

#define gf256mat_solve_linear_eq_impl		gf256mat_solve_linear_eq_avx2_modify

void gf256mat_prod(uint8_t* c, const uint8_t* matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t* b)
{
	gf256mat_prod_impl(c, matA, n_A_vec_byte, n_A_width, b);
}

void gf256mat_prod_multab(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf256mat_prod_multab_impl( c, matA, n_A_vec_byte, n_A_width, b);
}

void gf256mat_mul(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec)
{
	gf256mat_mul_impl(c, a, b, len_vec);
}

unsigned gf256mat_solve_linear_eq(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv)
{
	return gf256mat_solve_linear_eq_impl(mat, H, B, C, D, A_inv);
}