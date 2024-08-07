// 20240806 djb: some automated conversion to cryptoint
#include <immintrin.h>

#include "crypto_int8.h"
#include "crypto_int16.h"
#include "crypto_int32.h"
#include "crypto_int64.h"
#define int8 crypto_int8
#define int16 crypto_int16
#define int32 crypto_int32

#include "crypto_core.h"

#include "params.h"

/* ----- arithmetic mod q */

typedef int8 small;

typedef int16 Fq;
/* always represented as -(q-1)/2...(q-1)/2 */

/* works for -7000000 < x < 7000000 if q in 4591, 4621, 5167, 6343, 7177, 7879 */
static Fq Fq_freeze(int32 x)
{
  x -= q*((q18*x)>>18);
  x -= q*((q27*x+67108864)>>27);
  return x;
}

static Fq Fq_bigfreeze(int32 x)
{
  x -= q*((q14*x)>>14);
  x -= q*((q18*x)>>18);
  x -= q*((q27*x+67108864)>>27);
  x -= q*((q27*x+67108864)>>27);
  return x;
}

/* nonnegative e */
static Fq Fq_pow(Fq a,int e)
{
  if (e == 0) return 1;
  if (e == 1) return a;
  if (crypto_int64_bottombit_01(e)) return Fq_bigfreeze(a*(int32)Fq_pow(a,e-1));
  a = Fq_bigfreeze(a*(int32)a);
  return Fq_pow(a,e>>1);
}

static Fq Fq_recip(Fq a)
{ 
  return Fq_pow(a,q-2);
} 

/* ----- more */

#define qvec _mm256_set1_epi16(q)
#define qinvvec _mm256_set1_epi16(qinv)

static inline __m256i montproduct(__m256i x,__m256i y,__m256i yqinv)
{
  __m256i hi,d,e;

  d = _mm256_mullo_epi16(x,yqinv);
  hi = _mm256_mulhi_epi16(x,y);
  e = _mm256_mulhi_epi16(d,qvec);
  return _mm256_sub_epi16(hi,e);
}

static inline void vectormodq_swapeliminate(Fq *f,Fq *g,int len,const Fq f0,const Fq g0,int mask)
{
  __m256i f0vec = _mm256_set1_epi16(f0);
  __m256i g0vec = _mm256_set1_epi16(g0);
  __m256i f0vecqinv = _mm256_mullo_epi16(f0vec,qinvvec);
  __m256i g0vecqinv = _mm256_mullo_epi16(g0vec,qinvvec);
  __m256i maskvec = _mm256_set1_epi32(mask);
  
  while (len > 0) {
    __m256i fi = _mm256_loadu_si256((__m256i *) f);
    __m256i gi = _mm256_loadu_si256((__m256i *) g);
    __m256i finew = _mm256_blendv_epi8(fi,gi,maskvec);
    __m256i ginew = _mm256_blendv_epi8(gi,fi,maskvec);
    ginew = _mm256_sub_epi16(montproduct(ginew,f0vec,f0vecqinv),montproduct(finew,g0vec,g0vecqinv));
    _mm256_storeu_si256((__m256i *) f,finew);
    _mm256_storeu_si256((__m256i *) (g-1),ginew);
    f += 16;
    g += 16;
    len -= 16;
  }
}

static inline void vectormodq_xswapeliminate(Fq *f,Fq *g,int len,const Fq f0,const Fq g0,int mask)
{
  __m256i f0vec = _mm256_set1_epi16(f0);
  __m256i g0vec = _mm256_set1_epi16(g0);
  __m256i f0vecqinv = _mm256_mullo_epi16(f0vec,qinvvec);
  __m256i g0vecqinv = _mm256_mullo_epi16(g0vec,qinvvec);
  __m256i maskvec = _mm256_set1_epi32(mask);
  
  f += len + (-len & 15);
  g += len + (-len & 15);
  while (len > 0) {
    f -= 16;
    g -= 16;
    len -= 16;
    __m256i fi = _mm256_loadu_si256((__m256i *) f);
    __m256i gi = _mm256_loadu_si256((__m256i *) g);
    __m256i finew = _mm256_blendv_epi8(fi,gi,maskvec);
    __m256i ginew = _mm256_blendv_epi8(gi,fi,maskvec);
    ginew = _mm256_sub_epi16(montproduct(ginew,f0vec,f0vecqinv),montproduct(finew,g0vec,g0vecqinv));
    _mm256_storeu_si256((__m256i *) (f+1),finew);
    _mm256_storeu_si256((__m256i *) g,ginew);
  }
}

int crypto_core(unsigned char *outbytes,const unsigned char *inbytes,const unsigned char *kbytes,const unsigned char *cbytes)
{
  small *in = (void *) inbytes;
  int loop;
  Fq out[p],f[ppad],g[ppad],v[ppad],r[ppad];
  Fq f0,g0;
  Fq scale;
  int i;
  int delta = 1;
  int minusdelta;
  int fgflip;
  int swap;

  for (i = 0;i < ppad;++i) f[i] = 0;
  f[0] = 1;
  f[p-1] = -1;
  f[p] = -1;
  /* generalization: initialize f to reversal of any deg-p polynomial m */

  for (i = 0;i < p;++i) g[i] = in[p-1-i];
  for (i = p;i < ppad;++i) g[i] = 0;

  for (i = 0;i < ppad;++i) r[i] = 0;
  r[0] = Fq_recip(3);

  for (i = 0;i < ppad;++i) v[i] = 0;

  for (loop = 0;loop < p;++loop) {
    g0 = Fq_freeze(g[0]);
    f0 = f[0];
    if (q > 5167) f0 = Fq_freeze(f0);

    minusdelta = -delta;
    swap = crypto_int16_negative_mask(minusdelta) & crypto_int16_nonzero_mask(g0);
    delta ^= swap & (delta ^ minusdelta);
    delta += 1;

    fgflip = swap & (f0 ^ g0);
    f0 ^= fgflip;
    g0 ^= fgflip;

    f[0] = f0;

    vectormodq_swapeliminate(f+1,g+1,p,f0,g0,swap);
    vectormodq_xswapeliminate(v,r,loop+1,f0,g0,swap);
  }

  for (loop = p-1;loop > 0;--loop) {
    g0 = Fq_freeze(g[0]);
    f0 = f[0];
    if (q > 5167) f0 = Fq_freeze(f0);

    minusdelta = -delta;
    swap = crypto_int16_negative_mask(minusdelta) & crypto_int16_nonzero_mask(g0);
    delta ^= swap & (delta ^ minusdelta);
    delta += 1;

    fgflip = swap & (f0 ^ g0);
    f0 ^= fgflip;
    g0 ^= fgflip;

    f[0] = f0;

    vectormodq_swapeliminate(f+1,g+1,loop,f0,g0,swap);
    vectormodq_xswapeliminate(v,r,p,f0,g0,swap);
  }

  scale = Fq_recip(Fq_freeze(f[0]));
  for (i = 0;i < p;++i) out[i] = Fq_bigfreeze(scale*(int32)Fq_freeze(v[p-i]));

  crypto_encode_pxint16(outbytes,out);
  outbytes[2*p] = crypto_int16_nonzero_mask(delta);
  return 0;
}
