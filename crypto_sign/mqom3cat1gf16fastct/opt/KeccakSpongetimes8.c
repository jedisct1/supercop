/*
Implementation by the Keccak Team, namely, Guido Bertoni, Joan Daemen,
Michael Peeters, Gilles Van Assche and Ronny Van Keer,
hereby denoted as "the implementer".

For more information, feedback or questions, please refer to our website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

#include "KeccakSpongetimes8.h"

#ifdef XKCP_has_KeccakP1600times8
#if !defined(SUPERCOP)
#include "KeccakP-1600-times8-SnP.h"
#else
#include <libkeccak.a.headers/KeccakP-1600-times8-SnP.h>
#endif
#endif

#define prefix KeccakWidth1600times8
#define PlSnP KeccakP1600times8
#define PlSnP_width 1600
#define PlSnP_Permute KeccakP1600times8_PermuteAll_24rounds
#if defined(KeccakF1600times8_AVX512_FastLoop_supported)
/* Disabled: not needed for our use case */
//#define PlSnP_FastLoop_Absorb KeccakF1600times8_AVX512_FastLoop_Absorb
#endif
#include "KeccakSpongetimes8.inc"
#undef prefix
#undef PlSnP
#undef PlSnP_width
#undef PlSnP_Permute
#undef PlSnP_FastLoop_Absorb
