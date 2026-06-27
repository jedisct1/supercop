#include <math.h>
#include <string.h>
#include "kernelrandombytes.h"
#include "cpucycles.h"
#include "crypto_pow.h"
#include "measure.h"

const char *primitiveimplementation = crypto_pow_IMPLEMENTATION;
const char *implementationversion = crypto_pow_VERSION;
const char *sizenames[] = { "bytes", 0 };
const long long sizes[] = { crypto_pow_BYTES };

static unsigned char *q;
static unsigned char *p;

#define TIMINGS 64

void preallocate(void)
{
}

void allocate(void)
{
  p = alignedcalloc(crypto_pow_BYTES);
  q = alignedcalloc(crypto_pow_BYTES);
}

static long long cycles[TIMINGS + 1];

void measure(void)
{
  long long loop,i;

  for (loop = 0;loop < LOOPS;++loop) {
    kernelrandombytes(p,crypto_pow_BYTES);
    for (i = 0;i <= TIMINGS;++i) {
      cycles[i] = cpucycles();
      crypto_pow(q,p);
    }
    for (i = 0;i < TIMINGS;++i) cycles[i] = cycles[i + 1] - cycles[i];
    printentry(-1,"cycles",cycles,TIMINGS);
  }
}
