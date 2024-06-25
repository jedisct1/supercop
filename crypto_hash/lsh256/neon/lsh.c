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

#include "lsh_def.h"
#include "lsh_local.h"
#include "lsh.h"

#include <stddef.h>
#include <string.h>

static const LSH_ALIGNED_(32) lsh_u32 IV224[16] = {
	0x068608D3, 0x62D8F7A7, 0xD76652AB, 0x4C600A43, 0xBDC40AA8, 0x1ECA0B68, 0xDA1A89BE, 0x3147D354,
	0x707EB4F9, 0xF65B3862, 0x6B0B2ABE, 0x56B8EC0A, 0xCF237286, 0xEE0D1727, 0x33636595, 0x8BB8D05F,
};

static const LSH_ALIGNED_(32) lsh_u32 IV256[16] = {
	0x46a10f1f, 0xfddce486, 0xb41443a8, 0x198e6b9d, 0x3304388d, 0xb0f5a3c7, 0xb36061c4, 0x7adbd553,
	0x105d5378, 0x2f74de54, 0x5c2f2d95, 0xf2553fbe, 0x8051357a, 0x138668c8, 0x47aa4484, 0xe01afb41
};

static const LSH_ALIGNED_(32) lsh_u32 STEP256[208] = {
	0x917caf90, 0x6c1b10a2, 0x6f352943, 0xcf778243, 0x2ceb7472, 0x29e96ff2, 0x8a9ba428, 0x2eeb2642,
	0x0e2c4021, 0x872bb30e, 0xa45e6cb2, 0x46f9c612, 0x185fe69e, 0x1359621b, 0x263fccb2, 0x1a116870,
	0x3a6c612f, 0xb2dec195, 0x02cb1f56, 0x40bfd858, 0x784684b6, 0x6cbb7d2e, 0x660c7ed8, 0x2b79d88a,
	0xa6cd9069, 0x91a05747, 0xcdea7558, 0x00983098, 0xbecb3b2e, 0x2838ab9a, 0x728b573e, 0xa55262b5,
	0x745dfa0f, 0x31f79ed8, 0xb85fce25, 0x98c8c898, 0x8a0669ec, 0x60e445c2, 0xfde295b0, 0xf7b5185a,
	0xd2580983, 0x29967709, 0x182df3dd, 0x61916130, 0x90705676, 0x452a0822, 0xe07846ad, 0xaccd7351,
	0x2a618d55, 0xc00d8032, 0x4621d0f5, 0xf2f29191, 0x00c6cd06, 0x6f322a67, 0x58bef48d, 0x7a40c4fd,
	0x8beee27f, 0xcd8db2f2, 0x67f2c63b, 0xe5842383, 0xc793d306, 0xa15c91d6, 0x17b381e5, 0xbb05c277,
	0x7ad1620a, 0x5b40a5bf, 0x5ab901a2, 0x69a7a768, 0x5b66d9cd, 0xfdee6877, 0xcb3566fc, 0xc0c83a32,
	0x4c336c84, 0x9be6651a, 0x13baa3fc, 0x114f0fd1, 0xc240a728, 0xec56e074, 0x009c63c7, 0x89026cf2,
	0x7f9ff0d0, 0x824b7fb5, 0xce5ea00f, 0x605ee0e2, 0x02e7cfea, 0x43375560, 0x9d002ac7, 0x8b6f5f7b,
	0x1f90c14f, 0xcdcb3537, 0x2cfeafdd, 0xbf3fc342, 0xeab7b9ec, 0x7a8cb5a3, 0x9d2af264, 0xfacedb06,
	0xb052106e, 0x99006d04, 0x2bae8d09, 0xff030601, 0xa271a6d6, 0x0742591d, 0xc81d5701, 0xc9a9e200,
	0x02627f1e, 0x996d719d, 0xda3b9634, 0x02090800, 0x14187d78, 0x499b7624, 0xe57458c9, 0x738be2c9,
	0x64e19d20, 0x06df0f36, 0x15d1cb0e, 0x0b110802, 0x2c95f58c, 0xe5119a6d, 0x59cd22ae, 0xff6eac3c,
	0x467ebd84, 0xe5ee453c, 0xe79cd923, 0x1c190a0d, 0xc28b81b8, 0xf6ac0852, 0x26efd107, 0x6e1ae93b,
	0xc53c41ca, 0xd4338221, 0x8475fd0a, 0x35231729, 0x4e0d3a7a, 0xa2b45b48, 0x16c0d82d, 0x890424a9,
	0x017e0c8f, 0x07b5a3f5, 0xfa73078e, 0x583a405e, 0x5b47b4c8, 0x570fa3ea, 0xd7990543, 0x8d28ce32,
	0x7f8a9b90, 0xbd5998fc, 0x6d7a9688, 0x927a9eb6, 0xa2fc7d23, 0x66b38e41, 0x709e491a, 0xb5f700bf,
	0x0a262c0f, 0x16f295b9, 0xe8111ef5, 0x0d195548, 0x9f79a0c5, 0x1a41cfa7, 0x0ee7638a, 0xacf7c074,
	0x30523b19, 0x09884ecf, 0xf93014dd, 0x266e9d55, 0x191a6664, 0x5c1176c1, 0xf64aed98, 0xa4b83520,
	0x828d5449, 0x91d71dd8, 0x2944f2d6, 0x950bf27b, 0x3380ca7d, 0x6d88381d, 0x4138868e, 0x5ced55c4,
	0x0fe19dcb, 0x68f4f669, 0x6e37c8ff, 0xa0fe6e10, 0xb44b47b0, 0xf5c0558a, 0x79bf14cf, 0x4a431a20,
	0xf17f68da, 0x5deb5fd1, 0xa600c86d, 0x9f6c7eb0, 0xff92f864, 0xb615e07f, 0x38d3e448, 0x8d5d3a6a,
	0x70e843cb, 0x494b312e, 0xa6c93613, 0x0beb2f4f, 0x928b5d63, 0xcbf66035, 0x0cb82c80, 0xea97a4f7,
	0x592c0f3b, 0x947c5f77, 0x6fff49b9, 0xf71a7e5a, 0x1de8c0f5, 0xc2569600, 0xc4e4ac8c, 0x823c9ce1
};
// "INDENT-ON"

