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
#include "lsh-impl.h"

#include <stdio.h>
#include <string.h>

static const LSH_ALIGNED_(32) lsh_u64 IV224[32] = {
	0x0C401E9FE8813A55ULL, 0x4A5F446268FD3D35ULL, 0xFF13E452334F612AULL, 0xF8227661037E354AULL,
	0xA5F223723C9CA29DULL, 0x95D965A11AED3979ULL, 0x01E23835B9AB02CCULL, 0x52D49CBAD5B30616ULL,
	0x9E5C2027773F4ED3ULL, 0x66A5C8801925B701ULL, 0x22BBC85B4C6779D9ULL, 0xC13171A42C559C23ULL,
	0x31E2B67D25BE3813ULL, 0xD522C4DEED8E4D83ULL, 0xA79F5509B43FBAFEULL, 0xE00D2CD88B4B6C6AULL,
};

static const LSH_ALIGNED_(32) lsh_u64 IV256[32] = {
	0x6DC57C33DF989423ULL, 0xD8EA7F6E8342C199ULL, 0x76DF8356F8603AC4ULL, 0x40F1B44DE838223AULL,
	0x39FFE7CFC31484CDULL, 0x39C4326CC5281548ULL, 0x8A2FF85A346045D8ULL, 0xFF202AA46DBDD61EULL,
	0xCF785B3CD5FCDB8BULL, 0x1F0323B64A8150BFULL, 0xFF75D972F29EA355ULL, 0x2E567F30BF1CA9E1ULL,
	0xB596875BF8FF6DBAULL, 0xFCCA39B089EF4615ULL, 0xECFF4017D020B4B6ULL, 0x7E77384C772ED802ULL,
};

static const LSH_ALIGNED_(32) lsh_u64 IV384[32] = {
	0x53156A66292808F6ULL, 0xB2C4F362B204C2BCULL, 0xB84B7213BFA05C4EULL, 0x976CEB7C1B299F73ULL,
	0xDF0CC63C0570AE97ULL, 0xDA4441BAA486CE3FULL, 0x6559F5D9B5F2ACC2ULL, 0x22DACF19B4B52A16ULL,
	0xBBCDACEFDE80953AULL, 0xC9891A2879725B3EULL, 0x7C9FE6330237E440ULL, 0xA30BA550553F7431ULL,
	0xBB08043FB34E3E30ULL, 0xA0DEC48D54618EADULL, 0x150317267464BC57ULL, 0x32D1501FDE63DC93ULL
};

static const LSH_ALIGNED_(32) lsh_u64 IV512[32] = {
	0xadd50f3c7f07094eULL, 0xe3f3cee8f9418a4fULL, 0xb527ecde5b3d0ae9ULL, 0x2ef6dec68076f501ULL,
	0x8cb994cae5aca216ULL, 0xfbb9eae4bba48cc7ULL, 0x650a526174725feaULL, 0x1f9a61a73f8d8085ULL,
	0xb6607378173b539bULL, 0x1bc99853b0c0b9edULL, 0xdf727fc19b182d47ULL, 0xdbef360cf893a457ULL,
	0x4981f5e570147e80ULL, 0xd00c4490ca7d3e30ULL, 0x5d73940c0e4ae1ecULL, 0x894085e2edb2d819ULL
};

