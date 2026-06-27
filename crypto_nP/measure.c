#include <math.h>
#include <string.h>
#include "kernelrandombytes.h"
#include "cpucycles.h"
#include "crypto_nP.h"
#include "measure.h"

const char *primitiveimplementation = crypto_nP_IMPLEMENTATION;
const char *implementationversion = crypto_nP_VERSION;
const char *sizenames[] = { "pointbytes", "scalarbytes", 0 };
const long long sizes[] = { crypto_nP_POINTBYTES, crypto_nP_SCALARBYTES };

static unsigned char *q;
static unsigned char *n;
static unsigned char *p;

#define TIMINGS 64

void preallocate(void)
{
}

void allocate(void)
{
  q = alignedcalloc(crypto_nP_POINTBYTES);
  n = alignedcalloc(crypto_nP_SCALARBYTES);
  p = alignedcalloc(crypto_nP_POINTBYTES);
}

static long long cycles[TIMINGS + 1];

void measure(void)
{
  long long loop,i;

  for (loop = 0;loop < LOOPS;++loop) {
    kernelrandombytes(n,crypto_nP_SCALARBYTES);
    kernelrandombytes(p,crypto_nP_POINTBYTES);
    for (i = 0;i <= TIMINGS;++i) {
      cycles[i] = cpucycles();
      crypto_nP(q,n,p);
    }
    for (i = 0;i < TIMINGS;++i) cycles[i] = cycles[i + 1] - cycles[i];
    printentry(-1,"cycles",cycles,TIMINGS);
  }
}
