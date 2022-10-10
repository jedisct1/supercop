/*
 * Algorithm     : Grain128-AEADv2
 * Implementation: C/C++, 64-bit, semi-optimised
 * Endianness    : Little endian
 * Author        : Alexander Maximov
 * Year          : 2021
 */

#include "crypto_aead.h"
#include "grain128aead-v2_opt.h"
#include <memory.h>

// ------------------------------------------------------------------
// Internals
// ------------------------------------------------------------------
#define N64(byte) (*(u64*)(((u8*)grain->nfsr) + (byte)))
#define L64(byte) (*(u64*)(((u8*)grain->lfsr) + (byte)))
#define N32(byte) (*(u32*)(((u8*)grain->nfsr) + (byte)))
#define L32(byte) (*(u32*)(((u8*)grain->lfsr) + (byte)))

#ifdef __GRAIN_DEBUG_PRINTS__
#include <stdio.h>
int ctr = 0;
#endif

// Performs 32 clocks of the cipher and return 32-bit value of y
static inline u32 grain_keystream32(grain_ctx *grain)
{
#ifdef __GRAIN_DEBUG_PRINTS__
	printf("=== time %d ===\n", ctr);
	printf("A=%016llx R=%016llx S=%016llx A^R=%016llx\n", grain->A, grain->R, grain->S, grain->A ^ grain->R);
	printf("LFSR="); for (int i = 0; i < 16; i++) printf("%02x ", (int)grain->lfsr[i]); printf("\n");
	printf("NFSR="); for (int i = 0; i < 16; i++) printf("%02x ", (int)grain->nfsr[i]);printf("\n");
	ctr += 32;
#endif

#if 0 /* Legacy expressions for debug purposes */
#define st(x)  (u32)(*(u64*)(grain->lfsr + ((x)/8) ) >> ((x)%8))
#define bt(x)  (u32)(*(u64*)(grain->nfsr + ((x)/8) ) >> ((x)%8))

	u32 y = (bt(12) & st(8)) ^ (st(13) & st(20)) ^ (bt(95) & st(42)) ^ (st(60) & st(79)) ^ (bt(12) & bt(95) & st(94))
		^ st(93) ^ bt(2) ^ bt(15) ^ bt(36) ^ bt(45) ^ bt(64) ^ bt(73) ^ bt(89);
	u32 nn = st(0) ^ bt(0) ^ bt(26) ^ bt(56) ^ bt(91) ^ bt(96) ^ (bt(3) & bt(67)) ^ (bt(11) & bt(13))
		^ (bt(17) & bt(18)) ^ (bt(27) & bt(59)) ^ (bt(40) & bt(48)) ^ (bt(61) & bt(65)) ^ (bt(68) & bt(84))
		^ (bt(22) & bt(24) & bt(25)) ^ (bt(70) & bt(78) & bt(82)) ^ (bt(88) & bt(92) & bt(93) & bt(95));
	u32 ln = st(0) ^ st(7) ^ st(38) ^ st(70) ^ st(81) ^ st(96);

	L32(0) = L32(4);
	L32(4) = L32(8);
	L32(8) = L32(12);
	L32(12) = ln;

	N32(0) = N32(4);
	N32(4) = N32(8);
	N32(8) = N32(12);
	N32(12) = nn;

#else
	u64 ln0 = L64(0), nn0 = N64(0), nn1 = N64(4), nn2 = N64(8), nn2_p16 = N64(6);
	u64 nn0_2 = nn0 >> 2, nn0_1 = nn0 >> 1;

	u64 nn4 = ln0 ^ nn0 ^ N64(12) ^ (((nn0 & nn1) ^ nn2) >> 27) ^ ((nn0 & nn2) >> 3) ^ ((nn0 & nn0_2) >> 11) ^
		(((nn0 & nn0_1) ^ ((nn1 >> 12) & nn2_p16)) >> 17) ^ (N64(5) & N64(6)) ^
		((nn2_p16 & nn2) >> 20) ^ ((nn0_2 ^ nn1 ^ ((nn0 & (nn0 << 2)) & nn0_1)) >> 24) ^
		(N64(11) & (nn2 >> 28) & (nn2 >> 29) & (nn2 >> 31)) ^ (((nn2 & N64(9)) >> 6) & (nn2 >> 18));
	
	N64(0) = nn1;
	N32(8) = N32(12);
	N32(12) = (u32)nn4;

	u64 ln2 = L64(8), ln1 = L64(4);
	u64 ln2_17 = ln2 >> 17, ln0_7 = ln0 >> 7;

	L64(0) = ln1;
	L32(8) = L32(12);
	L32(12) ^= ln0 ^ ((ln1 ^ ln2) >> 6) ^ ln0_7 ^ ln2_17;

	u64 nn2_21 = nn2 >> 21;

	u32 y = (u32)(nn2 ^ nn0_2 ^ (nn1 >> 4) ^ ((nn2 ^ nn2_p16) >> 25) ^ ((ln1 >> 28) & (ln2 >> 15)) ^
		((ln2_17 ^ (nn0 & (ln0 << 4))) >> 12) ^ (((ln0 & ln0_7) ^ nn1 ^ nn0_2) >> 13) ^
		(((ln1 & nn2_21) ^ (nn0_2 & nn2_21 & (ln2 >> 20))) >> 10));
#endif

#ifdef __GRAIN_DEBUG_PRINTS__
	printf("y=%08x\n", y);
#endif
	return y;
}

