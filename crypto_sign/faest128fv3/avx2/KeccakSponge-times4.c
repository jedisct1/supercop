/*
Adapted from `KeccakSponge.c` of:

The eXtended Keccak Code Package (XKCP)
https://github.com/XKCP/XKCP

Keccak, designed by Guido Bertoni, Joan Daemen, Michaël Peeters and Gilles Van Assche.

Implementation by the designers, hereby denoted as "the implementer".

For more information, feedback or questions, please refer to the Keccak Team website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

#include "KeccakSponge-times4.h"

#ifdef XKCP_has_KeccakP1600times4
extern "C" {
    #include "libkeccak.a.headers/KeccakP-1600-times4-SnP.h"
}

    #define prefix KeccakWidth1600x4
    #define PlSnP KeccakP1600times4
    #define PlSnP_state KeccakP1600times4_state
    #define PlSnP_width 1600
    #define PlSnP_PermuteAll KeccakP1600times4_PermuteAll_24rounds
    /* #define PlSnP_FastLoop_Absorb KeccakF1600times4_FastLoop_Absorb */
        #include "KeccakSponge-times4.inc"
    #undef prefix
    #undef PlSnP
    #undef PlSnP_state
    #undef PlSnP_width
    #undef PlSnP_PermuteAll
    /* #undef PlSnP_FastLoop_Absorb */
#endif
