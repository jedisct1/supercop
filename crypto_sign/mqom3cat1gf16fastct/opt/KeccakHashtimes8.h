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

8-way parallel hash interface, modeled on KeccakHashtimes4.h.
*/

#ifndef _KeccakHashInterfacetimes8_h_
#define _KeccakHashInterfacetimes8_h_

#include "config.h"
#ifdef XKCP_has_KeccakP1600times8

#if !defined(SUPERCOP)
#include "KeccakHash.h"
#else
#include <libkeccak.a.headers/KeccakHash.h>
#endif
#include "KeccakSpongetimes8.h"

typedef struct {
	KeccakWidth1600times8_SpongeInstance sponge;
	unsigned int fixedOutputLength;
	unsigned char delimitedSuffix;
} Keccak_HashInstancetimes8;

#define Keccak_HashInitializetimes8_SHAKE128(hashInstance) \
    Keccak_HashInitializetimes8(hashInstance, 1344, 256, 0, 0x1F)
#define Keccak_HashInitializetimes8_SHAKE256(hashInstance) \
    Keccak_HashInitializetimes8(hashInstance, 1088, 512, 0, 0x1F)

HashReturn Keccak_HashInitializetimes8(Keccak_HashInstancetimes8 *hashInstance,
    unsigned int rate, unsigned int capacity,
    unsigned int hashbitlen, unsigned char delimitedSuffix);
HashReturn Keccak_HashUpdatetimes8(Keccak_HashInstancetimes8 *hashInstance,
    const BitSequence **data, BitLength databitlen);
HashReturn Keccak_HashFinaltimes8(Keccak_HashInstancetimes8 *hashInstance,
    BitSequence **hashval);
HashReturn Keccak_HashSqueezetimes8(Keccak_HashInstancetimes8 *hashInstance,
    BitSequence **data, BitLength databitlen);

#else
#error This requires an implementation of Keccak-p[1600]x8
#endif

#endif /* _KeccakHashInterfacetimes8_h_ */
