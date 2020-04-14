#ifndef ntt_H
#define ntt_H

#include <stdint.h>

#define ntt512_7681 crypto_core_mult3sntrup857_avx_ntt512_7681
#define invntt512_7681 crypto_core_mult3sntrup857_avx_invntt512_7681

extern void ntt512_7681(int16_t *,int);
extern void invntt512_7681(int16_t *,int);

#endif
