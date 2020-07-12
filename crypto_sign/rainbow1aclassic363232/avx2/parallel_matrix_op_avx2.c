///  @file parallel_matrix_op_avx2.c
///  @brief the AVX2 implementations for functions in parallel_matrix_op_avx2.h
///
///

#include "blas_comm.h"
#include "blas.h"

#include "parallel_matrix_op.h"
#include "parallel_matrix_op_avx2.h"




////////////////////  matrix multiplications  ///////////////////////////////






void batch_trimat_madd_multab_gf16_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Awidth = Bheight;
    unsigned Aheight = Awidth;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(k<i) continue;
                gf16v_madd_multab_avx2( bC , & btriA[ (k-i)*size_batch ] , &B[(j*Bheight+k)*16] , size_batch );
            }
            bC += size_batch;
        }
        btriA += (Aheight-i)*size_batch;
    }
}

void batch_trimat_madd_multab_gf256_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Awidth = Bheight;
    unsigned Aheight = Awidth;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(k<i) continue;
                gf256v_madd_multab_avx2( bC , & btriA[ (k-i)*size_batch ] , &B[(j*Bheight+k)*32] , size_batch );
            }
            bC += size_batch;
        }
        btriA += (Aheight-i)*size_batch;
    }
}







void batch_trimatTr_madd_multab_gf16_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Aheight = Bheight;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(i<k) continue;
                gf16v_madd_multab_avx2( bC , & btriA[ size_batch*(idx_of_trimat(k,i,Aheight)) ] , &B[(j*Bheight+k)*16] , size_batch );
            }
            bC += size_batch;
        }
    }
}

void batch_trimatTr_madd_multab_gf256_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Aheight = Bheight;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(i<k) continue;
                gf256v_madd_multab_avx2( bC , & btriA[ size_batch*(idx_of_trimat(k,i,Aheight)) ] , &B[(j*Bheight+k)*32] , size_batch );
            }
            bC += size_batch;
        }
    }
}





void batch_2trimat_madd_multab_gf16_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Aheight = Bheight;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(i==k) continue;
                gf16v_madd_multab_avx2( bC , & btriA[ size_batch*(idx_of_2trimat(i,k,Aheight)) ] , &B[(j*Bheight+k)*16] , size_batch );
            }
            bC += size_batch;
        }
    }
}

void batch_2trimat_madd_multab_gf256_avx2( unsigned char * bC , const unsigned char* btriA ,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Aheight = Bheight;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                if(i==k) continue;
                gf256v_madd_multab_avx2( bC , & btriA[ size_batch*(idx_of_2trimat(i,k,Aheight)) ] , &B[(j*Bheight+k)*32] , size_batch );
            }
            bC += size_batch;
        }
    }
}




void batch_matTr_madd_multab_gf16_avx2( unsigned char * bC , const unsigned char* A_to_tr , unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
        const unsigned char* bB, unsigned Bwidth, unsigned size_batch )
{
    (void) size_Acolvec; // unused
    unsigned Atr_height = Awidth;
    unsigned Atr_width  = Aheight;
    for(unsigned i=0;i<Atr_height;i++) {
        for(unsigned j=0;j<Atr_width;j++) {
            gf16v_madd_multab_avx2( bC , & bB[ j*Bwidth*size_batch ] , &A_to_tr[(i*Aheight+j)*16] , size_batch*Bwidth );
        }
        bC += size_batch*Bwidth;
    }
}

void batch_matTr_madd_multab_gf256_avx2( unsigned char * bC , const unsigned char* A_to_tr , unsigned Aheight, unsigned size_Acolvec, unsigned Awidth,
        const unsigned char* bB, unsigned Bwidth, unsigned size_batch )
{
    (void) size_Acolvec; // unused
    unsigned Atr_height = Awidth;
    unsigned Atr_width  = Aheight;
    for(unsigned i=0;i<Atr_height;i++) {
        for(unsigned j=0;j<Atr_width;j++) {
            gf256v_madd_multab_avx2( bC , & bB[ j*Bwidth*size_batch ] , &A_to_tr[(i*Aheight+j)*32] , size_batch*Bwidth );
        }
        bC += size_batch*Bwidth;
    }
}




void batch_bmatTr_madd_multab_gf16_avx2( unsigned char *bC , const unsigned char *bA_to_tr, unsigned Awidth_before_tr,
        const unsigned char *B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    const unsigned char *bA = bA_to_tr;
    unsigned Aheight = Awidth_before_tr;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                gf16v_madd_multab_avx2( bC , & bA[ size_batch*(i+k*Aheight) ] , &B[(j*Bheight+k)*16] , size_batch );
            }
            bC += size_batch;
        }
    }
}

