#include "ntt.h"
#include "config.h"
#include "consts.h"
#include <assert.h>
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

static inline __m256i reduce(const __m256i a, const __m256i p,
                             const int16_t *pdata) {
    __m256i t;
    const __m256i v = _mm256_load_si256((__m256i *)&pdata[_16XV]);
    const __m256i shift = _mm256_load_si256((__m256i *)&pdata[_16XSHIFT]);
    t = _mm256_mulhi_epi16(a, v);
    t = _mm256_mulhrs_epi16(t, shift);
    t = _mm256_mullo_epi16(t, p);
    t = _mm256_sub_epi16(a, t);
    return t;
}

void poly_crt(poly *r, const nttpoly *a, const nttpoly *b) {
    unsigned int i;
    __m256i f0, f1;
    const __m256i u_pinv = _mm256_set1_epi16(CRT_U_PINV);
    const __m256i u = _mm256_set1_epi16(CRT_U);
    const __m256i p0 = _mm256_load_si256((__m256i *)&PDATA0[_16XP]);
    const __m256i p1 = _mm256_load_si256((__m256i *)&PDATA1[_16XP]);
    const __m256i mod = _mm256_set1_epi16(KEM_Q - 1);
    const __m256i mont0_pinv =
        _mm256_load_si256((__m256i *)&PDATA0[_16XMONT_PINV]);
    const __m256i mont0 = _mm256_load_si256((__m256i *)&PDATA0[_16XMONT]);

    for (i = 0; i < KEM_N / 16; i++) {
        f0 = _mm256_load_si256((__m256i *)&a->coeffs[16 * i]);
        f1 = _mm256_load_si256((__m256i *)&b->coeffs[16 * i]);
        f0 = mulmod(f0, mont0_pinv, mont0, p0); // extra reduction
        f1 = _mm256_sub_epi16(f1, f0);
        f1 = mulmod(f1, u_pinv, u, p1);
        f1 = _mm256_mullo_epi16(f1, p0);
        f0 = _mm256_add_epi16(f0, f1);
        f0 = _mm256_and_si256(f0, mod);
        _mm256_store_si256((__m256i *)&r->coeffs[16 * i], f0);
    }
}

void poly_mul(poly *r, const poly *a, const poly *b) {
    unsigned int i;
    poly a2, b2;
    nttpoly ahat, bhat, chat;
    const __m256i mod = _mm256_set1_epi16(KEM_Q - 1);
    const __m256i q = _mm256_set1_epi16(KEM_Q);
    const __m256i hq = _mm256_set1_epi16(KEM_Q / 2 - 1);
    __m256i f, g, t, u;

#if 0
  for(int k=0;k<KEM_N;k++)
    assert(a->coeffs[k] < KEM_Q/2 && a->coeffs[k] >= -KEM_Q/2);

  for(int k=0;k<KEM_N;k++)
    assert(b->coeffs[k] <= 6  && b->coeffs[k] >= -6);
#endif

    for (i = 0; i < (KEM_N + 15) / 16; i++) {
        f = _mm256_load_si256((__m256i *)&a->coeffs[16 * i]);
        g = _mm256_load_si256((__m256i *)&b->coeffs[16 * i]);
        f = _mm256_and_si256(f, mod);
        g = _mm256_and_si256(g, mod);
        t = _mm256_cmpgt_epi16(f, hq);
        u = _mm256_cmpgt_epi16(g, hq);
        t = _mm256_and_si256(t, q);
        u = _mm256_and_si256(u, q);
        f = _mm256_sub_epi16(f, t);
        g = _mm256_sub_epi16(g, u);
        _mm256_store_si256((__m256i *)&a2.coeffs[16 * i], f);
        _mm256_store_si256((__m256i *)&b2.coeffs[16 * i], g);
    }

    f = _mm256_setzero_si256();
    while (i < POLY_N / 16) {
        _mm256_store_si256((__m256i *)&a2.coeffs[16 * i], f);
        _mm256_store_si256((__m256i *)&b2.coeffs[16 * i], f);
        i += 1;
    }

    for (i = KEM_N; i < (KEM_N + 15) / 16 * 16; i++)
        a2.coeffs[i] = b2.coeffs[i] = 0;

    poly_ntt(&ahat, &a2, PDATA0);
    poly_ntt(&bhat, &b2, PDATA0);
    poly_basemul_montgomery(&ahat, &ahat, &bhat, PDATA0);
    poly_invntt_tomont(&ahat, &ahat, PDATA0);
    poly_ntt(&bhat, &a2, PDATA1);
    poly_ntt(&chat, &b2, PDATA1);
    poly_basemul_montgomery(&bhat, &bhat, &chat, PDATA1);
    poly_invntt_tomont(&bhat, &bhat, PDATA1);
    poly_crt(r, &ahat, &bhat);
}

