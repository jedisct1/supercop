// 20250922 djb: switch to little-endian

#include <stdint.h>
#include "fep256.h"
#include "curve.h"
#include "randombytes.h"

int
CRYPTO_NAMESPACE(keypair)(unsigned char *pk, unsigned char *sk)
{
        unsigned char skbig[32];
        unsigned char pkbig[64];
        point temp;
        randombytes(sk, 32);
        for (long long i = 0;i < 32;++i) skbig[i] = sk[31-i];
        p256scalarmult_base(&temp, skbig);
        p256pack(pkbig, &temp);
        for (long long i = 0;i < 32;++i) pk[i] = pkbig[31-i];
        for (long long i = 0;i < 32;++i) pk[32+i] = pkbig[32+31-i];
        return 0;
}

int
CRYPTO_NAMESPACETOP(unsigned char *out, const unsigned char *p,
                                const unsigned char *n)
{
        unsigned char nbig[32];
        unsigned char pbig[64];
        unsigned char outbig[64];
        point temp;
        for (long long i = 0;i < 32;++i) nbig[i] = n[31-i];
        for (long long i = 0;i < 32;++i) pbig[i] = p[31-i];
        for (long long i = 0;i < 32;++i) pbig[32+i] = p[32+31-i];
        p256unpack(&temp, pbig);
        if(!p256oncurvefinite(&temp)){ //we don't have a good point
                p256scalarmult_base(&temp, nbig); //use the basepoint instead
        } else {
                p256scalarmult(&temp, &temp, nbig);
	}
        p256pack(outbig, &temp);
        for (long long i = 0;i < 32;++i) out[i] = outbig[31-i];
        for (long long i = 0;i < 32;++i) out[32+i] = outbig[32+31-i];
        return 0;
}
