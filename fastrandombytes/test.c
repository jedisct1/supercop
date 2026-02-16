#include <stdio.h>
#include "cpucycles.h"
#include "randombytes.h"
#include "stq.h"

#define TIMINGS 24
unsigned long long t[TIMINGS + 1];
unsigned char x[65536];
unsigned long long freq[256];

int main()
{
  int i;
  int j;

  for (j = 0;j <= TIMINGS;++j) {
    randombytes(x,sizeof x);
    for (i = 0;i < 256;++i) freq[i] = 0;
    for (i = 0;i < sizeof x;++i) ++freq[255 & (int) x[i]];
    for (i = 0;i < 256;++i) if (!freq[i]) return 111;
  }

  for (i = 0;i <= TIMINGS;++i) {
    randombytes(x,sizeof x);
    t[i] = cpucycles();
  }

  for (i = 0;i < TIMINGS;++i) t[i] = t[i + 1] - t[i];
  printf("%lld\n",stq2_longlong(t,TIMINGS));
  return 0;
}
