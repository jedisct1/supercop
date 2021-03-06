#include <string.h>
#include <stdio.h>
#include <emmintrin.h>
#include "crypto_hash.h"
#include "crypto_uint64.h"
#include "crypto_uint32.h"
#include "crypto_uint8.h"

/* typedef unsigned long long u64; */
/* typedef unsigned int u32; */
/* typedef unsigned char u8; */

typedef crypto_uint64 u64;
typedef crypto_uint32 u32;
typedef crypto_uint8 u8; 

#define U8TO32(p)					\
  (((u32)((p)[0]) << 24) | ((u32)((p)[1]) << 16) |	\
   ((u32)((p)[2]) <<  8) | ((u32)((p)[3])      ))
#define U32TO8(p, v)					\
  (p)[0] = (u8)((v) >> 24); (p)[1] = (u8)((v) >> 16);	\
  (p)[2] = (u8)((v) >>  8); (p)[3] = (u8)((v)      ); 

#define LOADU(p)  _mm_loadu_si128( (__m128i *)(p) )
#define BSWAP32(r) do { \
   r = _mm_shufflehi_epi16(r, _MM_SHUFFLE(2, 3, 0, 1)); \
   r = _mm_shufflelo_epi16(r, _MM_SHUFFLE(2, 3, 0, 1)); \
   r = _mm_xor_si128(_mm_slli_epi16(r, 8), _mm_srli_epi16(r, 8)); \
} while(0)

typedef struct  { 
  u32 h[8], s[4], t[2];
  int buflen, nullt;
  u8  buf[64];
} state;

static const u8 sigma[][16] = {
  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 },
  {14,10, 4, 8, 9,15,13, 6, 1,12, 0, 2,11, 7, 5, 3 },
  {11, 8,12, 0, 5, 2,15,13,10,14, 3, 6, 7, 1, 9, 4 },
  { 7, 9, 3, 1,13,12,11,14, 2, 6, 5,10, 4, 0,15, 8 },
  { 9, 0, 5, 7, 2, 4,10,15,14, 1,11,12, 6, 8, 3,13 },
  { 2,12, 6,10, 0,11, 8, 3, 4,13, 7, 5,15,14, 1, 9 },
  {12, 5, 1,15,14,13, 4,10, 0, 7, 6, 3, 9, 2, 8,11 },
  {13,11, 7,14,12, 1, 3, 9, 5, 0,15, 4, 8, 6, 2,10 },
  { 6,15,14, 9,11, 3, 0, 8,12, 2,13, 7, 1, 4,10, 5 },
  {10, 2, 8, 4, 7, 6, 1, 5,15,11, 9,14, 3,12,13 ,0 },
  { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15 },
  {14,10, 4, 8, 9,15,13, 6, 1,12, 0, 2,11, 7, 5, 3 },
  {11, 8,12, 0, 5, 2,15,13,10,14, 3, 6, 7, 1, 9, 4 },
  { 7, 9, 3, 1,13,12,11,14, 2, 6, 5,10, 4, 0,15, 8 },
  { 9, 0, 5, 7, 2, 4,10,15,14, 1,11,12, 6, 8, 3,13 },
  { 2,12, 6,10, 0,11, 8, 3, 4,13, 7, 5,15,14, 1, 9 },
  {12, 5, 1,15,14,13, 4,10, 0, 7, 6, 3, 9, 2, 8,11 },
  {13,11, 7,14,12, 1, 3, 9, 5, 0,15, 4, 8, 6, 2,10 },
  { 6,15,14, 9,11, 3, 0, 8,12, 2,13, 7, 1, 4,10, 5 },
  {10, 2, 8, 4, 7, 6, 1, 5,15,11, 9,14, 3,12,13 ,0 }};

static const u32 cst[16] = {
  0x243F6A88,0x85A308D3,0x13198A2E,0x03707344,
  0xA4093822,0x299F31D0,0x082EFA98,0xEC4E6C89,
  0x452821E6,0x38D01377,0xBE5466CF,0x34E90C6C,
  0xC0AC29B7,0xC97C50DD,0x3F84D5B5,0xB5470917};

static const u8 padding[] =
  {0x80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

#define mycopy(x) ({ \
     register __m128i __out; \
     register __m128i __in = x; \
     __asm__ ("movdqa %1,%0" : "=x"(__out) : "x"(__in)); \
     __out; \
  })

