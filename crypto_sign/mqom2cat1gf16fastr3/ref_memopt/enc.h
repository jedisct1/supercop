#ifndef __ENC_H__
#define __ENC_H__

/* MQOM2 parameters */
#include "mqom2_parameters.h"
/* Common helpers */
#include "common.h"

/* === 128 bits security === */
#if MQOM2_PARAM_SECURITY == 128

#if defined(MQOM2_FOR_MUPQ) && !defined(MQOM2_FOR_MUPQ_LOCAL_RIJNDAEL)
/*************************************/
/********** MUPQ API *****************/
/*************************************/
/* For 128 bits security for MUPQ when local Rijndael is not defined, we use the AES-128 dedicated "private" API */
#include "aes.h"
#include "aes-publicinputs.h"
/* XXX: NOTE: when possible, we use the faster LUT based AES for key schedule
 * and the constant-time "fixsliced" AES for encryption.
 * Hence the following union.
 * See: https://github.com/mupq/mupq/issues/171 for the discussion
 * */
typedef union {
	aes128ctx_publicinputs ctx_pub;
	aes128ctx ctx_priv;
} enc_ctx;

/* Helpers to interleave two round keys, stolen from https://github.com/aadomn/aes/blob/master/opt32/fixslicing/aes_encrypt.c */
#define SWAPMOVE(a, b, mask, n) ({                                                      \
        tmp = (b ^ (a >> n)) & mask;                                                    \
        b ^= tmp;                                                                       \
        a ^= (tmp << n);                                                                \
})
#define LE_LOAD_32(x)                                                                   \
    ((((uint32_t)((x)[3])) << 24) |                                                     \
     (((uint32_t)((x)[2])) << 16) |                                                     \
     (((uint32_t)((x)[1])) << 8) |                                                      \
      ((uint32_t)((x)[0])))

/******************************************************************************
* Applies ShiftRows^(-1) on a round key to match the fixsliced representation.
******************************************************************************/
static inline void inv_shiftrows_1(uint32_t* rkey) {
        uint32_t tmp;
        for(int i = 0; i < 8; i++) {
                SWAPMOVE(rkey[i], rkey[i], 0x0c0f0300, 4);
                SWAPMOVE(rkey[i], rkey[i], 0x33003300, 2);
        }
}
/******************************************************************************
* Applies ShiftRows^(-2) on a round key to match the fixsliced representation.
******************************************************************************/
static inline void inv_shiftrows_2(uint32_t* rkey) {
        uint32_t tmp;
        for(int i = 0; i < 8; i++)
                SWAPMOVE(rkey[i], rkey[i], 0x0f000f00, 4);
}

/******************************************************************************
* Applies ShiftRows^(-3) on a round key to match the fixsliced representation.
******************************************************************************/
static inline void inv_shiftrows_3(uint32_t* rkey) {
        uint32_t tmp;
        for(int i = 0; i < 8; i++) {
                SWAPMOVE(rkey[i], rkey[i], 0x030f0c00, 4);
                SWAPMOVE(rkey[i], rkey[i], 0x33003300, 2);
        }
}

