#ifndef CONSTS256_H
#define CONSTS256_H

#include "mulconfig.h"

/* qdata */
#define _16XP 0
#define _16XPINV 16
#define _16XV 32
#define _16XSHIFT 48
#define _16XMONT_PINV 64
#define _16XMONT 80
#define _16XF_PINV 96
#define _16XF 112
#define _ZETAS 128
#define _TWIST32 288
#define _TWIST4 800
#define _REVIDXB_FNT 592
#define _REVIDXD_FNT 608

#define _TWIST0 624
#define _TWIST0_INV 880
#define _TWIST1 1136
#define _TWIST1_INV 1264
#define _TWIST2 1392
#define _TWIST2_INV 1520
#define _THETA 1648

#define _ITWIST0 1776
#define _ITWIST0_INV 2032
#define _ITWIST1 2288
#define _ITWIST1_INV 2416
#define _ITWIST2 2544
#define _ITWIST2_INV 2672

#define _TWIDDLE_FACTOR 2800
#define _TWIDDLE_FACTOR_PINV 2816

/* idx */
#define _REVIDXW 0
#define _REVIDXD 32
#define _SIGNMSKW 64

/* The C ABI on MacOS exports all symbols with a leading
 * underscore. This means that any symbols we refer to from
 * C files (functions) can't be found, and all symbols we
 * refer to from ASM also can't be found.
 *
 * This define helps us get around this
 */
#ifdef __ASSEMBLER__
#if defined(__WIN32__) || defined(__APPLE__)
#define decorate(s) _##s
#define cdecl2(s) decorate(s)
#define cdecl(s) cdecl2(POLYMUL_NAMESPACE(_##s))
#else
#define cdecl(s) POLYMUL_NAMESPACE(_##s)
#endif
#endif

#ifndef __ASSEMBLER__
#include <stdint.h>

#define pdata7681 POLYMUL_NAMESPACE(_pdata7681)
extern const int16_t pdata7681[];
#define pdata257 POLYMUL_NAMESPACE(_pdata257)
extern const int16_t pdata257[];

#define P0 7681
#define P2 257
#define FNT_CRT_U_PINV 49726 // (1/p1 mod R)  * CRT_U) mod R
#define FNT_CRT_U 62         // (1/p0 mod p1) * R) mod p1

#define PDATA0 pdata7681
#define PDATA2 pdata257

#endif
#endif
