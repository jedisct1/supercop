/* Defined when we want to overload some low-level APIs */
#if defined(USE_WEAK_LOW_LEVEL_API)
#define WEAK __attribute__((weak))
#else
#define WEAK
#endif

#define XKCP_has_Sponge_Keccak
#define XKCP_has_FIPS202
#define XKCP_has_KeccakP1600
#define XKCP_has_KeccakP1600times4
#include "parameters.h"
