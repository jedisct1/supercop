#include "blas_comm.h"
#include "blas.h"
#include "blas_matrix_ref.h"

#include <stdint.h>
#include <string.h>

void gf256mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        gf256v_madd(c, matA, b[i], n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}

static inline
void gf256mat_submat(uint8_t* mat2, unsigned w2, unsigned st, const uint8_t* mat, unsigned w, unsigned h)
{
	for (unsigned i = 0; i < h; i++) {
		for (unsigned j = 0; j < w2; j++) mat2[i * w2 + j] = mat[i * w + st + j];
	}
}