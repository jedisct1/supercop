/*
The Keccak-p permutations, designed by Guido Bertoni, Joan Daemen, Michaël Peeters and Gilles Van Assche.

Implementation by Gilles Van Assche, hereby denoted as "the implementer".

For more information, feedback or questions, please refer to the Keccak Team website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/

---

Please refer to PlSnP-documentation.h for more details.
*/

#ifndef _KeccakP_1600_times2_SnP_h_
#define _KeccakP_1600_times2_SnP_h_

#include "KeccakP-1600-SnP.h"

typedef struct {
    uint64_t A[50];
} KeccakP1600times2_states;

#define KeccakP1600times2_implementation        "fallback on serial implementation (" KeccakP1600_implementation ")"
#define KeccakP1600times2_statesSizeInBytes     400
#define KeccakP1600times2_statesAlignment       8
#define KeccakP1600times2_isFallback

void KeccakP1600times2_StaticInitialize( void );
void KeccakP1600times2_InitializeAll(void *states);
void KeccakP1600times2_AddByte(void *states, unsigned int instanceIndex, unsigned char data, unsigned int offset);
void KeccakP1600times2_AddBytes(void *states, unsigned int instanceIndex, const unsigned char *data, unsigned int offset, unsigned int length);
void KeccakP1600times2_AddLanesAll(void *states, const unsigned char *data, unsigned int laneCount, unsigned int laneOffset);
void KeccakP1600times2_OverwriteBytes(void *states, unsigned int instanceIndex, const unsigned char *data, unsigned int offset, unsigned int length);
void KeccakP1600times2_OverwriteLanesAll(void *states, const unsigned char *data, unsigned int laneCount, unsigned int laneOffset);
void KeccakP1600times2_OverwriteWithZeroes(void *states, unsigned int instanceIndex, unsigned int byteCount);
void KeccakP1600times2_PermuteAll_4rounds(void *states);
void KeccakP1600times2_PermuteAll_6rounds(void *states);
void KeccakP1600times2_PermuteAll_12rounds(void *states);
void KeccakP1600times2_PermuteAll_24rounds(void *states);
void KeccakP1600times2_ExtractBytes(const void *states, unsigned int instanceIndex, unsigned char *data, unsigned int offset, unsigned int length);
void KeccakP1600times2_ExtractLanesAll(const void *states, unsigned char *data, unsigned int laneCount, unsigned int laneOffset);
void KeccakP1600times2_ExtractAndAddBytes(const void *states, unsigned int instanceIndex,  const unsigned char *input, unsigned char *output, unsigned int offset, unsigned int length);
void KeccakP1600times2_ExtractAndAddLanesAll(const void *states, const unsigned char *input, unsigned char *output, unsigned int laneCount, unsigned int laneOffset);

#endif
