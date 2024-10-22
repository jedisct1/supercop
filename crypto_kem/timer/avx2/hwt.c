#include "hwt.h"
#include "align.h"
#include "fips202x4.h"
#include <immintrin.h>
#include <stdio.h>
#include "crypto_uint16.h"
#include "crypto_uint32.h"
#include "crypto_declassify.h"

#define TARR(i) [i] = 65536 % (LWE_N - i)

static uint16_t T_REJ[LWE_N] __attribute__((aligned(32))) = {
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
/*************************************************
 * Name:        load16_littleendian
 *
 * Description: load 2 bytes into a 16-bit integer
 *              in little-endian order
 *
 * Arguments:   - uint16_t *out: pointer to output int16_t array
 *              - int outlen: output length
 *              - uint8_t *in: pointer to input byte array
 **************************************************/
static void load16_littleendian(uint16_t *out, const int outlen,
                                const uint8_t *in) {
    int pos = 0;
    for (int i = 0; i < outlen; ++i) {
        out[i] = ((uint16_t)(in[pos])) | ((uint16_t)(in[pos + 1]) << 8);
        pos += 2;
    }
}

// referenced
// Décio Luiz Gazzoni Filho and Tomás S. R. Silva and Julio López
// “Efficient isochronous fixed-weight sampling with applications to {NTRU},” in
// Cryptology {ePrint} Archive, Paper 2024/548. 2024,
// url: eprint.iacr.org/2024/548.
/*************************************************
 * Name:        rejsampling_mod
 *
 * Description: Sample array of random integers such that res[i] is in the range
 *              [0, LWE_N - i] for 0 <= i < LWE_N
 *
 * Arguments:   - uint8_t *res: pointer to ouptput polynomial r(x)
 *                (of length LWE), assumed to be already initialized
 *              - uint8_t *seed: pointer to input seed (of length
 *input_size)
 **************************************************/
static int rejsampling_mod(int16_t res[LWE_N], const uint16_t *rand) {
    int16_t i, j = LWE_N;
    int16_t k;
    uint32_t m;
    uint16_t l;

    ALIGNED_INT16(16) sv;
    sv.vec[0] = _mm256_set_epi16(LWE_N - 15, LWE_N - 14, LWE_N - 13, LWE_N - 12,
                                 LWE_N - 11, LWE_N - 10, LWE_N - 9, LWE_N - 8,
                                 LWE_N - 7, LWE_N - 6, LWE_N - 5, LWE_N - 4,
                                 LWE_N - 3, LWE_N - 2, LWE_N - 1, LWE_N);
    const __m256i delta = _mm256_set_epi16(16, 16, 16, 16, 16, 16, 16, 16, 16,
                                           16, 16, 16, 16, 16, 16, 16);
    __m256i tv;
    __m256i rv;
    __m256i lv;
    __m256i randv;
    for (i = 0; i < LWE_N; i += 16) {
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
                crypto_uint16 tlel;
                if (j >= (HWTSEEDBYTES / 2)) {
                    return -1;
                }
                m = (uint32_t)rand[j] * sv.coeffs[k];
                j++;
                l = m;
                tlel = crypto_uint16_leq_mask(T_REJ[i + k],l);
                crypto_declassify(&tlel,sizeof tlel);
                if (tlel) break;
            }
            res[i + k] = m >> 16;
            mask1 ^= 0xf << (4 * k);
        }

        while (mask2 != 0) {
            k = __builtin_ctz(mask2) / 4;
            for (;;) {
                crypto_uint16 tlel;
                if (j >= (HWTSEEDBYTES / 2)) {
                    return -1;
                }
                m = (uint32_t)rand[j] * sv.coeffs[8 + k];
                j++;
                l = m;
                tlel = crypto_uint16_leq_mask(T_REJ[i + 8 + k],l);
                crypto_declassify(&tlel,sizeof tlel);
                if (tlel) break;
            }
            res[i + 8 + k] = m >> 16;
            mask2 ^= 0xf << (4 * k);
        }
        sv.vec[0] = _mm256_sub_epi16(sv.vec[0], delta);
    }
    return 0;
}

