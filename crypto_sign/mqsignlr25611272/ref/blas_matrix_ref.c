#include "blas_comm.h"
#include "blas.h"
#include "blas_matrix_ref.h"
#include "blas_matrix.h"

#include "mqs_config.h"

#include <stdint.h>
#include <string.h>

#define _GE_CADD_EARLY_STOP_

void gf256mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        gf256v_madd(c, matA, b[i], n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}

// c = circ * b for col-major circulant circ // ext_circ = [an ... a2 a1 an ... a2 a1] where circ = [a1 a2 ... an]
void gf256mat_prod_circ_ref(uint8_t* c, const uint8_t* ext_circ, unsigned len, const uint8_t* b)
{
	memset(c, 0, len);
	for (unsigned i = 0; i < len; i++)
	{
		gf256v_madd(c, ext_circ + len - 1 - i, b[i], len);
	}
}

// circ_1 * (a1 a2 ... an) + circ_2 * (an a1 ... a(n-1)) + ... + circ_n * (a2 a3 ... a1)
void gf256mat_mul_circ_ref(uint8_t* c, const uint8_t* a, const uint8_t* circ, unsigned len_vec) 
{
	unsigned n_vec_byte = len_vec * len_vec;
	uint8_t ext_a[2 * _O * _O + 31] = { 0, };

	memcpy(ext_a, a, n_vec_byte);
	memcpy(ext_a + n_vec_byte, a, n_vec_byte);
	//ext_a = (a | a) = (a1 a2 ... an a1 a2 ... an)

	gf256v_set_zero(c, n_vec_byte);
	for (unsigned k = 0; k < len_vec; k++) {
		gf256v_madd(c, ext_a + len_vec * (len_vec - k), circ[k], n_vec_byte);
	}
}

static
unsigned gf256mat_gauss_elim_ref(uint8_t* mat, unsigned h, unsigned w)
{
	unsigned r8 = 1;

	for (unsigned i = 0; i < h; i++) {
		uint8_t* ai = mat + w * i;
		//unsigned i_start = i-(i&(_BLAS_UNIT_LEN_-1));
		unsigned i_start = i;

		for (unsigned j = i + 1; j < h; j++) {
			uint8_t* aj = mat + w * j;
			gf256v_conditional_add(ai + i_start, !gf256_is_nonzero(ai[i]), aj + i_start, w - i_start);
		}
		r8 &= gf256_is_nonzero(ai[i]);
		uint8_t pivot = ai[i];
		pivot = gf256_inv(pivot);
		gf256v_mul_scalar(ai + i_start, pivot, w - i_start);
		for (unsigned j = 0; j < h; j++) {
			if (i == j) continue;
			uint8_t* aj = mat + w * j;
			gf256v_madd(aj + i_start, ai + i_start, aj[i], w - i_start);
		}
	}

	return r8;
}

