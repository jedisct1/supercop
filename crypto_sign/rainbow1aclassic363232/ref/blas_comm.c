/// @file blas_comm.c
/// @brief The standard implementations for blas_comm.h
///

#include "blas_comm.h"
#include "blas.h"

#include <assert.h>  // FIXME(js): don't use assert() and don't deal with NDEBUG
#include <stdint.h>
#include <string.h>

/// This implementation depends on these vector functions :
///   0.  gf16v_mul_scalar
///       gf16v_madd
///       gf256v_add
///       gf256v_mul_scalar
///       gf256v_madd
///
///   1.  gf256v_predicated_add     for _gf(16/256)mat_gauss_elim()
///   2.  gf16v_dot                 for gf16v_rowmat_prod()
///   3.  gf(16/256)mat_gauss_elim  for _gf(16/256)mat_solve_linear_eq()
///  these functions have to be defined in blas.h

/////////////////////////////////////

void gf256v_set_zero(uint8_t *b, unsigned _num_byte) {
    gf256v_add(b, b, _num_byte);
}

unsigned gf256v_is_zero(const uint8_t *a, unsigned _num_byte) {
    uint8_t r = 0;
    while( _num_byte-- ) { r |= a[0]; a++; }
    return (0 == r);
}

///////////////// multiplications  ////////////////////////////////

/// polynomial multplication
/// School boook

void gf256v_polymul(uint8_t *c, const uint8_t *a, const uint8_t *b, unsigned _num) {
    gf256v_set_zero(c, _num * 2 - 1);
    for (unsigned i = 0; i < _num; i++) gf256v_madd(c + i, a, b[i], _num);
}

///////////  matrix-vector

static
void gf16mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        uint8_t bb = gf16v_get_ele(b, i);
        gf16v_madd(c, matA, bb, n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}

static
void gf256mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b) {
    gf256v_set_zero(c, n_A_vec_byte);
    for (unsigned i = 0; i < n_A_width; i++) {
        gf256v_madd(c, matA, b[i], n_A_vec_byte);
        matA += n_A_vec_byte;
    }
}


/////////// matrix-matrix

void gf16mat_mul(uint8_t *c, const uint8_t *a, const uint8_t *b, unsigned len_vec) {
    unsigned n_vec_byte = (len_vec + 1) / 2;
    for (unsigned k = 0; k < len_vec; k++) {
        gf256v_set_zero(c, n_vec_byte);
        const uint8_t *bk = b + n_vec_byte * k;
        for (unsigned i = 0; i < len_vec; i++) {
            uint8_t bb = gf16v_get_ele(bk, i);
            gf16v_madd(c, a + n_vec_byte * i, bb, n_vec_byte);
        }
        c += n_vec_byte;
    }
}

void gf256mat_mul(uint8_t *c, const uint8_t *a, const uint8_t *b, unsigned len_vec) {
    unsigned n_vec_byte = len_vec;
    for (unsigned k = 0; k < len_vec; k++) {
        gf256v_set_zero(c, n_vec_byte);
        const uint8_t *bk = b + n_vec_byte * k;
        for (unsigned i = 0; i < len_vec; i++) {
            gf256v_madd(c, a + n_vec_byte * i, bk[i], n_vec_byte);
        }
        c += n_vec_byte;
    }
}

/////////////////   algorithms:  gaussian elim  //////////////////

static
unsigned gf16mat_gauss_elim_ref(uint8_t *mat, unsigned h, unsigned w) {
    /// assert( 0==(w&1) );  w must be even !!!
    unsigned n_w_byte = (w + 1) / 2;
    unsigned r8 = 1;
    for (unsigned i = 0; i < h; i++) {
        unsigned offset_byte = i >> 1;
        uint8_t *ai = mat + n_w_byte * i;
        for (unsigned j = i + 1; j < h; j++) {
            uint8_t *aj = mat + n_w_byte * j;
            gf256v_predicated_add(ai + offset_byte, !gf16_is_nonzero(gf16v_get_ele(ai, i)), aj + offset_byte, n_w_byte - offset_byte);
        }
        uint8_t pivot = gf16v_get_ele(ai, i);
        r8 &= gf16_is_nonzero(pivot);
        pivot = gf16_inv(pivot);
        offset_byte = (i + 1) >> 1;
        gf16v_mul_scalar(ai + offset_byte, pivot, n_w_byte - offset_byte);
        for (unsigned j = 0; j < h; j++) {
            if (i == j) continue;
            uint8_t *aj = mat + n_w_byte * j;
            gf16v_madd(aj + offset_byte, ai + offset_byte, gf16v_get_ele(aj, i), n_w_byte - offset_byte);
        }
    }
    return r8;
}