static inline void grain_init(grain_ctx *grain, const u8 *key, const u8 *iv)
{
	// load key, and IV along with padding
	memcpy(grain->nfsr, key, 16);
	memcpy(grain->lfsr, iv, 12);
	L32(12) = 0x7fffffffUL;

	// 320 + 64 clocks of Initialisation & Key-Reintroduction
	for (int i = -10; i < 2; i++)
	{	u32 ks = grain_keystream32(grain);
		L32(12) ^= ks;
		N32(12) ^= ks;
		if (i < 0) continue;
		L32(12) ^= ((u32*)key)[i + 2];
		N32(12) ^= ((u32*)key)[i];
	}

	// 128 clocks of A/R initialisation
	for (int i = 0; i < 4; i++)
		((u32*)(&grain->A))[i] = grain_keystream32(grain);
}

#if GRAIN_USE_SIMD

#define _xor2(a, b)	_mm_xor_si128(a, b)
#define _and2(a, b)	_mm_and_si128(a, b)
#define shr1(e, v, n) _mm_or_si128(_mm_srli_epi64(v, n), _mm_slli_epi64(e, 64 - (n)))
#define shr8(v, n) _mm_srli_si128(v, n)
#define shl8(v, n) _mm_slli_si128(v, n)

#if GRAIN_USE_AVX512
#define _xor3(a, b, c)		_mm_ternarylogic_epi64(a, b, c, 0x96)
#define _and3(a, b, c)		_mm_ternarylogic_epi64(a, b, c, 0x80)
#define _andxor3(a, b, c)	_mm_ternarylogic_epi64(a, b, c, 0x6a)
#define _xorand3(a, b, c)	_mm_ternarylogic_epi64(a, b, c, 0x28)
#else
#define _xor3(a, b, c)		_xor2(_xor2(a, b), c)		/* 13 op */
#define _and3(a, b, c)		_and2(_and2(a, b), c)		/* 6  op */
#define _andxor3(a, b, c)	_xor2(_and2(a, b), c)		/* 12 op */
#define _xorand3(a, b, c)	_and2(_xor2(a, b), c)		/* 3  op */
#endif

