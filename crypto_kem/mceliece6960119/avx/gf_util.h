#ifndef GF_UTIL_H
#define GF_UTIL_H

#include "gf.h"

gf gf_random();
void gf_dump(gf);
void gf_list_dump(gf *, int);
void GF_dump(gf *);
void gf2_list_dump(unsigned char *, int);

#endif