static
unsigned gf16mat_solve_linear_eq_ref(uint8_t *sol, const uint8_t *inp_mat, const uint8_t *c_terms, unsigned n) {
    assert(64 >= n);
    uint8_t mat[64 * 33];
    unsigned n_byte = (n + 1) >> 1;
    for (unsigned i = 0; i < n; i++) {
        memcpy(mat + i * (n_byte + 1), inp_mat + i * n_byte, n_byte);
        mat[i * (n_byte + 1) + n_byte] = gf16v_get_ele(c_terms, i);
    }
    unsigned r8 = gf16mat_gauss_elim(mat, n, n + 2);  /// XXX: this function is ``defined'' in blas.h
    for (unsigned i = 0; i < n; i++) {
        gf16v_set_ele(sol, i, mat[i * (n_byte + 1) + n_byte]);
    }
    return r8;
}

static inline void gf16mat_submat(uint8_t *mat2, unsigned w2, unsigned st, const uint8_t *mat, unsigned w, unsigned h) {
    unsigned n_byte_w1 = (w + 1) / 2;
    unsigned n_byte_w2 = (w2 + 1) / 2;
    unsigned st_2 = st / 2;
    for (unsigned i = 0; i < h; i++) {
        for (unsigned j = 0; j < n_byte_w2; j++) mat2[i * n_byte_w2 + j] = mat[i * n_byte_w1 + st_2 + j];
    }
}

unsigned gf16mat_inv(uint8_t *inv_a, const uint8_t *a, unsigned H, uint8_t *buffer) {
    unsigned n_w_byte = (H + 1) / 2;

    uint8_t *aa = buffer;
    for (unsigned i = 0; i < H; i++) {
        uint8_t *ai = aa + i * 2 * n_w_byte;
        gf256v_set_zero(ai, 2 * n_w_byte);
        gf256v_add(ai, a + i * n_w_byte, n_w_byte);
        gf16v_set_ele(ai + n_w_byte, i, 1);
    }
    uint8_t r8 = gf16mat_gauss_elim(aa, H, 2 * H);  /// XXX: would 2*H fail if H is odd ???
    gf16mat_submat(inv_a, H, H, aa, 2 * H, H);
    return r8;
}


/////////////////////////////////////////////////

static
unsigned gf256mat_gauss_elim_ref( uint8_t * mat , unsigned h , unsigned w )
{
    unsigned r8 = 1;

    for(unsigned i=0;i<h;i++) {
        uint8_t * ai = mat + w*i;
        //unsigned i_start = i&(~0x3);
#if defined( _BLAS_UINT64_ )
        unsigned i_start = i-(i&7);
#else
        unsigned i_start = i-(i&3);
#endif

        for(unsigned j=i+1;j<h;j++) {
            uint8_t * aj = mat + w*j;
//            gf256v_predicated_add( ai + i , !gf256_is_nonzero(ai[i]) , aj + i , w-i );
            gf256v_predicated_add( ai + i_start , !gf256_is_nonzero(ai[i]) , aj + i_start , w - i_start );
        }
        r8 &= gf256_is_nonzero(ai[i]);
        uint8_t pivot = ai[i];
        pivot = gf256_inv( pivot );
//        gf256v_mul_scalar( ai + (i+1) , pivot , w - (i+1) );
        gf256v_mul_scalar( ai + i_start  , pivot , w - i_start );
        for(unsigned j=0;j<h;j++) {
            if(i==j) continue;
            uint8_t * aj = mat + w*j;
//            gf256v_madd( aj + (i+1) , ai + (i+1) , aj[i] , w - (i+1) );
            gf256v_madd( aj + i_start , ai+ i_start , aj[i] , w - i_start );
        }
    }

    return r8;
}

