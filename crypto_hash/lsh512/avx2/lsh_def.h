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

#ifndef _SIMD_LSH_DEF_H_
#define _SIMD_LSH_DEF_H_

/* LSH Variable Type */
#include <stddef.h>
#if defined(_MSC_VER) && _MSC_VER < 1600
/* Under Visual Studio 2010 */
typedef unsigned __int64 lsh_u64;
typedef unsigned int lsh_u32;
typedef unsigned short lsh_u16;
typedef unsigned char lsh_u8;
typedef unsigned int lsh_uint;
typedef lsh_u32 lsh_type;
typedef lsh_uint lsh_err;
#else
/* C99 Compatible */
#include <stdint.h> 
typedef uint64_t lsh_u64;
typedef uint32_t lsh_u32;
typedef uint16_t lsh_u16;
typedef uint8_t  lsh_u8;
typedef uint32_t lsh_uint;
typedef lsh_u32 lsh_type;
typedef lsh_uint lsh_err;
#endif

/* SIMD Flag */
// #define LSH_NO_SIMD
// #define LSH_NO_AVX2
// #define LSH_NO_XOP
// #define LSH_NO_SSSE3
// #define LSH_NO_SSE2

/* LSH AlgType */

#define LSH_TYPE_256_256				0x0000020
#define LSH_TYPE_256_224				0x000001C

#define LSH_TYPE_512_512				0x0010040
#define LSH_TYPE_512_384				0x0010030
#define LSH_TYPE_512_256				0x0010020
#define LSH_TYPE_512_224				0x001001C

#define LSH_TYPE_224					LSH_TYPE_256_224
#define LSH_TYPE_256					LSH_TYPE_256_256
#define LSH_TYPE_384					LSH_TYPE_512_384
#define LSH_TYPE_512					LSH_TYPE_512_512

/* LSH AlgType Macro */

#define LSH_IS_LSH256(lsh_type_val)				(((lsh_type_val)&0xf0000)==0)
#define LSH_IS_LSH512(lsh_type_val)				(((lsh_type_val)&0xf0000)==0x10000)

#define LSH_GET_SMALL_HASHBIT(lsh_type_val)		((lsh_type_val)>>24)
#define LSH_GET_HASHBYTE(lsh_type_val)			((lsh_type_val) & 0xffff)
#define LSH_GET_HASHBIT(lsh_type_val)			((LSH_GET_HASHBYTE(lsh_type_val)<<3)-LSH_GET_SMALL_HASHBIT(lsh_type_val))

#define LSH_MAKE_TYPE(is_lsh512, hash_bit_len)	(lsh_type)(((is_lsh512)?0x10000:0) \
												| (((hash_bit_len)&7)	?((((hash_bit_len)>>3) + 1) | ((8 - ((hash_bit_len)&7))<<24)) \
																		:((hash_bit_len)>>3)))

/* LSH Constants */

#define LSH256_MSG_BLK_BYTE_LEN			128
#define LSH256_MSG_BLK_BIT_LEN			1024
#define LSH256_CV_BYTE_LEN				64
#define LSH256_HASH_VAL_MAX_BYTE_LEN	32

#define LSH512_MSG_BLK_BYTE_LEN			256
#define LSH512_MSG_BLK_BIT_LEN			2048
#define LSH512_CV_BYTE_LEN				128
#define LSH512_HASH_VAL_MAX_BYTE_LEN	64

/* Error Code */

#define LSH_SUCCESS					0x0
#define LSH_ERR_NULL_PTR			0x2401
#define LSH_ERR_INVALID_ALGTYPE		0x2402
#define LSH_ERR_INVALID_DATABITLEN	0x2403
#define LSH_ERR_INVALID_STATE		0x2404

#ifndef NULL
#define NULL ((void*)0)
#endif

#ifndef __has_attribute
#define __has_attribute(x) 0
#endif

#if defined(LSH_ALIGNED_)
/* do nothing */
#elif defined(_MSC_VER)
#define LSH_ALIGNED_(x) __declspec(align(x))
#elif defined(__GNUC__)
#define LSH_ALIGNED_(x) __attribute__ ((aligned(x)))
#elif __has_attribute(aligned)
#define LSH_ALIGNED_(x) __attribute__ ((aligned(x)))
#endif


#endif
