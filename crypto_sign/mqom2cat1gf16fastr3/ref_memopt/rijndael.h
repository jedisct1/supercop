#ifndef __RIJNDAEL_H__
#define __RIJNDAEL_H__

#include "rijndael_platform.h"

#if defined(RIJNDAEL_CONSTANT_TIME_REF)
#if defined(RIJNDAEL_AES_NI) || defined(RIJNDAEL_BITSLICE) || defined(RIJNDAEL_TABLE)
#error "RIJNDAEL_CONSTANT_TIME_REF, RIJNDAEL_TABLE, RIJNDAEL_BITSLICE and RIJNDAEL_AES_NI are exclusive!"
#endif
#endif
#if defined(RIJNDAEL_AES_NI)
#if defined(RIJNDAEL_CONSTANT_TIME_REF) || defined(RIJNDAEL_BITSLICE) || defined(RIJNDAEL_TABLE)
#error "RIJNDAEL_CONSTANT_TIME_REF, RIJNDAEL_TABLE, RIJNDAEL_BITSLICE and RIJNDAEL_AES_NI are exclusive!"
#endif
#endif
#if defined(RIJNDAEL_BITSLICE)
#if defined(RIJNDAEL_AES_NI) || defined(RIJNDAEL_CONSTANT_TIME_REF) || defined(RIJNDAEL_TABLE)
#error "RIJNDAEL_CONSTANT_TIME_REF, RIJNDAEL_TABLE, RIJNDAEL_BITSLICE and RIJNDAEL_AES_NI are exclusive!"
#endif
#endif
#if defined(RIJNDAEL_TABLE)
#if defined(RIJNDAEL_AES_NI) || defined(RIJNDAEL_BITSLICE) || defined(RIJNDAEL_CONSTANT_TIME_REF)
#error "RIJNDAEL_CONSTANT_TIME_REF, RIJNDAEL_TABLE, RIJNDAEL_BITSLICE and RIJNDAEL_AES_NI are exclusive!"
#endif
#endif

/* === Constant time ref case */
#if defined(RIJNDAEL_CONSTANT_TIME_REF)
#include "rijndael_ref.h"
#define rijndael_ctx_aes128 rijndael_ref_ctx_aes128
#define rijndael_ctx_aes256 rijndael_ref_ctx_aes256
#define rijndael_ctx_rijndael256 rijndael_ref_ctx_rijndael256
#define aes128_setkey_enc aes128_ref_setkey_enc
#define aes256_setkey_enc aes256_ref_setkey_enc
#define rijndael256_setkey_enc rijndael256_ref_setkey_enc
#define aes128_enc aes128_ref_enc
#define aes256_enc aes256_ref_enc
#define rijndael256_enc rijndael256_ref_enc
#define aes128_enc_x2 aes128_ref_enc_x2
#define aes128_enc_x4 aes128_ref_enc_x4
#define aes128_enc_x8 aes128_ref_enc_x8
#define aes256_enc_x2 aes256_ref_enc_x2
#define aes256_enc_x4 aes256_ref_enc_x4
#define aes256_enc_x8 aes256_ref_enc_x8
#define rijndael256_enc_x2 rijndael256_ref_enc_x2
#define rijndael256_enc_x4 rijndael256_ref_enc_x4
#define rijndael256_enc_x8 rijndael256_ref_enc_x8
static const char rijndael_conf[] = "Rijndael ref (constant time, slow)";
#endif

/* === Constant time bitslice case */
#if defined(RIJNDAEL_BITSLICE)
#include "rijndael_ct64.h"
#define rijndael_ctx_aes128 rijndael_ct64_ctx_aes128
#define rijndael_ctx_aes256 rijndael_ct64_ctx_aes256
#define rijndael_ctx_rijndael256 rijndael_ct64_ctx_rijndael256
#define aes128_setkey_enc aes128_ct64_setkey_enc
#define aes256_setkey_enc aes256_ct64_setkey_enc
#define rijndael256_setkey_enc rijndael256_ct64_setkey_enc
#define aes128_enc aes128_ct64_enc
#define aes256_enc aes256_ct64_enc
#define rijndael256_enc rijndael256_ct64_enc
#define aes128_enc_x2 aes128_ct64_enc_x2
#define aes128_enc_x4 aes128_ct64_enc_x4
#define aes128_enc_x8 aes128_ct64_enc_x8
#define aes256_enc_x2 aes256_ct64_enc_x2
#define aes256_enc_x4 aes256_ct64_enc_x4
#define aes256_enc_x8 aes256_ct64_enc_x8
#define rijndael256_enc_x2 rijndael256_ct64_enc_x2
#define rijndael256_enc_x4 rijndael256_ct64_enc_x4
#define rijndael256_enc_x8 rijndael256_ct64_enc_x8
#if defined(RIJNDAEL_OPT_ARMV7M)
static const char rijndael_conf[] = "Rijndael bitslice (constant time) (Variant ASM optimized for ARMv7M micro-architecture)";
#else
static const char rijndael_conf[] = "Rijndael bitslice (constant time) (pure C)";
#endif
#endif

