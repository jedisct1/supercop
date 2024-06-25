#include "mqs_keypair.h"
#include "mqs_keypair_computation.h"

#include "blas_comm.h"
#include "blas.h"
#include "mqs_blas.h"

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "utils_malloc.h"

void extpk_to_pk(pk_mqs* pk, const ext_pk* extpk)
{
	const unsigned char* idx = extpk->quad1;
	for (unsigned i = 0; i < _V; i++) {
		for (unsigned j = i; j < _V; j++) {
			unsigned pub_idx = idx_of_trimat(i, j, _PUB_N);
			memcpy(&pk->pk[_PUB_M_BYTE * pub_idx], idx, _O);
			idx += _O;
		}
	}
	idx = extpk->quad2;
	for (unsigned i = 0; i < _V; i++) {
		for (unsigned j = _V; j < _V + _O; j++) {
			unsigned pub_idx = idx_of_trimat(i, j, _PUB_N);
			memcpy(&pk->pk[_PUB_M_BYTE * pub_idx], idx, _O);
			idx += _O;
		}
	}
	idx = extpk->quad3;
	for (unsigned i = _V; i < _V + _O; i++) {
		for (unsigned j = i; j < _V + _O; j++) {
			unsigned pub_idx = idx_of_trimat(i, j, _PUB_N);
			memcpy(&pk->pk[_PUB_M_BYTE * pub_idx], idx, _O);
			idx += _O;
		}
	}

#if defined PUBMAP_QUAD_LIN
	memcpy(pk->pk + (_PUB_M)* N_TRIANGLE_TERMS(_PUB_N), extpk->linear, _O * _PUB_N);
#elif defined PUBMAP_QUAD_LIN_CONST
	memcpy(pk->pk + (_PUB_M)* N_TRIANGLE_TERMS(_PUB_N) + _O * _PUB_N, extpk->constants, _O);
#endif
}

// Choosing implementations depends on the macros: _BLAS_SSE_ and _BLAS_AVX2_
#if defined(_BLAS_AVX2_)
#include "mqs_keypair_computation_simd.h"
#define cal_ext_pk_mqrr_impl			cal_ext_pk_mqrr_simd
#define cal_ext_pk_mqrr_circA_impl		cal_ext_pk_mqrr_circA_simd
#define cal_ext_pk_mqsr_impl			cal_ext_pk_mqsr_simd

#else

#define cal_ext_pk_mqrr_impl			cal_ext_pk_mqrr_ref
#define cal_ext_pk_mqrr_circA_impl		cal_ext_pk_mqrr_circA_ref
#define cal_ext_pk_mqsr_impl			cal_ext_pk_mqsr_ref
// implement ref version 

#endif 


///////////////////////////////////////////////////////////////////////


void cal_ext_pk_mqrr(ext_pk* Qs, const sk_mqrr* Fs, const sk_mqrr* Ts)
{
	cal_ext_pk_mqrr_impl(Qs, Fs, Ts);
}
