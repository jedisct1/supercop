#include "gf16.h"
#include "blas_config.h"
#include "gf16_avx2.h"
#include "blas.h"
#include "blas_sse.h"
#include "blas_avx2.h"
#include "blas_comm.h"
#include "blas_matrix_sse.h"
#include "blas_matrix_avx2.h"
#include "assert.h"
#include <immintrin.h>
#include "string.h"
#include "mqs_config.h"
#include "mqs_blas_simd.h"

#define _GE_CADD_EARLY_STOP_


#ifndef _mm256_set_m128i
#define _mm256_set_m128i(v0, v1)  _mm256_insertf128_si256(_mm256_castsi128_si256(v1), (v0), 1)
#define _mm256_setr_m128i(v0, v1) _mm256_set_m128i((v1), (v0))
#endif 

void gf256mat_prod_multab_avx2(uint8_t* c, const uint8_t* matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t* multab) {
	assert(n_A_width <= 256);
	//assert(n_A_vec_byte <= 256);

	__m256i mask_f = _mm256_load_si256((__m256i const*) __mask_low);

	__m256i r[96 * 96 / 32];

	unsigned n_ymm = ((n_A_vec_byte + 31) >> 5);

	for (unsigned i = 0; i < n_ymm; i++) r[i] = _mm256_setzero_si256();

	for (unsigned i = 0; i < n_A_width; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab + i * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);
		for (unsigned j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(matA + j * 32));
			r[j] ^= _mm256_shuffle_epi8(ml, inp & mask_f);
			r[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);
		}
		matA += n_A_vec_byte;
	}
	uint8_t r8[96 * 96] __attribute__((aligned(32)));
	for (unsigned i = 0; i < n_ymm; i++) _mm256_store_si256((__m256i*)(r8 + i * 32), r[i]);
	for (unsigned i = 0; i < n_A_vec_byte; i++) c[i] = r8[i];
}

// sparse ov evaluation !! output is O by O matrix 
void gf256mat_prod_multab_sparse_ov_avx2(uint8_t* c, const uint8_t* matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t* multab) {
	assert(n_A_width <= 256);
	// assert(n_A_vec_byte <= 256);
	// In OV evaluation, vec_byte = O (=M) & width = V

	uint8_t ct[100 * 100] = { 0, }; // oil variable <= 100 
	__m256i mask_f = _mm256_load_si256((__m256i const*) __mask_low);

	__m256i r[96 * 96 / 32];
	unsigned n_ymm = ((n_A_vec_byte + 31) >> 5);
	for (unsigned i = 0; i < n_ymm; i++) r[i] = _mm256_setzero_si256();

	for (unsigned i = 0; i < n_A_width; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab + i * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);
		for (unsigned j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(matA + j * 32));
			r[j] = _mm256_shuffle_epi8(ml, inp & mask_f);
			r[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);
		}

		uint8_t r8[256] __attribute__((aligned(32)));
		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r[j]);

		// classification by index .. for constructing oil matrix
		// for (unsigned j = 0; j < n_A_vec_byte; j++) ct[j*n_A_vec_byte + (i+j)%n_A_vec_byte] ^= r8[j]; // before transpose
		for (unsigned j = 0; j < n_A_vec_byte; j++) ct[j + ((i + j) % n_A_vec_byte) * n_A_vec_byte] ^= r8[j];

		matA += n_A_vec_byte;
	}
	memcpy(c, ct, n_A_vec_byte * n_A_vec_byte);
	// gf256mat_prod_multab_avx2(c, ct, n_A_vec_byte, n_A_vec_byte, multab + n_A_width * 32); // for complete evaluation
}


