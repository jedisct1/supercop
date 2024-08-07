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

static void stride(int16 fpad[4][512],const int16 f[1024])
{
  int16x16 f0,f1,f2,f3,g0,g1,g2,g3;
  int i,j;

  for (j = 0;j < 256;j += 16) {
    f0 = load_x16(&f[0]);
    f1 = load_x16(&f[16]);
    f2 = load_x16(&f[32]);
    f3 = load_x16(&f[48]);
    f += 64;
  
    g0 = _mm256_permute2x128_si256(f0,f2,0x20);
    g1 = _mm256_permute2x128_si256(f0,f2,0x31);
    g2 = _mm256_permute2x128_si256(f1,f3,0x20);
    g3 = _mm256_permute2x128_si256(f1,f3,0x31);
    f0 = _mm256_unpacklo_epi16(g0,g1);
    f1 = _mm256_unpackhi_epi16(g0,g1);
    f2 = _mm256_unpacklo_epi16(g2,g3);
    f3 = _mm256_unpackhi_epi16(g2,g3);
    g0 = _mm256_unpacklo_epi16(f0,f1);
    g1 = _mm256_unpackhi_epi16(f0,f1);
    g2 = _mm256_unpacklo_epi16(f2,f3);
    g3 = _mm256_unpackhi_epi16(f2,f3);
    f0 = _mm256_unpacklo_epi64(g0,g2);
    f1 = _mm256_unpackhi_epi64(g0,g2);
    f2 = _mm256_unpacklo_epi64(g1,g3);
    f3 = _mm256_unpackhi_epi64(g1,g3);
  
    store_x16(&fpad[0][j],f0);
    store_x16(&fpad[1][j],f1);
    store_x16(&fpad[2][j],f2);
    store_x16(&fpad[3][j],f3);
  }

  for (i = 0;i < 4;++i)
    for (j = 256;j < 512;++j)
      fpad[i][j] = 0;
}

static void unstride(int16 f[2048],const int16 fpad[4][512])
{
  int16x16 f0,f1,f2,f3,g0,g1,g2,g3,h0,h1,h2,h3;
  int j;

  for (j = 0;j < 512;j += 16) {
    f0 = load_x16(&fpad[0][j]);
    f1 = load_x16(&fpad[1][j]);
    f2 = load_x16(&fpad[2][j]);
    f3 = load_x16(&fpad[3][j]);
  
    g2 = _mm256_unpacklo_epi16(f2,f3);
    g3 = _mm256_unpackhi_epi16(f2,f3);
    g0 = _mm256_unpacklo_epi16(f0,f1);
    h0 = _mm256_unpacklo_epi32(g0,g2);
    h1 = _mm256_unpackhi_epi32(g0,g2);
    g1 = _mm256_unpackhi_epi16(f0,f1);
    h2 = _mm256_unpacklo_epi32(g1,g3);
    h3 = _mm256_unpackhi_epi32(g1,g3);
    f1 = _mm256_permute2x128_si256(h2,h3,0x20);
    f3 = _mm256_permute2x128_si256(h2,h3,0x31);
    f0 = _mm256_permute2x128_si256(h0,h1,0x20);
    f2 = _mm256_permute2x128_si256(h0,h1,0x31);

    store_x16(&f[0],f0);
    store_x16(&f[16],f1);
    store_x16(&f[32],f2);
    store_x16(&f[48],f3);
    f += 64;
  }
}

#define ALIGNED __attribute((aligned(32)))

static const ALIGNED int16 y_7681[512] = {
#include "precomp7681.inc"
} ;

