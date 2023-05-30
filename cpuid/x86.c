#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void nope()
{
  exit(1);
}

#define CPUID(func,leaf,a,b,c,d) \
  __asm volatile(".byte 15;.byte 162":"=a"(a),"=b"(b),"=c"(c),"=d"(d):"a"(func),"c"(leaf):)

static void putword(unsigned int x)
{
  int j;
  for (j = 0;j < 4;++j) {
    unsigned int c = 255&(x>>(8*j));
    if (c < 32) c = 32;
    if (c > 126) c = 126;
    putchar(c);
  }
}

static unsigned int cpuidmax,b0,c0,d0;
static unsigned int a1,b1,c1,d1;
static unsigned int a26,b26,c26,d26;

int main()
{
  signal(SIGILL,nope);

  CPUID(0,0,cpuidmax,b0,c0,d0);
  if (!cpuidmax) return 1;
  CPUID(1,0,a1,b1,c1,d1);
  if (cpuidmax >= 26) CPUID(26,0,a26,b26,c26,d26);

  putword(b0);
  putword(d0);
  putword(c0);
  printf("-%08x",a1);
  if (cpuidmax >= 26) printf("-%02x",a26>>24);
  printf("-%08x\n",d1);
  return 0;
}