static const LSH_ALIGNED_(32) lsh_u64 STEP512[224] = {
	0x97884283c938982aULL, 0xba1fca93533e2355ULL, 0xc519a2e87aeb1c03ULL, 0x9a0fc95462af17b1ULL,
	0xfc3dda8ab019a82bULL, 0x02825d079a895407ULL, 0x79f2d0a7ee06a6f7ULL, 0xd76d15eed9fdf5feULL,
	0x1fcac64d01d0c2c1ULL, 0xd9ea5de69161790fULL, 0xdebc8b6366071fc8ULL, 0xa9d91db711c6c94bULL,
	0x3a18653ac9c1d427ULL, 0x84df64a223dd5b09ULL, 0x6cc37895f4ad9e70ULL, 0x448304c8d7f3f4d5ULL,
	0xea91134ed29383e0ULL, 0xc4484477f2da88e8ULL, 0x9b47eec96d26e8a6ULL, 0x82f6d4c8d89014f4ULL,
	0x527da0048b95fb61ULL, 0x644406c60138648dULL, 0x303c0e8aa24c0edcULL, 0xc787cda0cbe8ca19ULL,
	0x7ba46221661764caULL, 0x0c8cbc6acd6371acULL, 0xe336b836940f8f41ULL, 0x79cb9da168a50976ULL,
	0xd01da49021915cb3ULL, 0xa84accc7399cf1f1ULL, 0x6c4a992cee5aeb0cULL, 0x4f556e6cb4b2e3e0ULL,
	0x200683877d7c2f45ULL, 0x9949273830d51db8ULL, 0x19eeeecaa39ed124ULL, 0x45693f0a0dae7fefULL,
	0xedc234b1b2ee1083ULL, 0xf3179400d68ee399ULL, 0xb6e3c61b4945f778ULL, 0xa4c3db216796c42fULL,
	0x268a0b04f9ab7465ULL, 0xe2705f6905f2d651ULL, 0x08ddb96e426ff53dULL, 0xaea84917bc2e6f34ULL,
	0xaff6e664a0fe9470ULL, 0x0aab94d765727d8cULL, 0x9aa9e1648f3d702eULL, 0x689efc88fe5af3d3ULL,
	0xb0950ffea51fd98bULL, 0x52cfc86ef8c92833ULL, 0xe69727b0b2653245ULL, 0x56f160d3ea9da3e2ULL,
	0xa6dd4b059f93051fULL, 0xb6406c3cd7f00996ULL, 0x448b45f3ccad9ec8ULL, 0x079b8587594ec73bULL,
	0x45a50ea3c4f9653bULL, 0x22983767c1f15b85ULL, 0x7dbed8631797782bULL, 0x485234be88418638ULL,
	0x842850a5329824c5ULL, 0xf6aca914c7f9a04cULL, 0xcfd139c07a4c670cULL, 0xa3210ce0a8160242ULL,
	0xeab3b268be5ea080ULL, 0xbacf9f29b34ce0a7ULL, 0x3c973b7aaf0fa3a8ULL, 0x9a86f346c9c7be80ULL,
	0xac78f5d7cabcea49ULL, 0xa355bddcc199ed42ULL, 0xa10afa3ac6b373dbULL, 0xc42ded88be1844e5ULL,
	0x9e661b271cff216aULL, 0x8a6ec8dd002d8861ULL, 0xd3d2b629beb34be4ULL, 0x217a3a1091863f1aULL,
	0x256ecda287a733f5ULL, 0xf9139a9e5b872fe5ULL, 0xac0535017a274f7cULL, 0xf21b7646d65d2aa9ULL,
	0x048142441c208c08ULL, 0xf937a5dd2db5e9ebULL, 0xa688dfe871ff30b7ULL, 0x9bb44aa217c5593bULL,
	0x943c702a2edb291aULL, 0x0cae38f9e2b715deULL, 0xb13a367ba176cc28ULL, 0x0d91bd1d3387d49bULL,
	0x85c386603cac940cULL, 0x30dd830ae39fd5e4ULL, 0x2f68c85a712fe85dULL, 0x4ffeecb9dd1e94d6ULL,
	0xd0ac9a590a0443aeULL, 0xbae732dc99ccf3eaULL, 0xeb70b21d1842f4d9ULL, 0x9f4eda50bb5c6fa8ULL,
	0x4949e69ce940a091ULL, 0x0e608dee8375ba14ULL, 0x983122cba118458cULL, 0x4eeba696fbb36b25ULL,
	0x7d46f3630e47f27eULL, 0xa21a0f7666c0dea4ULL, 0x5c22cf355b37cec4ULL, 0xee292b0c17cc1847ULL,
	0x9330838629e131daULL, 0x6eee7c71f92fce22ULL, 0xc953ee6cb95dd224ULL, 0x3a923d92af1e9073ULL,
	0xc43a5671563a70fbULL, 0xbc2985dd279f8346ULL, 0x7ef2049093069320ULL, 0x17543723e3e46035ULL,
	0xc3b409b00b130c6dULL, 0x5d6aee6b28fdf090ULL, 0x1d425b26172ff6edULL, 0xcccfd041cdaf03adULL,
	0xfe90c7c790ab6cbfULL, 0xe5af6304c722ca02ULL, 0x70f695239999b39eULL, 0x6b8b5b07c844954cULL,
	0x77bdb9bb1e1f7a30ULL, 0xc859599426ee80edULL, 0x5f9d813d4726e40aULL, 0x9ca0120f7cb2b179ULL,
	0x8f588f583c182cbdULL, 0x951267cbe9eccce7ULL, 0x678bb8bd334d520eULL, 0xf6e662d00cd9e1b7ULL,
	0x357774d93d99aaa7ULL, 0x21b2edbb156f6eb5ULL, 0xfd1ebe846e0aee69ULL, 0x3cb2218c2f642b15ULL,
	0xe7e7e7945444ea4cULL, 0xa77a33b5d6b9b47cULL, 0xf34475f0809f6075ULL, 0xdd4932dce6bb99adULL,
	0xacec4e16d74451dcULL, 0xd4a0a8d084de23d6ULL, 0x1bdd42f278f95866ULL, 0xeed3adbb938f4051ULL,
	0xcfcf7be8992f3733ULL, 0x21ade98c906e3123ULL, 0x37ba66711fffd668ULL, 0x267c0fc3a255478aULL,
	0x993a64ee1b962e88ULL, 0x754979556301faaaULL, 0xf920356b7251be81ULL, 0xc281694f22cf923fULL,
	0x9f4b6481c8666b02ULL, 0xcf97761cfe9f5444ULL, 0xf220d7911fd63e9fULL, 0xa28bd365f79cd1b0ULL,
	0xd39f5309b1c4b721ULL, 0xbec2ceb864fca51fULL, 0x1955a0ddc410407aULL, 0x43eab871f261d201ULL,
	0xeaafe64a2ed16da1ULL, 0x670d931b9df39913ULL, 0x12f868b0f614de91ULL, 0x2e5f395d946e8252ULL,
	0x72f25cbb767bd8f4ULL, 0x8191871d61a1c4ddULL, 0x6ef67ea1d450ba93ULL, 0x2ea32a645433d344ULL,
	0x9a963079003f0f8bULL, 0x74a0aeb9918cac7aULL, 0x0b6119a70af36fa3ULL, 0x8d9896f202f0d480ULL,
	0x654f1831f254cd66ULL, 0x1318a47f0366a25eULL, 0x65752076250b4e01ULL, 0xd1cd8eb888071772ULL,
	0x30c6a9793f4e9b25ULL, 0x154f684b1e3926eeULL, 0x6c7ac0b1fe6312aeULL, 0x262f88f4f3c5550dULL,
	0xb4674a24472233cbULL, 0x2bbd23826a090071ULL, 0xda95969b30594f66ULL, 0x9f5c47408f1e8a43ULL,
	0xf77022b88de9c055ULL, 0x64b7b36957601503ULL, 0xe73b72b06175c11aULL, 0x55b87de8b91a6233ULL,
	0x1bb16e6b6955ff7fULL, 0xe8e0a5ec7309719cULL, 0x702c31cb89a8b640ULL, 0xfba387cfada8cde2ULL,
	0x6792db4677aa164cULL, 0x1c6b1cc0b7751867ULL, 0x22ae2311d736dc01ULL, 0x0e3666a1d37c9588ULL,
	0xcd1fd9d4bf557e9aULL, 0xc986925f7c7b0e84ULL, 0x9c5dfd55325ef6b0ULL, 0x9f2b577d5676b0ddULL,
	0xfa6e21be21c062b3ULL, 0x8787dd782c8d7f83ULL, 0xd0d134e90e12dd23ULL, 0x449d087550121d96ULL,
	0xecf9ae9414d41967ULL, 0x5018f1dbf789934dULL, 0xfa5b52879155a74cULL, 0xca82d4d3cd278e7cULL,
	0x688fdfdfe22316adULL, 0x0f6555a4ba0d030aULL, 0xa2061df720f000f3ULL, 0xe1a57dc5622fb3daULL,
	0xe6a842a8e8ed8153ULL, 0x690acdd3811ce09dULL, 0x55adda18e6fcf446ULL, 0x4d57a8a0f4b60b46ULL,
	0xf86fbfc20539c415ULL, 0x74bafa5ec7100d19ULL, 0xa824151810f0f495ULL, 0x8723432791e38ebbULL,
	0x8eeaeb91d66ed539ULL, 0x73d8a1549dfd7e06ULL, 0x0387f2ffe3f13a9bULL, 0xa5004995aac15193ULL,
	0x682f81c73efdda0dULL, 0x2fb55925d71d268dULL, 0xcc392d2901e58a3dULL, 0xaa666ab975724a42ULL
};

