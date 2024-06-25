#ifndef _BLAS_COMM_H_
#define _BLAS_COMM_H_

#include <stdint.h>


static inline uint8_t gf256v_get_ele(const uint8_t *a, unsigned i) { return a[i]; }

static inline uint8_t gf256v_set_ele(uint8_t *a, unsigned i, uint8_t v) { a[i]=v; return v; }


#ifdef  __cplusplus
extern  "C" {
#endif

void gf256v_set_zero(uint8_t *b, unsigned _num_byte);

unsigned gf256v_is_zero(const uint8_t *a, unsigned _num_byte);


#ifdef  __cplusplus
}
#endif

#endif

