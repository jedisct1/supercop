#include "util.h"
#include <string.h>
#include "symmetric.h"
#include "fips202.h"

void hash_f(uint8_t *buf, const uint8_t *msg)
{
    uint8_t data[1 + HASH_F_INBYTES];

    data[0] = 0x00;
    memcpy(data + 1, msg, HASH_F_INBYTES);
    shake256(buf, HASH_F_OUTBYTES, data, HASH_F_INBYTES + 1);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
    uint8_t data[1 + HASH_G_INBYTES];

    data[0] = 0x01;
    memcpy(data + 1, msg, HASH_G_INBYTES);
    shake256(buf, HASH_G_OUTBYTES, data, HASH_G_INBYTES + 1);
    secure_clear(data, sizeof data);
}

void hash_h(uint8_t *buf, const uint8_t *msg)
{
    uint8_t data[1 + HASH_H_INBYTES];

    data[0] = 0x02;
    memcpy(data + 1, msg, HASH_H_INBYTES);
    shake256(buf, HASH_H_OUTBYTES, data, HASH_H_INBYTES + 1);
    secure_clear(data, sizeof data);
}
