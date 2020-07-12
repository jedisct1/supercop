/*
  This file is for Niederreiter encryption
*/

#ifndef ENCRYPT_H
#define ENCRYPT_H
#define encrypt crypto_kem_mceliece6688128_sse_encrypt

void encrypt(unsigned char *, const unsigned char *, unsigned char *);

#endif