static const lsh_u32 BLK_LEN_BYTE = 128;
static const lsh_u32 ALPHA_EVEN = 29;
static const lsh_u32 ALPHA_ODD = 5;
static const lsh_u32 BETA_EVEN = 1;
static const lsh_u32 BETA_ODD = 17;

static const LSH_ALIGNED_(16) lsh_s32x4 GAMMA[2] ={ {0, 8, 16, 24}, {24, 16, 8, 0} };
static const LSH_ALIGNED_(16) lsh_s32x4 GAMMA_INV[2] ={ {-32, -24, -16, -8}, {-8, -16, -24, -32} };

typedef struct LSH_ALIGNED_(32) {
	LSH_ALIGNED_(16) lsh_u32 algtype;
	LSH_ALIGNED_(16) lsh_u32 rbits; // remaining bits
	LSH_ALIGNED_(32) lsh_u32x4 cv[4];
	LSH_ALIGNED_(32) lsh_u8 block[128];
} LSH256Neon_Context;

static INLINE void add(lsh_u32x4* lhs, const lsh_u32x4* rhs) {
	lhs[0] += rhs[0];
	lhs[1] += rhs[1];
}

static INLINE void msg_add(LSH256Neon_Context* ctx, lsh_u32x4* msg) {
	lsh_uint idx;
	for (idx = 0; idx < 4; ++idx) {
		ctx->cv[idx] ^= msg[idx];
	}
}

/**
 * {0, 1, 2, 3} -> {3, 2, 0, 1}
 */
static INLINE lsh_u32x4 msg_permutation(lsh_u32x4* value) {
	lsh_u32x2 high = vget_high_u32(*value);
	lsh_u32x2 low = vget_low_u32(*value);
	high = vrev64_u32(high);
	return vcombine_u32(high, low);
}

static INLINE void msg_expansion(lsh_u32x4* lhs, const lsh_u32x4* rhs) {
	lhs[0] = msg_permutation(&lhs[0]);
	lhs[1] = vextq_u32(lhs[1], lhs[1], 3); // {0, 1, 2, 3} -> {3, 0, 1, 2}
	lhs[2] = msg_permutation(&lhs[2]);
	lhs[3] = vextq_u32(lhs[3], lhs[3], 3);

	add(lhs, rhs);
	add(lhs+2, rhs+2);
}