// Performs 64 clocks of the cipher and return 64-bit value of y
static u64 grain_keystream64(grain_ctx *grain)
{
#ifdef __GRAIN_DEBUG_PRINTS__
	printf("=== time %d ===\n", ctr);
	printf("A=%016llx R=%016llx S=%016llx A^R=%016llx\n", grain->A, grain->R, grain->S, grain->A ^ grain->R);
	printf("LFSR="); for (int i = 0; i < 16; i++) printf("%02x ", (int)grain->lfsr[i]); printf("\n");
	printf("NFSR="); for (int i = 0; i < 16; i++) printf("%02x ", (int)grain->nfsr[i]);printf("\n");
	ctr += 64;
#endif

	__m128i s0 = _mm_loadu_si128((__m128i*)(grain->lfsr));
	__m128i b0 = _mm_loadu_si128((__m128i*)(grain->nfsr));
	__m128i se = _mm_srli_si128(s0, 8);
	__m128i be = _mm_srli_si128(b0, 8);
	__m128i b4 = shr1(be, b0, 4);
	__m128i b5 = shr1(be, b0, 5);
	__m128i b7 = shr1(be, b0, 7);
	__m128i s6 = shr1(se, s0, 6);
	__m128i s7 = shr1(se, s0, 7);
	__m128i s6_4 = shr8(s6, 4);

	u64 ss = _mm_cvtsi128_si64( _xor3(s0, s7, s6_4));

	__m128i b0_7 = shr8(b0, 7);
	__m128i b4_4 = shr8(b4, 4);

	__m128i s4 = shr1(se, s0, 4);
	__m128i s5 = shr1(se, s0, 13);
	__m128i b1 = shr1(be, b0, 1);
	__m128i b2 = shr1(be, b0, 2);

	u64 ys = _mm_cvtsi128_si64(_xor2(b2, _xor3(shr8(_xor3((_and2(b4, s0)), b7, b0_7), 1), _andxor3(s5, shr8(s4, 2), shr8(b5, 5)), b4_4)));

	b2 = shr8(b2, 2);

	__m128i b3 = shr1(be, b0, 3);
	__m128i b6 = shr1(be, b0, 6);
	__m128i b3_4 = shr8(b3, 4);
	u64 bs = _mm_cvtsi128_si64(_xor3(_andxor3(shr8(b1, 2), b2, shr8(_andxor3(b3, b5, b2), 1)),
		_andxor3(shr8(b0, 6), shr8(b0, 5), _xor3(s0, b0, b0_7)), shr8(_andxor3(b3, b3_4, _and3(shl8(b6, 1), b0, b1)), 3)));

	__m128i s1 = shr1(se, s0, 1);

	u32 sn1 = (u32)(ss ^ _mm_cvtsi128_si64(_xor3(shr8(s6, 8), shr8(s1, 10), shr8(s0, 12))));

	__m128i ts = shl8(_mm_cvtsi64_si128((u64)sn1), 12);
	s1 = _xor2(shr8(s1, 6), _mm_srli_epi64(ts, 16 + 1));
	s5 = _xor2(shr8(s5, 3), _mm_srli_epi64(ts, 5));
	s6 = _xor2(s6_4, _mm_srli_epi64(ts, 6));
	s7 = _xor2(shr8(s7, 2), _mm_slli_epi64(ts, 9));

	u32 bn1 = (u32)(bs ^ _mm_cvtsi128_si64(_xor3(_andxor3(shr8(b3, 8), b3, shr8(b0, 12)), shr8(_andxor3(_and3(b0, b4, b5), b7, b3), 11),
		shr8(_andxor3(shl8(b5, 1), b1, _andxor3(shr8(b4, 2), b4, _and3(shr8(b6, 1), b6, b2))), 8))));

	ts = shl8(b4, 6);
	__m128i tb = _mm_cvtsi64_si128((u64)bn1);
	b0 = _mm_alignr_epi8(tb, b0, 4);
	tb = shl8(tb, 12);

	b1 = _xor2(shr8(b1, 4), _mm_srli_epi64(tb, 1));
	b2 = _xor2(shr8(b2, 4), _mm_srli_epi64(tb, 18));
	b3 = _xor2(b3_4, _mm_srli_epi64(tb, 3));
	b4 = _xor2(b4_4, _mm_srli_epi64(tb, 4));
	b5 = _xor2(shr8(b5, 4), _mm_srli_epi64(tb, 5));
	b6 = _xor2(shr8(b6, 4), _mm_srli_epi64(tb, 6));
	b7 = _xor2(shr8(b7, 4), _mm_srli_epi64(tb, 7));

	u32 sn2 = (u32)(sn1 ^ (ss >> 32) ^ _mm_cvtsi128_si64(shr8(_xor2(s6, s1), 8)));

	u32 bn2 = (u32)(bn1 ^ (bs >> 32) ^ _mm_cvtsi128_si64(_xor3(_and2(b3, shr8(b3, 8)), shr8(_andxor3(_and3(b0, b4, b5), b7, b3), 11),
		shr8(_xor3(_and2(b1, shl8(b5, 1)), _and2(b4, shr8(b4, 2)), _and3(shr8(b6, 1), b6, b2)), 8))));

	__m128i s2 = shr1(se, s0, 2);
	u64 y = ys ^ _mm_cvtsi128_si64(_xor2(shr8(_xor3(_andxor3(s4, s7, s5), _and3(ts, b7, s6), b1), 7), shr8(_andxor3(shr8(b7, 2), s2, b1), 5)));

	L64(0) = L64(8);
	L32(8) = sn1;
	L32(12) = sn2;

	N64(0) = N64(8);
	N32(8) = bn1;
	N32(12) = bn2;

#ifdef __GRAIN_DEBUG_PRINTS__
	printf("y=%016llx\n", y);
#endif

	return y;
}

