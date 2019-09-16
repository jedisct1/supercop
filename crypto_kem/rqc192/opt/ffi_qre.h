/**
 * \file ffi_qre.h
 * \brief Interface for quotient ring elements 
 * */

#ifndef FFI_QRE_H
#define FFI_QRE_H

#include "ffi.h"
#include "rng.h"

ffi_poly_sparse modulus;
ffi_poly modulusInv;
uint64_t QRE_DEG;

void ffi_qre_init_modulus(uint64_t n);
void ffi_qre_clear_modulus();
ffi_poly_sparse ffi_qre_get_modulus(uint64_t n);

void ffi_qre_init(ffi_qre* e);
void ffi_qre_clear(ffi_qre e);

void ffi_qre_set_zero(ffi_qre o);
void ffi_qre_set_random(ffi_qre o, AES_XOF_struct* ctx);
void ffi_qre_set_random2(ffi_qre o);
void ffi_qre_set_random_full_rank(ffi_qre o, AES_XOF_struct* ctx);
void ffi_qre_set_random_full_rank_with_one(ffi_qre o, AES_XOF_struct* ctx);
void ffi_qre_set_random_from_support(ffi_qre o, const ffi_vspace support, uint64_t rank, AES_XOF_struct* ctx);
void ffi_qre_set_random_from_support2(ffi_qre o, const ffi_vspace support, uint64_t rank);

uint64_t ffi_qre_is_equal_to(const ffi_qre e1, const ffi_qre e2);

void ffi_qre_add(ffi_qre o, const ffi_qre e1, const ffi_qre e2);
void ffi_qre_mul(ffi_qre o, const ffi_qre e1, const ffi_qre e2);
void ffi_qre_div(ffi_qre q, ffi_qre r, const ffi_qre a, const ffi_qre b);
void ffi_qre_inv(ffi_qre o, const ffi_qre e);

void ffi_qre_to_string(unsigned char* str, const ffi_qre e);
void ffi_qre_from_string(ffi_qre e, const unsigned char* str);
void ffi_qre_to_string_compact(unsigned char* str, const ffi_qre e);
void ffi_qre_from_string_compact(ffi_qre e, const unsigned char* str);

void ffi_qre_print(ffi_qre e);

#endif

