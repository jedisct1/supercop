/*
The Keccak-p permutations, designed by Guido Bertoni, Joan Daemen, Michaël Peeters and Gilles Van Assche.

Implementation by Gilles Van Assche and Ronny Van Keer, hereby denoted as "the implementer".

For more information, feedback or questions, please refer to the Keccak Team website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/

---

Please refer to PlSnP-documentation.h for more details.
*/

#ifndef _KeccakP_1600_times4_SnP_h_
#define _KeccakP_1600_times4_SnP_h_

#include <stdint.h>
#include <immintrin.h>
#include "SIMD256-config.h"

typedef __m256i V256;

typedef struct {
    V256 A[25];
} KeccakP1600times4_SIMD256_states;

typedef KeccakP1600times4_SIMD256_states KeccakP1600times4_states;


#define KeccakP1600times4_implementation        "256-bit SIMD implementation (" KeccakP1600times4_implementation_config ")"
#define KeccakP1600times4_statesSizeInBytes     800
#define KeccakP1600times4_statesAlignment       64
#define KeccakF1600times4_FastLoop_supported
#define KeccakP1600times4_12rounds_FastLoop_supported
#define KeccakF1600times4_FastKravatte_supported

#define KeccakP1600times4_StaticInitialize()
void KeccakP1600times4_InitializeAll(KeccakP1600times4_states *states);
#define KeccakP1600times4_AddByte(states, instanceIndex, byte, offset) \
    ((unsigned char*)(states))[(instanceIndex)*8 + ((offset)/8)*4*8 + (offset)%8] ^= (byte)
void KeccakP1600times4_AddBytes(KeccakP1600times4_states *states, unsigned int instanceIndex, const unsigned char *data, unsigned int offset, unsigned int length);
void KeccakP1600times4_AddLanesAll(KeccakP1600times4_states *states, const unsigned char *data, unsigned int laneCount, unsigned int laneOffset);
void KeccakP1600times4_OverwriteBytes(KeccakP1600times4_states *states, unsigned int instanceIndex, const unsigned char *data, unsigned int offset, unsigned int length);
void KeccakP1600times4_OverwriteLanesAll(KeccakP1600times4_states *states, const unsigned char *data, unsigned int laneCount, unsigned int laneOffset);
void KeccakP1600times4_OverwriteWithZeroes(KeccakP1600times4_states *states, unsigned int instanceIndex, unsigned int byteCount);
void KeccakP1600times4_PermuteAll_4rounds(KeccakP1600times4_states *states);
void KeccakP1600times4_PermuteAll_6rounds(KeccakP1600times4_states *states);
void KeccakP1600times4_PermuteAll_12rounds(KeccakP1600times4_states *states);
void KeccakP1600times4_PermuteAll_24rounds(KeccakP1600times4_states *states);
void KeccakP1600times4_ExtractBytes(const KeccakP1600times4_states *states, unsigned int instanceIndex, unsigned char *data, unsigned int offset, unsigned int length);
void KeccakP1600times4_ExtractLanesAll(const KeccakP1600times4_states *states, unsigned char *data, unsigned int laneCount, unsigned int laneOffset);
void KeccakP1600times4_ExtractAndAddBytes(const KeccakP1600times4_states *states, unsigned int instanceIndex,  const unsigned char *input, unsigned char *output, unsigned int offset, unsigned int length);
void KeccakP1600times4_ExtractAndAddLanesAll(const KeccakP1600times4_states *states, const unsigned char *input, unsigned char *output, unsigned int laneCount, unsigned int laneOffset);
size_t KeccakF1600times4_FastLoop_Absorb(KeccakP1600times4_states *states, unsigned int laneCount, unsigned int laneOffsetParallel, unsigned int laneOffsetSerial, const unsigned char *data, size_t dataByteLen);
size_t KeccakP1600times4_12rounds_FastLoop_Absorb(KeccakP1600times4_states *states, unsigned int laneCount, unsigned int laneOffsetParallel, unsigned int laneOffsetSerial, const unsigned char *data, size_t dataByteLen);
size_t KeccakP1600times4_KravatteCompress(uint64_t *xAccu, uint64_t *kRoll, const unsigned char *input, size_t inputByteLen);
size_t KeccakP1600times4_KravatteExpand(uint64_t *yAccu, const uint64_t *kRoll, unsigned char *output, size_t outputByteLen);

#endif
