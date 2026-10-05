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

#include "KeccakSpongetimes4.h"

#ifdef XKCP_has_KeccakP1600
#if !defined(SUPERCOP)
#include "KeccakP-1600-times4-SnP.h"
#else
#include <libkeccak.a.headers/KeccakP-1600-times4-SnP.h>
#endif
#endif

#if defined(SUPERCOP)
/* The XKCP that SUPERCOP builds takes a typed KeccakP1600times4_states pointer
 * where this sponge layer holds the state as a plain byte array, so its entry
 * points cannot be called directly. The layout is the same - 800 bytes, the
 * alignment the library itself announces - so a cast is sound; these shims keep
 * it in one place instead of scattering it through KeccakSpongetimes4.inc.
 * The times8 side needs none of this: it is still declared with void *. */
#define mqom3_x4_statesSizeInBytes KeccakP1600times4_statesSizeInBytes
#define mqom3_x4_statesAlignment   KeccakP1600times4_statesAlignment
#define mqom3_x4_StaticInitialize  KeccakP1600times4_StaticInitialize

static inline void mqom3_x4_InitializeAll(unsigned char *states)
{
	KeccakP1600times4_InitializeAll((KeccakP1600times4_states *)states);
}

static inline void mqom3_x4_AddByte(unsigned char *states, unsigned int instanceIndex,
                                    unsigned char byte, unsigned int offset)
{
	KeccakP1600times4_AddByte((KeccakP1600times4_states *)states, instanceIndex, byte, offset);
}

static inline void mqom3_x4_AddBytes(unsigned char *states, unsigned int instanceIndex,
                                     const unsigned char *data, unsigned int offset,
                                     unsigned int length)
{
	KeccakP1600times4_AddBytes((KeccakP1600times4_states *)states, instanceIndex, data, offset, length);
}

static inline void mqom3_x4_ExtractBytes(const unsigned char *states, unsigned int instanceIndex,
                                         unsigned char *data, unsigned int offset,
                                         unsigned int length)
{
	KeccakP1600times4_ExtractBytes((const KeccakP1600times4_states *)states, instanceIndex, data, offset, length);
}

static inline void mqom3_x4_PermuteAll_24rounds(unsigned char *states)
{
	KeccakP1600times4_PermuteAll_24rounds((KeccakP1600times4_states *)states);
}
#endif

#define prefix KeccakWidth1600times4
#if !defined(SUPERCOP)
#define PlSnP KeccakP1600times4
#define PlSnP_Permute KeccakP1600times4_PermuteAll_24rounds
#else
#define PlSnP mqom3_x4
#define PlSnP_Permute mqom3_x4_PermuteAll_24rounds
#endif
#define PlSnP_width 1600
#if defined(KeccakF1600times4_FastLoop_supported)
//can we enable fastloop absorb?
//#define PlSnP_FastLoop_Absorb KeccakF1600times4_FastLoop_Absorb
#endif
#include "KeccakSpongetimes4.inc"
#undef prefix
#undef PlSnP
#undef PlSnP_width
#undef PlSnP_Permute
#undef PlSnP_FastLoop_Absorb
