#ifndef TiMER_POLY_H
#define TiMER_POLY_H

#include "align.h"
#include "parameters.h"

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

typedef ALIGNED_INT16(LWE_N) poly;

typedef struct {
    poly vec[MODULE_RANK];
} polyvec;

typedef poly nttpoly;
typedef polyvec nttpolyvec;

#define vec_vec_mult_add_p TiMER_NAMESPACE(vec_vec_mult_add_p)
void vec_vec_mult_add_p(poly *r, const polyvec *a, const polyvec *b);
#define vec_vec_mult_add_q TiMER_NAMESPACE(vec_vec_mult_add_q)
void vec_vec_mult_add_q(poly *r, const polyvec *a, const nttpolyvec bhat[2]);

#define matrix_vec_mult_add TiMER_NAMESPACE(matrix_vec_mult_add)
void matrix_vec_mult_add(polyvec *r, nttpolyvec bhat[2],
                         const polyvec a[MODULE_RANK], const polyvec *b);
#define matrix_vec_mult_sub TiMER_NAMESPACE(matrix_vec_mult_sub)
void matrix_vec_mult_sub(polyvec *r, const polyvec a[MODULE_RANK],
                         const polyvec *b);
                         
uint16_t flipabs(uint16_t x);
void poly_frommsg(poly *r, const uint8_t *msg);
void poly_tomsg(unsigned char *msg, const poly *x);

#endif // TiMER_POLY_H