/* === Non-constant time table case */
#if defined(RIJNDAEL_TABLE)
#include "rijndael_table.h"
#define rijndael_ctx_aes128 rijndael_table_ctx_aes128
#define rijndael_ctx_aes256 rijndael_table_ctx_aes256
#define rijndael_ctx_rijndael256 rijndael_table_ctx_rijndael256
#define aes128_setkey_enc aes128_table_setkey_enc
#define aes256_setkey_enc aes256_table_setkey_enc
#define rijndael256_setkey_enc rijndael256_table_setkey_enc
#define aes128_enc aes128_table_enc
#define aes256_enc aes256_table_enc
#define rijndael256_enc rijndael256_table_enc
#define aes128_enc_x2 aes128_table_enc_x2
#define aes128_enc_x4 aes128_table_enc_x4
#define aes128_enc_x8 aes128_table_enc_x8
#define aes256_enc_x2 aes256_table_enc_x2
#define aes256_enc_x4 aes256_table_enc_x4
#define aes256_enc_x8 aes256_table_enc_x8
#define rijndael256_enc_x2 rijndael256_table_enc_x2
#define rijndael256_enc_x4 rijndael256_table_enc_x4
#define rijndael256_enc_x8 rijndael256_table_enc_x8
#if defined(RIJNDAEL_OPT_ARMV7M)
static const char rijndael_conf[] = "Rijndael table (usually NON constant time, constant time on embedded platforms without cache to SRAM) (Variant ASM optimized for ARMv7M micro-architecture)";
#else
static const char rijndael_conf[] = "Rijndael table (usually NON constant time, constant time on embedded platforms without cache to SRAM) (pure C)";
#endif
#endif

/* === Constant time AES-NI case (supposes AES-NI x86 support) */
#if defined(RIJNDAEL_AES_NI)
#include "rijndael_aes_ni.h"
#define rijndael_ctx_aes128 rijndael_aes_ni_ctx_aes128
#define rijndael_ctx_aes256 rijndael_aes_ni_ctx_aes256
#define rijndael_ctx_rijndael256 rijndael_aes_ni_ctx_rijndael256
#define aes128_setkey_enc aes128_aes_ni_setkey_enc
#define aes256_setkey_enc aes256_aes_ni_setkey_enc
#define rijndael256_setkey_enc rijndael256_aes_ni_setkey_enc
#define aes128_enc aes128_aes_ni_enc
#define aes256_enc aes256_aes_ni_enc
#define rijndael256_enc rijndael256_aes_ni_enc
#define aes128_enc_x2 aes128_aes_ni_enc_x2
#define aes128_enc_x4 aes128_aes_ni_enc_x4
#define aes128_enc_x8 aes128_aes_ni_enc_x8
#define aes256_enc_x2 aes256_aes_ni_enc_x2
#define aes256_enc_x4 aes256_aes_ni_enc_x4
#define aes256_enc_x8 aes256_aes_ni_enc_x8
#define rijndael256_enc_x2 rijndael256_aes_ni_enc_x2
#define rijndael256_enc_x4 rijndael256_aes_ni_enc_x4
#define rijndael256_enc_x8 rijndael256_aes_ni_enc_x8
static const char rijndael_conf[] = "Rijndael AES-NI (constant time, x86 dedicated)";
#endif

/* ==== Public API ==== */

int aes128_setkey_enc(rijndael_ctx_aes128 *ctx, const uint8_t key[16]);
int aes256_setkey_enc(rijndael_ctx_aes256 *ctx, const uint8_t key[32]);
int rijndael256_setkey_enc(rijndael_ctx_rijndael256 *ctx, const uint8_t key[32]);
int aes128_enc(const rijndael_ctx_aes128 *ctx, const uint8_t data_in[16], uint8_t data_out[16]);
int aes256_enc(const rijndael_ctx_aes256 *ctx, const uint8_t data_in[16], uint8_t data_out[16]);
int rijndael256_enc(const rijndael_ctx_rijndael256 *ctx, const uint8_t data_in[32], uint8_t data_out[32]);
/* x2, x4 and x8 encryption APIs */
/* == */
int aes128_enc_x2(const rijndael_ctx_aes128 *ctx1, const rijndael_ctx_aes128 *ctx2, const uint8_t plainText1[16], const uint8_t plainText2[16], uint8_t cipherText1[16], uint8_t cipherText2[16]);
int aes128_enc_x4(const rijndael_ctx_aes128 *ctx1, const rijndael_ctx_aes128 *ctx2, const rijndael_ctx_aes128 *ctx3, const rijndael_ctx_aes128 *ctx4,
                const uint8_t plainText1[16], const uint8_t plainText2[16], const uint8_t plainText3[16], const uint8_t plainText4[16],
                uint8_t cipherText1[16], uint8_t cipherText2[16], uint8_t cipherText3[16], uint8_t cipherText4[16]);
