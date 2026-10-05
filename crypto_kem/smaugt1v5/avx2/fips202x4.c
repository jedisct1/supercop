#include "fips202x4.h"
#include "fips202.h"
#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* Use implementation from the Keccak Code Package */
#define KeccakF1600_StatePermute4x                                             \
    FIPS202X4_NAMESPACE(KeccakP1600times4_PermuteAll_24rounds)
extern void KeccakF1600_StatePermute4x(__m256i *s);

static void keccakx4_absorb_once(__m256i s[25], unsigned int r,
                                 const uint8_t *in0, const uint8_t *in1,
                                 const uint8_t *in2, const uint8_t *in3,
                                 size_t inlen, uint8_t p) {
    size_t i;
    uint64_t pos = 0;
    __m256i t, idx;

    for (i = 0; i < 25; ++i)
        s[i] = _mm256_setzero_si256();

    idx = _mm256_set_epi64x((long long)in3, (long long)in2, (long long)in1,
                            (long long)in0);
    while (inlen >= r) {
        for (i = 0; i < r / 8; ++i) {
            t = _mm256_i64gather_epi64((long long *)pos, idx, 1);
            s[i] = _mm256_xor_si256(s[i], t);
            pos += 8;
        }
        inlen -= r;

        KeccakF1600_StatePermute4x(s);
    }

    for (i = 0; i < inlen / 8; ++i) {
        t = _mm256_i64gather_epi64((long long *)pos, idx, 1);
        s[i] = _mm256_xor_si256(s[i], t);
        pos += 8;
    }
    inlen -= 8 * i;

    if (inlen) {
        t = _mm256_i64gather_epi64((long long *)pos, idx, 1);
        idx = _mm256_set1_epi64x((1ULL << (8 * inlen)) - 1);
        t = _mm256_and_si256(t, idx);
        s[i] = _mm256_xor_si256(s[i], t);
    }

    t = _mm256_set1_epi64x((uint64_t)p << 8 * inlen);
    s[i] = _mm256_xor_si256(s[i], t);
    t = _mm256_set1_epi64x(1ULL << 63);
    s[r / 8 - 1] = _mm256_xor_si256(s[r / 8 - 1], t);
}

static void keccakx4_squeezeblocks(uint8_t *out0, uint8_t *out1, uint8_t *out2,
                                   uint8_t *out3, size_t nblocks,
                                   unsigned int r, __m256i s[25]) {
    unsigned int i;
    __m128d t;

    while (nblocks > 0) {
        KeccakF1600_StatePermute4x(s);
        for (i = 0; i < r / 8; ++i) {
            t = _mm_castsi128_pd(_mm256_castsi256_si128(s[i]));
            _mm_storel_pd((__attribute__((__may_alias__)) double *)&out0[8 * i],
                          t);
            _mm_storeh_pd((__attribute__((__may_alias__)) double *)&out1[8 * i],
                          t);
            t = _mm_castsi128_pd(_mm256_extracti128_si256(s[i], 1));
            _mm_storel_pd((__attribute__((__may_alias__)) double *)&out2[8 * i],
                          t);
            _mm_storeh_pd((__attribute__((__may_alias__)) double *)&out3[8 * i],
                          t);
        }

        out0 += r;
        out1 += r;
        out2 += r;
        out3 += r;
        --nblocks;
    }
}

void shake128x4_absorb_once(keccakx4_state *state, const uint8_t *in0,
                            const uint8_t *in1, const uint8_t *in2,
                            const uint8_t *in3, size_t inlen) {
    keccakx4_absorb_once(state->s, SHAKE128_RATE, in0, in1, in2, in3, inlen,
                         0x1F);
}

void shake128x4_squeezeblocks(uint8_t *out0, uint8_t *out1, uint8_t *out2,
                              uint8_t *out3, size_t nblocks,
                              keccakx4_state *state) {
    keccakx4_squeezeblocks(out0, out1, out2, out3, nblocks, SHAKE128_RATE,
                           state->s);
}

