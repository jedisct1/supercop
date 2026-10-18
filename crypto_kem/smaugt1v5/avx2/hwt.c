// SPDX-License-Identifier: MIT

#include "hwt.h"
#include "crypto_declassify.h"
#include "fips202.h"
#include "align.h"
#include "fips202x4.h"
#include "crypto_uint16.h"
#include "crypto_uint32.h"
#include <immintrin.h>
#include <string.h>


#define TARR(i) [i] = 65536 % (SMAUGT_N - i)

static uint16_t T_REJ[SMAUGT_N] __attribute__((aligned(32))) = {
    TARR(0),   TARR(1),   TARR(2),   TARR(3),   TARR(4),   TARR(5),   TARR(6),
    TARR(7),   TARR(8),   TARR(9),   TARR(10),  TARR(11),  TARR(12),  TARR(13),
    TARR(14),  TARR(15),  TARR(16),  TARR(17),  TARR(18),  TARR(19),  TARR(20),
    TARR(21),  TARR(22),  TARR(23),  TARR(24),  TARR(25),  TARR(26),  TARR(27),
    TARR(28),  TARR(29),  TARR(30),  TARR(31),  TARR(32),  TARR(33),  TARR(34),
    TARR(35),  TARR(36),  TARR(37),  TARR(38),  TARR(39),  TARR(40),  TARR(41),
    TARR(42),  TARR(43),  TARR(44),  TARR(45),  TARR(46),  TARR(47),  TARR(48),
    TARR(49),  TARR(50),  TARR(51),  TARR(52),  TARR(53),  TARR(54),  TARR(55),
    TARR(56),  TARR(57),  TARR(58),  TARR(59),  TARR(60),  TARR(61),  TARR(62),
    TARR(63),  TARR(64),  TARR(65),  TARR(66),  TARR(67),  TARR(68),  TARR(69),
    TARR(70),  TARR(71),  TARR(72),  TARR(73),  TARR(74),  TARR(75),  TARR(76),
    TARR(77),  TARR(78),  TARR(79),  TARR(80),  TARR(81),  TARR(82),  TARR(83),
    TARR(84),  TARR(85),  TARR(86),  TARR(87),  TARR(88),  TARR(89),  TARR(90),
    TARR(91),  TARR(92),  TARR(93),  TARR(94),  TARR(95),  TARR(96),  TARR(97),
    TARR(98),  TARR(99),  TARR(100), TARR(101), TARR(102), TARR(103), TARR(104),
    TARR(105), TARR(106), TARR(107), TARR(108), TARR(109), TARR(110), TARR(111),
    TARR(112), TARR(113), TARR(114), TARR(115), TARR(116), TARR(117), TARR(118),
    TARR(119), TARR(120), TARR(121), TARR(122), TARR(123), TARR(124), TARR(125),
    TARR(126), TARR(127), TARR(128), TARR(129), TARR(130), TARR(131), TARR(132),
    TARR(133), TARR(134), TARR(135), TARR(136), TARR(137), TARR(138), TARR(139),
    TARR(140), TARR(141), TARR(142), TARR(143), TARR(144), TARR(145), TARR(146),
    TARR(147), TARR(148), TARR(149), TARR(150), TARR(151), TARR(152), TARR(153),
    TARR(154), TARR(155), TARR(156), TARR(157), TARR(158), TARR(159), TARR(160),
    TARR(161), TARR(162), TARR(163), TARR(164), TARR(165), TARR(166), TARR(167),
    TARR(168), TARR(169), TARR(170), TARR(171), TARR(172), TARR(173), TARR(174),
    TARR(175), TARR(176), TARR(177), TARR(178), TARR(179), TARR(180), TARR(181),
    TARR(182), TARR(183), TARR(184), TARR(185), TARR(186), TARR(187), TARR(188),
    TARR(189), TARR(190), TARR(191), TARR(192), TARR(193), TARR(194), TARR(195),
    TARR(196), TARR(197), TARR(198), TARR(199), TARR(200), TARR(201), TARR(202),
    TARR(203), TARR(204), TARR(205), TARR(206), TARR(207), TARR(208), TARR(209),
    TARR(210), TARR(211), TARR(212), TARR(213), TARR(214), TARR(215), TARR(216),
    TARR(217), TARR(218), TARR(219), TARR(220), TARR(221), TARR(222), TARR(223),
    TARR(224), TARR(225), TARR(226), TARR(227), TARR(228), TARR(229), TARR(230),
    TARR(231), TARR(232), TARR(233), TARR(234), TARR(235), TARR(236), TARR(237),
    TARR(238), TARR(239), TARR(240), TARR(241), TARR(242), TARR(243), TARR(244),
    TARR(245), TARR(246), TARR(247), TARR(248), TARR(249), TARR(250), TARR(251),
    TARR(252), TARR(253), TARR(254), TARR(255),
};

