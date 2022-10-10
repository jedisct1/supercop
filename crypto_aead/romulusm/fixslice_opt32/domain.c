#include "domain.h"
#include "romulus.h"

u8 final_ad_domain (unsigned long long adlen, unsigned long long mlen) {
    u8 domain = 0;
    u32 leftover;
    //Determine which domain bits we need based on the length of the ad
    if (adlen == 0) {
        domain ^= 0x02;         // No message, so only 1 block with padding
    } else {
        leftover = (u32)(adlen % (2 * BLOCKBYTES));
        if (leftover == 0) {    // Even or odd ad length?
            domain ^= 0x08;     // Even with a full double block at the end
        } else if (leftover < BLOCKBYTES) {
            domain ^= 0x02;     // Odd with a partial single block at the end
        } else if (leftover > BLOCKBYTES) {
            domain ^= 0x0A;     // Even with a partial double block at the end
        }
    }
    //Determine which domain bits we need based on the length of the message
    if (mlen == 0) {
        domain ^= 0x01;         // No message, so only 1 block with padding
    } else {
        leftover = (u32)(mlen % (2 * BLOCKBYTES));
        if (leftover == 0) {    // Even or odd message length?
            domain ^= 0x04;     // Even with a full double block at the end
        } else if (leftover < BLOCKBYTES) {
            domain ^= 0x01;     // Odd with a partial single block at the end
        } else if (leftover > BLOCKBYTES) {
            domain ^= 0x05;     // Even with a partial double block at the end
        }
    }
    return domain;
}
