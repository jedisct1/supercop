#ifndef NTRUPLUS_PACK_ASM_H
#define NTRUPLUS_PACK_ASM_H

#include <stdint.h>

void tobytes_full_asm(uint8_t out[1296],
                                const int16_t fr0[864]);
void tobytes_small_asm(uint8_t out[1296],
                                 const int16_t fr0[864]);

#endif