#if 0
// slower
void gf256mat_prod_avx2(uint8_t * c, const uint8_t * matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t * b) {
	assert(n_A_width <= 128);
	assert(n_A_vec_byte <= 80);

	uint8_t multab[256 * 16] __attribute__((aligned(32)));
	gf256v_generate_multab_sse(multab, b, n_A_width);

	gf256mat_prod_multab_avx2(c, matA, n_A_vec_byte, n_A_width, multab);
}
#else
void gf256mat_prod_avx2(uint8_t* c, const uint8_t* matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t* b) {
	assert(n_A_width <= 256);
	assert(n_A_vec_byte <= 96 * 96);
	//if( 256 < n_A_vec_byte ) return gf256mat_prod_no_buffer_avx2(c,matA,n_A_vec_byte,n_A_width,b);
	if (16 >= n_A_vec_byte) { gf256mat_prod_sse(c, matA, n_A_vec_byte, n_A_width, b); return; }

	__m256i mask_f = _mm256_load_si256((__m256i*)__mask_low);

	__m256i r[96 * 96 / 32];
	unsigned n_ymm = ((n_A_vec_byte + 31) >> 5);
	for (unsigned i = 0; i < n_ymm; i++) r[i] = _mm256_setzero_si256();

	uint8_t x0[256] __attribute__((aligned(32)));
	uint8_t x1[256] __attribute__((aligned(32)));
	for (unsigned i = 0; i < n_A_width; i++) x0[i] = b[i];
	for (unsigned i = 0; i < ((n_A_width + 31) >> 5); i++) {
		__m256i inp = _mm256_load_si256((__m256i*)(x0 + i * 32));
		__m256i i0 = inp & mask_f;
		__m256i i1 = _mm256_srli_epi16(inp, 4) & mask_f;
		_mm256_store_si256((__m256i*)(x0 + i * 32), tbl32_gf16_log(i0));
		_mm256_store_si256((__m256i*)(x1 + i * 32), tbl32_gf16_log(i1));
	}

	if (0 == (n_A_vec_byte & 31)) {
		for (unsigned i = 0; i < n_A_width; i++) {
			x0[0] = x0[i]; __m256i m0 = _mm256_broadcastb_epi8(_mm_load_si128((__m128i*)x0));
			x1[0] = x1[i]; __m256i m1 = _mm256_broadcastb_epi8(_mm_load_si128((__m128i*)x1));
			//__m128i ml = _mm_set1_epi8(x[i]);
			for (unsigned j = 0; j < n_ymm; j++) {
				__m256i inp = _mm256_loadu_si256((__m256i*)(matA + j * 32));
				__m256i l_i0 = tbl32_gf16_log(inp & mask_f);
				__m256i l_i1 = tbl32_gf16_log(_mm256_srli_epi16(inp, 4) & mask_f);

				__m256i ab0 = tbl32_gf16_mul_log_log(l_i0, m0, mask_f);
				__m256i ab1 = tbl32_gf16_mul_log_log(l_i1, m0, mask_f) ^ tbl32_gf16_mul_log_log(l_i0, m1, mask_f);
				__m256i ab2 = tbl32_gf16_mul_log_log(l_i1, m1, mask_f);
				__m256i ab2x8 = tbl32_gf16_mul_0x8(ab2);

				r[j] ^= ab0 ^ ab2x8 ^ _mm256_slli_epi16(ab1 ^ ab2, 4);
			}
			matA += n_A_vec_byte;
		}
	}
	else {
		for (unsigned i = 0; i < n_A_width - 1; i++) {
			x0[0] = x0[i]; __m256i m0 = _mm256_broadcastb_epi8(_mm_load_si128((__m128i*)x0));
			x1[0] = x1[i]; __m256i m1 = _mm256_broadcastb_epi8(_mm_load_si128((__m128i*)x1));
			//__m128i ml = _mm_set1_epi8(x[i]);
			for (unsigned j = 0; j < n_ymm; j++) {
				__m256i inp = _mm256_loadu_si256((__m256i*)(matA + j * 32));
				__m256i l_i0 = tbl32_gf16_log(inp & mask_f);
				__m256i l_i1 = tbl32_gf16_log(_mm256_srli_epi16(inp, 4) & mask_f);

				__m256i ab0 = tbl32_gf16_mul_log_log(l_i0, m0, mask_f);
				__m256i ab1 = tbl32_gf16_mul_log_log(l_i1, m0, mask_f) ^ tbl32_gf16_mul_log_log(l_i0, m1, mask_f);
				__m256i ab2 = tbl32_gf16_mul_log_log(l_i1, m1, mask_f);
				__m256i ab2x8 = tbl32_gf16_mul_0x8(ab2);

				r[j] ^= ab0 ^ ab2x8 ^ _mm256_slli_epi16(ab1 ^ ab2, 4);
			}
			matA += n_A_vec_byte;
		} {
			unsigned i = n_A_width - 1;
			x0[0] = x0[i]; __m256i m0 = _mm256_broadcastb_epi8(_mm_load_si128((__m128i*)x0));
			x1[0] = x1[i]; __m256i m1 = _mm256_broadcastb_epi8(_mm_load_si128((__m128i*)x1));
			//__m128i ml = _mm_set1_epi8(x[i]);
			for (unsigned j = 0; j < n_ymm - 1; j++) {
				__m256i inp = _mm256_loadu_si256((__m256i*)(matA + j * 32));
				__m256i l_i0 = tbl32_gf16_log(inp & mask_f);
				__m256i l_i1 = tbl32_gf16_log(_mm256_srli_epi16(inp, 4) & mask_f);

				__m256i ab0 = tbl32_gf16_mul_log_log(l_i0, m0, mask_f);
				__m256i ab1 = tbl32_gf16_mul_log_log(l_i1, m0, mask_f) ^ tbl32_gf16_mul_log_log(l_i0, m1, mask_f);
				__m256i ab2 = tbl32_gf16_mul_log_log(l_i1, m1, mask_f);
				__m256i ab2x8 = tbl32_gf16_mul_0x8(ab2);

				r[j] ^= ab0 ^ ab2x8 ^ _mm256_slli_epi16(ab1 ^ ab2, 4);
			}
			unsigned j = n_ymm - 1;
			uint8_t tmp_mat_col[32] __attribute__((aligned(32)));
			for (unsigned k = 0; k < (n_A_vec_byte & 31); k++) tmp_mat_col[k] = matA[k + j * 32];
			__m256i inp = _mm256_load_si256((__m256i*)tmp_mat_col);
			__m256i l_i0 = tbl32_gf16_log(inp & mask_f);
			__m256i l_i1 = tbl32_gf16_log(_mm256_srli_epi16(inp, 4) & mask_f);

			__m256i ab0 = tbl32_gf16_mul_log_log(l_i0, m0, mask_f);
			__m256i ab1 = tbl32_gf16_mul_log_log(l_i1, m0, mask_f) ^ tbl32_gf16_mul_log_log(l_i0, m1, mask_f);
			__m256i ab2 = tbl32_gf16_mul_log_log(l_i1, m1, mask_f);
			__m256i ab2x8 = tbl32_gf16_mul_0x8(ab2);
			r[j] ^= ab0 ^ ab2x8 ^ _mm256_slli_epi16(ab1 ^ ab2, 4);
		}
	}

	if (0 == (n_A_vec_byte & 31)) {
		for (unsigned i = 0; i < n_ymm; i++) _mm256_storeu_si256((__m256i*)(c + i * 32), r[i]);
	}
	else {
		__m256i* rr = r;
		n_ymm--;
		while (n_ymm) {
			_mm256_storeu_si256((__m256i*)c, *rr);
			rr += 1;
			c += 32;
			n_ymm--;
		}
		_mm256_store_si256((__m256i*)x0, *rr);
		for (unsigned i = 0; i < (n_A_vec_byte & 31); i++) { c[i] = x0[i]; }
	}
}
#endif

// c = circ * b for col-major circulant circ // ext_circ = [an ... a2 a1 an ... a2 a1] where circ = [a1 a2 ... an]
void gf256mat_prod_circ_avx2(uint8_t* c, const uint8_t* ext_circ, unsigned len, const uint8_t* b)
{
	memset(c, 0, len);
	for (unsigned i = 0; i < len; i++)
	{
		gf256v_madd_avx2(c, ext_circ + len - 1 - i, b[i], len);
	}
}

