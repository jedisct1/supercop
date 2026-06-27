/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define hh1_p1
// linker define hh1_p2
// linker define hh1_p3
// linker define h2h_p1
// linker define h2h_p2
// linker define h2h_p3
// linker define hh1_xor
// linker define h2h_xor
// linker define dup_mask1
// linker define dup_mask2
// linker define dup_mask3
// linker define swap_c
// linker define swap_mask
// linker define h2h_mask
// linker define vecmask1
// linker define vecmask2
// linker define vec19
// linker define vec608
// linker define vecmask21
// linker define vecmask26
// linker define vecmask32
// linker define a24
// linker define mask63

#include "consts_namespace.h"
#include "crypto_uint32.h"
#include "crypto_uint64.h"

CRYPTO_ALIGN(64)
const crypto_uint32 hh1_p1[]     = { 0x0,0x0,0x0,0x0,0x7FFFFDB,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFDB,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x0,0x0,0x0,0x0 };
CRYPTO_ALIGN(64)
const crypto_uint32 hh1_p2[]     = { 0x0,0x0,0x0,0x0,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x0,0x0,0x0,0x0 };
CRYPTO_ALIGN(64)
const crypto_uint32 hh1_p3[]     = { 0x0,0x0,0x0,0x0,0x7FFFFFF,0x0,0x3FFFFF,0x0,0x7FFFFFF,0x0,0x3FFFFF,0x0,0x0,0x0,0x0,0x0 };
CRYPTO_ALIGN(64)
const crypto_uint32 h2h_p1[]     = { 0x0,0x0,0x0,0x0,0x7FFFFDB,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x0,0x0,0x0,0x0,0x7FFFFDB,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF };
CRYPTO_ALIGN(64)
const crypto_uint32 h2h_p2[]     = { 0x0,0x0,0x0,0x0,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x0,0x0,0x0,0x0,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF,0x7FFFFFF };
CRYPTO_ALIGN(64)
const crypto_uint32 h2h_p3[]     = { 0x0,0x0,0x0,0x0,0x7FFFFFF,0x0,0x3FFFFF,0x0,0x0,0x0,0x0,0x0,0x7FFFFFF,0x0,0x3FFFFF,0x0 };
CRYPTO_ALIGN(64)
const crypto_uint64 hh1_xor[]    = { 0,0,-1,-1,-1,-1,0,0 };
CRYPTO_ALIGN(64)
const crypto_uint64 h2h_xor[]    = { 0,0,-1,-1,0,0,-1,-1 };
CRYPTO_ALIGN(64)
const crypto_uint64 dup_mask1[]  = { 0,1,2,3,0,1,2,3 };
CRYPTO_ALIGN(64)
const crypto_uint64 dup_mask2[]  = { 0,1,0,1,4,5,4,5 };
CRYPTO_ALIGN(64)
const crypto_uint64 dup_mask3[]  = { 2,3,2,3,6,7,6,7 };
CRYPTO_ALIGN(64)
const crypto_uint64 swap_c[]     = { 0,1,2,3,4,5,6,7 };
CRYPTO_ALIGN(64)
const crypto_uint64 swap_mask[]  = { 7,7,7,7,7,7,7,7 };
CRYPTO_ALIGN(64)
const crypto_uint64 h2h_mask[]   = { 0,0,-1,-1,-1,-1,-1,-1 };
CRYPTO_ALIGN(64)
const crypto_uint64 vecmask1[]   = { 0,-1,0,-1,0,-1,0,-1 };
CRYPTO_ALIGN(64)
const crypto_uint64 vecmask2[]   = { -1,0,-1,0,-1,0,-1,0 };
CRYPTO_ALIGN(64)
const crypto_uint64 vec19[]      = { 19,19,19,19,19,19,19,19 };
CRYPTO_ALIGN(64)
const crypto_uint64 vec608[]     = { 608,608,608,608,608,608,608,608 };
CRYPTO_ALIGN(64)
const crypto_uint64 vecmask21[]  = { 0x1FFFFF,0x1FFFFF,0x1FFFFF,0x1FFFFF,0x1FFFFF,0x1FFFFF,0x1FFFFF,0x1FFFFF };
CRYPTO_ALIGN(64)
const crypto_uint64 vecmask26[]  = { 0x3FFFFFF,0x3FFFFFF,0x3FFFFFF,0x3FFFFFF,0x3FFFFFF,0x3FFFFFF,0x3FFFFFF,0x3FFFFFF };
CRYPTO_ALIGN(64)
const crypto_uint64 vecmask32[]  = { 0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF };
CRYPTO_ALIGN(64)
const crypto_uint64 a24[]  	  = { 0,0,121666,121666,0,0,0,0 };
CRYPTO_ALIGN(64)
const crypto_uint64 mask63[] 	  = { 0x7FFFFFFFFFFFFFFF };
