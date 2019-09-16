/**
 * \file ffi_vspace.h
 * \brief Interface for subspaces of Fq^m
 */

#ifndef FFi_VSPACE_H
#define FFi_VSPACE_H

#include "ffi.h"
#include "ffi_elt.h"
#include "ffi_vec.h"

void ffi_vspace_init(ffi_vspace* v, uint64_t size);
void ffi_vspace_clear(ffi_vspace v, uint64_t size);

void ffi_vspace_set_zero(ffi_vspace o, uint64_t size);
void ffi_vspace_set(ffi_vspace o, const ffi_vspace v, uint64_t size);
void ffi_vspace_set_random_full_rank(ffi_vspace o, uint64_t size, AES_XOF_struct* ctx);
void ffi_vspace_set_random_full_rank2(ffi_vspace o, uint64_t size);
void ffi_vspace_set_random_full_rank_with_one(ffi_vspace o, uint64_t size, AES_XOF_struct* ctx);

void ffi_vspace_directsum(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size);
void ffi_vspace_product(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size);
uint64_t ffi_vspace_intersection(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size);

void ffi_vspace_print(const ffi_vspace v, uint64_t size);

#endif

