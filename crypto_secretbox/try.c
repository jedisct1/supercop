/*
 * crypto_secretbox/try.c version 20240530
 * D. J. Bernstein
 * Public domain.
 * Auto-generated by trygen.py; do not edit.
 */

#include "crypto_secretbox.h"
#include "try.h"

const char *primitiveimplementation = crypto_secretbox_IMPLEMENTATION;

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

static unsigned char *k;
static unsigned char *n;
static unsigned char *m;
static unsigned char *c;
static unsigned char *t;
static unsigned char *k2;
static unsigned char *n2;
static unsigned char *m2;
static unsigned char *c2;
static unsigned char *t2;
#define klen crypto_secretbox_KEYBYTES
#define nlen crypto_secretbox_NONCEBYTES
unsigned long long mlen;
unsigned long long clen;
unsigned long long tlen;

void preallocate(void)
{
}

void allocate(void)
{
  unsigned long long alloclen = 0;
  if (alloclen < TUNE_BYTES) alloclen = TUNE_BYTES;
  if (alloclen < MAXTEST_BYTES) alloclen = MAXTEST_BYTES;
  if (alloclen < crypto_secretbox_KEYBYTES) alloclen = crypto_secretbox_KEYBYTES;
  if (alloclen < crypto_secretbox_NONCEBYTES) alloclen = crypto_secretbox_NONCEBYTES;
  k = alignedcalloc(alloclen);
  n = alignedcalloc(alloclen);
  m = alignedcalloc(alloclen);
  c = alignedcalloc(alloclen);
  t = alignedcalloc(alloclen);
  k2 = alignedcalloc(alloclen);
  n2 = alignedcalloc(alloclen);
  m2 = alignedcalloc(alloclen);
  c2 = alignedcalloc(alloclen);
  t2 = alignedcalloc(alloclen);
}

void unalign(void)
{
  ++k;
  ++n;
  ++m;
  ++c;
  ++t;
  ++k2;
  ++n2;
  ++m2;
  ++c2;
  ++t2;
}

void realign(void)
{
  --k;
  --n;
  --m;
  --c;
  --t;
  --k2;
  --n2;
  --m2;
  --c2;
  --t2;
}

void predoit(void)
{
}

void doit(void)
{
  crypto_secretbox(c,m,TUNE_BYTES + crypto_secretbox_ZEROBYTES,n,k);
  unpoison(c,clen);
  crypto_secretbox_open(t,c,TUNE_BYTES + crypto_secretbox_ZEROBYTES,n,k);
}

