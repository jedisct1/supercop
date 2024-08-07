#include "blas_comm.h"
#include "blas.h"
#include "mqs_config.h"
#include "mqs_keypair.h"
#include "parallel_matrix_op.h"
#include "utils_malloc.h"

/////////////////  matrix multiplications  /////////////////
void batch_trimat_madd_gf256( unsigned char *bC, const unsigned char *btriA,
                              const unsigned char *B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch ) {
#define MAX_O_BYTE  (96)
    uint8_t tmp_c[MAX_O_BYTE];
#undef MAX_O_BYTE
// access fixed positions of destination matrix C
    unsigned Aheight = Bheight;
    for (unsigned i = 0; i < Aheight; i++) {
        for (unsigned j = 0; j < Bwidth; j++) {
            gf256mat_prod( tmp_c, btriA, size_batch, Aheight - i, B + j * size_Bcolvec + i );
            gf256v_add( bC, tmp_c, size_batch);
            bC += size_batch;
        }
        btriA += size_batch * (Aheight - i);
    }
}

void batch_trimatTr_madd_gf256( unsigned char *bC, const unsigned char *btriA,
                                const unsigned char *B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch ) {
#define MAX_O_BYTE  (96)
#define MAX_V      (148)
    uint8_t tmp_c[MAX_O_BYTE];
    uint8_t tmp_Arow[MAX_V * MAX_O_BYTE];
#undef MAX_O_BYTE
#undef MAX_V

// access fixed positions of destination matrix C
    unsigned Aheight = Bheight;
    for (unsigned i = 0; i < Aheight; i++) {
        const uint8_t *ptr = btriA + i * size_batch;
        for (unsigned j = 0; j < i; j++) {
            memcpy( tmp_Arow + j * size_batch, ptr, size_batch );
            ptr += (Aheight - j - 1) * size_batch;
        }
        memcpy( tmp_Arow + i * size_batch, ptr, size_batch );

        for (unsigned j = 0; j < Bwidth; j++) {
            gf256mat_prod( tmp_c, tmp_Arow, size_batch, i + 1, B + j * size_Bcolvec );
            gf256v_add( bC, tmp_c, size_batch);
            bC += size_batch;
        }
    }
}


void batch_upper_matTr_x_mat_gf256( unsigned char *bC, const unsigned char *A_to_tr, unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
                                    const unsigned char *bB, unsigned Bwidth, unsigned size_batch ) {
#define MAX_O  (96)
    uint8_t _ALIGN_(32) row[MAX_O * MAX_O]; /// XXX: buffer for maximum row
#undef MAX_O

    unsigned Atr_height = Awidth;
    unsigned Atr_width  = Aheight;
    for (unsigned i = 0; i < Atr_height; i++) {
        gf256mat_prod( row, bB, Bwidth * size_batch, Atr_width, A_to_tr + size_Acolvec * i );
        uint8_t *ptr = bC + i * size_batch;
        for (unsigned j = 0; j < i; j++) {
            gf256v_add( ptr, row + size_batch * j, size_batch );
            ptr += (Bwidth - j - 1) * size_batch;
        }
        memcpy( ptr, row + size_batch * i, size_batch * (Bwidth - i) );
    }
}


////////////////////  "quadratric" matrix evaluation  ////////////////////

void batch_quad_trimat_eval_gf256( unsigned char *y, const unsigned char *trimat, const unsigned char *x, unsigned dim, unsigned size_batch ) {
    unsigned char tmp[256];

    gf256v_set_zero( y, size_batch );
    for (unsigned i = 0; i < dim - 15; i++) {
        gf256mat_prod( tmp, trimat, size_batch, dim - i, x + i );
        gf256v_madd( y, tmp, x[i], size_batch );
        trimat += (dim - i) * size_batch;
    }
    uint8_t quad_terms[128] = {0};
    int idx = 0;
    for (unsigned i = dim - 15; i < dim; i++) {
        gf256v_madd(quad_terms + idx, x + i, x[i], dim - i );
        idx += dim - i;
    }
    gf256mat_prod( tmp, trimat, size_batch, 120, quad_terms );      // 1 + 2 + ... + 15 = 120
    gf256v_add( y, tmp, size_batch );
}