#ifdef notdef
// referenced
// Décio Luiz Gazzoni Filho and Tomás S. R. Silva and Julio López
// “Efficient isochronous fixed-weight sampling with applications to {NTRU},” in
// Cryptology {ePrint} Archive, Paper 2024/548. 2024,
// url: eprint.iacr.org/2024/548.
/*************************************************
 * Name:        rej_sample_mod
 *
 * Description: Sample array of random integers such that res[i] is in the range
 *              [0, SMAUGT_N - i] for 0 <= i < SMAUGT_N
 *
 * Arguments:   - uint8_t si[SMAUGT_N]: pointer to ouptput polynomial r(x),
 *              assumed to be already initialized
 *              - const uint16_t *seed: pointer to input seed (of length
 *              SMAUGT_HWTSEEDBYTES/2)
 *
 * Specification: Implements @[KS X 123456, Algorithm 4, RejSampleMod]
 **************************************************/
#define rej_sample_mod SMAUGT_NAMESPACE(rej_sample_mod)
static int rej_sample_mod(int16_t si[SMAUGT_N], const uint16_t *rand) {
    unsigned int i, j = SMAUGT_N;
    uint32_t m;
    uint16_t s, t, l;

    for (i = 0; i < SMAUGT_N; i++) {
        s = SMAUGT_N - i;
        t = 65536 % s;

        m = (uint32_t)rand[i] * s;
        l = m;

        for (;;) {
            crypto_uint16 tlel = crypto_uint16_leq_mask(t,l);
            crypto_declassify(&tlel,sizeof tlel);
            if (tlel) break;
            if (j >= (SMAUGT_HWTSEEDBYTES / 2))
                return -1; // all randomness used
            m = (uint32_t)rand[j++] * s;
            l = m;
        }

        si[i] = m >> 16;
    }

    return 0;
}
#endif

