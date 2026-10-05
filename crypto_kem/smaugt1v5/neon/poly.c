// SPDX-License-Identifier: MIT

#include "poly.h"
#include "toomcook.h"
#include <string.h>
#include "ntt_dilithium.h"
#include "fnt.h"
#include "ntt_kyber.h"
#include "arm_neon.h"
#include "params.h"
#include "crypto_int16.h"
#include "crypto_uint16.h"
#include "crypto_int64.h"
// #include "../benchmark/cpucycles.h"


#if SMAUGT_MODE == SMAUGT_MODET
/*************************************************
 * Name:        flipabs
 *
 * Description: Computes |(x mod q) - Q/2|
 *
 * Arguments:   - uint16_t x: input coefficient
 *
 * Return: |(x mod q) - Q/2|
 **************************************************/
uint16_t flipabs(uint16_t x) {
    int16_t r, m;
    r = x - (SMAUGT_MODULUS_SCALED_Q_HALF);
    m = crypto_int16_negative_mask(r);
    return (r + m) ^ m;
}

/*************************************************
 * Name:        d2_ecd
 *
 * Description: Convert 16-byte message to polynomial
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t msg[SMAUGT_MSG_BYTES]: pointer to input message
 **************************************************/
void d2_ecd(poly *r, const uint8_t msg[SMAUGT_MSG_BYTES]) {
    unsigned int mask;
    for (size_t i = 0; i < SMAUGT_MSG_BYTES; i++) {
        for (size_t j = 0; j < 8; j++) {
            mask = crypto_int64_bitmod_01(msg[i],j);
            mask = (mask * SMAUGT_MODULUS_SCALED_Q_HALF) &
                   SMAUGT_MODULUS_SCALED_Q_HALF;
            r->coeffs[8 * i + j] = mask;
            r->coeffs[8 * i + j + 128] = mask;
        }
    }
}

/*************************************************
 * Name:        d2_dcd
 *
 * Description: Convert polynomial to 16-byte message
 *
 * Arguments:   - uint8_t msg[SMAUGT_MSG_BYTES]: pointer to output message
 *              - const poly *x: pointer to input polynomial
 **************************************************/
void d2_dcd(uint8_t msg[SMAUGT_MSG_BYTES], const poly *x) {
    uint16_t t;
    for (size_t i = 0; i < SMAUGT_MSG_BYTES; i++)
        msg[i] = 0;

    for (size_t i = 0; i < SMAUGT_N / 2; i++) {
        t = flipabs(x->coeffs[i]);
        t += flipabs(x->coeffs[i + 128]);
        t = t - SMAUGT_MODULUS_SCALED_Q_HALF;
        t = crypto_uint16_topbit_01(t);
        msg[i >> 3] |= t << (i & 7);
    }
}
#endif

/*CRT with NTT and FNT*/
static inline int16x8_t barrett_mul_1943(int16x8_t b)
{
        int16x8_t t = vqrdmulhq_n_s16(b, 19125);
        int16x8_t d = vmulq_n_s16(b, 1943);
        return vmlsq_n_s16(d,t, 3329);
}

/*************************************************
 * Name:        poly_add
 *
 * Description: Add two polynomials. no modular reduction is performed
 *
 * Arguments: - poly *r: pointer to output polynomial
 *            - const poly *a: pointer to first input polynomial
 *            - const poly *b: pointer to second input polynomial
 **************************************************/
static inline void poly_add(poly *r, const poly *a, const poly *b) {
    unsigned int i;
    for (i = 0; i < SMAUGT_N; i++)
        r->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}

/*************************************************
 * Name:        poly_sub
 *
 * Description: Subtract two polynomials. no modular reduction is performed
 *
 * Arguments: - poly *r: pointer to output polynomial
 *            - const poly *a: pointer to first input polynomial
 *            - const poly *b: pointer to second input polynomial
 **************************************************/