/**
 * {0, 1, 2, 3} -> {2, 0, 1, 3}
 */
static INLINE void word_permutation1(lsh_u32x4* value) {
	lsh_u32x2 high = vget_high_u32(*value);
	lsh_u32x2 low = vget_low_u32(*value);
	high = vrev64_u32(high);
	*value = vcombine_u32(low, high);
	*value = vextq_u32(*value, *value, 3);
}

/**
 * {0, 1, 2, 3} -> {0, 3, 2, 1}
 */
static INLINE void word_permutation2(lsh_u32x4* value) {
	*value = vextq_u32(*value, *value, 3);
	*value = vrev64q_u32(*value);
}

static INLINE void word_permutation(LSH256Neon_Context* ctx) {
	lsh_u32x4 tmp;

	word_permutation1(&ctx->cv[0]);
	word_permutation1(&ctx->cv[1]);
	word_permutation2(&ctx->cv[2]);
	word_permutation2(&ctx->cv[3]);

	tmp = ctx->cv[0];
	ctx->cv[0] = ctx->cv[1];
	ctx->cv[1] = ctx->cv[3];
	ctx->cv[3] = ctx->cv[2];
	ctx->cv[2] = tmp;
}

static INLINE void inner_step_even_alpha(lsh_u32x4* lhs, const lsh_u32x4* rhs) {
	add(lhs, rhs);
	
	lhs[0] = vsriq_n_u32(vshlq_n_u32(lhs[0], 29), lhs[0], 3);
	lhs[1] = vsriq_n_u32(vshlq_n_u32(lhs[1], 29), lhs[1], 3);
}

static INLINE void inner_step_even_beta(lsh_u32x4* lhs, const lsh_u32x4* rhs) {
	add(lhs, rhs);

	lhs[0] = vsriq_n_u32(vshlq_n_u32(lhs[0], 1), lhs[0], 31);
	lhs[1] = vsriq_n_u32(vshlq_n_u32(lhs[1], 1), lhs[1], 31);
}

static INLINE void inner_step_odd_alpha(lsh_u32x4* lhs, const lsh_u32x4* rhs) {
	add(lhs, rhs);

	lhs[0] = vsriq_n_u32(vshlq_n_u32(lhs[0], 5), lhs[0], 27);
	lhs[1] = vsriq_n_u32(vshlq_n_u32(lhs[1], 5), lhs[1], 27);
}

static INLINE void inner_step_odd_beta(lsh_u32x4* lhs, const lsh_u32x4* rhs) {
	add(lhs, rhs);

	lhs[0] = vsriq_n_u32(vshlq_n_u32(lhs[0], 17), lhs[0], 15);
	lhs[1] = vsriq_n_u32(vshlq_n_u32(lhs[1], 17), lhs[1], 15);
}

static INLINE void load_sc(lsh_u32x4* sc, const lsh_u32* psc) {
	sc[0] = vld1q_u32(psc);
	sc[1] = vld1q_u32(psc + 4);
}

static INLINE void step_even(LSH256Neon_Context* ctx, lsh_u32x4* msg, lsh_u32x4* sc) {
	// msg add
	msg_add(ctx, msg);

	// mix: rotate alpha
	inner_step_even_alpha(ctx->cv, ctx->cv + 2);

	// mix: xor step constant
	ctx->cv[0] ^= sc[0];
	ctx->cv[1] ^= sc[1];

	// mix: rotate beta
	inner_step_even_beta(ctx->cv + 2, ctx->cv);

	// mix: add to left
	//ctx->cv[0] += ctx->cv[2];
	//ctx->cv[1] += ctx->cv[3];
	add(ctx->cv, ctx->cv+2);

	// mix: rotate gamma
	ctx->cv[2] = vshlq_u32(ctx->cv[2], GAMMA[0]) ^ vshlq_u32(ctx->cv[2], GAMMA_INV[0]);
	ctx->cv[3] = vshlq_u32(ctx->cv[3], GAMMA[1]) ^ vshlq_u32(ctx->cv[3], GAMMA_INV[1]);

	// word permutation
	word_permutation(ctx);
}