void shake256x4_absorb_once(keccakx4_state *state, const uint8_t *in0,
                            const uint8_t *in1, const uint8_t *in2,
                            const uint8_t *in3, size_t inlen) {
    keccakx4_absorb_once(state->s, SHAKE256_RATE, in0, in1, in2, in3, inlen,
                         0x1F);
}

void shake256x4_squeezeblocks(uint8_t *out0, uint8_t *out1, uint8_t *out2,
                              uint8_t *out3, size_t nblocks,
                              keccakx4_state *state) {
    keccakx4_squeezeblocks(out0, out1, out2, out3, nblocks, SHAKE256_RATE,
                           state->s);
}

void shake128x4(uint8_t *out0, uint8_t *out1, uint8_t *out2, uint8_t *out3,
                size_t outlen, const uint8_t *in0, const uint8_t *in1,
                const uint8_t *in2, const uint8_t *in3, size_t inlen) {
    unsigned int i;
    size_t nblocks = outlen / SHAKE128_RATE;
    uint8_t t[4][SHAKE128_RATE];
    keccakx4_state state;

    shake128x4_absorb_once(&state, in0, in1, in2, in3, inlen);
    shake128x4_squeezeblocks(out0, out1, out2, out3, nblocks, &state);

    out0 += nblocks * SHAKE128_RATE;
    out1 += nblocks * SHAKE128_RATE;
    out2 += nblocks * SHAKE128_RATE;
    out3 += nblocks * SHAKE128_RATE;
    outlen -= nblocks * SHAKE128_RATE;

    if (outlen) {
        shake128x4_squeezeblocks(t[0], t[1], t[2], t[3], 1, &state);
        for (i = 0; i < outlen; ++i) {
            out0[i] = t[0][i];
            out1[i] = t[1][i];
            out2[i] = t[2][i];
            out3[i] = t[3][i];
        }
    }
}

void shake256x4(uint8_t *out0, uint8_t *out1, uint8_t *out2, uint8_t *out3,
                size_t outlen, const uint8_t *in0, const uint8_t *in1,
                const uint8_t *in2, const uint8_t *in3, size_t inlen) {
    unsigned int i;
    size_t nblocks = outlen / SHAKE256_RATE;
    uint8_t t[4][SHAKE256_RATE];
    keccakx4_state state;

    shake256x4_absorb_once(&state, in0, in1, in2, in3, inlen);
    shake256x4_squeezeblocks(out0, out1, out2, out3, nblocks, &state);

    out0 += nblocks * SHAKE256_RATE;
    out1 += nblocks * SHAKE256_RATE;
    out2 += nblocks * SHAKE256_RATE;
    out3 += nblocks * SHAKE256_RATE;
    outlen -= nblocks * SHAKE256_RATE;

    if (outlen) {
        shake256x4_squeezeblocks(t[0], t[1], t[2], t[3], 1, &state);
        for (i = 0; i < outlen; ++i) {
            out0[i] = t[0][i];
            out1[i] = t[1][i];
            out2[i] = t[2][i];
            out3[i] = t[3][i];
        }
    }
}

/* Relative cost of one single-lane and one 4-way Keccak-f[1600] permutation
 * (about 800 and 1800 cycles on recent Intel cores): four independent
 * permutations are only worth doing as one 4-way permutation when at least
 * three of them carry real work. */
#define KECCAKX4_COST_X1 9
#define KECCAKX4_COST_X4 20

/* The 4-way state is only ever accessed with 256-bit loads and stores (a
 * 64-bit store into it would stall the next 256-bit load of the permutation
 * on store forwarding); the 64-bit view is read when leaving 4-way mode. */
typedef union {
    __m256i v[25];
    uint64_t q[100]; /* word w of lane k is q[4 * w + k] */
} keccakx4_lanes;

typedef struct {
    const keccak_job *job; /* NULL for an idle lane */
    size_t inpos;          /* input bytes absorbed so far */
    size_t outpos;         /* output bytes squeezed so far */
    unsigned int left;     /* permutations still to be performed */
    int squeezing;         /* the padded last block has been absorbed */
} keccak_lane;

static uint64_t load64(const uint8_t x[8]) {
    uint64_t r;
    memcpy(&r, x, 8); /* x86 is little-endian */
    return r;
}

