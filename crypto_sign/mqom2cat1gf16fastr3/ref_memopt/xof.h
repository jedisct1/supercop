#ifndef __XOF_H__
#define __XOF_H__

#include "mqom2_parameters.h"

/*************************************/
/********** Local ********************/
/*************************************/
#if !defined(MQOM2_FOR_MUPQ)
#include <stdint.h>
/* Include the underlying Keccak header for hash and XOF */
#include "KeccakHash.h"
#include "KeccakHashtimes4.h"

/* For common helpers */
#include "common.h"

/* Depending on the parameter, the instances are different:
 *   - For 128 bits security, we use SHAKE-128 for XOF
 *   - For 192 bits security, we use SHAKE-256 for XOF
 *   - For 256 bits security, we use SHAKE-256 for XOF
 */
/* === 128 bits security === */
#if MQOM2_PARAM_SECURITY == 128
#define _XOF_Init Keccak_HashInitialize_SHAKE128
#define _XOF_Init_x4 Keccak_HashInitializetimes4_SHAKE128
/* === 192 bits security === */
#elif MQOM2_PARAM_SECURITY == 192
#define _XOF_Init Keccak_HashInitialize_SHAKE256
#define _XOF_Init_x4 Keccak_HashInitializetimes4_SHAKE256
/* === 256 bits security === */
#elif MQOM2_PARAM_SECURITY == 256
#define _XOF_Init Keccak_HashInitialize_SHAKE256
#define _XOF_Init_x4 Keccak_HashInitializetimes4_SHAKE256
#else
#error "No XOF implementation for this security level"
#endif
/* Common defines for XOF */
#define _XOF_Update Keccak_HashUpdate
#define _XOF_Update_x4 Keccak_HashUpdatetimes4
#define _XOF_Final Keccak_HashFinal
#define _XOF_Final_x4 Keccak_HashFinaltimes4
#define _XOF_Squeeze Keccak_HashSqueeze
#define _XOF_Squeeze_x4 Keccak_HashSqueezetimes4

/*************************************/
/********** MUPQ API *****************/
/*************************************/
#else
#include "fips202.h"
/* For common helpers */
#include "common.h"
/* Depending on the parameter, the instances are different:
 *   - For 128 bits security, we use SHAKE-128 for XOF 
 *   - For 192 bits security, we use SHAKE-256 for XOF
 *   - For 256 bits security, we use SHAKE-256 for XOF
 */
/* === 128 bits security === */
#if MQOM2_PARAM_SECURITY == 128
#define Keccak_HashInstance shake128incctx
#define __XOF_Init shake128_inc_init
#define __XOF_Update shake128_inc_absorb
#define __XOF_Final shake128_inc_finalize
#define __XOF_Squeeze shake128_inc_squeeze
/* === 192 bits security === */
#elif MQOM2_PARAM_SECURITY == 192
#define Keccak_HashInstance shake256incctx
#define __XOF_Init shake256_inc_init
#define __XOF_Update shake256_inc_absorb
#define __XOF_Final shake256_inc_finalize
#define __XOF_Squeeze shake256_inc_squeeze
/* === 256 bits security === */
#elif MQOM2_PARAM_SECURITY == 256
#define Keccak_HashInstance shake256incctx
#define __XOF_Init shake256_inc_init
#define __XOF_Update shake256_inc_absorb
#define __XOF_Final shake256_inc_finalize
#define __XOF_Squeeze shake256_inc_squeeze
#else
#error "No XOF implementation for this security level"
#endif

typedef struct {
	Keccak_HashInstance ctx[4];
} Keccak_HashInstancetimes4;

/**/
static inline int _XOF_Init(Keccak_HashInstance *ctx){
	__XOF_Init(ctx);
	return 0;
}
static inline int _XOF_Init_x4(Keccak_HashInstancetimes4 *ctx){
	unsigned int i;
	for(i = 0; i < 4; i++){
		__XOF_Init(&ctx->ctx[i]);
	}
	return 0;
}
/**/
static inline int _XOF_Update(Keccak_HashInstance *ctx, const uint8_t* data, size_t byte_len){
	__XOF_Update(ctx, data, byte_len >> 3);
	return 0;
}
static inline int _XOF_Update_x4(Keccak_HashInstancetimes4 *ctx, const uint8_t *data[4], size_t byte_len){
	unsigned int i;
	for(i = 0; i < 4; i++){
		__XOF_Update(&ctx->ctx[i], data[i], byte_len >> 3);
	}
	return 0;
}
/**/
static inline int _XOF_Squeeze(Keccak_HashInstance *ctx, uint8_t* data, size_t byte_len){
	__XOF_Squeeze(data, byte_len >> 3, ctx);
	return 0;
}
static inline int _XOF_Squeeze_x4(Keccak_HashInstancetimes4 *ctx, uint8_t *data[4], size_t byte_len){
	unsigned int i;
	for(i = 0; i < 4; i++){
		__XOF_Squeeze(data[i], byte_len >> 3, &ctx->ctx[i]);
	}
	return 0;
}
/**/
static inline int _XOF_Final(Keccak_HashInstance *ctx, const uint8_t* dummy){
	(void)dummy;
	__XOF_Final(ctx);
	return 0;
}
static inline int _XOF_Final_x4(Keccak_HashInstancetimes4 *ctx, const uint8_t* dummy){
	unsigned int i;
	(void)dummy;
	for(i = 0; i < 4; i++){
		__XOF_Final(&ctx->ctx[i]);
	}
	return 0;
}
#endif

/* Hash and XOF contexts are simply Keccak instances, with XOF finalization state
 * for XOF
 */
typedef struct {
	uint8_t xof_finalized;
	Keccak_HashInstance ctx;
} xof_context;

/* x4 (4 times) context */
typedef struct {
	uint8_t xof_finalized;
	Keccak_HashInstancetimes4 ctx;
} xof_context_x4;

/* Exported API for XOF, simple and x4 */
int xof_init(xof_context *ctx);
int xof_update(xof_context *ctx, const uint8_t *data, size_t byte_len);
int xof_squeeze(xof_context *ctx, uint8_t *out, uint32_t byte_len);

int xof_init_x4(xof_context_x4 *ctx);
int xof_update_x4(xof_context_x4 *ctx, const uint8_t *data[4], size_t byte_len);
int xof_squeeze_x4(xof_context_x4 *ctx, uint8_t *out[4], uint32_t byte_len);



#endif /* __HASH_XOF_H__ */
