#ifndef NTRUPLUS768_ENCAP_H
#define NTRUPLUS768_ENCAP_H

#include <stdint.h>

#include "params.h"
#include "poly.h"

/* Encapsulation endpoints (private to kem.c).  Block-major layout and the
 * loose range are described in docs/IMPLEMENTATION.md. */

/* Canonical encoding of a reduced block-major (Encap) polynomial: the
 * ciphertext boundary.  Key generation packs pk/sk with poly_tobytes_keygen_cq. */
void poly_tobytes_encap(uint8_t out[NTRUPLUS_POLYBYTES], const poly *a);
/*
 * Decode every coefficient and return 1 iff any decoded 12-bit value is
 * outside [0, NTRUPLUS_Q). The output is complete on both return paths.
 */
int poly_frombytes_encap(poly *out,
                   const uint8_t in[NTRUPLUS_POLYBYTES]);

/* Encapsulation-only a*b+c endpoint; its result is packed immediately. */
void poly_basemul_add_encap(poly *out, const poly *a, const poly *b,
                      const poly *c);

/* Lambda table of the Encap basemul-add (tables.c; consumed by base.S). */
extern const int16_t gt_rowbitrev_lambda[2][96];

/* Encap-only signed [-2,2] input; output [-21050,21050]. Same block-major
 * layout and modulo-q scaling as poly_ntt_loose; exact alias allowed.
 * NOT raw bit-exact to generic NTT. Consumers: loose pack and loose basemul-add. */
void poly_ntt_encap_small_lazy(poly *out, const poly *in);

/*
 * Canonical byte boundary for the loose representation above.  This entry
 * accepts every signed-16 representative; public poly_tobytes_encap retains its
 * already-reduced fast path.
 */
void poly_tobytes_encap_loose(
    uint8_t out[NTRUPLUS_POLYBYTES], const poly *in);

#endif
