#include <math.h>
#include <string.h>
#include "kernelrandombytes.h"
#include "cpucycles.h"
#include "crypto_nG.h"
#include "measure.h"

const char *primitiveimplementation = crypto_nG_IMPLEMENTATION;
const char *implementationversion = crypto_nG_VERSION;
const char *sizenames[] = { "pointbytes", "scalarbytes", 0 };
const long long sizes[] = { crypto_nG_POINTBYTES, crypto_nG_SCALARBYTES };

static unsigned char *q;
static unsigned char *n;

#define TIMINGS 64

void preallocate(void)
{
}

void allocate(void)
{
  q = alignedcalloc(crypto_nG_POINTBYTES);
  n = alignedcalloc(crypto_nG_SCALARBYTES);
}

static long long cycles[TIMINGS + 1];

void measure(void)
{
  long long loop,i;

  for (loop = 0;loop < LOOPS;++loop) {
    kernelrandombytes(n,crypto_nG_SCALARBYTES);
    for (i = 0;i <= TIMINGS;++i) {
      cycles[i] = cpucycles();
      crypto_nG(q,n);
    }
    for (i = 0;i < TIMINGS;++i) cycles[i] = cycles[i + 1] - cycles[i];
    printentry(-1,"cycles",cycles,TIMINGS);
  }
}
