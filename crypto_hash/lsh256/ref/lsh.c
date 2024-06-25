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

#include <string.h>
#include "lsh_local.h"
#include "lsh.h"

/* -------------------------------------------------------- *
* LSH: parameters
* -------------------------------------------------------- */
#define MSG_BLK_WORD_LEN		32
#define CV_WORD_LEN				16
#define CONST_WORD_LEN			8
#define HASH_VAL_MAX_WORD_LEN	8

#define WORD_BIT_LEN			32

/* -------------------------------------------------------- */

#define NUM_STEPS				26

#define ROT_EVEN_ALPHA			29
#define ROT_EVEN_BETA			1
#define ROT_ODD_ALPHA			5
#define ROT_ODD_BETA			17

struct LSH256_internal{
	lsh_u32 submsg_e_l[CV_WORD_LEN / 2];	/* even left sub-message */
	lsh_u32 submsg_e_r[CV_WORD_LEN / 2];	/* even right sub-message */
	lsh_u32 submsg_o_l[CV_WORD_LEN / 2];	/* odd left sub-message */
	lsh_u32 submsg_o_r[CV_WORD_LEN / 2];	/* odd right sub-message */
};

/* -------------------------------------------------------- *
* LSH: iv
* -------------------------------------------------------- */

static const lsh_u32 g_IV224[CV_WORD_LEN] = {
	0x068608D3, 0x62D8F7A7, 0xD76652AB, 0x4C600A43, 0xBDC40AA8, 0x1ECA0B68, 0xDA1A89BE, 0x3147D354,
	0x707EB4F9, 0xF65B3862, 0x6B0B2ABE, 0x56B8EC0A, 0xCF237286, 0xEE0D1727, 0x33636595, 0x8BB8D05F,
};

static const lsh_u32 g_IV256[CV_WORD_LEN] = {
	0x46a10f1f, 0xfddce486, 0xb41443a8, 0x198e6b9d, 0x3304388d, 0xb0f5a3c7, 0xb36061c4, 0x7adbd553,
	0x105d5378, 0x2f74de54, 0x5c2f2d95, 0xf2553fbe, 0x8051357a, 0x138668c8, 0x47aa4484, 0xe01afb41
};

static const lsh_uint g_gamma256[8] = { 0, 8, 16, 24, 24, 16, 8, 0 };

/* -------------------------------------------------------- *
* LSH: step constants
* -------------------------------------------------------- */

