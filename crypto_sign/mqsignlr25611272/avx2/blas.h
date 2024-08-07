#ifndef _BLAS_H_
#define _BLAS_H_

#include <stdint.h>
#include <stdio.h>

#include "blas_config.h"

#ifdef _BLAS_AVX2_

#ifndef _BLAS_UNIT_LEN_
#define _BLAS_UNIT_LEN_ 32
#endif

#include "blas_avx2.h"

#define gf256v_add         gf256v_add_avx2
#define gf256v_madd        gf256v_madd_avx2
#define gf256v_madd_multab gf256v_madd_multab_avx2


#else
error here.
#endif



#include "blas_comm.h"
#include "blas_matrix.h"
#include "blas_matrix_avx2.h"




#endif