/* Deinterleave 128 bits of the keystream */
static inline void grain_getz(grain_ctx *grain)
{
	u8 x[16];
	*(u64*)(x + 0) = grain_keystream64(grain);
	*(u64*)(x + 8) = grain_keystream64(grain);
	__m128i T, X;
	X = _mm_loadu_si128((__m128i*)x);

#if GRAIN_USE_GF2
	X = _mm_gf2p8affine_epi64_epi8(X, _mm_set1_epi64x(0x0104104002082080ULL), 0);
#else
	T = _xorand3(_mm_srli_epi16(X, 1), X, _mm_set1_epi16(0x2222));
	X = _xor3(_mm_slli_epi16(T, 1), X, T);
	T = _xorand3(_mm_srli_epi16(X, 2), X, _mm_set1_epi16(0x0c0c));
	X = _xor3(_mm_slli_epi16(T, 2), X, T);
#endif
	T = _xorand3(_mm_srli_epi16(X, 4), X, _mm_set1_epi16(0x00f0));
	X = _xor3(_mm_slli_epi16(T, 4), X, T);
	X = _mm_shuffle_epi8(X, _mm_set_epi64x(0x0e0c0a0806040200ULL, 0x0f0d0b0907050301ULL));
	_mm_storeu_si128((__m128i*)&grain->S, X);
}

/* Using PCLMULQDQ intrinsics (SIMD), variable length = [0..8] */
static inline void grain_auth(grain_ctx *grain, u8 * data, int bytes)
{	
	if (!bytes) return;
	u64 msg;
	int bits = bytes << 3;

#ifdef __GRAIN_STACK_SAFE__
	if (bytes==8)
		msg = _byteswap_uint64(*(u64*)data);
	else
	{	msg = 0;
		for (int i = 0, j = bytes; i < bytes; i++)
			((u8*)(&msg))[--j] = data[i];
	}
#else
	msg = _byteswap_uint64(*(u64*)data) >> (64 - bits);
#endif

	// 64-bit reversing 
#if GRAIN_USE_GF2
	__m128i imsg = _mm_gf2p8affine_epi64_epi8(_mm_cvtsi64_si128(msg), _mm_cvtsi64_si128(0x8040201008040201ULL), 0);
#else
	const u64 m1 = 0x5555555555555555ULL;
	const u64 m2 = 0x3333333333333333ULL;
	const u64 m4 = 0x0F0F0F0F0F0F0F0FULL;
	msg = ((msg >> 1) & m1) | ((msg & m1) << 1);
	msg = ((msg >> 2) & m2) | ((msg & m2) << 2);
	msg = ((msg >> 4) & m4) | ((msg & m4) << 4);
	__m128i imsg = _mm_cvtsi64_si128(msg);
#endif

	u8 tmp[16];
	__m128i reg = _mm_loadu_si128((__m128i*)&grain->R);
	_mm_storeu_si128((__m128i*)tmp, _mm_clmulepi64_si128(reg, imsg, 0x00));
	reg = _mm_clmulepi64_si128(reg, imsg, 0x0f);

	if (bits == 64)
	{
		grain->R = grain->S;
		grain->S = 0;
	}
	else
	{		
		grain->R = (grain->R >> bits) | (grain->S << (64 - bits));
		grain->S >>= bits;
	}
	grain->A ^= ((*(u64*)(tmp + bytes)) << 1) ^ ((u64)tmp[bytes - 1] >> 7) ^ (((u64)_mm_cvtsi128_si64(reg)) << (65 - bits));
}

