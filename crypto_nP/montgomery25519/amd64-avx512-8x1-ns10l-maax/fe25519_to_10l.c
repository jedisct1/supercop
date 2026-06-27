/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define fe25519_to_10l

#include "fe25519.h"

void fe25519_to_10l(fe25519_10l *r, const fe25519 *x) {
	
	r->l[0] = ((x->l[0] & 0x0000000003FFFFFF));
	r->l[1] = ((x->l[0] & 0x000FFFFFFC000000) >> 26);
	r->l[2] = ((x->l[0] & 0xFFF0000000000000) >> 52) | ((x->l[1] & 0x0000000000003FFF) << 12);
	r->l[3] = ((x->l[1] & 0x000000FFFFFFC000) >> 14);
	r->l[4] = ((x->l[1] & 0xFFFFFF0000000000) >> 40) | ((x->l[2] & 0x0000000000000003) << 24);
	r->l[5] = ((x->l[2] & 0x000000000FFFFFFC) >>  2);
	r->l[6] = ((x->l[2] & 0x003FFFFFF0000000) >> 28);
	r->l[7] = ((x->l[2] & 0xFFC0000000000000) >> 54) | ((x->l[3] & 0x000000000000FFFF) << 10);
	r->l[8] = ((x->l[3] & 0x000003FFFFFF0000) >> 16);
	r->l[9] = ((x->l[3] & 0x7FFFFC0000000000) >> 42);	 
}
