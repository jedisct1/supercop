/*
 * crypto_sort/try.c version 20180814
 * D. J. Bernstein
 * Public domain.
 */

#include <string.h>
#include "crypto_sort.h"
#include "try.h"

const char *primitiveimplementation = crypto_sort_IMPLEMENTATION;

#define TUNE 768
#ifdef SMALL
#define MAXTEST 128
#else
#define MAXTEST 4096
#endif
#ifdef SMALL
#define LOOPS 1024
#else
#define LOOPS 4096
#endif

static unsigned char *x;
static unsigned char *y;
static unsigned char *x2;
static unsigned char *y2;
unsigned long long len;

void preallocate(void)
{
}

void allocate(void)
{
  unsigned long long alloclen = 0;
  if (alloclen < TUNE) alloclen = TUNE;
  if (alloclen < MAXTEST) alloclen = MAXTEST;
  x = alignedcalloc(crypto_sort_BYTES * alloclen);
  y = alignedcalloc(crypto_sort_BYTES * alloclen);
  x2 = alignedcalloc(crypto_sort_BYTES * alloclen);
  y2 = alignedcalloc(crypto_sort_BYTES * alloclen);
}

void predoit(void)
{
  long long i;
  for (i = 0;i < crypto_sort_BYTES * TUNE;++i) y[i] = myrandom();
}

void doit(void)
{
  memcpy(x,y,crypto_sort_BYTES * TUNE);
  crypto_sort(x,TUNE);
}

void test(void)
{
  long long loop,bytes;
  
  for (loop = 0;loop < LOOPS;++loop) {
    len = myrandom() % (MAXTEST + 1);
    bytes = crypto_sort_BYTES * len;

    input_prepare(x2,x,bytes);
    output_prepare(y2,y,bytes);
    memcpy(y,x,bytes);
    crypto_sort(y,len);
    checksum(y,bytes);
    output_compare(y2,y,bytes,"crypto_sort");
    input_compare(x2,x,bytes,"crypto_sort");

    double_canary(y2,y,bytes);
    memcpy(y2,x,bytes);
    crypto_sort(y2,len);
    if (memcmp(y2,y,bytes) != 0) fail("crypto_sort is nondeterministic");

    double_canary(y2,y,bytes);
    crypto_sort(y2,len);
    if (memcmp(y2,y,bytes) != 0) fail("crypto_sort is not idempotent");
  }
}
