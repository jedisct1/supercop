#ifndef NTRUPLUS768_DECAP_H
#define NTRUPLUS768_DECAP_H

/* Decapsulation endpoints (private to kem.c); layouts in docs/IMPLEMENTATION.md. */

#include <stdint.h>

#include "params.h"
#include "poly.h"

/*
 * Checked packed ct/f consumer for the decapsulation path.  Decodes ct and f,
 * writes decoded_ct in Decap QSoA with coefficients in [0,4095], and writes
 * their product, retaining one R^-1 factor, element-major per group (st4) as
 * expected by poly_invntt_ternary_decap(); |product| <= 2458 for canonical
 * inputs.  Returns 1 iff any ct or f coefficient is >= q; both outputs are
 * complete on either return.
 */
int poly_frombytes_basemul_decap_scale(
    poly *out, poly *decoded_ct,
    const uint8_t packed_ct[NTRUPLUS_POLYBYTES],
    const uint8_t packed_f[NTRUPLUS_POLYBYTES]);

/* Checked decode into Decap QSoA; returns 1 iff any coefficient is >= q.
 * Output coefficients lie in [0,4095] on either return. */
int poly_frombytes_decap(
    poly *out, const uint8_t in[NTRUPLUS_POLYBYTES]);
/* Reduces Decap QSoA coefficients in (-5q/2,5q/2) to [0,q) and serializes. */
void poly_tobytes_decap(
    uint8_t out[NTRUPLUS_POLYBYTES], const poly *in);
/* Normal-domain product of two Decap QSoA polynomials with coefficients in
 * (-2q,2q); output in (-3q/2,3q/2), Decap QSoA. */
void poly_basemul_decap(
    poly *out, const poly *a, const poly *b);

/* Working area of poly_invntt_ternary_decap: three 512-byte row buffers and
 * the 512-byte stage123 stripe area. */
#define POLY_INVNTT_TERNARY_DECAP_SCRATCHBYTES 2048

/*
 * Good-Thomas inverse of the first decapsulation product fused with the
 * centered mod-3 map: in place, output in {-1,0,1}, equal to poly_crepmod3
 * of the exact inverse.  scratch is caller-owned and holds secret
 * intermediates on return; the caller must clear it.
 */
void poly_invntt_ternary_decap(
    poly *inout, uint8_t scratch[POLY_INVNTT_TERNARY_DECAP_SCRATCHBYTES]);

/* Decap-only signed [-2,2] input (both KEM callers are ternary).
 * Top-split quotient is exactly zero; output remains Decap QSoA.
 * This is not an arbitrary-coefficient Forward entry. */
void poly_ntt_decap(poly *out, const poly *in);

#endif