static inline void keys_packing(uint32_t* out, const unsigned char* in0,
                const unsigned char* in1, unsigned int i) {
        uint32_t tmp;
        out[0] = LE_LOAD_32(in0);
        out[1] = LE_LOAD_32(in1);
        out[2] = LE_LOAD_32(in0 + 4);
        out[3] = LE_LOAD_32(in1 + 4);
        out[4] = LE_LOAD_32(in0 + 8);
        out[5] = LE_LOAD_32(in1 + 8);
        out[6] = LE_LOAD_32(in0 + 12);
        out[7] = LE_LOAD_32(in1 + 12);
        SWAPMOVE(out[1], out[0], 0x55555555, 1);
        SWAPMOVE(out[3], out[2], 0x55555555, 1);
        SWAPMOVE(out[5], out[4], 0x55555555, 1);
        SWAPMOVE(out[7], out[6], 0x55555555, 1);
        SWAPMOVE(out[2], out[0], 0x33333333, 2);
        SWAPMOVE(out[3], out[1], 0x33333333, 2);
        SWAPMOVE(out[6], out[4], 0x33333333, 2);
        SWAPMOVE(out[7], out[5], 0x33333333, 2);
        SWAPMOVE(out[4], out[0], 0x0f0f0f0f, 4);
        SWAPMOVE(out[5], out[1], 0x0f0f0f0f, 4);
        SWAPMOVE(out[6], out[2], 0x0f0f0f0f, 4);
        SWAPMOVE(out[7], out[3], 0x0f0f0f0f, 4);
        /* Apply inverse shiftrows on some round keys to match fixslicing */
        switch(i){
                case 3:
                case 7:
                        inv_shiftrows_3(out);
                        break;
                case 1:
                case 5:
                case 9:
                        inv_shiftrows_1(out);
                        break;
                case 2:
                case 6:
                        inv_shiftrows_2(out);
                        break;
                default:
                        break;
        }
        if(i > 0){
                /* Apply the xor with 0xffffffff since it is expected by the bitslice
                 * encryption to speedup the SBox */
                out[1] ^= 0xffffffff;
                out[2] ^= 0xffffffff;
                out[6] ^= 0xffffffff;
                out[7] ^= 0xffffffff;
        }
}

/* XXX: NOTE: on a x86 host, we force MQOM2_FOR_MUPQ_AES_GENERIC_KEYSCHEDULE since
 * we cannot mix public and private AES .... */
#if defined(__i386__) || defined(__x86_64__)
#define MQOM2_FOR_MUPQ_AES_GENERIC_KEYSCHEDULE
#endif

static inline int enc_key_sched(enc_ctx *ctx, const uint8_t key[16])
{
#if defined(MQOM2_FOR_MUPQ_AES_GENERIC_KEYSCHEDULE)
	aes128_ecb_keyexp(&ctx->ctx_priv, key);
#else
	/* By default, and since our key schedule only deals with public data, we
 	 * use the non constant-time LUT based key schedule for performance
 	 * */
	aes128_ecb_keyexp_publicinputs(&ctx->ctx_pub, key);
#endif
	return 0;
}
static inline int enc_encrypt(const enc_ctx *ctx, const uint8_t pt[16], uint8_t ct[16])
{
#if !defined(MQOM2_FOR_MUPQ_AES_GENERIC_KEYSCHEDULE)
	unsigned int i;
	uint32_t *rk = (uint32_t*)(&ctx->ctx_pub);
	uint32_t interleaved_keys[88];
	/* Transfer the keys from LUT to bitslice */
	for(i = 0; i < 11; i++){
        	keys_packing(&interleaved_keys[8*i], (uint8_t*)&rk[4*i], (uint8_t*)&rk[4*i], i);
	}
	aes128_ecb(ct, pt, 1, (aes128ctx*)&interleaved_keys);
#else
	aes128_ecb(ct, pt, 1, &ctx->ctx_priv);
#endif
	return 0;
}

static inline int enc_encrypt_x2(const enc_ctx *ctx1, const enc_ctx *ctx2, const uint8_t pt1[16], const uint8_t pt2[16], uint8_t ct1[16], uint8_t ct2[16])
{
#if !defined(MQOM2_FOR_MUPQ_AES_GENERIC_KEYSCHEDULE)
	unsigned int i;
	uint32_t *rk1 = (uint32_t*)(&ctx1->ctx_pub);
	uint32_t *rk2 = (uint32_t*)(&ctx2->ctx_pub);
	uint32_t interleaved_keys[88];
	/* Transfer the keys from LUT to bitslice */
	for(i = 0; i < 11; i++){
        	keys_packing(&interleaved_keys[8*i], (uint8_t*)&rk1[4*i], (uint8_t*)&rk2[4*i], i);
	}
	{
		uint8_t pt[32];
		uint8_t ct[32];

		memcpy(&pt[0], pt1, 16);
		memcpy(&pt[16], pt2, 16);

		aes128_ecb(ct, pt, 2, (aes128ctx*)&interleaved_keys);

		memcpy(ct1, &ct[0], 16);
		memcpy(ct2, &ct[16], 16);
	}
#else
	if(ctx1 == ctx2){
		uint8_t pt[32];
		uint8_t ct[32];

		memcpy(&pt[0], pt1, 16);
		memcpy(&pt[16], pt2, 16);

		aes128_ecb(ct, pt, 2, &ctx1->ctx_priv);

		memcpy(ct1, &ct[0], 16);
		memcpy(ct2, &ct[16], 16);
	}
	else{
		aes128_ecb(ct1, pt1, 1, &ctx1->ctx_priv);
		aes128_ecb(ct2, pt2, 1, &ctx2->ctx_priv);
	}
#endif
	return 0;
}