// Full block authentication for 8 bytes
static inline void grain_authF(grain_ctx *grain, u8 * data)
{
	u64 msg = _byteswap_uint64(*(u64*)data);
#if GRAIN_USE_GF2
	__m128i imsg = _mm_gf2p8affine_epi64_epi8(_mm_cvtsi64_si128(msg), _mm_cvtsi64_si128(0x8040201008040201ULL), 0);
	__m128i reg = _mm_loadu_si128((__m128i*)&grain->R);
	_mm_storeu_si128((__m128i*)&grain->R, _mm_srli_si128(reg, 8));
	__m128i x = _mm_clmulepi64_si128(reg, imsg, 0x00);
	__m128i y = _mm_clmulepi64_si128(reg, imsg, 0x0f);
	grain->A ^= _mm_cvtsi128_si64(_xor2(_mm_slli_epi64(_xor2(_mm_srli_si128(x, 8), y), 1), _mm_srli_epi64(x, 63)));
#else
	const u64 m1 = 0x5555555555555555ULL;
	const u64 m2 = 0x3333333333333333ULL;
	const u64 m4 = 0x0F0F0F0F0F0F0F0FULL;
	msg = ((msg >> 1) & m1) | ((msg & m1) << 1);
	msg = ((msg >> 2) & m2) | ((msg & m2) << 2);
	msg = ((msg >> 4) & m4) | ((msg & m4) << 4);
	__m128i imsg = _mm_cvtsi64_si128(msg << 1);
	__m128i reg = _mm_loadu_si128((__m128i*)&grain->R);
	__m128i x = _mm_clmulepi64_si128(reg, imsg, 0x00);
	__m128i y = _mm_clmulepi64_si128(reg, imsg, 0x0f);
	__m128i z = _xor2(_mm_srli_si128(x, 8), y);
	u64 b = grain->R & (((long long)msg) >> 63);
	grain->A ^= b ^ _mm_cvtsi128_si64(z);
	_mm_storeu_si128((__m128i*)&grain->R, _mm_srli_si128(reg, 8));
#endif
}



#else

/* Deinterleave 64 bits of the keystream */
static inline void grain_getz(grain_ctx *grain)
{
	u64 tmp, x;
	x = grain_keystream32(grain);
	x |= ((u64)grain_keystream32(grain)) << 32;
	tmp = (x ^ (x >> 1)) & 0x2222222222222222ULL; x ^= tmp ^ (tmp << 1); // a(Ab)Bc(Cd)De(Ef)Fg(Gh)H
	tmp = (x ^ (x >> 2)) & 0x0c0c0c0c0c0c0c0cULL; x ^= tmp ^ (tmp << 2); // ab(ABcd)CDef(EFgh)GH
	tmp = (x ^ (x >> 4)) & 0x00f000f000f000f0ULL; x ^= tmp ^ (tmp << 4); // abcd(ABCDefgh)EFGH
	tmp = (x ^ (x >> 8)) & 0x0000ff000000ff00ULL; x ^= tmp ^ (tmp << 8); // ...
	tmp = (x ^ (x >> 16)) & 0x00000000ffff0000ULL; x ^= tmp ^ (tmp << 16);
	grain->S = x >> 32;
	*(u32*)grain->z = x;
}

/* Classical bitwise solution, variable length = [0..4] */
static inline void grain_auth(grain_ctx *grain, u8 * data, int bytes)
{
	for (int t = 0; t < bytes; t++)
	{
		u8 msg = data[t];
		for (int i = 0; i < 8; ++i, grain->S >>= 1, msg >>= 1)
		{
			u64 mask = (u64)-(long long)(msg & 1);
			grain->A ^= grain->R & mask;
			grain->R = (grain->R >> 1) | (grain->S << 63);
		}
	}
}

// Full block authentication for 4 bytes
static inline void grain_authF(grain_ctx *grain, u8 * data)
{
	grain_auth(grain, data, 4);
}

#endif


