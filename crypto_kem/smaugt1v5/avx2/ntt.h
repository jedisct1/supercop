#ifndef SMAUG_NTT_H
#define SMAUG_NTT_H

#include "mulconfig.h"
#include "consts.h"
#include "poly.h"

/* batched, software-interleaved transforms (src/mul/mul_batch.S):
 * two mod-7681 streams (r0/a0, r1/a1 with q0=q1=PDATA0) advanced in lockstep
 * with two mod-257 streams (r2/a2, r3/a3 with q2=q3=PDATA2). */
#define ntt2_fnt2 POLYMUL_NAMESPACE(_ntt2_fnt2)
void ntt2_fnt2(int16_t *r0, const int16_t *a0, const int16_t *q0,
               int16_t *r1, const int16_t *a1, const int16_t *q1,
               int16_t *r2, const int16_t *a2, const int16_t *q2,
               int16_t *r3, const int16_t *a3, const int16_t *q3);
/* two-stream variant: one mod-7681 NTT interleaved with one mod-257 FNT, for
 * the odd polynomial left over when a vector of odd length is batched */
#define ntt1_fnt1 POLYMUL_NAMESPACE(_ntt1_fnt1)
void ntt1_fnt1(int16_t *r0, const int16_t *a0, const int16_t *q0,
               int16_t *r1, const int16_t *a1, const int16_t *q1);
#define invntt2_invfnt2 POLYMUL_NAMESPACE(_invntt2_invfnt2)
void invntt2_invfnt2(int16_t *r0, const int16_t *a0, const int16_t *q0,
                     int16_t *r1, const int16_t *a1, const int16_t *q1,
                     int16_t *r2, const int16_t *a2, const int16_t *q2,
                     int16_t *r3, const int16_t *a3, const int16_t *q3);
/* two-stream variant: one mod-7681 inverse NTT interleaved with one mod-257
 * inverse FNT (the inner-product path has a single polynomial per modulus) */
#define invntt1_invfnt1 POLYMUL_NAMESPACE(_invntt1_invfnt1)
void invntt1_invfnt1(int16_t *r0, const int16_t *a0, const int16_t *q0,
                     int16_t *r1, const int16_t *a1, const int16_t *q1);

/* pointwise multiplication accumulated over the module rank */
#define polyvec_basemul_acc_montgomery                                         \
    POLYMUL_NAMESPACE(_polyvec_basemul_acc_montgomery)
void polyvec_basemul_acc_montgomery(nttpoly *r, const nttpolyvec *a,
                                    const nttpolyvec *b, const int16_t *pdata);
#define polyvec_basemul_fnt_acc_montgomery POLYMUL_NAMESPACE(_polyvec_basemul_fnt_acc_montgomery)
void polyvec_basemul_fnt_acc_montgomery(nttpoly *r, const nttpolyvec *a, const nttpolyvec *b, const int16_t *pdata);

/* matrix-vector product and inner product, stopped before the CRT
 * recombination: the two per-modulus results are handed back so the caller can
 * pick a fused recombination (see poly_fnt_crt_shl_add & friends) */
#define polyvec_fnt_matrix_vector_mul_raw POLYMUL_NAMESPACE(_polyvec_fnt_matrix_vector_mul_raw)
void polyvec_fnt_matrix_vector_mul_raw(nttpolyvec *t0, nttpolyvec *t1,
                                       nttpolyvec shat[2],
                                       const polyvec a[KEM_K],
                                       const polyvec *s, int transpose);
#define polyvec_fnt_iprod_raw POLYMUL_NAMESPACE(_polyvec_fnt_iprod_raw)
void polyvec_fnt_iprod_raw(nttpoly *r0, nttpoly *r1, const polyvec *a,
                           const polyvec *b);
/* as polyvec_fnt_iprod_raw, but with b already transformed: bhat[0] holds the
 * mod-7681 NTT and bhat[1] the mod-257 FNT of b, in the exact layout
 * polyvec_fnt_matrix_vector_mul_raw hands back through its shat argument.
 * Lets a caller that multiplies the same vector by a matrix and by another
 * vector (Enc: A*r and b^T*r) pay for b's forward transforms only once. */
#define polyvec_fnt_iprod_pre_raw POLYMUL_NAMESPACE(_polyvec_fnt_iprod_pre_raw)
void polyvec_fnt_iprod_pre_raw(nttpoly *r0, nttpoly *r1, const polyvec *a,
                               const nttpolyvec bhat[2]);

/* CRT recombination fused with the caller's output stage.
 *
 * A plain recombination would mask the result down to Z_q; every caller in
 * src/poly.c then re-reads the whole buffer to shift it back up into the
 * scheme's <<(16-log q) representation, and sometimes to accumulate onto the
 * destination.  Shifting left by 16-log q discards exactly the bits the mask
 * clears, so the mask is redundant once the shift is fused in, and the
 * accumulate costs one extra load instead of a second pass. */
#define poly_fnt_crt_shl_add POLYMUL_NAMESPACE(_poly_fnt_crt_shl_add)
void poly_fnt_crt_shl_add(poly *r, const nttpoly *a, const nttpoly *b,
                          int shift, int16_t round_add, int round_shift);
#define polyvec_fnt_crt_shl POLYMUL_NAMESPACE(_polyvec_fnt_crt_shl)
void polyvec_fnt_crt_shl(polyvec *r, const nttpolyvec *a, const nttpolyvec *b,
                         int shift, int16_t round_add, int round_shift);
#define polyvec_fnt_crt_shl_sub POLYMUL_NAMESPACE(_polyvec_fnt_crt_shl_sub)
void polyvec_fnt_crt_shl_sub(polyvec *r, const nttpolyvec *a,
                             const nttpolyvec *b, int shift);

#endif // SMAUG_NTT_H
