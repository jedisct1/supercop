#ifndef NTRUPLUS768_INTERNAL_KEYGEN_H
#define NTRUPLUS768_INTERNAL_KEYGEN_H

#include <stdint.h>

#include "poly.h"

/* Keygen-only CQ layout with the same storage ABI and alignment as poly. */
typedef struct {
    poly storage;
} gt_cq_poly;

typedef char gt_cq_poly_size_must_match_poly[
    sizeof(gt_cq_poly) == sizeof(poly) ? 1 : -1];
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
_Static_assert(_Alignof(gt_cq_poly) == _Alignof(poly),
               "CQ storage alignment must match poly");
#endif

#define GT_KEYGEN_CQ_GROUPS 24

/* Quartic lambda table of the keygen CQ pipeline (tables.c). */
extern const int16_t gt_keygen_bpq_lambda8[GT_KEYGEN_CQ_GROUPS][8];


/*
 * Keygen-only CQ contract. The generic GT transform remains block-major;
 * this endpoint writes CQ directly for the keygen baseinv/basemul pipeline.
 */
void poly_ntt_keygen_cq(gt_cq_poly *out_cq,
                              const poly *in_coefficients);
/* Inverts every base element of in_cq (CQ).  Returns 1 if some element is not
 * invertible, and then zeroes out_cq; otherwise returns 0 and writes the
 * inverses, scaled by R, in CQ as poly_basemul_keygen_cq_scaled_r expects.
 * Branch-free up to the returned value, which is declassified for TIMECOP. */
int poly_baseinv_keygen_cq_scaled_r(
    gt_cq_poly *out_cq, const gt_cq_poly *in_cq);
void poly_basemul_keygen_cq_scaled_r(
    gt_cq_poly *out_cq, const gt_cq_poly *a_cq,
    const gt_cq_poly *b_scaled_r_cq);
void poly_tobytes_keygen_cq(uint8_t out[NTRUPLUS_POLYBYTES],
                          const gt_cq_poly *in_cq);

#endif
