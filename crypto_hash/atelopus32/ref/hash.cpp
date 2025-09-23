
#include "crypto_hash.h"
#include "api.h"
#include "Atelopus.h"

#include <exception>
#include <string.h>

using namespace std;

int crypto_hash(unsigned char *out, const unsigned char *in, unsigned long long inlen)
{
   unsigned char h[32];
   try
   {
      //Atelopus32 - 32 bytes output, input block size 128
      Atelopus at(2, Atelopus::DigestSize32, Atelopus::BlockSize128);
      memset(h,0,32);
      at.Hash(in, h, inlen);
      memcpy(out,h,32);
   }
   catch(exception const&)
   {
      return -1;
   }
   return 0;
}

