#include <string.h>
#include "symmetric.h"
#include "secure_clear.h"
#include "fips202.h"
#include "pack_asm.h"

/*
 * NTRU+1152 symmetric layer.
 *
 * All three transcripts go through fips202.c's shake256_prefixed: SHAKE256 over
 * a domain byte followed by the message, absorbed straight out of the caller's
 * buffer so the concatenation is never built.  hash_f and hash_g take
 * 1 + 1728 bytes, which is 12 full rate blocks plus a 97-byte tail; hash_h
 * takes 1 + 176, which is one full block plus a 41-byte tail.
 *
 * Counting permutations as ceil((inlen+1)/r) + ceil(outlen/r) - 1 -- the -1
 * because the padded final absorb block and the first squeeze share one
 * permutation -- hash_h takes 2 + 3 - 1 = 4, against 13 for hash_f and 15 for
 * hash_g.
 */

#define HASH_F_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_F_OUTBYTES (32)
#define HASH_G_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_G_OUTBYTES (NTRUPLUS_N / 4)
#define HASH_H_INBYTES  (NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES)
#define HASH_H_OUTBYTES (NTRUPLUS_SSBYTES + NTRUPLUS_N / 4)

void ntruplus_hash_f_fixed(uint8_t output[HASH_F_OUTBYTES],
                           const uint8_t input[HASH_F_INBYTES]);
void ntruplus_hash_g_fixed(uint8_t output[HASH_G_OUTBYTES],
                           const uint8_t input[HASH_G_INBYTES]);

void hash_f(uint8_t *buf, const uint8_t *msg)
{
    ntruplus_hash_f_fixed(buf, msg);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
    ntruplus_hash_g_fixed(buf, msg);
}

/* Encapsulation-private boundary: serialize straight into the transcript. */
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
