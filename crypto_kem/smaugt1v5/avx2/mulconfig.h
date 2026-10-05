#ifndef SMAUGT_MULCONFIG_H
#define SMAUGT_MULCONFIG_H

/* Compatibility shim for the AVX2 polynomial-multiplication layer.
 *
 * The AVX2 kernels (src/mul/ntt.c, *.S) were written against the
 * SMAUG-T optimized_implementation naming (KEM_N/KEM_Q/KEM_K/POLY_N/...).
 * This header maps those onto the reference implementation's SMAUGT_*
 * parameters so the kernels can be dropped in unchanged.
 *
 * Named mulconfig.h (not config.h as in optimized_implementation) so that it
 * cannot be confused with the reference implementation's own include/config.h.
 */

#include "params.h"

/* All exported symbols of the multiplication layer live under
 * <namespace-prefix>_nttmul_..., e.g. cryptolab_smaugt_mode1_nttmul_ntt2_fnt2 */
#define POLYMUL_NAMESPACE_(s) SMAUGT_NAMESPACE(s)
#define POLYMUL_NAMESPACE(s)  POLYMUL_NAMESPACE_(SMAUGT_CONCAT(nttmul, s))

#define NEGACYCLIC
#define KEM_N SMAUGT_N
#define POLY_N SMAUGT_N
#define NTT_N SMAUGT_N
#define NTT_F 1
#define KEM_Q SMAUGT_Q
#define KEM_K SMAUGT_K

#endif /* !SMAUGT_MULCONFIG_H */