template<int to_decrypt>
static inline int grain_aead_encdec(
	unsigned char *c, unsigned long long *clen,
	const unsigned char *m, unsigned long long mlen,
	const unsigned char *ad, unsigned long long adlen,
	const unsigned char *iv,
	const unsigned char *k)
{
	if (to_decrypt)
	{
		if (mlen < 8) return -1;
		mlen -= 8;
		
	}
	grain_ctx grain;
	grain_init(&grain, k, iv);

	// DER encoding of the adlen
	u8 der[9];
	int der_len;
	*(u64*)(der + 1) = adlen;

	der[0] = 0x80;
	for (der_len = 8; !der[der_len]; --der_len);
	if ((der_len <= 1) && (der[1] < 128))
	{
		der[0] = der[1];
		der_len = 0;
	}
	else
		der[0] |= der_len;

	++der_len;

	// Authenticate ADlen
	grain_getz(&grain);

	long long i;
	for (i = 0; i <= (der_len - GRAIN_Z_BLOCK); i += GRAIN_Z_BLOCK)
	{
		grain_authF(&grain, der + i);
		grain_getz(&grain);
	}

	grain_auth(&grain, der + i, der_len - i);

	// Authenticate AD
	long long rem = GRAIN_Z_BLOCK - (der_len % GRAIN_Z_BLOCK);

	if ((long long)adlen < rem)
	{
		grain_auth(&grain, (u8*)ad, (int)adlen);
		rem -= (long long)adlen;
	}
	else
	{
		grain_auth(&grain, (u8*)ad, (int)rem);
		grain_getz(&grain);

		for (i = rem; i <= ((long long)adlen - GRAIN_Z_BLOCK); i += GRAIN_Z_BLOCK)
		{
			grain_authF(&grain, (u8*)ad + i);
			grain_getz(&grain);
		}

		grain_auth(&grain, (u8*)ad + i, (int)adlen - (int)i);
		rem = GRAIN_Z_BLOCK - ((long long)adlen - i);
	}

	// Auth and Encrypt/Decrypt
	i = (long long)mlen < rem ? (long long)mlen : rem;

	if (to_decrypt)
	{
		for (int j = 0; j < i; j++)
			c[j] = m[j] ^ grain.z[GRAIN_Z_BLOCK - rem + j];
		grain_auth(&grain, (u8*)c, i);

		grain_getz(&grain);
		for (; i <= ((long long)mlen - GRAIN_Z_BLOCK); i += GRAIN_Z_BLOCK)
		{
			*(GRAIN_Z_TYPE*)(c + i) = *(GRAIN_Z_TYPE*)(m + i) ^ *(GRAIN_Z_TYPE*)(grain.z);
			grain_authF(&grain, (u8*)c + i);
			grain_getz(&grain);
		}

		for (rem = 0; i < (long long)mlen; i++, rem++)
			c[i] = m[i] ^ grain.z[rem];
		grain_auth(&grain, (u8*)c + i - rem, (long long)mlen - i + rem);

		*clen = i;
		// verify MAC
		if (*(u64*)(m + mlen) ^ grain.A ^ grain.R)
			return -1;
	}
	else
	{
		grain_auth(&grain, (u8*)m, i);
		for (int j = 0; j < i; j++)
			c[j] = m[j] ^ grain.z[GRAIN_Z_BLOCK - rem + j];

		grain_getz(&grain);

		for (; i <= ((long long)mlen - GRAIN_Z_BLOCK); i += GRAIN_Z_BLOCK)
		{
			grain_authF(&grain, (u8*)m + i);
			*(GRAIN_Z_TYPE*)(c + i) = *(GRAIN_Z_TYPE*)(m + i) ^ *(GRAIN_Z_TYPE*)(grain.z);
			grain_getz(&grain);
		}

		grain_auth(&grain, (u8*)m + i, (long long)mlen - i);
		for (rem = 0; i < (long long)mlen; i++, rem++)
			c[i] = m[i] ^ grain.z[rem];

		// append MAC to ciphertext
		*(u64*)(c + mlen) = grain.A ^ grain.R;
		*clen = i + 8;
	}

	return 0;
}



// ------------------------------------------------------------------
// NIST API for Grain-128AEADv2
// ------------------------------------------------------------------
int crypto_aead_encrypt(
	unsigned char *c, unsigned long long *clen,
	const unsigned char *m, unsigned long long mlen,
	const unsigned char *ad, unsigned long long adlen,
	const unsigned char *nsec,
	const unsigned char *npub,
	const unsigned char *k)
{
	return grain_aead_encdec<0>(c, clen, m, mlen, ad, adlen, npub, k);
}



int crypto_aead_decrypt(
	unsigned char *m, unsigned long long *mlen,
	unsigned char *nsec,
	const unsigned char *c, unsigned long long clen,
	const unsigned char *ad, unsigned long long adlen,
	const unsigned char *npub,
	const unsigned char *k
)
{
	return grain_aead_encdec<1>(m, mlen, c, clen, ad, adlen, npub, k);
}
