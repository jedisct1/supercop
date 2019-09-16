/**
 * \file ffi_poly.h
 * \brief Interface for polynomials over a finite field
 */

#ifndef FFI_POLY_H
#define FFI_POLY_H

#include "ffi.h"
#include "ffi_elt.h"
#include "ffi_vec.h"
#include "ffi_vspace.h"
#include "rng.h"


void ffi_poly_init(ffi_poly* p, uint64_t degree);
void ffi_poly_resize(ffi_poly p, uint64_t size);
void ffi_poly_clear(ffi_poly p);

void ffi_poly_sparse_init(ffi_poly_sparse* p, uint64_t coeff_nb, uint64_t *coeffs);
void ffi_poly_sparse_clear(ffi_poly_sparse p);

void ffi_poly_set_zero(ffi_poly o, uint64_t degree);
void ffi_poly_set(ffi_poly o, const ffi_poly p);
void ffi_poly_set_random(ffi_poly o, uint64_t degree, AES_XOF_struct* ctx);
void ffi_poly_set_random2(ffi_poly o, uint64_t degree);
void ffi_poly_set_random_full_rank(ffi_poly o, uint64_t degree, AES_XOF_struct* ctx);
void ffi_poly_set_random_full_rank_with_one(ffi_poly o, uint64_t degree, AES_XOF_struct* ctx);
void ffi_poly_set_random_from_support(ffi_poly o, uint64_t degree, const ffi_vspace support, uint64_t rank, AES_XOF_struct* ctx);
void ffi_poly_set_random_from_support2(ffi_poly o, uint64_t degree, const ffi_vspace support, uint64_t rank);

void ffi_poly_update_degree(ffi_poly p, uint64_t max_degree);
uint64_t ffi_poly_is_equal_to(const ffi_poly p1, const ffi_poly p2);

void ffi_poly_add(ffi_poly o, const ffi_poly p1, const ffi_poly p2);
void ffi_poly_mul(ffi_poly o, const ffi_poly p1, const ffi_poly p2);
void ffi_poly_mulmod(ffi_poly o, const ffi_poly p1, const ffi_poly p2, const ffi_poly modulus);
void ffi_poly_mulmod_sparse(ffi_poly o, const ffi_poly p1, const ffi_poly p2, const ffi_poly_sparse modulus);
void ffi_poly_div(ffi_poly q, ffi_poly r, const ffi_poly a, const ffi_poly b);
void ffi_poly_inv(ffi_poly o, const ffi_poly p, const ffi_poly modulus);

void ffi_poly_to_string(unsigned char* str, const ffi_poly p);
void ffi_poly_from_string(ffi_poly p, const unsigned char* str);
void ffi_poly_to_string_compact(unsigned char* str, const ffi_poly p);
void ffi_poly_from_string_compact(ffi_poly p, const unsigned char* str);

void ffi_poly_print(ffi_poly p);
void ffi_poly_sparse_print(const ffi_poly_sparse p);

#endif