static void mult1024(int16 h[2048],const int16 f[1024],const int16 g[1024])
{
  ALIGNED int16 fpad[4][512];
  ALIGNED int16 gpad[4][512];
  ALIGNED int16 h_7681[2048];
#define hpad fpad
  int i;

  stride(fpad,f);
  ntt512_7681(fpad[0],4);

  stride(gpad,g);
  ntt512_7681(gpad[0],4);

  /* XXX: try arbitrary-degree Karatsuba */

  for (i = 0;i < 512;i += 16) {
    int16x16 f0 = squeeze_7681_x16(load_x16(&fpad[0][i]));
    int16x16 f1 = squeeze_7681_x16(load_x16(&fpad[1][i]));
    int16x16 f2 = squeeze_7681_x16(load_x16(&fpad[2][i]));
    int16x16 f3 = squeeze_7681_x16(load_x16(&fpad[3][i]));
    int16x16 g0 = squeeze_7681_x16(load_x16(&gpad[0][i]));
    int16x16 g1 = squeeze_7681_x16(load_x16(&gpad[1][i]));
    int16x16 g2 = squeeze_7681_x16(load_x16(&gpad[2][i]));
    int16x16 g3 = squeeze_7681_x16(load_x16(&gpad[3][i]));
    int16x16 d0 = mulmod_7681_x16(f0,g0);
    int16x16 d1 = mulmod_7681_x16(f1,g1);
    int16x16 d2 = mulmod_7681_x16(f2,g2);
    int16x16 d3 = mulmod_7681_x16(f3,g3);
    int16x16 d0d1 = add_x16(d0,d1);
    int16x16 d0d1d2 = add_x16(d0d1,d2);
    int16x16 d0d1d2d3 = squeeze_7681_x16(add_x16(d0d1d2,d3));
    int16x16 d2d3 = add_x16(d2,d3);
    int16x16 d1d2d3 = add_x16(d1,d2d3);
    int16x16 e01 = mulmod_7681_x16(sub_x16(f0,f1),sub_x16(g0,g1));
    int16x16 e02 = mulmod_7681_x16(sub_x16(f0,f2),sub_x16(g0,g2));
    int16x16 e03 = mulmod_7681_x16(sub_x16(f0,f3),sub_x16(g0,g3));
    int16x16 e12 = mulmod_7681_x16(sub_x16(f1,f2),sub_x16(g1,g2));
    int16x16 e13 = mulmod_7681_x16(sub_x16(f1,f3),sub_x16(g1,g3));
    int16x16 e23 = mulmod_7681_x16(sub_x16(f2,f3),sub_x16(g2,g3));
    int16x16 h0 = d0;
    int16x16 h1 = sub_x16(d0d1,e01);
    int16x16 h2 = sub_x16(d0d1d2,e02);
    int16x16 h3 = sub_x16(d0d1d2d3,add_x16(e12,e03));
    int16x16 h4 = sub_x16(d1d2d3,e13);
    int16x16 h5 = sub_x16(d2d3,e23);
    int16x16 h6 = d3;
    int16x16 twist = load_x16(&y_7681[i]);
    h4 = mulmod_7681_x16(h4,twist);
    h5 = mulmod_7681_x16(h5,twist);
    h6 = mulmod_7681_x16(h6,twist);
    h0 = add_x16(h0,h4);
    h1 = add_x16(h1,h5);
    h2 = add_x16(h2,h6);
    store_x16(&hpad[0][i],squeeze_7681_x16(h0));
    store_x16(&hpad[1][i],squeeze_7681_x16(h1));
    store_x16(&hpad[2][i],squeeze_7681_x16(h2));
    store_x16(&hpad[3][i],squeeze_7681_x16(h3));
  }

  invntt512_7681(hpad[0],4);
  unstride(h_7681,hpad);

  for (i = 0;i < 2048;i += 16) {
    int16x16 u = load_x16(&h_7681[i]);
    u = mulmod_7681_x16(u,const_x16(956));
    store_x16(&h[i],u);
  }
}

#include "crypto_core.h"
#include "crypto_decode_857xint16.h"
#define crypto_decode_pxint16 crypto_decode_857xint16
#include "crypto_encode_857xint16.h"
#include "crypto_int64.h"
#define crypto_encode_pxint16 crypto_encode_857xint16

#define p 857

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
  ALIGNED int16 f[1024];
  ALIGNED int16 g[1024];
  ALIGNED int16 fg[2048];
#define h f
  int i;
  int16x16 x;

  x = const_x16(0);
  for (i = p&~15;i < 1024;i += 16) store_x16(&f[i],x);
  for (i = p&~15;i < 1024;i += 16) store_x16(&g[i],x);

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

  mult1024(fg,f,g);

  fg[0] -= fg[p-1];
  for (i = 0;i < 1024;i += 16) {
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
