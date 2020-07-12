/*
  This file is for Niederreiter decryption
*/

#ifndef DECRYPT_H
#define DECRYPT_H
#define decrypt crypto_kem_mceliece6688128_avx_decrypt

int decrypt(unsigned char *, const unsigned char *, const unsigned char *);

#endif

