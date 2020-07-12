/// @file blas_comm_avx2.h
/// @brief Common functions for linear algebra, specialized for AVX2 instruction set.
///

#ifndef _BLAS_COMM_AVX2_H_
#define _BLAS_COMM_AVX2_H_


#include "stdint.h"



#ifdef  __cplusplus
extern  "C" {
#endif


///////////////////////////////  GF( 16 ) ////////////////////////////////////////////////////


/// @brief  c = matA * b , GF(16)
///
/// @param[out]   c         - the output vector c
/// @param[in]   matA          - the matrix A.
/// @param[in]   n_A_vec_byte    - the size of column vectors in A.
/// @param[in]   n_A_width       - the width of matrix A.
/// @param[in]   b_multab        - the vector b, in multiplication tables.
///
void gf16mat_prod_multab_avx2( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b_multab );

/// @brief  c = mat_a * b , GF(16)
///
/// @param[out]   c         - the output vector c
/// @param[in]   mat_a       - the matrix a.
/// @param[in]   a_h_byte    - the size of column vectors in a.
/// @param[in]   a_w        - the width of matrix a.
/// @param[in]   b           - the vector b.
///
void gf16mat_prod_avx2( uint8_t * c , const uint8_t * mat_a , unsigned a_h_byte , unsigned a_w , const uint8_t * b );

/// @brief Gauss elimination for a matrix, in GF(16)
///
/// @param[in,out]  mat    - the matrix.
/// @param[in]   h         - the height of the matrix.
/// @param[in]   w         - the width of the matrix.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf16mat_gauss_elim_avx2( uint8_t * mat , unsigned h , unsigned w );

/// @brief Solving linear equations, in GF(16)
///
/// @param[out]  sol       - the solutions.
/// @param[in]   inp_mat   - the matrix parts of input equations.
/// @param[in]   c_terms   - the constant terms of the input equations.
/// @param[in]   n         - the number of equations.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf16mat_solve_linear_eq_avx2( uint8_t * sol , const uint8_t * inp_mat , const uint8_t * c_terms , unsigned n );


///////////////////////////////  GF( 256 ) ////////////////////////////////////////////////////


//void gf256mat_prod_add_multab_avx2( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * multab );

/// @brief  c = matA * b , GF(256)
///
/// @param[out]   c         - the output vector c
/// @param[in]   matA       - the matrix A.
/// @param[in]   n_A_vec_byte    - the size of column vectors in A.
/// @param[in]   n_A_width       - the widht of matrix A.
/// @param[in]   b_multab        - the vector b, in multiplication tables.
///
void gf256mat_prod_multab_avx2( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b_multab );

//void gf256mat_prod_add_avx2( __m128i * r , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );


/// @brief  c = matA * b , GF(256)
///
/// @param[out]   c         - the output vector c
/// @param[in]   matA       - the matrix A.
/// @param[in]   n_A_vec_byte   - the size of column vectors in a.
/// @param[in]   n_A_width    - the width of matrix a.
/// @param[in]   b           - the vector b.
///
void gf256mat_prod_avx2( uint8_t * c , const uint8_t * matA , unsigned n_A_vec_byte , unsigned n_A_width , const uint8_t * b );


/// @brief Gauss elimination for a matrix, in GF(16)
///
/// @param[in,out]  mat    - the matrix.
/// @param[in]   h         - the height of the matrix.
/// @param[in]   w         - the width of the matrix.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf256mat_gauss_elim_avx2( uint8_t * mat , unsigned h , unsigned w );


/// @brief Solving linear equations, in GF(256)
///
/// @param[out]  sol       - the solutions.
/// @param[in]   inp_mat   - the matrix parts of input equations.
/// @param[in]   c_terms   - the constant terms of the input equations.
/// @param[in]   n         - the number of equations.
/// @return   1(true) if success. 0(false) if the matrix is singular.
///
unsigned gf256mat_solve_linear_eq_avx2( uint8_t * sol , const uint8_t * inp_mat , const uint8_t * c_terms, unsigned n );



#ifdef  __cplusplus
}
#endif



#endif // _BLAS_COMM_AVX2_H_

