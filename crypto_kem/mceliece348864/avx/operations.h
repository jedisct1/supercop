#ifndef OPERATIONS_H
#define OPERATIONS_H

#define operation_keypair CRYPTO_NAMESPACE(operation_keypair)
#define operation_enc CRYPTO_NAMESPACE(operation_enc)
#define operation_dec CRYPTO_NAMESPACE(operation_dec)

int operation_enc(
       unsigned char *c,
       unsigned char *key,
       const unsigned char *pk
);

int operation_dec(
       unsigned char *key,
       const unsigned char *c,
       const unsigned char *sk
);

void operation_keypair
(
       unsigned char *pk,
       unsigned char *sk 
);

#endif