static
unsigned _gf256mat_gauss_elim_avx2_32x(uint8_t* mat, unsigned h, unsigned w)
{
	unsigned n_ymm = w >> 5;

	__m128i mask_0 = _mm_setzero_si128();

	uint8_t rr8 = 1;
	for (unsigned i = 0; i < h; i++) {
		unsigned char i_r16 = i & 0xf;
		unsigned i_d16 = i >> 4;
		unsigned i_d32 = i >> 5;

		uint8_t* mi = mat + i * w;

		for (unsigned j = i + 1; j < h; j++) {
			__m128i piv_i = _mm_load_si128((__m128i*)(mi + i_d16 * 16));
			__m128i is_zero = _mm_cmpeq_epi8(piv_i, mask_0);
			__m128i add_mask = _mm_shuffle_epi8(is_zero, _mm_set1_epi8(i_r16));

			__m256i mask = _mm256_setr_m128i(add_mask, add_mask);
			uint8_t* mj = mat + j * w;

			for (unsigned k = i_d32; k < n_ymm; k++) {
				__m256i p_i = _mm256_load_si256((__m256i*)(mi + k * 32));
				__m256i p_j = _mm256_load_si256((__m256i*)(mj + k * 32));

				p_i ^= mask & p_j;
				_mm256_store_si256((__m256i*)(mi + k * 32), p_i);
			}
		}
		rr8 &= gf256_is_nonzero(mi[i]);

		__m128i pi0 = _mm_set1_epi8(mi[i]);
		__m128i pi1 = tbl_gf256_inv(pi0);

		__m256i pi2 = _mm256_setr_m128i(pi1, pi1);

		for (unsigned k = i_d32; k < n_ymm; k++) {
			__m256i rowi = _mm256_load_si256((__m256i*)(mi + k * 32));
			rowi = tbl32_gf256_mul(rowi, pi2);
			_mm256_store_si256((__m256i*)(mi + k * 32), rowi);
		}

		for (unsigned j = 0; j < h; j++) {
			if (i == j) continue;

			uint8_t* mj = mat + j * w;
			__m256i mm = _mm256_set1_epi8(mj[i]);

			for (unsigned k = i_d32; k < n_ymm; k++) {
				__m256i rowi = _mm256_load_si256((__m256i*)(mi + k * 32));
				rowi = tbl32_gf256_mul(rowi, mm);
				rowi ^= _mm256_load_si256((__m256i*)(mj + k * 32));
				_mm256_store_si256((__m256i*)(mj + k * 32), rowi);
			}
		}
	}
	return rr8;
}

////////////////////////////////////////////

unsigned gf256mat_inv_avx2(uint8_t* inv_a, const uint8_t* mat_a, const unsigned h)
{
	unsigned vec_len = ((h + 15) >> 4) << 5;

	uint8_t mat[h * vec_len] __attribute__((aligned(32)));
	gf256v_set_zero(mat, h * vec_len);
	for (unsigned i = 0; i < h; i++) {
		memcpy(mat + i * vec_len, mat_a + i * h, h);
		mat[i * vec_len + h + i] = 1;
	}
	unsigned r = _gf256mat_gauss_elim_avx2_32x(mat, h, vec_len);
	for (unsigned i = 0; i < h; i++) memcpy(inv_a + i * h, mat + i * vec_len + h, h);
	gf256v_set_zero(mat, h * vec_len);
	return r;
}

unsigned gf256mat_solve_linear_CORE(uint8_t* sol, const uint8_t* mat_a, const uint8_t* c_terms, const unsigned h)
{
	unsigned vec_len = ((h + 15) >> 4) << 5;

	uint8_t mat[h * vec_len] __attribute__((aligned(32)));
	gf256v_set_zero(mat, h * vec_len);
	for (unsigned i = 0; i < h; i++) {
		memcpy(mat + i * vec_len, mat_a + i * h, h);
		mat[i * vec_len + h + i] = 1;
	}
	unsigned r = _gf256mat_gauss_elim_avx2_32x(mat, h, vec_len);
	for (unsigned i = 0; i < h; i++) memcpy(mat + i * h, mat + i * vec_len + h, h);
	gf256mat_prod_avx2(sol, mat, h, h, c_terms);

	gf256v_set_zero(mat, h * vec_len);
	return r;
}

void gf256mat_mul_avx2(uint8_t* c, const uint8_t* a, const uint8_t* b, unsigned len_vec) {
	unsigned n_vec_byte = len_vec;
  unsigned align_len = ((n_vec_byte + 31) / 32) * 32;
  unsigned char r[((_O + 31) / 32) * 32] __attribute__((aligned(32))) = { 0 };
	for (unsigned k = 0; k < len_vec; k++) {
		gf256v_set_zero(c, n_vec_byte);
		const uint8_t* bk = b + n_vec_byte * k;
		for (unsigned i = 0; i < len_vec; i++) {
			gf256v_madd_avx2(r, a + n_vec_byte * i, bk[i], align_len);
		}
    memcpy(c, r, n_vec_byte);
    memset(r, 0, n_vec_byte);
		c += n_vec_byte;
	}
}

// circ_1 * (a1 a2 ... an) + circ_2 * (an a1 ... a(n-1)) + ... + circ_n * (a2 a3 ... a1)
void gf256mat_mul_circ_avx2(uint8_t* c, const uint8_t* a, const uint8_t* circ, unsigned len_vec) {
	unsigned n_vec_byte = len_vec * len_vec;
	unsigned align_len = ((n_vec_byte + 31) / 32) * 32;
	unsigned char r[((_O * _O + 31) / 32) * 32] __attribute__((aligned(32))) = { 0 };
	uint8_t ext_a[2 * _O * _O + 31] = { 0, };
	
	memcpy(ext_a, a, n_vec_byte);
	memcpy(ext_a + n_vec_byte, a, n_vec_byte);
	//ext_a = (a | a) = (a1 a2 ... an a1 a2 ... an)

	gf256v_set_zero(c, n_vec_byte);
	for (unsigned k = 0; k < len_vec; k++) {
		gf256v_madd_avx2(r, ext_a + len_vec * (len_vec - k), circ[k], align_len);

		gf256v_add_avx2(c, r, n_vec_byte);
		memset(r, 0, n_vec_byte);
	}
	// gf256v_add_avx2(A + i * H_half, mat + i * H, H_half);
}

