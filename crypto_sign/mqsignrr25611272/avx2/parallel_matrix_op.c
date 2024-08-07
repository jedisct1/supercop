#include "blas_comm.h"
#include "blas.h"
#include "mqs_config.h"
#include "mqs_keypair.h"
#include "parallel_matrix_op.h"
#include "utils_malloc.h"

#ifdef _MQS256_148_96
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
#endif