static inline int enc_encrypt_x4(const enc_ctx *ctx1, const enc_ctx *ctx2, const enc_ctx *ctx3, const enc_ctx *ctx4,
				const uint8_t pt1[16], const uint8_t pt2[16], const uint8_t pt3[16], const uint8_t pt4[16],
				uint8_t ct1[16], uint8_t ct2[16], uint8_t ct3[16], uint8_t ct4[16])
{
#if !defined(MQOM2_FOR_MUPQ_AES_GENERIC_KEYSCHEDULE)
	int ret = 0;
	ret |= enc_encrypt_x2(ctx1, ctx2, pt1, pt2, ct1, ct2);
	ret |= enc_encrypt_x2(ctx3, ctx4, pt3, pt4, ct3, ct4);
	return ret;
#else
	if((ctx1 == ctx2) && (ctx2 == ctx3) && (ctx3 == ctx4)){
		uint8_t pt[64];
		uint8_t ct[64];

		memcpy(&pt[0],  pt1, 16);
		memcpy(&pt[16], pt2, 16);
		memcpy(&pt[32], pt3, 16);
		memcpy(&pt[48], pt4, 16);

		aes128_ecb(ct, pt, 4, &ctx1->ctx_priv);

		memcpy(ct1, &ct[0] , 16);
		memcpy(ct2, &ct[16], 16);
		memcpy(ct3, &ct[32], 16);
		memcpy(ct4, &ct[48], 16);
	}
	else{
		enc_encrypt_x2(ctx1, ctx2, pt1, pt2, ct1, ct2);
		enc_encrypt_x2(ctx3, ctx4, pt3, pt4, ct3, ct4);
	}
	return 0;
#endif
}

static inline int enc_encrypt_x8(const enc_ctx *ctx1, const enc_ctx *ctx2, const enc_ctx *ctx3, const enc_ctx *ctx4,
				const enc_ctx *ctx5, const enc_ctx *ctx6, const enc_ctx *ctx7, const enc_ctx *ctx8,
				const uint8_t pt1[16], const uint8_t pt2[16], const uint8_t pt3[16], const uint8_t pt4[16],
				const uint8_t pt5[16], const uint8_t pt6[16], const uint8_t pt7[16], const uint8_t pt8[16],
				uint8_t ct1[16], uint8_t ct2[16], uint8_t ct3[16], uint8_t ct4[16],
				uint8_t ct5[16], uint8_t ct6[16], uint8_t ct7[16], uint8_t ct8[16])
{
#if !defined(MQOM2_FOR_MUPQ_AES_GENERIC_KEYSCHEDULE)
	int ret = 0;
	ret |= enc_encrypt_x4(ctx1, ctx2, ctx3, ctx4, pt1, pt2, pt3, pt4, ct1, ct2, ct3, ct4);
	ret |= enc_encrypt_x4(ctx5, ctx6, ctx7, ctx8, pt5, pt6, pt7, pt8, ct5, ct6, ct7, ct8);
	return ret;
#else
	if((ctx1 == ctx2) && (ctx2 == ctx3) && (ctx3 == ctx4) && (ctx4 == ctx5) && (ctx5 == ctx6) && (ctx6 == ctx7) && (ctx7 == ctx8)){
		uint8_t pt[128];
		uint8_t ct[128];

		memcpy(&pt[0],   pt1, 16);
		memcpy(&pt[16],  pt2, 16);
		memcpy(&pt[32],  pt3, 16);
		memcpy(&pt[48],  pt4, 16);
		memcpy(&pt[64],  pt5, 16);
		memcpy(&pt[80],  pt6, 16);
		memcpy(&pt[96],  pt7, 16);
		memcpy(&pt[112], pt8, 16);

		aes128_ecb(ct, pt, 8, &ctx1->ctx_priv);

		memcpy(ct1, &ct[0] ,  16);
		memcpy(ct2, &ct[16],  16);
		memcpy(ct3, &ct[32],  16);
		memcpy(ct4, &ct[48],  16);
		memcpy(ct5, &ct[64],  16);
		memcpy(ct6, &ct[80],  16);
		memcpy(ct7, &ct[96],  16);
		memcpy(ct8, &ct[112], 16);
	}
	else{
		enc_encrypt_x4(ctx1, ctx2, ctx3, ctx4, pt1, pt2, pt3, pt4, ct1, ct2, ct3, ct4);
		enc_encrypt_x4(ctx5, ctx6, ctx7, ctx8, pt5, pt6, pt7, pt8, ct5, ct6, ct7, ct8);
	}
	return 0;
#endif
}
#else
/*************************************/
/********** Local ********************/
/*************************************/
/* Our block encryption is based on Rijndael variants */
#include "rijndael.h"
/* For 128 bits security, we transparently use AES-128 */
#define enc_ctx rijndael_ctx_aes128
#define enc_key_sched aes128_setkey_enc
#define enc_encrypt aes128_enc
#define enc_encrypt_x2 aes128_enc_x2
#define enc_encrypt_x4 aes128_enc_x4
#define enc_encrypt_x8 aes128_enc_x8
#endif


