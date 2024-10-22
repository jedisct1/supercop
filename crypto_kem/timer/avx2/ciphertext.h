#ifndef TiMER_CIPHERTEXT_H
#define TiMER_CIPHERTEXT_H

#include <stdint.h>

#include "ntt.h"
#include "parameters.h"
#include "poly.h"

typedef struct Ciphertext {
    polyvec c1;
    poly c2;
} ciphertext;

#define computeC1 TiMER_NAMESPACE(computeC1)
void computeC1(polyvec *c1, nttpolyvec rhat[2], const polyvec A[MODULE_RANK],
               const polyvec *r);
#define computeC2 TiMER_NAMESPACE(computeC2)
void computeC2(poly *c2, const uint8_t delta[MSG_BYTES], const polyvec *b,
               const nttpolyvec rhat[2]);

#endif // TiMER_CIPHERTEXT_H