void polyvec_ntt(nttpolyvec *r, const polyvec *a, const int16_t *pdata) {
    unsigned int i;
    for (i = 0; i < KEM_K; i++)
        poly_ntt(&r->vec[i], &a->vec[i], pdata);
}

void polyvec_invntt_tomont(nttpolyvec *r, const nttpolyvec *a,
                           const int16_t *pdata) {
    unsigned int i;
    for (i = 0; i < KEM_K; i++)
        poly_invntt_tomont(&r->vec[i], &a->vec[i], pdata);
}

void polyvec_crt(polyvec *r, const nttpolyvec *a, const nttpolyvec *b) {
    unsigned int i;
    for (i = 0; i < KEM_K; i++)
        poly_crt(&r->vec[i], &a->vec[i], &b->vec[i]);
}

void polyvec_matrix_vector_mul(polyvec *t, nttpolyvec shat[2],
                               const polyvec a[KEM_K], const polyvec *s,
                               int transpose) {
    unsigned int i, j;
    nttpolyvec ahat, t0, t1;

    polyvec_ntt(&shat[0], s, PDATA0);
    for (i = 0; i < KEM_K; i++) {
        for (j = 0; j < KEM_K; j++) {
            if (transpose)
                poly_ntt(&ahat.vec[j], &a[j].vec[i], PDATA0);
            else
                poly_ntt(&ahat.vec[j], &a[i].vec[j], PDATA0);
        }
        polyvec_basemul_acc_montgomery(&t0.vec[i], &ahat, &shat[0], PDATA0);
    }

    polyvec_ntt(&shat[1], s, PDATA1);
    for (i = 0; i < KEM_K; i++) {
        for (j = 0; j < KEM_K; j++) {
            if (transpose)
                poly_ntt(&ahat.vec[j], &a[j].vec[i], PDATA1);
            else
                poly_ntt(&ahat.vec[j], &a[i].vec[j], PDATA1);
        }
        polyvec_basemul_acc_montgomery(&t1.vec[i], &ahat, &shat[1], PDATA1);
    }

    polyvec_invntt_tomont(&t0, &t0, PDATA0);
    polyvec_invntt_tomont(&t1, &t1, PDATA1);
    polyvec_crt(t, &t0, &t1);
}

void polyvec_iprod(poly *r, const polyvec *a, const polyvec *b) {
    nttpoly r0, r1;
    nttpolyvec ahat;
    nttpolyvec bhat;

    polyvec_ntt(&ahat, a, PDATA0);
    polyvec_ntt(&bhat, b, PDATA0);
    polyvec_basemul_acc_montgomery(&r0, &ahat, &bhat, PDATA0);

    polyvec_ntt(&ahat, a, PDATA1);
    polyvec_ntt(&bhat, b, PDATA1);
    polyvec_basemul_acc_montgomery(&r1, &ahat, &bhat, PDATA1);

    poly_invntt_tomont(&r0, &r0, PDATA0);
    poly_invntt_tomont(&r1, &r1, PDATA1);
    poly_crt(r, &r0, &r1);
}

void polyvec_iprod_ntt(poly *r, const polyvec *a, const nttpolyvec bhat[2]) {
    nttpoly r0, r1;
    nttpolyvec ahat;

    polyvec_ntt(&ahat, a, PDATA0);
    polyvec_basemul_acc_montgomery(&r0, &ahat, &bhat[0], PDATA0);

    polyvec_ntt(&ahat, a, PDATA1);
    polyvec_basemul_acc_montgomery(&r1, &ahat, &bhat[1], PDATA1);

    poly_invntt_tomont(&r0, &r0, PDATA0);
    poly_invntt_tomont(&r1, &r1, PDATA1);
    poly_crt(r, &r0, &r1);
}
