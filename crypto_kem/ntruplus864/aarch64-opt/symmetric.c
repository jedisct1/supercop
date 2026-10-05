#include <string.h>
#include "symmetric.h"
#include "secure_clear.h"

#include "fips202.h"

#define HASH_F_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_F_OUTBYTES (32)

#define HASH_G_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_G_OUTBYTES (NTRUPLUS_N / 4)

#define HASH_H_INBYTES  (NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES)
#define HASH_H_OUTBYTES (NTRUPLUS_SSBYTES + NTRUPLUS_N / 4)

void tobytes_full_asm(uint8_t *, const int16_t *);
void ntruplus_hash_f_fixed(uint8_t output[32], const uint8_t input[1296]);
void ntruplus_hash_g_fixed(uint8_t output[216], const uint8_t input[1296]);

void hash_f(uint8_t *buf, const uint8_t *msg)
{
    ntruplus_hash_f_fixed(buf, msg);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
    ntruplus_hash_g_fixed(buf, msg);
}

void hash_g_fr0(uint8_t *buf, const int16_t coeffs[NTRUPLUS_N])
{
    uint8_t data[HASH_G_INBYTES];

    tobytes_full_asm(data, coeffs);
    ntruplus_hash_g_fixed(buf, data);
    secure_clear(data, sizeof data);
}

void hash_h(uint8_t *buf, const uint8_t *msg)
{
    /* The prefixed entry point absorbs 0x02 || msg without building a copy. */
    shake256_prefixed(buf, HASH_H_OUTBYTES, 0x02, msg, HASH_H_INBYTES);
}
