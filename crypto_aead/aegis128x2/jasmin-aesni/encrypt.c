#include <stddef.h>

#include "api.h"
#include "crypto_aead.h"

typedef struct Params {
    unsigned char       *c;
    unsigned long long   clen;
    unsigned char       *mac;
    unsigned char        maclen;
    unsigned char       *m;
    unsigned long long   mlen;
    const unsigned char *ad;
    unsigned long long   adlen;
    const unsigned char *k;
    const unsigned char *npub;
} Params;

#define _aegis128x2_encrypt CRYPTO_NAMESPACE(_aegis128x2_encrypt)
#define _aegis128x2_decrypt CRYPTO_NAMESPACE(_aegis128x2_decrypt)

extern int _aegis128x2_encrypt(const Params *params);
extern int _aegis128x2_decrypt(const Params *params);

static int
crypto_aead_encrypt_detached(unsigned char       *c,
                             unsigned char       *mac,
                             unsigned long long  *maclen_p,
                             const unsigned char *m,
                             unsigned long long   mlen,
                             const unsigned char *ad,
                             unsigned long long   adlen,
                             const unsigned char *nsec,
                             const unsigned char *npub,
                             const unsigned char *k)
{
    const Params params = { c, mlen, mac, CRYPTO_ABYTES, (unsigned char *) m, mlen, ad, adlen, k, npub };
    return _aegis128x2_encrypt(&params);
}

static int
crypto_aead_decrypt_detached(unsigned char       *m,
                             unsigned char       *nsec,
                             const unsigned char *c,
                             unsigned long long   clen,
                             const unsigned char *mac,
                             const unsigned char *ad,
                             unsigned long long   adlen,
                             const unsigned char *npub,
                             const unsigned char *k)
{
    const Params params = {
        (unsigned char *) c, clen, (unsigned char *) mac, CRYPTO_ABYTES, m, clen, ad, adlen, k, npub
    };
    return _aegis128x2_decrypt(&params);
}

int
crypto_aead_encrypt(unsigned char       *c,
                    unsigned long long  *clen_p,
                    const unsigned char *m,
                    unsigned long long   mlen,
                    const unsigned char *ad,
                    unsigned long long   adlen,
                    const unsigned char *nsec,
                    const unsigned char *npub,
                    const unsigned char *k)
{
    (void) nsec;

    if (clen_p != NULL) {
        *clen_p = mlen + CRYPTO_ABYTES;
    }
    return crypto_aead_encrypt_detached(
        c, c + mlen, NULL, m, mlen, ad, adlen, NULL, npub, k);
}

int
crypto_aead_decrypt(unsigned char       *m,
                    unsigned long long  *mlen_p,
                    unsigned char       *nsec,
                    const unsigned char *c,
                    unsigned long long   clen,
                    const unsigned char *ad,
                    unsigned long long   adlen,
                    const unsigned char *npub,
                    const unsigned char *k)
{
    (void) nsec;

    if (clen < CRYPTO_ABYTES) {
        return -1;
    }
    if (mlen_p != NULL) {
        *mlen_p = clen - CRYPTO_ABYTES;
    }
    return crypto_aead_decrypt_detached(
        m, NULL, c, clen - CRYPTO_ABYTES, c + clen - CRYPTO_ABYTES, ad, adlen, npub, k);
}