static void store64(uint8_t x[8], uint64_t u) { memcpy(x, &u, 8); }

/* Stores the low / high 64 bits of x to p, which may be unaligned (unlike a
 * store through a double * as done by _mm_storeh_pd). */
static void store64_lo(uint8_t *p, __m128i x) {
    _mm_storel_epi64((__m128i *)p, x);
}

static void store64_hi(uint8_t *p, __m128i x) {
    store64(p, (uint64_t)_mm_extract_epi64(x, 1));
}

/* The last n < 8 bytes of a block followed by the domain-separation byte */
static uint64_t load_tail(const uint8_t *in, size_t n, uint8_t dsbyte) {
    uint64_t t = (uint64_t)dsbyte << 8 * n;
    size_t i;

    for (i = 0; i < n; ++i)
        t |= (uint64_t)in[i] << 8 * i;
    return t;
}

static __m256i lane_mask(unsigned int k) {
    return _mm256_cmpeq_epi64(_mm256_set_epi64x(3, 2, 1, 0),
                              _mm256_set1_epi64x(k));
}


#define JOB_PERMUTATIONS(inlen, outlen, r)                                     \
    ((unsigned int)((inlen) / (r) + ((outlen) + (r)-1) / (r)))

static unsigned int job_permutations(const keccak_job *job) {
    switch (job->rate) {
    case SHAKE128_RATE:
        return JOB_PERMUTATIONS(job->inlen, job->outlen, SHAKE128_RATE);
    case SHAKE256_RATE:
        return JOB_PERMUTATIONS(job->inlen, job->outlen, SHAKE256_RATE);
    case SHA3_512_RATE:
        return JOB_PERMUTATIONS(job->inlen, job->outlen, SHA3_512_RATE);
    default:
        return JOB_PERMUTATIONS(job->inlen, job->outlen, job->rate);
    }
}


static void lane_start(keccak_lane *lane, const keccak_job *jobs,
                       const unsigned int *nperm, uint64_t *pending) {
    uint64_t p = *pending;
    unsigned int i, best = (unsigned int)__builtin_ctzll(p);

    for (; p != 0; p &= p - 1) {
        i = (unsigned int)__builtin_ctzll(p);
        if (nperm[i] > nperm[best])
            best = i;
    }
    *pending &= ~((uint64_t)1 << best);
    lane->job = &jobs[best];
    lane->inpos = 0;
    lane->outpos = 0;
    lane->left = nperm[best];
    lane->squeezing = 0;
}


