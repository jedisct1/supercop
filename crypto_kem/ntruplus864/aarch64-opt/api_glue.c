/* Thin C wrappers over the assembly kernels: each supplies the tables and the
 * caller-owned scratch a kernel takes, behind the poly_* API.  NTRU+1152's
 * api_glue.c is the same arrangement. */
#include "poly.h"
#include "base.h"
#include "inverse.h"
#include "unpack.h"
#include "unpack_asm.h"
#include "base_tables.h"
#include "inverse_tables.h"
#include "inverse16_tables.h"

void ntt_asm(int16_t out[864], const int16_t in[864], int16_t *scratch);
void basemul_rinv_asm(int16_t *, const int16_t *, const int16_t *, const int16_t *);
int baseinv_asm(int16_t *, const int16_t *, const int16_t *, int16_t *);
void invntt_ternary_asm(int16_t *, const int16_t *, const int16_t *,
                        const int16_t *, const int16_t *, const int16_t *,
                        int16_t *);

/* ---- forward transform and pointwise products ---- */

void poly_ntt(poly *out, const poly *in)
{
    /* Caller-owned so the leaf allocates nothing the caller cannot name, which
     * is how mlkem-native's kernels are arranged.  Not cleared: under the
     * Official-aligned policy this is an assembly working frame, not secret
     * data with a lifetime, and NTRU+768 stopped clearing its equivalent. */
    int16_t scratch[896];

    ntt_asm(out->coeffs, in->coeffs, scratch);
}

void poly_basemul(poly *out, const poly *a, const poly *b)
{
    basemul_asm(out->coeffs, a->coeffs, b->coeffs);
}

void poly_basemul_add(poly *out, const poly *a, const poly *b, const poly *c)
{
    basemul_add_asm(out->coeffs, a->coeffs, b->coeffs, c->coeffs);
}

/* ---- inversion, the decapsulation first product and inverse ---- */

int poly_baseinv(poly *out, const poly *in)
{
    /* The leaf allocates nothing: this is its denominator tree, prefix tree and
     * running inverse, so the batch inversion's intermediates are reachable
     * from C.  Not cleared: under the Official-aligned policy this is a
     * working frame, like NTRU+1152's den/prefix locals. */
    int16_t scratch[600];

    return baseinv_asm(out->coeffs, in->coeffs, &basemul_zetas[0][0], scratch);
}

void poly_basemul_rinv(int16_t *out, const int16_t *a, const int16_t *b)
{
    basemul_rinv_asm(out, a, b, &basemul_zetas[0][0]);
}

void poly_invntt_ternary(poly *out, const poly *in,
                         uint8_t scratch[POLY_INVNTT_TERNARY_SCRATCHBYTES])
{
    invntt_ternary_asm(out->coeffs, in->coeffs,
                       &invntt9_constants[0][0][0][0][0],
                       &invntt16_constants[0][0],
                       &invntt16_main_constants[0][0],
                       &invntt16_tail_constants[0][0],
                       (int16_t *)scratch);
}

/* ---- canonical decoding ---- */

int poly_frombytes(poly *out, const uint8_t in[NTRUPLUS_POLYBYTES])
{
    return frombytes_asm(out->coeffs, in);
}
