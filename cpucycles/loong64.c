#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>
#include "osfreq.c"

static long myround(double u)
{
  long result = u;
  while (result + 0.5 < u) result += 1;
  while (result - 0.5 > u) result -= 1;
  return result;
}

static long long microseconds(void)
{
  struct timeval t;
  gettimeofday(&t,(struct timezone *) 0);
  return t.tv_sec * (long long) 1000000 + t.tv_usec;
}

static long long timebase(void)
{
  long long result;
  asm volatile("rdtime.d %0, $zero\n" : "=r" (result));
  return result;
}

static double cpufrequency = 0;
static long ratio = 0;

static double guessratio(void)
{
  long long tb0; long long us0;
  long long tb1; long long us1;

  tb0 = timebase();
  us0 = microseconds();
  do {
    tb1 = timebase();
    us1 = microseconds();
  } while (us1 - us0 < 10000 || tb1 - tb0 < 1000);
  if (tb1 <= tb0) return 0;
  tb1 -= tb0;
  us1 -= us0;
  return (cpufrequency * 0.000001 * (double) us1) / (double) tb1;
}

static void init(void)
{
  int loop;

  cpufrequency = osfreq();
  if (!cpufrequency) return;

  for (loop = 0;loop < 100;++loop) {
    ratio = myround(guessratio());
    if (ratio == myround(guessratio()))
      return;
  }
  ratio = 0;
}

long long cpucycles_loong64(void)
{
  if (!ratio) init();
  return timebase() * ratio;
}

long long cpucycles_loong64_persecond(void)
{
  if (!ratio) init();
  return cpufrequency;
}
