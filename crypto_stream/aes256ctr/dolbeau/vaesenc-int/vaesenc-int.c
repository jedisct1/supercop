/*
  aesenc-int.c version 2024/04/28 $
  AES-CTR
  Romain Dolbeau
  Public Domain
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <immintrin.h>
#include "crypto_stream.h"

#ifndef __AVX__
#error "This code requires AVX enabled in the compiler."
#endif

#ifndef __VAES__
#error "This code requires VAES enabled in the compiler."
#endif

#ifdef __AVX512F__
#define __mAESi __m512i
#define _mmAES_broadcast_i32x4(a) _mm512_broadcast_i32x4(a)
#define _mmAES_extracti64x2_epi64(a, b) _mm512_extracti64x2_epi64(a, b)
#define _mmAES_shuffle_epi8(a, b) _mm512_shuffle_epi8(a, b)
#define _mmAES_shuffle_epi32(a, b) _mm512_shuffle_epi32(a, b)
#define _mmAES_clmulepi64_epi128(a, b, c)  _mm512_clmulepi64_epi128(a, b, c)
#define _mmAES_xor_siAES(a, b) _mm512_xor_si512(a, b)
#define _mmAES_loadu_siAES(a) _mm512_loadu_si512(a)
#define _mmAES_aesenc_epi128(a, b) _mm512_aesenc_epi128(a, b)
#define _mmAES_aesenclast_epi128(a, b) _mm512_aesenclast_epi128(a, b)
#define _mmAES_storeu_siAES(a, b) _mm512_storeu_si512(a, b)
#define VAES_WIDTH 64
#else
#define __mAESi __m256i
#define _mmAES_broadcast_i32x4(a) _mm256_broadcastsi128_si256(a)
#define _mmAES_extracti64x2_epi64(a, b) _mm256_extracti128_si256(a, b)
#define _mmAES_shuffle_epi8(a, b) _mm256_shuffle_epi8(a, b)
#define _mmAES_shuffle_epi32(a, b) _mm256_shuffle_epi32(a, b)
#define _mmAES_clmulepi64_epi128(a, b, c)  _mm256_clmulepi64_epi128(a, b, c)
#define _mmAES_xor_siAES(a, b) _mm256_xor_si256(a, b) 
#define _mmAES_loadu_siAES(a) _mm256_loadu_si256(a)
#define _mmAES_aesenc_epi128(a, b) _mm256_aesenc_epi128(a, b)
#define _mmAES_aesenclast_epi128(a, b) _mm256_aesenclast_epi128(a, b)
#define _mmAES_storeu_siAES(a, b) _mm256_storeu_si256(a, b)
#define VAES_WIDTH 32
#endif

#ifdef __INTEL_COMPILER
#define ALIGN16 __declspec(align(16))
#define ALIGN32 __declspec(align(32))
#define ALIGN64 __declspec(align(64))
#else // assume GCC
#define ALIGN16  __attribute__((aligned(16)))
#define ALIGN32  __attribute__((aligned(32)))
#define ALIGN64  __attribute__((aligned(64)))
#undef _bswap64
#undef _bswap
#define _bswap64(a) __builtin_bswap64(a)
#define _bswap(a) __builtin_bswap32(a)
#endif


static inline void aesni_key256_expand(const unsigned char* key, __mAESi rkeys[15]) {
  __m128i key0 = _mm_loadu_si128((const __m128i *)(key+0));
  __m128i key1 = _mm_loadu_si128((const __m128i *)(key+16));
  __m128i temp0, temp1, temp2, temp4;
  int idx = 0;

  rkeys[idx++] = _mmAES_broadcast_i32x4(key0);
  temp0 = key0;
  temp2 = key1;

  /* blockshift-based block by Cedric Bourrasset & Romain Dolbeau */
#define BLOCK1(IMM)                              \
  temp1 = _mm_aeskeygenassist_si128(temp2, IMM); \
  rkeys[idx++] = _mmAES_broadcast_i32x4(temp2);	 \
  temp4 = _mm_slli_si128(temp0,4);               \
  temp0 = _mm_xor_si128(temp0,temp4);            \
  temp4 = _mm_slli_si128(temp0,8);               \
  temp0 = _mm_xor_si128(temp0,temp4);            \
  temp1 = _mm_shuffle_epi32(temp1,0xff);         \
  temp0 = _mm_xor_si128(temp0,temp1)