static inline void poly_sub(poly *r, const poly *a, const poly *b) {
    unsigned int i;
    for (i = 0; i < SMAUGT_N; i++)
        r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

#define vec_vec_mult SMAUGT_NAMESPACE(vec_vec_mult)
/*************************************************
 * Name:        vec_vec_mult
 *
 * Description: Multiply two vector of polynomials.
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const polyvec *a: pointer to input vector of polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void vec_vec_mult(poly *r, const polyvec *a, const polyvec *b) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; i++)
        poly_mul_acc(a->vec[i].coeffs, b->vec[i].coeffs, r->coeffs);
        //poly_ntt_mul(a->vec[i].coeffs, b->vec[i].coeffs, r->coeffs);
}

void vec_vec_mul_crt(poly *r, polyvec a, polyvec *b) {
    unsigned int i, j, k;

    int16x8_t at_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t at_f[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_f[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_asy_k[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t s_asy_f[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t bb_k[SMAUGT_N_VEC];
    int16x8_t bb_f[SMAUGT_N_VEC];

    int16x8_t* ap;
    int16x8_t tmp;

    memcpy(s_k, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));
    memcpy(s_f, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));

    for (j = 0; j < SMAUGT_K; ++j){
        ap = (int16x8_t*)(a.vec[j].coeffs);
        for (k = 0; k < SMAUGT_N_VEC; ++k){
            at_k[j][k] = vshrq_n_s16(ap[k], SMAUGT_MODULUS_16_LOG_Q);
            // centering
            at_f[j][k] = at_k[j][k];
        }
    }

    kyber_vv(bb_k, s_k, s_asy_k, at_k);
    fnt_vv(bb_f, s_f, s_asy_f, at_f);


    // crt
    // load vector
    int16x8_t* rp = (int16x8_t*)(r->coeffs);
    
    for (k = 0; k < SMAUGT_N_VEC; ++k){
        // tmp = a2 - a1
        tmp = vsubq_s16(bb_k[k], bb_f[k]);
        // tmp = tmp*(1/257) %3329
        tmp = barrett_mul_1943(tmp);
        // out = a1 + 257*tmp
        rp[k] = vshlq_n_s16( vaddq_s16(bb_f[k], vaddq_s16(tmp, vshlq_n_s16(tmp, 8))), SMAUGT_MODULUS_16_LOG_Q);  
    }
}

/*************************************************
 * Name:        vec_vec_mult_add
 *
 * Description: Multiply two vectors of polynomials and add the result to output
 *              polynomial
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const polyvec *a: pointer to input vector of polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 *              - uint8_t mod: modulus (16-SMAUGT_LOG_P) or (16-SMAUGT_LOG_Q)
 **************************************************/
void vec_vec_mult_add(poly *r, const polyvec *a, const polyvec *b,
                      uint8_t mod) {
    unsigned int i, j;
    polyvec al;
    poly res;

    for (i = 0; i < SMAUGT_K; ++i)
        for (j = 0; j < SMAUGT_N; ++j)
            al.vec[i].coeffs[j] = a->vec[i].coeffs[j] >> mod;

    memset(&res, 0, sizeof(poly));
    vec_vec_mult(&res, &al, b);
    for (j = 0; j < SMAUGT_N; ++j)
        res.coeffs[j] <<= mod;

    poly_add(r, r, &res);
}

void vec_vec_mul_crt_add(poly *r, polyvec *a, polyvec *b) {
    unsigned int i, j, k;

    int16x8_t at_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t at_f[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_f[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_asy_k[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t s_asy_f[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t bb_k[SMAUGT_N_VEC];
    int16x8_t bb_f[SMAUGT_N_VEC];

    int16x8_t* ap;
    int16x8_t tmp;

    memcpy(s_k, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));
    memcpy(s_f, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));

    for (j = 0; j < SMAUGT_K; ++j){
        ap = (int16x8_t*)(a->vec[j].coeffs);
        for (k = 0; k < SMAUGT_N_VEC; ++k){
            at_k[j][k] = vshrq_n_s16(ap[k], SMAUGT_MODULUS_16_LOG_Q);
            // centering
            at_f[j][k] = at_k[j][k];
        }
    }

    kyber_vv(bb_k, s_k, s_asy_k, at_k);
    fnt_vv(bb_f, s_f, s_asy_f, at_f);


    // crt
    // load vector
    int16x8_t* rp = (int16x8_t*)(r->coeffs);
    
    for (k = 0; k < SMAUGT_N_VEC; ++k){
        // tmp = a2 - a1
        tmp = vsubq_s16(bb_k[k], bb_f[k]);
        // tmp = tmp*(1/257) %3329
        tmp = barrett_mul_1943(tmp);
        // out = a1 + 257*tmp
        rp[k] = vaddq_s16(rp[k], vshlq_n_s16( vaddq_s16(bb_f[k], vaddq_s16(tmp, vshlq_n_s16(tmp, 8))), SMAUGT_MODULUS_16_LOG_Q));  
    }
}


/*************************************************
 * Name:        matrix_vec_mult_add
 *
 * Description: Transpose the matrix of polynomial and multiply it with the
 *              vector of polynomials.
 *
 * Arguments:   - polyvec *r: pointer to output vector of polynomials
 *              - const polyvec a[SMAUGT_K]: pointer to input matrix of
 *              polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mult_add(polyvec *r, const polyvec a[SMAUGT_K],
                         const polyvec *b) {
    unsigned int i, j, k;
    polyvec at;

    for (i = 0; i < SMAUGT_K; ++i) {
        for (j = 0; j < SMAUGT_K; ++j)
            for (k = 0; k < SMAUGT_N; ++k)
                at.vec[j].coeffs[k] =
                    a[j].vec[i].coeffs[k] >> SMAUGT_MODULUS_16_LOG_Q;

        vec_vec_mult(&r->vec[i], &at, b);

        for (j = 0; j < SMAUGT_N; ++j){
           r->vec[i].coeffs[j] <<= SMAUGT_MODULUS_16_LOG_Q;
        }
    }
}

/*************************************************
 * Name:        matrix_vec_mult_sub
 *
 * Description: Multiply the matrix of polynomial with the vector of polynomial
 *              and subtract the result to output vector of polynomials.
 *
 * Arguments:   - polyvec *r: pointer to input/output vector of polynomials
 *              - const polyvec a[SMAUGT_K]: pointer to input matrix of
 *              polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mult_sub(polyvec *r, const polyvec a[SMAUGT_K],
                         const polyvec *b) {
    unsigned int i, j, k;
    polyvec al;
    poly res;

    for (i = 0; i < SMAUGT_K; ++i) {
        for (j = 0; j < SMAUGT_K; ++j)
            for (k = 0; k < SMAUGT_N; ++k)
                al.vec[j].coeffs[k] =
                    a[i].vec[j].coeffs[k] >> SMAUGT_MODULUS_16_LOG_Q;

        memset(&res, 0, sizeof(poly));
        vec_vec_mult(&res, &al, b);
        for (j = 0; j < SMAUGT_N; ++j)
            res.coeffs[j] <<= SMAUGT_MODULUS_16_LOG_Q;

        poly_sub(&r->vec[i], &r->vec[i], &res);
    }
}


void matrix_vec_mul_crt_sub(polyvec *r, polyvec a[SMAUGT_K], polyvec *b) {
    unsigned int i, j, k;

    int16x8_t at_k[SMAUGT_K][SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t at_f[SMAUGT_K][SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_f[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_asy_k[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t s_asy_f[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t bb_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t bb_f[SMAUGT_K][SMAUGT_N_VEC];

    int16x8_t* ap;
    int16x8_t tmp;


    memcpy(s_k, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));
    memcpy(s_f, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));

    for (i = 0; i < SMAUGT_K; ++i) {
        for (j = 0; j < SMAUGT_K; ++j){
            ap = (int16x8_t*)(a[i].vec[j].coeffs);
            for (k = 0; k < SMAUGT_N_VEC; ++k){
                // no transpose here: matrix_vec_mult_sub computes A*b, not A^T*b
                at_k[i][j][k] = vshrq_n_s16(ap[k], SMAUGT_MODULUS_16_LOG_Q);
                // centering
                at_f[i][j][k] = at_k[i][j][k];
            }
        }
    }

    kyber_mv(bb_k, s_k, s_asy_k, at_k);
    fnt_mv(bb_f, s_f, s_asy_f, at_f);

    for (i = 0; i < SMAUGT_K; ++i) {
        // crt
        // load vector
        int16x8_t tmp;
        // int16x8_t* a1 = (int16x8_t*)(bb_f[i]);
        // int16x8_t* a2 = (int16x8_t*)(bb_k[i]);
        int16x8_t* rp = (int16x8_t*)(r->vec[i].coeffs);

        for (k = 0; k < SMAUGT_N_VEC; ++k){
            // tmp = a2 - a1
            tmp = vsubq_s16(bb_k[i][k], bb_f[i][k]);
            // tmp = tmp*(1/257) %3329
            tmp = barrett_mul_1943(tmp);
            // out = a1 + 257*tmp
            rp[k] = vsubq_s16(rp[k], vshlq_n_s16( vaddq_s16(bb_f[i][k], vaddq_s16(tmp, vshlq_n_s16(tmp, 8))), SMAUGT_MODULUS_16_LOG_Q));
        }
    }
}



/*NTT (Dilithium)*/
void poly_ntt_mul(const int16_t a[SMAUGT_N], const int16_t b[SMAUGT_N], int16_t res[SMAUGT_N]) {
    int32_t pa[SMAUGT_N], pb[SMAUGT_N], pc[SMAUGT_N];
    
    for (int i=0; i<SMAUGT_N; i++){
        pa[i] = (int32_t)a[i];
        pb[i] = (int32_t)b[i];
    }

    ntt(pa);
    ntt(pb);
    base_mul(pc, pa, pb);
    invntt_tomont(pc);

    for (int i=0; i<SMAUGT_N; i++){
        res[i] = (int16_t)(pc[i] & (SMAUGT_Q-1));
    }
}

void polyvecl_ntt(polyvec32 *v) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i) {
        ntt(v->vec[i].coeffs);
    }
}

void polyvecl_reduce(polyvec32 *v) {
    unsigned int i;

    for (i = 0; i < SMAUGT_K; ++i) {
        DILITHIUM_AARCH64__asm_poly_reduce(v->vec[i].coeffs, dilithium_constants);
    }
}

void polyvecl_invntt_tomont(polyvec32 *v) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i) {
        invntt_tomont(v->vec[i].coeffs);
    }
}

