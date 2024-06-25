#include <stdlib.h>
#include "kernelrandombytes.h"
#include "cpucycles.h"
#include "crypto_xof.h"
#include "measure.h"

const char *primitiveimplementation = crypto_xof_IMPLEMENTATION;
const char *implementationversion = crypto_xof_VERSION;
const char *sizenames[] = { 0 };
const long long sizes[] = { };

#define MAXTEST_BYTES 2048

static unsigned char *m;
static unsigned char *h;

void preallocate(void)
{
}

void allocate(void)
{
  m = alignedcalloc(MAXTEST_BYTES);
  h = alignedcalloc(MAXTEST_BYTES);
}

#define TIMINGS 15
static long long cycles[TIMINGS + 1];

void measure(void)
{
  int i;
  int loop;
  int direction;
  unsigned long long mlen;
  unsigned long long hlen;

  for (loop = 0;loop < LOOPS;++loop) {
    for (direction = 0;direction < 3;++direction) {
      mlen = 32;
      hlen = 32;
      if (direction != 1) mlen = 0;
      if (direction != 0) hlen = 0;
      for (;;) {
        int skip = 0;
        if (mlen > MAXTEST_BYTES) break;
        if (hlen > MAXTEST_BYTES) break;
        if (mlen > 64) if (mlen & 31) if (hlen != mlen) skip = 1;
        if (hlen > 64) if (hlen & 31) if (hlen != mlen) skip = 1;
        if (!skip) {
          kernelrandombytes(m,mlen);
          for (i = 0;i <= TIMINGS;++i) {
            cycles[i] = cpucycles();
            crypto_xof(h,hlen,m,mlen);
          }
          for (i = 0;i < TIMINGS;++i) cycles[i] = cycles[i + 1] - cycles[i];
          printentry(1000000 * hlen + mlen,"cycles",cycles,TIMINGS);
        }
        if (direction != 1) ++mlen;
        if (direction != 0) ++hlen;
      }
    }
  }
}