static INLINE void step_odd(LSH256Neon_Context* ctx, lsh_u32x4* msg, lsh_u32x4* sc) {
	// msg add
	msg_add(ctx, msg);

	// mix: rotate alpha
	inner_step_odd_alpha(ctx->cv, ctx->cv + 2);

	// mix: xor step constant
	ctx->cv[0] ^= sc[0];
	ctx->cv[1] ^= sc[1];

	// mix: rotate beta
	inner_step_odd_beta(ctx->cv + 2, ctx->cv);

	// mix: add to left
	//ctx->cv[0] += ctx->cv[2];
	//ctx->cv[1] += ctx->cv[3];
	add(ctx->cv, ctx->cv+2);

	// mix: rotate gamma
	ctx->cv[2] = vshlq_u32(ctx->cv[2], GAMMA[0]) ^ vshlq_u32(ctx->cv[2], GAMMA_INV[0]);
	ctx->cv[3] = vshlq_u32(ctx->cv[3], GAMMA[1]) ^ vshlq_u32(ctx->cv[3], GAMMA_INV[1]);

	// word permutation
	word_permutation(ctx);
}

static INLINE void compress(LSH256Neon_Context* ctx, const lsh_u8* block) {

	lsh_uint idx;
	lsh_u32* pb = (lsh_u32*) block;
	const lsh_u32* pstep = STEP256;

	LSH_ALIGNED_(32) lsh_u32x4 sc[2];
	LSH_ALIGNED_(32) lsh_u32x4 msg[8];

	//msg load
	for (idx = 0; idx < 8; ++idx, pb += 4) {
		msg[idx] = vld1q_u32(pb);
	}

	// step functions
	for (idx = 0; idx < 13; ++idx, pstep += 16) {
		//sc[0] = vld1q_u32(pstep);
		//sc[1] = vld1q_u32(pstep + 4);
		load_sc(sc, pstep);
		step_even(ctx, msg, sc); // msg add & Mix & word permutation
		msg_expansion(msg, msg + 4);

		//sc[0] = vld1q_u32(pstep + 8);
		//sc[1] = vld1q_u32(pstep + 12);
		load_sc(sc, pstep + 8);
		step_odd(ctx, msg + 4, sc); // msg add & Mix & word permutation
		msg_expansion(msg + 4, msg);
	}

	// msg add
	msg_add(ctx, msg);
}

static INLINE void load_iv(LSH256Neon_Context* ctx, const lsh_u32* iv) {
	ctx->cv[0] = vld1q_u32(iv);
	ctx->cv[1] = vld1q_u32(iv + 4);
	ctx->cv[2] = vld1q_u32(iv + 8);
	ctx->cv[3] = vld1q_u32(iv + 12);
}

static INLINE void generate_iv(LSH256Neon_Context* ctx, const lsh_u32 hashlenbit) {
	lsh_u32 block[32] = {'\0'};

	lsh_u32 cv[4] = {32, hashlenbit, 0, 0};
	memset(ctx->cv, 0, 4 * sizeof(lsh_u32x4));
	ctx->cv[0] = vld1q_u32(cv);

	compress(ctx, (lsh_u8*) block);
}

lsh_err lsh256_init(struct LSH256_Context* ctx, const lsh_type algtype) {
	LSH256Neon_Context* state = (LSH256Neon_Context*) ctx;
	state->algtype = algtype;
	state->rbits = 0;

	switch(algtype) {
		case LSH_TYPE_256_224:
			load_iv(state, IV224);
			break;

		case LSH_TYPE_256_256:
			load_iv(state, IV256);
			break;

		default:
			generate_iv(state, LSH_GET_HASHBIT(algtype));
			break;
	}
	generate_iv(state, LSH_GET_HASHBIT(algtype));

	return LSH_SUCCESS;
}