static int rejsampling_mod(int16_t res[SMAUGT_N], const uint16_t *rand) {
    int16_t i, j = SMAUGT_N;
    int16_t k;
    uint32_t m;
    uint16_t l;

    ALIGNED_INT16(16) sv;
    sv.vec[0] = _mm256_set_epi16(SMAUGT_N - 15, SMAUGT_N - 14, SMAUGT_N - 13, SMAUGT_N - 12,
                                 SMAUGT_N - 11, SMAUGT_N - 10, SMAUGT_N - 9, SMAUGT_N - 8,
                                 SMAUGT_N - 7, SMAUGT_N - 6, SMAUGT_N - 5, SMAUGT_N - 4,
                                 SMAUGT_N - 3, SMAUGT_N - 2, SMAUGT_N - 1, SMAUGT_N);
    const __m256i delta = _mm256_set_epi16(16, 16, 16, 16, 16, 16, 16, 16, 16,
                                           16, 16, 16, 16, 16, 16, 16);
    __m256i tv;
    __m256i rv;
    __m256i lv;
    __m256i randv;
    for (i = 0; i < SMAUGT_N; i += 16) {
        randv = _mm256_load_si256((__m256i *)&rand[i]);
        tv = _mm256_load_si256((__m256i *)&T_REJ[i]);

        rv = _mm256_mulhi_epu16(randv, sv.vec[0]);
        lv = _mm256_mullo_epi16(randv, sv.vec[0]);

        uint32_t mask1 = _mm256_movemask_epi8(_mm256_cmpgt_epi32(
            _mm256_cvtepu16_epi32(_mm256_castsi256_si128(tv)),
            _mm256_cvtepu16_epi32(_mm256_castsi256_si128(lv))));
        uint32_t mask2 = _mm256_movemask_epi8(_mm256_cmpgt_epi32(
            _mm256_cvtepu16_epi32(_mm256_extracti128_si256(tv, 1)),
            _mm256_cvtepu16_epi32(_mm256_extracti128_si256(lv, 1))));

        _mm256_store_si256((__m256i *)&res[i], rv);

        crypto_declassify(&mask1,sizeof mask1);
        crypto_declassify(&mask2,sizeof mask2);

        while (mask1 != 0) {
            k = __builtin_ctz(mask1) / 4;
            for (;;) {
                if (j >= (SMAUGT_HWTSEEDBYTES / 2)) {
                    return -1;
                }
                m = (uint32_t)rand[j] * sv.coeffs[k];
                j++;
                l = m;
                uint32_t tlel = crypto_uint32_leq_01(T_REJ[i + k],l);
                crypto_declassify(&tlel,sizeof tlel);
                if (tlel) break;
            }
            res[i + k] = m >> 16;
            mask1 ^= 0xfu << (4 * k);
        }

        while (mask2 != 0) {
            k = __builtin_ctz(mask2) / 4;
            for (;;) {
                if (j >= (SMAUGT_HWTSEEDBYTES / 2)) {
                    return -1;
                }
                m = (uint32_t)rand[j] * sv.coeffs[8 + k];
                j++;
                l = m;
                uint32_t tlel = crypto_uint32_leq_01(T_REJ[i + 8 + k],l);
                crypto_declassify(&tlel,sizeof tlel);
                if (tlel) break;
            }
            res[i + 8 + k] = m >> 16;
            mask2 ^= 0xfu << (4 * k);
        }
        sv.vec[0] = _mm256_sub_epi16(sv.vec[0], delta);
    }
    return 0;
}

/*************************************************
 * Name:        hwt_jobs
 *
 * Description: Set up the SMAUGT_K SHAKE256 evaluations of ExpandS, lane i
 *              absorbing seed || SMAUGT_K * i || 0, so that the caller can
 *              batch them with other independent XOF calls in keccakx4_jobs.
 *
 * Arguments:   - keccak_job *jobs: pointer to output jobs (SMAUGT_K entries)
 *              - hwt_ws *ws: pointer to workspace holding the XOF inputs and
 *              outputs
 *              - const uint8_t *seed: pointer to input seed (of length
 *              SMAUGT_crypto_BYTES)
 *
 * Returns the number of jobs written (SMAUGT_K)
 **************************************************/
unsigned int hwt_jobs(keccak_job *jobs, hwt_ws *ws, const uint8_t *seed) {
    unsigned int i;

    for (i = 0; i < SMAUGT_K; ++i) {
        memcpy(ws->seed[i], seed, SMAUGT_crypto_BYTES);
        ws->seed[i][SMAUGT_crypto_BYTES] = SMAUGT_K * i;
        ws->seed[i][SMAUGT_crypto_BYTES + 1] = 0;
        keccak_job_shake256(&jobs[i], ws->buf[i].bytes, SMAUGT_HWT_XOF_BYTES,
                            ws->seed[i], SMAUGT_crypto_BYTES + 2);
    }
    return SMAUGT_K;
}

/*************************************************
 * Name:        hwt_finish
 *
 * Description: Hamming weight sampling of the SMAUGT_K sparse polynomials of
 *              the secret from the XOF outputs produced by the jobs of
 *              hwt_jobs. If a lane runs out of randomness (negligible
 *              probability) it is re-squeezed with the next counter byte, as
 *              in the reference implementation.
 *
 * Arguments:   - int16_t *res: pointer to ouptput polynomials (SMAUGT_K
 *              consecutive polynomials of SMAUGT_N coefficients)
 *              - hwt_ws *ws: pointer to workspace filled by hwt_jobs and
 *              keccakx4_jobs
 *
 * Specification: Implements @[KS X 123456, Algorithm 3, HWT]
 **************************************************/
