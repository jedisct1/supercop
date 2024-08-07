#ifndef REDUCE_H
#define REDUCE_H

#include <stdint.h>
#include "params.h"

int32_t montgomery_reduce(int64_t a);
uint32_t to_mont(int32_t a);
uint32_t from_mont(int32_t a);

// uint32_t reduce32(int64_t a);


int32_t caddq(int32_t a);
int32_t csubq(int32_t a) ;


int32_t freeze(int32_t a);
int32_t mod_add(int32_t a, int32_t b);
int32_t mod_sub(int32_t a, int32_t b);
int32_t reduce32(int32_t a);

#endif