static void lanes_absorb_x4(keccakx4_lanes *s, keccak_lane lane[4]) {
    const __m256i bit63 = _mm256_set1_epi64x((long long)(1ULL << 63));
    const uint8_t *base = NULL;
    long long ofs[4] = {0}, nfw[4] = {0}, tail[4] = {0};
    unsigned int k, w, maxw = 0, fin = 0, uniform = 1;
    size_t tw[4] = {0}, pw[4] = {0}; /* words receiving tail and pad bit */
    __m256i idx, n, t, m;

    for (k = 0; k < 4; ++k) {
        const keccak_job *job = lane[k].job;
        const uint8_t *in;
        size_t rem;

        if (job == NULL || lane[k].squeezing)
            continue;
        in = job->in + lane[k].inpos;
        rem = job->inlen - lane[k].inpos;
        if (rem >= job->rate) {
            nfw[k] = job->rate / 8;
            lane[k].inpos += job->rate;
        } else {
            nfw[k] = rem / 8;
            tail[k] =
                (long long)load_tail(in + rem / 8 * 8, rem % 8, job->dsbyte);
            tw[k] = rem / 8;
            pw[k] = job->rate / 8 - 1;
            if (fin != 0) {
                w = (unsigned int)__builtin_ctz(fin);
                uniform &= (tw[k] == tw[w]) & (pw[k] == pw[w]);
            }
            fin |= 1u << k;
            lane[k].inpos = job->inlen;
            lane[k].squeezing = 1;
        }
        if (base == NULL)
            base = in;
        ofs[k] = (long long)((uintptr_t)in - (uintptr_t)base);
        if ((unsigned int)nfw[k] > maxw)
            maxw = (unsigned int)nfw[k];
    }

    idx = _mm256_set_epi64x(ofs[3], ofs[2], ofs[1], ofs[0]);
    n = _mm256_set_epi64x(nfw[3], nfw[2], nfw[1], nfw[0]);
    for (w = 0; w < maxw; ++w) {
        m = _mm256_cmpgt_epi64(n, _mm256_set1_epi64x(w));
        t = _mm256_mask_i64gather_epi64(
            _mm256_setzero_si256(),
            (const long long *)((uintptr_t)base + 8 * w), idx, m, 1);
        s->v[w] = _mm256_xor_si256(s->v[w], t);
    }

    if (fin == 0)
        return;
    if (uniform) {
        /* the lanes padding in this block agree on tail word and rate */
        k = (unsigned int)__builtin_ctz(fin);
        m = _mm256_set_epi64x(
            -(long long)((fin >> 3) & 1), -(long long)((fin >> 2) & 1),
            -(long long)((fin >> 1) & 1), -(long long)(fin & 1));
        t = _mm256_set_epi64x(tail[3], tail[2], tail[1], tail[0]);
        s->v[tw[k]] = _mm256_xor_si256(s->v[tw[k]], t);
        s->v[pw[k]] = _mm256_xor_si256(s->v[pw[k]], _mm256_and_si256(bit63, m));
        return;
    }
    for (k = 0; k < 4; ++k) {
        if (((fin >> k) & 1) == 0)
            continue;
        m = lane_mask(k);
        t = _mm256_and_si256(_mm256_set1_epi64x(tail[k]), m);
        s->v[tw[k]] = _mm256_xor_si256(s->v[tw[k]], t);
        s->v[pw[k]] = _mm256_xor_si256(s->v[pw[k]], _mm256_and_si256(bit63, m));
    }
}

/* Called after every 4-way permutation: squeezing lanes store their next
 * output block as in keccakx4_squeezeblocks. Returns the mask of lanes whose
 * job is complete. */
static unsigned int lanes_squeeze_x4(const keccakx4_lanes *s,
                                     keccak_lane lane[4]) {
    uint8_t *out[4] = {NULL, NULL, NULL, NULL};
    size_t nb[4] = {0, 0, 0, 0};
    unsigned int k, w, j, maxw = 0, done = 0;
    __m128i lo, hi;
    uint64_t t;

    for (k = 0; k < 4; ++k) {
        const keccak_job *job = lane[k].job;

        if (job == NULL)
            continue;
        lane[k].left -= 1;
        if (!lane[k].squeezing)
            continue;
        out[k] = job->out + lane[k].outpos;
        nb[k] = job->outlen - lane[k].outpos;
        if (nb[k] > job->rate)
            nb[k] = job->rate;
        if (nb[k] / 8 > maxw)
            maxw = (unsigned int)(nb[k] / 8);
        lane[k].outpos += nb[k];
        if (lane[k].outpos == job->outlen)
            done |= 1u << k;
    }

    if (nb[0] == nb[1] && nb[0] == nb[2] && nb[0] == nb[3] && nb[0] % 8 == 0) {
        /* all lanes squeeze the same number of words */
        for (w = 0; w < maxw; ++w) {
            lo = _mm256_castsi256_si128(s->v[w]);
            hi = _mm256_extracti128_si256(s->v[w], 1);
            store64_lo(out[0] + 8 * w, lo);
            store64_hi(out[1] + 8 * w, lo);
            store64_lo(out[2] + 8 * w, hi);
            store64_hi(out[3] + 8 * w, hi);
        }
        return done;
    }

    for (w = 0; w < maxw; ++w) {
        lo = _mm256_castsi256_si128(s->v[w]);
        hi = _mm256_extracti128_si256(s->v[w], 1);
        if (w < nb[0] / 8)
            store64_lo(out[0] + 8 * w, lo);
        if (w < nb[1] / 8)
            store64_hi(out[1] + 8 * w, lo);
        if (w < nb[2] / 8)
            store64_lo(out[2] + 8 * w, hi);
        if (w < nb[3] / 8)
            store64_hi(out[3] + 8 * w, hi);
    }

    for (k = 0; k < 4; ++k) {
        if (nb[k] % 8 == 0)
            continue;
        t = s->q[4 * (nb[k] / 8) + k];
        for (j = 0; j < nb[k] % 8; ++j)
            out[k][nb[k] / 8 * 8 + j] = (uint8_t)(t >> 8 * j);
    }
    return done;
}

