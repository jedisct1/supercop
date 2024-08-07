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
}

#define cal_ext_pk_mqrr_impl			cal_ext_pk_mqrr_ref

void cal_ext_pk_mqrr_ref(ext_pk* Qs, const sk_mqrr* Fs, const sk_mqrr* Ts)
{
	memcpy(Qs->quad1, Fs->Fq1, _O * N_TRIANGLE_TERMS(_V));
	memcpy(Qs->quad2, Fs->Fq2, _O * _V * _O);
	memset(Qs->quad3, 0, _O * N_TRIANGLE_TERMS(_O));

	batch_trimat_madd(Qs->quad2, Fs->Fq1, Ts->mat_t, _V, _V, _O, _O);        		// F1*T1 + F2
    batch_upper_matTr_x_mat(Qs->quad3, Ts->mat_t, _V, _V, _O, Qs->quad2, _O, _O );  // T1_tr*(F1*T1 + F2)
    batch_trimatTr_madd(Qs->quad2, Fs->Fq1, Ts->mat_t, _V, _V, _O, _O);       		// F1_tr * T1
}

///////////////////////////////////////////////////////////////////////


void cal_ext_pk_mqrr(ext_pk* Qs, const sk_mqrr* Fs, const sk_mqrr* Ts)
{
	cal_ext_pk_mqrr_impl(Qs, Fs, Ts);
}
