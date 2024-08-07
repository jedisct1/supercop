#include "blas_comm.h"
#include "blas.h"
#include "mqs_config.h"
#include "mqs_keypair.h"
#include "parallel_matrix_op.h"
#include "utils_malloc.h"

#include <string.h>

void UpperTrianglize( unsigned char * btriC , const unsigned char * bA , unsigned Awidth, unsigned size_batch )
{
    unsigned char * runningC = btriC;
    unsigned Aheight = Awidth;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<i;j++) {
            unsigned idx = idx_of_trimat(j,i,Aheight);
            gf256v_add( btriC + idx*size_batch , bA + size_batch*(i*Awidth+j) , size_batch );
        }
        gf256v_add( runningC , bA + size_batch*(i*Awidth+i) , size_batch*(Aheight-i) );
        runningC += size_batch*(Aheight-i);
    }
}

void UpperTrianglize_circ(unsigned char* btriC, const unsigned char* bcirc, unsigned Awidth, unsigned size_batch)
{
	unsigned char* bA = (unsigned char*)adapted_alloc(32, _O * _V * _V);
	unsigned char bcirc2[(_V * _V) << 1];

	for (unsigned i = 0; i < _V; i++) {
		memcpy(bcirc2 + i * 2 * _V, bcirc + i * _V, _V);
		memcpy(bcirc2 + i * 2 * _V + _V, bcirc + i * _V, _V);
	}

	for (unsigned i = 0; i < _V; i++) {
		for (unsigned j = 0; j < _V; j++) {
			memcpy(bA + i * _O * _V + j * _O, bcirc2 + i + j * 2 * _V, size_batch);
		}
	}

	unsigned char* runningC = btriC;
	unsigned Aheight = Awidth;
	for (unsigned i = 0; i < Aheight; i++) {
		for (unsigned j = 0; j < i; j++) {
			unsigned idx = idx_of_trimat(j, i, Aheight);
			gf256v_add(btriC + idx * size_batch, bA + size_batch * (i * Awidth + j), size_batch);
		}
		gf256v_add(runningC, bA + size_batch * (i * Awidth + i), size_batch * (Aheight - i));
		runningC += size_batch * (Aheight - i);
	}

	free(bA);
}