static
unsigned _gf256mat_gauss_elim_row_echelon_ref(uint8_t* mat, unsigned h, unsigned w)
{
	unsigned r8 = 1;

	for (unsigned i = 0; i < h; i++) {
		uint8_t* ai = mat + w * i;
		//unsigned i_start = i-(i&(_BLAS_UNIT_LEN_-1));
		unsigned i_start = i;
#if defined( _GE_CADD_EARLY_STOP_ )
		unsigned stop = (i + 8 < h) ? i + 8 : h;
		for (unsigned j = i + 1; j < stop; j++) {
#else
		for (unsigned j = i + 1; j < h; j++) {
#endif
			uint8_t* aj = mat + w * j;
			gf256v_conditional_add(ai + i_start, !gf256_is_nonzero(ai[i]), aj + i_start, w - i_start);
		}
		r8 &= gf256_is_nonzero(ai[i]);
		uint8_t pivot = ai[i];
		pivot = gf256_inv(pivot);
		gf256v_mul_scalar(ai + i_start, pivot, w - i_start);
		for (unsigned j = i + 1; j < h; j++) {
			if (i == j) continue;
			uint8_t* aj = mat + w * j;
			gf256v_madd(aj + i_start, ai + i_start, aj[i], w - i_start);
		}
	}

	return r8;
}

unsigned gf256mat_gaussian_elim_ref(uint8_t* sqmat_a, uint8_t* constant, unsigned len)
{
#define MAX_H  128
	uint8_t mat[MAX_H * (MAX_H + 4)];

	unsigned height = len;
	unsigned width = len + 4;

	for (unsigned i = 0; i < height; i++) {
		uint8_t* ai = mat + i * width;
		for (unsigned j = 0; j < height; j++) ai[j] = sqmat_a[j * len + i];  // transpose since sqmat_a is col-major
		ai[height] = constant[i];
	}
	unsigned char r8 = _gf256mat_gauss_elim_row_echelon_ref(mat, height, width);

	for (unsigned i = 0; i < height; i++) {
		uint8_t* ai = mat + i * width;
		memcpy(sqmat_a + i * len, ai, len);     // output a row-major matrix
		constant[i] = ai[len];
	}
	return r8;
}

void gf256mat_back_substitute_ref(uint8_t* constant, const uint8_t* sqmat_a, unsigned len)
{
#define MAX_H  128
	uint8_t column[MAX_H] = { 0 };
	for (int i = len - 1; i > 0; i--) {
		for (int j = 0; j < i; j++) column[j] = sqmat_a[j * len + i];   // row-major -> column-major, i.e., transpose
		gf256v_madd(constant, column, constant[i], i);
	}
}

void gf256mat_submat(uint8_t* mat2, unsigned w2, unsigned st, const uint8_t* mat, unsigned w, unsigned h)
{
	for (unsigned i = 0; i < h; i++) {
		for (unsigned j = 0; j < w2; j++) mat2[i * w2 + j] = mat[i * w + st + j];
	}
}

void gf256mat_mul_ref(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec) {
	unsigned n_vec_byte = len_vec;
	for (unsigned k = 0; k < len_vec; k++) {
		gf256v_set_zero(c, n_vec_byte);
		const uint8_t* bk = b + n_vec_byte * k;
		for (unsigned i = 0; i < len_vec; i++) {
			gf256v_madd(c, a + n_vec_byte * i, bk[i], n_vec_byte);
		}
		c += n_vec_byte;
	}
}

unsigned gf256mat_inv_ref(uint8_t* inv_a, const uint8_t* a, unsigned h)
{
	const unsigned H = h;
	uint8_t mat[H * H * 2];
	for (unsigned i = 0; i < H; i++) {
		uint8_t* ai = mat + i * 2 * H;
		gf256v_set_zero(ai, 2 * H);
		gf256v_add(ai, a + i * H, H);
		ai[H + i] = 1;
	}
	unsigned char r8 = gf256mat_gauss_elim_ref(mat, H, 2 * H);
	gf256mat_submat(inv_a, H, H, mat, 2 * H, H);
	gf256v_set_zero(mat, H * 2 * H);
	return r8;
}

unsigned gf256mat_solve_linear_CORE_ref(uint8_t* sol, const uint8_t* inp_mat, const uint8_t* c_terms, const unsigned h)
{
	unsigned vec_len = h + _BLAS_UNIT_LEN_;

	uint8_t mat[h * vec_len];
	gf256v_set_zero(mat, h * vec_len);
	for (unsigned i = 0; i < h; i++) {
		uint8_t* mi = mat + i * vec_len;
		for (unsigned j = 0; j < h; j++) mi[j] = inp_mat[j * h + i];
		mi[h] = c_terms[i];
	}
	unsigned r8 = gf256mat_gauss_elim_ref(mat, h, vec_len);
	for (unsigned i = 0; i < h; i++) sol[i] = mat[i * vec_len + h];
	gf256v_set_zero(mat, h * vec_len); // clean
	return r8;
}

unsigned gf256mat_solve_linear_eq_ref(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth) {
	unsigned rr = 1;
	uint8_t temp_mat[H * H];
	if (depth == 0) {
		return gf256mat_solve_linear_CORE_ref(output, mat, vec, H);
	}

	unsigned H_half = H >> 1;
	unsigned H_hh = H_half * H_half;

	uint8_t A[H_hh];
	uint8_t B[H_hh];
	uint8_t C[H_hh];
	uint8_t D[H_hh];
	uint8_t A_inv[H_hh];
	uint8_t CA_inv[H_hh];

	uint8_t temp_vec[H];
	uint8_t temp_vec2[H];

	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(A + i * H_half, H_half);
		gf256v_set_zero(C + i * H_half, H_half);
		gf256v_add(A + i * H_half, mat + i * H, H_half);
		gf256v_add(C + i * H_half, mat + H_half + i * H, H_half);
	} // up to down & left to right
	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(B + i * H_half, H_half);
		gf256v_set_zero(D + i * H_half, H_half);
		gf256v_add(B + i * H_half, mat + H_half * H + i * H, H_half);
		gf256v_add(D + i * H_half, mat + H_half * H + H_half + i * H, H_half);
	}
	rr &= gf256mat_inv_ref(A_inv, A, H_half);

	gf256mat_mul(CA_inv, C, A_inv, H_half);
	gf256mat_prod(temp_vec + H_half, CA_inv, H_half, H_half, vec);
	gf256v_set_zero(temp_vec, H_half);

	gf256v_add(temp_vec, vec, H);


	gf256mat_mul(temp_mat, CA_inv, B, H_half);
	gf256v_add(temp_mat, D, H_half * H_half);

	gf256mat_prod(temp_vec2, A_inv, H_half, H_half, temp_vec);

	rr &= gf256mat_solve_linear_eq_ref(temp_vec2 + H_half, temp_mat, H_half, temp_vec + H_half, depth - 1);

	gf256mat_prod(temp_vec, B, H_half, H_half, temp_vec2 + H_half);

	gf256mat_prod(output, A_inv, H_half, H_half, temp_vec);

	gf256v_set_zero(output + H_half, H_half);
	gf256v_add(output, temp_vec2, H);

	return rr;
}

