#include "ntt.h"
#include "mulconfig.h"
#include "consts.h"
#include <immintrin.h>
#include <stdint.h>

static inline __m256i mulmod(const __m256i a, const __m256i b_pinv,
                             const __m256i b, const __m256i p) {
    __m256i t, u;
    t = _mm256_mullo_epi16(a, b_pinv);
    u = _mm256_mulhi_epi16(a, b);
    t = _mm256_mulhi_epi16(t, p);
    t = _mm256_sub_epi16(u, t);
    return t;
}

static inline __m256i fnt_crt_combine(__m256i f0, __m256i f1) {
    const __m256i u_pinv = _mm256_set1_epi16(FNT_CRT_U_PINV);
    const __m256i u = _mm256_set1_epi16(FNT_CRT_U);
    const __m256i p0 = _mm256_load_si256((__m256i *)&PDATA0[_16XP]);
    const __m256i p1 = _mm256_load_si256((__m256i *)&PDATA2[_16XP]);
    const __m256i mont0_pinv =
        _mm256_load_si256((__m256i *)&PDATA0[_16XMONT_PINV]);
    const __m256i mont0 = _mm256_load_si256((__m256i *)&PDATA0[_16XMONT]);

    f0 = mulmod(f0, mont0_pinv, mont0, p0); // extra reduction
    f1 = _mm256_sub_epi16(f1, f0);
    f1 = mulmod(f1, u_pinv, u, p1);
    f1 = _mm256_mullo_epi16(f1, p0);
    return _mm256_add_epi16(f0, f1);
}

void poly_fnt_crt_shl_add(poly *r, const nttpoly *a, const nttpoly *b,
                          int shift, int16_t round_add, int round_shift) {
    unsigned int i;
    const __m128i sh = _mm_cvtsi32_si128(shift);
    const __m128i rsh = _mm_cvtsi32_si128(round_shift);
    const __m256i radd = _mm256_set1_epi16(round_add);

    for (i = 0; i < KEM_N / 16; i++) {
        const __m256i f0 = _mm256_load_si256((__m256i *)&a->coeffs[16 * i]);
        const __m256i f1 = _mm256_load_si256((__m256i *)&b->coeffs[16 * i]);
        const __m256i g = _mm256_load_si256((__m256i *)&r->coeffs[16 * i]);
        const __m256i t = fnt_crt_combine(f0, f1);
        const __m256i u = _mm256_add_epi16(g, _mm256_sll_epi16(t, sh));
        _mm256_store_si256((__m256i *)&r->coeffs[16 * i],
                           _mm256_srl_epi16(_mm256_add_epi16(u, radd), rsh));
    }
}


void polyvec_fnt_crt_shl(polyvec *r, const nttpolyvec *a, const nttpolyvec *b,
                         int shift, int16_t round_add, int round_shift) {
    unsigned int i, j;
    const __m128i sh = _mm_cvtsi32_si128(shift);
    const __m128i rsh = _mm_cvtsi32_si128(round_shift);
    const __m256i radd = _mm256_set1_epi16(round_add);

    for (i = 0; i < KEM_N / 16; i++)
        for (j = 0; j < KEM_K; j++) {
            const __m256i f0 =
                _mm256_load_si256((__m256i *)&a->vec[j].coeffs[16 * i]);
            const __m256i f1 =
                _mm256_load_si256((__m256i *)&b->vec[j].coeffs[16 * i]);
            const __m256i t = fnt_crt_combine(f0, f1);
            const __m256i u = _mm256_sll_epi16(t, sh);
            _mm256_store_si256(
                (__m256i *)&r->vec[j].coeffs[16 * i],
                _mm256_srl_epi16(_mm256_add_epi16(u, radd), rsh));
        }
}

