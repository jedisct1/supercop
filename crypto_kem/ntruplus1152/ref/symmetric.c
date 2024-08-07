#include "sha2.h"
#include "aes256ctr.h"
#include "symmetric.h"

static const unsigned char n[16] = {0};

void hash_f(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_PUBLICKEYBYTES] = {0x0};

	for (int i = 0; i < NTRUPLUS_PUBLICKEYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	sha256(buf, data, NTRUPLUS_PUBLICKEYBYTES + 1);
}

void hash_g(uint8_t *buf, const uint8_t *msg)
{
	uint8_t data[1 + NTRUPLUS_POLYBYTES] = {0x1};

	for (int i = 0; i < NTRUPLUS_POLYBYTES; i++)
	{
		data[i+1] = msg[i];
	}
	
	sha256(buf, data, NTRUPLUS_POLYBYTES + 1);
	aes256ctr_prf(buf, NTRUPLUS_N/4, buf, n);
}

void hash_h_kem(uint8_t *buf, const uint8_t *msg)
{
	sha512(buf, msg, NTRUPLUS_N/8 + NTRUPLUS_SYMBYTES);
	aes256ctr_prf(buf + NTRUPLUS_SSBYTES, NTRUPLUS_N/4, buf + NTRUPLUS_SSBYTES, n);
}