void test(void)
{
  unsigned long long j;
  unsigned long long loop;
  int result;
  
  for (loop = 0;loop < LOOPS;++loop) {
    mlen = myrandom() % (MAXTEST_BYTES + 1);
    clen = mlen;
    tlen = mlen;
    if (mlen < crypto_secretbox_ZEROBYTES) continue;
    
    output_prepare(c2,c,clen);
    input_prepare(m2,m,mlen);
    input_prepare(n2,n,nlen);
    input_prepare(k2,k,klen);
    for (j = 0;j < crypto_secretbox_ZEROBYTES;++j) m[j] = 0;
    for (j = 0;j < crypto_secretbox_ZEROBYTES;++j) m2[j] = 0;
    poison(m,mlen);
    unpoison(n,nlen);
    poison(k,klen);
    result = crypto_secretbox(c,m,mlen,n,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox returns nonzero");
    unpoison(c,clen);
    unpoison(m,mlen);
    unpoison(n,nlen);
    unpoison(k,klen);
    for (j = 0;j < crypto_secretbox_BOXZEROBYTES;++j)
      if (c[j] != 0) fail("crypto_secretbox does not clear extra bytes");
    checksum(c,clen);
    output_compare(c2,c,clen,"crypto_secretbox");
    input_compare(m2,m,mlen,"crypto_secretbox");
    input_compare(n2,n,nlen,"crypto_secretbox");
    input_compare(k2,k,klen,"crypto_secretbox");
    
    double_canary(c2,c,clen);
    double_canary(m2,m,mlen);
    double_canary(n2,n,nlen);
    double_canary(k2,k,klen);
    poison(m2,mlen);
    unpoison(n2,nlen);
    poison(k2,klen);
    result = crypto_secretbox(c2,m2,mlen,n2,k2);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox returns nonzero");
    unpoison(c2,clen);
    unpoison(m2,mlen);
    unpoison(n2,nlen);
    unpoison(k2,klen);
    if (memcmp(c2,c,clen) != 0) fail("crypto_secretbox is nondeterministic");
    
    double_canary(c2,c,clen);
    double_canary(m2,m,mlen);
    double_canary(n2,n,nlen);
    double_canary(k2,k,klen);
    poison(m2,mlen);
    unpoison(n,nlen);
    poison(k,klen);
    result = crypto_secretbox(m2,m2,mlen,n,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox with m=c overlap returns nonzero");
    unpoison(m2,clen);
    unpoison(n,nlen);
    unpoison(k,klen);
    if (memcmp(m2,c,clen) != 0) fail("crypto_secretbox does not handle m=c overlap");
    memcpy(m2,m,mlen);
    poison(m,mlen);
    unpoison(n2,nlen);
    poison(k,klen);
    result = crypto_secretbox(n2,m,mlen,n2,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox with n=c overlap returns nonzero");
    unpoison(n2,clen);
    unpoison(m,mlen);
    unpoison(k,klen);
    if (memcmp(n2,c,clen) != 0) fail("crypto_secretbox does not handle n=c overlap");
    memcpy(n2,n,nlen);
    poison(m,mlen);
    unpoison(n,nlen);
    poison(k2,klen);
    result = crypto_secretbox(k2,m,mlen,n,k2);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox with k=c overlap returns nonzero");
    unpoison(k2,clen);
    unpoison(m,mlen);
    unpoison(n,nlen);
    if (memcmp(k2,c,clen) != 0) fail("crypto_secretbox does not handle k=c overlap");
    memcpy(k2,k,klen);
    
    output_prepare(t2,t,tlen);
    memcpy(c2,c,clen);
    double_canary(c2,c,clen);
    memcpy(n2,n,nlen);
    double_canary(n2,n,nlen);
    memcpy(k2,k,klen);
    double_canary(k2,k,klen);
    unpoison(c,clen);
    unpoison(n,nlen);
    poison(k,klen);
    result = crypto_secretbox_open(t,c,clen,n,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox_open returns nonzero");
    unpoison(t,tlen);
    unpoison(c,clen);
    unpoison(n,nlen);
    unpoison(k,klen);
    if (memcmp(t,m,mlen) != 0) fail("crypto_secretbox_open does not match m");
    checksum(t,tlen);
    output_compare(t2,t,tlen,"crypto_secretbox_open");
    input_compare(c2,c,clen,"crypto_secretbox_open");
    input_compare(n2,n,nlen,"crypto_secretbox_open");
    input_compare(k2,k,klen,"crypto_secretbox_open");
    
    double_canary(t2,t,tlen);
    double_canary(c2,c,clen);
    double_canary(n2,n,nlen);
    double_canary(k2,k,klen);
    unpoison(c2,clen);
    unpoison(n2,nlen);
    poison(k2,klen);
    result = crypto_secretbox_open(t2,c2,clen,n2,k2);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox_open returns nonzero");
    unpoison(t2,tlen);
    unpoison(c2,clen);
    unpoison(n2,nlen);
    unpoison(k2,klen);
    if (memcmp(t2,t,tlen) != 0) fail("crypto_secretbox_open is nondeterministic");
    
    double_canary(t2,t,tlen);
    double_canary(c2,c,clen);
    double_canary(n2,n,nlen);
    double_canary(k2,k,klen);
    unpoison(c2,clen);
    unpoison(n,nlen);
    poison(k,klen);
    result = crypto_secretbox_open(c2,c2,clen,n,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox_open with c=t overlap returns nonzero");
    unpoison(c2,tlen);
    unpoison(n,nlen);
    unpoison(k,klen);
    if (memcmp(c2,t,tlen) != 0) fail("crypto_secretbox_open does not handle c=t overlap");
    memcpy(c2,c,clen);
    unpoison(c,clen);
    unpoison(n2,nlen);
    poison(k,klen);
    result = crypto_secretbox_open(n2,c,clen,n2,k);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox_open with n=t overlap returns nonzero");
    unpoison(n2,tlen);
    unpoison(c,clen);
    unpoison(k,klen);
    if (memcmp(n2,t,tlen) != 0) fail("crypto_secretbox_open does not handle n=t overlap");
    memcpy(n2,n,nlen);
    unpoison(c,clen);
    unpoison(n,nlen);
    poison(k2,klen);
    result = crypto_secretbox_open(k2,c,clen,n,k2);
    unpoison(&result,sizeof result);
    if (result != 0) fail("crypto_secretbox_open with k=t overlap returns nonzero");
    unpoison(k2,tlen);
    unpoison(c,clen);
    unpoison(n,nlen);
    if (memcmp(k2,t,tlen) != 0) fail("crypto_secretbox_open does not handle k=t overlap");
    memcpy(k2,k,klen);
  }
#include "test-more.inc"
}
