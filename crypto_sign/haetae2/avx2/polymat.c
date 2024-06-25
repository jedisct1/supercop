#include "polymat.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include <stdint.h>

/*************************************************
 * Name:        polymat_expand
 *
 * Description: Implementation of ExpandA. Generates matrix A with uniformly
 *              random coefficients a_{i,j} by performing rejection
 *              sampling on the output stream of SHAKE128(rho|j|i)
 *              or AES256CTR(rho,j|i).
 *
 * Arguments:   - polyvecm mat[K]: output matrix k \times m
 *              - const uint8_t rho[]: byte array containing seed rho
 **************************************************/
void polymatkl_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES]) {
    unsigned int i, j;

#ifdef HAETAE_USE_AES
    for (i = 0; i < K; ++i)
        for (j = 0; j < M; ++j)
            poly_uniform(&mat[i].vec[j + 1], rho, (i << 8) + j);
#else
#if K == 2 && L == 4
    poly tmp0, tmp1;
    poly_uniform_4x(
        &mat[0].vec[1],
        &mat[0].vec[2],
        &mat[0].vec[3],
        &mat[1].vec[1],
        rho,
        (0 << 8) + 0,
        (0 << 8) + 1,
        (0 << 8) + 2,
        (1 << 8) + 0
        );
    poly_uniform_4x(
        &mat[1].vec[2],
        &mat[1].vec[3],
        &tmp0,
        &tmp1,
        rho,
        (1 << 8) + 1,
        (1 << 8) + 2,
        (9 << 8) + 9,
        (9 << 8) + 9
        );
#elif K == 3 && L == 6
    poly tmp;
    poly_uniform_4x(
        &mat[0].vec[1],
        &mat[0].vec[2],
        &mat[0].vec[3],
        &mat[0].vec[4],
        rho,
        (0 << 8) + 0,
        (0 << 8) + 1,
        (0 << 8) + 2,
        (0 << 8) + 3
        );
    poly_uniform_4x(
        &mat[0].vec[5],
        &mat[1].vec[1],
        &mat[1].vec[2],
        &mat[1].vec[3],
        rho,
        (0 << 8) + 4,
        (1 << 8) + 0,
        (1 << 8) + 1,
        (1 << 8) + 2
        );
    poly_uniform_4x(
        &mat[1].vec[4],
        &mat[1].vec[5],
        &mat[2].vec[1],
        &mat[2].vec[2],
        rho,
        (1 << 8) + 3,
        (1 << 8) + 4,
        (2 << 8) + 0,
        (2 << 8) + 1
        );
    poly_uniform_4x(
        &mat[2].vec[3],
        &mat[2].vec[4],
        &mat[2].vec[5],
        &tmp,
        rho,
        (2 << 8) + 2,
        (2 << 8) + 3,
        (2 << 8) + 4,
        (9 << 8) + 9
        );
#elif K == 4 && L == 7
    for (j = 0; j < M; j++)
    {
      poly_uniform_4x(
          &mat[0].vec[j+1],
          &mat[1].vec[j+1],
          &mat[2].vec[j+1],
          &mat[3].vec[j+1],
          rho,
          (0 << 8) + j,
          (1 << 8) + j,
          (2 << 8) + j,
          (3 << 8) + j
          );
    }
#else
#error
#endif
    for (i = 0; i < K; ++i)
        for (j = 0; j < M; ++j)
            poly_nttunpack(&mat[i].vec[j + 1]);
#endif
}

/*************************************************
 * Name:        polymat_expand
 *
 * Description: Implementation of ExpandA. Generates matrix A with uniformly
 *              random coefficients a_{i,j} by performing rejection
 *              sampling on the output stream of SHAKE128(rho|j|i)
 *              or AES256CTR(rho,j|i).
 *
 * Arguments:   - polyvecm mat[K]: output matrix k \times m
 *              - const uint8_t rho[]: byte array containing seed rho
 **************************************************/
