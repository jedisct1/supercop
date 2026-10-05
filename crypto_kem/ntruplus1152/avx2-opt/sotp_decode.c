/*
 * NTRU+1152 AVX2 (avx2-opt): poly_sotp_decode.
 * Official NTRU+ AVX2 poly.c:poly_sotp_decode, unchanged apart from the
 * namespaced symbol.  Of the rest of Official's poly.c, poly_baseinv and its
 * helpers continue as baseinv.c (with the R^2 input scale), and the rest is
 * not used by this KEM.
 */
#include <stdint.h>

#include "params.h"
#include "poly.h"

/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decode a message deterministically using SOTP_INV and a random
*
* Arguments:   - uint8_t *msg: pointer to output message
*              - const poly *a: pointer to iput polynomial
*              - const uint8_t *buf: pointer to input random
*
* Returns 0 (success) or 1 (failure)
**************************************************/
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N/8], const poly *a, const uint8_t buf[NTRUPLUS_N/4])
{
    const __m256i mask55 = _mm256_set1_epi8((char)0x55);
    const __m256i maskff = _mm256_set1_epi8((char)0xff);
    const __m256i mask01 = _mm256_set1_epi8((char)0x01);
    const __m256i mask_lo = _mm256_set1_epi16((int16_t)0x00ff);
    const __m256i mask_hi = _mm256_set1_epi16((int16_t)0xff00);
          __m256i fail_mask = _mm256_set1_epi8((char)0xff);

    {
        const size_t tail = NTRUPLUS_N / 8 - 32;
        const int16_t *tcoeffs = a->coeffs + 8 * tail;
        const uint8_t *tbuf_lo = buf + tail;
        const uint8_t *tbuf_hi = buf + tail + NTRUPLUS_N / 8;
        uint8_t *tmsg = msg + tail;

        __m256i a0 = _mm256_load_si256((const __m256i *)(tcoeffs +   0));
        __m256i a1 = _mm256_load_si256((const __m256i *)(tcoeffs +  64));
        __m256i a2 = _mm256_load_si256((const __m256i *)(tcoeffs + 128));
        __m256i a3 = _mm256_load_si256((const __m256i *)(tcoeffs + 192));
        __m256i a4 = _mm256_load_si256((const __m256i *)(tcoeffs +  16));
        __m256i a5 = _mm256_load_si256((const __m256i *)(tcoeffs +  80));
        __m256i a6 = _mm256_load_si256((const __m256i *)(tcoeffs + 144));
        __m256i a7 = _mm256_load_si256((const __m256i *)(tcoeffs + 208));

        __m256i b0 = _mm256_packs_epi16(a0, a1);
        __m256i b1 = _mm256_packs_epi16(a2, a3);
        __m256i b2 = _mm256_packs_epi16(a4, a5);
        __m256i b3 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_load_si256((const __m256i *)(tcoeffs +  32));
        a1 = _mm256_load_si256((const __m256i *)(tcoeffs +  96));
        a2 = _mm256_load_si256((const __m256i *)(tcoeffs + 160));
        a3 = _mm256_load_si256((const __m256i *)(tcoeffs + 224));
        a4 = _mm256_load_si256((const __m256i *)(tcoeffs +  48));
        a5 = _mm256_load_si256((const __m256i *)(tcoeffs + 112));
        a6 = _mm256_load_si256((const __m256i *)(tcoeffs + 176));
        a7 = _mm256_load_si256((const __m256i *)(tcoeffs + 240));

        __m256i b4 = _mm256_packs_epi16(a0, a1);
        __m256i b5 = _mm256_packs_epi16(a2, a3);
        __m256i b6 = _mm256_packs_epi16(a4, a5);
        __m256i b7 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_permute2x128_si256(b0, b1, 0x20);
        a1 = _mm256_permute2x128_si256(b0, b1, 0x31);
        a2 = _mm256_permute2x128_si256(b2, b3, 0x20);
        a3 = _mm256_permute2x128_si256(b2, b3, 0x31);
        a4 = _mm256_permute2x128_si256(b4, b5, 0x20);
        a5 = _mm256_permute2x128_si256(b4, b5, 0x31);
        a6 = _mm256_permute2x128_si256(b6, b7, 0x20);
        a7 = _mm256_permute2x128_si256(b6, b7, 0x31);

        b0 = _mm256_slli_epi64(a4, 32);
        b1 = _mm256_srli_epi64(a0, 32);
        b2 = _mm256_slli_epi64(a5, 32);
        b3 = _mm256_srli_epi64(a1, 32);

        b0 = _mm256_blend_epi32(a0, b0, 0xaa);
        b1 = _mm256_blend_epi32(a4, b1, 0x55);
        b2 = _mm256_blend_epi32(a1, b2, 0xaa);
        b3 = _mm256_blend_epi32(a5, b3, 0x55);

        b4 = _mm256_slli_epi64(a6, 32);
        b5 = _mm256_srli_epi64(a2, 32);
        b6 = _mm256_slli_epi64(a7, 32);
        b7 = _mm256_srli_epi64(a3, 32);

        b4 = _mm256_blend_epi32(a2, b4, 0xaa);
        b5 = _mm256_blend_epi32(a6, b5, 0x55);
        b6 = _mm256_blend_epi32(a3, b6, 0xaa);
        b7 = _mm256_blend_epi32(a7, b7, 0x55);

        a0 = _mm256_slli_epi32(b4, 16);
        a1 = _mm256_srli_epi32(b0, 16);
        a2 = _mm256_slli_epi32(b5, 16);
        a3 = _mm256_srli_epi32(b1, 16);

        a0 = _mm256_blend_epi16(b0, a0, 0xaa);
        a1 = _mm256_blend_epi16(b4, a1, 0x55);
        a2 = _mm256_blend_epi16(b1, a2, 0xaa);
        a3 = _mm256_blend_epi16(b5, a3, 0x55);

        a4 = _mm256_slli_epi32(b6, 16);
        a5 = _mm256_srli_epi32(b2, 16);
        a6 = _mm256_slli_epi32(b7, 16);
        a7 = _mm256_srli_epi32(b3, 16);

        a4 = _mm256_blend_epi16(b2, a4, 0xaa);
        a5 = _mm256_blend_epi16(b6, a5, 0x55);
        a6 = _mm256_blend_epi16(b3, a6, 0xaa);
        a7 = _mm256_blend_epi16(b7, a7, 0x55);

        __m256i t0 = _mm256_and_si256(a0, mask_lo);
        __m256i t1 = _mm256_slli_epi16(a4, 8);
        __m256i t2 = _mm256_srli_epi16(a0, 8);
        __m256i t3 = _mm256_and_si256(a4, mask_hi);

        b0 = _mm256_xor_si256(t0, t1);
        b1 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a1, mask_lo);
        t1 = _mm256_slli_epi16(a5, 8);
        t2 = _mm256_srli_epi16(a1, 8);
        t3 = _mm256_and_si256(a5, mask_hi);

        b2 = _mm256_xor_si256(t0, t1);
        b3 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a2, mask_lo);
        t1 = _mm256_slli_epi16(a6, 8);
        t2 = _mm256_srli_epi16(a2, 8);
        t3 = _mm256_and_si256(a6, mask_hi);

        b4 = _mm256_xor_si256(t0, t1);
        b5 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a3, mask_lo);
        t1 = _mm256_slli_epi16(a7, 8);
        t2 = _mm256_srli_epi16(a3, 8);
        t3 = _mm256_and_si256(a7, mask_hi);

        b6 = _mm256_xor_si256(t0, t1);
        b7 = _mm256_xor_si256(t2, t3);

        b0 = _mm256_add_epi8(b0, mask01);
        b1 = _mm256_add_epi8(b1, mask01);
        b2 = _mm256_add_epi8(b2, mask01);
        b3 = _mm256_add_epi8(b3, mask01);
        b4 = _mm256_add_epi8(b4, mask01);
        b5 = _mm256_add_epi8(b5, mask01);
        b6 = _mm256_add_epi8(b6, mask01);
        b7 = _mm256_add_epi8(b7, mask01);

        b2 = _mm256_slli_epi16(b2, 2);
        b3 = _mm256_slli_epi16(b3, 2);
        b4 = _mm256_slli_epi16(b4, 4);
        b5 = _mm256_slli_epi16(b5, 4);
        b6 = _mm256_slli_epi16(b6, 6);
        b7 = _mm256_slli_epi16(b7, 6);

        a0 = _mm256_xor_si256(b0, b2);
        a1 = _mm256_xor_si256(b1, b3);
        a2 = _mm256_xor_si256(b4, b6);
        a3 = _mm256_xor_si256(b5, b7);

        a0 = _mm256_xor_si256(a0, a2);
        a1 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_loadu_si256((const __m256i *)tbuf_hi);
        a3 = _mm256_srli_epi16(a2, 1);

        a2 = _mm256_and_si256(a2, mask55);
        a3 = _mm256_and_si256(a3, mask55);

        a0 = _mm256_add_epi8(a0, a2);
        a1 = _mm256_add_epi8(a1, a3);

        //handling error
        a2 = _mm256_srli_epi16(a0, 1);
        a3 = _mm256_srli_epi16(a1, 1);

        a2 = _mm256_xor_si256(a0, a2);
        a3 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_and_si256(a2, a3);
        fail_mask = _mm256_and_si256(fail_mask, a2);

        //extract bits
        a0 = _mm256_and_si256(a0, mask55);
        a1 = _mm256_and_si256(a1, mask55);
        a1 = _mm256_slli_epi16(a1, 1);

        a0 = _mm256_xor_si256(a0, a1);
        a0 = _mm256_xor_si256(a0, maskff);

        a1 = _mm256_loadu_si256((const __m256i *)tbuf_lo);

        a0 = _mm256_xor_si256(a0, a1);

        _mm256_storeu_si256((__m256i *)tmsg, a0);
    }

    const int16_t *coeffs = a->coeffs;
    const uint8_t *buf_lo = buf;
    const uint8_t *buf_hi = buf + NTRUPLUS_N / 8;
    uint8_t *msgp = msg;

    for (size_t i = 0; i < NTRUPLUS_N / 256; i++)
    {
        __m256i a0 = _mm256_load_si256((const __m256i *)(coeffs +   0));
        __m256i a1 = _mm256_load_si256((const __m256i *)(coeffs +  64));
        __m256i a2 = _mm256_load_si256((const __m256i *)(coeffs + 128));
        __m256i a3 = _mm256_load_si256((const __m256i *)(coeffs + 192));
        __m256i a4 = _mm256_load_si256((const __m256i *)(coeffs +  16));
        __m256i a5 = _mm256_load_si256((const __m256i *)(coeffs +  80));
        __m256i a6 = _mm256_load_si256((const __m256i *)(coeffs + 144));
        __m256i a7 = _mm256_load_si256((const __m256i *)(coeffs + 208));

        __m256i b0 = _mm256_packs_epi16(a0, a1);
        __m256i b1 = _mm256_packs_epi16(a2, a3);
        __m256i b2 = _mm256_packs_epi16(a4, a5);
        __m256i b3 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_load_si256((const __m256i *)(coeffs +  32));
        a1 = _mm256_load_si256((const __m256i *)(coeffs +  96));
        a2 = _mm256_load_si256((const __m256i *)(coeffs + 160));
        a3 = _mm256_load_si256((const __m256i *)(coeffs + 224));
        a4 = _mm256_load_si256((const __m256i *)(coeffs +  48));
        a5 = _mm256_load_si256((const __m256i *)(coeffs + 112));
        a6 = _mm256_load_si256((const __m256i *)(coeffs + 176));
        a7 = _mm256_load_si256((const __m256i *)(coeffs + 240));

        __m256i b4 = _mm256_packs_epi16(a0, a1);
        __m256i b5 = _mm256_packs_epi16(a2, a3);
        __m256i b6 = _mm256_packs_epi16(a4, a5);
        __m256i b7 = _mm256_packs_epi16(a6, a7);

        a0 = _mm256_permute2x128_si256(b0, b1, 0x20);
        a1 = _mm256_permute2x128_si256(b0, b1, 0x31);
        a2 = _mm256_permute2x128_si256(b2, b3, 0x20);
        a3 = _mm256_permute2x128_si256(b2, b3, 0x31);
        a4 = _mm256_permute2x128_si256(b4, b5, 0x20);
        a5 = _mm256_permute2x128_si256(b4, b5, 0x31);
        a6 = _mm256_permute2x128_si256(b6, b7, 0x20);
        a7 = _mm256_permute2x128_si256(b6, b7, 0x31);

        b0 = _mm256_slli_epi64(a4, 32);
        b1 = _mm256_srli_epi64(a0, 32);
        b2 = _mm256_slli_epi64(a5, 32);
        b3 = _mm256_srli_epi64(a1, 32);

        b0 = _mm256_blend_epi32(a0, b0, 0xaa);
        b1 = _mm256_blend_epi32(a4, b1, 0x55);
        b2 = _mm256_blend_epi32(a1, b2, 0xaa);
        b3 = _mm256_blend_epi32(a5, b3, 0x55);

        b4 = _mm256_slli_epi64(a6, 32);
        b5 = _mm256_srli_epi64(a2, 32);
        b6 = _mm256_slli_epi64(a7, 32);
        b7 = _mm256_srli_epi64(a3, 32);

        b4 = _mm256_blend_epi32(a2, b4, 0xaa);
        b5 = _mm256_blend_epi32(a6, b5, 0x55);
        b6 = _mm256_blend_epi32(a3, b6, 0xaa);
        b7 = _mm256_blend_epi32(a7, b7, 0x55);

        a0 = _mm256_slli_epi32(b4, 16);
        a1 = _mm256_srli_epi32(b0, 16);
        a2 = _mm256_slli_epi32(b5, 16);
        a3 = _mm256_srli_epi32(b1, 16);

        a0 = _mm256_blend_epi16(b0, a0, 0xaa);
        a1 = _mm256_blend_epi16(b4, a1, 0x55);
        a2 = _mm256_blend_epi16(b1, a2, 0xaa);
        a3 = _mm256_blend_epi16(b5, a3, 0x55);

        a4 = _mm256_slli_epi32(b6, 16);
        a5 = _mm256_srli_epi32(b2, 16);
        a6 = _mm256_slli_epi32(b7, 16);
        a7 = _mm256_srli_epi32(b3, 16);

        a4 = _mm256_blend_epi16(b2, a4, 0xaa);
        a5 = _mm256_blend_epi16(b6, a5, 0x55);
        a6 = _mm256_blend_epi16(b3, a6, 0xaa);
        a7 = _mm256_blend_epi16(b7, a7, 0x55);

        __m256i t0 = _mm256_and_si256(a0, mask_lo);
        __m256i t1 = _mm256_slli_epi16(a4, 8);
        __m256i t2 = _mm256_srli_epi16(a0, 8);
        __m256i t3 = _mm256_and_si256(a4, mask_hi);

        b0 = _mm256_xor_si256(t0, t1);
        b1 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a1, mask_lo);
        t1 = _mm256_slli_epi16(a5, 8);
        t2 = _mm256_srli_epi16(a1, 8);
        t3 = _mm256_and_si256(a5, mask_hi);

        b2 = _mm256_xor_si256(t0, t1);
        b3 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a2, mask_lo);
        t1 = _mm256_slli_epi16(a6, 8);
        t2 = _mm256_srli_epi16(a2, 8);
        t3 = _mm256_and_si256(a6, mask_hi);

        b4 = _mm256_xor_si256(t0, t1);
        b5 = _mm256_xor_si256(t2, t3);

        t0 = _mm256_and_si256(a3, mask_lo);
        t1 = _mm256_slli_epi16(a7, 8);
        t2 = _mm256_srli_epi16(a3, 8);
        t3 = _mm256_and_si256(a7, mask_hi);

        b6 = _mm256_xor_si256(t0, t1);
        b7 = _mm256_xor_si256(t2, t3);

        b0 = _mm256_add_epi8(b0, mask01);
        b1 = _mm256_add_epi8(b1, mask01);
        b2 = _mm256_add_epi8(b2, mask01);
        b3 = _mm256_add_epi8(b3, mask01);
        b4 = _mm256_add_epi8(b4, mask01);
        b5 = _mm256_add_epi8(b5, mask01);
        b6 = _mm256_add_epi8(b6, mask01);
        b7 = _mm256_add_epi8(b7, mask01);

        b2 = _mm256_slli_epi16(b2, 2);
        b3 = _mm256_slli_epi16(b3, 2);
        b4 = _mm256_slli_epi16(b4, 4);
        b5 = _mm256_slli_epi16(b5, 4);
        b6 = _mm256_slli_epi16(b6, 6);
        b7 = _mm256_slli_epi16(b7, 6);

        a0 = _mm256_xor_si256(b0, b2);
        a1 = _mm256_xor_si256(b1, b3);
        a2 = _mm256_xor_si256(b4, b6);
        a3 = _mm256_xor_si256(b5, b7);

        a0 = _mm256_xor_si256(a0, a2);
        a1 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_loadu_si256((const __m256i *)buf_hi);
        a3 = _mm256_srli_epi16(a2, 1);

        a2 = _mm256_and_si256(a2, mask55);
        a3 = _mm256_and_si256(a3, mask55);

        a0 = _mm256_add_epi8(a0, a2);
        a1 = _mm256_add_epi8(a1, a3);

        //handling error
        a2 = _mm256_srli_epi16(a0, 1);
        a3 = _mm256_srli_epi16(a1, 1);

        a2 = _mm256_xor_si256(a0, a2);
        a3 = _mm256_xor_si256(a1, a3);

        a2 = _mm256_and_si256(a2, a3);
        fail_mask = _mm256_and_si256(fail_mask, a2);

        //extract bits
        a0 = _mm256_and_si256(a0, mask55);
        a1 = _mm256_and_si256(a1, mask55);
        a1 = _mm256_slli_epi16(a1, 1);

        a0 = _mm256_xor_si256(a0, a1);
        a0 = _mm256_xor_si256(a0, maskff);

        a1 = _mm256_loadu_si256((const __m256i *)buf_lo);

        a0 = _mm256_xor_si256(a0, a1);

        _mm256_storeu_si256((__m256i *)msgp, a0);

        coeffs += 256;
        buf_lo += 32;
        buf_hi += 32;
        msgp   += 32;
    }

    fail_mask = _mm256_xor_si256(fail_mask, maskff);
    fail_mask = _mm256_and_si256(fail_mask, mask55);

    int fail = !_mm256_testz_si256(fail_mask, fail_mask);
    volatile uint8_t mask = (uint8_t)(fail - 1);
    const __m256i m = _mm256_set1_epi8((char)mask);
    size_t i = 0;

    for (; i + 32 <= NTRUPLUS_N / 8; i += 32)
    {
        __m256i x = _mm256_loadu_si256((const __m256i *)(msg + i));
        x = _mm256_and_si256(x, m);
        _mm256_storeu_si256((__m256i *)(msg + i), x);
    }

    for (; i < NTRUPLUS_N / 8; i++)
        msg[i] &= mask;

    return fail;
}
