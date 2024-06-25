#include "mqs_keypair.h"
#include "mqs_keypair_computation.h"
#include "mqs_keypair_computation_simd.h"
#include "blas_comm.h"
#include "blas.h"
#include "mqs_blas.h"
#include "mqs_blas_simd.h"

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "utils_malloc.h"


#if 64 < _V
#define _MALLOC_
#endif

void cal_ext_pk_mqlr_simd(ext_pk* Qs, const sk_mqlr* Fs, const sk_mqlr* Ts)
{
#if defined(_MALLOC_)
	unsigned char* t1 = (unsigned char*)adapted_alloc(32, _V * _O * 32);
	unsigned char* tmp2 = (unsigned char*)adapted_alloc(32, _O * _V * _O);
	unsigned char* tempQ = (unsigned char*)adapted_alloc(32, _O * _O * _O);
#else
	unsigned char _ALIGN_(32) t1[_V * _O * 32];
	unsigned char _ALIGN_(32) tmp2[_O * _V * _O];
	unsigned char _ALIGN_(32) tempQ[_O * _O * _O];
#endif
	gfv_generate_multab(t1, Ts->mat_t, _V * _O);

	// Quadratic part
	memset(Qs->quad1, 0, _O * N_TRIANGLE_TERMS(_V));
	UpperTrianglize_circ(Qs->quad1, Fs->Fq1, _V, _O); // F1 	
	memcpy(Qs->quad2, Fs->Fq2, _O * _V * _O);

	batch_trimat_madd_multab(tmp2, Qs->quad1, t1, _V, _V, _O, _O); // F1*T1
	gf256v_add(Qs->quad2, tmp2, _O * _V * _O); // F1*T1 + F2

	memset(Qs->quad3, 0, _O * N_TRIANGLE_TERMS(_O));

	batch_matTr_madd_multab(tempQ, t1, _V, _V, _O, Qs->quad2, _O, _O); // t1_tr*(F1*T1 + F2)
	UpperTrianglize(Qs->quad3, tempQ, _O, _O);

	batch_trimatTr_madd_multab(tmp2, Qs->quad1, t1, _V, _V, _O, _O); // F1_tr * T1
	gf256v_add(Qs->quad2, tmp2, _O * _V * _O);

	memset(t1, 0, _V * _O * 32);
	memset(tempQ, 0, _O * _O * _O);


#if defined(_MALLOC_)
	free(t1);
	free(tmp2);
	free(tempQ);
#endif
}