unsigned gf256mat_solve_linear_eq_avx2(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth) {
	unsigned rr = 1;
	uint8_t temp_mat[H * H] __attribute__((aligned(32)));
	//uint8_t buffer[H*H <<1] __attribute__((aligned(32))) ;
	if (depth == 0) {
		return gf256mat_solve_linear_CORE(output, mat, vec, H);
	}

	unsigned H_half = H >> 1;
	unsigned H_hh = H_half * H_half;

	uint8_t A[H_hh] __attribute__((aligned(32)));
	uint8_t B[H_hh] __attribute__((aligned(32)));
	uint8_t C[H_hh] __attribute__((aligned(32)));
	uint8_t D[H_hh] __attribute__((aligned(32)));
	uint8_t A_inv[H_hh] __attribute__((aligned(32)));
	uint8_t CA_inv[H_hh] __attribute__((aligned(32)));

	uint8_t temp_vec[H] __attribute__((aligned(32)));
	uint8_t temp_vec2[H] __attribute__((aligned(32)));
	//gf256v_set_zero(temp_vec , H_half);

	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(A + i * H_half, H_half);
		gf256v_set_zero(C + i * H_half, H_half);
		gf256v_add_avx2(A + i * H_half, mat + i * H, H_half);
		gf256v_add_avx2(C + i * H_half, mat + H_half + i * H, H_half);
	} // up to down & left to right
	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(B + i * H_half, H_half);
		gf256v_set_zero(D + i * H_half, H_half);
		gf256v_add_avx2(B + i * H_half, mat + H_half * H + i * H, H_half);
		gf256v_add_avx2(D + i * H_half, mat + H_half * H + H_half + i * H, H_half);
	}
	rr &= gf256mat_inv_avx2(A_inv, A, H_half);
	if (!rr) return rr;

	gf256mat_mul(CA_inv, C, A_inv, H_half);
	gf256mat_prod_avx2(temp_vec + H_half, CA_inv, H_half, H_half, vec);
	gf256v_set_zero(temp_vec, H_half);

	gf256v_add_avx2(temp_vec, vec, H);


	gf256mat_mul(temp_mat, CA_inv, B, H_half);
	gf256v_add_avx2(temp_mat, D, H_half * H_half);

	gf256mat_prod_avx2(temp_vec2, A_inv, H_half, H_half, temp_vec);

	rr &= gf256mat_solve_linear_eq_avx2(temp_vec2 + H_half, temp_mat, H_half, temp_vec + H_half, depth - 1);

	gf256mat_prod_avx2(temp_vec, B, H_half, H_half, temp_vec2 + H_half);

	gf256mat_prod_avx2(output, A_inv, H_half, H_half, temp_vec);

	gf256v_set_zero(output + H_half, H_half);
	gf256v_add_avx2(output, temp_vec2, H);

	return rr;
}

unsigned gf256mat_solve_linear_eq_avx2_modify(const uint8_t* mat, const unsigned H, uint8_t *B, uint8_t *C, uint8_t *D, uint8_t *A_inv) {
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
		gf256v_add_avx2(A + i * H_half, mat + i * H, H_half);
		gf256v_add_avx2(C + i * H_half, mat + H_half + i * H, H_half);
	} // up to down & left to right
	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(B + i * H_half, H_half);
		gf256v_set_zero(D + i * H_half, H_half);
		gf256v_add_avx2(B + i * H_half, mat + H_half * H + i * H, H_half);
		gf256v_add_avx2(D + i * H_half, mat + H_half * H + H_half + i * H, H_half);
	}
	rr &= gf256mat_inv_avx2(A_inv, A, H_half); 
	
	return rr;
}

// unsigned gf256mat_solve_linear_eq_avx2_modify(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth) {
// 	unsigned rr = 1;
// 	uint8_t temp_mat[H * H] __attribute__((aligned(32)));
// 	//uint8_t buffer[H*H <<1] __attribute__((aligned(32))) ;
// 	if (depth == 0) {
// 		return gf256mat_solve_linear_CORE(output, mat, vec, H);
// 	}

// 	unsigned H_half = H >> 1;
// 	unsigned H_hh = H_half * H_half;

// 	uint8_t A[H_hh] __attribute__((aligned(32)));
// 	uint8_t B[H_hh] __attribute__((aligned(32)));
// 	uint8_t C[H_hh] __attribute__((aligned(32)));
// 	uint8_t D[H_hh] __attribute__((aligned(32)));
// 	uint8_t A_inv[H_hh] __attribute__((aligned(32)));
// 	uint8_t CA_inv[H_hh] __attribute__((aligned(32)));

// 	uint8_t temp_vec[H] __attribute__((aligned(32)));
// 	uint8_t temp_vec2[H] __attribute__((aligned(32)));
// 	//gf256v_set_zero(temp_vec , H_half);

// 	for (unsigned i = 0; i < H_half; i++) {
// 		gf256v_set_zero(A + i * H_half, H_half);
// 		gf256v_set_zero(C + i * H_half, H_half);
// 		gf256v_add_avx2(A + i * H_half, mat + i * H, H_half);
// 		gf256v_add_avx2(C + i * H_half, mat + H_half + i * H, H_half);
// 	} // up to down & left to right
// 	for (unsigned i = 0; i < H_half; i++) {
// 		gf256v_set_zero(B + i * H_half, H_half);
// 		gf256v_set_zero(D + i * H_half, H_half);
// 		gf256v_add_avx2(B + i * H_half, mat + H_half * H + i * H, H_half);
// 		gf256v_add_avx2(D + i * H_half, mat + H_half * H + H_half + i * H, H_half);
// 	}
// 	rr &= gf256mat_inv_avx2(A_inv, A, H_half); 
// 	if (!rr) return rr;

// 	gf256mat_mul(CA_inv, C, A_inv, H_half); 
// 	gf256mat_prod_avx2(temp_vec + H_half, CA_inv, H_half, H_half, vec);
// 	gf256v_set_zero(temp_vec, H_half);

// 	gf256v_add_avx2(temp_vec, vec, H);


// 	gf256mat_mul(temp_mat, CA_inv, B, H_half);
// 	gf256v_add_avx2(temp_mat, D, H_half * H_half);

