#ifndef xor_mat_vec256_h
#define xor_mat_vec256_h

#include <stdint.h>
#include "vec256.h"

#define xor_mat_vec256 CRYPTO_NAMESPACE(xor_mat_vec256)
extern void xor_mat_vec256(unsigned char *, const unsigned char *, int64_t, int64_t, const vec256 *);

#endif
