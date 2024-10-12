#ifndef SMAUG_CIPHERTEXT_H
#define SMAUG_CIPHERTEXT_H

#include <stdint.h>

#include "parameters.h"
#include "poly.h"

typedef struct Ciphertext {
    polyvec c1;
    poly c2;
} ciphertext;

#define computeC1 SMAUG_NAMESPACE(computeC1)
void computeC1(polyvec *c1, const polyvec A[MODULE_RANK], const polyvec *r);
#define computeC2 SMAUG_NAMESPACE(computeC2)
void computeC2(poly *c2, const uint8_t delta[DELTA_BYTES], const polyvec *b,
               const polyvec *r);

#endif // SMAUG_CIPHERTEXT_H
