#include <openssl/sha.h>
#include "aes256ctr.h"
#include "symmetric.h"

void hash_f(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_PUBLICKEYBYTES] = {0x0};

	for (int i = 0; i < NTRUPLUS_PUBLICKEYBYTES; i++)
	{
		data[i+1] = msg[i];
	}

	SHA256(data, NTRUPLUS_PUBLICKEYBYTES + 1, buf);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_POLYBYTES] = {0x1};

	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	SHA256(data, NTRUPLUS_POLYBYTES + 1, buf);
	aes256ctr_prf(buf, NTRUPLUS_N/4, buf, 0);
}

void hash_h_kem(uint8_t *buf, const uint8_t *msg)
{
	SHA512(msg, NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES, buf);
  	aes256ctr_prf(buf + NTRUPLUS_SSBYTES, NTRUPLUS_N/4, buf + NTRUPLUS_SSBYTES, 0);
}
