#ifndef FE25519_H
#define FE25519_H

#define fe25519                CRYPTO_NAMESPACE(fe25519)
#define fe25519_freeze         CRYPTO_SHARED_NAMESPACE(fe25519_freeze)
#define fe25519_unpack         CRYPTO_NAMESPACE(fe25519_unpack)
#define fe25519_pack           CRYPTO_NAMESPACE(fe25519_pack)
#define fe25519_mul            CRYPTO_SHARED_NAMESPACE(fe25519_mul)
#define fe25519_square         CRYPTO_SHARED_NAMESPACE(fe25519_square)
#define fe25519_nsquare        CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
#define fe25519_invert         CRYPTO_NAMESPACE(fe25519_invert)

#define fe25519_4l_to_9l_dense      CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_9l_dense)
#define fe25519_9l_dense_to_4l      CRYPTO_SHARED_NAMESPACE(fe25519_9l_dense_to_4l)

typedef struct 
{
  unsigned long long v[4]; 
}
fe25519;

typedef struct 
{
  unsigned long long v[5]; 
}
fe25519_9l_dense;

void fe25519_freeze(fe25519 *r);

void fe25519_unpack(fe25519 *r, const unsigned char x[32]);

void fe25519_pack(unsigned char r[32], const fe25519 *x);

void fe25519_mul(fe25519_9l_dense *r, const fe25519_9l_dense *x, const fe25519_9l_dense *y);

void fe25519_nsquare(fe25519_9l_dense *r, const fe25519_9l_dense *x, long long n);

void fe25519_square(fe25519_9l_dense *r, const fe25519_9l_dense *x);

void fe25519_invert(fe25519_9l_dense *r, const fe25519_9l_dense *x);

void fe25519_4l_to_9l_dense(fe25519_9l_dense *, const fe25519 *);

void fe25519_9l_dense_to_4l(fe25519 *, const fe25519_9l_dense *);

#endif
