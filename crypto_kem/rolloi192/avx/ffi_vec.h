/**
 * \file ffi_vec.h
 * \brief Interface for vectors of finite field elements
 */

#ifndef FFI_VEC_H
#define FFI_VEC_H

#include "ffi.h"
#include "ffi_elt.h"
#include "rng.h"


void ffi_vec_init(ffi_vec* v, uint64_t size);
void ffi_vec_clear(ffi_vec v, uint64_t size);

void ffi_vec_set_zero(ffi_vec v, uint64_t size);
void ffi_vec_set(ffi_vec o, const ffi_vec v, uint64_t size);
void ffi_vec_set_random(ffi_vec v, uint64_t size, AES_XOF_struct* ctx);
void ffi_vec_set_random2(ffi_vec v, uint64_t size);
void ffi_vec_set_random_full_rank(ffi_vec o, uint64_t size, AES_XOF_struct* ctx);
void ffi_vec_set_random_full_rank2(ffi_vec o, uint64_t size);
void ffi_vec_set_random_full_rank_with_one(ffi_vec o, uint64_t size, AES_XOF_struct* ctx);
void ffi_vec_set_random_from_support(ffi_vec o, uint64_t size, const ffi_vec support, uint64_t rank, AES_XOF_struct* ctx);
void ffi_vec_set_random_from_support2(ffi_vec o, uint64_t size, const ffi_vec support, uint64_t rank);

uint64_t ffi_vec_gauss(ffi_vec v, uint64_t size);
uint64_t ffi_vec_get_rank(const ffi_vec v, uint64_t size);
uint64_t ffi_vec_echelonize(ffi_vec v, uint64_t size);

void ffi_vec_add(ffi_vec o, const ffi_vec v1, const ffi_vec v2, uint64_t size);
void ffi_vec_scalar_mul(ffi_vec o, const ffi_vec v, const ffi_elt e, uint64_t size);

void ffi_vec_to_string(unsigned char* str, const ffi_vec v, uint64_t size);
void ffi_vec_from_string(ffi_vec v, uint64_t size, const unsigned char* str);
void ffi_vec_to_string_compact(unsigned char* str, const ffi_vec v, uint64_t size);
void ffi_vec_from_string_compact(ffi_vec v, uint64_t size, const unsigned char* str);
void ffi_vec_print(ffi_vec v, uint64_t size);

#endif

