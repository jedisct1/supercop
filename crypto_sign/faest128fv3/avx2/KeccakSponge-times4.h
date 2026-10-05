/*
Adapted from `KeccakSponge.h` of:

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

#ifndef _KeccakSponge_times4_h_
#define _KeccakSponge_times4_h_

/* For the documentation, please follow the link: */
/* #include "KeccakSponge-documentation.h" */

#include <string.h>
extern "C" {
#include "libkeccak.a.headers/align.h"
}
extern "C" {
#include "libkeccak.a.headers/config.h"
}

#define XKCP_DeclareSpongeStructure_x4(prefix, state_t) \
    typedef struct prefix##_SpongeInstanceStruct { \
        state_t state[4]; \
        unsigned int rate; \
        unsigned int byteIOIndex; \
        int squeezing; \
    } prefix##_SpongeInstance;

#define XKCP_DeclareSpongeFunctions_x4(prefix) \
    int prefix##_Sponge(unsigned int rate, unsigned int capacity, const unsigned char **input, size_t inputByteLen, unsigned char suffix, unsigned char **output, size_t outputByteLen); \
    int prefix##_SpongeInitialize(prefix##_SpongeInstance *spongeInstance, unsigned int rate, unsigned int capacity); \
    int prefix##_SpongeAbsorb(prefix##_SpongeInstance *spongeInstance, const unsigned char **data, size_t dataByteLen); \
    int prefix##_SpongeAbsorbLastFewBits(prefix##_SpongeInstance *spongeInstance, unsigned char delimitedData); \
    int prefix##_SpongeSqueeze(prefix##_SpongeInstance *spongeInstance, unsigned char **data, size_t dataByteLen);

#ifdef XKCP_has_KeccakP1600times4
extern "C" {
    #include "libkeccak.a.headers/KeccakP-1600-times4-SnP.h"
}
    XKCP_DeclareSpongeStructure_x4(KeccakWidth1600x4, KeccakP1600times4_states)
    XKCP_DeclareSpongeFunctions_x4(KeccakWidth1600x4)
    /* #define XKCP_has_Sponge_Keccak_width1600 */
#endif

#endif
