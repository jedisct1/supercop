/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define fe25519_to_5l

#include "fe25519.h"

void fe25519_to_5l(fe25519_5l *r, const fe25519 *x) {

	r->l[0] = ((x->l[0] & 0x0007FFFFFFFFFFFF));
	r->l[1] = ((x->l[0] & 0xFFF8000000000000) >> 51) | ((x->l[1] & 0x0000003FFFFFFFFF) << 13);
	r->l[2] = ((x->l[1] & 0xFFFFFFC000000000) >> 38) | ((x->l[2] & 0x0000000001FFFFFF) << 26);
	r->l[3] = ((x->l[2] & 0xFFFFFFFFFE000000) >> 25) | ((x->l[3] & 0x0000000000000FFF) << 39);
	r->l[4] = ((x->l[3] & 0x7FFFFFFFFFFFF000) >> 12); 
}
