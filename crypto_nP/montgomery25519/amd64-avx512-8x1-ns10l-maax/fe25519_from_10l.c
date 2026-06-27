/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define fe25519_from_10l

#include "fe25519.h"

void fe25519_from_10l(fe25519 *r, const fe25519_10l *x) {
        
        r->l[0] = ((x->l[0] & 0x0000000003FFFFFF) >>  0) | ((x->l[1] & 0x0000000003FFFFFF) << 26) | ((x->l[2] & 0x0000000000000FFF) << 52);
        r->l[1] = ((x->l[2] & 0x0000000003FFF000) >> 12) | ((x->l[3] & 0x0000000003FFFFFF) << 14) | ((x->l[4] & 0x0000000000FFFFFF) << 40);
        r->l[2] = ((x->l[4] & 0x0000000003000000) >> 24) | ((x->l[5] & 0x0000000003FFFFFF) <<  2) | ((x->l[6] & 0x0000000003FFFFFF) << 28) | ((x->l[7] & 0x00000000000003FF) << 54);
        r->l[3] = ((x->l[7] & 0x0000000003FFFC00) >> 10) | ((x->l[8] & 0x0000000003FFFFFF) << 16) | ((x->l[9] & 0x00000000001FFFFF) << 42);          
}