/* Returns 1 if the lanes in mask, all just started, run jobs of one shape
 * (same rate and output length, input within one block). */
static int lanes_uniform(const keccak_lane lane[4], unsigned int mask) {
    const keccak_job *a = lane[__builtin_ctz(mask)].job, *b;
    unsigned int k;

    for (k = 0; k < 4; ++k) {
        if (((mask >> k) & 1) == 0)
            continue;
        b = lane[k].job;
        if (b->rate != a->rate || b->outlen != a->outlen || b->inlen >= b->rate)
            return 0;
    }
    return 1;
}

static void lanes_run_uniform_x4(keccakx4_lanes *s, keccak_lane lane[4],
                                 unsigned int mask) {
    const keccak_job *job = lane[__builtin_ctz(mask)].job;
    const unsigned int r = job->rate;
    const size_t outlen = job->outlen;
    uint8_t *out[4] = {NULL, NULL, NULL, NULL};
    size_t pos, n;
    unsigned int k, w, j;
    __m128i lo, hi;
    uint64_t t;

    lanes_absorb_x4(s, lane);
    for (k = 0; k < 4; ++k)
        if ((mask >> k) & 1)
            out[k] = lane[k].job->out;

    for (pos = 0; pos < outlen; pos += n) {
        KeccakF1600_StatePermute4x(s->v);
        n = (outlen - pos < r) ? outlen - pos : r;
        for (w = 0; w < n / 8; ++w) {
            lo = _mm256_castsi256_si128(s->v[w]);
            hi = _mm256_extracti128_si256(s->v[w], 1);
            if (mask & 1)
                store64_lo(out[0] + pos + 8 * w, lo);
            if (mask & 2)
                store64_hi(out[1] + pos + 8 * w, lo);
            if (mask & 4)
                store64_lo(out[2] + pos + 8 * w, hi);
            if (mask & 8)
                store64_hi(out[3] + pos + 8 * w, hi);
        }
        for (k = 0; k < 4 && n % 8 != 0; ++k) {
            if (((mask >> k) & 1) == 0)
                continue;
            t = s->q[4 * (n / 8) + k];
            for (j = 0; j < n % 8; ++j)
                out[k][pos + n / 8 * 8 + j] = (uint8_t)(t >> 8 * j);
        }
    }
}

/* Continues a lane's job on the single-lane permutation. */
static void lane_finish_x1(uint64_t s[25], keccak_lane *lane) {
    const keccak_job *job = lane->job;
    unsigned int i, r = job->rate;
    size_t n;

    for (;;) {
        if (!lane->squeezing) {
            const uint8_t *in = job->in + lane->inpos;
            size_t rem = job->inlen - lane->inpos;

            if (rem >= r) {
                for (i = 0; i < r / 8; ++i)
                    s[i] ^= load64(in + 8 * i);
                lane->inpos += r;
            } else {
                for (i = 0; i < rem / 8; ++i)
                    s[i] ^= load64(in + 8 * i);
                s[i] ^= load_tail(in + 8 * i, rem % 8, job->dsbyte);
                s[r / 8 - 1] ^= (uint64_t)1 << 63;
                lane->inpos = job->inlen;
                lane->squeezing = 1;
            }
        }

        KeccakF1600_StatePermute(s);

        if (lane->squeezing) {
            uint8_t *out = job->out + lane->outpos;

            n = job->outlen - lane->outpos;
            if (n > r)
                n = r;
            for (i = 0; i < n / 8; ++i)
                store64(out + 8 * i, s[i]);
            for (i = 0; i < n % 8; ++i)
                out[n / 8 * 8 + i] = (uint8_t)(s[n / 8] >> 8 * i);
            lane->outpos += n;
            if (lane->outpos == job->outlen)
                return;
        }
    }
}

