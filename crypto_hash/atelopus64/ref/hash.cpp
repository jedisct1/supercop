
#include "crypto_hash.h"
#include "api.h"
#include "Atelopus.h"

#include <exception>
#include <string.h>

using namespace std;

int crypto_hash(unsigned char *out, const unsigned char *in, unsigned long long inlen)
{
   unsigned char h[64];
   try
   {
      //Atelopus64 - 64 bytes output, input block size 256
      Atelopus at(2, Atelopus::DigestSize64, Atelopus::BlockSize256);
      memset(h,0,64);
      at.Hash(in, h, inlen);
      memcpy(out,h,64);
   }
   catch(exception const&)
   {
      return -1;
   }
   return 0;
}

