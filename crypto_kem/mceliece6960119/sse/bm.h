/*
  This file is for the Berlekamp-Massey algorithm
*/

#ifndef BM_H
#define BM_H

#include "params.h"
#include "vec128.h"

void bm(vec128 *, vec128 [][ GFBITS ]);

#endif