static
unsigned gf256mat_solve_linear_eq_ref( uint8_t * sol , const uint8_t * inp_mat , const uint8_t * c_terms , unsigned n )
{
    assert( 64 >= n );
    uint8_t mat[ 64*72 ];
    for(unsigned i=0;i<n;i++) {
    memcpy( mat + i*(n+1) , inp_mat + i*n , n );
    mat[i*(n+1)+n] = c_terms[i];
    }
    unsigned r8 = gf256mat_gauss_elim( mat , n , n+1 );   /// XXX: this function is ``defined'' in blas.h
    for(unsigned i=0;i<n;i++) sol[i] = mat[i*(n+1)+n];
    return r8;
}



static inline
void gf256mat_submat( uint8_t * mat2 , unsigned w2 , unsigned st , const uint8_t * mat , unsigned w , unsigned h )
{
    for(unsigned i=0;i<h;i++) {
        for(unsigned j=0;j<w2;j++) mat2[i*w2+j] = mat[i*w+st+j];
    }
}


unsigned gf256mat_inv( uint8_t * inv_a , const uint8_t * a , unsigned H , uint8_t * buffer )
{
    uint8_t * aa = buffer;
    for(unsigned i=0;i<H;i++) {
        uint8_t * ai = aa + i*2*H;
        gf256v_set_zero( ai , 2*H );
        gf256v_add( ai , a + i*H , H );
        ai[H+i] = 1;
    }
    unsigned char r8 = gf256mat_gauss_elim( aa , H , 2*H );
    gf256mat_submat( inv_a , H , H , aa , 2*H , H );
    return r8;
}





////////////////////////////////////////////////////


// choosing the implementations depends on the macros _BLAS_AVX2_ and _BLAS_SSE_


#if defined( _BLAS_AVX2_ )

#include "blas_comm_avx2.h"
#define gf16mat_prod_impl             gf16mat_prod_avx2
#define gf16mat_gauss_elim_impl       gf16mat_gauss_elim_avx2
#define gf16mat_solve_linear_eq_impl  gf16mat_solve_linear_eq_avx2
#define gf256mat_prod_impl            gf256mat_prod_avx2
#define gf256mat_gauss_elim_impl      gf256mat_gauss_elim_avx2
#define gf256mat_solve_linear_eq_impl gf256mat_solve_linear_eq_avx2

#elif defined( _BLAS_SSE_ )

#include "blas_comm_sse.h"
#define gf16mat_prod_impl             gf16mat_prod_sse
#define gf16mat_gauss_elim_impl       gf16mat_gauss_elim_sse
#define gf16mat_solve_linear_eq_impl  gf16mat_solve_linear_eq_sse
#define gf256mat_prod_impl            gf256mat_prod_sse
#define gf256mat_gauss_elim_impl      gf256mat_gauss_elim_sse
#define gf256mat_solve_linear_eq_impl gf256mat_solve_linear_eq_sse

#else

#define gf16mat_prod_impl             gf16mat_prod_ref
#define gf16mat_gauss_elim_impl       gf16mat_gauss_elim_ref
#define gf16mat_solve_linear_eq_impl  gf16mat_solve_linear_eq_ref
#define gf256mat_prod_impl            gf256mat_prod_ref
#define gf256mat_gauss_elim_impl      gf256mat_gauss_elim_ref
#define gf256mat_solve_linear_eq_impl gf256mat_solve_linear_eq_ref

#endif






void gf16mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf16mat_prod_impl( c, matA, n_A_vec_byte, n_A_width, b);
}


unsigned gf16mat_gauss_elim(uint8_t *mat, unsigned h, unsigned w)
{
    return gf16mat_gauss_elim_impl( mat, h, w);
}

unsigned gf16mat_solve_linear_eq( uint8_t * sol , const uint8_t * inp_mat , const uint8_t * c_terms , unsigned n )
{
    return gf16mat_solve_linear_eq_impl( sol , inp_mat , c_terms , n );
}


void gf256mat_prod(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b)
{
    gf256mat_prod_impl( c, matA, n_A_vec_byte, n_A_width, b);
}

unsigned gf256mat_gauss_elim( uint8_t * mat , unsigned h , unsigned w )
{
    return gf256mat_gauss_elim_impl( mat , h , w );
}


unsigned gf256mat_solve_linear_eq( uint8_t * sol , const uint8_t * inp_mat , const uint8_t * c_terms , unsigned n )
{
    return gf256mat_solve_linear_eq_impl( sol , inp_mat , c_terms , n );
}
