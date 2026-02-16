#include <math.h>
#include <string.h>
#include "kernelrandombytes.h"
#include "cpucycles.h"
#include "crypto_sort.h"
#include "measure.h"

const char *primitiveimplementation = crypto_sort_IMPLEMENTATION;
const char *implementationversion = crypto_sort_VERSION;
const char *sizenames[] = { "bytes", 0 };
const long long sizes[] = { crypto_sort_BYTES };

static unsigned char *x;
static unsigned char *y;

#define MAXTEST 65536
#define TIMINGS 32

void preallocate(void)
{
}

void allocate(void)
{
  x = alignedcalloc(MAXTEST * crypto_sort_BYTES);
  y = alignedcalloc((TIMINGS + 1) * MAXTEST * crypto_sort_BYTES);
}

static long long cycles[TIMINGS + 1];

void measure(void)
{
  long long loop,i;

  for (loop = 0;loop < LOOPS;++loop) {
    for (long long npos = 0;;++npos) {
      long long nposlow = npos%24;
      long long nposhigh = npos/24;
      long long len = round(exp2(nposhigh+round(27.75001*nposlow)/665));
      if (len > MAXTEST) break;

      kernelrandombytes(y,(TIMINGS + 1) * len * crypto_sort_BYTES);
      for (i = 0;i <= TIMINGS;++i) {
        cycles[i] = cpucycles();
        memcpy(x,y + i * len * crypto_sort_BYTES,len * crypto_sort_BYTES);
      }
      for (i = 0;i < TIMINGS;++i) cycles[i] = cycles[i + 1] - cycles[i];
      printentry(len,"copy_cycles",cycles,TIMINGS);
      for (i = 0;i <= TIMINGS;++i) {
        cycles[i] = cpucycles();
        memcpy(x,y + i * len * crypto_sort_BYTES,len * crypto_sort_BYTES);
        crypto_sort(x,len);
      }
      for (i = 0;i < TIMINGS;++i) cycles[i] = cycles[i + 1] - cycles[i];
      printentry(len,"cycles",cycles,TIMINGS);
    }
  }
}