void hwt_finish(int16_t *res, hwt_ws *ws) {
    unsigned int i, j, nretry;
    ALIGNED_INT16(SMAUGT_N) si[SMAUGT_K];
    keccak_job jobs[SMAUGT_K];
    unsigned int todo = (1 << SMAUGT_K) - 1;

    for (;;) {
        for (i = 0; i < SMAUGT_K; ++i) {
            if (((todo >> i) & 1) &&
                rejsampling_mod(si[i].coeffs, ws->buf[i].rand) == 0)
                todo &= ~(1u << i); // randomness was sufficient (happens with
                                    // overwhelming prob)
        }
        if (todo == 0)
            break;

        nretry = 0;
        for (i = 0; i < SMAUGT_K; ++i) {
            if ((todo >> i) & 1) {
                ws->seed[i][SMAUGT_crypto_BYTES + 1] += 1;
                keccak_job_shake256(&jobs[nretry++], ws->buf[i].bytes,
                                    SMAUGT_HWT_XOF_BYTES, ws->seed[i],
                                    SMAUGT_crypto_BYTES + 2);
            }
        }
        keccakx4_jobs(jobs, nretry);
    }


    uint16_t c0[SMAUGT_K];
    for (i = 0; i < SMAUGT_K; ++i)
        c0[i] = SMAUGT_N - SMAUGT_HS;
    for (j = 0; j < SMAUGT_N; j++) {
        for (i = 0; i < SMAUGT_K; ++i) {
            uint16_t lt = (uint16_t)si[i].coeffs[j] < c0[i];
            c0[i] -= lt;
            res[i * SMAUGT_N + j] = 1 - lt;
        }
    }

    // Coefficient j is +1 if bit (j / 16) % 8 of sign byte
    // (j / 128) * 16 + j % 16 is set and -1 otherwise (when nonzero).
    for (i = 0; i < SMAUGT_K; ++i) {
        const uint8_t *sign = ws->buf[i].bytes + SMAUGT_HWTSEEDBYTES;
        __m256i *r = (__m256i *)&res[i * SMAUGT_N];

        for (j = 0; j < SMAUGT_N / 16; j++) {
            __m256i b = _mm256_cvtepu8_epi16(
                _mm_loadu_si128((const __m128i *)&sign[(j >> 3) << 4]));
            // ns = 0 if the sign bit is set, -1 otherwise
            __m256i ns = _mm256_srai_epi16(
                _mm256_sll_epi16(_mm256_xor_si256(b, _mm256_set1_epi16(-1)),
                                 _mm_cvtsi32_si128(15 - (j & 7))),
                15);
            __m256i m = _mm256_loadu_si256(&r[j]);
            _mm256_storeu_si256(&r[j],
                                _mm256_sub_epi16(_mm256_xor_si256(m, ns), ns));
        }
    }
}

/*************************************************
 * Name:        hwt
 *
 * Description: Hamming weight sampling deterministically to generate the
 *              SMAUGT_K sparse polynomials of the secret from a seed.
 *              shake256 is the Extendable-Output Function from the SHA-3
 *              family.
 *
 * Arguments:   - int16_t *res: pointer to ouptput polynomials (SMAUGT_K
 *              consecutive polynomials of SMAUGT_N coefficients)
 *              - const uint8_t *seed: pointer to input seed (of length
 *              SMAUGT_crypto_BYTES)
 *
 * Specification: Implements @[KS X 123456, Algorithm 3, HWT]
 **************************************************/
int hwt(int16_t *res, const uint8_t *seed) {
    hwt_ws ws;
    keccak_job jobs[SMAUGT_K];

    keccakx4_jobs(jobs, hwt_jobs(jobs, &ws, seed));
    hwt_finish(res, &ws);
    return 0;
}
