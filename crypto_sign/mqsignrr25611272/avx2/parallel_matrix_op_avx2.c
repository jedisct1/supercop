#include "blas_comm.h"
#include "blas.h"
#include "mqs_keypair.h"
#include "utils_malloc.h"

#include "parallel_matrix_op.h"
#include "parallel_matrix_op_avx2.h"

#include <string.h>

#ifndef _MQS256_148_96
void batch_trimat_madd_multab_gf256_avx2(unsigned char* bC, const unsigned char* btriA,
const unsigned char* B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch)
{
#define MAX_O_BYTE  (96)
    uint8_t tmp_c[MAX_O_BYTE];
#undef MAX_V

// access fixed positions of destination matrix C
    (void)size_Bcolvec; // un-used variable
    const unsigned w_multab = 5;
    unsigned Aheight = Bheight;
    for (unsigned i = 0; i < Aheight; i++) {
        for (unsigned j = 0; j < Bwidth; j++) {
            gf256mat_prod_multab( tmp_c, btriA, size_batch, Aheight - i, B + ((j * Bheight + i) << w_multab) );
            gf256v_add( bC, tmp_c, size_batch);
            bC += size_batch;
        }
        btriA += size_batch * (Aheight - i);
    }
}

void batch_trimatTr_madd_multab_gf256_avx2(unsigned char* bC, const unsigned char* btriA,
	const unsigned char* B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch)
{
#define MAX_O_BYTE  (96)
#define MAX_V      (148)
    uint8_t tmp_c[MAX_O_BYTE];
    uint8_t tmp_Arow[MAX_V * MAX_O_BYTE];
#undef MAX_O_BYTE
#undef MAX_V

// access fixed positions of destination matrix C
    (void)size_Bcolvec; // un-used variable
    const unsigned w_multab = 5;
    unsigned Aheight = Bheight;
    for (unsigned i = 0; i < Aheight; i++) {
        const uint8_t *ptr = btriA + i * size_batch;
        for (unsigned j = 0; j < i; j++) {
            memcpy( tmp_Arow + j * size_batch, ptr, size_batch );
            ptr += (Aheight - j - 1) * size_batch;
        }
        memcpy( tmp_Arow + i * size_batch, ptr, size_batch );
        for (unsigned j = 0; j < Bwidth; j++) {
            gf256mat_prod_multab( tmp_c, tmp_Arow, size_batch, i + 1, B + (j * Bheight << w_multab) );
            gf256v_add( bC, tmp_c, size_batch);
            bC += size_batch;
        }
    }
}

void batch_upper_matTr_x_mat_multab_gf256( unsigned char *bC, const unsigned char *A_to_tr, unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
        const unsigned char *bB, unsigned Bwidth, unsigned size_batch ) {
#define MAX_O  (96)
    uint8_t _ALIGN_(32) row[MAX_O * MAX_O]; /// XXX: buffer for maximum row
#undef MAX_O
    (void)size_Acolvec; // un-used variable
    const unsigned w_multab = 5;
    unsigned Atr_height = Awidth;
    unsigned Atr_width  = Aheight;
    for (unsigned i = 0; i < Atr_height; i++) {
        gf256mat_prod_multab( row, bB, Bwidth * size_batch, Atr_width, A_to_tr + (i * Aheight << w_multab) );

        uint8_t *ptr = bC + i * size_batch;
        for (unsigned j = 0; j < i; j++) {
            gf256v_add( ptr, row + size_batch * j, size_batch );
            ptr += (Bwidth - j - 1) * size_batch;
        }
        memcpy( ptr, row + size_batch * i, size_batch * (Bwidth - i) );
    }
}

#else 

void batch_trimat_madd_multab_gf256_avx2(unsigned char* bC, const unsigned char* btriA,
	const unsigned char* B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch)
{
	(void)size_Bcolvec; // unused
	unsigned Awidth = Bheight;
	unsigned Aheight = Awidth;
	unsigned align_len = ((size_batch + 31) / 32) * 32;

	// For size_batch = _O only 
	unsigned char r[((_O + 31) / 32) * 32] __attribute__((aligned(32))) = { 0 };
	for (unsigned i = 0; i < Aheight; i++) {
		for (unsigned j = 0; j < Bwidth; j++) {
			for (unsigned k = 0; k < Bheight; k++) {
				if (k < i) continue;
				gf256v_madd_multab(r, &btriA[(k - i) * size_batch], &B[(j * Bheight + k) * 32], align_len);
			}
			memcpy(bC, r, size_batch);
			memset(r, 0, size_batch);
			bC += size_batch;
		}
		btriA += (Aheight - i) * size_batch;
	}
}

void batch_matTr_madd_multab_gf256_avx2(unsigned char* bC, const unsigned char* A_to_tr, unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
	const unsigned char* bB, unsigned Bwidth, unsigned size_batch)
{
	(void)size_Acolvec; // unused
	unsigned Atr_height = Awidth;
	unsigned Atr_width = Aheight;
	unsigned align_len = ((size_batch * Bwidth + 31) / 32) * 32;
	// For size_batch = _O only 
	unsigned char r[((_O * _O + 31) / 32) * 32] __attribute__((aligned(32))) = { 0 };
	for (unsigned i = 0; i < Atr_height; i++) {
		for (unsigned j = 0; j < Atr_width; j++) {
			gf256v_madd_multab(r, &bB[j * Bwidth * size_batch], &A_to_tr[(i * Aheight + j) * 32], align_len);
		}
		memcpy(bC, r, size_batch * Bwidth);
		memset(r, 0, size_batch * Bwidth);
		bC += size_batch * Bwidth;
	}
}

void batch_trimatTr_madd_multab_gf256_avx2(unsigned char* bC, const unsigned char* btriA,
	const unsigned char* B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch)
{
	(void)size_Bcolvec; // unused
	unsigned Aheight = Bheight;
	unsigned align_len = ((size_batch + 31) / 32) * 32;
	// For size_batch = _O only 
	unsigned char r[((_O + 31) / 32) * 32] __attribute__((aligned(32))) = { 0 };
	for (unsigned i = 0; i < Aheight; i++) {
		for (unsigned j = 0; j < Bwidth; j++) {
			for (unsigned k = 0; k < Bheight; k++) {
				if (i < k) continue;
				gf256v_madd_multab(r, &btriA[size_batch * (idx_of_trimat(k, i, Aheight))], &B[(j * Bheight + k) * 32], align_len);
			}
			memcpy(bC, r, size_batch);
			memset(r, 0, size_batch);
			bC += size_batch;
		}
	}
}
#endif

#include <stdint.h>

void batch_quad_trimat_eval_multab_gf256_avx2(unsigned char* y, const unsigned char* trimat, const unsigned char* x_multab, unsigned dim, unsigned size_batch)
{
	///    assert( dim <= 128 );
	///    assert( size_batch <= 128 );
	unsigned char tmp[256] __attribute__((aligned(32)));
	unsigned align_len = ((size_batch + 31) / 32) * 32;

	gf256v_set_zero(y, size_batch);
	for (unsigned i = 0; i < dim; i++) {
		gf256v_set_zero(tmp, size_batch);
		for (unsigned j = i; j < dim; j++) {
			gf256v_madd_multab(tmp, trimat, x_multab + 32 * j, align_len);
			trimat += size_batch;
		}
		gf256v_madd_multab(y, tmp, x_multab + 32 * i, align_len);
	}
}
