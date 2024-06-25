/*
  This file is for Niederreiter encryption
*/
// 20230102 djb: rename encrypt() as pke_encrypt()

#ifndef ENCRYPT_H
#define ENCRYPT_H
#define pke_encrypt CRYPTO_NAMESPACE(pke_encrypt)

void pke_encrypt(unsigned char *, const unsigned char *, unsigned char *);

#endif

