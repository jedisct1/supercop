// SPDX-License-Identifier: MIT

#ifndef SMAUGT_PARAMS_H
#define SMAUGT_PARAMS_H

#include "config.h"

#define SMAUGT_MODE SMAUGT_CONFIG_MODE
#define SMAUGT_NAMESPACE CRYPTO_NAMESPACE
#define OLD_SMAUGT_NAMESPACE(s)                                                    \
    SMAUGT_CONCAT(SMAUGT_CONFIG_NAMESPACE_PREFIX_MODE, s)
#define SMAUGT_CRYPTO_ALGNAME                                                  \
    SMAUGT_STR(SMAUGT_CONCAT(smaugt_, SMAUGT_CONFIG_MODE_STRING))

#define SMAUGT_N 256                      // LWE dim and LWR dim
#define SMAUGT_DELTA_BYTES (SMAUGT_N / 8) // 32
#define SMAUGT_T_BYTES (SMAUGT_N / 8)     // 32
#define SMAUGT_LOG_T 1                    // plaintext modulus

#if SMAUGT_MODE == SMAUGT_MODE1
#define SMAUGT_K 2           // rank of the module, in (2, 3, 4)
#define SMAUGT_LOG_Q 10      // public key modulus
#define SMAUGT_LOG_P 8       // ciphertext modulus
#define SMAUGT_LOG_P_PRIME 5 // ciphertext2 modulus
#define SMAUGT_CBDSEED_BYTES ((3 * SMAUGT_N) / 8)
#define SMAUGT_MSG_BYTES SMAUGT_DELTA_BYTES
#elif SMAUGT_MODE == SMAUGT_MODE3
#define SMAUGT_K 3           // rank of the module, in (2, 3, 4)
#define SMAUGT_LOG_Q 11      // public key modulus
#define SMAUGT_LOG_P 9       // ciphertext modulus
#define SMAUGT_LOG_P_PRIME 4 // ciphertext2 modulus
#define SMAUGT_CBDSEED_BYTES ((2 * SMAUGT_N) / 8)
#define SMAUGT_MSG_BYTES SMAUGT_DELTA_BYTES
#elif SMAUGT_MODE == SMAUGT_MODE5
#define SMAUGT_K 4           // rank of the module, in (2, 3, 4)
#define SMAUGT_LOG_Q 11      // public key modulus
#define SMAUGT_LOG_P 9       // ciphertext modulus
#define SMAUGT_LOG_P_PRIME 7 // ciphertext2 modulus
#define SMAUGT_CBDSEED_BYTES ((4 * SMAUGT_N) / 8)
#define SMAUGT_MSG_BYTES SMAUGT_DELTA_BYTES
#elif SMAUGT_MODE == SMAUGT_MODET
#define SMAUGT_K 2           // rank of the module, in (2, 3, 4)
#define SMAUGT_LOG_Q 10      // public key modulus
#define SMAUGT_LOG_P 8       // ciphertext modulus
#define SMAUGT_LOG_P_PRIME 3 // ciphertext2 modulus
#define SMAUGT_CBDSEED_BYTES ((3 * SMAUGT_N) / 8)
#define SMAUGT_MSG_BYTES 16 // for D2
#endif

#define SMAUGT_MODULUS_16_LOG_Q                                                \
    (16 - SMAUGT_LOG_Q) // modulus (16 - SMAUGT_LOG_Q)
#define SMAUGT_MODULUS_16_LOG_P                                                \
    (16 - SMAUGT_LOG_P) // modulus (16 - SMAUGT_LOG_P)
#define SMAUGT_MODULUS_16_LOG_P_PRIME                                          \
    (16 - SMAUGT_LOG_P_PRIME) // modulus (16 - SMAUGT_LOG_P_PRIME)
#define SMAUGT_MODULUS_16_LOG_T                                                \
    (16 - SMAUGT_LOG_T) // modulus (16 - SMAUGT_LOG_T)

// Size of keys and ciphertext
#define SMAUGT_SHARED_SECRETE_BYTES (32)                   // 32
#define SMAUGT_crypto_BYTES SMAUGT_SHARED_SECRETE_BYTES    // 32
#define SMAUGT_CTPOLY1_BYTES (SMAUGT_LOG_P * SMAUGT_N / 8) // element in R_p
#define SMAUGT_CTPOLY2_BYTES                                                   \
    (SMAUGT_LOG_P_PRIME * SMAUGT_N / 8)    // element in R_p'
#define SMAUGT_SKPOLY_BYTES (SMAUGT_N / 4) // 64
#define SMAUGT_SKPOLYVEC_BYTES                                                 \
    (SMAUGT_SKPOLY_BYTES * SMAUGT_K) // vector of secret polynomials
#define SMAUGT_CTPOLYVEC_BYTES                                                 \
    (SMAUGT_CTPOLY1_BYTES * SMAUGT_K) // vector with element in R_p
#define SMAUGT_CIPHERTEXT_BYTES                                                \
    (SMAUGT_CTPOLYVEC_BYTES + SMAUGT_CTPOLY2_BYTES)         // (vector c21, c22)
#define SMAUGT_PKSEED_BYTES (32)                            // seed for a(x) 32
#define SMAUGT_PKPOLY_BYTES ((SMAUGT_LOG_Q * SMAUGT_N) / 8) // b(x)
#define SMAUGT_PKPOLYVEC_BYTES                                                 \
    (SMAUGT_PKPOLY_BYTES * SMAUGT_K) // vector with element in R_q
#define SMAUGT_PKPOLYMAT_BYTES                                                 \
    (SMAUGT_PKPOLYVEC_BYTES * SMAUGT_K) // matrix with element in R_q
#define SMAUGT_PUBLICKEY_BYTES                                                 \
    (SMAUGT_PKSEED_BYTES + SMAUGT_PKPOLYVEC_BYTES) // (A seed, b(x) vector)
#define SMAUGT_PKE_SECRETKEY_BYTES (SMAUGT_SKPOLYVEC_BYTES) // s(x) vector
#define SMAUGT_KEM_SECRETKEY_BYTES                                             \
    (SMAUGT_PKE_SECRETKEY_BYTES + SMAUGT_T_BYTES +                             \
     SMAUGT_PUBLICKEY_BYTES) // s(x) vector, t, pk

#endif /* !SMAUGT_PARAMS_H */
