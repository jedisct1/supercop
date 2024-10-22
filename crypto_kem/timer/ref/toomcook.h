#ifndef TiMER_TOOMCOOK_H
#define TiMER_TOOMCOOK_H

#include "parameters.h"
#include <stdint.h>

#define poly_mul_acc TiMER_NAMESPACE(poly_mul_acc)
void poly_mul_acc(const int16_t a[LWE_N], const int16_t b[LWE_N],
                  int16_t res[LWE_N]);

#endif // TiMER_TOOMCOOK_H