void polyvecl_pointwise_acc_montgomery(poly32 *w,
                                       const polyvec32 *u,
                                       const polyvec32 *v) {
    DILITHIUM_AARCH64__asm_polyvecl_pointwise_acc_montgomery(w->coeffs, u->vec[0].coeffs, v->vec[0].coeffs, dilithium_constants);
}

void polyvec_matrix_pointwise_montgomery(polyvec32 *t, const polyvec32 mat[SMAUGT_K], const polyvec32 *v) {
    unsigned int i;

    for (i = 0; i < SMAUGT_K; ++i) {
        polyvecl_pointwise_acc_montgomery(&t->vec[i], &mat[i], v);
    }
}


void matrix_vec_ntt_mul(polyvec *r, polyvec32 a[SMAUGT_K], polyvec32 *b) {
    polyvec32 tmp = {0};
    polyvec32 al[SMAUGT_K] = {0};

    //Transpose
    for (int i = 0; i < SMAUGT_K; ++i) {
        for (int j = 0; j < SMAUGT_K; ++j){
            for (int k = 0; k < SMAUGT_N; ++k){
                al[j].vec[i].coeffs[k] = (a[i].vec[j].coeffs[k]>>SMAUGT_MODULUS_16_LOG_Q);
            }
        }
    }
    
    for (int i=0; i<SMAUGT_K; i++){
        polyvecl_ntt(al+i);
    }

    polyvecl_ntt(b);
    

    int32_t acc[SMAUGT_N] = {0};
    int32_t term[SMAUGT_N] = {0};

    for (int i = 0; i < SMAUGT_K; i++) {
        base_mul(acc, al[i].vec[0].coeffs, b->vec[0].coeffs);

        for (int j = 1; j < SMAUGT_K; j++) {
            base_mul(term, al[i].vec[j].coeffs, b->vec[j].coeffs);
            for (int n = 0; n < SMAUGT_N; n++){
                acc[n] += term[n];
            }
        }

        for (int n = 0; n < SMAUGT_N; n++){
            tmp.vec[i].coeffs[n] = acc[n];
        }
    }

    polyvecl_invntt_tomont(&tmp);

    for (int i=0; i<SMAUGT_K; i++){
        for (int j=0; j<SMAUGT_N; j++){
            r->vec[i].coeffs[j] = ((int16_t)tmp.vec[i].coeffs[j] & (SMAUGT_Q-1));
            r->vec[i].coeffs[j] <<= SMAUGT_MODULUS_16_LOG_Q;
        }
    }
}




