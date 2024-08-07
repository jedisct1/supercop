#ifndef _MQS_BLAS_H_
#define _MQS_BLAS_H_

#include "blas.h"
#include "parallel_matrix_op.h"
#include "mqs_config.h"

#define gfv_get_ele     gf256v_get_ele
#define gfv_madd        gf256v_madd

#define gfmat_prod      gf256mat_prod

#define gfmat_inv					gf256mat_inv
#define gfmat_solve_linear_eq       gf256mat_solve_linear_eq

#endif 

