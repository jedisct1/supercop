/*
 * Algorithm     : Grain128-AEADv2
 * Implementation: C/C++, 64-bit, semi-optimised
 * Endianness    : Little endian
 * Author        : Alexander Maximov
 * Year          : 2021
 */

#ifndef _GRAIN_128_AEAD_V2_
#define _GRAIN_128_AEAD_V2_

// ------------------------------------------------------------------
// Build configuration
// ------------------------------------------------------------------
#define GRAIN_USE_SIMD 1	/* Set to 1 for a version that uses SIMD                         */
#define GRAIN_USE_AVX512 0	/* Set to 1 if the platform supports AVX-512 set of instructions */
#define GRAIN_USE_GF2 0		/* Set to 1 if the platform supports GF2 set of instructions     */

// #define __GRAIN_DEBUG_PRINTS__  /* Printouts the Grain state for debugging purposes       */
#define __GRAIN_STACK_SAFE__       /* Define the flag to make stack-safe code                */

// ------------------------------------------------------------------
#ifdef _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <stdio.h>
#include <stdlib.h>

#include <stdint.h>
typedef uint8_t		u8;
typedef uint16_t	u16;
typedef uint32_t	u32;
typedef uint64_t	u64;

#if GRAIN_USE_SIMD
/* with SIMD */
#ifdef _MSC_VER
#include <intrin.h>
#else
#include <x86intrin.h>
#define _byteswap_uint64(x) __builtin_bswap64(x)
#endif
#define GRAIN_Z_BLOCK 8
#define GRAIN_Z_TYPE u64
#else
/* without SIMD */
#define GRAIN_Z_BLOCK 4
#define GRAIN_Z_TYPE u32
#endif

// ------------------------------------------------------------------
// Public data structures
// ------------------------------------------------------------------
typedef struct 
{	// Order of data members is important in this implementation
	u8 lfsr[16]; // LFSR
	u8 nfsr[16]; // NFSR
	u64 A, R, S; // Accumulator, Register, and next Auth-keystream
	u8 z[GRAIN_Z_BLOCK]; // Message-keystream
} grain_ctx;


// ------------------------------------------------------------------
// NIST API
// ------------------------------------------------------------------

extern int crypto_aead_encrypt(
	unsigned char *c, unsigned long long *clen,
	const unsigned char *m, unsigned long long mlen,
	const unsigned char *ad, unsigned long long adlen,
	const unsigned char *nsec,
	const unsigned char *npub,
	const unsigned char *k);

extern int crypto_aead_decrypt(
	unsigned char *m, unsigned long long *mlen,
	unsigned char *nsec,
	const unsigned char *c, unsigned long long clen,
	const unsigned char *ad, unsigned long long adlen,
	const unsigned char *npub,
	const unsigned char *k);

#endif /* _GRAIN_128_AEAD_V2_ */
