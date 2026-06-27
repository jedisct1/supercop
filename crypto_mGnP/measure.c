#include <math.h>
#include <string.h>
#include "kernelrandombytes.h"
#include "cpucycles.h"
#include "crypto_mGnP.h"
#include "measure.h"

const char *primitiveimplementation = crypto_mGnP_IMPLEMENTATION;
const char *implementationversion = crypto_mGnP_VERSION;
const char *sizenames[] = { "outputbytes", "mbytes", "nbytes", "pbytes", 0 };
const long long sizes[] = { crypto_mGnP_OUTPUTBYTES, crypto_mGnP_MBYTES, crypto_mGnP_NBYTES, crypto_mGnP_PBYTES };

static unsigned char *q;
static unsigned char *m;
static unsigned char *n;
static unsigned char *p;

#define TIMINGS 64

void preallocate(void)
{
}

void allocate(void)
{
  q = alignedcalloc(crypto_mGnP_OUTPUTBYTES);
  m = alignedcalloc(crypto_mGnP_MBYTES);
  n = alignedcalloc(crypto_mGnP_NBYTES);
  p = alignedcalloc(crypto_mGnP_PBYTES);
}

static long long cycles[TIMINGS + 1];

void measure(void)
{
  long long loop,i;

  for (loop = 0;loop < LOOPS;++loop) {
    kernelrandombytes(m,crypto_mGnP_MBYTES);
    kernelrandombytes(n,crypto_mGnP_NBYTES);
    kernelrandombytes(p,crypto_mGnP_PBYTES);
    for (i = 0;i <= TIMINGS;++i) {
      cycles[i] = cpucycles();
      crypto_mGnP(q,m,n,p);
    }
    for (i = 0;i < TIMINGS;++i) cycles[i] = cycles[i + 1] - cycles[i];
    printentry(-1,"cycles",cycles,TIMINGS);
  }
}
