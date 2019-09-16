/**
 * \file ffi_vec.h
 * \brief Interface for finite field elements
 */

#ifndef FFI_ELT_H
#define FFI_ELT_H

#include "ffi.h"
#include "rng.h"


/********************
* ffi_elt functions *
********************/

void ffi_field_init() ;

void ffi_elt_set_zero(ffi_elt o);
void ffi_elt_set_one(ffi_elt o);
void ffi_elt_set(ffi_elt o, const ffi_elt e);
void ffi_elt_set_random(ffi_elt o, AES_XOF_struct* ctx);
void ffi_elt_set_random2(ffi_elt o);

uint64_t ffi_elt_get_degree(const ffi_elt e);
uint64_t ffi_elt_get_coefficient(const ffi_elt e, uint64_t index);
void ffi_elt_set_coefficient(ffi_elt o, uint64_t index);
uint64_t ffi_elt_is_zero(const ffi_elt e);
uint64_t ffi_elt_is_equal_to(const ffi_elt e1, const ffi_elt e2);
uint64_t ffi_elt_is_greater_than(const ffi_elt e1, const ffi_elt e2);

void ffi_elt_add(ffi_elt o, const ffi_elt e1, const ffi_elt e2);
void ffi_elt_mul(ffi_elt o, const ffi_elt e1, const ffi_elt e2);
void ffi_elt_inv(ffi_elt o, const ffi_elt e);
void ffi_elt_sqr(ffi_elt o, const ffi_elt e);
void ffi_elt_nth_root(ffi_elt o, const ffi_elt e, uint64_t n);
void ffi_elt_reduce(ffi_elt o, const ffi_elt_ur e);

void ffi_elt_print(const ffi_elt e);


/***********************
* ffi_elt_ur functions *
***********************/

void ffi_elt_ur_mul(ffi_elt_ur o, const ffi_elt e1, const ffi_elt e2);
void ffi_elt_ur_sqr(ffi_elt_ur o, const ffi_elt e);

void ffi_elt_ur_print(const ffi_elt_ur e);



/***************************
* ffi-layer only functions *
***************************/

void ffi_elt_from_uint64(ffi_elt e, const uint64_t* u);
void ffi_elt_to_uint64(uint64_t* o, const ffi_elt e);

void ffi_elt_ur_set_zero(ffi_elt_ur o);
void ffi_elt_ur_from_uint64(ffi_elt e, const uint64_t* u);
void ffi_elt_ur_set_random(ffi_elt_ur e);

#endif
