#ifndef _MPKC_H_
#define _MPKC_H_

#include "blas.h"
#include "string.h"
#include "mqs_config.h"

#define IDX_XSQ(i,n_var) (((2*(n_var)+1-i)*(i)/2)+n_var)

/// xi <= xj
#define IDX_QTERMS_REVLEX(xi,xj) ((xj)*(xj+1)/2 + (xi))

#define mpkc_pub_map_gf256       _mpkc_pub_map_gf256

#ifdef  __cplusplus
extern  "C" {
#endif

static inline
void _mpkc_pub_map_gf256( uint8_t * z , const uint8_t * pk_mat , const uint8_t * w )
{
	uint8_t r[_PUB_M_BYTE] = { 0, };
	uint8_t tmp[_PUB_M_BYTE];
	const unsigned n_var = _PUB_N;

	const uint8_t* quad_mat = pk_mat;
	for (unsigned i = 0; i < n_var; i++) {
		memset(tmp, 0, _PUB_M_BYTE);
		for (unsigned j = i; j < n_var; j++) {
			gf256v_madd(tmp, quad_mat, w[j], _PUB_M_BYTE);
			quad_mat += _PUB_M_BYTE;
		}
		gf256v_madd(r, tmp, w[i], _PUB_M_BYTE);
	}

	memcpy(z, r, _PUB_M_BYTE);
}

#ifdef  __cplusplus
}
#endif


#endif