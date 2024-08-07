#include "blas_comm.h"
#include "blas.h"
#include "mqs_keypair.h"

#include "parallel_matrix_op.h"
#include "parallel_matrix_op_avx2.h"

#include <string.h>


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
				gf256v_madd_multab_avx2(r, &btriA[(k - i) * size_batch], &B[(j * Bheight + k) * 32], align_len);
			}
			memcpy(bC, r, size_batch);
			memset(r, 0, size_batch);
			bC += size_batch;
		}
		btriA += (Aheight - i) * size_batch;
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
				gf256v_madd_multab_avx2(r, &btriA[size_batch * (idx_of_trimat(k, i, Aheight))], &B[(j * Bheight + k) * 32], align_len);
			}
			memcpy(bC, r, size_batch);
			memset(r, 0, size_batch);
			bC += size_batch;
		}
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
			gf256v_madd_multab_avx2(r, &bB[j * Bwidth * size_batch], &A_to_tr[(i * Aheight + j) * 32], align_len);
		}
		memcpy(bC, r, size_batch * Bwidth);
		memset(r, 0, size_batch * Bwidth);
		bC += size_batch * Bwidth;
	}
}

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
			gf256v_madd_multab_avx2(tmp, trimat, x_multab + 32 * j, align_len);
			trimat += size_batch;
		}
		gf256v_madd_multab_avx2(y, tmp, x_multab + 32 * i, align_len);
	}
}

void circmat_eval_multab_avx2(unsigned char* y, const unsigned char* circmat, const unsigned char* x_multab, unsigned dim, unsigned size_batch)
{
	unsigned char tmp[256] __attribute__((aligned(32))) = { 0, };
	unsigned char c[_V << 1] __attribute__((aligned(32))) = { 0, };
	unsigned char* c_pt = c;
	unsigned align_len = ((size_batch + 31) / 32) * 32;
	unsigned dim_len = ((dim + 31) / 32) * 32;
	assert(align_len < _V);

	gf256v_set_zero(y, size_batch);

	for (unsigned i = 0; i < dim; i++) {
		gf256v_madd_multab_avx2(tmp, circmat, x_multab + 32 * i, dim_len);
		circmat += dim;
	}
	gf256v_add_avx2(c, tmp, dim); // compute L1(x) ~ Lv(x)

	memcpy(c + dim, c, sizeof(unsigned char) * dim);

	for (unsigned i = 0; i < dim; i++) {
		gf256v_set_zero(tmp, size_batch);

		gf256v_madd_multab_avx2(tmp, c_pt, x_multab + 32 * i, align_len);
		c_pt += 1;

		gf256v_add_avx2(y, tmp, size_batch);
	}
}
