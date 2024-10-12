#ifndef SMAUG_NTT_H
#define SMAUG_NTT_H

#include "config.h"
#include "consts.h"
#include "poly.h"

/* poly */
#define poly_ntt POLYMUL_NAMESPACE(_poly_ntt)
void poly_ntt(nttpoly *r, const poly *a, const int16_t *pdata);
#define poly_invntt_tomont POLYMUL_NAMESPACE(_poly_invntt_tomont)
void poly_invntt_tomont(nttpoly *r, const nttpoly *a, const int16_t *pdata);

#define poly_basemul_montgomery POLYMUL_NAMESPACE(_poly_basemul_montgomery)
void poly_basemul_montgomery(nttpoly *r, const nttpoly *a, const nttpoly *b,
                             const int16_t *pdata);
#define poly_crt POLYMUL_NAMESPACE(_poly_crt)
void poly_crt(poly *r, const nttpoly *a, const nttpoly *b);

#define poly_mul POLYMUL_NAMESPACE(_poly_mul)
void poly_mul(poly *r, const poly *a, const poly *b);

/* polyvec */
#define polyvec_ntt POLYMUL_NAMESPACE(_polyvec_ntt)
void polyvec_ntt(nttpolyvec *r, const polyvec *a, const int16_t *pdata);
#define polyvec_invntt_tomont POLYMUL_NAMESPACE(_polyvec_invntt_tomont)
void polyvec_invntt_tomont(nttpolyvec *r, const nttpolyvec *a,
                           const int16_t *pdata);

#define polyvec_basemul_acc_montgomery                                         \
    POLYMUL_NAMESPACE(_polyvec_basemul_acc_montgomery)
void polyvec_basemul_acc_montgomery(nttpoly *r, const nttpolyvec *a,
                                    const nttpolyvec *b, const int16_t *pdata);

#define polyvec_crt POLYMUL_NAMESPACE(_polyvec_crt)
void polyvec_crt(polyvec *r, const nttpolyvec *a, const nttpolyvec *b);

#define polyvec_matrix_vector_mul POLYMUL_NAMESPACE(_polyvec_matrix_vector_mul)
void polyvec_matrix_vector_mul(polyvec *t, nttpolyvec shat[2],
                               const polyvec a[KEM_K], const polyvec *s,
                               int transpose);

#define polyvec_iprod POLYMUL_NAMESPACE(_polyvec_iprod)
void polyvec_iprod(poly *r, const polyvec *a, const polyvec *b);

#define polyvec_iprod_ntt POLYMUL_NAMESPACE(_polyvec_iprod_ntt)
void polyvec_iprod_ntt(poly *r, const polyvec *a, const nttpolyvec bhat[2]);

#endif // SMAUG_NTT_H
