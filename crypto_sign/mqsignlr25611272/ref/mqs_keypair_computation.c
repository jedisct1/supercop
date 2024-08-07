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

#define cal_ext_pk_mqlr_impl			cal_ext_pk_mqlr_ref

void cal_ext_pk_mqlr_ref(ext_pk* Qs, const sk_mqlr* Fs, const sk_mqlr* Ts)
{
#if defined(_MALLOC_)
	unsigned char* tmp2 = (unsigned char*)malloc(32, _O * _V * _O);
	unsigned char* tempQ = (unsigned char*)malloc(32, _O * _O * _O);
#else
	unsigned char tmp2[_O * _V * _O];
	unsigned char tempQ[_O * _O * _O];
#endif

	memset(Qs->quad1, 0, _O * N_TRIANGLE_TERMS(_V));
	UpperTrianglize_circ(Qs->quad1, Fs->Fq1, _V, _O); // F1 
	// Quadratic part
	memcpy(Qs->quad2, Fs->Fq2, _O * _V * _O);

	batch_trimat_madd(tmp2, Qs->quad1, Ts->mat_t, _V, _V, _O, _O); // F1*Ts->mat_t
	gf256v_add(Qs->quad2, tmp2, _O * _V * _O); // F1*Ts->mat_t + F2

	memset(Qs->quad3, 0, _O * N_TRIANGLE_TERMS(_O));

	batch_matTr_madd(tempQ, Ts->mat_t, _V, _V, _O, Qs->quad2, _O, _O); // Ts->mat_t_tr*(F1*Ts->mat_t + F2)
	UpperTrianglize(Qs->quad3, tempQ, _O, _O);

	batch_trimatTr_madd(tmp2, Qs->quad1, Ts->mat_t, _V, _V, _O, _O); // F1_tr * Ts->mat_t
	gf256v_add(Qs->quad2, tmp2, _O * _V * _O);
	
	memset(tempQ, 0, _O * _O * _O);
	
#if defined(_MALLOC_)
	free(tmp2);
	free(tempQ);
#endif
}

///////////////////////////////////////////////////////////////////////


void cal_ext_pk_mqlr(ext_pk* Qs, const sk_mqlr* Fs, const sk_mqlr* Ts)
{
	cal_ext_pk_mqlr_impl(Qs, Fs, Ts);
}
