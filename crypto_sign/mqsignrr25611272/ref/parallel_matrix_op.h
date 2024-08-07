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

void batch_trimat_madd_gf256( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch );
void batch_trimatTr_madd_gf256( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch );
void batch_upper_matTr_x_mat_gf256( unsigned char *bC, const unsigned char *A_to_tr, unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
                                    const unsigned char *bB, unsigned Bwidth, unsigned size_batch );
void batch_quad_trimat_eval_gf256( unsigned char * y, const unsigned char * trimat, const unsigned char * x, unsigned dim , unsigned size_batch );

#ifdef  __cplusplus
}
#endif


#endif