void batch_bmatTr_madd_multab_gf256_avx2( unsigned char *bC , const unsigned char *bA_to_tr, unsigned Awidth_before_tr,
        const unsigned char *B, unsigned Bheight, unsigned size_Bcolvec, unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    const unsigned char *bA = bA_to_tr;
    unsigned Aheight = Awidth_before_tr;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                gf256v_madd_multab_avx2( bC , & bA[ size_batch*(i+k*Aheight) ] , &B[(j*Bheight+k)*32] , size_batch );
            }
            bC += size_batch;
        }
    }
}





void batch_mat_madd_multab_gf16_avx2( unsigned char * bC , const unsigned char* bA , unsigned Aheight,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Awidth = Bheight;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                gf16v_madd_multab_avx2( bC , & bA[ k*size_batch ] , &B[(j*Bheight+k)*16] , size_batch );
            }
            bC += size_batch;
        }
        bA += (Awidth)*size_batch;
    }
}

void batch_mat_madd_multab_gf256_avx2( unsigned char * bC , const unsigned char* bA , unsigned Aheight,
        const unsigned char* B , unsigned Bheight, unsigned size_Bcolvec , unsigned Bwidth, unsigned size_batch )
{
    (void) size_Bcolvec; // unused
    unsigned Awidth = Bheight;
    for(unsigned i=0;i<Aheight;i++) {
        for(unsigned j=0;j<Bwidth;j++) {
            for(unsigned k=0;k<Bheight;k++) {
                gf256v_madd_multab_avx2( bC , & bA[ k*size_batch ] , &B[(j*Bheight+k)*32] , size_batch );
            }
            bC += size_batch;
        }
        bA += (Awidth)*size_batch;
    }
}









////////////////////  "quadratric" matrix evaluation  ///////////////////////////////


#include "stdint.h"

static
void mq_gf16_n96_m64_vartime_avx2_unalign( uint8_t * z , const uint8_t * pk_mat , const uint8_t * w )
{
        uint8_t _x0[96] __attribute__((aligned(32)));
        __m256i mask = _mm256_set1_epi8( 0xf );
        __m128i mask16 = _mm256_castsi256_si128( mask );
        __m128i w0,w1;
        w0 = _mm_loadu_si128( (__m128i*) w );
        w1 = _mm_srli_epi16( w0 , 4 ) & mask16;
        w0 &= mask16;
        _mm_store_si128( (__m128i*) _x0 , _mm_unpacklo_epi8(w0,w1) );
        _mm_store_si128( (__m128i*) (_x0+16) , _mm_unpackhi_epi8(w0,w1) );
        w0 = _mm_loadu_si128( (__m128i*) (w+16) );
        w1 = _mm_srli_epi16( w0 , 4 ) & mask16;
        w0 &= mask16;
        _mm_store_si128( (__m128i*) (_x0+32) , _mm_unpacklo_epi8(w0,w1) );
        _mm_store_si128( (__m128i*) (_x0+48) , _mm_unpackhi_epi8(w0,w1) );
        w0 = _mm_loadu_si128( (__m128i*) (w+32) );
        w1 = _mm_srli_epi16( w0 , 4 ) & mask16;
        w0 &= mask16;
        _mm_store_si128( (__m128i*) (_x0+64) , _mm_unpacklo_epi8(w0,w1) );
        _mm_store_si128( (__m128i*) (_x0+80) , _mm_unpackhi_epi8(w0,w1) );

        __m256i r0 = _mm256_setzero_si256();
        __m256i r1 = _mm256_setzero_si256();
        for(unsigned i=0;i<96;i++) {
                if( 0 == _x0[i] ) {
                        pk_mat += 32*(96-i);
                        continue;
                }
                __m256i temp0 = _mm256_setzero_si256();
                __m256i temp1 = _mm256_setzero_si256();
                __m256i ml;
                for(unsigned j=i;j<96;j++) {
                        unsigned b = _x0[j];
                        ml = _mm256_load_si256( (__m256i*) (__gf16_mulx2 + 32*b) );
                        __m256i inp = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;

                        temp0 ^= _mm256_shuffle_epi8( ml , inp&mask );
                        temp1 ^= _mm256_shuffle_epi8( ml , _mm256_srli_epi16(inp,4)&mask );
                }
                unsigned bb = _x0[i];
                ml = _mm256_load_si256( (__m256i*) (__gf16_mulx2 + 32*bb) );
                r0 ^= _mm256_shuffle_epi8( ml , temp0 );
                r1 ^= _mm256_shuffle_epi8( ml , temp1 );
        }
        __m256i rr = r0^_mm256_slli_epi16(r1,4);
        _mm256_storeu_si256( (__m256i*)z , rr );
}




