// 20240806 djb: some automated conversion to cryptoint
#include "polyfix.h"
#include "decompose.h"
#include "math.h"
#include "ntt.h"
#include "params.h"
#include "reduce.h"
#include "symmetric.h"
#include <stdint.h>
#include "crypto_int64.h"
#include "crypto_uint64.h"
#include "crypto_declassify.h"

/*************************************************
 * Name:        polyfix_add
 *
 * Description: Add double polynomial and integer polynomial.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyfix *c: pointer to output double polynomial
 *              - const polyfix *a: pointer to first summand
 *              - const poly *b: pointer to second summand
 **************************************************/
void polyfix_add(polyfix *c, const polyfix *a, const poly *b) {
    unsigned int i;
    __m256i tmp;

    for (i = 0; i < N/8; ++i)
    {
#if LN != (1<<13)
#error "Hardcoded for LN = 1<<13"
#endif
      tmp = _mm256_slli_epi32(b->vec[i], 13);
      c->vec[i] = _mm256_add_epi32(a->vec[i], tmp);
    }
}

/*************************************************
 * Name:        polyfixfix_sub
 *
 * Description: Subtract fixed polynomial and fixed polynomial.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyfix *c: pointer to output fixed polynomial
 *              - const polyfix *a: pointer to first summand
 *              - const polyfix *b: pointer to second summand
 **************************************************/
void polyfixfix_sub(polyfix *c, const polyfix *a, const polyfix *b) {
    unsigned int i;

    for (i = 0; i < N/8; ++i)
    {
      c->vec[i] = _mm256_sub_epi32(a->vec[i], b->vec[i]);
    }
}


/*************************************************
 * Name:        polyfix_round
 *
 * Description: rounds a fixed polynomial to integer polynomial
 *
 * Arguments:   - poly *a: output integer polynomial
 *              - poly *b: input fixed polynomial
 **************************************************/
static const union {
  __m256i vec[4];
  int32_t arr[4*8];
} ln1_avx = {.arr = {
  -LN + 1, -LN + 1, -LN + 1, -LN + 1, -LN + 1, -LN + 1, -LN + 1, -LN + 1,
  LN/2, LN/2, LN/2, LN/2, LN/2, LN/2, LN/2, LN/2,
  LN-1, LN-1, LN-1, LN-1, LN-1, LN-1, LN-1, LN-1,
  0, 0, 0, 0, 0, 0, 0, 0
  }};
void polyfix_round(poly *a, const polyfix *b) {
    unsigned i;
    __m256i tmp, tmp2;

    for (i = 0; i < N/8; ++i)
    {
      tmp = _mm256_srai_epi32(b->vec[i], 31);
      tmp = _mm256_and_si256(tmp, ln1_avx.vec[0]);
      tmp = _mm256_add_epi32(b->vec[i], tmp);
      tmp = _mm256_add_epi32(tmp, ln1_avx.vec[1]);
      a->vec[i] = _mm256_srai_epi32(tmp, 13);
      tmp2 = _mm256_srli_epi32(b->vec[i], 31); // 1 if b is negative
      tmp = _mm256_and_si256(tmp, ln1_avx.vec[2]); // only the bits that we want to shift away
      tmp = _mm256_cmpeq_epi32(tmp, ln1_avx.vec[3]); // check if they are zero (in this case, we do not round); if so: result is all-ones
      tmp2 = _mm256_andnot_si256(tmp, tmp2); // if the rounded values are NOT zero and we were negative, we add 1
      a->vec[i] = _mm256_add_epi32(a->vec[i], tmp2);
#if LN != (1<<13)
#error "Hardcoded for LN = 1<<13"
#endif
    }
}

/**************************************************************/
/********* Double Vectors of polynomials of length K **********/
/**************************************************************/

/*************************************************
 * Name:        polyfixveck_add
 *
 * Description: Add vector to a vector of double polynomials of length K.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyveck *u: pointer to first summand
 *              - const polyveck *v: pointer to second summand
 **************************************************/