void polyvec_fnt_crt_shl_sub(polyvec *r, const nttpolyvec *a,
                             const nttpolyvec *b, int shift) {
    unsigned int i, j;
    const __m128i sh = _mm_cvtsi32_si128(shift);

    for (i = 0; i < KEM_N / 16; i++)
        for (j = 0; j < KEM_K; j++) {
            const __m256i f0 =
                _mm256_load_si256((__m256i *)&a->vec[j].coeffs[16 * i]);
            const __m256i f1 =
                _mm256_load_si256((__m256i *)&b->vec[j].coeffs[16 * i]);
            const __m256i g =
                _mm256_load_si256((__m256i *)&r->vec[j].coeffs[16 * i]);
            const __m256i t = fnt_crt_combine(f0, f1);
            _mm256_store_si256((__m256i *)&r->vec[j].coeffs[16 * i],
                               _mm256_sub_epi16(g, _mm256_sll_epi16(t, sh)));
        }
}


void polyvec_basemul_fnt_acc_montgomery(nttpoly *r, const nttpolyvec *a, const nttpolyvec *b, const int16_t *pdata)
{
  unsigned int blk, g, k;
  const __m256i p    = _mm256_load_si256((const __m256i *)&pdata[_16XP]);
  const __m256i pinv = _mm256_load_si256((const __m256i *)&pdata[_16XPINV]);

  for (blk = 0; blk < 4; blk++) {
    const __m256i th  = _mm256_load_si256((const __m256i *)&pdata[_THETA + 32*blk]);
    const __m256i thp = _mm256_load_si256((const __m256i *)&pdata[_THETA + 32*blk + 16]);
    for (g = 0; g < 2; g++) {          /* g=0: x^2-w pairs, g=1: x^2+w pairs */
      __m256i sac = _mm256_setzero_si256();
      __m256i sodd = _mm256_setzero_si256();
      __m256i sbd = _mm256_setzero_si256();
      for (k = 0; k < KEM_K; k++) {
        const int16_t *ak = &a->vec[k].coeffs[64*blk + 32*g];
        const int16_t *bk = &b->vec[k].coeffs[64*blk + 32*g];
        const __m256i va = _mm256_load_si256((const __m256i *)&ak[0]);
        const __m256i vb = _mm256_load_si256((const __m256i *)&ak[16]);
        const __m256i vc = _mm256_load_si256((const __m256i *)&bk[0]);
        const __m256i vd = _mm256_load_si256((const __m256i *)&bk[16]);
        const __m256i alo = _mm256_mullo_epi16(va, pinv);
        const __m256i blo = _mm256_mullo_epi16(vb, pinv);
        const __m256i ac = _mm256_sub_epi16(_mm256_mulhi_epi16(va, vc),
                _mm256_mulhi_epi16(_mm256_mullo_epi16(alo, vc), p));
        const __m256i ad = _mm256_sub_epi16(_mm256_mulhi_epi16(va, vd),
                _mm256_mulhi_epi16(_mm256_mullo_epi16(alo, vd), p));
        const __m256i bc = _mm256_sub_epi16(_mm256_mulhi_epi16(vb, vc),
                _mm256_mulhi_epi16(_mm256_mullo_epi16(blo, vc), p));
        const __m256i bd = _mm256_sub_epi16(_mm256_mulhi_epi16(vb, vd),
                _mm256_mulhi_epi16(_mm256_mullo_epi16(blo, vd), p));
        sac = _mm256_add_epi16(sac, ac);
        sodd = _mm256_add_epi16(sodd, _mm256_add_epi16(ad, bc));
        sbd = _mm256_add_epi16(sbd, bd);
      }
      {
        const __m256i wbd = mulmod(sbd, thp, th, p);
        const __m256i even = g ? _mm256_sub_epi16(sac, wbd)
                               : _mm256_add_epi16(sac, wbd);
        _mm256_store_si256((__m256i *)&r->coeffs[64*blk + 32*g], even);
        _mm256_store_si256((__m256i *)&r->coeffs[64*blk + 32*g + 16], sodd);
      }
    }
  }
}


__attribute__((always_inline)) static inline void
fwd_batch(nttpoly *rn, nttpoly *rf, const poly *const *a, unsigned int n) {
    unsigned int i;

    for (i = 0; i + 1 < n; i += 2)
        ntt2_fnt2(rn[i].coeffs, a[i]->coeffs, PDATA0,
                  rn[i + 1].coeffs, a[i + 1]->coeffs, PDATA0,
                  rf[i].coeffs, a[i]->coeffs, PDATA2,
                  rf[i + 1].coeffs, a[i + 1]->coeffs, PDATA2);
    if (i < n)
        ntt1_fnt1(rn[i].coeffs, a[i]->coeffs, PDATA0,
                  rf[i].coeffs, a[i]->coeffs, PDATA2);
}

