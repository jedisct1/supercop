#ifndef __PRG_H__
#define __PRG_H__

/* MQOM2 parameters */
#include "mqom2_parameters.h"
/* Our PRG is based on a block cipher defined in the following header */
#include "enc.h"
#include "prg_cache.h"

int PRG_memopt(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], uint32_t e, const uint8_t seed[MQOM2_PARAM_SEED_SIZE], uint32_t start_nbytes, uint32_t nbytes, uint8_t *out_data, uint8_t in_out_leftover[MQOM2_PARAM_SEED_SIZE], prg_key_sched_cache *cache);

int PRG(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], uint32_t e, const uint8_t seed[MQOM2_PARAM_SEED_SIZE], uint32_t nbytes, uint8_t *out_data, prg_key_sched_cache *cache);

int PRG_x4(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], const uint32_t* e, const uint8_t seed[4][MQOM2_PARAM_SEED_SIZE], uint32_t nbytes, uint8_t* out_data[4], prg_key_sched_cache** cache, uint8_t nb_contexts);

int PRG_x8(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], const uint32_t *e, const uint8_t seed[8][MQOM2_PARAM_SEED_SIZE], uint32_t nbytes, uint8_t* out_data[8], prg_key_sched_cache** cache, uint8_t nb_contexts);

#endif /* __PRG_H__ */
