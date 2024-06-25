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

void expand_sparmat_vo(unsigned char* Fq, const unsigned char* sparmat, unsigned size_batch)
{
	memset(Fq, 0, _O * _V * _O);
	for (unsigned i = 0; i < _V; i++) {
		for (unsigned j = 0; j < _O; j++) {
			Fq[((i + j) % _O) * size_batch + j] = sparmat[i * _O + j];

			//Fq[(i * _O + j) * size_batch + (i + j) % _O] = sparmat[i * _O + j];
		}
		Fq += _O * size_batch;
	}
}

void expand_sparmat_vv(unsigned char* Fq, const unsigned char* sparmat, unsigned size_batch)
{
	unsigned char* Fq_pt = Fq;
	memset(Fq, 0, _O * N_TRIANGLE_TERMS(_V));
	for (unsigned i = 0; i < _V; i++) {
		unsigned k = 0;
		for (unsigned j = 0; j < _O; j++) {
			if (i + j + 1 < _V) {
				Fq_pt[(j + 1) * size_batch + j] ^= sparmat[i * _O + j];
			}
			else {
				Fq[k + (_V - 1 - j) * size_batch + j] ^= sparmat[i * _O + j];
				k += (_V - j + _V - 1 - i) * size_batch;
			}
		}
		Fq_pt += (_V - i) * size_batch;
	}

	/*for (unsigned i = 0; i < _V; i++) {
		unsigned k = 0;
		for (unsigned j = 0; j < _O; j++) {
			if (i + j >= _V - 1) {
				Fq[k + (_V - 1 - j) * size_batch + j] = sparmat[i * _O + j];
				k += (_V - j + _V - 1 - i) * size_batch;
			}
			else {
				Fq_pt[(j + 1) * size_batch + j] = sparmat[i * _O + j];
			}
		} 
		Fq_pt += (_V - i) * size_batch;
	}*/
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

void batch_2trimat_madd_gf256( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
	(void)size_Bcolvec;
    unsigned Aheight = Bheight;
	memset(bC, 0, size_batch * Bwidth * Aheight);
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(i==k) continue;
                gf256v_madd( bC , & btriA[ size_batch*(idx_of_2trimat(i,k,Aheight)) ] , gf256v_get_ele( &B[j* Bheight] , k ) , size_batch );
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

void batch_bmatTr_madd_gf256( unsigned char *bC , const unsigned char *bA_to_tr, unsigned Awidth_before_tr,
        const unsigned char *B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch )
{
	(void)size_Bcolvec;
    const unsigned char *bA = bA_to_tr;
    unsigned Aheight = Awidth_before_tr;
	memset(bC, 0, size_batch * Bwidth * Aheight);
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                gf256v_madd( bC , & bA[ size_batch*(i+k*Aheight) ] , gf256v_get_ele( &B[j* Bheight] , k ) , size_batch );
            }
            bC += size_batch;
        }
    }
}

void batch_mat_madd_gf256( unsigned char * bC , const unsigned char* bA , unsigned Aheight,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
	(void)size_Bcolvec;
    unsigned Awidth = Bheight;
	memset(bC, 0, size_batch * Bwidth * Aheight);
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                gf256v_madd( bC , & bA[ k*size_batch ] , gf256v_get_ele( &B[j* Bheight] , k ) , size_batch );
            }
            bC += size_batch;
        }
        bA += (Awidth)*size_batch;
    }
}

void batch_quad_trimat_eval_gf256( unsigned char * y, const unsigned char * trimat, const unsigned char * x, unsigned dim , unsigned size_batch )
{
    unsigned char tmp[256];

    unsigned char _x[256];
    for(unsigned i=0;i<dim;i++) _x[i] = gf256v_get_ele( x , i );

    gf256v_set_zero( y , size_batch );
    for(unsigned i=0;i<dim;i++) {
        gf256v_set_zero( tmp , size_batch );
        for(unsigned j=i;j<dim;j++) {
           gf256v_madd( tmp , trimat , _x[j] , size_batch );
           trimat += size_batch;
        }
        gf256v_madd( y , tmp , _x[i] , size_batch );
    }
}

void batch_quad_recmat_eval_gf256( unsigned char * z, const unsigned char * y, unsigned dim_y, const unsigned char * mat,
        const unsigned char * x, unsigned dim_x , unsigned size_batch )
{
///
///    assert( dim_x <= 128 );
///    assert( dim_y <= 128 );
///    assert( size_batch <= 128 );
    unsigned char tmp[128];

    unsigned char _x[128];
    for(unsigned i=0;i<dim_x;i++) _x[i] = gf256v_get_ele( x , i );
    unsigned char _y[128];
    for(unsigned i=0;i<dim_y;i++) _y[i] = gf256v_get_ele( y , i );

    gf256v_set_zero( z , size_batch );
    for(unsigned i=0;i<dim_y;i++) {
        gf256v_set_zero( tmp , size_batch );
        for(unsigned j=0;j<dim_x;j++) {
           gf256v_madd( tmp , mat , _x[j] , size_batch );
           mat += size_batch;
        }
        gf256v_madd( z , tmp , _y[i] , size_batch );
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

void sparmat_vv_eval(unsigned char* y, const unsigned char* sparmat, const unsigned char* x, unsigned size_batch)
{
	// for vinegar - vinegar matrix evaluation
	unsigned char tmp_mat[_O * _V] = { 0, };
	unsigned char rot_mat[_O * _V] = { 0, };
	unsigned char tmp[256] = { 0, };
	unsigned char _z[_O << 1] = { 0, };

	memset(y, 0, _O);
	for (unsigned i = 0; i < _V; i++) {
		memset(tmp, 0, size_batch);
		gf256v_madd(tmp, sparmat + i * _O, x[i], size_batch);
		memcpy(tmp_mat + i * size_batch, tmp, size_batch);
	}
	for (unsigned i = 0; i < _V; i++) {
		for (unsigned j = 0; j < _O; j++) {
			rot_mat[((i + j + 1) % _V) * _O + j] = tmp_mat[i * _O + j];
		}
	}
	for (unsigned i = 0; i < _V; i++) {
		gf256v_madd(_z, rot_mat + i * _O, x[i], size_batch);
	}
	memcpy(y, _z, _O);
}

void sparmat_gen_linear(unsigned char* mat, const unsigned char* sparmat, const unsigned char* x, unsigned size_batch)
{
	// for vinegar - oil 
	// generate linear system for oil variables 
	unsigned char tmp[256] = { 0, };

	memset(mat, 0, _O * _O);
	for (unsigned i = 0; i < _V; i++) {
		memset(tmp, 0, size_batch);
		gf256v_madd(tmp, sparmat + i * _O, x[i], size_batch);

		for (unsigned j = 0; j < _O; j++) {
			mat[((i + j) % _O) * size_batch + j] ^= tmp[j];
		}
	}
}