void batch_quad_trimat_eval_gf16_avx2( unsigned char * y, const unsigned char * trimat, const unsigned char * x, unsigned dim , unsigned size_batch )
{
    if( 96==dim && 32==size_batch ) { mq_gf16_n96_m64_vartime_avx2_unalign( y , trimat , x ); return; }
    batch_quad_trimat_eval_gf16( y , trimat , x , dim , size_batch );
}






void batch_quad_trimat_eval_multab_gf16_avx2( unsigned char * y, const unsigned char * trimat, const unsigned char * x_multab, unsigned dim , unsigned size_batch )
{
///    assert( dim <= 128 );
///    assert( size_batch <= 128 );
    unsigned char tmp[256] __attribute__((aligned(32)));

    gf256v_set_zero( y , size_batch );
    for(unsigned i=0;i<dim;i++) {
        gf16mat_prod_multab_avx2( tmp , trimat , size_batch , dim-i , x_multab+16*i );
        trimat += size_batch*(dim-i);
        gf16v_madd_multab_avx2( y , tmp , x_multab+16*i , size_batch );
    }
}







///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



static
void mq_gf256_n140_m72_vartime_avx2_unalign( uint8_t * z , const uint8_t * pk_mat , const uint8_t * w )
{

    __m256i mask_f = _mm256_set1_epi8( 0xf );

    __m256i r0 = _mm256_setzero_si256();
    __m256i r1 = _mm256_setzero_si256();
    __m256i r2 = _mm256_setzero_si256();
    for(unsigned i=0;i<139;i++) {
        if( 0 == w[i] ) {
            pk_mat += 72*(140-i);
            continue;
        }
        __m256i temp0 = _mm256_setzero_si256();
        __m256i temp1 = _mm256_setzero_si256();
        __m256i temp2 = _mm256_setzero_si256();

        for(unsigned j=i;j<140;j++) {
            unsigned b0 = w[j];
            __m256i tab = _mm256_load_si256((__m256i const *) (__gf256_mul+  b0*32 ));
            __m256i tab_l = _mm256_permute2x128_si256( tab , tab , 0 );
            __m256i tab_h = _mm256_permute2x128_si256( tab , tab , 0x11 );

            __m256i inp0 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;
            __m256i inp1 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;
            __m256i inp2 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 8;

            temp0 ^= linear_transform_8x8_256b( tab_l , tab_h , inp0 , mask_f );
            temp1 ^= linear_transform_8x8_256b( tab_l , tab_h , inp1 , mask_f );
            temp2 ^= linear_transform_8x8_256b( tab_l , tab_h , inp2 , mask_f );
        }
        unsigned b1 = w[i];
        __m256i tab = _mm256_load_si256((__m256i const *) (__gf256_mul+  b1*32 ));
        __m256i tab_l = _mm256_permute2x128_si256( tab , tab , 0 );
        __m256i tab_h = _mm256_permute2x128_si256( tab , tab , 0x11 );

        r0 ^= linear_transform_8x8_256b( tab_l , tab_h , temp0 , mask_f );
        r1 ^= linear_transform_8x8_256b( tab_l , tab_h , temp1 , mask_f );
        r2 ^= linear_transform_8x8_256b( tab_l , tab_h , temp2 , mask_f );
    }

    // last column
    uint8_t temp[32] __attribute__((aligned(32)));

    unsigned b2 = w[139];
    __m256i tab = _mm256_load_si256((__m256i const *) (__gf256_mul+  b2*32 ));
    __m256i tab_l = _mm256_permute2x128_si256( tab , tab , 0 );
    __m256i tab_h = _mm256_permute2x128_si256( tab , tab , 0x11 );

    __m256i inp0 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;
    __m256i inp1 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;
    for(int i=0;i<8;i++) temp[i] = pk_mat[i];
    __m256i inp2 = _mm256_load_si256( (__m256i*)temp );

    inp0 = linear_transform_8x8_256b( tab_l , tab_h , inp0 , mask_f );
    inp1 = linear_transform_8x8_256b( tab_l , tab_h , inp1 , mask_f );
    inp2 = linear_transform_8x8_256b( tab_l , tab_h , inp2 , mask_f );
    r0 ^= linear_transform_8x8_256b( tab_l , tab_h , inp0 , mask_f );
    r1 ^= linear_transform_8x8_256b( tab_l , tab_h , inp1 , mask_f );
    r2 ^= linear_transform_8x8_256b( tab_l , tab_h , inp2 , mask_f );


    _mm256_storeu_si256( (__m256i*)z , r0 );
    _mm256_storeu_si256( (__m256i*)(z+32) , r1 );

    _mm256_store_si256( (__m256i*)temp , r2 );
    for(int i=0;i<8;i++) z[64+i] = temp[i];
}





