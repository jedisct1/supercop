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
#include <string.h>
#include "mqs_config.h"
#include "mqs_blas_simd.h"

#define _GE_CADD_EARLY_STOP_


#ifndef _mm256_set_m128i
#define _mm256_set_m128i(v0, v1)  _mm256_insertf128_si256(_mm256_castsi128_si256(v1), (v0), 1)
#define _mm256_setr_m128i(v0, v1) _mm256_set_m128i((v1), (v0))
#endif 

static
void gf256mat_blockmat_madd_avx2( __m256i *dest, const uint8_t *org_mat, unsigned mat_vec_byte, unsigned blk_st_idx, unsigned blk_vec_byte,
                                  const __m256i *multab_vec_ele, unsigned n_vec_ele ) {
    unsigned n_full_ymm = blk_vec_byte >> 5;
    unsigned n_rem_byte = blk_vec_byte & 31;
    __m256i mask_f = _mm256_set1_epi8(0xf);

    org_mat += blk_st_idx;
    if (!n_rem_byte) {
        for (unsigned i = 0; i < n_vec_ele; i++ ) {
            __m256i m_tab = multab_vec_ele[0];
            multab_vec_ele ++;
            __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
            __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

            for (unsigned j = 0; j < n_full_ymm; j++) {
                __m256i mj = _mm256_loadu_si256( (__m256i *)(org_mat + j * 32) );
                dest[j] ^= linear_transform_8x8_256b( ml, mh, mj, mask_f );
            }
            org_mat += mat_vec_byte;
        }
    } else {
        for (unsigned i = 0; i < n_vec_ele - 1; i++ ) {
            __m256i m_tab = multab_vec_ele[0];
            multab_vec_ele ++;
            __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
            __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

            for (unsigned j = 0; j < n_full_ymm + 1; j++) {
                __m256i mj = _mm256_loadu_si256( (__m256i *)(org_mat + j * 32) );
                dest[j] ^= linear_transform_8x8_256b( ml, mh, mj, mask_f );
            }
            org_mat += mat_vec_byte;
        }{  // i = n_vec_ele-1;
            __m256i m_tab = multab_vec_ele[0];
            multab_vec_ele ++;
            __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
            __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

            for (unsigned j = 0; j < n_full_ymm; j++) {
                __m256i mj = _mm256_loadu_si256( (__m256i *)(org_mat + j * 32) );
                dest[j] ^= linear_transform_8x8_256b( ml, mh, mj, mask_f );
            } //if( n_rem_byte )
            {
                // unsigned j=n_full_ymm
                __m256i mj = _load_ymm( org_mat + (n_full_ymm * 32), n_rem_byte );
                dest[n_full_ymm] ^= linear_transform_8x8_256b( ml, mh, mj, mask_f );
            }
        }
    }
}

static void gf256mat_prod_multab_1ymm_avx2( uint8_t *c, const uint8_t *matA, unsigned matA_vec_byte, unsigned matA_n_vec, const __m256i *multabs ) {
    __m256i tmp = _mm256_setzero_si256();
    __m256i mask_f = _mm256_set1_epi8(0xf);
    for (unsigned i = 0; i < matA_n_vec - 1; i++) {
        __m256i m_tab = multabs[i];
        __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
        __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

        __m256i mj = _mm256_loadu_si256( (__m256i *)matA );
        tmp ^= linear_transform_8x8_256b( ml, mh, mj, mask_f );
        matA += matA_vec_byte;
    }{
        unsigned i = matA_n_vec - 1;
        __m256i m_tab = multabs[i];
        __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
        __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

        __m256i mj = (32 == matA_vec_byte) ? _mm256_loadu_si256((const __m256i *)matA) : _load_ymm( matA, matA_vec_byte );
        tmp ^= linear_transform_8x8_256b( ml, mh, mj, mask_f );
    }
    _store_ymm( c, matA_vec_byte, tmp );
    //storeu_ymm( c , matA_vec_byte , blockmat_vec );
}

static void gf256mat_prod_multab_2ymm_avx2( uint8_t *c, const uint8_t *matA, unsigned matA_vec_byte, unsigned matA_n_vec, const __m256i *multabs ) {
    __m256i tmp0 = _mm256_setzero_si256();
    __m256i tmp1 = _mm256_setzero_si256();
    __m256i mask_f = _mm256_set1_epi8(0xf);
    for (unsigned i = 0; i < matA_n_vec - 1; i++) {
        __m256i m_tab = multabs[i];
        __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
        __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

        __m256i mj0 = _mm256_loadu_si256( (__m256i *)matA );
        __m256i mj1 = _mm256_loadu_si256( (__m256i *)(matA + 32) );
        tmp0 ^= linear_transform_8x8_256b( ml, mh, mj0, mask_f );
        tmp1 ^= linear_transform_8x8_256b( ml, mh, mj1, mask_f );
        matA += matA_vec_byte;
    }{
        unsigned i = matA_n_vec - 1;
        __m256i m_tab = multabs[i];
        __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
        __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

        __m256i mj0 = _mm256_loadu_si256( (__m256i *)matA );
        __m256i mj1 = (64 == matA_vec_byte) ? _mm256_loadu_si256( (__m256i *)(matA + 32) ) : _load_ymm( matA + 32, matA_vec_byte - 32 );
        tmp0 ^= linear_transform_8x8_256b( ml, mh, mj0, mask_f );
        tmp1 ^= linear_transform_8x8_256b( ml, mh, mj1, mask_f );
    }
    _mm256_storeu_si256( (__m256i *)c, tmp0 );
    _store_ymm( c + 32, matA_vec_byte - 32, tmp1 );
}