/* === 192 bits security === */
#elif MQOM2_PARAM_SECURITY == 192
/* Our block encryption is based on Rijndael variants */
#include "rijndael.h"

#define enc_ctx rijndael_ctx_rijndael256

/* Specifically for 192 bits, we need to adapt the underlying calls
 * as we use Rijndael-256-256 with expansion and truncation
 * */
static inline int enc_key_sched(enc_ctx *ctx, const uint8_t key[24])
{
	/* Key expansion key || O^64 */
	uint8_t exp_key[32] = { 0 };
	memcpy(exp_key, key, 24);

	/* Execute the Rijndael-256-256 key schedule */
	return rijndael256_setkey_enc(ctx, exp_key);
}

static inline int enc_encrypt(const enc_ctx *ctx, const uint8_t pt[24], uint8_t ct[24])
{
	int ret = -1;

	/* Plaintext expansion pt || 0^64 */
	uint8_t exp_pt[32] = { 0 }, exp_ct[32];
	memcpy(exp_pt, pt, 24);

	/* Encrypt */
	ret = rijndael256_enc(ctx, exp_pt, exp_ct); ERR(ret, err);

	/* Truncate the output */
	memcpy(ct, exp_ct, 24);

	ret = 0;
err:
	return ret;
}

static inline int enc_encrypt_x2(const enc_ctx *ctx1, const enc_ctx *ctx2, const uint8_t pt1[24], const uint8_t pt2[24], uint8_t ct1[24], uint8_t ct2[24])
{
	int ret = -1;

	/* Plaintext expansion pt || 0^64 */
	uint8_t exp_pt[2][32] = { 0 }, exp_ct[2][32];
	memcpy(exp_pt[0], pt1, 24);
	memcpy(exp_pt[1], pt2, 24);
	/* Encrypt */
	ret = rijndael256_enc_x2(ctx1, ctx2, exp_pt[0], exp_pt[1], exp_ct[0], exp_ct[1]); ERR(ret, err);

	/* Truncate the output */
	memcpy(ct1, exp_ct[0], 24);
	memcpy(ct2, exp_ct[1], 24);

	ret = 0;
err:
	return ret;
}

