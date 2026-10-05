#ifndef FIPS202X4_H
#define FIPS202X4_H

#include "fips202.h"

#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>

#define FIPS202X4_NAMESPACE(s) fips202x4_##s

typedef struct {
    __m256i s[25];
} keccakx4_state;

#define shake128x4_absorb_once FIPS202X4_NAMESPACE(shake128x4_absorb_once)
void shake128x4_absorb_once(keccakx4_state *state, const uint8_t *in0,
                            const uint8_t *in1, const uint8_t *in2,
                            const uint8_t *in3, size_t inlen);

#define shake128x4_squeezeblocks FIPS202X4_NAMESPACE(shake128x4_squeezeblocks)
void shake128x4_squeezeblocks(uint8_t *out0, uint8_t *out1, uint8_t *out2,
                              uint8_t *out3, size_t nblocks,
                              keccakx4_state *state);

#define shake256x4_absorb_once FIPS202X4_NAMESPACE(shake256x4_absorb_once)
void shake256x4_absorb_once(keccakx4_state *state, const uint8_t *in0,
                            const uint8_t *in1, const uint8_t *in2,
                            const uint8_t *in3, size_t inlen);

#define shake256x4_squeezeblocks FIPS202X4_NAMESPACE(shake256x4_squeezeblocks)
void shake256x4_squeezeblocks(uint8_t *out0, uint8_t *out1, uint8_t *out2,
                              uint8_t *out3, size_t nblocks,
                              keccakx4_state *state);

#define shake128x4 FIPS202X4_NAMESPACE(shake128x4)
void shake128x4(uint8_t *out0, uint8_t *out1, uint8_t *out2, uint8_t *out3,
                size_t outlen, const uint8_t *in0, const uint8_t *in1,
                const uint8_t *in2, const uint8_t *in3, size_t inlen);

#define shake256x4 FIPS202X4_NAMESPACE(shake256x4)
void shake256x4(uint8_t *out0, uint8_t *out1, uint8_t *out2, uint8_t *out3,
                size_t outlen, const uint8_t *in0, const uint8_t *in1,
                const uint8_t *in2, const uint8_t *in3, size_t inlen);


typedef struct {
    const uint8_t *in;
    size_t inlen;
    uint8_t *out;
    size_t outlen;
    unsigned int rate;
    uint8_t dsbyte;
} keccak_job;

static inline void keccak_job_shake128(keccak_job *job, uint8_t *out,
                                       size_t outlen, const uint8_t *in,
                                       size_t inlen) {
    job->in = in;
    job->inlen = inlen;
    job->out = out;
    job->outlen = outlen;
    job->rate = SHAKE128_RATE;
    job->dsbyte = 0x1F;
}

static inline void keccak_job_shake256(keccak_job *job, uint8_t *out,
                                       size_t outlen, const uint8_t *in,
                                       size_t inlen) {
    job->in = in;
    job->inlen = inlen;
    job->out = out;
    job->outlen = outlen;
    job->rate = SHAKE256_RATE;
    job->dsbyte = 0x1F;
}

static inline void keccak_job_sha3_256(keccak_job *job, uint8_t out[32],
                                       const uint8_t *in, size_t inlen) {
    job->in = in;
    job->inlen = inlen;
    job->out = out;
    job->outlen = SHA3_256_HashSize;
    job->rate = SHA3_256_RATE;
    job->dsbyte = 0x06;
}

#define KECCAKX4_MAX_JOBS 64

/* Runs njobs independent jobs (scheduled KECCAKX4_MAX_JOBS at a time),
 * generalising the fixed lane assignment of the Kyber AVX2
 * gen_matrix/getnoise_4x code: the four lanes of the 4-way permutation are kept
 * busy longest-job-first, lanes may mix rates and input/output lengths, and a
 * lane that finishes its job is reseeded with the next one. Once so little work
 * is left that the single-lane permutation is cheaper, the remaining jobs are
 * finished on it. No job's output may overlap another job's input. */
#define keccakx4_jobs FIPS202X4_NAMESPACE(keccakx4_jobs)
void keccakx4_jobs(const keccak_job *jobs, unsigned int njobs);

#endif