static
void mq_gf256_n188_m96_vartime_avx2_unalign( uint8_t * z , const uint8_t * pk_mat , const uint8_t * w )
{

    __m256i mask_f = _mm256_set1_epi8( 0xf );

    __m256i r0 = _mm256_setzero_si256();
    __m256i r1 = _mm256_setzero_si256();
    __m256i r2 = _mm256_setzero_si256();
    for(unsigned i=0;i<188;i++) {
        if( 0 == w[i] ) {
            pk_mat += 96*(188-i);
            continue;
        }
        __m256i temp0 = _mm256_setzero_si256();
        __m256i temp1 = _mm256_setzero_si256();
        __m256i temp2 = _mm256_setzero_si256();

        for(unsigned j=i;j<188;j++) {
            unsigned b0 = w[j];
            __m256i tab = _mm256_load_si256((__m256i const *) (__gf256_mul+  b0*32 ));
            __m256i tab_l = _mm256_permute2x128_si256( tab , tab , 0 );
            __m256i tab_h = _mm256_permute2x128_si256( tab , tab , 0x11 );

            __m256i inp0 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;
            __m256i inp1 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;
            __m256i inp2 = _mm256_loadu_si256( (__m256i*)pk_mat ); pk_mat += 32;

            temp0 ^= linear_transform_8x8_256b( tab_l , tab_h , inp0 , mask_f );
            temp1 ^= linear_transform_8x8_256b( tab_l , tab_h , inp1 , mask_f );
            temp2 ^= linear_transform_8x8_256b( tab_l , tab_h , inp2 , mask_f );
        }
        unsigned b1 = w[i];
        __m256i tab = _mm256_load_si256((__m256i const *) (__gf256_mul+  b1*32 ));
        __m256i tab_l = _mm256_permute2x128_si256( tab , tab , 0 );
        __m256i tab_h = _mm256_permute2x128_si256( tab , tab , 0x11 );

        r0 ^= linear_transform_8x8_256b( tab_l , tab_h , temp0 , mask_f );
        r1 ^= linear_transform_8x8_256b( tab_l , tab_h , temp1 , mask_f );
        r2 ^= linear_transform_8x8_256b( tab_l , tab_h , temp2 , mask_f );
    }

    _mm256_storeu_si256( (__m256i*)z , r0 );
    _mm256_storeu_si256( (__m256i*)(z+32) , r1 );
    _mm256_storeu_si256( (__m256i*)(z+64) , r2 );
}





void batch_quad_trimat_eval_gf256_avx2( unsigned char * y, const unsigned char * trimat, const unsigned char * x, unsigned dim , unsigned size_batch )
{
    if( 140==dim && 72==size_batch ) { mq_gf256_n140_m72_vartime_avx2_unalign( y, trimat , x); return; }
    if( 188==dim && 96==size_batch ) { mq_gf256_n188_m96_vartime_avx2_unalign( y, trimat , x); return; }
    batch_quad_trimat_eval_gf256( y , trimat , x , dim , size_batch );
}





void batch_quad_trimat_eval_multab_gf256_avx2( unsigned char * y, const unsigned char * trimat, const unsigned char * x_multab, unsigned dim , unsigned size_batch )
{
///    assert( dim <= 128 );
///    assert( size_batch <= 128 );
    unsigned char tmp[256] __attribute__((aligned(32)));

    gf256v_set_zero( y , size_batch );
    for(unsigned i=0;i<dim;i++) {
        gf256v_set_zero( tmp , size_batch );
        for(unsigned j=i;j<dim;j++) {
           gf256v_madd_multab_avx2( tmp , trimat , x_multab+32*j , size_batch );
           trimat += size_batch;
        }
        gf256v_madd_multab_avx2( y , tmp , x_multab+32*i , size_batch );
    }
}