static inline int enc_encrypt_x4(const enc_ctx *ctx1, const enc_ctx *ctx2, const enc_ctx *ctx3, const enc_ctx *ctx4,
				const uint8_t pt1[24], const uint8_t pt2[24], const uint8_t pt3[24], const uint8_t pt4[24],
				uint8_t ct1[24], uint8_t ct2[24], uint8_t ct3[24], uint8_t ct4[24])
{
	int ret = -1;

	/* Plaintext expansion pt || 0^64 */
	uint8_t exp_pt[4][32] = { 0 }, exp_ct[4][32];
	memcpy(exp_pt[0], pt1, 24);
	memcpy(exp_pt[1], pt2, 24);
	memcpy(exp_pt[2], pt3, 24);
	memcpy(exp_pt[3], pt4, 24);

	/* Encrypt */
	ret = rijndael256_enc_x4(ctx1, ctx2, ctx3, ctx4, exp_pt[0], exp_pt[1], exp_pt[2], exp_pt[3], exp_ct[0], exp_ct[1], exp_ct[2], exp_ct[3]);
	ERR(ret, err);

	/* Truncate the output */
	memcpy(ct1, exp_ct[0], 24);
	memcpy(ct2, exp_ct[1], 24);
	memcpy(ct3, exp_ct[2], 24);
	memcpy(ct4, exp_ct[3], 24);

	ret = 0;
err:
	return ret;
}

static inline int enc_encrypt_x8(const enc_ctx *ctx1, const enc_ctx *ctx2, const enc_ctx *ctx3, const enc_ctx *ctx4,
				const enc_ctx *ctx5, const enc_ctx *ctx6, const enc_ctx *ctx7, const enc_ctx *ctx8,
				const uint8_t pt1[24], const uint8_t pt2[24], const uint8_t pt3[24], const uint8_t pt4[24],
				const uint8_t pt5[24], const uint8_t pt6[24], const uint8_t pt7[24], const uint8_t pt8[24],
				uint8_t ct1[24], uint8_t ct2[24], uint8_t ct3[24], uint8_t ct4[24],
				uint8_t ct5[24], uint8_t ct6[24], uint8_t ct7[24], uint8_t ct8[24])
{
	int ret = -1;

	/* Plaintext expansion pt || 0^64 */
	uint8_t exp_pt[8][32] = { 0 }, exp_ct[8][32];
	memcpy(exp_pt[0], pt1, 24);
	memcpy(exp_pt[1], pt2, 24);
	memcpy(exp_pt[2], pt3, 24);
	memcpy(exp_pt[3], pt4, 24);
	memcpy(exp_pt[4], pt5, 24);
	memcpy(exp_pt[5], pt6, 24);
	memcpy(exp_pt[6], pt7, 24);
	memcpy(exp_pt[7], pt8, 24);

	/* Encrypt */
	ret = rijndael256_enc_x8(ctx1, ctx2, ctx3, ctx4, ctx5, ctx6, ctx7, ctx8,
				 exp_pt[0], exp_pt[1], exp_pt[2], exp_pt[3], exp_pt[4], exp_pt[5], exp_pt[6], exp_pt[7],
				 exp_ct[0], exp_ct[1], exp_ct[2], exp_ct[3], exp_ct[4], exp_ct[5], exp_ct[6], exp_ct[7]);
	ERR(ret, err);

	/* Truncate the output */
	memcpy(ct1, exp_ct[0], 24);
	memcpy(ct2, exp_ct[1], 24);
	memcpy(ct3, exp_ct[2], 24);
	memcpy(ct4, exp_ct[3], 24);
	memcpy(ct5, exp_ct[4], 24);
	memcpy(ct6, exp_ct[5], 24);
	memcpy(ct7, exp_ct[6], 24);
	memcpy(ct8, exp_ct[7], 24);

	ret = 0;
err:
	return ret;
}

/* === 256 bits security === */
#elif MQOM2_PARAM_SECURITY == 256
/* Our block encryption is based on Rijndael variants */
#include "rijndael.h"

#define enc_ctx rijndael_ctx_rijndael256

/* For 256 bits security, we tyransparently use Rijndael-256-256 */
#define enc_key_sched rijndael256_setkey_enc
#define enc_encrypt rijndael256_enc
#define enc_encrypt_x2 rijndael256_enc_x2
#define enc_encrypt_x4 rijndael256_enc_x4
#define enc_encrypt_x8 rijndael256_enc_x8

#else

#error "Sorry, unsupported security parameters: must be one of 128, 192, 256"
#endif


#endif /* __ENC_H__ */