/*************************************************
 * Name:        hwt
 *
 * Description: Hamming weight sampling deterministically to generate sparse
 *              polynomial r(x) from a seed. shake256 is the Extendable-Output
 *              Function from the SHA-3 family.
 *
 * Arguments:   - polyvec *r: pointer to ouptput polynomial vector r(x)
 *                assumed to be already initialized
 *              - uint8_t *seed: pointer to input seed (of length crypto_BYTES)
 **************************************************/
#define HWTSHAKEBLOCKS                                                         \
    ((HWTSEEDBYTES + LWE_N / 4 + SHAKE256_RATE - 1) / SHAKE256_RATE)
#define HWTSHAKEBUFSIZE                                                        \
    (HWTSHAKEBLOCKS * SHAKE256_RATE)
void hwt(polyvec *r, const uint8_t seed[crypto_BYTES]) {

    unsigned int i, j;
    ALIGNED_UINT8(HWTSHAKEBUFSIZE) buf[4] = {0};
    ALIGNED_INT16(LWE_N) si[MODULE_RANK];
    ALIGNED_UINT16(HWTSEEDBYTES / 2) rand[MODULE_RANK];
    ALIGNED_UINT8(LWE_N / 4) sign[MODULE_RANK];
    keccakx4_state state;

#if MODULE_RANK > 4
#error "This function assumes MODULE_RANK <= 4."
#endif
#if crypto_BYTES != 32
#error "This function assumes crypto_BYTES == 32."
#endif

    uint8_t doneflags = 0;
    j = 0;
    do {
        __m256i f = _mm256_loadu_si256((__m256i *)seed);
        _mm256_store_si256(buf[0].vec, f);
        _mm256_store_si256(buf[1].vec, f);
        _mm256_store_si256(buf[2].vec, f);
        _mm256_store_si256(buf[3].vec, f);
        buf[0].coeffs[32] = 0;
        buf[1].coeffs[32] = MODULE_RANK * 1;
        buf[2].coeffs[32] = MODULE_RANK * 2;
        buf[3].coeffs[32] = MODULE_RANK * 3;
        buf[0].coeffs[33] = j;
        buf[1].coeffs[33] = j;
        buf[2].coeffs[33] = j;
        buf[3].coeffs[33] = j;

        shake256x4_absorb_once(&state, buf[0].coeffs, buf[1].coeffs, buf[2].coeffs,
                            buf[3].coeffs, crypto_BYTES + 2);
        shake256x4_squeezeblocks(buf[0].coeffs, buf[1].coeffs, buf[2].coeffs,
                                buf[3].coeffs, HWTSHAKEBLOCKS, &state);

        for (i = 0; i < MODULE_RANK; ++i) {
            if ((1 << i) & doneflags)
            {
                continue;
            }
            load16_littleendian(rand[i].coeffs, HWTSEEDBYTES / 2, buf[i].coeffs);
            if (rejsampling_mod(si[i].coeffs, rand[i].coeffs) == 0) {
                doneflags |= 1 << i; // set flag if randomness was sufficient
                                    // (happens with overwhelming prob)
            }
        }
        j += 1;
    } while (doneflags != ((1 << MODULE_RANK)-1));

    for (i = 0; i < MODULE_RANK; ++i) {
        memcpy(sign[i].coeffs, buf[i].coeffs + HWTSEEDBYTES, LWE_N / 4);

        int16_t t0;
        int16_t c0 = LWE_N - HS;
        for (j = 0; j < LWE_N; j++) {
            t0 = (si[i].coeffs[j] - c0) >> 15;
            c0 += t0;
            r->vec[i].coeffs[j] = 1 + t0;
            // Convert to ternary
            // index of sign: (i / 16 / 8) * 16 + (i % 16)
            // shift size   : (i / 16) % 8
            r->vec[i].coeffs[j] =
                (-r->vec[i].coeffs[j]) &
                ((((sign[i].coeffs[(((j >> 4) >> 3) << 4) + (j & 0x0F)] >>
                    ((j >> 4) & 0x07))
                   << 1) &
                  0x02) -
                 1);
        }
    }
}
