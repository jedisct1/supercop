#include "crypto_kem.h"
extern int ntruplus768_gt_crypto_kem_keypair(unsigned char*,unsigned char*);
extern int ntruplus768_gt_crypto_kem_enc(unsigned char*,unsigned char*,const unsigned char*);
extern int ntruplus768_gt_crypto_kem_dec(unsigned char*,const unsigned char*,const unsigned char*);
int crypto_kem_keypair(unsigned char*p,unsigned char*s){return ntruplus768_gt_crypto_kem_keypair(p,s);}
int crypto_kem_enc(unsigned char*c,unsigned char*s,const unsigned char*p){return ntruplus768_gt_crypto_kem_enc(c,s,p);}
int crypto_kem_dec(unsigned char*s,const unsigned char*c,const unsigned char*k){return ntruplus768_gt_crypto_kem_dec(s,c,k);}
