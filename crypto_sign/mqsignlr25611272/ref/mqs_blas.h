#ifndef _MQS_BLAS_H_
#define _MQS_BLAS_H_

#include "blas.h"
#include "parallel_matrix_op.h"
#include "mqs_config.h"

#define gfv_get_ele     gf256v_get_ele
#define gfv_mul_scalar  gf256v_mul_scalar
#define gfv_madd        gf256v_madd

#define gfmat_prod      gf256mat_prod

#define batch_trimat_madd			batch_trimat_madd_gf256
#define batch_trimatTr_madd			batch_trimatTr_madd_gf256
#define batch_2trimat_madd			batch_2trimat_madd_gf256
#define batch_matTr_madd			batch_matTr_madd_gf256
#define batch_bmatTr_madd			batch_bmatTr_madd_gf256
#define batch_mat_madd				batch_mat_madd_gf256

#define batch_quad_trimat_eval		batch_quad_trimat_eval_gf256
#define batch_quad_recmat_eval		batch_quad_recmat_eval_gf256

#define circmat_eval circmat_eval
#define sparmat_vv_eval sparmat_vv_eval
#define sparmat_gen_linear sparmat_gen_linear


#define gfmat_inv					gf256mat_inv
#define gfmat_solve_linear_eq       gf256mat_solve_linear_eq

#endif 

