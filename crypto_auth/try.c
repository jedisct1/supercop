/*
 * crypto_auth/try.c version 20240530
 * D. J. Bernstein
 * Public domain.
 * Auto-generated by trygen.py; do not edit.
 */

#include "crypto_auth.h"
#include "try.h"

const char *primitiveimplementation = crypto_auth_IMPLEMENTATION;

#define TUNE_BYTES 1536
#ifdef SMALL
#define MAXTEST_BYTES 128
#else
#define MAXTEST_BYTES 4096
#endif
#ifdef TIMECOP
#define LOOPS TIMECOP_LOOPS
#else
#ifdef SMALL
#define LOOPS 4096
#else
#define LOOPS 32768
#endif
#endif

#include "test-loops.inc"

static unsigned char *h;
static unsigned char *m;
static unsigned char *k;
static unsigned char *h2;
static unsigned char *m2;
static unsigned char *k2;
#define hlen crypto_auth_BYTES
unsigned long long mlen;
#define klen crypto_auth_KEYBYTES

void preallocate(void)
{
}

void allocate(void)
{
  unsigned long long alloclen = 0;
  if (alloclen < TUNE_BYTES) alloclen = TUNE_BYTES;
  if (alloclen < MAXTEST_BYTES) alloclen = MAXTEST_BYTES;
  if (alloclen < crypto_auth_BYTES) alloclen = crypto_auth_BYTES;
  if (alloclen < crypto_auth_KEYBYTES) alloclen = crypto_auth_KEYBYTES;
  h = alignedcalloc(alloclen);
  m = alignedcalloc(alloclen);
  k = alignedcalloc(alloclen);
  h2 = alignedcalloc(alloclen);
  m2 = alignedcalloc(alloclen);
  k2 = alignedcalloc(alloclen);
}

void unalign(void)
{
  ++h;
  ++m;
  ++k;
  ++h2;
  ++m2;
  ++k2;
}

void realign(void)
{
  --h;
  --m;
  --k;
  --h2;
  --m2;
  --k2;
}

void predoit(void)
{
}

void doit(void)
{
  crypto_auth(h,m,TUNE_BYTES,k);
  crypto_auth_verify(h,m,TUNE_BYTES,k);
}

void test(void)
{
  unsigned long long loop;
  int result;
  
  for (loop = 0;loop < LOOPS;++loop) {
    mlen = myrandom() % (MAXTEST_BYTES + 1);
    
    output_prepare(h2,h,hlen);
    input_prepare(m2,m,mlen);
    input_prepare(k2,k,klen);
    poison(m,mlen);
    poison(k,klen);
    result = crypto_auth(h,m,mlen,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_auth returns nonzero");
    unpoison(h,hlen);
    unpoison(m,mlen);
    unpoison(k,klen);
    checksum(h,hlen);
    output_compare(h2,h,hlen,"crypto_auth");
    input_compare(m2,m,mlen,"crypto_auth");
    input_compare(k2,k,klen,"crypto_auth");
    
    double_canary(h2,h,hlen);
    double_canary(m2,m,mlen);
    double_canary(k2,k,klen);
    poison(m2,mlen);
    poison(k2,klen);
    result = crypto_auth(h2,m2,mlen,k2);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_auth returns nonzero");
    unpoison(h2,hlen);
    unpoison(m2,mlen);
    unpoison(k2,klen);
    if (memcmp(h2,h,hlen) != 0) fail("crypto_auth is nondeterministic");
    
    double_canary(h2,h,hlen);
    double_canary(m2,m,mlen);
    double_canary(k2,k,klen);
    poison(m2,mlen);
    poison(k,klen);
    result = crypto_auth(m2,m2,mlen,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_auth with m=h overlap returns nonzero");
    unpoison(m2,hlen);
    unpoison(k,klen);
    if (memcmp(m2,h,hlen) != 0) fail("crypto_auth does not handle m=h overlap");
    memcpy(m2,m,mlen);
    poison(m,mlen);
    poison(k2,klen);
    result = crypto_auth(k2,m,mlen,k2);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_auth with k=h overlap returns nonzero");
    unpoison(k2,hlen);
    unpoison(m,mlen);
    if (memcmp(k2,h,hlen) != 0) fail("crypto_auth does not handle k=h overlap");
    memcpy(k2,k,klen);
    
    memcpy(h2,h,hlen);
    double_canary(h2,h,hlen);
    memcpy(m2,m,mlen);
    double_canary(m2,m,mlen);
    memcpy(k2,k,klen);
    double_canary(k2,k,klen);
    poison(h,hlen);
    poison(m,mlen);
    poison(k,klen);
    result = crypto_auth_verify(h,m,mlen,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_auth_verify returns nonzero");
    unpoison(h,hlen);
    unpoison(m,mlen);
    unpoison(k,klen);
    input_compare(h2,h,hlen,"crypto_auth_verify");
    input_compare(m2,m,mlen,"crypto_auth_verify");
    input_compare(k2,k,klen,"crypto_auth_verify");
    
    double_canary(h2,h,hlen);
    double_canary(m2,m,mlen);
    double_canary(k2,k,klen);
    poison(h2,hlen);
    poison(m2,mlen);
    poison(k2,klen);
    result = crypto_auth_verify(h2,m2,mlen,k2);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_auth_verify returns nonzero");
    unpoison(h2,hlen);
    unpoison(m2,mlen);
    unpoison(k2,klen);
    
    h[myrandom() % hlen] += 1 + (myrandom() % 255);
    if (crypto_auth_verify(h,m,mlen,k) == 0)
      if (memcmp(h2,h,hlen) != 0)
        fail("crypto_auth_verify accepts modified authenticators");
    h[myrandom() % hlen] += 1 + (myrandom() % 255);
    if (crypto_auth_verify(h,m,mlen,k) == 0)
      if (memcmp(h2,h,hlen) != 0)
        fail("crypto_auth_verify accepts modified authenticators");
    h[myrandom() % hlen] += 1 + (myrandom() % 255);
    if (crypto_auth_verify(h,m,mlen,k) == 0)
      if (memcmp(h2,h,hlen) != 0)
        fail("crypto_auth_verify accepts modified authenticators");
  }
#include "test-more.inc"
}
