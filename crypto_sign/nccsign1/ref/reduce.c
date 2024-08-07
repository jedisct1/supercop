#include <stdint.h>
#include "params.h"
#include "reduce.h"

int32_t montgomery_reduce(int64_t a) {
  int32_t t;

  t = (int64_t)(int32_t)a*QINV;
  t = (a - (int64_t)t*Q) >> 32;
  return t;
}

int32_t caddq(int32_t a) {
  a += (a >> 31) & Q; 
  return a;
}

int32_t csubq(int32_t a) {
  a -= Q;
  a += ((int32_t)a >> 31) & Q;
  return a;
}

int32_t freeze(int32_t a) {
  a = reduce32(a);
  a = caddq(a);
  return a;
}

int32_t mod_add(int32_t a, int32_t b)
{
    int32_t t;
    t=(a+b);
    t=t-Q;
    t += (t >> 31) & Q;
    t += (t >> 31) & Q;
    t += (t >> 31) & Q;

    return (uint32_t)t;
}

int32_t mod_sub(int32_t a, int32_t b)
{
    int32_t t;
    t=a-b;
    t=t-Q;
    t += (t >> 31) & Q; 
    t += (t >> 31) & Q;
    t += (t >> 31) & Q;

    return (uint32_t)t;
}

/*************************************************
* Name:        reduce32
*
* Description: For finite field element a with a <= 2^{31} - 2^{22} - 1,
*              compute r \equiv a (mod Q) such that -6283009 <= r <= 6283007.
*
* Arguments:   - int32_t: finite field element a
*
* Returns r.
**************************************************/
int32_t reduce32(int32_t a) {
  int32_t t;

  t = (a + (1 << 22)) >> 23;
  t = a - t*Q;
  //t=a%Q;
  return t;
}