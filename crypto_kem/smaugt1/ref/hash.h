#ifndef SMAUG_HASH_H
#define SMAUG_HASH_H

#include "fips202.h"
#include "parameters.h"

#define hash_h(OUT, IN, INBYTES) sha3_256(OUT, IN, INBYTES)
#define hash_g(OUT, OUTBYTES, IN1, IN1BYTES, IN2, IN2BYTES)                    \
    shake256_absorb_twice_squeeze(OUT, OUTBYTES, IN1, IN1BYTES, IN2, IN2BYTES)

#define shake256_absorb_twice_squeeze                                          \
    SMAUG_NAMESPACE(shake256_absorb_twice_squeeze)
void shake256_absorb_twice_squeeze(uint8_t *out, size_t out_bytes,
                                   const uint8_t *in1, size_t in1_bytes,
                                   const uint8_t *in2, size_t in2_bytes);

#endif // SMAUG_HASH_H
