#include <cryptopp/shake.h>
#include "crypto_hash.h"

int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
        CryptoPP::SHAKE256 sha(crypto_hash_BYTES);
        sha.CalculateDigest(out, in, inlen);
        return 0;
}