static void gf256mat_prod_multab_3ymm_avx2( uint8_t *c, const uint8_t *matA, unsigned matA_vec_byte, unsigned matA_n_vec, const __m256i *multabs ) {
    __m256i tmp0 = _mm256_setzero_si256();
    __m256i tmp1 = _mm256_setzero_si256();
    __m256i tmp2 = _mm256_setzero_si256();
    __m256i mask_f = _mm256_set1_epi8(0xf);
    for (unsigned i = 0; i < matA_n_vec - 1; i++) {
        __m256i m_tab = multabs[i];
        __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
        __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

        __m256i mj0 = _mm256_loadu_si256( (__m256i *)matA );
        __m256i mj1 = _mm256_loadu_si256( (__m256i *)(matA + 32) );
        __m256i mj2 = _mm256_loadu_si256( (__m256i *)(matA + 64) );
        tmp0 ^= linear_transform_8x8_256b( ml, mh, mj0, mask_f );
        tmp1 ^= linear_transform_8x8_256b( ml, mh, mj1, mask_f );
        tmp2 ^= linear_transform_8x8_256b( ml, mh, mj2, mask_f );
        matA += matA_vec_byte;
    }{
        unsigned i = matA_n_vec - 1;
        __m256i m_tab = multabs[i];
        __m256i ml = _mm256_permute2x128_si256( m_tab, m_tab, 0 );
        __m256i mh = _mm256_permute2x128_si256( m_tab, m_tab, 0x11 );

        __m256i mj0 = _mm256_loadu_si256( (__m256i *)matA );
        __m256i mj1 = _mm256_loadu_si256( (__m256i *)(matA + 32) );
        __m256i mj2 = (96 == matA_vec_byte) ? _mm256_loadu_si256( (__m256i *)(matA + 64) ) : _load_ymm( matA + 64, matA_vec_byte - 64 );
        tmp0 ^= linear_transform_8x8_256b( ml, mh, mj0, mask_f );
        tmp1 ^= linear_transform_8x8_256b( ml, mh, mj1, mask_f );
        tmp2 ^= linear_transform_8x8_256b( ml, mh, mj2, mask_f );
    }
    _mm256_storeu_si256( (__m256i *)c, tmp0 );
    _mm256_storeu_si256( (__m256i *)(c + 32), tmp1 );
    _store_ymm( c + 64, matA_vec_byte - 64, tmp2 );
}
static void gf256mat_prod_multab_small_avx2( uint8_t *c, const uint8_t *matA, unsigned matA_vec_byte, unsigned matA_n_vec, const __m256i *multabs ) {
    // XXX: if(matA_vec_byte <16 ) exit(-1);
    if     (matA_vec_byte <= 32) {
        gf256mat_prod_multab_1ymm_avx2(c, matA, matA_vec_byte, matA_n_vec, multabs);
        return;
    } else if (matA_vec_byte <= 64) {
        gf256mat_prod_multab_2ymm_avx2(c, matA, matA_vec_byte, matA_n_vec, multabs);
        return;
    } else {
        gf256mat_prod_multab_3ymm_avx2(c, matA, matA_vec_byte, matA_n_vec, multabs);
        return;
    }
}

void gf256mat_prod_multab_avx2( uint8_t *c, const uint8_t *matA, unsigned matA_vec_byte, unsigned matA_n_vec, const uint8_t *multab_b ) {
    const __m256i *multabs = (const __m256i *)multab_b;
    if ( 96 >= matA_vec_byte ) {
        gf256mat_prod_multab_small_avx2(c, matA, matA_vec_byte, matA_n_vec, multabs);
        return;
    }

    while (matA_n_vec) {
        unsigned n_ele = matA_n_vec;

        unsigned vec_len_to_go = matA_vec_byte;
        while ( vec_len_to_go ) {
            unsigned block_len = (vec_len_to_go >= 8 * 32) ? 8 * 32 : vec_len_to_go;
            unsigned block_st_idx = matA_vec_byte - vec_len_to_go;

            __m256i blockmat_vec[8];
            for (int i = 0; i < 8; i++) {
                blockmat_vec[i] = _mm256_setzero_si256();
            }
            gf256mat_blockmat_madd_avx2( blockmat_vec, matA, matA_vec_byte, block_st_idx, block_len, multabs, n_ele );
            storeu_ymm( c + block_st_idx, block_len, blockmat_vec );

            vec_len_to_go -= block_len;
        }

        matA_n_vec -= n_ele;
        multabs += n_ele;
        matA += n_ele * matA_vec_byte;
    }
}

void gf256mat_prod_multabs_avx2(uint8_t* c, const uint8_t* matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t* multab) {
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