// 	gf256mat_prod_avx2(temp_vec2, A_inv, H_half, H_half, temp_vec);

// 	rr &= gf256mat_gaussian_elim_avx2(temp_mat, temp_vec + H_half, H_half);
// 	gf256mat_back_substitute_avx2(temp_vec + H_half, temp_mat, H_half);

// 	memcpy(temp_vec2 + H_half, temp_vec + H_half, H_half);

// 	gf256mat_prod_avx2(temp_vec, B, H_half, H_half, temp_vec2 + H_half);

// 	gf256mat_prod_avx2(output, A_inv, H_half, H_half, temp_vec);

// 	gf256v_set_zero(output + H_half, H_half);
// 	gf256v_add_avx2(output, temp_vec2, H);

// 	return rr;
// }

static
unsigned _gf256mat_gauss_elim_row_echelon_avx2(uint8_t* mat, unsigned h, unsigned w, unsigned offset)
{
	// assert( (w&31)==0 );
	unsigned n_ymm = w >> 5;
	__m128i mask_0 = _mm_setzero_si128();

	// assert( h <= 128 );
#define MAX_H  128
#undef MAX_H

	uint8_t rr8 = 1;
	for (unsigned i = 0; i < h; i++) {
		unsigned idx = offset + i;
		unsigned char i_r16 = idx & 0xf;
		unsigned i_d16 = idx >> 4;
		unsigned i_d32 = idx >> 5;

		uint8_t* mi = mat + i * w;

#if defined( _GE_CADD_EARLY_STOP_ )
		unsigned stop = (i + 8 < h) ? i + 8 : h;
		for (unsigned j = i + 1; j < stop; j++) {
#else
		for (unsigned j = i + 1; j < h; j++) {
#endif
			__m128i piv_i = _mm_load_si128((__m128i*)(mi + i_d16 * 16));
			__m128i is_zero = _mm_cmpeq_epi8(piv_i, mask_0);
			__m128i add_mask = _mm_shuffle_epi8(is_zero, _mm_set1_epi8(i_r16));

			__m256i mask = _mm256_setr_m128i(add_mask, add_mask);
			uint8_t* mj = mat + j * w;

			for (unsigned k = i_d32; k < n_ymm; k++) {
				__m256i p_i = _mm256_load_si256((__m256i*)(mi + k * 32));
				__m256i p_j = _mm256_load_si256((__m256i*)(mj + k * 32));

				p_i ^= mask & p_j;
				_mm256_store_si256((__m256i*)(mi + k * 32), p_i);
			}
		}

		rr8 &= gf256_is_nonzero(mi[idx]); // pivots[i] = mat[i*w + idx] = mi[idx]

		__m128i pi0 = _mm_set1_epi8(mi[idx]);
		__m128i pi1 = tbl_gf256_inv(pi0);

		__m256i pi2 = _mm256_setr_m128i(pi1, pi1);

		for (unsigned k = i_d32; k < n_ymm; k++) {
			__m256i rowi = _mm256_load_si256((__m256i*)(mi + k * 32));
			rowi = tbl32_gf256_mul(rowi, pi2);
			_mm256_store_si256((__m256i*)(mi + k * 32), rowi);
		}

		for (unsigned j = i + 1; j < h; j++) {
			uint8_t* mj = mat + j * w;
			__m256i mm = _mm256_set1_epi8(mj[idx]);

			for (unsigned k = i_d32; k < n_ymm; k++) {
				__m256i rowi = _mm256_load_si256((__m256i*)(mi + k * 32));
				rowi = tbl32_gf256_mul(rowi, mm);
				rowi ^= _mm256_load_si256((__m256i*)(mj + k * 32));
				_mm256_store_si256((__m256i*)(mj + k * 32), rowi);
			}
		}
		}
	return rr8;
	}

unsigned gf256mat_gaussian_elim_avx2(uint8_t* sqmat_a, uint8_t* constant, unsigned len)
{
#define MAX_H  128
	uint8_t mat[MAX_H * (MAX_H + 32)] __attribute__((aligned(32)));
#undef MAX_H
	unsigned height = len;
	unsigned width = ((len + 1 + 31) >> 5) << 5;
	unsigned offset = width - (len + 1);
	for (unsigned i = 0; i < height; i++) {
		uint8_t* ai = mat + i * width;
		for (unsigned j = 0; j < height; j++) ai[offset + j] = sqmat_a[j * len + i];  // transpose since sqmat_a is col-major
		ai[offset + height] = constant[i];
	}
	unsigned char r8 = _gf256mat_gauss_elim_row_echelon_avx2(mat, height, width, offset);

	for (unsigned i = 0; i < height; i++) {
		uint8_t* ai = mat + i * width;
		memcpy(sqmat_a + i * len, ai + offset, len);     // output a row-major matrix
		constant[i] = ai[offset + len];
	}
	return r8;
}

void gf256mat_back_substitute_avx2(uint8_t* constant, const uint8_t* sq_row_mat_a, unsigned len)
{
	//const unsigned MAX_H=96;
#define MAX_H  128
	uint8_t column[MAX_H] __attribute__((aligned(32))) = { 0 };
	uint8_t temp[MAX_H] __attribute__((aligned(32)));
#undef MAX_H
	memcpy(temp, constant, len);
	for (int i = len - 1; i > 0; i--) {
		for (int j = 0; j < i; j++) column[j] = sq_row_mat_a[j * len + i];   // row-major -> column-major, i.e., transpose
		column[i] = 0;
		unsigned len_t = ((i + 31) >> 5) << 5;
		gf256v_madd_avx2(temp, column, temp[i], len_t);
	}
	memcpy(constant, temp, len);
}

// For _O-degree polynomials
// In : poly = a_n * x^n + ... + a_1 * x + a_0 with len = n + 1
// Out : n where a_n != 0
uint8_t degree_check(uint8_t *poly)
{
  uint8_t n = _HALF_O - 1;

  for (int i = n; i >= 0; i--)
  {
    if (poly[i]) break;
	n -= 1;
  }
  n += (n==255);

  return n;
}

// Polynomial multiplication routine in extended Euclidean algorithm 
void gf256poly_mult_avx2(uint8_t* acc_poly, uint8_t* poly1, uint8_t* poly2)
{
	uint8_t deg_poly2 = degree_check(poly2);
	uint8_t tmp1[_O] __attribute__((aligned(32)));
	uint8_t* t_p = tmp1 + _HALF_O;

	unsigned n_ymm = ((_HALF_O + 31) >> 5);
	uint8_t r[_HALF_O] __attribute__((aligned(32)));
	__m256i r_t[8];

	for (unsigned i = 0; i < n_ymm; i++) r_t[i] = _mm256_setzero_si256();
	__m256i mask_f = _mm256_load_si256((__m256i const*) __mask_low);

	uint8_t multab[160 * 32] __attribute__((aligned(32)));
	gf256v_generate_multab_sse(multab, poly2, deg_poly2 + 1);

	memcpy(r, acc_poly, _HALF_O);
	memcpy(tmp1, poly1, _HALF_O);
	memcpy(tmp1 + _HALF_O, poly1, _HALF_O);

	for (unsigned i = 0; i <= deg_poly2; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab + i * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);

		for (unsigned j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(t_p + j * 32));
			r_t[j] = _mm256_shuffle_epi8(ml, inp & mask_f);
			r_t[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);
		}
		uint8_t r8[256] __attribute__((aligned(32)));
		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t[j]);

		for (unsigned j = 0; j < _HALF_O; j++) r[j] ^= r8[j];

		t_p -= 1; // shift 1
	}
	memcpy(acc_poly, poly1, _HALF_O);
	memcpy(poly1, r, _HALF_O);
}