lsh_err lsh256_update(struct LSH256_Context* ctx, const lsh_u8* data, size_t databitlen) {

	LSH256Neon_Context* ctx_neon = (LSH256Neon_Context*) ctx;

	size_t len_bytes = databitlen >> 3;
	size_t len_bits = databitlen & 0x7;

	size_t rbytes;
	size_t rbits;

	if (databitlen == 0) {
		return LSH_SUCCESS;
	}

	if (ctx == NULL || data == NULL) {
		return LSH_ERR_NULL_PTR;
	}

	if (ctx->algtype == 0 || LSH_GET_HASHBYTE(ctx->algtype) > LSH256_HASH_VAL_MAX_BYTE_LEN){
		return LSH_ERR_INVALID_STATE;
	}
	
	rbytes = ctx_neon->rbits >> 3;
    rbits = ctx_neon->rbits & 0x7;
	if (rbits > 0) {
		return LSH_ERR_INVALID_DATABITLEN;
	}
	
	if (len_bytes + rbytes < BLK_LEN_BYTE) {
		memcpy(ctx_neon->block + rbytes, data, len_bytes);
		ctx_neon->rbits += databitlen;
		rbytes += len_bytes;
		if (len_bits) {
			ctx_neon->block[rbytes] = data[len_bytes] & ((0xff >> len_bits) ^ 0xff);
		}

		return LSH_SUCCESS;
	}

	if (rbytes > 0) {
		size_t more_byte = BLK_LEN_BYTE - rbytes;
		memcpy(ctx_neon->block + rbytes, data, more_byte);

		compress(ctx_neon, ctx_neon->block);
		data += more_byte;
		len_bytes -= more_byte;

		rbytes = 0;
		ctx_neon->rbits = 0;
	}

	while (len_bytes >= BLK_LEN_BYTE) {
		compress(ctx_neon, data);
		data += BLK_LEN_BYTE;
		len_bytes -= BLK_LEN_BYTE;
	}

	if (len_bytes > 0) {
		memcpy(ctx_neon->block, data, len_bytes);
		ctx_neon->rbits = len_bytes << 3;
	}

	if (len_bits) {
		ctx_neon->block[len_bytes] = data[len_bytes] & ((0xff >> len_bits) ^ 0xff);
		ctx_neon->rbits += len_bits;
	}

	return LSH_SUCCESS;
}

lsh_err lsh256_final(struct LSH256_Context* ctx, lsh_u8* hashval) {

	lsh_u8 buffer[LSH256_HASH_VAL_MAX_BYTE_LEN] = { 0x00, };
	lsh_u32* out = (lsh_u32*) buffer;
	LSH256Neon_Context* ctx_neon = (LSH256Neon_Context*) ctx;
	lsh_uint outlenbytes = LSH_GET_HASHBYTE(ctx->algtype);
	lsh_uint routbits = LSH_GET_SMALL_HASHBIT(ctx->algtype);

	size_t rbytes;
	size_t rbits;

	if (ctx == NULL || hashval == NULL) {
		return LSH_ERR_NULL_PTR;
	}
	
	if (ctx->algtype == 0 || LSH_GET_HASHBYTE(ctx->algtype) > LSH256_HASH_VAL_MAX_BYTE_LEN){
		return LSH_ERR_INVALID_STATE;
	}

	rbytes = ctx_neon->rbits >> 3;
	rbits = ctx_neon->rbits & 0x7;	
	if (rbits) {
		ctx_neon->block[rbytes] |= (0x1 << (7 - rbits));
	} else {
		ctx_neon->block[rbytes] = 0x80;
	}

	int pos = rbytes + 1;
	if (pos < BLK_LEN_BYTE) {
		memset(ctx_neon->block + pos, 0, BLK_LEN_BYTE - pos);
	}

	compress(ctx_neon, ctx_neon->block);

	// finalize
	ctx_neon->cv[0] = veorq_u32(ctx_neon->cv[0], ctx_neon->cv[2]);
	ctx_neon->cv[1] = veorq_u32(ctx_neon->cv[1], ctx_neon->cv[3]);

	// copy to output
	vst1q_u32(out, ctx_neon->cv[0]);
	vst1q_u32(out + 4, ctx_neon->cv[1]);
	
	memcpy(hashval, buffer, sizeof(lsh_u8) * outlenbytes);
	if (routbits > 0) {
		hashval[outlenbytes-1] &= (((lsh_u8)0xff) << routbits);
	}

	return LSH_SUCCESS;
}

lsh_err lsh256_digest(const lsh_type algtype, const lsh_u8* data, const size_t databitlen, lsh_u8* hashval) {

	lsh_err result;
	struct LSH256_Context ctx;

	result = lsh256_init(&ctx, algtype);
	if (result != LSH_SUCCESS) {
		return result;
	}

	result = lsh256_update(&ctx, data, databitlen);
	if (result != LSH_SUCCESS) {
		return result;
	}

	return lsh256_final(&ctx, hashval);
}