static const lsh_u32 BLK_LEN_BYTE = 256;
static const lsh_u32 ALPHA_EVEN = 23;
static const lsh_u32 ALPHA_ODD = 7;
static const lsh_u32 BETA_EVEN = 59;
static const lsh_u32 BETA_ODD = 3;

static const LSH_ALIGNED_(32) lsh_s64x2 GAMMA[4] = {{0, 16}, {32, 48}, {8, 24}, {40, 56}};
static const LSH_ALIGNED_(32) lsh_s64x2 GAMMA_INV[4] = {{-64, -48}, {-32, -16}, {-56, -40}, {-24, -8}};

typedef struct LSH_ALIGNED_(32) {
	LSH_ALIGNED_(16) lsh_u32 algtype;
	LSH_ALIGNED_(16) lsh_u32 rbits; // remaining bits
	LSH_ALIGNED_(32) lsh_u64x2 cv[8];
	LSH_ALIGNED_(32) lsh_u8 block[256];
} LSH512Neon_Context;

static INLINE void msg_add(LSH512Neon_Context* ctx, lsh_u64x2* msg) {
	lsh_uint idx;
	for (idx = 0; idx < 8; ++idx) {
		ctx->cv[idx] ^= msg[idx];
	}
}

static INLINE lsh_u64x2 rol_n_u64(lsh_u64x2 value, const lsh_u32 rot) {
	return vsriq_n_u64(vshlq_n_u64(value, rot), value, 64 - rot);
}