unsigned gf256mat_solve_linear_eq_ref_modify(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv) {
	unsigned rr = 1;
	// uint8_t temp_mat[H * H] __attribute__((aligned(32)));
	//uint8_t buffer[H*H <<1] __attribute__((aligned(32))) ;
	// if (depth == 0) {
	// 	return gf256mat_solve_linear_CORE(output, mat, vec, H);
	// }

	unsigned H_half = H >> 1;
	unsigned H_hh = H_half * H_half;

	uint8_t A[H_hh] __attribute__((aligned(32)));

	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(A + i * H_half, H_half);
		gf256v_set_zero(C + i * H_half, H_half);
		gf256v_add(A + i * H_half, mat + i * H, H_half);
		gf256v_add(C + i * H_half, mat + H_half + i * H, H_half);
	} // up to down & left to right
	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(B + i * H_half, H_half);
		gf256v_set_zero(D + i * H_half, H_half);
		gf256v_add(B + i * H_half, mat + H_half * H + i * H, H_half);
		gf256v_add(D + i * H_half, mat + H_half * H + H_half + i * H, H_half);
	}
	rr &= gf256mat_inv(A_inv, A, H_half); 
	
	return rr;
}

// unsigned gf256mat_solve_linear_eq_ref_modify(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth) {
// 	unsigned rr = 1;
// 	uint8_t temp_mat[H * H];
// 	if (depth == 0) {
// 		return gf256mat_solve_linear_CORE_ref(output, mat, vec, H);
// 	}

// 	unsigned H_half = H >> 1;
// 	unsigned H_hh = H_half * H_half;

// 	uint8_t A[H_hh];
// 	uint8_t B[H_hh];
// 	uint8_t C[H_hh];
// 	uint8_t D[H_hh];
// 	uint8_t A_inv[H_hh];
// 	uint8_t CA_inv[H_hh];

// 	uint8_t temp_vec[H];
// 	uint8_t temp_vec2[H];
// 	//gf256v_set_zero(temp_vec , H_half);

// 	for (unsigned i = 0; i < H_half; i++) {
// 		gf256v_set_zero(A + i * H_half, H_half);
// 		gf256v_set_zero(C + i * H_half, H_half);
// 		gf256v_add(A + i * H_half, mat + i * H, H_half);
// 		gf256v_add(C + i * H_half, mat + H_half + i * H, H_half);
// 	} // up to down & left to right
// 	for (unsigned i = 0; i < H_half; i++) {
// 		gf256v_set_zero(B + i * H_half, H_half);
// 		gf256v_set_zero(D + i * H_half, H_half);
// 		gf256v_add(B + i * H_half, mat + H_half * H + i * H, H_half);
// 		gf256v_add(D + i * H_half, mat + H_half * H + H_half + i * H, H_half);
// 	}
// 	rr &= gf256mat_inv(A_inv, A, H_half);
// 	if (!rr) return rr;