static int blake256_compress( state * state, const u8 * datablock ) {

  __m128i row1,row2,row3,row4,copy;
  __m128i buf1,buf2;
  
  union {
    u32     u32[16];
    __m128i u128[4];
  } m;
  int r;
  u64 t;

  static const int sig[][16] = {
    {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 } ,
    { 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 } ,
    { 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 } ,
    {  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 } ,
    {  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 } ,
    {  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 } ,
    { 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 } ,
    { 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 } ,
    {  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 } ,
    { 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13 , 0 } ,
    {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 } ,
    { 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 } ,
    { 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 } ,
    {  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 }  
  };
  static const u32 z[16] = {
    0x243F6A88, 0x85A308D3, 0x13198A2E, 0x03707344,
    0xA4093822, 0x299F31D0, 0x082EFA98, 0xEC4E6C89,
    0x452821E6, 0x38D01377, 0xBE5466CF, 0x34E90C6C,
    0xC0AC29B7, 0xC97C50DD, 0x3F84D5B5, 0xB5470917 
  };

  /* get message */
  m.u128[0] = LOADU(datablock +  0);
  m.u128[1] = LOADU(datablock + 16);
  m.u128[2] = LOADU(datablock + 32);
  m.u128[3] = LOADU(datablock + 48);
   
  BSWAP32(m.u128[0]);
  BSWAP32(m.u128[1]);
  BSWAP32(m.u128[2]);
  BSWAP32(m.u128[3]);

  row1 = _mm_set_epi32(state->h[ 3], state->h[ 2],
		       state->h[ 1], state->h[ 0]);
  row2 = _mm_set_epi32(state->h[ 7], state->h[ 6],
		       state->h[ 5], state->h[ 4]);
  row3 = _mm_set_epi32(0x03707344, 0x13198A2E, 0x85A308D3, 0x243F6A88);

  if (state->nullt) 
    row4 = _mm_set_epi32(0xEC4E6C89, 0x082EFA98, 0x299F31D0, 0xA4093822);
  else 
    row4 = _mm_set_epi32(0xEC4E6C89^state->t[1], 0x082EFA98^state->t[1],
			 0x299F31D0^state->t[0], 0xA4093822^state->t[0]);

#define round(r) \
        buf1 = _mm_set_epi32(m.u32[sig[r][ 6]], \
                            m.u32[sig[r][ 4]], \
                            m.u32[sig[r][ 2]], \
                            m.u32[sig[r][ 0]]); \
        buf2  = _mm_set_epi32(z[sig[r][ 7]], \
                            z[sig[r][ 5]], \
                            z[sig[r][ 3]], \
                            z[sig[r][ 1]]); \
        buf1 = _mm_xor_si128( buf1, buf2); \
        row1 = _mm_add_epi32( row1, buf1); \
        row1 = _mm_add_epi32( row1, row2 ); \
	copy = mycopy(row4); \
        row4 = _mm_xor_si128( row4, row1 ); \
        copy = _mm_xor_si128( copy, row1 ); \
	row4 = _mm_srli_epi32(row4,16); \
	copy = _mm_slli_epi32(copy,16); \
        row4 = _mm_xor_si128(row4,copy); \
        buf1  = _mm_set_epi32(z[sig[r][ 6]], \
                            z[sig[r][ 4]], \
                            z[sig[r][ 2]], \
                            z[sig[r][ 0]]); \
        buf2 = _mm_set_epi32(m.u32[sig[r][ 7]], \
                            m.u32[sig[r][ 5]], \
                            m.u32[sig[r][ 3]], \
                            m.u32[sig[r][ 1]]); \
        buf1 = _mm_xor_si128( buf1, buf2); \
        row3 = _mm_add_epi32( row3, row4 );   \
	copy = mycopy(row2); \
        row2 = _mm_xor_si128( row2, row3 ); \
        copy = _mm_xor_si128( copy, row3 ); \
	row2 = _mm_srli_epi32(row2,12); \
	copy = _mm_slli_epi32(copy,20); \
        row2 = _mm_xor_si128(row2,copy); \
        row1 = _mm_add_epi32( row1, buf1); \
        row1 = _mm_add_epi32( row1, row2 ); \
	copy = mycopy(row4); \
        row4 = _mm_xor_si128( row4, row1 ); \
        copy = _mm_xor_si128( copy, row1 ); \
	row4 = _mm_srli_epi32(row4,8); \
	copy = _mm_slli_epi32(copy,24); \
        row4 = _mm_xor_si128(row4,copy); \
        buf1 = _mm_set_epi32(m.u32[sig[r][14]], \
                            m.u32[sig[r][12]], \
                            m.u32[sig[r][10]], \
                            m.u32[sig[r][ 8]]); \
        buf2  = _mm_set_epi32(z[sig[r][15]], \
                            z[sig[r][13]], \
                            z[sig[r][11]], \
                            z[sig[r][ 9]]); \
        buf1 = _mm_xor_si128( buf1, buf2); \
        row3 = _mm_add_epi32( row3, row4 );   \
        row4 = _mm_shuffle_epi32( row4, _MM_SHUFFLE(2,1,0,3) ); \
	copy = mycopy(row2); \
        row2 = _mm_xor_si128( row2, row3 ); \
        copy = _mm_xor_si128( copy, row3 ); \
	row2 = _mm_srli_epi32(row2,7); \
	copy = _mm_slli_epi32(copy,25); \
        row2 = _mm_xor_si128(row2,copy); \
\
        row3 = _mm_shuffle_epi32( row3, _MM_SHUFFLE(1,0,3,2) ); \
        row2 = _mm_shuffle_epi32( row2, _MM_SHUFFLE(0,3,2,1) ); \
\
        row1 = _mm_add_epi32( row1, buf1 ); \
        row1 = _mm_add_epi32( row1, row2 ); \
	copy = mycopy(row4); \
        row4 = _mm_xor_si128( row4, row1 ); \
        copy = _mm_xor_si128( copy, row1 ); \
	row4 = _mm_srli_epi32(row4,16); \
	copy = _mm_slli_epi32(copy,16); \
        row4 = _mm_xor_si128(row4,copy); \
        buf1  = _mm_set_epi32(z[sig[r][14]], \
                            z[sig[r][12]], \
                            z[sig[r][10]], \
                            z[sig[r][ 8]]); \
        buf2 = _mm_set_epi32(m.u32[sig[r][15]], \
                            m.u32[sig[r][13]], \
                            m.u32[sig[r][11]], \
                            m.u32[sig[r][ 9]]); \
        buf1 = _mm_xor_si128( buf1, buf2); \
        row3 = _mm_add_epi32( row3, row4 );   \
	copy = mycopy(row2); \
        row2 = _mm_xor_si128( row2, row3 ); \
        copy = _mm_xor_si128( copy, row3 ); \
	row2 = _mm_srli_epi32(row2,12); \
	copy = _mm_slli_epi32(copy,20); \
        row2 = _mm_xor_si128(row2,copy); \
        row1 = _mm_add_epi32( row1, buf1 ); \
        row1 = _mm_add_epi32( row1, row2 ); \
	copy = mycopy(row4); \
        row4 = _mm_xor_si128( row4, row1 ); \
        copy = _mm_xor_si128( copy, row1 ); \
	row4 = _mm_srli_epi32(row4,8); \
	copy = _mm_slli_epi32(copy,24); \
        row4 = _mm_xor_si128(row4,copy); \
        row3 = _mm_add_epi32( row3, row4 );   \
        row4 = _mm_shuffle_epi32( row4, _MM_SHUFFLE(0,3,2,1) ); \
	copy = mycopy(row2); \
        row2 = _mm_xor_si128( row2, row3 ); \
        copy = _mm_xor_si128( copy, row3 ); \
	row2 = _mm_srli_epi32(row2,7); \
	copy = _mm_slli_epi32(copy,25); \
        row2 = _mm_xor_si128(row2,copy); \
\
        row3 = _mm_shuffle_epi32( row3, _MM_SHUFFLE(1,0,3,2) ); \
        row2 = _mm_shuffle_epi32( row2, _MM_SHUFFLE(2,1,0,3) ); \
\

  round( 0);
  round( 1);
  round( 2);
  round( 3);
  round( 4);
  round( 5);
  round( 6);
  round( 7);
  round( 8);
  round( 9);
  round(10);
  round(11);
  round(12);
  round(13);

  _mm_store_si128( (__m128i *)m.u32, _mm_xor_si128(row1,row3));
  state->h[0] ^= m.u32[ 0]; 
  state->h[1] ^= m.u32[ 1];    
  state->h[2] ^= m.u32[ 2];    
  state->h[3] ^= m.u32[ 3];
  _mm_store_si128( (__m128i *)m.u32, _mm_xor_si128(row2,row4));
  state->h[4] ^= m.u32[ 0];    
  state->h[5] ^= m.u32[ 1];    
  state->h[6] ^= m.u32[ 2];    
  state->h[7] ^= m.u32[ 3];

  return 0;
}


