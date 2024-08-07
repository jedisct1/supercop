#include "blas_comm.h"
#include "blas.h"
#include "mqs_config.h"
#include "mqs_keypair.h"
#include "parallel_matrix_op.h"
#include "utils_malloc.h"

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
	unsigned char* bA = (unsigned char*)malloc(_O * _V * _V);
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

void batch_trimat_madd_gf256( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
	(void)size_Bcolvec;
    unsigned Awidth = Bheight;
    unsigned Aheight = Awidth;
	memset(bC, 0, size_batch * Bwidth * Aheight);
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(k<i) continue;
                gf256v_madd( bC , & btriA[ (k-i)*size_batch ] , gf256v_get_ele( &B[j* Bheight] , k ) , size_batch );
            }
            bC += size_batch;
        }
        btriA += (Aheight-i)*size_batch;
    }
}

void batch_trimatTr_madd_gf256( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
	(void)size_Bcolvec;
    unsigned Aheight = Bheight;
	memset(bC, 0, size_batch * Bwidth * Aheight);
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(i<k) continue;
                gf256v_madd( bC , & btriA[ size_batch*(idx_of_trimat(k,i,Aheight)) ] , gf256v_get_ele( &B[j* Bheight] , k ) , size_batch );
            }
            bC += size_batch;
        }
    }
}

void batch_matTr_madd_gf256( unsigned char * bC , const unsigned char* A_to_tr , unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
        const unsigned char* bB, unsigned Bwidth, unsigned size_batch )
{
	(void)size_Acolvec;
    unsigned Atr_height = Awidth;
    unsigned Atr_width  = Aheight;
	memset(bC, 0, size_batch * Bwidth * Atr_height);
    for(unsigned i=0;i<Atr_height;i++) {
        for(unsigned j=0;j<Atr_width;j++) {
            gf256v_madd( bC , & bB[ j*Bwidth*size_batch ] , gf256v_get_ele( &A_to_tr[Aheight *i] , j ) , size_batch*Bwidth );
        }
        bC += size_batch*Bwidth;
    }
}

void circmat_eval(unsigned char* y, const unsigned char* circmat, const unsigned char* x, unsigned dim, unsigned size_batch)
{
	unsigned char tmp[256] = { 0, };
	unsigned char c[_V << 1] = { 0, };
	unsigned char* c_pt = c;

	gf256v_set_zero(y, size_batch);

	for (unsigned i = 0; i < dim; i++) {
		gf256v_madd(tmp, circmat, x[i], dim);
		circmat += dim;
	}
	gf256v_add(c, tmp, dim); // compute L1(x) ~ Lv(x)

	memcpy(c + dim, c, sizeof(unsigned char) * dim);

	for (unsigned i = 0; i < dim; i++) {
		gf256v_set_zero(tmp, size_batch);

		gf256v_madd(tmp, c_pt, x[i], size_batch);
		c_pt += 1;

		gf256v_add(y, tmp, size_batch);
	}
}