static INLINE void add(lsh_u64x2* lhs, const lsh_u64x2* rhs) {
	lhs[0] = vaddq_u64(lhs[0], rhs[0]);
	lhs[1] = vaddq_u64(lhs[1], rhs[1]);
	lhs[2] = vaddq_u64(lhs[2], rhs[2]);
	lhs[3] = vaddq_u64(lhs[3], rhs[3]);
}

/**
 * {0, 1, 2, 3} -> {3, 2, 0, 1}
 */
static INLINE void msg_permutation1(lsh_u64x2* value) {
	const lsh_u64x2 tmp = value[0];
	value[0] = vextq_u64(value[1], value[1], 1);
	value[1] = tmp;
}

/**
 * {0, 1, 2, 3} -> {3, 0, 1, 2}
 */
static INLINE void msg_permutation2(lsh_u64x2* value) {
	const lsh_u64x2 tmp0 = value[0];
	const lsh_u64x2 tmp1 = value[1];

	value[0] = vextq_u64(tmp1, tmp0, 1);
	value[1] = vextq_u64(tmp0, tmp1, 1);
}

//TODO
static INLINE void msg_expansion(lsh_u64x2* lhs, const lsh_u64x2* rhs) {
	msg_permutation1(lhs);
	msg_permutation2(lhs + 2);
	msg_permutation1(lhs + 4);
	msg_permutation2(lhs + 6);

	add(lhs, rhs);
	add(lhs+4, rhs+4);
}

/**
 * {0, 1, 2, 3} -> {2, 0, 1, 3}
 */
static INLINE void word_permutation1(lsh_u64x2* value) {
	lsh_u64x2 tmp0 = value[0];
	lsh_u64x2 tmp1 = vextq_u64(value[1], value[1], 1);

	value[0] = vextq_u64(tmp1, tmp0, 1);
	value[1] = vextq_u64(tmp0, tmp1, 1);
}

/**
 * {0, 1, 2, 3} -> {0, 3, 2, 1}
 */
static INLINE void word_permutation2(lsh_u64x2* value) {
	lsh_u64x2 tmp0 = vextq_u64(value[0], value[0], 1);
	lsh_u64x2 tmp1 = vextq_u64(value[1], value[1], 1);

	value[0] = vextq_u64(tmp0, tmp1, 1);
	value[1] = vextq_u64(tmp1, tmp0, 1);
}

