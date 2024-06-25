#include "blas_comm.h"
#include "blas_matrix.h"
#include "blas.h"
#include "mqs_config.h"

#if defined( _BLAS_AVX2_ )

#include "blas_matrix_avx2.h"
#define gf256mat_prod_impl					gf256mat_prod_avx2
#define gf256mat_inv_impl					gf256mat_inv_avx2
#define gf256mat_solve_linear_eq_ref_impl	gf256mat_solve_linear_eq_avx2
#define gf256mat_gaussian_elim_impl			gf256mat_gaussian_elim_avx2
#define gf256mat_back_substitute_impl		gf256mat_back_substitute_avx2
#define gf256mat_mul_impl					gf256mat_mul_avx2
#define gf256mat_prod_circ_impl				gf256mat_prod_circ_avx2
#define gf256mat_mul_circ_impl				gf256mat_mul_circ_avx2

#if defined(_MQRR)||defined(_MQSR)||defined(_MQLR)
#define gf256mat_solve_linear_eq_impl		gf256mat_solve_linear_eq_avx2_modify
#elif defined(_MQRR_CIRCA)
#define gf256mat_solve_linear_eq_impl		gf256mat_solve_linear_eq_avx2_circA
#else 
#endif 

#else

#include "blas_matrix_ref.h"
#define gf256mat_prod_impl					gf256mat_prod_ref
#define gf256mat_inv_impl					gf256mat_inv_ref
#define gf256mat_solve_linear_eq_ref_impl	gf256mat_solve_linear_eq_ref
#define gf256mat_gaussian_elim_impl			gf256mat_gaussian_elim_ref
#define gf256mat_back_substitute_impl		gf256mat_back_substitute_ref
#define gf256mat_mul_impl					gf256mat_mul_ref
#define gf256mat_prod_circ_impl				gf256mat_prod_circ_ref
#define gf256mat_mul_circ_impl				gf256mat_mul_circ_ref

#if defined(_MQRR)||defined(_MQSR)
#define gf256mat_solve_linear_eq_impl		gf256mat_solve_linear_eq_ref_modify
#elif defined(_MQRR_CIRCA)
#define gf256mat_solve_linear_eq_impl		gf256mat_solve_linear_eq_ref_circA
#else 
#endif 


#endif


void gf256mat_prod(uint8_t* c, const uint8_t* matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t* b)
{
	gf256mat_prod_impl(c, matA, n_A_vec_byte, n_A_width, b);
}

unsigned gf256mat_inv(uint8_t* inv_a, const uint8_t* mat_a, const unsigned h)
{
	return gf256mat_inv_impl(inv_a, mat_a, h);
}

unsigned gf256mat_solve_linear_eq_proto(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth)
{
	return gf256mat_solve_linear_eq_ref_impl(output, mat, H, vec, depth);
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

void gf256mat_prod_circ(uint8_t* c, const uint8_t* ext_circ, unsigned len, const uint8_t* b)
{
	gf256mat_prod_circ_impl(c, ext_circ, len, b);
}

void gf256mat_mul_circ(uint8_t* c, const uint8_t* a, const uint8_t* circ, unsigned len_vec)
{
	gf256mat_mul_circ_impl(c, a, circ, len_vec);
}

#if defined(_MQRR)||defined(_MQSR)||defined(_MQRR_CIRCA)||defined(_MQLR)
unsigned gf256mat_solve_linear_eq(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv)
{
	return gf256mat_solve_linear_eq_impl(mat, H, B, C, D, A_inv);
}
#else
unsigned gf256mat_solve_linear_eq(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth)
{
	(void)output;
	(void)mat;
	(void)H;
	(void)vec;
	(void)depth;

	return 0;
}
#endif