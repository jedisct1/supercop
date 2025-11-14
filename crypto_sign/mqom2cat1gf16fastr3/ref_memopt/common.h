#ifndef __COMMON_H__
#define __COMMON_H__

/* MQOM2 parameters */
#include "mqom2_parameters.h"
#include <string.h>
#include <stdint.h>

#if !defined(NO_EMBEDDED_SRAM_SECTION)
/* Some macro useful for global variables space accounting in SRAM */
#define EMBEDDED_SRAM __attribute__((section(".embedded_sram_tables")))
#endif

/* Malloc redirection to allow for max allocation accounting */
#if defined(BENCHMARK) || defined(BENCHMARK_CYCLES) || defined(BENCHMARK_TIME)
#include <stdio.h>
#include <stdlib.h>
#define MAX_TRACKED_POINTERS 100
typedef struct {
	void *ptr;
	size_t size;
	uint8_t alive;
} living_pointer;

__attribute__((weak)) living_pointer living_pointers[MAX_TRACKED_POINTERS] = { 0 };

__attribute__((weak)) long int alloc_peak_usage = 0;

static void update_alloc_stats(void)
{
	long int alloc_current_usage = 0;
	unsigned int i;
	for(i = 0; i < MAX_TRACKED_POINTERS; i++){
		if(living_pointers[i].alive){
			alloc_current_usage += living_pointers[i].size;
		}
	}
	if(alloc_current_usage > alloc_peak_usage){
		alloc_peak_usage = alloc_current_usage;
	}
}

static inline void *mqom_malloc(size_t size){
	/* XXX: we always malloc on aligned 64 bits boundaries */
	void *ptr = malloc(size);
	if(ptr != NULL){
		/* Find a suitable slot */
		unsigned int i;
		for(i = 0; i < MAX_TRACKED_POINTERS; i++){
			if(!living_pointers[i].alive){
				break;
			}
		}
		if(i == MAX_TRACKED_POINTERS){
			/* No more space ... */
			printf("[-] WARNING: no more slots available to track malloc!\r\n");
			goto out;
		}
		living_pointers[i].alive = 1;
		living_pointers[i].ptr = ptr;
		living_pointers[i].size = size;
	}
out:
	update_alloc_stats();
	return ptr;
}

static inline void *mqom_calloc(size_t nmemb, size_t size){
	void *ptr = calloc(nmemb, size);
	size = nmemb * size;
	if(ptr != NULL){
		/* Find a suitable slot */
		unsigned int i;
		for(i = 0; i < MAX_TRACKED_POINTERS; i++){
			if(!living_pointers[i].alive){
				break;
			}
		}
		if(i == MAX_TRACKED_POINTERS){
			/* No more space ... */
			printf("[-] WARNING: no more slots available to track malloc!\r\n");
			goto out;
		}
		living_pointers[i].alive = 1;
		living_pointers[i].ptr = ptr;
		living_pointers[i].size = size;
	}
out:
	update_alloc_stats();
	return ptr;
}

static inline void mqom_free(void *ptr){
	if(ptr != NULL){
		/* Find the slot */
		unsigned int i;
		for(i = 0; i < MAX_TRACKED_POINTERS; i++){
			if(living_pointers[i].ptr == ptr){
				break;
			}
		}
		if((i == MAX_TRACKED_POINTERS) || (!living_pointers[i].alive)){
			/* Should not happen ... */
			printf("[-] WARNING: internal error in malloc tracking ...\r\n");
			goto out;
		}
		living_pointers[i].alive = 0;
		living_pointers[i].ptr = NULL;
		living_pointers[i].size = 0;
	}
out:
	free(ptr);
	update_alloc_stats();
}

#define reset_alloc_usage() do { \
	memset(living_pointers, 0, MAX_TRACKED_POINTERS * sizeof(living_pointer)); \
	alloc_peak_usage = 0; \
} while(0);

#define print_alloc_usage(s) do { \
	printf("[+] Malloc stats %s: Peak Usage is %ld bytes\r\n", s, alloc_peak_usage); \
} while(0);