// p(x)*s0(x) + q(x)*s1(x) = 1
uint8_t gf256poly_euclidean_avx2(uint8_t* p, uint8_t* q, uint8_t* s0, uint8_t* s1)
{
	int i, j;
	uint8_t deg_q = degree_check(q);
	int deg_pmq = degree_check(p) - deg_q;
	uint8_t a[_HALF_O] __attribute__((aligned(32))) = { 0, };
	uint8_t tmp[_HALF_O] __attribute__((aligned(32))) = { 0, };

	memcpy(tmp, p, _HALF_O);

	if (deg_pmq < 0)
	{
		gf256poly_mult_avx2(s0, s1, a);
		return gf256poly_euclidean_avx2(q, tmp, s0, s1);
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
	gf256poly_mult_avx2(s0, s1, a); // s0 <- s1 , s1 <- s0 + s1*a

	if (degree_check(tmp) == 0)
	{
		return tmp[0];
	}
	
	return gf256poly_euclidean_avx2(q, tmp, s0, s1);
}

uint8_t gf256mat_inv_circ_avx2(uint8_t* inv_circ, uint8_t* circ)
{
	uint8_t tmp[_HALF_O] __attribute__((aligned(32))) = { 0, };
	uint8_t out_tmp[_HALF_O] __attribute__((aligned(32))) = { 0, };
	uint8_t ss[_HALF_O] __attribute__((aligned(32))) = { 1, 0 , };
	uint8_t s0[_HALF_O] __attribute__((aligned(32))) = { 0, };
	uint8_t s1[_HALF_O] __attribute__((aligned(32))) = { 1, 0, };
	uint8_t multmp;
	uint8_t a;

	memcpy(tmp, circ, _HALF_O);

	uint8_t deg_a = degree_check(tmp);
	unsigned deg_ymm = (deg_a + 31) >> 5;

	multmp = gf256_inv(tmp[deg_a]);

	for (unsigned i = 0; i < deg_ymm; i++) {
		__m256i t0 = _mm256_load_si256((__m256i*)(tmp + i * 32));
		__m256i mt = _mm256_set1_epi8(multmp);

		t0 = tbl32_gf256_mul(t0, mt);

		_mm256_store_si256((__m256i*)(out_tmp + i * 32), t0);
	}
	for (int i = 0; i < deg_a; i++) {
		ss[_HALF_O - deg_a + i] = out_tmp[i];
	}

	s0[_HALF_O - deg_a] = multmp;

	a = gf256poly_euclidean_avx2(ss, tmp, s0, s1);
	if (!a) return a;
	gf256v_mul_scalar(s1, gf256_inv(a), _HALF_O);

	memcpy(inv_circ, s1, _HALF_O);

	return !(!a);
}

unsigned gf256mat_solve_linear_eq_avx2_circA(uint8_t* output, const uint8_t* mat, const unsigned H, const uint8_t* vec, uint8_t depth) {
	unsigned rr = 1;
	uint8_t temp_mat[H * H] __attribute__((aligned(32)));

	unsigned H_half = H >> 1;
	unsigned H_hh = H_half * H_half;

	uint8_t ext_mat[H * H] __attribute__((aligned(32)));
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

		return gf256mat_solve_linear_CORE(output, ext_mat, vec, H);
	}

	uint8_t A[H_half] __attribute__((aligned(32)));
	uint8_t B[H_hh] __attribute__((aligned(32)));
	uint8_t C[H_hh] __attribute__((aligned(32)));
	uint8_t D[H_hh] __attribute__((aligned(32)));
	uint8_t A_inv[H_half] __attribute__((aligned(32)));
	uint8_t CA_inv[H_hh] __attribute__((aligned(32)));

	uint8_t temp_vec[H] __attribute__((aligned(32)));
	uint8_t temp_vec2[H] __attribute__((aligned(32)));

	gf256v_set_zero(A, H_half);
	gf256v_add_avx2(A, mat, H_half);
	gf256v_set_zero(C, H_hh);
	gf256v_add_avx2(C, mat + H_half, H_hh); // up to down & left to right
	for (unsigned i = 0; i < H_half; i++) {
		gf256v_set_zero(B + i * H_half, H_half);
		gf256v_set_zero(D + i * H_half, H_half);
		gf256v_add_avx2(B + i * H_half, mat + H_half + H_hh + i * H, H_half);
		gf256v_add_avx2(D + i * H_half, mat + H_half + H_hh + H_half + i * H, H_half);
	}
	rr &= gf256mat_inv_circ_avx2(A_inv, A); // inverse matrix of circulant mat. A (A_inv is row-major)
	if (!rr) return rr;

	gf256mat_mul_circ(CA_inv, C, A_inv, H_half); // matrix * circulant matrix multiplication .. 

	for (unsigned j = 0; j < _HALF_O; j++)
	{
		ext_poly[j] = A_inv[(_HALF_O - 1 - j)];
	}
	memcpy(ext_poly + _HALF_O, ext_poly, _HALF_O);

	gf256mat_prod_avx2(temp_vec + H_half, CA_inv, H_half, H_half, vec);
	gf256v_set_zero(temp_vec, H_half);

	gf256v_add_avx2(temp_vec, vec, H);


	gf256mat_mul(temp_mat, CA_inv, B, H_half);
	gf256v_add_avx2(temp_mat, D, H_half * H_half);

	gf256mat_prod_circ_avx2(temp_vec2, ext_poly, H_half, temp_vec);

	rr &= gf256mat_gaussian_elim_avx2(temp_mat, temp_vec + H_half, H_half);
	gf256mat_back_substitute_avx2(temp_vec + H_half, temp_mat, H_half);

	memcpy(temp_vec2 + H_half, temp_vec + H_half, H_half);

	gf256mat_prod_avx2(temp_vec, B, H_half, H_half, temp_vec2 + H_half);

	gf256mat_prod_circ_avx2(output, ext_poly, H_half, temp_vec);

	gf256v_set_zero(output + H_half, H_half);
	gf256v_add_avx2(output, temp_vec2, H);

	return rr;
}