static const lsh_u32 g_StepConstants[CONST_WORD_LEN * NUM_STEPS] = {
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

/* -------------------------------------------------------- *
* LSH: functions
* -------------------------------------------------------- */

/* -------------------------------------------------------- *
* generating function of step constants
* -------------------------------------------------------- */

#if 0
static void GenStepConstants()
{
	int i, j;
	for (i = 1; i < NUM_STEPS; i++)
	{
		for (j = 0; j < CONST_WORD_LEN; j++)
		{
			g_StepConstants[CONST_WORD_LEN*i + j] = ROTL(g_StepConstants[CONST_WORD_LEN*(i - 1) + j], 8);
			g_StepConstants[CONST_WORD_LEN*i + j] += g_StepConstants[CONST_WORD_LEN*(i - 1) + j];
		}
	}
}
#endif

static INLINE void load_msg_blk(struct LSH256_internal * i_state, const lsh_u32 * msgblk){
	i_state->submsg_e_l[0] = loadLE32(msgblk[0]);
	i_state->submsg_e_l[1] = loadLE32(msgblk[1]);
	i_state->submsg_e_l[2] = loadLE32(msgblk[2]);
	i_state->submsg_e_l[3] = loadLE32(msgblk[3]);
	i_state->submsg_e_l[4] = loadLE32(msgblk[4]);
	i_state->submsg_e_l[5] = loadLE32(msgblk[5]);
	i_state->submsg_e_l[6] = loadLE32(msgblk[6]);
	i_state->submsg_e_l[7] = loadLE32(msgblk[7]);
	i_state->submsg_e_r[0] = loadLE32(msgblk[8]);
	i_state->submsg_e_r[1] = loadLE32(msgblk[9]);
	i_state->submsg_e_r[2] = loadLE32(msgblk[10]);
	i_state->submsg_e_r[3] = loadLE32(msgblk[11]);
	i_state->submsg_e_r[4] = loadLE32(msgblk[12]);
	i_state->submsg_e_r[5] = loadLE32(msgblk[13]);
	i_state->submsg_e_r[6] = loadLE32(msgblk[14]);
	i_state->submsg_e_r[7] = loadLE32(msgblk[15]);
	i_state->submsg_o_l[0] = loadLE32(msgblk[16]);
	i_state->submsg_o_l[1] = loadLE32(msgblk[17]);
	i_state->submsg_o_l[2] = loadLE32(msgblk[18]);
	i_state->submsg_o_l[3] = loadLE32(msgblk[19]);
	i_state->submsg_o_l[4] = loadLE32(msgblk[20]);
	i_state->submsg_o_l[5] = loadLE32(msgblk[21]);
	i_state->submsg_o_l[6] = loadLE32(msgblk[22]);
	i_state->submsg_o_l[7] = loadLE32(msgblk[23]);
	i_state->submsg_o_r[0] = loadLE32(msgblk[24]);
	i_state->submsg_o_r[1] = loadLE32(msgblk[25]);
	i_state->submsg_o_r[2] = loadLE32(msgblk[26]);
	i_state->submsg_o_r[3] = loadLE32(msgblk[27]);
	i_state->submsg_o_r[4] = loadLE32(msgblk[28]);
	i_state->submsg_o_r[5] = loadLE32(msgblk[29]);
	i_state->submsg_o_r[6] = loadLE32(msgblk[30]);
	i_state->submsg_o_r[7] = loadLE32(msgblk[31]);
}

static INLINE void msg_exp_even(struct LSH256_internal * i_state){
	lsh_u32 temp;
	temp = i_state->submsg_e_l[0];
	i_state->submsg_e_l[0] = i_state->submsg_o_l[0] + i_state->submsg_e_l[3];
	i_state->submsg_e_l[3] = i_state->submsg_o_l[3] + i_state->submsg_e_l[1];
	i_state->submsg_e_l[1] = i_state->submsg_o_l[1] + i_state->submsg_e_l[2];
	i_state->submsg_e_l[2] = i_state->submsg_o_l[2] + temp;
	temp = i_state->submsg_e_l[4];
	i_state->submsg_e_l[4] = i_state->submsg_o_l[4] + i_state->submsg_e_l[7];
	i_state->submsg_e_l[7] = i_state->submsg_o_l[7] + i_state->submsg_e_l[6];
	i_state->submsg_e_l[6] = i_state->submsg_o_l[6] + i_state->submsg_e_l[5];
	i_state->submsg_e_l[5] = i_state->submsg_o_l[5] + temp;
	temp = i_state->submsg_e_r[0];
	i_state->submsg_e_r[0] = i_state->submsg_o_r[0] + i_state->submsg_e_r[3];
	i_state->submsg_e_r[3] = i_state->submsg_o_r[3] + i_state->submsg_e_r[1];
	i_state->submsg_e_r[1] = i_state->submsg_o_r[1] + i_state->submsg_e_r[2];
	i_state->submsg_e_r[2] = i_state->submsg_o_r[2] + temp;
	temp = i_state->submsg_e_r[4];
	i_state->submsg_e_r[4] = i_state->submsg_o_r[4] + i_state->submsg_e_r[7];
	i_state->submsg_e_r[7] = i_state->submsg_o_r[7] + i_state->submsg_e_r[6];
	i_state->submsg_e_r[6] = i_state->submsg_o_r[6] + i_state->submsg_e_r[5];
	i_state->submsg_e_r[5] = i_state->submsg_o_r[5] + temp;
}

static INLINE void msg_exp_odd(struct LSH256_internal * i_state){
	lsh_u32 temp;
	temp = i_state->submsg_o_l[0];
	i_state->submsg_o_l[0] = i_state->submsg_e_l[0] + i_state->submsg_o_l[3];
	i_state->submsg_o_l[3] = i_state->submsg_e_l[3] + i_state->submsg_o_l[1];
	i_state->submsg_o_l[1] = i_state->submsg_e_l[1] + i_state->submsg_o_l[2];
	i_state->submsg_o_l[2] = i_state->submsg_e_l[2] + temp;
	temp = i_state->submsg_o_l[4];
	i_state->submsg_o_l[4] = i_state->submsg_e_l[4] + i_state->submsg_o_l[7];
	i_state->submsg_o_l[7] = i_state->submsg_e_l[7] + i_state->submsg_o_l[6];
	i_state->submsg_o_l[6] = i_state->submsg_e_l[6] + i_state->submsg_o_l[5];
	i_state->submsg_o_l[5] = i_state->submsg_e_l[5] + temp;
	temp = i_state->submsg_o_r[0];
	i_state->submsg_o_r[0] = i_state->submsg_e_r[0] + i_state->submsg_o_r[3];
	i_state->submsg_o_r[3] = i_state->submsg_e_r[3] + i_state->submsg_o_r[1];
	i_state->submsg_o_r[1] = i_state->submsg_e_r[1] + i_state->submsg_o_r[2];
	i_state->submsg_o_r[2] = i_state->submsg_e_r[2] + temp;
	temp = i_state->submsg_o_r[4];
	i_state->submsg_o_r[4] = i_state->submsg_e_r[4] + i_state->submsg_o_r[7];
	i_state->submsg_o_r[7] = i_state->submsg_e_r[7] + i_state->submsg_o_r[6];
	i_state->submsg_o_r[6] = i_state->submsg_e_r[6] + i_state->submsg_o_r[5];
	i_state->submsg_o_r[5] = i_state->submsg_e_r[5] + temp;
}

static INLINE void load_sc(const lsh_u32** p_const_v, lsh_uint i){
	*p_const_v = &g_StepConstants[i];
}

static INLINE void msg_add_even(lsh_u32* cv_l, lsh_u32* cv_r, struct LSH256_internal * i_state){
	cv_l[0] ^= i_state->submsg_e_l[0]; cv_l[1] ^= i_state->submsg_e_l[1]; cv_l[2] ^= i_state->submsg_e_l[2]; cv_l[3] ^= i_state->submsg_e_l[3];
	cv_l[4] ^= i_state->submsg_e_l[4]; cv_l[5] ^= i_state->submsg_e_l[5]; cv_l[6] ^= i_state->submsg_e_l[6]; cv_l[7] ^= i_state->submsg_e_l[7];
	cv_r[0] ^= i_state->submsg_e_r[0]; cv_r[1] ^= i_state->submsg_e_r[1]; cv_r[2] ^= i_state->submsg_e_r[2]; cv_r[3] ^= i_state->submsg_e_r[3];
	cv_r[4] ^= i_state->submsg_e_r[4]; cv_r[5] ^= i_state->submsg_e_r[5]; cv_r[6] ^= i_state->submsg_e_r[6]; cv_r[7] ^= i_state->submsg_e_r[7];
}
static INLINE void msg_add_odd(lsh_u32* cv_l, lsh_u32* cv_r, struct LSH256_internal * i_state){
	cv_l[0] ^= i_state->submsg_o_l[0]; cv_l[1] ^= i_state->submsg_o_l[1]; cv_l[2] ^= i_state->submsg_o_l[2]; cv_l[3] ^= i_state->submsg_o_l[3];
	cv_l[4] ^= i_state->submsg_o_l[4]; cv_l[5] ^= i_state->submsg_o_l[5]; cv_l[6] ^= i_state->submsg_o_l[6]; cv_l[7] ^= i_state->submsg_o_l[7];
	cv_r[0] ^= i_state->submsg_o_r[0]; cv_r[1] ^= i_state->submsg_o_r[1]; cv_r[2] ^= i_state->submsg_o_r[2]; cv_r[3] ^= i_state->submsg_o_r[3];
	cv_r[4] ^= i_state->submsg_o_r[4]; cv_r[5] ^= i_state->submsg_o_r[5]; cv_r[6] ^= i_state->submsg_o_r[6]; cv_r[7] ^= i_state->submsg_o_r[7];
}

static INLINE void  add_blk(lsh_u32* cv_l, const lsh_u32* cv_r){
	cv_l[0] += cv_r[0];
	cv_l[1] += cv_r[1];
	cv_l[2] += cv_r[2];
	cv_l[3] += cv_r[3];
	cv_l[4] += cv_r[4];
	cv_l[5] += cv_r[5];
	cv_l[6] += cv_r[6];
	cv_l[7] += cv_r[7];
}

static INLINE void  rotate_blk(lsh_u32 cv[8], const int rot_value){
	cv[0] = ROTL(cv[0], rot_value);
	cv[1] = ROTL(cv[1], rot_value);
	cv[2] = ROTL(cv[2], rot_value);
	cv[3] = ROTL(cv[3], rot_value);
	cv[4] = ROTL(cv[4], rot_value);
	cv[5] = ROTL(cv[5], rot_value);
	cv[6] = ROTL(cv[6], rot_value);
	cv[7] = ROTL(cv[7], rot_value);
}

static INLINE void  xor_with_const(lsh_u32* cv_l, const lsh_u32* const_v){
	cv_l[0] ^= const_v[0];
	cv_l[1] ^= const_v[1];
	cv_l[2] ^= const_v[2];
	cv_l[3] ^= const_v[3];
	cv_l[4] ^= const_v[4];
	cv_l[5] ^= const_v[5];
	cv_l[6] ^= const_v[6];
	cv_l[7] ^= const_v[7];
}

static INLINE void  rotate_msg_gamma(lsh_u32* cv_r){
	cv_r[1] = ROTL(cv_r[1], g_gamma256[1]);
	cv_r[2] = ROTL(cv_r[2], g_gamma256[2]);
	cv_r[3] = ROTL(cv_r[3], g_gamma256[3]);
	cv_r[4] = ROTL(cv_r[4], g_gamma256[4]);
	cv_r[5] = ROTL(cv_r[5], g_gamma256[5]);
	cv_r[6] = ROTL(cv_r[6], g_gamma256[6]);
}

static INLINE void  word_perm(lsh_u32* cv_l, lsh_u32* cv_r){
	lsh_u32 temp;
	temp = cv_l[0];
	cv_l[0] = cv_l[6];
	cv_l[6] = cv_r[6];
	cv_r[6] = cv_r[2];
	cv_r[2] = cv_l[1];
	cv_l[1] = cv_l[4];
	cv_l[4] = cv_r[4];
	cv_r[4] = cv_r[0];
	cv_r[0] = cv_l[2];
	cv_l[2] = cv_l[5];
	cv_l[5] = cv_r[7];
	cv_r[7] = cv_r[1];
	cv_r[1] = temp;
	temp = cv_l[3];
	cv_l[3] = cv_l[7];
	cv_l[7] = cv_r[5];
	cv_r[5] = cv_r[3];
	cv_r[3] = temp;
};

/* -------------------------------------------------------- *
* step function
* -------------------------------------------------------- */

static INLINE void mix(lsh_u32* cv_l, lsh_u32* cv_r, const lsh_u32* const_v, const int rot_alpha, const int rot_beta){
	add_blk(cv_l, cv_r);
	rotate_blk(cv_l, rot_alpha);
	xor_with_const(cv_l, const_v);
	add_blk(cv_r, cv_l);
	rotate_blk(cv_r, rot_beta);
	add_blk(cv_l, cv_r);
	rotate_msg_gamma(cv_r);
}

/* -------------------------------------------------------- *
* compression function
* -------------------------------------------------------- */
static INLINE void compress(struct LSH256_Context* ctx, const lsh_u32 pdMsgBlk[MSG_BLK_WORD_LEN])
{
	lsh_uint i;
	struct LSH256_internal i_state[1];

	const lsh_u32* const_v = NULL;
	lsh_u32* cv_l = ctx->cv_l;
	lsh_u32* cv_r = ctx->cv_r;

	load_msg_blk(i_state, pdMsgBlk);

	msg_add_even(cv_l, cv_r, i_state);
	load_sc(&const_v, 0);
	mix(cv_l, cv_r, const_v, ROT_EVEN_ALPHA, ROT_EVEN_BETA);
	word_perm(cv_l, cv_r);

	msg_add_odd(cv_l, cv_r, i_state);
	load_sc(&const_v, 8);
	mix(cv_l, cv_r, const_v, ROT_ODD_ALPHA, ROT_ODD_BETA);
	word_perm(cv_l, cv_r);

	for (i = 1; i < NUM_STEPS / 2; i++)
	{
		msg_exp_even(i_state);
		msg_add_even(cv_l, cv_r, i_state);
		load_sc(&const_v, 16 * i);
		mix(cv_l, cv_r, const_v, ROT_EVEN_ALPHA, ROT_EVEN_BETA);
		word_perm(cv_l, cv_r);

		msg_exp_odd(i_state);
		msg_add_odd(cv_l, cv_r, i_state);
		load_sc(&const_v, 16 * i + 8);
		mix(cv_l, cv_r, const_v, ROT_ODD_ALPHA, ROT_ODD_BETA);
		word_perm(cv_l, cv_r);
	}

	msg_exp_even(i_state);
	msg_add_even(cv_l, cv_r, i_state);
}


/* -------------------------------------------------------- */

static INLINE void init224(struct LSH256_Context * ctx)
{
	ctx->cv_l[0] = g_IV224[0];
	ctx->cv_l[1] = g_IV224[1];
	ctx->cv_l[2] = g_IV224[2];
	ctx->cv_l[3] = g_IV224[3];
	ctx->cv_l[4] = g_IV224[4];
	ctx->cv_l[5] = g_IV224[5];
	ctx->cv_l[6] = g_IV224[6];
	ctx->cv_l[7] = g_IV224[7];
	ctx->cv_r[0] = g_IV224[8];
	ctx->cv_r[1] = g_IV224[9];
	ctx->cv_r[2] = g_IV224[10];
	ctx->cv_r[3] = g_IV224[11];
	ctx->cv_r[4] = g_IV224[12];
	ctx->cv_r[5] = g_IV224[13];
	ctx->cv_r[6] = g_IV224[14];
	ctx->cv_r[7] = g_IV224[15];
}

static INLINE void init256(struct LSH256_Context * ctx)
{
	ctx->cv_l[0] = g_IV256[0];
	ctx->cv_l[1] = g_IV256[1];
	ctx->cv_l[2] = g_IV256[2];
	ctx->cv_l[3] = g_IV256[3];
	ctx->cv_l[4] = g_IV256[4];
	ctx->cv_l[5] = g_IV256[5];
	ctx->cv_l[6] = g_IV256[6];
	ctx->cv_l[7] = g_IV256[7];
	ctx->cv_r[0] = g_IV256[8];
	ctx->cv_r[1] = g_IV256[9];
	ctx->cv_r[2] = g_IV256[10];
	ctx->cv_r[3] = g_IV256[11];
	ctx->cv_r[4] = g_IV256[12];
	ctx->cv_r[5] = g_IV256[13];
	ctx->cv_r[6] = g_IV256[14];
	ctx->cv_r[7] = g_IV256[15];
}



/* -------------------------------------------------------- */

static INLINE void fin(struct LSH256_Context * ctx)
{
	lsh_uint i;
	for (i = 0; i < HASH_VAL_MAX_WORD_LEN; i++){
		ctx->cv_l[i] = loadLE32(ctx->cv_l[i] ^ ctx->cv_r[i]);
	}
}

/* -------------------------------------------------------- */

static INLINE void get_hash(struct LSH256_Context * ctx, lsh_u8 * pbHashVal, const lsh_type algtype)
{
	lsh_uint hash_val_byte_len = LSH_GET_HASHBYTE(algtype);
	lsh_uint hash_val_bit_len = LSH_GET_SMALL_HASHBIT(algtype);
	memcpy(pbHashVal, ctx->cv_l, sizeof(lsh_u8) * hash_val_byte_len);
	if (hash_val_bit_len){
		pbHashVal[hash_val_byte_len-1] &= (((lsh_u8)0xff) << hash_val_bit_len);
	}
}

/* -------------------------------------------------------- */

lsh_err lsh256_init(struct LSH256_Context * ctx, const lsh_type algtype){

	lsh_uint i;
	lsh_u32* cv_l;
	lsh_u32* cv_r;

	const lsh_u32* const_v = NULL;

	if (ctx == NULL){
		return LSH_ERR_NULL_PTR;
	}

	ctx->algtype = algtype;
	ctx->remain_databitlen = 0;

	if (!LSH_IS_LSH256(algtype)){
		return LSH_ERR_INVALID_ALGTYPE;
	}

	if (LSH_GET_HASHBYTE(algtype) > LSH256_HASH_VAL_MAX_BYTE_LEN || LSH_GET_HASHBYTE(algtype) == 0){
		return LSH_ERR_INVALID_ALGTYPE;
	}


	switch (algtype){
	case LSH_TYPE_256_256:
		init256(ctx);
		return LSH_SUCCESS;
	case LSH_TYPE_256_224:
		init224(ctx);
		return LSH_SUCCESS;
	default:
		break;
	}


	cv_l = ctx->cv_l;
	cv_r = ctx->cv_r;

	memset(ctx->cv_l, 0, 8 * sizeof(lsh_u32));
	memset(ctx->cv_r, 0, 8 * sizeof(lsh_u32));
	ctx->cv_l[0] = LSH256_HASH_VAL_MAX_BYTE_LEN;
	ctx->cv_l[1] = LSH_GET_HASHBIT(algtype);

	for (i = 0; i < NUM_STEPS / 2; i++)
	{
		//Mix
		load_sc(&const_v, i * 16);
		mix(cv_l, cv_r, const_v, ROT_EVEN_ALPHA, ROT_EVEN_BETA);
		word_perm(cv_l, cv_r);

		load_sc(&const_v, i * 16 + 8);
		mix(cv_l, cv_r, const_v, ROT_ODD_ALPHA, ROT_ODD_BETA);
		word_perm(cv_l, cv_r);
	}


	return LSH_SUCCESS;
}

lsh_err lsh256_update(struct LSH256_Context * ctx, const lsh_u8 * data, size_t databitlen){

	size_t databytelen = databitlen >> 3;
	lsh_uint pos2 = databitlen & 0x7;

	lsh_uint remain_msg_byte;
	lsh_uint remain_msg_bit;

	if (databitlen == 0){
		return LSH_SUCCESS;
	}

	if (ctx == NULL || data == NULL){
		return LSH_ERR_NULL_PTR;
	}
	
	if (ctx->algtype == 0 || LSH_GET_HASHBYTE(ctx->algtype) > LSH256_HASH_VAL_MAX_BYTE_LEN){
		return LSH_ERR_INVALID_STATE;
	}

	remain_msg_byte = ctx->remain_databitlen >> 3;
	remain_msg_bit = ctx->remain_databitlen & 7;
	if (remain_msg_byte >= LSH256_MSG_BLK_BYTE_LEN){
		return LSH_ERR_INVALID_STATE;
	}
	if (remain_msg_bit > 0){
		return LSH_ERR_INVALID_DATABITLEN;
	}

	if (databytelen + remain_msg_byte < LSH256_MSG_BLK_BYTE_LEN){
		memcpy(ctx->last_block + remain_msg_byte, data, databytelen);
		ctx->remain_databitlen += (lsh_uint)databitlen;
		remain_msg_byte += (lsh_uint)databytelen;
		if (pos2){
			ctx->last_block[remain_msg_byte] = data[databytelen] & ((0xff >> pos2) ^ 0xff);
		}
		return LSH_SUCCESS;
	}

	if (remain_msg_byte > 0){
		lsh_uint more_byte = LSH256_MSG_BLK_BYTE_LEN - remain_msg_byte;
		memcpy(ctx->last_block + remain_msg_byte, data, more_byte);
		compress(ctx, (lsh_u32*)ctx->last_block);
		data += more_byte;
		databytelen -= more_byte;
		remain_msg_byte = 0;
		ctx->remain_databitlen = 0;
	}

	while (databytelen >= LSH256_MSG_BLK_BYTE_LEN)
	{
		compress(ctx, (lsh_u32*)data);
		data += LSH256_MSG_BLK_BYTE_LEN;
		databytelen -= LSH256_MSG_BLK_BYTE_LEN;
	}

	if (databytelen > 0){
		memcpy(ctx->last_block, data, databytelen);
		ctx->remain_databitlen = (lsh_uint)(databytelen << 3);
	}

	if (pos2){
		ctx->last_block[databytelen] = data[databytelen] & ((0xff >> pos2) ^ 0xff);
		ctx->remain_databitlen += pos2;
	}
	return LSH_SUCCESS;
}

lsh_err lsh256_final(struct LSH256_Context * ctx, lsh_u8 * hashval){
	lsh_uint remain_msg_byte;
	lsh_uint remain_msg_bit;

	if (ctx == NULL || hashval == NULL){
		return LSH_ERR_NULL_PTR;
	}
	if (ctx->algtype == 0 || LSH_GET_HASHBYTE(ctx->algtype) > LSH256_HASH_VAL_MAX_BYTE_LEN){
		return LSH_ERR_INVALID_STATE;
	}

	remain_msg_byte = ctx->remain_databitlen >> 3;
	remain_msg_bit = ctx->remain_databitlen & 7;

	if (remain_msg_byte >= LSH256_MSG_BLK_BYTE_LEN){
		return LSH_ERR_INVALID_STATE;
	}

	if (remain_msg_bit){
		ctx->last_block[remain_msg_byte] |= (0x1 << (7 - remain_msg_bit));
	}
	else{
		ctx->last_block[remain_msg_byte] = 0x80;
	}
	memset(ctx->last_block + remain_msg_byte + 1, 0, LSH256_MSG_BLK_BYTE_LEN - remain_msg_byte - 1);

	compress(ctx, (lsh_u32*)ctx->last_block);

	fin(ctx);
	get_hash(ctx, hashval, ctx->algtype);

	memset(ctx, 0, sizeof(struct LSH256_Context));

	return LSH_SUCCESS;
}

lsh_err lsh256_digest(const lsh_type algtype, const lsh_u8 * data, size_t databitlen, lsh_u8 * hashval){
	lsh_err result;
	struct LSH256_Context ctx;

	result = lsh256_init(&ctx, algtype);
	if (result != LSH_SUCCESS) return result;

	result = lsh256_update(&ctx, data, databitlen);
	if (result != LSH_SUCCESS) return result;

	return lsh256_final(&ctx, hashval);
}