void polymatkm_expand(polyvecm mat[K], const uint8_t rho[SEEDBYTES]) {
    unsigned int i, j;

#ifdef HAETAE_USE_AES
    for (i = 0; i < K; ++i)
        for (j = 0; j < M; ++j)
            poly_uniform(&mat[i].vec[j], rho, (i << 8) + j);
#else
#if K == 2 && L == 4
    poly tmp0, tmp1;
    poly_uniform_4x(
        &mat[0].vec[0],
        &mat[0].vec[1],
        &mat[0].vec[2],
        &mat[1].vec[0],
        rho,
        (0 << 8) + 0,
        (0 << 8) + 1,
        (0 << 8) + 2,
        (1 << 8) + 0
        );
    poly_uniform_4x(
        &mat[1].vec[1],
        &mat[1].vec[2],
        &tmp0,
        &tmp1,
        rho,
        (1 << 8) + 1,
        (1 << 8) + 2,
        (9 << 8) + 9,
        (9 << 8) + 9
        );
#elif K == 3 && L == 6
    poly tmp;
    poly_uniform_4x(
        &mat[0].vec[0],
        &mat[0].vec[1],
        &mat[0].vec[2],
        &mat[0].vec[3],
        rho,
        (0 << 8) + 0,
        (0 << 8) + 1,
        (0 << 8) + 2,
        (0 << 8) + 3
        );
    poly_uniform_4x(
        &mat[0].vec[4],
        &mat[1].vec[0],
        &mat[1].vec[1],
        &mat[1].vec[2],
        rho,
        (0 << 8) + 4,
        (1 << 8) + 0,
        (1 << 8) + 1,
        (1 << 8) + 2
        );
    poly_uniform_4x(
        &mat[1].vec[3],
        &mat[1].vec[4],
        &mat[2].vec[0],
        &mat[2].vec[1],
        rho,
        (1 << 8) + 3,
        (1 << 8) + 4,
        (2 << 8) + 0,
        (2 << 8) + 1
        );
    poly_uniform_4x(
        &mat[2].vec[2],
        &mat[2].vec[3],
        &mat[2].vec[4],
        &tmp,
        rho,
        (2 << 8) + 2,
        (2 << 8) + 3,
        (2 << 8) + 4,
        (9 << 8) + 9
        );
#elif K == 4 && L == 7
    for (j = 0; j < M; j++)
    {
      poly_uniform_4x(
          &mat[0].vec[j],
          &mat[1].vec[j],
          &mat[2].vec[j],
          &mat[3].vec[j],
          rho,
          (0 << 8) + j,
          (1 << 8) + j,
          (2 << 8) + j,
          (3 << 8) + j
          );
    }
#else
#error
#endif
    for (i = 0; i < K; ++i)
        for (j = 0; j < M; ++j)
            poly_nttunpack(&mat[i].vec[j]);
#endif
}

// doubles k * m sub-matrix of k * l mat
void polymatkl_double(polyvecl mat[K]) {
    unsigned int i, j, k;
    for (i = 0; i < K; ++i) {
        for (j = 1; j < L; ++j) {
            for (k = 0; k < N/8; ++k) {
                mat[i].vec[j].vec[k] = _mm256_add_epi32(mat[i].vec[j].vec[k], mat[i].vec[j].vec[k]);
            }
        }
    }
}

void polymatkl_pointwise_montgomery(polyveck *t, const polyvecl mat[K],
                                    const polyvecl *v) {
    unsigned int i;

    for (i = 0; i < K; ++i) {
        polyvecl_pointwise_acc_montgomery(&t->vec[i], &mat[i], v);
    }
}

void polymatkm_pointwise_montgomery(polyveck *t, const polyvecm mat[K],
                                    const polyvecm *v) {
    unsigned int i;

    for (i = 0; i < K; ++i) {
        polyvecm_pointwise_acc_montgomery(&t->vec[i], &mat[i], v);
    }
}