#define BLOCK2(IMM)                              \
  temp1 = _mm_aeskeygenassist_si128(temp0, IMM); \
  rkeys[idx++] = _mmAES_broadcast_i32x4(temp0);	 \
  temp4 = _mm_slli_si128(temp2,4);               \
  temp2 = _mm_xor_si128(temp2,temp4);            \
  temp4 = _mm_slli_si128(temp2,8);               \
  temp2 = _mm_xor_si128(temp2,temp4);            \
  temp1 = _mm_shuffle_epi32(temp1,0xaa);         \
  temp2 = _mm_xor_si128(temp2,temp1)
  
  BLOCK1(0x01);
  BLOCK2(0x01);

  BLOCK1(0x02);
  BLOCK2(0x02);

  BLOCK1(0x04);
  BLOCK2(0x04);

  BLOCK1(0x08);
  BLOCK2(0x08);

  BLOCK1(0x10);
  BLOCK2(0x10);

  BLOCK1(0x20);
  BLOCK2(0x20);

  BLOCK1(0x40);
  rkeys[idx++] = _mmAES_broadcast_i32x4(temp0);
}

/** single, by-the-book AES encryption with AES-NI */
static inline void aesni_encrypt1(unsigned char *out, unsigned char *n, __mAESi rkeys[16]) {
  __m128i nv = _mm_load_si128((const __m128i *)n);
  int i;
  __m128i temp = _mm_xor_si128(nv, _mmAES_extracti64x2_epi64(rkeys[0], 0));
#pragma unroll(13)
  for (i = 1 ; i < 14 ; i++) {
    temp = _mm_aesenc_si128(temp, _mmAES_extracti64x2_epi64(rkeys[i], 0));
  }
  temp = _mm_aesenclast_si128(temp, _mmAES_extracti64x2_epi64(rkeys[14], 0));
  _mm_store_si128((__m128i*)(out), temp);
}

/** increment the 16-bytes nonce ;
    this really should be improved somehow...
    but it's not yet time-critical, because we
    use the vector variant anyway  */
static inline void incle(unsigned char n[16]) {
/*   unsigned long long out; */
/*   unsigned char carry; */
  unsigned long long *n_ = (unsigned long long*)n;
  n_[1]++;
  if (n_[1] == 0)
    n_[0] ++;
  /* perhaps this will be efficient on broadwell ? */
  /*   carry = _addcarry_u64(0, n_[1], 1ULL, &out); */
  /*   carry = _addcarry_u64(carry, n_[0], 0ULL, &out); */
}

/* all the MAKE* macros are for automatic explicit unrolling */
#define MAKE2(X)                                \
  X(0);X(1)

#define MAKE4(X)                                \
  X(0);X(1);X(2);X(3)

#define MAKE6(X)                                \
  X(0);X(1);X(2);X(3);                          \
  X(4);X(5)

#define MAKE7(X)                                \
  X(0);X(1);X(2);X(3);                          \
  X(4);X(5);X(6)

#define MAKE8(X)                                \
  X(0);X(1);X(2);X(3);                          \
  X(4);X(5);X(6);X(7)

#define MAKE10(X)                               \
  X(0);X(1);X(2);X(3);                          \
  X(4);X(5);X(6);X(7);                          \
  X(8);X(9)

#define MAKE12(X)                               \
  X(0);X(1);X(2);X(3);                          \
  X(4);X(5);X(6);X(7);                          \
  X(8);X(9);X(10);X(11)



/** multiple-blocks-at-once AES encryption with Vector AES-NI ;
    on Icelake, aesenc as a latency of ??? and a througput of ??? */
