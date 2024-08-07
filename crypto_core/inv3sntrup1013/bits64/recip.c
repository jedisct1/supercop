#include "crypto_core.h"

#include "params.h"

#include "crypto_int8.h"
#include "crypto_int16.h"
#include "crypto_int64.h"
#include "crypto_uint64.h"
#define int8 crypto_int8
#define int16 crypto_int16
#define int64 crypto_int64
#define uint64 crypto_uint64

#define bitvec_len (ppad64>>6)
typedef uint64 bitvec[bitvec_len];

static inline int8 bitvec_bot(bitvec v)
{
  return -crypto_uint64_bottombit_mask(v[0]);
}

static inline int8 bitvec_get(bitvec v,int pos)
{
  return -crypto_uint64_bitmod_mask(v[pos>>6],pos);
}

static inline void bitvec_set(bitvec v,int pos,int8 bit)
{
  bit ^= bitvec_get(v,pos);
  v[pos>>6] ^= crypto_uint64_shlmod(bit,pos);
}

static void bitvec_zero(bitvec v)
{
  int i;
  for (i = 0;i < bitvec_len;++i) v[i] = 0;
}

static void bitvec_shiftup(bitvec v)
{
  int i;
  for (i = bitvec_len-1;i > 0;--i)
    v[i] = (v[i]<<1)|-crypto_int64_negative_mask(v[i-1]);
  v[0] <<= 1;
}

static void bitvec_shiftdown(bitvec v)
{
  int i;
  for (i = 0;i < bitvec_len-1;++i)
    v[i] = (v[i]>>1)|(crypto_uint64_bottombit_mask(v[i+1])<<63);
  v[bitvec_len-1] >>= 1;
}

static void bitvec_condswap(bitvec v,bitvec w,int64 swap)
{
  int i;
  for (i = 0;i < bitvec_len;++i) {
    uint64 t = swap&(v[i]^w[i]);
    v[i] ^= t;
    w[i] ^= t;
  }
}

static void bitvec_eliminate(bitvec f0,bitvec f1,bitvec g0,bitvec g1,uint64 c0,uint64 c1)
{
  int i;
  c0 = -c0;
  c1 = -c1;

  for (i = 0;i < bitvec_len;++i) {
    uint64 f0i = f0[i];
    uint64 f1i = f1[i];
    uint64 g0i = g0[i];
    uint64 g1i = g1[i];
    uint64 t;

    f0i &= c0;
    f1i ^= c1;
    f1i &= f0i;

    t = g0i ^ f0i;
    g0[i] = t | (g1i ^ f1i);
    g1[i] = (g1i ^ f0i) & (f1i ^ t);
  }
}

/* byte p of output is 0 if recip succeeded; else -1 */
int crypto_core(unsigned char *outbytes,const unsigned char *inbytes,const unsigned char *kbytes,const unsigned char *cbytes)
{
  int8 *out = (void *) outbytes;
  int8 *in = (void *) inbytes;
  bitvec f0,f1,g0,g1,v0,v1,r0,r1;
  int i,loop,delta;
  int8 sign0,sign1;
  int swap;

  bitvec_zero(v0); bitvec_zero(v1);
  bitvec_zero(r0); bitvec_zero(r1);
  bitvec_set(r0,0,1);
  bitvec_zero(f0); bitvec_zero(f1);
  bitvec_set(f0,0,1);
  bitvec_set(f0,p-1,1);
  bitvec_set(f1,p-1,1);
  bitvec_set(f0,p,1);
  bitvec_set(f1,p,1);
  bitvec_zero(g0); bitvec_zero(g1);
  for (i = 0;i < p;++i) {
    int8 x0 = -crypto_int8_bottombit_mask(in[i]);
    int8 x1 = x0&(in[i]>>1);
    bitvec_set(g0,p-1-i,x0);
    bitvec_set(g1,p-1-i,x1);
  }
  bitvec_set(g0,p,0);
  bitvec_set(g1,p,0);

  delta = 1; 

  for (loop = 0;loop < 2*p-1;++loop) {
    bitvec_shiftup(v0);
    bitvec_shiftup(v1);

    /* note: this sign is f0g0 _without_ negation */
    sign0 = bitvec_bot(g0)&bitvec_bot(f0);
    sign1 = (bitvec_bot(g1)^bitvec_bot(f1))&sign0;

    swap = crypto_int16_positive_mask(delta) & crypto_int16_nonzero_mask(bitvec_bot(g0));
    delta ^= swap&(delta^-delta);
    delta += 1;

    bitvec_condswap(f0,g0,swap);
    bitvec_condswap(f1,g1,swap);
    bitvec_condswap(v0,r0,swap);
    bitvec_condswap(v1,r1,swap);

    bitvec_eliminate(f0,f1,g0,g1,sign0,sign1);
    bitvec_eliminate(v0,v1,r0,r1,sign0,sign1);

    bitvec_shiftdown(g0);
    bitvec_shiftdown(g1);
  }

  sign0 = bitvec_bot(f0);
  sign1 = bitvec_bot(f1);
  for (i = 0;i < p;++i) {
    int8 m0 = bitvec_get(v0,p-1-i);
    int8 m1 = bitvec_get(v1,p-1-i);
    m0 &= sign0;
    m1 ^= sign1;
    m1 &= m0;
    out[i] = m0-2*m1;
  }

  out[p] = crypto_int16_nonzero_mask(delta);
  return 0;
} 
