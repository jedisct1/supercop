#ifndef PACKING_H
#define PACKING_H

#include <stdint.h>
#include "params.h"
#include "poly.h"

void polyeta_pack(uint8_t *r, const poly *a);

void polyeta_unpack(poly *r, const uint8_t *a);

void polyt1_pack(uint8_t *r, const poly *a);

void polyt1_unpack(poly *r, const uint8_t *a);

void polyt0_pack(uint8_t *r, const poly *a);

void polyt0_unpack(poly *r, const uint8_t *a);

void polyz_pack(uint8_t *r, const poly *a);

void polyz_unpack(poly *r, const uint8_t *a);

void polyw1_pack(uint8_t *r, const poly *a);

void pack_sk(uint8_t sk[crypto_SECRETKEYBYTES],
             const uint8_t zeta[SEEDBYTES],
             const uint8_t tr[SEEDBYTES],
             const uint8_t key[SEEDBYTES],
             const poly *t0,
             const poly *s1,
             const poly *s2);

void pack_sig(uint8_t sig[crypto_BYTES],
              const uint8_t c[SEEDBYTES], const poly *z, const poly *h);

void pack_pk(uint8_t pk[crypto_PUBLICKEYBYTES],
             const uint8_t zeta[SEEDBYTES], const poly *t1);

void unpack_pk(uint8_t zeta[SEEDBYTES], poly *t1,
               const uint8_t pk[crypto_PUBLICKEYBYTES]);

void unpack_sk(uint8_t zeta[SEEDBYTES],
               uint8_t tr[SEEDBYTES],
               uint8_t key[SEEDBYTES],
               poly *t0,
               poly *s1,
               poly *s2,
               const uint8_t sk[crypto_SECRETKEYBYTES]);

int unpack_sig(uint8_t c[SEEDBYTES], poly *z, poly *h,
               const uint8_t sig[crypto_BYTES]);

#endif