static void blake256_init( state *S ) {

  S->h[0]=0x6A09E667;
  S->h[1]=0xBB67AE85;
  S->h[2]=0x3C6EF372;
  S->h[3]=0xA54FF53A;
  S->h[4]=0x510E527F;
  S->h[5]=0x9B05688C;
  S->h[6]=0x1F83D9AB;
  S->h[7]=0x5BE0CD19;
  S->t[0]=S->t[1]=S->buflen=S->nullt=0;
  S->s[0]=S->s[1]=S->s[2]=S->s[3] =0;
}


static void blake256_update( state *S, const u8 *data, u64 datalen ) {

  int left=S->buflen >> 3; 
  int fill=64 - left;
   
  if( left && ( ((datalen >> 3) & 0x3F) >= fill ) ) {
    memcpy( (void*) (S->buf + left), (void*) data, fill );
    S->t[0] += 512;
    if (S->t[0] == 0) S->t[1]++;      
    blake256_compress( S, S->buf );
    data += fill;
    datalen  -= (fill << 3);       
    left = 0;
  }

  while( datalen >= 512 ) {
    S->t[0] += 512;
    if (S->t[0] == 0) S->t[1]++;
    blake256_compress( S, data );
    data += 64;
    datalen  -= 512;
  }
  
  if( datalen > 0 ) {
    memcpy( (void*) (S->buf + left), (void*) data, datalen>>3 );
    S->buflen = (left<<3) + datalen;
  }
  else S->buflen=0;
}


