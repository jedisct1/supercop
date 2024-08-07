#ifndef _MPKC_AVX2_H_
#define _MPKC_AVX2_H_

#include "blas_avx2.h"
#include "mpkc.h"

#include <time.h>


#ifdef  __cplusplus
extern  "C" {
#endif

static inline
void mpkc_pub_map_gf256_avx2( uint8_t * z , const uint8_t * pk_mat , const uint8_t * w )
{
	uint8_t r[((_PUB_M_BYTE+31)/32)*32] __attribute__((aligned(32))) = {0};
	uint8_t tmp[((_PUB_M_BYTE+31)/32)*32] __attribute__((aligned(32)));
	const unsigned n_var = _PUB_N;

	unsigned align_len = ((_PUB_M_BYTE+31)/32)*32;
	
	const uint8_t * quad_mat = pk_mat;
	for(unsigned i=0;i<n_var;i++) {
		memset( tmp , 0 , _PUB_M_BYTE );
		for (unsigned j = i; j < n_var; j++) {
			gf256v_madd( tmp , quad_mat , w[j] , align_len );
			quad_mat += _PUB_M_BYTE;
		}
		gf256v_madd( r , tmp , w[i] , align_len );
	}
	
	memcpy(z, r, _PUB_M_BYTE);
}


#ifdef  __cplusplus
}
#endif

#endif
