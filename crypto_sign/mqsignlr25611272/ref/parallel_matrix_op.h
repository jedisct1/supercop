#ifndef _P_MATRIX_OP_H_
#define _P_MATRIX_OP_H_

#ifdef  __cplusplus
extern  "C" {
#endif

static inline
unsigned idx_of_trimat( unsigned i_row , unsigned j_col , unsigned dim )
{
    return (dim + dim - i_row + 1 )*i_row/2 + j_col - i_row;
}

static inline
unsigned idx_of_2trimat( unsigned i_row , unsigned j_col , unsigned n_var )
{
   if( i_row > j_col ) return idx_of_trimat(j_col,i_row,n_var);
   else return idx_of_trimat(i_row,j_col,n_var);
}

void UpperTrianglize( unsigned char * btriC , const unsigned char * bA , unsigned Awidth, unsigned size_batch );

void UpperTrianglize_circ(unsigned char* btriC, const unsigned char* bcirc, unsigned Awidth, unsigned size_batch);

void batch_trimat_madd_gf256( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch );

void batch_trimatTr_madd_gf256( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch );

void batch_matTr_madd_gf256( unsigned char * bC ,
        const unsigned char* A_to_tr , unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
        const unsigned char* bB, unsigned Bwidth, unsigned size_batch );

void circmat_eval(unsigned char* y, const unsigned char* circmat, const unsigned char* x, unsigned dim, unsigned size_batch);

#ifdef  __cplusplus
}
#endif


#endif