#ifndef _MQS_BLAS_SIMD_H_
#define _MQS_BLAS_SIMD_H_

#include "blas_config.h"
#include "mqs_config.h"

#ifndef _BLAS_AVX2_
error here.
#endif

#include "gf16_avx2.h"
#include "blas_avx2.h"
#include "blas_matrix_avx2.h"
#include "parallel_matrix_op_avx2.h"

#define gfv_generate_multab            gf256v_generate_multab_sse
#define gfmat_prod_multab              gf256mat_prod_multab_avx2
#define batch_quad_trimat_eval_multab  batch_quad_trimat_eval_multab_gf256_avx2

#define batch_trimat_madd_multab    batch_trimat_madd_multab_gf256_avx2
#define batch_trimatTr_madd_multab  batch_trimatTr_madd_multab_gf256_avx2
#define batch_upper_matTr_x_mat_multab     batch_upper_matTr_x_mat_multab_gf256

#ifdef _MQS256_148_96
#define batch_matTr_madd_multab     batch_matTr_madd_multab_gf256_avx2
#endif

#endif


