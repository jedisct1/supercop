#ifndef FAEST_API_HPP
#define FAEST_API_HPP

extern "C"
{
#include "randomness.h"
}

#include "faest.hpp"
#include "faest_keys.hpp"
#include <cstdint>
#include <cstring>

namespace faest
{

template <typename P> struct faest_scheme
{
    constexpr static unsigned long long CRYPTO_SECRETKEYBYTES = FAEST_SECRET_KEY_BYTES<P>;
    constexpr static unsigned long long CRYPTO_PUBLICKEYBYTES = FAEST_PUBLIC_KEY_BYTES<P>;
    constexpr static unsigned long long CRYPTO_BYTES = FAEST_SIGNATURE_BYTES<P>;
    // #define CRYPTO_ALGNAME "%VERSION%"

    static int crypto_sign_keypair(unsigned char* pk, unsigned char* sk)
    {
        if (is_owf_with_zero_sboxes(P::owf_v))
        {
            constexpr auto sk_offset = FAEST_IV_BYTES<P>;
            memset(sk, 0, sk_offset);
            do
            {
                rand_bytes(sk + sk_offset, FAEST_SECRET_KEY_BYTES<P> - sk_offset);
            } while (!faest_seckey<P>(sk));
            rand_bytes(sk, sk_offset);

            bool success = faest_pubkey<P>(pk, sk);
            assert(success);
            (void) success;

            return 0;
        }
        else
        {
            do
            {
                rand_bytes(sk, FAEST_SECRET_KEY_BYTES<P>);
            } while (!faest_pubkey<P>(pk, sk));
            return 0;
        }
    }

    static int crypto_sign(unsigned char* sm, unsigned long long* smlen, const unsigned char* m,
                           unsigned long long mlen, const unsigned char* sk)
    {
        *smlen = mlen + FAEST_SIGNATURE_BYTES<P>;
        memmove(sm, m, mlen);

        uint8_t random_seed[P::secpar_bytes];
        rand_bytes(random_seed, sizeof(random_seed));
        faest_sign<P>(sm + mlen, sm, mlen, sk, random_seed, sizeof(random_seed));
        return 0;
    }

    static int crypto_sign_open(unsigned char* m, unsigned long long* mlen, const unsigned char* sm,
                                unsigned long long smlen, const unsigned char* pk)
    {
        unsigned long long m_length = smlen - FAEST_SIGNATURE_BYTES<P>;
        if (!faest_verify<P>(sm + m_length, sm, m_length, pk))
            return -1;

        *mlen = m_length;
        memmove(m, sm, m_length);
        return 0;
    }
};

} // namespace faest

#endif
