
#ifndef _MPKC_H_
#define _MPKC_H_

#include "blas.h"
#include "string.h"
#include "mqs_config.h"

#define IDX_XSQ(i,n_var) (((2*(n_var)+1-i)*(i)/2)+n_var)

/// xi <= xj
#define IDX_QTERMS_REVLEX(xi,xj) ((xj)*(xj+1)/2 + (xi))

#ifdef _BLAS_AVX2_

#include "mpkc_avx2.h"

#if defined PUBMAP_QUAD
#define mpkc_pub_map_gf256      mpkc_pub_map_quad_gf256_avx2
#elif defined PUBMAP_QUAD_LIN
#define mpkc_pub_map_gf256		mpkc_pub_map_quad_lin_gf256_avx2
#else // defined PUBMAP_QUAD_LIN_CONST
#define mpkc_pub_map_gf256		mpkc_pub_map_quad_lin_const_gf256_avx2
#endif 

#else

#if defined PUBMAP_QUAD
#define mpkc_pub_map_gf256      _mpkc_pub_map_quad_gf256
#elif defined PUBMAP_QUAD_LIN
#define mpkc_pub_map_gf256		_mpkc_pub_map_quad_lin_gf256
#else // defined PUBMAP_QUAD_LIN_CONST
#define mpkc_pub_map_gf256		_mpkc_pub_map_quad_lin_const_gf256
#endif 

#define mpkc_pub_map_gf256       _mpkc_pub_map_gf256

#endif

#ifdef  __cplusplus
extern  "C" {
#endif



#ifdef  __cplusplus
}
#endif


#endif