__attribute__((always_inline)) static inline void
inv_batch(nttpoly *t0, nttpoly *t1, unsigned int n) {
    unsigned int i;

    for (i = 0; i + 1 < n; i += 2)
        invntt2_invfnt2(t0[i].coeffs, t0[i].coeffs, PDATA0,
                        t0[i + 1].coeffs, t0[i + 1].coeffs, PDATA0,
                        t1[i].coeffs, t1[i].coeffs, PDATA2,
                        t1[i + 1].coeffs, t1[i + 1].coeffs, PDATA2);
    if (i < n)
        invntt1_invfnt1(t0[i].coeffs, t0[i].coeffs, PDATA0, t1[i].coeffs,
                        t1[i].coeffs, PDATA2);
}

void polyvec_fnt_matrix_vector_mul_raw(nttpolyvec *t0, nttpolyvec *t1,
                                       nttpolyvec shat[2],
                                       const polyvec a[KEM_K],
                                       const polyvec *s, int transpose) {
    unsigned int i, j;
    nttpolyvec ahat_n, ahat_f;
    const poly *src[KEM_K];

    for (j = 0; j < KEM_K; j++)
        src[j] = &s->vec[j];
    fwd_batch(shat[0].vec, shat[1].vec, src, KEM_K);

    for (i = 0; i < KEM_K; i++) {
        for (j = 0; j < KEM_K; j++)
            src[j] = transpose ? &a[j].vec[i] : &a[i].vec[j];
        fwd_batch(ahat_n.vec, ahat_f.vec, src, KEM_K);

        polyvec_basemul_acc_montgomery(&t0->vec[i], &ahat_n, &shat[0], PDATA0);
        polyvec_basemul_fnt_acc_montgomery(&t1->vec[i], &ahat_f, &shat[1],
                                           PDATA2);
    }

    inv_batch(t0->vec, t1->vec, KEM_K);
}

void polyvec_fnt_iprod_raw(nttpoly *r0, nttpoly *r1, const polyvec *a,
                           const polyvec *b) {
    unsigned int j;
    /* [0 .. KEM_K) holds a's transforms, [KEM_K .. 2*KEM_K) holds b's; the two
     * halves are handed to the basemuls as polynomial vectors */
    nttpoly nhat[2 * KEM_K], fhat[2 * KEM_K];
    const poly *src[2 * KEM_K];

    for (j = 0; j < KEM_K; j++) {
        src[j] = &a->vec[j];
        src[KEM_K + j] = &b->vec[j];
    }
    fwd_batch(nhat, fhat, src, 2 * KEM_K);

    polyvec_basemul_acc_montgomery(r0, (const nttpolyvec *)&nhat[0],
                                   (const nttpolyvec *)&nhat[KEM_K], PDATA0);
    polyvec_basemul_fnt_acc_montgomery(r1, (const nttpolyvec *)&fhat[0],
                                       (const nttpolyvec *)&fhat[KEM_K],
                                       PDATA2);

    invntt1_invfnt1(r0->coeffs, r0->coeffs, PDATA0, r1->coeffs, r1->coeffs,
                    PDATA2);
}

void polyvec_fnt_iprod_pre_raw(nttpoly *r0, nttpoly *r1, const polyvec *a,
                               const nttpolyvec bhat[2]) {
    unsigned int j;
    nttpolyvec ahat_n, ahat_f;
    const poly *src[KEM_K];

    for (j = 0; j < KEM_K; j++)
        src[j] = &a->vec[j];
    fwd_batch(ahat_n.vec, ahat_f.vec, src, KEM_K);

    polyvec_basemul_acc_montgomery(r0, &ahat_n, &bhat[0], PDATA0);
    polyvec_basemul_fnt_acc_montgomery(r1, &ahat_f, &bhat[1], PDATA2);

    invntt1_invfnt1(r0->coeffs, r0->coeffs, PDATA0, r1->coeffs, r1->coeffs,
                    PDATA2);
}
