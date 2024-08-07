#ifndef _P_MATRIX_OP_AVX2_H_
#define _P_MATRIX_OP_AVX2_H_

#ifdef  __cplusplus
extern  "C" {
#endif


#ifndef _MQS256_148_96
void batch_upper_matTr_x_mat_multab_gf256( unsigned char *bC,
        const unsigned char *multab_A_to_tr, unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
        const unsigned char *bB, unsigned Bwidth, unsigned size_batch );
#else
void batch_matTr_madd_multab_gf256_avx2( unsigned char * bC ,
        const unsigned char* A_to_tr , unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
        const unsigned char* bB, unsigned Bwidth, unsigned size_batch );
#endif

void batch_trimat_madd_multab_gf256_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch );

void batch_trimatTr_madd_multab_gf256_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch );
        
void batch_quad_trimat_eval_multab_gf256_avx2( unsigned char * y, const unsigned char * trimat, const unsigned char * multab_x, unsigned dim , unsigned size_batch );


#ifdef  __cplusplus
}
#endif


#endif

