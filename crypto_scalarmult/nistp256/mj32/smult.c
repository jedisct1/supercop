/*
20140917
Jan Mojzis
Public domain.
*/

#include "cleanup.h"
#include "gep256.h"
#include "crypto_scalarmult.h"

int crypto_scalarmult(unsigned char *q, const unsigned char *n, const unsigned char *p) {

    gep256 pp, qq;
    long long i;

    int ret = gep256_frombytes(pp, p);
    gep256_scalarmult(qq, pp, n);
    ret &= ~gep256_tobytes(q, qq);

    for (i = 0; i < 64; ++i) q[i] &= ~ret;

    cleanup(pp); cleanup(qq);
    return ret;
}

int crypto_scalarmult_base(unsigned char *q, const unsigned char *n) {

    gep256 qq;
    long long i;
    int ret;

    gep256_scalarmult_base(qq, n);
    ret = gep256_tobytes(q, qq);

    cleanup(qq);
    return ret;
}