#else
#define mqom_malloc malloc
#define mqom_calloc calloc
#define mqom_free free
#define reset_alloc_usage()
#define print_alloc_usage(s)
#endif

#undef ERR
#define ERR(r, e) if(r) { goto e; }

/* Helpers to compute some sizes of serialized objects */
#define MQOM2_PK_SIZE ((2 * MQOM2_PARAM_SEED_SIZE) + BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_MQ_M/MQOM2_PARAM_MU))
#define MQOM2_SK_SIZE ((2 * MQOM2_PARAM_SEED_SIZE) + BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_MQ_M/MQOM2_PARAM_MU) + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N))
#define MQOM2_PARAM_OPENING_SIZE (MQOM2_PARAM_TAU*(                           \
    BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE              \
      + MQOM2_PARAM_NB_EVALS_LOG*MQOM2_PARAM_SEED_SIZE                        \
      + MQOM2_PARAM_DIGEST_SIZE                                               \
))
#define MQOM2_SIG_SIZE (                                                      \
    4 + MQOM2_PARAM_TAU*BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_ETA*MQOM2_PARAM_MU)  \
      + (MQOM2_PARAM_SALT_SIZE) + (2*(MQOM2_PARAM_DIGEST_SIZE))               \
      + MQOM2_PARAM_OPENING_SIZE                                              \
)

/* Endianness detection:
 * Return 1 if architecture is big endian, 0 otherwise. 
 */
static inline int arch_is_big_endian(void)
{
        const uint16_t val = 0x0102;
        const uint8_t *buf = (const uint8_t *)(&val);

        return (buf[0] == 0x01);
}


/* Salt tweaking primitive */
static inline void TweakSalt(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], uint8_t tweaked_salt[MQOM2_PARAM_SALT_SIZE], uint8_t sel, uint8_t e, uint16_t j)
{
        /* The tweak only consists in xoring the salt with the counter */
        memcpy(tweaked_salt, salt, MQOM2_PARAM_SALT_SIZE);
        tweaked_salt[0] ^= sel + 4*e;
        tweaked_salt[1] ^= j & 0xff;
        tweaked_salt[2] ^= (j>>8) & 0xff;
        return;
}

/* LinOrtho primitive */
static inline void LinOrtho(const uint8_t seed[MQOM2_PARAM_SEED_SIZE], uint8_t linortho_seed[MQOM2_PARAM_SEED_SIZE])
{
        unsigned int i;
        memcpy(&linortho_seed[0], &seed[MQOM2_PARAM_SEED_SIZE / 2], MQOM2_PARAM_SEED_SIZE / 2);
        memcpy(&linortho_seed[MQOM2_PARAM_SEED_SIZE / 2], &seed[0], MQOM2_PARAM_SEED_SIZE / 2);

        for(i = 0; i < MQOM2_PARAM_SEED_SIZE / 2; i++){
                linortho_seed[i] ^= seed[i];
        }

        return;
}

/* Helper to xor MQOM2_PARAM_SEED_SIZE elements 
 * NOTE: since we do not have information about alignment, we must
 * copy this to aligned buffers and do this on 64 bits, this will
 * hopefully trigger the compiler vectorization
 */
static inline void xor_blocks(const uint8_t seed_in[MQOM2_PARAM_SEED_SIZE], const uint8_t delta[MQOM2_PARAM_SEED_SIZE], uint8_t seed_out[MQOM2_PARAM_SEED_SIZE]){
        unsigned int i;
        uint64_t s[3][MQOM2_PARAM_SEED_SIZE / 8];

        memcpy(&s[0], seed_in, MQOM2_PARAM_SEED_SIZE);
        memcpy(&s[1], delta, MQOM2_PARAM_SEED_SIZE);

        for(i = 0; i < MQOM2_PARAM_SEED_SIZE / 8; i++){
                s[2][i] = s[0][i] ^ s[1][i];
        }

        memcpy(seed_out, &s[2], MQOM2_PARAM_SEED_SIZE);

        return;
}

#endif /* __COMMON_H__ */
