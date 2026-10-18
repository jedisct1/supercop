#include "namespace.h"
#include <string.h>
#include "symmetric.h"
#include "util.h"

#include "crypto_xof_shake256.h"

extern void ntruplus_hash_g_fixed(uint8_t output[NTRUPLUS_N / 4],
                           const uint8_t input[NTRUPLUS_POLYBYTES]);

#ifndef HASH_F_INBYTES
#define HASH_F_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_F_OUTBYTES (32)
#define HASH_G_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_G_OUTBYTES (NTRUPLUS_N / 4)
#define HASH_H_INBYTES  (NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES)
#define HASH_H_OUTBYTES (NTRUPLUS_SSBYTES + NTRUPLUS_N / 4)
#endif

void hash_f(uint8_t *buf, const uint8_t *msg)
{
    uint8_t x[1+HASH_F_INBYTES];
    x[0] = 0;
    memcpy(x+1,msg,HASH_F_INBYTES);
    crypto_xof_shake256(buf,HASH_F_OUTBYTES,x,sizeof x);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
    /* Absorb the virtual prefix || msg before writing any output (buf == msg
     * is used by Encap). No domain-prefixed message copy is materialized. */
    ntruplus_hash_g_fixed(buf, msg);
}

void hash_h(uint8_t *buf, const uint8_t *msg)
{
    uint8_t x[1+HASH_H_INBYTES];
    x[0] = 2;
    memcpy(x+1,msg,HASH_H_INBYTES);
    crypto_xof_shake256(buf,HASH_H_OUTBYTES,x,sizeof x);
}
