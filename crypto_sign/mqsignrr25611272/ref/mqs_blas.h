#ifndef _MQS_BLAS_H_
#define _MQS_BLAS_H_

#include "blas.h"
#include "parallel_matrix_op.h"
#include "mqs_config.h"

#define gfv_get_ele     gf256v_get_ele

#define gfmat_prod      gf256mat_prod

#define batch_trimat_madd			batch_trimat_madd_gf256
#define batch_trimatTr_madd			batch_trimatTr_madd_gf256
#define batch_upper_matTr_x_mat     batch_upper_matTr_x_mat_gf256

#define batch_quad_trimat_eval		batch_quad_trimat_eval_gf256
#endif 