void polyfixveck_add(polyfixveck *w, const polyfixveck *u, const polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; ++i)
        polyfix_add(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyfixfixveck_sub
 *
 * Description: subtract vector to a vector of fixed polynomials of length k.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyfixveck *u: pointer to first summand
 *              - const polyfixveck *v: pointer to second summand
 **************************************************/
void polyfixfixveck_sub(polyfixveck *w, const polyfixveck *u,
                        const polyfixveck *v) {
    unsigned int i;

    for (i = 0; i < K; ++i)
        polyfixfix_sub(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyfixveck_double
 *
 * Description: Double vector of polynomials of length K.
 *
 * Arguments:   - polyveck *b: pointer to output vector
 *              - polyveck *a: pointer to input vector
 **************************************************/
void polyfixveck_double(polyfixveck *b, const polyfixveck *a) {
    unsigned int i, j;

    for (i = 0; i < K; ++i)
        for (j = 0; j < N; ++j)
            b->vec[i].coeffs[j] = 2 * a->vec[i].coeffs[j];
}

/*************************************************
 * Name:        polyfixveck_round
 *
 * Description: rounds a fixed polynomial vector of length K
 *
 * Arguments:   - polyveck *a: output integer polynomial vector
 *              - polyfixveck *b: input fixed polynomial vector
 **************************************************/
void polyfixveck_round(polyveck *a, const polyfixveck *b) {
    unsigned i;

    for (i = 0; i < K; ++i)
        polyfix_round(&a->vec[i], &b->vec[i]);
}

/**************************************************************/
/********* Double Vectors of polynomials of length L **********/
/**************************************************************/

/*************************************************
 * Name:        polyfixvecl_add
 *
 * Description: Add vector to a vector of double polynomials of length L.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyvecl *w: pointer to output vector
 *              - const polyfixvecl *u: pointer to first summand
 *              - const polyvecl *v: pointer to second summand
 **************************************************/
void polyfixvecl_add(polyfixvecl *w, const polyfixvecl *u, const polyvecl *v) {
    unsigned int i;

    for (i = 0; i < L; ++i)
        polyfix_add(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyfixfixvecl_sub
 *
 * Description: subtract vector to a vector of fixed polynomials of length l.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyvecl *w: pointer to output vector
 *              - const polyfixvecl *u: pointer to first summand
 *              - const polyfixvecl *v: pointer to second summand
 **************************************************/
void polyfixfixvecl_sub(polyfixvecl *w, const polyfixvecl *u,
                        const polyfixvecl *v) {
    unsigned int i;

    for (i = 0; i < L; ++i)
        polyfixfix_sub(&w->vec[i], &u->vec[i], &v->vec[i]);
}
/*************************************************
 * Name:        polyfixvecl_double
 *
 * Description: Double vector of polynomials of length L.
 *
 * Arguments:   - polyveck *b: pointer to output vector
 *              - polyveck *a: pointer to input vector
 **************************************************/
void polyfixvecl_double(polyfixvecl *b, const polyfixvecl *a) {
    unsigned int i, j;

    for (i = 0; i < L; ++i)
        for (j = 0; j < N/8; ++j) {
            b->vec[i].vec[j] = _mm256_add_epi32(a->vec[i].vec[j], a->vec[i].vec[j]);
        }
}

/*************************************************
 * Name:        polyfixvecl_round
 *
 * Description: rounds a fixed polynomial vector of length L
 *
 * Arguments:   - polyvecl *a: output integer polynomial vector
 *              - polyfixvecl *b: input fixed polynomial vector
 **************************************************/
void polyfixvecl_round(polyvecl *a, const polyfixvecl *b) {
    unsigned i;

    for (i = 0; i < L; ++i)
        polyfix_round(&a->vec[i], &b->vec[i]);
}

/*************************************************
 * Name:        polyfixveclk_norm2
 *
 * Description: Calculates L2 norm of a fixed point polynomial vector with
 *length L + K The result is L2 norm * LN similar to the way polynomial is
 *usually stored
 *
 * Arguments:   - polyfixvecl *a: polynomial vector with length L to calculate
 *                norm
 *              - polyfixveck *a: polynomial vector with length K to calculate
 *                norm
 **************************************************/
uint64_t polyfixveclk_sqnorm2(const polyfixvecl *a, const polyfixveck *b) {
    unsigned int i, j;

    union {
        __m256i vec;
        uint64_t arr[4];
    } sum = {.arr={0}};
    __m256i reg[4];

    for (i = 0; i < L; ++i) {
        for (j = 0; j < N/8; ++j)
        {
            reg[0] = _mm256_srli_epi64(a->vec[i].vec[j], 32);
            reg[1] = _mm256_mul_epi32(a->vec[i].vec[j], a->vec[i].vec[j]);
            reg[2] = _mm256_mul_epi32(reg[0], reg[0]);
            reg[3] = _mm256_add_epi64(reg[1], reg[2]);
            sum.vec = _mm256_add_epi64(sum.vec, reg[3]);
        }
    }

    for (i = 0; i < K; ++i) {
        for (j = 0; j < N/8; ++j)
        {
            reg[0] = _mm256_srli_epi64(b->vec[i].vec[j], 32);
            reg[1] = _mm256_mul_epi32(b->vec[i].vec[j], b->vec[i].vec[j]);
            reg[2] = _mm256_mul_epi32(reg[0], reg[0]);
            reg[3] = _mm256_add_epi64(reg[1], reg[2]);
            sum.vec = _mm256_add_epi64(sum.vec, reg[3]);
        }
    }

    return sum.arr[0] + sum.arr[1] + sum.arr[2] + sum.arr[3];
}

static const union {
  __m256i vec[4];
  int64_t arr[4*4];
} mulrnd_avx = {.arr = {
  (1ULL<<30), (1ULL<<30), (1ULL<<30), (1ULL<<30),
  0,0,0,0,
  2,2,2,2,
  (1UL<<27), (1UL<<27), (1UL<<27), (1UL<<27)
}};
static void __mr13(__m256i tmp[6], __m256i smp[2], const __m256i isv[3], const uint64_t *samples)
{
  smp[0] = _mm256_loadu_si256((__m256i const *) samples);
  smp[1] = _mm256_srli_epi64(smp[0], 32);

  tmp[0] = _mm256_mul_epu32(smp[0], isv[0]); // sl * il  ( 16)
  tmp[1] = _mm256_mul_epu32(smp[1], isv[0]); // sh * il  ( 48)
  tmp[2] = _mm256_mul_epu32(smp[0], isv[1]); // sl * im  ( 46)
  tmp[3] = _mm256_mul_epu32(smp[1], isv[1]); // sh * im  ( 78)
  tmp[4] = _mm256_mul_epu32(smp[0], isv[2]); // sl * ih  ( 76)
  tmp[5] = _mm256_mul_epu32(smp[1], isv[2]); // sh * ih  (108)

  tmp[0] = _mm256_srli_epi64(tmp[0], 46);
  tmp[0] = _mm256_add_epi64(tmp[0], tmp[2]);
  tmp[0] = _mm256_add_epi64(tmp[0], mulrnd_avx.vec[2]); // rounding
  tmp[0] = _mm256_srli_epi64(tmp[0], 2);
  tmp[0] = _mm256_add_epi64(tmp[0], tmp[1]);
  tmp[0] = _mm256_add_epi64(tmp[0], mulrnd_avx.vec[3]); // rounding
  tmp[0] = _mm256_srli_epi64(tmp[0], 28);
  tmp[0] = _mm256_add_epi64(tmp[0], tmp[4]);
  tmp[0] = _mm256_srli_epi64(tmp[0], 2);
  tmp[0] = _mm256_add_epi64(tmp[0], tmp[3]);
  tmp[0] = _mm256_srli_epi64(tmp[0], 30);
  tmp[0] = _mm256_add_epi64(tmp[0], tmp[5]);
  tmp[0] = _mm256_add_epi64(tmp[0], mulrnd_avx.vec[0]); // rounding
  tmp[0] = _mm256_srli_epi64(tmp[0], 31);
}
static void _mul_rnd13(polyfix *y, const uint64_t samples[N], const uint8_t signs[N/8], const uint64_t invsqrt[2])
{
/*
for (j = 0; j < N; j++)
    y1->vec[i].coeffs[j] = fixpoint_mul_rnd13(
        samples[(i * N + j)], &sqsum,
        (signs[(i * N + j) / 8] >> ((i * N + j) % 8)) & 1);
*/
  size_t i;
  uint32_t is[3] = {invsqrt[0]&((1ULL<<30)-1),  ((invsqrt[0]>>30) | (invsqrt[1]<<(48-30)))&((1ULL<<30)-1),  (invsqrt[1]>>(60-48))&((1ULL<<30)-1)};
  __m256i isv[3], tmp[7], smp[2];
  isv[0] = _mm256_set1_epi64x(is[0]);
  isv[1] = _mm256_set1_epi64x(is[1]);
  isv[2] = _mm256_set1_epi64x(is[2]);

  for (i = 0; i < N/8; i++)
  {
    const union {
      __m256 vec;
      int32_t arr[8];
    } signs_avx = {.arr = {
      -(int32_t)(crypto_int64_bottombit_01(signs[i])), -(int32_t)(crypto_int64_bitmod_01(signs[i],1)),  -(int32_t)(crypto_int64_bitmod_01(signs[i],2)),  -(int32_t)(crypto_int64_bitmod_01(signs[i],3)), 
        -(int32_t)(crypto_int64_bitmod_01(signs[i],4)),  -(int32_t)(crypto_int64_bitmod_01(signs[i],5)),  -(int32_t)(crypto_int64_bitmod_01(signs[i],6)),  -(int32_t)(crypto_int64_bitmod_01(signs[i],7))
    }};
    __mr13(tmp, smp, isv, &samples[i*8 + 0]);
    tmp[6] = tmp[0];
    __mr13(tmp, smp, isv, &samples[i*8 + 4]);
    // write to polynomial
    // we have tmp[6] 0d0c0b0a, tmp[0] 0h0g0f0e, but we want hgfedcba
    tmp[1] = _mm256_permute4x64_epi64(tmp[0], 0x44); // now tmp[0] holds 0h0g0f0e and tmp[1] has 0f0e0f0e
    tmp[2] = _mm256_permute4x64_epi64(tmp[6], 0xee); // now tmp[6] holds 0d0c0b0a and tmp[2] has 0d0c0d0c
    tmp[0] = _mm256_shuffle_epi32(tmp[0], 0x85); // now tmp[0] holds hg00fe00
    tmp[1] = _mm256_shuffle_epi32(tmp[1], 0x58); // now tmp[1] holds 00fe00fe
    tmp[2] = _mm256_shuffle_epi32(tmp[2], 0x85); // now tmp[2] holds dc00dc00
    tmp[6] = _mm256_shuffle_epi32(tmp[6], 0x58); // now tmp[6] holds 00dc00ba
    tmp[3] = _mm256_blend_epi32(tmp[6], tmp[2], 0xcc); // tmp[0] hols dcdcdcba
    tmp[1] = _mm256_blend_epi32(tmp[1], tmp[0], 0xcc); // tmp[1] hols hgfefefe
    tmp[3] = _mm256_blend_epi32(tmp[3], tmp[1], 0xf0); // hgfedcba
    tmp[4] = _mm256_sub_epi32(mulrnd_avx.vec[1], tmp[3]); // negate
    y->vec[i] = _mm256_castps_si256(_mm256_blendv_ps(_mm256_castsi256_ps(tmp[3]), _mm256_castsi256_ps(tmp[4]), signs_avx.vec));
  }
}

uint16_t polyfixveclk_sample_hyperball(polyfixvecl *y1, polyfixveck *y2, uint8_t *b, 
                                       const uint8_t seed[CRHBYTES],
                                       const uint16_t nonce) {
    uint16_t ni = nonce;
    uint64_t samples[N * (L + K)];
    fp96_76 sqsum, invsqrt;
    unsigned int i;
    uint8_t signs[N * (L + K) / 8];
    crypto_uint64 rejectmask;

    do {
        sqsum.limb48[0] = 0;
        sqsum.limb48[1] = 0;
        
/*#ifdef HAETAE_USE_AES
        sample_gauss_N(&samples[0], &signs[0], &sqsum, seed, ni++, N + 1);
        sample_gauss_N(&samples[N], &signs[N / 8], &sqsum, seed, ni++, N + 1);

        for (i = 2; i < L + K; i++)
            sample_gauss_N(&samples[N * i], &signs[N / 8 * i], &sqsum, seed,
                           ni++, N);
#else*/
#if K == 2 && L == 4
        sample_gauss_N_4x(  &samples[0],   &samples[N], &samples[2*N], &samples[3*N],
                              &signs[0],   &signs[N/8], &signs[2*N/8], &signs[3*N/8],
                          &sqsum, seed, 
                                     ni,          ni+1,          ni+2,          ni+3,
                                    N+1,           N+1,             N,             N);
        sample_gauss_N_4x(&samples[4*N], &samples[5*N],          NULL,          NULL,
                          &signs[4*N/8], &signs[5*N/8],     &signs[0],   &signs[N/8],
                          &sqsum, seed, 
                                   ni+4,          ni+5,            ni,          ni+1,
                                      N,             N,             0,             0);
#elif K == 3 && L == 6
        sample_gauss_N_4x(  &samples[0],   &samples[N], &samples[2*N], &samples[3*N],
                              &signs[0],   &signs[N/8], &signs[2*N/8], &signs[3*N/8],
                          &sqsum, seed, 
                                     ni,          ni+1,          ni+2,          ni+3,
                                    N+1,           N+1,             N,             N);
        sample_gauss_N_4x(&samples[4*N], &samples[5*N], &samples[6*N], &samples[7*N],
                          &signs[4*N/8], &signs[5*N/8], &signs[6*N/8], &signs[7*N/8],
                          &sqsum, seed, 
                                   ni+4,          ni+5,          ni+6,          ni+7,
                                      N,             N,             N,             N);
        sample_gauss_N(&samples[8*N], &signs[8*N/8], &sqsum, seed, ni+8, N);
#elif K == 4 && L == 7
        sample_gauss_N_4x(  &samples[0],   &samples[N], &samples[2*N], &samples[3*N],
                              &signs[0],   &signs[N/8], &signs[2*N/8], &signs[3*N/8],
                          &sqsum, seed, 
                                     ni,          ni+1,          ni+2,          ni+3,
                                    N+1,           N+1,             N,             N);
        sample_gauss_N_4x(&samples[4*N], &samples[5*N], &samples[6*N], &samples[7*N],
                          &signs[4*N/8], &signs[5*N/8], &signs[6*N/8], &signs[7*N/8],
                          &sqsum, seed, 
                                   ni+4,          ni+5,          ni+6,          ni+7,
                                      N,             N,             N,             N);
        sample_gauss_N_4x(&samples[8*N], &samples[9*N],&samples[10*N],          NULL,
                          &signs[8*N/8], &signs[9*N/8],&signs[10*N/8],     &signs[0],
                          &sqsum, seed, 
                                   ni+8,          ni+9,         ni+10,            ni,
                                      N,             N,             N,             0);
#else
#error
#endif
        ni += K + L;
//#endif

        // divide sqsum by 2 and approximate inverse square root
        sqsum.limb48[0] += 1; // rounding
        sqsum.limb48[0] >>= 1;
        sqsum.limb48[0] += (crypto_int64_bottombit_01(sqsum.limb48[1])) << 47;
        sqsum.limb48[1] >>= 1;
        sqsum.limb48[1] += sqsum.limb48[0] >> 48;
        sqsum.limb48[0] &= (1ULL << 48) - 1;
        fixpoint_newton_invsqrt(&invsqrt, &sqsum);
        fixpoint_mul_high(&sqsum, &invsqrt,
                          (uint64_t)(B0 * LN + SQNM / 2) << (28 - 13));

        for (i = 0; i < L; i++) {
          _mul_rnd13(&y1->vec[i], &samples[i*N], &signs[i*N/8], &sqsum.limb48[0]);
        }
        for (i = L; i < K + L; i++) {
          _mul_rnd13(&y2->vec[i-L], &samples[i*N], &signs[i*N/8], &sqsum.limb48[0]);
        }
        rejectmask = crypto_uint64_smaller_mask(B0SQ * LN * LN,polyfixveclk_sqnorm2(y1, y2));
        crypto_declassify(&rejectmask,sizeof rejectmask);
    } while (rejectmask);

    {
      uint8_t tmp[CRHBYTES + 2];
      for (i = 0; i < CRHBYTES; i++)
      {
        tmp[i] = seed[i];
      }
      tmp[CRHBYTES + 0] = ni >> 0;
      tmp[CRHBYTES + 1] = ni >> 8;
      shake256(b, 1, tmp, CRHBYTES+2);
    }

    return ni;
}
