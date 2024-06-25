#include "crypto_xof.h"
#include "crypto_uint64.h"

#define ratebytes 136
#define squeezebytes 136
#define padding 31

// the following is mostly copied from https://twitter.com/tweetfips202
// (by Daniel J. Bernstein, Peter Schwabe, Gilles Van Assche)
// except for the following changes in Keccak() function:
// * r arg replaced with ratebytes
// * d arg replaced with squeezebytes
// * p arg replaced with padding
// * u64 n arg replaced with long long mlen
// * new arg: long long hlen
// * final squeeze changed to hlen loop
// * arg order: h,hlen,m,mlen
// * function name crypto_xof instead of Keccak
// and the following change:
// * u64 is defined as crypto_uint64 instead of unsigned long long

#define FOR(i,n) for (i = 0;i < n;++i)
typedef unsigned char u8;
typedef crypto_uint64 u64;
static u64 ROL(u64 a,u8 n){return(a<<n)|(a>>(64-n));}
static u64 L64(const u8*x){u64 r=0,i;FOR(i,8)r|=(u64)x[i]<<8*i;return r;}
static void F(u64*s){u8 x,y,j,R=1,r,n;u64 t,B[5],Y;FOR(n,24){FOR(x,5){B[x]=0;FOR(y,5)B[x]^=s[x+5*y];}FOR(x,5){t=B[(x+4)%5]^ROL(B[(x+1)%5],1);FOR(y,5)s[x+5*y]^=t;}t=s[1];y=r=0;x=1;FOR(j,24){r+=j+1;Y=2*x+3*y;x=y;y=Y%5;Y=s[x+5*y];s[x+5*y]=ROL(t,r%64);t=Y;}FOR(y,5){FOR(x,5)B[x]=s[x+5*y];FOR(x,5)s[x+5*y]=B[x]^(~B[(x+1)%5]&B[(x+2)%5]);}FOR(y,7)if((R=(R<<1)^(113*(R>>7)))&2)*s^=1ULL<<((1<<y)-1);}}
int crypto_xof(u8 *h,long long hlen,const u8*m,long long mlen){u64 s[25],i;u8 t[200];FOR(i,25)s[i]=0;while(mlen>=ratebytes){FOR(i,ratebytes/8)s[i]^=L64(m+8*i);F(s);mlen-=ratebytes;m+=ratebytes;}FOR(i,ratebytes)t[i]=0;FOR(i,mlen)t[i]=m[i];t[i]=padding;t[ratebytes-1]|=128;FOR(i,ratebytes/8)s[i]^=L64(t+8*i);
while(hlen>0){F(s);FOR(i,squeezebytes)if(i<hlen)h[i]=s[i/8]>>8*(i%8);h+=squeezebytes;hlen-=squeezebytes;}return 0;}