static inline
uint8_t inverse_CirMat_avx(uint8_t* Ia, uint8_t* Ib, uint8_t* Ic, uint8_t* Id, uint8_t* a, uint8_t* b, uint8_t* c, uint8_t* d, unsigned o_len)
{
	unsigned h_olen = o_len >> 1;
	uint8_t K[_O] __attribute__((aligned(32))) = { 0, };
	uint8_t INV_K[_O] __attribute__((aligned(32))) = { 0, };
	uint8_t TIa[_O] __attribute__((aligned(32))) = { 0, };
	uint8_t TIb[_O] __attribute__((aligned(32))) = { 0, };
	uint8_t TIc[_O] __attribute__((aligned(32))) = { 0, };
	uint8_t TId[_O] __attribute__((aligned(32))) = { 0, };
	uint8_t t;
	uint8_t dbl_d[_PUB_M] __attribute__((aligned(32)));
	uint8_t dbl_c[_PUB_M] __attribute__((aligned(32)));
	unsigned n_ymm = ((h_olen + 31) >> 5);
	__m256i r_t[8], r_t2[8], r_t3[8], r_t4[8];

	// For efficient indexing
	memcpy(dbl_d, d, h_olen);
	memcpy(dbl_c, c, h_olen);
	memcpy(dbl_d + h_olen, d, h_olen);
	memcpy(dbl_c + h_olen, c, h_olen);

	uint8_t* pt = dbl_d + h_olen;
	uint8_t* pt2 = dbl_c + h_olen;

	__m256i mask_f = _mm256_load_si256((__m256i const*) __mask_low);
	uint8_t multab[160 * 32] __attribute__((aligned(32)));
	uint8_t multab2[160 * 32] __attribute__((aligned(32)));
	gf256v_generate_multab_sse(multab, a, h_olen);
	gf256v_generate_multab_sse(multab2, b, h_olen);

	// a[j] load -> d[i-j] & d[i+HO-j] load and mult.
	for (unsigned i = 0; i < h_olen; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab + i * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);

		for (unsigned j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(pt + j * 32));
			r_t[j] = _mm256_shuffle_epi8(ml, inp & mask_f);
			r_t[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);
		}
		uint8_t r8[256] __attribute__((aligned(32)));
		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t[j]);
		for (unsigned j = 0; j < h_olen; j++) K[j] ^= r8[j];

		pt -= 1; // shift 1
	}

	// b[j] load -> c[i-j] & c[i+HO-j] load
	for (unsigned i = 0; i < h_olen; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab2 + i * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);

		for (unsigned j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(pt2 + j * 32));
			r_t[j] = _mm256_shuffle_epi8(ml, inp & mask_f);
			r_t[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);
		}
		uint8_t r8[256] __attribute__((aligned(32)));
		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t[j]);
		for (unsigned j = 0; j < h_olen; j++) K[j] ^= r8[j];

		pt2 -= 1; // shift 1
	}

	t = gf256mat_inv_circ_avx2(INV_K, K);
	if (!t) return t;

	uint8_t dbl_a[_PUB_M] __attribute__((aligned(32)));
	uint8_t dbl_b[_PUB_M] __attribute__((aligned(32)));

	memcpy(dbl_a, a, h_olen);
	memcpy(dbl_b, b, h_olen);
	memcpy(dbl_a + h_olen, a, h_olen);
	memcpy(dbl_b + h_olen, b, h_olen);

	uint8_t* pt3 = dbl_a + h_olen;
	uint8_t* pt4 = dbl_b + h_olen;
	pt = dbl_d + h_olen;
	pt2 = dbl_c + h_olen;

	gf256v_generate_multab_sse(multab, INV_K, h_olen);

	for (unsigned i = 0; i < h_olen; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab + i * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);

		for (unsigned j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(pt + j * 32));
			r_t[j] = _mm256_shuffle_epi8(ml, inp & mask_f);
			r_t[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);

			__m256i inp2 = _mm256_loadu_si256((__m256i*)(pt2 + j * 32));
			r_t2[j] = _mm256_shuffle_epi8(ml, inp2 & mask_f);
			r_t2[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp2, 4) & mask_f);

			__m256i inp3 = _mm256_loadu_si256((__m256i*)(pt3 + j * 32));
			r_t3[j] = _mm256_shuffle_epi8(ml, inp3 & mask_f);
			r_t3[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp3, 4) & mask_f);

			__m256i inp4 = _mm256_loadu_si256((__m256i*)(pt4 + j * 32));
			r_t4[j] = _mm256_shuffle_epi8(ml, inp4 & mask_f);
			r_t4[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp4, 4) & mask_f);
		}
		uint8_t r8[256] __attribute__((aligned(32)));
		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t[j]);
		for (unsigned j = 0; j < h_olen; j++) TIa[j] ^= r8[j];

		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t4[j]);
		for (unsigned j = 0; j < h_olen; j++) TIb[j] ^= r8[j];

		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t2[j]);
		for (unsigned j = 0; j < h_olen; j++) TIc[j] ^= r8[j];

		for (unsigned j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t3[j]);
		for (unsigned j = 0; j < h_olen; j++) TId[j] ^= r8[j];

		pt -= 1; // shift 1
		pt2 -= 1;
		pt3 -= 1;
		pt4 -= 1;
	}

	memcpy(Ia, TIa, h_olen);
	memcpy(Ib, TIb, h_olen);
	memcpy(Ic, TIc, h_olen);
	memcpy(Id, TId, h_olen);

	return t;
}