static INLINE void word_permutation(LSH512Neon_Context* ctx) {
	lsh_u64x2 tmp;

	word_permutation1(ctx->cv);
	word_permutation1(ctx->cv + 2);
	word_permutation2(ctx->cv + 4);
	word_permutation2(ctx->cv + 6);

	tmp = ctx->cv[0];
	ctx->cv[0] = ctx->cv[2];
	ctx->cv[2] = ctx->cv[6];
	ctx->cv[6] = ctx->cv[4];
	ctx->cv[4] = tmp;

	tmp = ctx->cv[1];
	ctx->cv[1] = ctx->cv[3];
	ctx->cv[3] = ctx->cv[7];
	ctx->cv[7] = ctx->cv[5];
	ctx->cv[5] = tmp;
}

static INLINE void inner_step_even_alpha(lsh_u64x2* lhs, const lsh_u64x2* rhs) {
	add(lhs, rhs);

	lhs[0] = vsriq_n_u64(vshlq_n_u64(lhs[0], 23), lhs[0], 41);
	lhs[1] = vsriq_n_u64(vshlq_n_u64(lhs[1], 23), lhs[1], 41);
	lhs[2] = vsriq_n_u64(vshlq_n_u64(lhs[2], 23), lhs[2], 41);
	lhs[3] = vsriq_n_u64(vshlq_n_u64(lhs[3], 23), lhs[3], 41);
}

static INLINE void inner_step_even_beta(lsh_u64x2* lhs, const lsh_u64x2* rhs) {
	add(lhs, rhs);

	lhs[0] = vsriq_n_u64(vshlq_n_u64(lhs[0], 59), lhs[0], 5);
	lhs[1] = vsriq_n_u64(vshlq_n_u64(lhs[1], 59), lhs[1], 5);
	lhs[2] = vsriq_n_u64(vshlq_n_u64(lhs[2], 59), lhs[2], 5);
	lhs[3] = vsriq_n_u64(vshlq_n_u64(lhs[3], 59), lhs[3], 5);
}

static INLINE void inner_step_odd_alpha(lsh_u64x2* lhs, const lsh_u64x2* rhs) {
	add(lhs, rhs);

	lhs[0] = vsriq_n_u64(vshlq_n_u64(lhs[0], 7), lhs[0], 57);
	lhs[1] = vsriq_n_u64(vshlq_n_u64(lhs[1], 7), lhs[1], 57);
	lhs[2] = vsriq_n_u64(vshlq_n_u64(lhs[2], 7), lhs[2], 57);
	lhs[3] = vsriq_n_u64(vshlq_n_u64(lhs[3], 7), lhs[3], 57);
}

static INLINE void inner_step_odd_beta(lsh_u64x2* lhs, const lsh_u64x2* rhs) {
	add(lhs, rhs);

	lhs[0] = vsriq_n_u64(vshlq_n_u64(lhs[0], 3), lhs[0], 61);
	lhs[1] = vsriq_n_u64(vshlq_n_u64(lhs[1], 3), lhs[1], 61);
	lhs[2] = vsriq_n_u64(vshlq_n_u64(lhs[2], 3), lhs[2], 61);
	lhs[3] = vsriq_n_u64(vshlq_n_u64(lhs[3], 3), lhs[3], 61);
}

static INLINE void load_sc(lsh_u64x2* sc, const lsh_u64* psc) {
	sc[0] = vld1q_u64(psc);
	sc[1] = vld1q_u64(psc + 2);
	sc[2] = vld1q_u64(psc + 4);
	sc[3] = vld1q_u64(psc + 6);
}