#ifdef __AVX512F__
/* Step 1 : loading the nonce */
/* load & increment the n vector (non-vectorized, unused for now) */
#define VNVx(a)								\
	__m512i nv##a;							\
	{								\
		__m128i t0nv##a = _mm_shuffle_epi8(_mm_load_si128((const __m128i *)n), pt);incle(n); \
		__m128i t1nv##a = _mm_shuffle_epi8(_mm_load_si128((const __m128i *)n), pt);incle(n); \
		__m128i t2nv##a = _mm_shuffle_epi8(_mm_load_si128((const __m128i *)n), pt);incle(n); \
		__m128i t3nv##a = _mm_shuffle_epi8(_mm_load_si128((const __m128i *)n), pt);incle(n); \
		nv##a = _mm512_inserti32x4(_mm512_undefined_epi32(), t0nv##a, 0); \
		nv##a = _mm512_inserti32x4(nv##a, t1nv##a, 1);		\
		nv##a = _mm512_inserti32x4(nv##a, t2nv##a, 2);		\
		nv##a = _mm512_inserti32x4(nv##a, t3nv##a, 3);		\
	}

#define VNVxV_NOWRAP(a)							\
  nv##a = _mm512_shuffle_epi8(_mm512_add_epi64(_mm512_broadcast_i32x4(nv0i), \
					       _mm512_set_epi64(a*4+3, 0, a*4+2, 0, a*4+1, 0, a*4, 0)), \
			      _mm512_broadcast_i32x4(_mm_set_epi8(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))

#define VNVxV_WRAP(a)                                                    \
  __m512i ad##a = _mm512_add_epi64(_mm512_broadcast_i32x4(nv0i), \
				   _mm512_set_epi64((a*4+3),(a*4+3)>=wrapnumber?1:0, \
						    (a*4+2),(a*4+2)>=wrapnumber?1:0, \
						    (a*4+1),(a*4+1)>=wrapnumber?1:0, \
						    (a*4+0),(a*4+0)>=wrapnumber?1:0)); \
  nv##a = _mm512_shuffle_epi8(ad##a, _mm512_broadcast_i32x4(_mm_set_epi8(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))

#else /* !AVX512F */
#define VNVx(a)								\
	__m256i nv##a;							\
	{								\
		__m128i t0nv##a = _mm_shuffle_epi8(_mm_load_si128((const __m128i *)n), pt);incle(n); \
		__m128i t1nv##a = _mm_shuffle_epi8(_mm_load_si128((const __m128i *)n), pt);incle(n); \
		nv##a = _mm256_inserti128_si256(_mm256_undefined_si256(), t0nv##a, 0); \
		nv##a = _mm256_inserti128_si256(nv##a, t1nv##a, 1);		\
	}

#define VNVxV_NOWRAP(a)							\
  nv##a = _mm256_shuffle_epi8(_mm256_add_epi64(_mm256_broadcastsi128_si256(nv0i), \
					       _mm256_set_epi64x(a*2+1, 0, a*2, 0)), \
			      _mm256_broadcastsi128_si256(_mm_set_epi8(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))

#define VNVxV_WRAP(a)							\
  __m256i ad##a = _mm256_add_epi64(_mm256_broadcastsi128_si256(nv0i),	\
				   _mm256_set_epi64x((a*2+1),(a*2+1)>=wrapnumber?1:0, \
						     (a*2+0),(a*2+0)>=wrapnumber?1:0)); \
  nv##a = _mm256_shuffle_epi8(ad##a, _mm256_broadcastsi128_si256(_mm_set_epi8(8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7)))

#endif /* AVX512F */

#define VNVx_DEC(a)								\
  __mAESi nv##a;

/* Step 2 : define value in round one (xor with subkey #0, aka key) */
#define VTEMPx(a)                                        \
  __mAESi vtemp##a = _mmAES_xor_siAES(nv##a, rkeys[0])

/* Step 3: one round of AES */
#define VAESENCx(a)                                      \
  vtemp##a =  _mmAES_aesenc_epi128(vtemp##a, rkeys[i])

/* Step 4: last round of AES */
#define VAESENCLASTx(a)                                  \
  vtemp##a = _mmAES_aesenclast_epi128(vtemp##a, rkeys[14])

