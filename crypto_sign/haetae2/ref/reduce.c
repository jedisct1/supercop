// 20251220 djb: some usage of cryptoint
#include "reduce.h"
#include "params.h"
#include <stdint.h>
#include "crypto_int32.h"

/*************************************************
 * Name:        montgomery_reduce
 *
 * Description: For finite field element a with -2^{31}Q <= a <= Q*2^31,
 *              compute r \equiv a*2^{-32} (mod Q) such that -Q < r < Q.
 *
 * Arguments:   - int64_t: finite field element a
 *
 * Returns r.
 **************************************************/
int32_t montgomery_reduce(int64_t a) {
    int32_t t;

    t = (int64_t)(int32_t)a * QINV;
    t = (a - (int64_t)t * Q) >> 32;
    return t;
}

/*************************************************
 * Name:        caddq
 *
 * Description: Add Q if input coefficient is negative.
 *
 * Arguments:   - int32_t: finite field element a
 *
 * Returns r.
 **************************************************/
int32_t caddq(int32_t a) {
    a += crypto_int32_negative_mask(a) & Q;
    return a;
}

/*************************************************
 * Name:        freeze
 *
 * Description: For finite field element a, compute standard
 *              representative r = a mod^+ Q.
 *
 * Arguments:   - int32_t: finite field element a
 *
 * Returns r.
 **************************************************/
int32_t freeze(int32_t a) {
    int64_t t = (int64_t)a * QREC;
    t = t >> 32;
    t = a - t * Q;             // -2Q <  t < 2Q
    t += crypto_int32_negative_mask(t) & DQ;       //   0 <= t < 2Q
    t -= ~crypto_int32_negative_mask(t - Q) & Q; //   0 <= t < Q
    return t;
}

/*************************************************
 * Name:        reduce32_2q
 *
 * Description: compute reduction with 2Q
 *
 * Arguments:   - int32_t: finite field element a
 *
 * Returns r.
 **************************************************/
int32_t reduce32_2q(int32_t a) {
    int64_t t = (int64_t)a * DQREC;
    t >>= 32;
    t = a - t * DQ;              // -4Q <  t < 4Q
    t += crypto_int32_negative_mask(t) & (DQ * 2);   //   0 <= t < 4Q
    t -= ~crypto_int32_negative_mask(t - DQ) & DQ; //   0 <= t < Q
    t -= ~crypto_int32_negative_mask(t - Q) & DQ;  // centered representation
    return (int32_t)t;
}

/*************************************************
 * Name:        freeze2q
 *
 * Description: For finite field element a, compute standard
 *              representative r = a mod^+ 2Q.
 *
 * Arguments:   - int32_t: finite field element a
 *
 * Returns r.
 **************************************************/
int32_t freeze2q(int32_t a) {
    int64_t t = (int64_t)a * DQREC;
    t >>= 32;
    t = a - t * DQ;              // -4Q <  t < 4Q
    t += crypto_int32_negative_mask(t) & (DQ * 2);   //   0 <= t < 4Q
    t -= ~crypto_int32_negative_mask(t - DQ) & DQ; //   0 <= t < Q
    return (int32_t)t;
}