void matrix_vec_mul_crt(polyvec *r, polyvec a[SMAUGT_K], polyvec *b) {
    unsigned int i, j, k;
    // polyvec at[2];
    // int16_t at_k[SMAUGT_K][SMAUGT_K][SMAUGT_N];
    // int16_t at_f[SMAUGT_K][SMAUGT_K][SMAUGT_N];
    // int16_t s_k[SMAUGT_K][SMAUGT_N], s_f[SMAUGT_K][SMAUGT_N];
    // int16_t s_asymmetric[SMAUGT_K][SMAUGT_N>>1] = {0};
    // int16_t s_asymmetric_f[SMAUGT_K][SMAUGT_N>>1] = {0};
    // int16_t bb_k[SMAUGT_K][SMAUGT_N] = {0};
    // int16_t bb_f[SMAUGT_K][SMAUGT_N] = {0};

    int16x8_t at_k[SMAUGT_K][SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t at_f[SMAUGT_K][SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_f[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t s_asy_k[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t s_asy_f[SMAUGT_K][SMAUGT_N_VEC>>1];
    int16x8_t bb_k[SMAUGT_K][SMAUGT_N_VEC];
    int16x8_t bb_f[SMAUGT_K][SMAUGT_N_VEC];

    int16x8_t* ap;
    int16x8_t tmp;


    memcpy(s_k, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));
    memcpy(s_f, b, (SMAUGT_K * SMAUGT_N_VEC)*sizeof(int16x8_t));

    for (i = 0; i < SMAUGT_K; ++i) {
        for (j = 0; j < SMAUGT_K; ++j){
            ap = (int16x8_t*)(a[i].vec[j].coeffs);
            for (k = 0; k < SMAUGT_N_VEC; ++k){
                at_k[j][i][k] = vshrq_n_s16(ap[k], SMAUGT_MODULUS_16_LOG_Q);
                // centering
                at_f[j][i][k] = at_k[j][i][k];
            }
        }
    }

    kyber_mv(bb_k, s_k, s_asy_k, at_k);
    fnt_mv(bb_f, s_f, s_asy_f, at_f);

    for (i = 0; i < SMAUGT_K; ++i) {
        // crt
        // load vector
        int16x8_t tmp;
        // int16x8_t* a1 = (int16x8_t*)(bb_f[i]);
        // int16x8_t* a2 = (int16x8_t*)(bb_k[i]);
        int16x8_t* rp = (int16x8_t*)(r->vec[i].coeffs);
        
        for (k = 0; k < SMAUGT_N_VEC; ++k){
            // tmp = a2 - a1
            tmp = vsubq_s16(bb_k[i][k], bb_f[i][k]);
            // tmp = tmp*(1/257) %3329
            tmp = barrett_mul_1943(tmp);
            // out = a1 + 257*tmp
            rp[k] = vshlq_n_s16( vaddq_s16(bb_f[i][k], vaddq_s16(tmp, vshlq_n_s16(tmp, 8))), SMAUGT_MODULUS_16_LOG_Q);  
        }
        // for (j = 0; j < SMAUGT_N; ++j){
        //     r->vec[i].coeffs[j] <<= SMAUGT_MODULUS_16_LOG_Q;
        // }
    }
}



/*************************************************
* Name:        poly_ntt
*
* Description: Computes negacyclic number-theoretic transform (NTT) of
*              a polynomial in place;
*              inputs assumed to be in normal order, output in bitreversed order
*
* Arguments:   - uint16_t *r: pointer to in/output polynomial
**************************************************/
// void poly_ntt(poly *r)
// {
//   kyber_ntt(r->coeffs);
// }

/*************************************************
* Name:        poly_invntt_tomont
*
* Description: Computes inverse of negacyclic number-theoretic transform (NTT)
*              of a polynomial in place;
*              inputs assumed to be in bitreversed order, output in normal order
*
* Arguments:   - uint16_t *a: pointer to in/output polynomial
**************************************************/
// void poly_invntt_tomont(poly *r)
// {
//   kyber_invntt(r->coeffs);
// }