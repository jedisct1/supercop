/*
Implementation by the Keccak Team, namely, Guido Bertoni, Joan Daemen,
Michael Peeters, Gilles Van Assche and Ronny Van Keer,
hereby denoted as "the implementer".

For more information, feedback or questions, please refer to our website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/

---

8-way parallel Keccak sponge, modeled on KeccakSpongetimes4.h.
*/

#ifndef _KeccakSpongeWidth1600times8_h_
#define _KeccakSpongeWidth1600times8_h_

#include <string.h>
#include "config.h"
#include "align.h"
#endif

#define KCP_DeclareSpongeStructuretimes8(prefix, size, alignment) \
    ALIGN(alignment) typedef struct prefix##_SpongeInstanceStruct { \
        unsigned char state[size]; \
        unsigned int rate; \
        unsigned int byteIOIndex; \
        int squeezing; \
    } prefix##_SpongeInstance;

#define KCP_DeclareSpongeFunctionstimes8(prefix) \
    int prefix##_SpongeInitialize(prefix##_SpongeInstance *spongeInstance, unsigned int rate, unsigned int capacity); \
    int prefix##_SpongeAbsorb(prefix##_SpongeInstance *spongeInstance, const unsigned char **data, size_t dataByteLen); \
    int prefix##_SpongeAbsorbLastFewBits(prefix##_SpongeInstance *spongeInstance, unsigned char delimitedData); \
    int prefix##_SpongeSqueeze(prefix##_SpongeInstance *spongeInstance, unsigned char **data, size_t dataByteLen);

#ifdef XKCP_has_KeccakP1600times8
#if !defined(SUPERCOP)
#include "KeccakP-1600-times8-SnP.h"
#else
#include <libkeccak.a.headers/KeccakP-1600-times8-SnP.h>
#endif
KCP_DeclareSpongeStructuretimes8(KeccakWidth1600times8, KeccakP1600times8_statesSizeInBytes, KeccakP1600times8_statesAlignment)
KCP_DeclareSpongeFunctionstimes8(KeccakWidth1600times8)
#endif
