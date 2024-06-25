#include <stddef.h>
#include <openssl/evp.h>
#include "crypto_xof.h"

int crypto_xof(unsigned char *out,long long outlen,const unsigned char *in,long long inlen)
{
  int ok = 1;
  EVP_MD_CTX *x;

  x = EVP_MD_CTX_create();
  if (!x) return -111;

  if (ok) ok = EVP_DigestInit_ex(x,EVP_shake256(),NULL);
  if (ok) ok = EVP_DigestUpdate(x,in,inlen);
  if (ok) ok = EVP_DigestFinalXOF(x,out,outlen);

  EVP_MD_CTX_destroy(x);
  if (!ok) return -111;
  return 0;
}
