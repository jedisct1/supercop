/* File imported from XKCP for use in CROSS, without modifications. */
#include "crypto_sign.h"
#include "namespace.h"
#include "set.h"
/*
This file defines some parameters of the implementation in the parent directory.
*/

#define KeccakP1600times4_implementation_config "AVX2, 6 rounds unrolled"
#define KeccakP1600times4_unrolling 6
#define KeccakP1600times4_useAVX2
