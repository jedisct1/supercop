
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
#define FIELD_M 127
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

static const __m128i SQR_MASK_LH = {0x0F0F0F0F0F0F0F0F, 0x0F0F0F0F0F0F0F0F};
static const __m128i SQR_LOOKUP_TABLE = {0x1514111005040100, 0x5554515045444140};


#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

#define ALIGN16 __attribute__((aligned(16)))

#define AVX_LOAD      _mm_load_si128
#define AVX_LOADS     _mm_stream_load_si128
#define AVX_ZERO      _mm_setzero_si128
#define AVX_STORE     _mm_store_si128
#define AVX_PSHUFB    _mm_shuffle_epi8
#define AVX_SET64     _mm_set_epi64x
#define AVX_SET8      _mm_set_epi8
#define AVX_XOR       _mm_xor_si128
#define AVX_AND       _mm_and_si128
#define AVX_SHL       _mm_slli_epi64
#define AVX_SHR       _mm_srli_epi64
#define AVX_SHL128    _mm_slli_si128
#define AVX_SHR128    _mm_srli_si128
#define AVX_UNPACKLO  _mm_unpacklo_epi8
#define AVX_UNPACKHI  _mm_unpackhi_epi8
#define AVX_EXTRACT64 _mm_extract_epi64
#define AVX_EXTRACT8  _mm_extract_epi8
#define AVX_ALIGNR    _mm_alignr_epi8
#define AVX_CLMUL     _mm_clmulepi64_si128

#define ALL_SHL(v, n) \
({ \
    __m128i v1, v2; \
    v1 = _mm_slli_epi64(v, n); \
    v2 = _mm_slli_si128(v, 8); \
    v2 = _mm_srli_epi64(v2, 64 - (n)); \
    v1 = _mm_or_si128(v1, v2); \
    v1; \
})

#define ALL_SHR(v, n) \
({ \
    __m128i v1, v2; \
 \
    v1 = _mm_srli_epi64(v, n); \
    v2 = _mm_srli_si128(v, 8); \
    v2 = _mm_slli_epi64(v2, 64 - (n)); \
    v1 = _mm_or_si128(v1, v2); \
    v1; \
})

#endif