static INLINE void step_even(LSH512Neon_Context* ctx, lsh_u64x2* msg, lsh_u64x2* sc) {
	// msg add
	msg_add(ctx, msg);

	// mix: rotate alpha
	inner_step_even_alpha(ctx->cv, ctx->cv + 4);

	// mix: xor step constant
	ctx->cv[0] ^= sc[0];
	ctx->cv[1] ^= sc[1];
	ctx->cv[2] ^= sc[2];
	ctx->cv[3] ^= sc[3];

	// mix: rotate beta
	inner_step_even_beta(ctx->cv + 4, ctx->cv);

	// mix: add to left	
	add(ctx->cv, ctx->cv+4);

	// mix: rotate gamma
	ctx->cv[4] = vshlq_u64(ctx->cv[4], GAMMA[0]) ^ vshlq_u64(ctx->cv[4], GAMMA_INV[0]);
	ctx->cv[5] = vshlq_u64(ctx->cv[5], GAMMA[1]) ^ vshlq_u64(ctx->cv[5], GAMMA_INV[1]);
	ctx->cv[6] = vshlq_u64(ctx->cv[6], GAMMA[2]) ^ vshlq_u64(ctx->cv[6], GAMMA_INV[2]);
	ctx->cv[7] = vshlq_u64(ctx->cv[7], GAMMA[3]) ^ vshlq_u64(ctx->cv[7], GAMMA_INV[3]);

	// word permutation
	word_permutation(ctx);
}

static INLINE void step_odd(LSH512Neon_Context* ctx, lsh_u64x2* msg, lsh_u64x2* sc) {
	// msg add
	msg_add(ctx, msg);

	// mix: rotate alpha
	inner_step_odd_alpha(ctx->cv, ctx->cv + 4);

	// mix: xor step constant
	ctx->cv[0] ^= sc[0];
	ctx->cv[1] ^= sc[1];
	ctx->cv[2] ^= sc[2];
	ctx->cv[3] ^= sc[3];

	// mix: rotate beta
	inner_step_odd_beta(ctx->cv + 4, ctx->cv);

	// mix: add to left
	add(ctx->cv, ctx->cv+4);

	// mix: rotate gamma
	ctx->cv[4] = vshlq_u64(ctx->cv[4], GAMMA[0]) ^ vshlq_u64(ctx->cv[4], GAMMA_INV[0]);
	ctx->cv[5] = vshlq_u64(ctx->cv[5], GAMMA[1]) ^ vshlq_u64(ctx->cv[5], GAMMA_INV[1]);
	ctx->cv[6] = vshlq_u64(ctx->cv[6], GAMMA[2]) ^ vshlq_u64(ctx->cv[6], GAMMA_INV[2]);
	ctx->cv[7] = vshlq_u64(ctx->cv[7], GAMMA[3]) ^ vshlq_u64(ctx->cv[7], GAMMA_INV[3]);

	// word permutation
	word_permutation(ctx);
}

static INLINE void compress(LSH512Neon_Context* ctx, const lsh_u8* block) {

	lsh_uint idx;
	lsh_u64* pb = (lsh_u64*) block;
	const lsh_u64* pstep = STEP512;

	LSH_ALIGNED_(32) lsh_u64x2 sc[4];
	LSH_ALIGNED_(32) lsh_u64x2 msg[16];

	//msg load
	for (idx = 0; idx < 16; ++idx, pb += 2) {
		msg[idx] = vld1q_u64(pb);
	}

	// step functions
	for (idx = 0; idx < 14; ++idx, pstep += 16) {
//		sc[0] = vld1q_u64(pstep);
//		sc[1] = vld1q_u64(pstep + 2);
//		sc[2] = vld1q_u64(pstep + 4);
//		sc[3] = vld1q_u64(pstep + 6);
		load_sc(sc, pstep);
		step_even(ctx, msg, sc); // msg add & Mix & word permutation
		msg_expansion(msg, msg + 8);

//		sc[0] = vld1q_u64(pstep + 8);
//		sc[1] = vld1q_u64(pstep + 10);
//		sc[2] = vld1q_u64(pstep + 12);
//		sc[3] = vld1q_u64(pstep + 14);
		load_sc(sc, pstep + 8);
		step_odd(ctx, msg + 8, sc); // msg add & Mix & word permutation
		msg_expansion(msg + 8, msg);
	}

	// msg add
	msg_add(ctx, msg);
}

static INLINE void load_iv(LSH512Neon_Context* ctx, const lsh_u64* iv) {
	/*
	lsh_uint idx;
	for (idx = 0; idx < 8; ++idx) {
		ctx->cv[0] = vld1q_u64(iv + (idx*2));
	}
	*/

	ctx->cv[0] = vld1q_u64(iv);
	ctx->cv[1] = vld1q_u64(iv + 2);
	ctx->cv[2] = vld1q_u64(iv + 4);
	ctx->cv[3] = vld1q_u64(iv + 6);
	ctx->cv[4] = vld1q_u64(iv + 8);
	ctx->cv[5] = vld1q_u64(iv + 10);
	ctx->cv[6] = vld1q_u64(iv + 12);
	ctx->cv[7] = vld1q_u64(iv + 14);
}

