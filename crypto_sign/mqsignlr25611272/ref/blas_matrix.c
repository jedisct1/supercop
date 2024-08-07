#include "blas_comm.h"
#include "blas_matrix.h"
#include "blas.h"
#include "mqs_config.h"

#include "blas_matrix_ref.h"

#define gf256mat_prod_impl					gf256mat_prod_ref
#define gf256mat_inv_impl					gf256mat_inv_ref
#define gf256mat_gaussian_elim_impl			gf256mat_gaussian_elim_ref
#define gf256mat_back_substitute_impl		gf256mat_back_substitute_ref
#define gf256mat_mul_impl					gf256mat_mul_ref

#define gf256mat_solve_linear_eq_impl		gf256mat_solve_linear_eq_ref_modify

void gf256mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf256mat_prod_impl( c, matA, n_A_vec_byte, n_A_width, b);
}

unsigned gf256mat_inv(uint8_t* inv_a, const uint8_t* mat_a, const unsigned h)
{
	return gf256mat_inv_impl(inv_a, mat_a, h);
}

unsigned gf256mat_gaussian_elim(uint8_t* sqmat_a, uint8_t* constant, unsigned len)
{
	return gf256mat_gaussian_elim_impl(sqmat_a, constant, len);
}

void gf256mat_back_substitute(uint8_t* constant, const uint8_t* sqmat_a, unsigned len)
{
	gf256mat_back_substitute_impl(constant, sqmat_a, len);
}

void gf256mat_mul(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec)
{
	gf256mat_mul_impl(c, a, b, len_vec);
}

unsigned gf256mat_solve_linear_eq(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv)
{
	return gf256mat_solve_linear_eq_impl(mat, H, B, C, D, A_inv);
}
