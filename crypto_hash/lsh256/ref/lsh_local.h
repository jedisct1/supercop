/*
 * Copyright (c) 2016 NSR (National Security Research Institute)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy 
 * of this software and associated documentation files (the "Software"), to deal 
 * in the Software without restriction, including without limitation the rights 
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
 * copies of the Software, and to permit persons to whom the Software is 
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
 * THE SOFTWARE.
 */

#ifndef _REF_LSH_LOCAL_H_
#define _REF_LSH_LOCAL_H_

#include "lsh_def.h"

/* INLINE, ROTL64, ROTL, IS_LITTLE_ENDIAN, loadLE32, loadLE64 */

#ifndef __has_builtin
#define __has_builtin(x) 0
#endif

#ifndef __has_attribute
#define __has_attribute(x) 0
#endif

#ifndef __has_declspec_attribute
#define __has_declspec_attribute(x) 0
#endif

/* Inlining Macro */
#ifdef INLINE
/* do nothing */
#elif defined(_MSC_VER)
#define INLINE __forceinline
#elif __has_attribute(always_inline)
#define INLINE inline __attribute__((always_inline))
#elif defined(__GNUC__)
#define INLINE inline __attribute__((always_inline))
#elif defined(__cplusplus)
#define INLINE inline
#elif defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#define INLINE inline
#else
#define INLINE 
#endif

/* Rotation Macro */
#if defined(_MSC_VER) && _MSC_VER >= 1400
#include <stdlib.h>
#define ROTL64(x,r)	_rotl64(x,r)
#define ROTR64(x,r)	_rotr64(x,r)
#define ROTL(x,r)	_lrotl(x,r)
#define ROTR(x,r)	_lrotr(x,r)
#else
#define ROTL64(x,r)	((x) << (r)) | ((x) >> (WORD_BIT_LEN-r)) 
#define ROTR64(x,r)	((x) >> (r)) | ((x) << (WORD_BIT_LEN-r))
#define ROTL(x,r)	((x) << (r)) | ((x) >> (WORD_BIT_LEN-r)) 
#define ROTR(x,r)	((x) >> (r)) | ((x) << (WORD_BIT_LEN-r)) 
#endif

/* Check Endian */
#if defined(IS_LITTLE_ENDIAN)
/* do Nothing */
#elif defined(__i386) || defined(_M_IX86) || defined(__x86_64__) || defined(_M_X64)
#	define IS_LITTLE_ENDIAN 1
/* Intel Architecture */
#elif defined(_MSC_VER)
#	define IS_LITTLE_ENDIAN 1
/* All available "Windows" are Little-Endian except XBOX360. */
#elif defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && defined(__ORDER_LITTLE_ENDIAN__)
/* GCC style */
/* use __BYTE_ORDER__ */
#	if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#		define IS_LITTLE_ENDIAN 1
#	else
#		define IS_LITTLE_ENDIAN 0
#	endif
#elif defined(__BIG_ENDIAN__) || defined(__LITTLE_ENDIAN__)
/* use __BIG_ENDIAN__ and __LITTLE_ENDIAN__ */
#	if defined(__LITTLE_ENDIAN__)
#		if __LITTLE_ENDIAN__
#			define IS_LITTLE_ENDIAN 1
#		else
#			define IS_LITTLE_ENDIAN 0
#		endif
#	elif defined(__BIG_ENDIAN__)
#		if __BIG_ENDIAN__
#			define IS_LITTLE_ENDIAN 0
#		else
#			define IS_LITTLE_ENDIAN 1
#		endif
#	endif
#else
/* use <endian.h> */
#	ifdef BSD
#		include <sys/endian.h>
#	else
#		include <endian.h>
#	endif
#	if __BYTE_ORDER__ == __LITTLE_ENDIAN
#		define IS_LITTLE_ENDIAN 1
#	else
#		define IS_LITTLE_ENDIAN 0
#	endif
#endif

#if defined(loadLE32) && defined(loadLE64)
/* do Nothing */
#elif IS_LITTLE_ENDIAN
//	little endian
#define loadLE32(v)	(v)
#define loadLE64(v)	(v)

#else
//	big endian

#if defined(__GNUC__) && ((__GNUC__ > 4) || (__GNUC__ == 4 && __GNUC_MINOR__ >= 3))
#define loadLE32(v)	__builtin_bswap32(v)
#define loadLE64(v)	__builtin_bswap64(v)

#elif __has_builtin(__builtin_bswap32)

#define loadLE32(v)	__builtin_bswap32(v)
#define loadLE64(v)	__builtin_bswap64(v)
#else

/* If you want, you can use htole32 and htole64 instead of below. */
static INLINE lsh_u32 loadLE32(lsh_u32 v) {
	unsigned char* p = (unsigned char*)&v;
	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
}
static INLINE lsh_u64 loadLE64(lsh_u64 v) {
	lsh_u32* p = (lsh_u32*)&v;
	return (lsh_u64)loadLE32(p[0]) << 32 | loadLE32(p[1]);
}
#endif
#endif


#endif
