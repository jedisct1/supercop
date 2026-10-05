#include "namespace.h"
#include <string.h>
#include "symmetric.h"
#include "util.h"

#include "fips202.h"

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
    /* The prefixed entry point absorbs 0x00 || msg without building a copy. */
    shake256_prefixed(buf, HASH_F_OUTBYTES, 0x00, msg, HASH_F_INBYTES);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
    /* Absorb the virtual prefix || msg before writing any output (buf == msg
     * is used by Encap). No domain-prefixed message copy is materialized. */
    ntruplus_hash_g_fixed(buf, msg);
}

void hash_h(uint8_t *buf, const uint8_t *msg)
{
    /* The prefixed entry point absorbs 0x02 || msg without building a copy. */
    shake256_prefixed(buf, HASH_H_OUTBYTES, 0x02, msg, HASH_H_INBYTES);
}
