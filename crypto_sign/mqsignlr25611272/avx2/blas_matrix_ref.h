#ifndef _BLAS_MATRIX_REF_H_
#define _BLAS_MATRIX_REF_H_

#include <stdint.h>

#ifdef  __cplusplus
extern  "C" {
#endif

void gf256mat_prod_ref(uint8_t *c, const uint8_t *matA, unsigned n_A_vec_byte, unsigned n_A_width, const uint8_t *b);


#ifdef  __cplusplus
}
#endif

#endif 