uint8_t _get_oil_avx(uint8_t* oil, uint8_t* con, uint8_t* a, uint8_t* b, uint8_t* c, uint8_t* d, unsigned o_len)
{
	unsigned h_olen = o_len >> 1;
	unsigned n_ymm = ((h_olen + 31) >> 5); //m=oil
	uint8_t Ia[_O] = { 0, };
	uint8_t Ib[_O] = { 0, };
	uint8_t Ic[_O] = { 0, };
	uint8_t Id[_O] = { 0, };
	uint8_t EXTIa[_PUB_M << 1] __attribute__((aligned(32))) = { 0, };
	uint8_t EXTIb[_PUB_M << 1] __attribute__((aligned(32))) = { 0, };
	uint8_t EXTIc[_PUB_M << 1] __attribute__((aligned(32))) = { 0, };
	uint8_t EXTId[_PUB_M << 1] __attribute__((aligned(32))) = { 0, };
	uint8_t temp2[_PUB_M << 1] __attribute__((aligned(32))) = { 0, };

	unsigned f_olen = o_len;

	uint8_t t;
	unsigned i, j;
	memset(oil, 0, f_olen);

	__m256i r_t[8], r_t2[8];
	__m256i mask_f = _mm256_load_si256((__m256i const*) __mask_low);

	for (i = 0; i < n_ymm; i++) r_t[i] = _mm256_setzero_si256();
	for (i = 0; i < n_ymm; i++) r_t2[i] = _mm256_setzero_si256();

	t = inverse_CirMat_avx(Ia, Ib, Ic, Id, a, b, c, d, o_len);
	if (!t) return t;

	EXTIa[0] = Ia[0];
	EXTIa[h_olen] = Ia[0];
	EXTIb[0] = Ib[0];
	EXTIb[h_olen] = Ib[0];
	EXTIc[0] = Ic[0];
	EXTIc[h_olen] = Ic[0];
	EXTId[0] = Id[0];
	EXTId[h_olen] = Id[0];

	for (i = 1; i < h_olen; i++) {
		EXTIa[h_olen - i] = Ia[i];
		EXTIa[(h_olen << 1) - i] = Ia[i];
		EXTIb[h_olen - i] = Ib[i];
		EXTIb[(h_olen << 1) - i] = Ib[i];
		EXTIc[h_olen - i] = Ic[i];
		EXTIc[(h_olen << 1) - i] = Ic[i];
		EXTId[h_olen - i] = Id[i];
		EXTId[(h_olen << 1) - i] = Id[i];
	}


	uint8_t multab[160 * 32] __attribute__((aligned(32)));
	gf256v_generate_multab_sse(multab, con, o_len);

	uint8_t* pt = EXTIa + h_olen;
	uint8_t* pt2 = EXTIc + h_olen;

	for (i = 0; i < h_olen; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab + i * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);

		for (j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(pt + j * 32));
			r_t[j] = _mm256_shuffle_epi8(ml, inp & mask_f);
			r_t[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);

			__m256i inp2 = _mm256_loadu_si256((__m256i*)(pt2 + j * 32));
			r_t2[j] = _mm256_shuffle_epi8(ml, inp2 & mask_f);
			r_t2[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp2, 4) & mask_f);
		}
		uint8_t r8[256] __attribute__((aligned(32)));
		for (j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t[j]);
		for (j = 0; j < h_olen; j++) temp2[j] ^= r8[j];

		for (j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t2[j]);
		for (j = 0; j < h_olen; j++) temp2[j + h_olen] ^= r8[j];
		pt -= 1; // shift 1
		pt2 -= 1;
	}


	pt = EXTIb + h_olen;
	pt2 = EXTId + h_olen;

	for (i = 0; i < h_olen; i++) {
		__m256i mt = _mm256_load_si256((__m256i*)(multab + (i + h_olen) * 32));
		__m256i ml = _mm256_permute2x128_si256(mt, mt, 0x00);
		__m256i mh = _mm256_permute2x128_si256(mt, mt, 0x11);

		for (j = 0; j < n_ymm; j++) {
			__m256i inp = _mm256_loadu_si256((__m256i*)(pt + j * 32));
			r_t[j] = _mm256_shuffle_epi8(ml, inp & mask_f);
			r_t[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp, 4) & mask_f);

			__m256i inp2 = _mm256_loadu_si256((__m256i*)(pt2 + j * 32));
			r_t2[j] = _mm256_shuffle_epi8(ml, inp2 & mask_f);
			r_t2[j] ^= _mm256_shuffle_epi8(mh, _mm256_srli_epi16(inp2, 4) & mask_f);


		}
		uint8_t r8[256] __attribute__((aligned(32)));
		for (j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t[j]);
		for (j = 0; j < h_olen; j++) temp2[j] ^= r8[j];

		for (j = 0; j < n_ymm; j++) _mm256_store_si256((__m256i*)(r8 + j * 32), r_t2[j]);
		for (j = 0; j < h_olen; j++) temp2[j + h_olen] ^= r8[j];
		pt -= 1; // shift 1
		pt2 -= 1;
	}

	for (i = 0; i < (h_olen << 1); i++) {
		oil[i] = temp2[i];
	}

	return t;

}