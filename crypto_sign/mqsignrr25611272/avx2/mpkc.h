
#ifndef _MPKC_H_
#define _MPKC_H_

#include "blas.h"
#include <string.h>
#include "mqs_config.h"

#define IDX_XSQ(i,n_var) (((2*(n_var)+1-i)*(i)/2)+n_var)

/// xi <= xj
#define IDX_QTERMS_REVLEX(xi,xj) ((xj)*(xj+1)/2 + (xi))

#ifdef _BLAS_AVX2_

#include "mpkc_avx2.h"

#define mpkc_pub_map_gf256      mpkc_pub_map_quad_gf256_avx2

#else

#define mpkc_pub_map_gf256       _mpkc_pub_map_gf256

#endif

#ifdef  __cplusplus
extern  "C" {
#endif



#ifdef  __cplusplus
}
#endif


#endif
