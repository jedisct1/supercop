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

void UpperTrianglize( unsigned char * btriC , const unsigned char * bA , unsigned Awidth, unsigned size_batch );

#ifdef  __cplusplus
}
#endif


#endif