/* Step 5: store result */
#define VSTOREx(a)                                       \
  _mmAES_storeu_siAES((__mAESi*)(out+(a*VAES_WIDTH)), vtemp##a)

/* create a function of unrolling N ; the MAKEN is the unrolling
   macro, defined above. The N in MAKEN must match N, obviously.
   this does N*(VAES_WIDTH/16) blocks at once.
*/
#define FUNC(N, MAKEN)							\
  static inline void aesni_encrypt##N(unsigned char *out, unsigned int *n, const __mAESi rkeys[15]) { \
    __m128i nv0i = _mm_load_si128((const __m128i *)n);                  \
    long long nl = *(long long*)&n[8];                                  \
    MAKEN(VNVx_DEC);							\
    /* check for nonce wraparound */                                    \
    if ((nl < 0) && (nl + N*VAES_WIDTH/16) >= 0) {					\
      int wrapnumber = (int)(N - (nl+N));                               \
      MAKEN(VNVxV_WRAP);						\
      _mm_storeu_si128((__m128i*)n, _mm_add_epi64(nv0i, _mm_set_epi64x(N*(VAES_WIDTH/16),1))); \
    } else {                                                            \
      MAKEN(VNVxV_NOWRAP);						\
      _mm_storeu_si128((__m128i*)n, _mm_add_epi64(nv0i, _mm_set_epi64x(N*(VAES_WIDTH/16),0))); \
    }                                                                   \
    int i;                                                              \
    MAKEN(VTEMPx);							\
    for (i = 1 ; i < 14 ; i++) {                                        \
      MAKEN(VAESENCx);							\
    }                                                                   \
    MAKEN(VAESENCLASTx);						\
    MAKEN(VSTOREx);							\
  }

/* and now building our unrolled function is trivial */
FUNC(2, MAKE2)
FUNC(4, MAKE4)
FUNC(8, MAKE8)
#undef FUNC


int crypto_stream(
unsigned char *out,
unsigned long long outlen,
const unsigned char *n,
const unsigned char *k
)
{
  __mAESi rkeys[16];
  ALIGN16 unsigned char n2[16];
  unsigned long long i, j;
  aesni_key256_expand(k, rkeys);
  /* n2 is in byte-reversed (i.e., native little endian)
     order to make increment/testing easier */
  (*(unsigned long long*)&n2[8]) = _bswap64((*(unsigned long long*)&n[8]));
  (*(unsigned long long*)&n2[0]) = _bswap64((*(unsigned long long*)&n[0]));

#define LOOP(iter)                                       \
  int lb = iter * VAES_WIDTH;				 \
  for (i = 0 ; i < outlen ; i+= lb) {                    \
    ALIGN16 unsigned char outni[lb];                     \
    aesni_encrypt##iter(outni, (unsigned int*)n2, rkeys);	 \
    unsigned long long mj = lb;                          \
    if ((i+mj)>=outlen)                                  \
      mj = outlen-i;                                     \
    for (j = 0 ; j < mj ; j++)                           \
      out[i+j] = outni[j];                               \
  }
  
  LOOP(8);

  return 0;
}

int crypto_stream_xor(
unsigned char *out,
const unsigned char *in,
unsigned long long inlen,
const unsigned char *n,
const unsigned char *k
)
{
  __mAESi rkeys[16];
  ALIGN16 unsigned char n2[16];
  unsigned long long i, j;
  aesni_key256_expand(k, rkeys);
  /* n2 is in byte-reversed (i.e., native little endian)
     order to make increment/testing easier */
  (*(unsigned long long*)&n2[8]) = _bswap64((*(unsigned long long*)&n[8]));
  (*(unsigned long long*)&n2[0]) = _bswap64((*(unsigned long long*)&n[0]));

#define LOOPXOR(iter)					 \
  int lb = iter * VAES_WIDTH;				 \
  for (i = 0 ; i < inlen ; i+= lb) {                     \
    ALIGN16 unsigned char outni[lb];                     \
    aesni_encrypt##iter(outni, (unsigned int*)n2, rkeys);	\
    unsigned long long mj = lb;                          \
    if ((i+mj)>=inlen)                                   \
      mj = inlen-i;                                      \
    for (j = 0 ; j < mj ; j++)                           \
      out[i+j] = in[i+j] ^ outni[j];                     \
  }
  
  LOOPXOR(8);

  return 0;
}