// 	gf256mat_mul(CA_inv, C, A_inv, H_half);
// 	gf256mat_prod(temp_vec + H_half, CA_inv, H_half, H_half, vec);
// 	gf256v_set_zero(temp_vec, H_half);

// 	gf256v_add(temp_vec, vec, H);


// 	gf256mat_mul(temp_mat, CA_inv, B, H_half);
// 	gf256v_add(temp_mat, D, H_half * H_half);

// 	gf256mat_prod(temp_vec2, A_inv, H_half, H_half, temp_vec);

// 	rr &= gf256mat_gaussian_elim(temp_mat, temp_vec + H_half, H_half);
// 	gf256mat_back_substitute(temp_vec + H_half, temp_mat, H_half);

// 	memcpy(temp_vec2 + H_half, temp_vec + H_half, H_half);

// 	gf256mat_prod(temp_vec, B, H_half, H_half, temp_vec2 + H_half);

// 	gf256mat_prod(output, A_inv, H_half, H_half, temp_vec);

// 	gf256v_set_zero(output + H_half, H_half);
// 	gf256v_add(output, temp_vec2, H);

// 	return rr;
// }

// For _O-degree polynomials
// In : poly = a_n * x^n + ... + a_1 * x + a_0 with len = n + 1
// Out : n where a_n != 0
uint8_t degree_check(uint8_t* poly)
{
	uint8_t n = _HALF_O - 1;

	for (int i = n; i >= 0; i--)
	{
		if (poly[i]) break;
		n -= 1;
	}
	n += (n == 255);

	return n;
}

void gf256poly_mult_ref(uint8_t* acc_poly, uint8_t* poly1, uint8_t* poly2)
{
	int i, j;
	uint8_t deg_poly2 = degree_check(poly2);
	uint8_t tmp1[_HALF_O];
	uint8_t tmp2[_HALF_O] = { 0, };

	for (i = 0; i < _HALF_O; i++)
	{
		tmp1[i] = poly1[i];
		tmp2[i] = acc_poly[i];
	}

	for (i = 0; i <= deg_poly2; i++)
	{
		for (j = 0; j < _HALF_O - i; j++)
		{
			tmp2[i + j] ^= gf256_mul(poly2[i], poly1[j]);
		}
		for (; j < _HALF_O; j++)
		{
			tmp2[i + j - _HALF_O] ^= gf256_mul(poly2[i], poly1[j]);
		}
	}

	for (i = 0; i < _HALF_O; i++)
	{
		acc_poly[i] = tmp1[i];
		poly1[i] = tmp2[i];
	}
}


uint8_t gf256poly_euclidean_ref(uint8_t* p, uint8_t* q, uint8_t* s0, uint8_t* s1)
{
	int i, j;
	uint8_t deg_q = degree_check(q);
	int deg_pmq = degree_check(p) - deg_q;
	uint8_t a[_HALF_O] = { 0, };
	uint8_t tmp[_HALF_O] = { 0, };

	memcpy(tmp, p, _HALF_O);

	if (deg_pmq < 0)
	{
		gf256poly_mult_ref(s0, s1, a);
		return gf256poly_euclidean_ref(q, tmp, s0, s1);
	}

	uint8_t inv_coeff = gf256_inv(q[deg_q]);
	for (i = deg_pmq; i >= 0; i--)
	{
		a[i] = gf256_mul(tmp[deg_q + i], inv_coeff);

		for (j = 0; j <= deg_q; j++)
		{
			tmp[i + j] ^= gf256_mul(a[i], q[j]);
		}
	}
	gf256poly_mult_ref(s0, s1, a); // s0 <- s1 , s1 <- s0 + s1*a

	if (degree_check(tmp) == 0)
	{
		return tmp[0];
	}

	return gf256poly_euclidean_ref(q, tmp, s0, s1);
}