void keccakx4_jobs(const keccak_job *jobs, unsigned int njobs) {
    keccakx4_lanes s;
    uint64_t s1[25];
    keccak_lane lane[4];
    unsigned int nperm[KECCAKX4_MAX_JOBS];
    uint64_t pending;
    unsigned int i, k, active, sum, max, queued = 0, used = 0, reseed, started;
    __m256i m;

    for (; njobs > KECCAKX4_MAX_JOBS; njobs -= KECCAKX4_MAX_JOBS) {
        keccakx4_jobs(jobs, KECCAKX4_MAX_JOBS);
        jobs += KECCAKX4_MAX_JOBS;
    }
    pending = (njobs == KECCAKX4_MAX_JOBS) ? ~(uint64_t)0
                                           : ((uint64_t)1 << njobs) - 1;
    for (i = 0; i < njobs; ++i) {
        nperm[i] = job_permutations(&jobs[i]);
        queued += nperm[i];
    }
    for (k = 0; k < 4; ++k)
        lane[k].job = NULL;
    for (i = 0; i < 25; ++i)
        s.v[i] = _mm256_setzero_si256();

    for (;;) {
        reseed = 0;
        started = 0;
        for (k = 0; k < 4; ++k) {
            if (lane[k].job == NULL && pending) {
                lane_start(&lane[k], jobs, nperm, &pending);
                queued -= lane[k].left;
                started |= 1u << k;
                reseed |= used & (1u << k);
                used |= 1u << k;
            }
        }
        if (reseed == 0xF) {
            for (i = 0; i < 25; ++i)
                s.v[i] = _mm256_setzero_si256();
        } else if (reseed) {
            m = _mm256_set_epi64x(-(long long)((reseed >> 3) & 1),
                                  -(long long)((reseed >> 2) & 1),
                                  -(long long)((reseed >> 1) & 1),
                                  -(long long)(reseed & 1));
            for (i = 0; i < 25; ++i)
                s.v[i] = _mm256_andnot_si256(m, s.v[i]);
        }

        active = 0;
        sum = queued;
        max = 0;
        for (k = 0; k < 4; ++k) {
            if (lane[k].job == NULL)
                continue;
            active += 1;
            sum += lane[k].left;
            if (lane[k].left > max)
                max = lane[k].left;
        }
        if (active == 0)
            return;

        /* A 4-way run needs at least max(max, ceil(sum / 4)) permutations. */
        if ((sum + 3) / 4 > max)
            max = (sum + 3) / 4;
        if (sum * KECCAKX4_COST_X1 < max * KECCAKX4_COST_X4)
            break;

        /* every busy lane was just started: no per-permutation bookkeeping
         * needed if they all run jobs of one shape */
        k = 0;
        for (i = 0; i < 4; ++i)
            k |= (unsigned int)(lane[i].job != NULL) << i;
        if (started == k && lanes_uniform(lane, k)) {
            lanes_run_uniform_x4(&s, lane, k);
            for (i = 0; i < 4; ++i)
                lane[i].job = NULL;
            continue;
        }

        lanes_absorb_x4(&s, lane);
        KeccakF1600_StatePermute4x(s.v);
        k = lanes_squeeze_x4(&s, lane);
        for (i = 0; i < 4; ++i)
            if ((k >> i) & 1)
                lane[i].job = NULL;
    }

    /* Too little work left to fill the 4-way permutation. */
    for (k = 0; k < 4; ++k) {
        if (lane[k].job == NULL)
            continue;
        for (i = 0; i < 25; ++i)
            s1[i] = s.q[4 * i + k];
        lane_finish_x1(s1, &lane[k]);
    }
    while (pending) {
        lane_start(&lane[0], jobs, nperm, &pending);
        for (i = 0; i < 25; ++i)
            s1[i] = 0;
        lane_finish_x1(s1, &lane[0]);
    }
}
