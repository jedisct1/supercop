#include "secure_clear.h"
#include "poly.h"
#include "base.h"
#include "inverse.h"
#include "inverse_asm.h"
#include "pack_asm.h"
#include "pack.h"
#include "inverse_tables.h"
#include "invntt9_lane_tables.h"
#include "inverse16_tables.h"

/* Thin wrappers over the assembly kernels, the same arrangement as NTRU+864's
 * api_glue.c. */

void ntt_asm(int16_t out[NTRUPLUS_N], const int16_t in[NTRUPLUS_N], int16_t *scratch);
void invntt_ternary_asm(int16_t *, const int16_t *, const int16_t *,
                        const int16_t *, const int16_t *, const int16_t *,
                        int16_t *);

void poly_ntt(poly *out, const poly *in)
{
    /* Caller-owned so the leaf allocates nothing the caller cannot name.  Not
     * cleared: an assembly working frame, which the Official-aligned policy
     * does not promise to erase. */
    int16_t scratch[1152];

    ntt_asm(out->coeffs, in->coeffs, scratch);
}

void poly_basemul(poly *out, const poly *a, const poly *b)
{ basemul_asm(out->coeffs, a->coeffs, b->coeffs); }

void poly_basemul_add(poly *out, const poly *a, const poly *b, const poly *c)
{ basemul_add_asm(out->coeffs, a->coeffs, b->coeffs, c->coeffs); }

int poly_baseinv(poly *out, const poly *in)
{ return baseinv_asm(out->coeffs, in->coeffs); }

void poly_basemul_rinv(int16_t *out, const int16_t *a, const int16_t *b)
{ basemul_rinv_asm(out, a, b); }

void poly_invntt_ternary(poly *out, const poly *in,
                         uint8_t scratch[POLY_INVNTT_TERNARY_SCRATCHBYTES])
{
    /* The transform cannot run in place -- every invntt16 call scatters its
     * output across ranges the other calls still have to read -- so the
     * scratch is structural.  The leaf does not clear it; decapsulation passes
     * a buffer it clears on exit. */
    invntt_ternary_asm(out->coeffs, in->coeffs,
                       &invntt9_constants_lane[0][0][0][0],
                       &invntt16_constants[0][0],
                       &invntt16_main_constants[0][0],
                       &invntt16_tail_constants[0][0],
                       (int16_t *)scratch);
}

void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{ tobytes_full_asm(r, a->coeffs); }

void poly_tobytes_small(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a)
{ tobytes_small_asm(r, a->coeffs); }


int poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES])
{ return frombytes_asm(r->coeffs, a); }
