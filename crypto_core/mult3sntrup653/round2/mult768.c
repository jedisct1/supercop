// 20240806 djb: some automated conversion to cryptoint
#include "ntt.h"
#include <immintrin.h>

typedef int8_t int8;
typedef int16_t int16;

#define int16x16 __m256i
#define load_x16(p) _mm256_loadu_si256((int16x16 *) (p))
#define store_x16(p,v) _mm256_storeu_si256((int16x16 *) (p),(v))
#define const_x16 _mm256_set1_epi16
#define add_x16 _mm256_add_epi16
#define sub_x16 _mm256_sub_epi16
#define mullo_x16 _mm256_mullo_epi16
#define mulhi_x16 _mm256_mulhi_epi16
#define mulhrs_x16 _mm256_mulhrs_epi16
#define signmask_x16(x) _mm256_srai_epi16((x),15)

static int16x16 squeeze_3_x16(int16x16 x)
{
  return sub_x16(x,mullo_x16(mulhrs_x16(x,const_x16(10923)),const_x16(3)));
}

static int16x16 squeeze_7681_x16(int16x16 x)
{
  return sub_x16(x,mullo_x16(mulhrs_x16(x,const_x16(4)),const_x16(7681)));
}

static int16x16 mulmod_7681_x16(int16x16 x,int16x16 y)
{
  int16x16 yqinv = mullo_x16(y,const_x16(-7679)); /* XXX: precompute */
  int16x16 b = mulhi_x16(x,y);
  int16x16 d = mullo_x16(x,yqinv);
  int16x16 e = mulhi_x16(d,const_x16(7681));
  return sub_x16(b,e);
}

#define mask0 _mm256_set_epi16(-1,0,0,-1,0,0,-1,0,0,-1,0,0,-1,0,0,-1)
#define mask1 _mm256_set_epi16(0,0,-1,0,0,-1,0,0,-1,0,0,-1,0,0,-1,0)
#define mask2 _mm256_set_epi16(0,-1,0,0,-1,0,0,-1,0,0,-1,0,0,-1,0,0)

static void good(int16 fpad[3][512],const int16 f[768])
{
  int j;
  int16x16 f0,f1;

  j = 0;
  for (;;) {
    f0 = load_x16(f+j);
    f1 = load_x16(f+512+j);
    store_x16(&fpad[0][j],(f0&mask0)|(f1&mask1));
    store_x16(&fpad[1][j],(f0&mask1)|(f1&mask2));
    store_x16(&fpad[2][j],(f0&mask2)|(f1&mask0));
    j += 16;
    if (j == 256) break;
  
    f0 = load_x16(f+j);
    f1 = load_x16(f+512+j);
    store_x16(&fpad[0][j],(f0&mask2)|(f1&mask0));
    store_x16(&fpad[1][j],(f0&mask0)|(f1&mask1));
    store_x16(&fpad[2][j],(f0&mask1)|(f1&mask2));
    j += 16;
  
    f0 = load_x16(f+j);
    f1 = load_x16(f+512+j);
    store_x16(&fpad[0][j],(f0&mask1)|(f1&mask2));
    store_x16(&fpad[1][j],(f0&mask2)|(f1&mask0));
    store_x16(&fpad[2][j],(f0&mask0)|(f1&mask1));
    j += 16;
  }
  for (;;) {
    f0 = load_x16(f+j);
    store_x16(&fpad[0][j],f0&mask2);
    store_x16(&fpad[1][j],f0&mask0);
    store_x16(&fpad[2][j],f0&mask1);
    j += 16;
    if (j == 512) break;
  
    f0 = load_x16(f+j);
    store_x16(&fpad[0][j],f0&mask1);
    store_x16(&fpad[1][j],f0&mask2);
    store_x16(&fpad[2][j],f0&mask0);
    j += 16;

    f0 = load_x16(f+j);
    store_x16(&fpad[0][j],f0&mask0);
    store_x16(&fpad[1][j],f0&mask1);
    store_x16(&fpad[2][j],f0&mask2);
    j += 16;
  }
}

static void ungood(int16 f[1536],const int16 fpad[3][512])
{
  int j;
  int16x16 f0,f1,f2,g0,g1,g2;

  j = 0;

  for (;;) {
    f0 = load_x16(&fpad[0][j]);
    f1 = load_x16(&fpad[1][j]);
    f2 = load_x16(&fpad[2][j]);
    g0 = (f0&mask0)|(f1&mask1)|(f2&mask2);
    g1 = (f0&mask1)|(f1&mask2)|(f2&mask0);
    g2 = f0^f1^f2^g0^g1; /* same as (f0&mask2)|(f1&mask0)|(f2&mask1) */
    store_x16(f+0+j,g0);
    store_x16(f+512+j,g1);
    store_x16(f+1024+j,g2);
    j += 16;
  
    f0 = load_x16(&fpad[0][j]);
    f1 = load_x16(&fpad[1][j]);
    f2 = load_x16(&fpad[2][j]);
    g0 = (f0&mask2)|(f1&mask0)|(f2&mask1);
    g1 = (f0&mask0)|(f1&mask1)|(f2&mask2);
    g2 = f0^f1^f2^g0^g1; /* same as (f0&mask1)|(f1&mask2)|(f2&mask0) */
    store_x16(f+0+j,g0);
    store_x16(f+512+j,g1);
    store_x16(f+1024+j,g2);
    j += 16;
    if (j == 512) break;
  
    f0 = load_x16(&fpad[0][j]);
    f1 = load_x16(&fpad[1][j]);
    f2 = load_x16(&fpad[2][j]);
    g0 = (f0&mask1)|(f1&mask2)|(f2&mask0);
    g1 = (f0&mask2)|(f1&mask0)|(f2&mask1);
    g2 = f0^f1^f2^g0^g1; /* same as (f0&mask0)|(f1&mask1)|(f2&mask2) */
    store_x16(f+0+j,g0);
    store_x16(f+512+j,g1);
    store_x16(f+1024+j,g2);
    j += 16;
  }
}