int aes128_enc_x8(const rijndael_ctx_aes128 *ctx1, const rijndael_ctx_aes128 *ctx2, const rijndael_ctx_aes128 *ctx3, const rijndael_ctx_aes128 *ctx4,
                  const rijndael_ctx_aes128 *ctx5, const rijndael_ctx_aes128 *ctx6, const rijndael_ctx_aes128 *ctx7, const rijndael_ctx_aes128 *ctx8,
                const uint8_t plainText1[16], const uint8_t plainText2[16], const uint8_t plainText3[16], const uint8_t plainText4[16],
                const uint8_t plainText5[16], const uint8_t plainText6[16], const uint8_t plainText7[16], const uint8_t plainText8[16],
                uint8_t cipherText1[16], uint8_t cipherText2[16], uint8_t cipherText3[16], uint8_t cipherText4[16],
                uint8_t cipherText5[16], uint8_t cipherText6[16], uint8_t cipherText7[16], uint8_t cipherText8[16]);
/* == */
int aes256_enc_x2(const rijndael_ctx_aes256 *ctx1, const rijndael_ctx_aes256 *ctx2, const uint8_t plainText1[16], const uint8_t plainText2[16], uint8_t cipherText1[16], uint8_t cipherText2[16]);
int aes256_enc_x4(const rijndael_ctx_aes256 *ctx1, const rijndael_ctx_aes256 *ctx2, const rijndael_ctx_aes256 *ctx3, const rijndael_ctx_aes256 *ctx4,
                const uint8_t plainText1[16], const uint8_t plainText2[16], const uint8_t plainText3[16], const uint8_t plainText4[16],
                uint8_t cipherText1[16], uint8_t cipherText2[16], uint8_t cipherText3[16], uint8_t cipherText4[16]);
int aes256_enc_x8(const rijndael_ctx_aes256 *ctx1, const rijndael_ctx_aes256 *ctx2, const rijndael_ctx_aes256 *ctx3, const rijndael_ctx_aes256 *ctx4,
		  const rijndael_ctx_aes256 *ctx5, const rijndael_ctx_aes256 *ctx6, const rijndael_ctx_aes256 *ctx7, const rijndael_ctx_aes256 *ctx8,
                const uint8_t plainText1[16], const uint8_t plainText2[16], const uint8_t plainText3[16], const uint8_t plainText4[16],
                const uint8_t plainText5[16], const uint8_t plainText6[16], const uint8_t plainText7[16], const uint8_t plainText8[16],
                uint8_t cipherText1[16], uint8_t cipherText2[16], uint8_t cipherText3[16], uint8_t cipherText4[16],
                uint8_t cipherText5[16], uint8_t cipherText6[16], uint8_t cipherText7[16], uint8_t cipherText8[16]);
/* == */
int rijndael256_enc_x2(const rijndael_ctx_rijndael256 *ctx1, const rijndael_ctx_rijndael256 *ctx2,
                        const uint8_t plainText1[32], const uint8_t plainText2[32],
                        uint8_t cipherText1[32], uint8_t cipherText2[32]);
int rijndael256_enc_x4(const rijndael_ctx_rijndael256 *ctx1, const rijndael_ctx_rijndael256 *ctx2, const rijndael_ctx_rijndael256 *ctx3, const rijndael_ctx_rijndael256 *ctx4,
                const uint8_t plainText1[32], const uint8_t plainText2[32], const uint8_t plainText3[32], const uint8_t plainText4[32],
                uint8_t cipherText1[32], uint8_t cipherText2[32], uint8_t cipherText3[32], uint8_t cipherText4[32]);
int rijndael256_enc_x8(const rijndael_ctx_rijndael256 *ctx1, const rijndael_ctx_rijndael256 *ctx2, const rijndael_ctx_rijndael256 *ctx3, const rijndael_ctx_rijndael256 *ctx4,
		  const rijndael_ctx_rijndael256 *ctx5, const rijndael_ctx_rijndael256 *ctx6, const rijndael_ctx_rijndael256 *ctx7, const rijndael_ctx_rijndael256 *ctx8,
                const uint8_t plainText1[32], const uint8_t plainText2[32], const uint8_t plainText3[32], const uint8_t plainText4[32],
                const uint8_t plainText5[32], const uint8_t plainText6[32], const uint8_t plainText7[32], const uint8_t plainText8[32],
                uint8_t cipherText1[32], uint8_t cipherText2[32], uint8_t cipherText3[32], uint8_t cipherText4[32],
                uint8_t cipherText5[32], uint8_t cipherText6[32], uint8_t cipherText7[32], uint8_t cipherText8[32]);

#endif /* __RIJNDAEL_H__ */
