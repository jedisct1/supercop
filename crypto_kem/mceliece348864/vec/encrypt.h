/*
  This file is for Niederreiter encryption
*/

#ifndef ENCRYPT_H
#define ENCRYPT_H
#define encrypt crypto_kem_mceliece348864_vec_encrypt

void encrypt(unsigned char *, const unsigned char *, unsigned char *);

#endif

