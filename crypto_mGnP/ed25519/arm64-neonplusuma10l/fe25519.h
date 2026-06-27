#ifndef FE25519_H
#define FE25519_H

#define fe25519                CRYPTO_NAMESPACE(fe25519)
#define fe25519_10l_dense      CRYPTO_NAMESPACE(fe25519_10l_dense)
#define fe25519_freeze         CRYPTO_SHARED_NAMESPACE(fe25519_freeze)
#define fe25519_unpack         CRYPTO_NAMESPACE(fe25519_unpack)
#define fe25519_pack           CRYPTO_NAMESPACE(fe25519_pack)
#define fe25519_iszero_vartime CRYPTO_NAMESPACE(fe25519_iszero_vartime)
#define fe25519_iseq_vartime   CRYPTO_NAMESPACE(fe25519_iseq_vartime)
#define fe25519_cmov           CRYPTO_SHARED_NAMESPACE(fe25519_cmov)
#define fe25519_setint         CRYPTO_NAMESPACE(fe25519_setint)
#define fe25519_neg            CRYPTO_NAMESPACE(fe25519_neg)
#define fe25519_getparity      CRYPTO_NAMESPACE(fe25519_getparity)
#define fe25519_add            CRYPTO_SHARED_NAMESPACE(fe25519_add)
#define fe25519_sub            CRYPTO_SHARED_NAMESPACE(fe25519_sub)
#define fe25519_mul            CRYPTO_SHARED_NAMESPACE(fe25519_mul)
#define fe25519_mul121666      CRYPTO_NAMESPACE(fe25519_mul121666)
#define fe25519_square         CRYPTO_SHARED_NAMESPACE(fe25519_square)
#define fe25519_nsquare        CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
#define fe25519_invert         CRYPTO_NAMESPACE(fe25519_invert)
#define fe25519_pow2523        CRYPTO_NAMESPACE(fe25519_pow2523)

#define fe25519_10l_dense_setint	   CRYPTO_NAMESPACE(fe25519_10l_dense_setint)
#define fe25519_10l_dense_iseq_vartime   CRYPTO_NAMESPACE(fe25519_10l_dense_iseq_vartime)
#define fe25519_10l_dense_getparity      CRYPTO_NAMESPACE(fe25519_10l_dense_getparity)

#define fe25519_10l_dense_to_4l      CRYPTO_SHARED_NAMESPACE(fe25519_10l_dense_to_4l)
#define fe25519_4l_to_10l_dense      CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_10l_dense)

typedef struct 
{
  unsigned long long v[4]; 
}
fe25519;

typedef struct 
{
  unsigned long long v[5]; 
}
fe25519_10l_dense;

void fe25519_freeze(fe25519 *r);

void fe25519_unpack(fe25519 *r, const unsigned char x[32]);

void fe25519_pack(unsigned char r[32], const fe25519 *x);

void fe25519_cmov(fe25519 *r, const fe25519 *x, unsigned char b);

void fe25519_cswap(fe25519 *r, fe25519 *x, unsigned char b);

void fe25519_setint(fe25519 *r, unsigned int v);

void fe25519_neg(fe25519 *r, const fe25519 *x);

unsigned char fe25519_getparity(const fe25519 *x);

int fe25519_iszero_vartime(const fe25519 *x);

int fe25519_iseq_vartime(const fe25519 *x, const fe25519 *y);

void fe25519_add(fe25519_10l_dense *r, const fe25519_10l_dense *x, const fe25519_10l_dense *y);

void fe25519_sub(fe25519_10l_dense *r, const fe25519_10l_dense *x, const fe25519_10l_dense *y);

void fe25519_mul(fe25519_10l_dense *r, const fe25519_10l_dense *x, const fe25519_10l_dense *y);

void fe25519_mul121666(fe25519 *r, const fe25519 *x);

void fe25519_nsquare(fe25519_10l_dense *r, const fe25519_10l_dense *x, long long n);

void fe25519_square(fe25519_10l_dense *r, const fe25519_10l_dense *x);

void fe25519_pow(fe25519 *r, const fe25519 *x, const unsigned char *e);

void fe25519_invert(fe25519 *r, const fe25519 *x);

void fe25519_pow2523(fe25519_10l_dense *r, const fe25519_10l_dense *x);

void fe25519_10l_dense_setint(fe25519_10l_dense *, unsigned int);

int fe25519_10l_dense_iseq_vartime(const fe25519_10l_dense *, const fe25519_10l_dense *);

unsigned char fe25519_10l_dense_getparity(const fe25519_10l_dense *);

void  fe25519_10l_dense_to_4l(fe25519 *, const fe25519_10l_dense *);

void  fe25519_4l_to_10l_dense(fe25519_10l_dense *, const fe25519 *);

#endif