uint8_t gf256mat_inv_circ_ref(uint8_t* inv_circ, uint8_t* circ)
{
	uint8_t tmp[_HALF_O] = { 0, };
	uint8_t ss[_HALF_O] = { 1, 0 , };
	uint8_t s0[_HALF_O] = { 0, };
	uint8_t s1[_HALF_O] = { 1, 0, };
	uint8_t multmp;
	uint8_t a;

	memcpy(tmp, circ, _HALF_O);

	uint8_t deg_a = degree_check(tmp);

	multmp = gf256_inv(tmp[deg_a]);

	for (int i = 0; i < deg_a; i++)
	{
		ss[_HALF_O - deg_a + i] = gf256_mul(multmp, tmp[i]);
	}
	s0[_HALF_O - deg_a] = multmp;

	a = gf256poly_euclidean_ref(ss, tmp, s0, s1);
	if (!a) return a;
	gf256v_mul_scalar(s1, gf256_inv(a), _HALF_O);

	memcpy(inv_circ, s1, _HALF_O);

	return !(!a);
}

unsigned gf256mat_solve_linear_eq_ref_circA(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth) {
	unsigned rr = 1;
	uint8_t temp_mat[H * H];

	unsigned H_half = H >> 1;
	unsigned H_hh = H_half * H_half;

	uint8_t ext_mat[H * H];
	uint8_t ext_poly[H];


	if (depth == 0) {

		for (unsigned j = 0; j < _HALF_O; j++)
		{
			ext_poly[j] = mat[(_HALF_O - 1 - j)];
		}
		memcpy(ext_poly + _HALF_O, ext_poly, _HALF_O);

		for (unsigned i = 0; i < _HALF_O; i++)
		{
			memcpy(ext_mat + i * _O, ext_poly + _HALF_O - 1 - i, _HALF_O);
			memcpy(ext_mat + _HALF_O + i * _O, mat + _HALF_O + i * _HALF_O, _HALF_O);
		}
		memcpy(ext_mat + _HALF_O * _O, mat + _HALF_O + _HALF_O * _HALF_O, _HALF_O * _O);

		return gf256mat_solve_linear_CORE_ref(output, ext_mat, vec, H);
	}

	uint8_t A[H_half];
	uint8_t B[H_hh];
	uint8_t C[H_hh];
	uint8_t D[H_hh];
	uint8_t A_inv[H_half];
	uint8_t CA_inv[H_hh];

	uint8_t temp_vec[H];
	uint8_t temp_vec2[H];

	gf256v_set_zero(A, H_half);
	gf256v_add(A, mat, H_half);
	gf256v_set_zero(C, H_hh);
	gf256v_add(C, mat + H_half, H_hh); // up to down & left to right
	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(B + i * H_half, H_half);
		gf256v_set_zero(D + i * H_half, H_half);
		gf256v_add(B + i * H_half, mat + H_half + H_hh + i * H, H_half);
		gf256v_add(D + i * H_half, mat + H_half + H_hh + H_half + i * H, H_half);
	}
	rr &= gf256mat_inv_circ_ref(A_inv, A); // inverse matrix of circulant mat. A (A_inv is row-major)
	if (!rr) return rr;

	gf256mat_mul_circ(CA_inv, C, A_inv, H_half); // matrix * circulant matrix multiplication .. 

	for (unsigned j = 0; j < _HALF_O; j++)
	{
		ext_poly[j] = A_inv[(_HALF_O - 1 - j)];
	}
	memcpy(ext_poly + _HALF_O, ext_poly, _HALF_O);

	gf256mat_prod(temp_vec + H_half, CA_inv, H_half, H_half, vec);
	gf256v_set_zero(temp_vec, H_half);

	gf256v_add(temp_vec, vec, H);


	gf256mat_mul(temp_mat, CA_inv, B, H_half);
	gf256v_add(temp_mat, D, H_half * H_half);

	gf256mat_prod_circ(temp_vec2, ext_poly, H_half, temp_vec);

	rr &= gf256mat_gaussian_elim(temp_mat, temp_vec + H_half, H_half);
	gf256mat_back_substitute(temp_vec + H_half, temp_mat, H_half);

	memcpy(temp_vec2 + H_half, temp_vec + H_half, H_half);

	gf256mat_prod(temp_vec, B, H_half, H_half, temp_vec2 + H_half);

	gf256mat_prod_circ(output, ext_poly, H_half, temp_vec);

	gf256v_set_zero(output + H_half, H_half);
	gf256v_add(output, temp_vec2, H);

	return rr;
}