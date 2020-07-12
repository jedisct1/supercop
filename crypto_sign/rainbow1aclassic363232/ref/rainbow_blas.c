
#include "rainbow_blas.h"


void public_map( uint8_t * y, const unsigned char * trimat, const unsigned char * x )
{
#if 16 == _GFSIZE
#if _PUB_M_BYTE > 32
error. _PUB_M_BYTE > 32
#endif
#define VEC_LEN 32
#else
#if _PUB_M_BYTE > 128
error. _PUB_M_BYTE > 128
#endif
#define VEC_LEN 128
#endif
    unsigned char tmp[VEC_LEN*_GFSIZE] = {0};
#if _PUB_N > 256
error. _PUB_N > 256
#endif
    unsigned char _x[256];
    for(unsigned i=0;i<_PUB_N;i++) _x[i] = gfv_get_ele( x , i );
    unsigned char _xixj[256];

    for(unsigned i=0;i<_PUB_N;i++) {
#if defined( _BLAS_AVX2_ )
        unsigned i_start = i-(i&31);
#elif defined( _BLAS_SSE_ )
        unsigned i_start = i-(i&15);
#elif defined( _BLAS_UINT64_ )
        unsigned i_start = i-(i&7);
#else
        unsigned i_start = i-(i&3);
#endif
        for(unsigned j=i;j<_PUB_N;j++) _xixj[j]=_x[j];
        gfv_mul_scalar( _xixj+i_start , _x[i] , _PUB_N-i_start );
        for(unsigned j=i;j<_PUB_N;j++) {
           unsigned idx = _xixj[j];
           if(idx) gf256v_add( tmp+VEC_LEN*idx , trimat , _PUB_M_BYTE );
           trimat += _PUB_M_BYTE;
        }
    }

    gf256v_set_zero( y , _PUB_M_BYTE );
    // x1
    for(int i=1;i<_GFSIZE;i+=2) gf256v_add( y , tmp+VEC_LEN*i , _PUB_M_BYTE );
    // x2
    for(int i=2;i<_GFSIZE;i++) if(i&2) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
    gf16v_madd( y , tmp , 2 ,  _PUB_M_BYTE );
    // x4
    gf256v_set_zero( tmp , _PUB_M_BYTE );
    for(int i=4;i<_GFSIZE;i++) if(i&4) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
    gf16v_madd( y , tmp , 4 , _PUB_M_BYTE );
    // x8
    gf256v_set_zero( tmp , _PUB_M_BYTE );
#if 16 == _GFSIZE
    for(int i=8;i<16;i++) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
#else
    for(int i=8;i<256;i++) if(i&8) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
#endif
    gf16v_madd( y , tmp , 8 , _PUB_M_BYTE );

#if 256 == _GFSIZE
    gf256v_set_zero( tmp , _PUB_M_BYTE );
    for(int i=16;i<256;i++) if(i&16) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
    gf256v_madd( y , tmp , 16 , _PUB_M_BYTE );

    gf256v_set_zero( tmp , _PUB_M_BYTE );
    for(int i=32;i<256;i++) if(i&32) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
    gf256v_madd( y , tmp , 32 , _PUB_M_BYTE );

    gf256v_set_zero( tmp , _PUB_M_BYTE );
    for(int i=64;i<256;i++) if(i&64) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
    gf256v_madd( y , tmp , 64 , _PUB_M_BYTE );

    gf256v_set_zero( tmp , _PUB_M_BYTE );
    for(int i=128;i<256;i++) gf256v_add( tmp , tmp+VEC_LEN*i , _PUB_M_BYTE );
    gf256v_madd( y , tmp , 128 , _PUB_M_BYTE );
#endif
}


