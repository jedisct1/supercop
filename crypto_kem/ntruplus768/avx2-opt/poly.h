#ifndef POLY_H
#define POLY_H

#include <immintrin.h>
#include <stdint.h>
#include "abi.h"
#include "params.h"

/*
 * Elements of R_q = Z_q[X]/(X^n - X^n/2 + 1). Represents polynomial
 * coeffs[0] + X*coeffs[1] + X^2*coeffs[2] + ... + X^{n-1}*coeffs[n-1]
 * (in the NTT domain: Official's storage order).  32-byte aligned.
 */
typedef struct{
	int16_t coeffs[NTRUPLUS_N];
} poly __attribute__((aligned(32)));

#define poly_tobytes NTRUPLUS_NAMESPACE(poly_tobytes)
#define poly_frombytes NTRUPLUS_NAMESPACE(poly_frombytes)
#define poly_cbd1 NTRUPLUS_NAMESPACE(poly_cbd1)
#define poly_sotp_encode NTRUPLUS_NAMESPACE(poly_sotp_encode)
#define poly_sotp_decode NTRUPLUS_NAMESPACE(poly_sotp_decode)
#define poly_ntt NTRUPLUS_NAMESPACE(poly_ntt)
#define poly_invntt_crepmod3 NTRUPLUS_NAMESPACE(poly_invntt_crepmod3)
#define poly_basemul_scale NTRUPLUS_NAMESPACE(poly_basemul_scale)
#define poly_basemul_montgomery NTRUPLUS_NAMESPACE(poly_basemul_montgomery)
#define poly_basemul_shoup NTRUPLUS_NAMESPACE(poly_basemul_shoup)
#define poly_baseinv_1 NTRUPLUS_NAMESPACE(poly_baseinv_1)
#define poly_baseinv NTRUPLUS_NAMESPACE(poly_baseinv)
#define poly_add NTRUPLUS_NAMESPACE(poly_add)
#define poly_sub NTRUPLUS_NAMESPACE(poly_sub)
#define poly_triple NTRUPLUS_NAMESPACE(poly_triple)

/* Canonical 12-bit encoding (any int16 input); r and a must not overlap. */
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_tobytes(uint8_t r[NTRUPLUS_POLYBYTES], const poly *a);
/* Decoding; returns 1 (and still writes r) if a coefficient is >= q. */
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
int poly_frombytes(poly *r, const uint8_t a[NTRUPLUS_POLYBYTES]);

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N/4]);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_sotp_encode(poly *r, const uint8_t msg[NTRUPLUS_N/8],
                      const uint8_t buf[NTRUPLUS_N/4]);
NTRUPLUS_INTERNAL
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a,
                     const uint8_t buf[NTRUPLUS_N/4]);

/*
 * Forward NTT in place, without the terminal Barrett reduction of Official
 * poly_ntt: the output equals Official's modulo q and stays within the int16
 * envelope proven for every KEM caller's input domain (docs/IMPLEMENTATION.md).
 * Not a general-input NTT.
 */
NTRUPLUS_INTERNAL NTRUPLUS_SYSV void poly_ntt(poly *r);
/*
 * r = crepmod3(invntt_scale(r)) of Official, in place, for r =
 * poly_basemul_scale(c, f) with c and f canonical (the Decap domain).
 */
NTRUPLUS_INTERNAL NTRUPLUS_SYSV void poly_invntt_crepmod3(poly *r);
/* Official poly_basemul_scale (Decap first product). */
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_basemul_scale(poly *r, const poly *a, const poly *b);
/* r = a*b*R^-1 per base (Official poly_basemul without its R^2 pass). */
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_basemul_montgomery(poly *r, const poly *a, const poly *b);
/*
 * r = a*b per base in Official poly_basemul's output scale (equal mod q).
 * b canonical ([0, q)); a inside the proven Encap/Decap envelope (a lazy
 * poly_ntt output, or c - poly_ntt(m) in Decap); r must not overlap a or b.
 */
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_basemul_shoup(poly *r, const poly *a, const poly *b);

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_baseinv_1(poly *r, __m256i den[NTRUPLUS_N / (16 * NTRUPLUS_D)], const poly *a);
/*
 * Base inversion.  Returns 1 (r zeroed) if a base is not invertible; else 0
 * and r = Official poly_baseinv(a) * R (mod q), which poly_basemul_montgomery
 * cancels in key generation.
 */
NTRUPLUS_INTERNAL int poly_baseinv(poly *r, const poly *a);

NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_add(poly *r, const poly *a, const poly *b);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV
void poly_sub(poly *c, const poly *a, const poly *b);
NTRUPLUS_INTERNAL NTRUPLUS_SYSV void poly_triple(poly *r);

#endif
