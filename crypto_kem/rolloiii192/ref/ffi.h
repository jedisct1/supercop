
#ifndef FFI_H
#define FFI_H

#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <x86intrin.h>

#define FIELD_Q 2
#define FIELD_M 107
#define FIELD_UINT64 2

typedef uint64_t ffi_elt[2];
typedef uint64_t ffi_elt_ur[4];

typedef ffi_elt* ffi_vec;
typedef ffi_vec ffi_vspace;

typedef struct {
	ffi_vec v;
	uint64_t size;
	int64_t degree;
} ffi_poly_struct;

typedef struct {
	uint64_t coeffs_nb;
	uint64_t* coeffs;
} ffi_poly_sparse_struct;

typedef ffi_poly_struct* ffi_poly;
typedef ffi_poly_sparse_struct* ffi_poly_sparse;

typedef ffi_poly ffi_qre;

uint64_t SQR_LOOKUP_TABLE[256];

static const ffi_elt INV_POLY_FIELD = {657, 8796093022208};

#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

#endif