static INLINE void generate_iv(LSH512Neon_Context* ctx, const lsh_u32 hashlenbit) {
	lsh_u64 block[32] = {'\0'};

	lsh_u64 cv[2] = {64, hashlenbit};
	memset(ctx->cv, 0, 8 * sizeof(lsh_u64x2));
	ctx->cv[0] = vld1q_u64(cv);

	compress(ctx, (lsh_u8*) block);
}

lsh_err lsh512_init(struct LSH512_Context * ctx, const lsh_type algtype) {
	LSH512Neon_Context* state = (LSH512Neon_Context*) ctx;
	state->algtype = algtype;
	state->rbits = 0;

	switch (algtype) {
	case LSH_TYPE_512_224:
		load_iv(state, IV224);
		break;

	case LSH_TYPE_512_256:
		load_iv(state, IV256);
		break;

	case LSH_TYPE_512_384:
		load_iv(state, IV384);
		break;

	case LSH_TYPE_512_512:
		load_iv(state, IV512);
		break;

	default:
		generate_iv(state, LSH_GET_HASHBIT(algtype));
		break;
	}

	return LSH_SUCCESS;
}

lsh_err lsh512_update(struct LSH512_Context * ctx, const lsh_u8* data, size_t databitlen) {
	LSH512Neon_Context* ctx_neon = (LSH512Neon_Context*) ctx;

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
	
	if (ctx->algtype == 0 || LSH_GET_HASHBYTE(ctx->algtype) > LSH512_HASH_VAL_MAX_BYTE_LEN){
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

lsh_err lsh512_final(struct LSH512_Context * ctx, lsh_u8 * hashval) {

	lsh_u8 buffer[LSH512_HASH_VAL_MAX_BYTE_LEN] = { 0x00, };
	lsh_u64* out = (lsh_u64*) buffer;
	LSH512Neon_Context* ctx_neon = (LSH512Neon_Context*) ctx;
	lsh_uint outlenbytes = LSH_GET_HASHBYTE(ctx->algtype);
	lsh_uint routbits = LSH_GET_SMALL_HASHBIT(ctx->algtype);

	size_t rbytes;
	size_t rbits;

	if (ctx == NULL || hashval == NULL) {
		return LSH_ERR_NULL_PTR;
	}
	
	if (ctx->algtype == 0 || LSH_GET_HASHBYTE(ctx->algtype) > LSH512_HASH_VAL_MAX_BYTE_LEN){
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
	ctx_neon->cv[0] = veorq_u64(ctx_neon->cv[0], ctx_neon->cv[4]);
	ctx_neon->cv[1] = veorq_u64(ctx_neon->cv[1], ctx_neon->cv[5]);
	ctx_neon->cv[2] = veorq_u64(ctx_neon->cv[2], ctx_neon->cv[6]);
	ctx_neon->cv[3] = veorq_u64(ctx_neon->cv[3], ctx_neon->cv[7]);

	// copy to output
	vst1q_u64(out, ctx_neon->cv[0]);
	vst1q_u64(out + 2, ctx_neon->cv[1]);
	vst1q_u64(out + 4, ctx_neon->cv[2]);
	vst1q_u64(out + 6, ctx_neon->cv[3]);
	
	memcpy(hashval, buffer, sizeof(lsh_u8) * outlenbytes);
	if (routbits > 0) {
		hashval[outlenbytes-1] &= (((lsh_u8)0xff) << routbits);
	}

	return LSH_SUCCESS;
}

lsh_err lsh512_digest(const lsh_type algtype, const lsh_u8 * data, size_t databitlen, lsh_u8 * hashval) {
	lsh_err result;
	struct LSH512_Context ctx;

	result = lsh512_init(&ctx, algtype);
	if (result != LSH_SUCCESS) {
		return result;
	}

	result = lsh512_update(&ctx, data, databitlen);
	if (result != LSH_SUCCESS) {
		return result;
	}

	return lsh512_final(&ctx, hashval);
}