static void blake256_final( state *S, u8 *digest ) {
  
  u8 msglen[8], zo=0x01, oo=0x81;
  u32 lo=S->t[0] + S->buflen, hi=S->t[1];
  if ( lo < S->buflen ) hi++;
  U32TO8(  msglen + 0, hi );
  U32TO8(  msglen + 4, lo );

  if ( S->buflen == 440 ) { /* one padding byte */
    S->t[0] -= 8;
    blake256_update( S, &oo, 8 );
  }
  else {
    if ( S->buflen < 440 ) { /* enough space to fill the block  */
      if ( !S->buflen ) S->nullt=1;
      S->t[0] -= 440 - S->buflen;
      blake256_update( S, padding, 440 - S->buflen );
    }
    else { /* need 2 compressions */
      S->t[0] -= 512 - S->buflen; 
      blake256_update( S, padding, 512 - S->buflen );
      S->t[0] -= 440;
      blake256_update( S, padding+1, 440 );
      S->nullt = 1;
    }
    blake256_update( S, &zo, 8 );
    S->t[0] -= 8;
  }
  S->t[0] -= 64;
  blake256_update( S, msglen, 64 );    
  
  U32TO8( digest + 0, S->h[0]);
  U32TO8( digest + 4, S->h[1]);
  U32TO8( digest + 8, S->h[2]);
  U32TO8( digest +12, S->h[3]);
  U32TO8( digest +16, S->h[4]);
  U32TO8( digest +20, S->h[5]);
  U32TO8( digest +24, S->h[6]);
  U32TO8( digest +28, S->h[7]);
}


int crypto_hash( unsigned char *out, const unsigned char *in, unsigned long long inlen ) {

  state S;  
  blake256_init( &S );
  blake256_update( &S, in, inlen*8 );
  blake256_final( &S, out );
  return 0;
}

/*
int main() {

  int i, v;
  u8 data[72], digest[32];
  u8 test1[]= {0x0C, 0xE8, 0xD4, 0xEF, 0x4D, 0xD7, 0xCD, 0x8D, 
	       0x62, 0xDF, 0xDE, 0xD9, 0xD4, 0xED, 0xB0, 0xA7, 
	       0x74, 0xAE, 0x6A, 0x41, 0x92, 0x9A, 0x74, 0xDA, 
	       0x23, 0x10, 0x9E, 0x8F, 0x11, 0x13, 0x9C, 0x87};
  u8 test2[]= {0xD4, 0x19, 0xBA, 0xD3, 0x2D, 0x50, 0x4F, 0xB7, 
	       0xD4, 0x4D, 0x46, 0x0C, 0x42, 0xC5, 0x59, 0x3F, 
	       0xE5, 0x44, 0xFA, 0x4C, 0x13, 0x5D, 0xEC, 0x31, 
	       0xE2, 0x1B, 0xD9, 0xAB, 0xDC, 0xC2, 0x2D, 0x41};

  for(i=0; i<72; ++i) data[i]=0;  

  crypto_hash( digest, data, 1 );    
  v=0;
  for(i=0; i<32; ++i) {
    printf("%02X", digest[i]);
    if ( digest[i] != test1[i]) v=1;
  }
  if (v) printf("\nerror\n");
  else printf("\nok\n");

  for(i=0; i<72; ++i) data[i]=0;  

  crypto_hash( digest, data, 72 );    
  v=0;
  for(i=0; i<32; ++i) {
    printf("%02X", digest[i]);
    if ( digest[i] != test2[i]) v=1;
  }
  if (v) printf("\nerror\n");
  else printf("\nok\n");

  return 0;
}
*/