#define ALIGNED __attribute((aligned(32)))

static void mult768(int16 h[1536],const int16 f[768],const int16 g[768])
{
  ALIGNED int16 fpad[3][512];
  ALIGNED int16 gpad[3][512];
#define hpad fpad
  ALIGNED int16 h_7681[1536];
  int i;

  good(fpad,f);
  ntt512_7681(fpad[0],3);

  good(gpad,g);
  ntt512_7681(gpad[0],3);

  for (i = 0;i < 512;i += 16) {
    int16x16 f0 = squeeze_7681_x16(load_x16(&fpad[0][i]));
    int16x16 f1 = squeeze_7681_x16(load_x16(&fpad[1][i]));
    int16x16 f2 = squeeze_7681_x16(load_x16(&fpad[2][i]));
    int16x16 g0 = squeeze_7681_x16(load_x16(&gpad[0][i]));
    int16x16 g1 = squeeze_7681_x16(load_x16(&gpad[1][i]));
    int16x16 g2 = squeeze_7681_x16(load_x16(&gpad[2][i]));
    int16x16 d0 = mulmod_7681_x16(f0,g0);
    int16x16 d1 = mulmod_7681_x16(f1,g1);
    int16x16 d2 = mulmod_7681_x16(f2,g2);
    int16x16 dsum = add_x16(add_x16(d0,d1),d2);
    int16x16 h0 = add_x16(dsum,mulmod_7681_x16(sub_x16(f2,f1),sub_x16(g1,g2)));
    int16x16 h1 = add_x16(dsum,mulmod_7681_x16(sub_x16(f1,f0),sub_x16(g0,g1)));
    int16x16 h2 = add_x16(dsum,mulmod_7681_x16(sub_x16(f0,f2),sub_x16(g2,g0)));
    store_x16(&hpad[0][i],squeeze_7681_x16(h0));
    store_x16(&hpad[1][i],squeeze_7681_x16(h1));
    store_x16(&hpad[2][i],squeeze_7681_x16(h2));
  }

  invntt512_7681(hpad[0],3);
  ungood(h_7681,hpad);

  for (i = 0;i < 1536;i += 16) {
    int16x16 u = load_x16(&h_7681[i]);
    u = mulmod_7681_x16(u,const_x16(956));
    store_x16(&h[i],u);
  }
}

#include "crypto_core.h"
#include "crypto_decode_653xint16.h"
#define crypto_decode_pxint16 crypto_decode_653xint16
#include "crypto_encode_653xint16.h"
#include "crypto_int64.h"
#define crypto_encode_pxint16 crypto_encode_653xint16

#define p 653

static inline int16x16 freeze_3_x16(int16x16 x)
{
  int16x16 mask, x3;
  x = add_x16(x,const_x16(3)&signmask_x16(x));
  mask = signmask_x16(sub_x16(x,const_x16(2)));
  x3 = sub_x16(x,const_x16(3));
  x = _mm256_blendv_epi8(x3,x,mask);
  return x;
}

int crypto_core(unsigned char *outbytes,const unsigned char *inbytes,const unsigned char *kbytes,const unsigned char *cbytes)
{
  ALIGNED int16 f[768];
  ALIGNED int16 g[768];
  ALIGNED int16 fg[1536];
#define h f
  int i;
  int16x16 x;

  x = const_x16(0);
  for (i = p&~15;i < 768;i += 16) store_x16(&f[i],x);
  for (i = p&~15;i < 768;i += 16) store_x16(&g[i],x);

  for (i = 0;i < p;++i) {
    int8 fi = inbytes[i];
    int8 fi0 = crypto_int64_bottombit_01(fi);
    f[i] = fi0-(fi&(fi0<<1));
  }
  for (i = 0;i < p;++i) {
    int8 gi = kbytes[i];
    int8 gi0 = crypto_int64_bottombit_01(gi);
    g[i] = gi0-(gi&(gi0<<1));
  }

  mult768(fg,f,g);

  fg[0] -= fg[p-1];
  for (i = 0;i < 768;i += 16) {
    int16x16 fgi = load_x16(&fg[i]);
    int16x16 fgip = load_x16(&fg[i + p]);
    int16x16 fgip1 = load_x16(&fg[i + p - 1]);
    x = add_x16(fgi,add_x16(fgip,fgip1));
    x = freeze_3_x16(squeeze_3_x16(x));
    store_x16(&h[i],x);
  }

  for (i = 0;i < p;++i) outbytes[i] = h[i];

  return 0;
}
