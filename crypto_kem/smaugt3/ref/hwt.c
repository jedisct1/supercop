#include "hwt.h"
#include <stdio.h>
#include "crypto_uint16.h"
#include "crypto_declassify.h"

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
    unsigned int i, j = LWE_N;
    uint32_t m;
    uint16_t s, t, l;

    for (i = 0; i < LWE_N; i++) {
        s = LWE_N - i;
        t = 65536 % s;

        m = (uint32_t)rand[i] * s;
        l = m;

        for (;;) {
            crypto_uint16 tlel = crypto_uint16_leq_mask(t,l);
            crypto_declassify(&tlel,sizeof tlel);
            if (tlel) break;
            if (j >= (HWTSEEDBYTES / 2))
                return -1; // all randomness used
            m = (uint32_t)rand[j++] * s;
            l = m;
        }

        res[i] = m >> 16;
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
 * Arguments:   - int16_t *res: pointer to ouptput polynomial r(x)
 *                (of length LWE), assumed to be already initialized
 *              - uint8_t *seed: pointer to input seed (of length crypto_BYTES + 2)
 **************************************************/
int hwt(int16_t *res, const uint8_t *seed) {
    unsigned int i;
    int16_t si[LWE_N] = {0};
    uint16_t rand[HWTSEEDBYTES / 2] = {0};
    uint8_t sign[LWE_N / 4] = {0};
    uint8_t buf[HWTSEEDBYTES] = {0};

    keccak_state state;
    shake256_init(&state);
    shake256_absorb_once(&state, seed, crypto_BYTES + 2);

    // only executed once with overwhelming probability:
    shake256_squeeze(buf, HWTSEEDBYTES, &state);
    load16_littleendian(rand, HWTSEEDBYTES / 2, buf);
    if (rejsampling_mod(si, rand))
    {
        return -1;
    }

    shake256_squeeze(sign, LWE_N / 4, &state);

    int16_t t0;
    int16_t c0 = LWE_N - HS;
    for (i = 0; i < LWE_N; i++) {
        t0 = (si[i] - c0) >> 15;
        c0 += t0;
        res[i] = 1 + t0;
        // Convert to ternary
        // index of sign: (i / 16 / 8) * 16 + (i % 16)
        // shift size   : (i / 16) % 8
        res[i] =
            (-res[i]) &
            ((((sign[(((i >> 4) >> 3) << 4) + (i & 0x0F)] >> ((i >> 4) & 0x07)) << 1) & 0x02) - 1);
    }
    return 0;
}
