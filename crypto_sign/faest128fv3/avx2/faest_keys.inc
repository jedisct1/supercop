#ifndef FAEST_KEYS_INC
#define FAEST_KEYS_INC

#include "aes.hpp"
#include "constants.hpp"
#include "faest_keys.hpp"
#include "gfsmall.hpp"
#include "parameters.hpp"

namespace faest
{

template <typename P>
    requires(is_owf_with_aes_ecb(P::owf_v))
void public_key<P>::pack(uint8_t* packed_pk_) const
{
    const auto packed_pk = mutable_packed_pk_view<P>(packed_pk_);

    // Copy AES input
    if constexpr (is_owf_with_ctr_input(P::owf_v) && P::OWF_CONSTS::OWF_BLOCKS > 1)
    {
        static_assert(sizeof(this->owf_input[0]) == decltype(packed_pk.aes_input())::extent);
        memcpy(packed_pk.aes_input().data(), &this->owf_input[0], packed_pk.aes_input().size());
    }
    else
    {
        static_assert(sizeof(this->owf_input) == decltype(packed_pk.aes_input())::extent);
        memcpy(packed_pk.aes_input().data(), &this->owf_input, packed_pk.aes_input().size());
    }

    // Copy AES output
    static_assert(sizeof(this->owf_output) == decltype(packed_pk.owf_output())::extent);
    memcpy(packed_pk.owf_output().data(), &this->owf_output, packed_pk.owf_output().size());
}

template <typename P>
    requires(is_owf_with_aes_ecb(P::owf_v))
public_key<P> public_key<P>::unpack(const uint8_t* packed_pk_)
{
    const auto packed_pk = packed_pk_view<P>(packed_pk_);

    public_key<P> unpacked;

    // Copy AES input
    if constexpr (is_owf_with_ctr_input(P::owf_v) && P::OWF_CONSTS::OWF_BLOCKS > 1)
    {
        // Copy first block
        static_assert(sizeof(unpacked.owf_input[0]) == decltype(packed_pk.aes_input())::extent);
        memcpy(&unpacked.owf_input[0], packed_pk.aes_input().data(), packed_pk.aes_input().size());
        // Compute the second block as the first XOR 1.
        unpacked.owf_input[1] = unpacked.owf_input[0];
        reinterpret_cast<uint8_t*>(&unpacked.owf_input[1])[0] ^= 0x01;
    }
    else
    {
        static_assert(sizeof(unpacked.owf_input) == decltype(packed_pk.aes_input())::extent);
        memcpy(&unpacked.owf_input, packed_pk.aes_input().data(), packed_pk.aes_input().size());
    }

    // Copy AES output
    static_assert(sizeof(unpacked.owf_output) == decltype(packed_pk.owf_output())::extent);
    memcpy(&unpacked.owf_output, packed_pk.owf_output().data(), packed_pk.owf_output().size());

    return unpacked;
}

template <typename P>
    requires(is_owf_with_aes_em(P::owf_v))
void public_key<P>::pack(uint8_t* packed_pk_) const
{
    const auto packed_pk = mutable_packed_pk_view<P>(packed_pk_);

    // Copy fixed key
    static_assert(sizeof(this->fixed_key) == decltype(packed_pk.fixed_key())::extent);
    memcpy(packed_pk.fixed_key().data(), &this->fixed_key, packed_pk.fixed_key().size());

    // Copy AES/Rijndael output
    static_assert(sizeof(this->owf_output) == decltype(packed_pk.owf_output())::extent);
    memcpy(packed_pk.owf_output().data(), &this->owf_output, packed_pk.owf_output().size());
}

template <typename P>
    requires(is_owf_with_aes_em(P::owf_v))
public_key<P> public_key<P>::unpack(const uint8_t* packed_pk_)
{
    const auto packed_pk = packed_pk_view<P>(packed_pk_);

    public_key<P> unpacked;

    // Copy fixed key
    static_assert(sizeof(unpacked.fixed_key) == decltype(packed_pk.fixed_key())::extent);
    memcpy(&unpacked.fixed_key, packed_pk.fixed_key().data(), packed_pk.fixed_key().size());

    // Copy AES/Rijndael output
    static_assert(sizeof(unpacked.owf_output) == decltype(packed_pk.owf_output())::extent);
    memcpy(&unpacked.owf_output, packed_pk.owf_output().data(), packed_pk.owf_output().size());

    // Compute the key schedule of the public fixed key.
    rijndael_keygen<P::secpar_v>(&unpacked.fixed_key_round_keys, unpacked.fixed_key);

    return unpacked;
}

template <typename P>
    requires(is_owf_with_aes_ecb(P::owf_v))
void secret_key<P>::pack(uint8_t* packed_sk_) const
{
    const auto packed_sk = mutable_packed_sk_view<P>(packed_sk_);
}

template <typename P>
    requires(is_owf_with_aes_em(P::owf_v))
void secret_key<P>::pack(uint8_t* packed_sk_) const
{
    const auto packed_sk = mutable_packed_sk_view<P>(packed_sk_);
}

template <typename P>
    requires(is_owf_with_aes_ecb(P::owf_v))
std::expected<secret_key<P>, std::monostate> secret_key<P>::unpack(const uint8_t* packed_sk_)
{
    const auto packed_sk = packed_sk_view<P>(packed_sk_);
    secret_key<P> unpacked;

    // Copy the input block(s).
    memcpy(&unpacked.pk.owf_input, packed_sk.aes_input().data(), packed_sk.aes_input().size());
    if constexpr (is_owf_with_ctr_input(P::owf_v) && P::OWF_CONSTS::OWF_BLOCKS > 1)
    {
        // If we use the CTR inputs, then the packed sk only contains the first block and we
        // compute the second block as the first XOR 1.
        static_assert(sizeof(unpacked.pk.owf_input[0]) == decltype(packed_sk.aes_input())::extent);
        unpacked.pk.owf_input[1] = unpacked.pk.owf_input[0];
        reinterpret_cast<uint8_t*>(&unpacked.pk.owf_input[1])[0] ^= 0x01;
    }
    else
    {
        // Otherwise, we should have copied all blocks from the packed key.
        static_assert(sizeof(unpacked.pk.owf_input) == decltype(packed_sk.aes_input())::extent);
    }

    // Load the secret key.
    memcpy(&unpacked.sk, packed_sk.aes_key().data(), packed_sk.aes_key().size());
    static_assert(sizeof(unpacked.sk) == decltype(packed_sk.aes_key())::extent);

    // Compute the key schedule of the secret AES key.
    aes_keygen<P::secpar_v>(&unpacked.round_keys, unpacked.sk);

    if (faest_compute_witness(&unpacked))
        return unpacked;
    else
        return {};
}

template <typename P>
    requires(is_owf_with_aes_em(P::owf_v))
std::expected<secret_key<P>, std::monostate> secret_key<P>::unpack(const uint8_t* packed_sk_)
{
    const auto packed_sk = packed_sk_view<P>(packed_sk_);
    secret_key<P> unpacked;

    // Load the Rijndael fixed key.
    memcpy(&unpacked.pk.fixed_key, packed_sk.fixed_key().data(), packed_sk.fixed_key().size());
    static_assert(sizeof(unpacked.pk.fixed_key) == decltype(packed_sk.fixed_key())::extent);
    // Load the Even-Mansour key.
    memcpy(&unpacked.sk, packed_sk.em_key().data(), packed_sk.em_key().size());
    static_assert(sizeof(unpacked.sk) == decltype(packed_sk.em_key())::extent);
    // Compute the key schedule of the public fixed key.
    rijndael_keygen<P::secpar_v>(&unpacked.pk.fixed_key_round_keys, unpacked.pk.fixed_key);

    if (faest_compute_witness(&unpacked))
        return unpacked;
    else
        return {};
}

template <typename P> bool faest_unpack_secret_key(secret_key<P>* unpacked, const uint8_t* packed)
{
    const auto sk = secret_key<P>::unpack(packed);
    if (!sk)
        return false;
    *unpacked = *sk;
    return true;
}

template <typename P>
ALWAYS_INLINE void faest_pack_public_key(uint8_t* packed, const public_key<P>* unpacked)
{
    unpacked->pack(packed);
}

template <typename P>
ALWAYS_INLINE void faest_unpack_public_key(public_key<P>* unpacked, const uint8_t* packed_)
{
    *unpacked = public_key<P>::unpack(packed_);
}

template <typename P> bool faest_compute_witness(secret_key<P>* sk)
{
    using OC = P::OWF_CONSTS;
    using owf_block = OC::block_t;

    uint8_t* w_ptr = (uint8_t*)&sk->witness;

    memcpy(w_ptr, &sk->sk, sizeof(sk->sk));

    if constexpr (is_owf_with_shrunk_keyspace(P::owf_v))
    {
        // Make sure that the first two bits of the key are not both 1.
        if ((w_ptr[0] & 1) && (w_ptr[0] & 2))
        {
            return false;
        }
    }

    w_ptr += sizeof(sk->sk);

    if constexpr (is_owf_with_aes_ecb(P::owf_v))
    {
        // Extract witness for key schedule.
        for (size_t i = P::secpar_bytes; i < OC::OWF_BLOCK_SIZE * (OC::OWF_ROUNDS + 1);
             i += OC::OWF_KEY_SCHEDULE_PERIOD, w_ptr += 4)
        {
            uint32_t prev_word, word;
            memcpy(&prev_word, ((uint8_t*)&sk->round_keys.keys[0]) + i - P::secpar_bytes, 4);
            memcpy(&word, ((uint8_t*)&sk->round_keys.keys[0]) + i, 4);
            memcpy(w_ptr, &word, 4);

            uint32_t sbox_output = word ^ prev_word;
            if (P::secpar_v != secpar::s256 || i % P::secpar_bytes == 0)
                sbox_output ^= aes_round_constants[i / P::secpar_bytes - 1];

            if constexpr (!is_owf_with_zero_sboxes(P::owf_v))
            {
                // Check if there is an S-box with a zero
                // https://graphics.stanford.edu/~seander/bithacks.html#ZeroInWord
                sbox_output ^= 0x63636363; // AES SBox maps 0 to 0x63.
                if ((sbox_output - 0x01010101) & ~sbox_output & 0x80808080)
                    return false;
            }
        }
    }

    FAEST_ASSERT(w_ptr - (uint8_t*)&sk->witness == OC::OWF_KEY_WITNESS_BITS / 8);

    if constexpr (is_owf_with_aes_ecb(P::owf_v))
    {
        for (uint32_t i = 0; i < OC::OWF_BLOCKS; ++i)
            sk->pk.owf_output[i] = sk->round_keys.keys[0] ^ sk->pk.owf_input[i];
    }
    else if constexpr (is_owf_with_aes_em(P::owf_v))
    {
        static_assert(OC::OWF_BLOCKS == 1, "");
        sk->pk.owf_output[0] = sk->pk.fixed_key_round_keys.keys[0] ^ sk->sk;
    }

    constexpr size_t witness_bytes_per_block = OC::OWF_ENC_WITNESS_BITS_PER_BLOCK / 8;

    // NB: Compared to the spec
    // - the order of the loops is switched
    // - the rounds are indexed by [1, R] instead of [0, R-2]
    for (size_t round_j = 1; round_j <= OC::OWF_ROUNDS; ++round_j)
    {
        for (size_t owf_block_i = 0; owf_block_i < OC::OWF_BLOCKS; ++owf_block_i)
        {
            if constexpr (!is_owf_with_zero_sboxes(P::owf_v))
            {
                // The block is about to go into the SBox, so check for zeros.
                if (sk->pk.owf_output[owf_block_i].any_zeros())
                    return false;
            }

            if constexpr (is_owf_with_norm_proof(P::owf_v))
            {
                if (round_j < OC::OWF_ROUNDS && (round_j & 1) == 1)
                {
                    // "even" case in the spec
                    // compute the inverse norms and compress
                    std::array<uint8_t, OC::OWF_BLOCK_SIZE / 2> invnorms;
                    gf256_gf16_batch_invnorm<OC::OWF_BLOCK_SIZE>(
                        invnorms.data(),
                        reinterpret_cast<uint8_t*>(&sk->pk.owf_output[owf_block_i]));
                    // store the inverse norms into the witness
                    memcpy(w_ptr + owf_block_i * witness_bytes_per_block, invnorms.data(),
                           OC::OWF_BLOCK_SIZE / 2);
                }
            }

            owf_block after_sbox;
            if constexpr (is_owf_with_aes_ecb(P::owf_v))
            {
                aes_round_function<P::secpar_v>(&sk->round_keys, &sk->pk.owf_output[owf_block_i],
                                                &after_sbox, round_j);
            }
            else if constexpr (is_owf_with_aes_em(P::owf_v))
            {
                if constexpr (P::secpar_v == secpar::s128)
                    aes_round_function<secpar::s128>(
                        &sk->pk.fixed_key_round_keys, &sk->pk.owf_output[owf_block_i], &after_sbox, round_j);
                else if constexpr (P::secpar_v == secpar::s192)
                    rijndael192_round_function(&sk->pk.fixed_key_round_keys, &sk->pk.owf_output[owf_block_i],
                                               &after_sbox, round_j);
                else if constexpr (P::secpar_v == secpar::s256)
                    rijndael256_round_function(&sk->pk.fixed_key_round_keys, &sk->pk.owf_output[owf_block_i],
                                               &after_sbox, round_j);
            }
            if constexpr (is_owf_with_norm_proof(P::owf_v) || is_owf_with_deg7_proof(P::owf_v))
            {
                if (round_j < OC::OWF_ROUNDS && ((round_j & 1) == 0))
                {
                    // "odd" case of the spec -> full-sized state
                    memcpy(w_ptr + owf_block_i * witness_bytes_per_block, &after_sbox,
                           sizeof(owf_block));
                }
            }
            else
            {
                if (round_j < OC::OWF_ROUNDS)
                    memcpy(w_ptr + owf_block_i * witness_bytes_per_block, &after_sbox,
                           sizeof(owf_block));
            }
        }

        if (round_j < OC::OWF_ROUNDS)
        {
            if constexpr (is_owf_with_deg7_proof(P::owf_v))
            {
                if ((round_j & 1) == 0)
                {
                    // "odd" case of the spec -> full-sized state
                    w_ptr += sizeof(owf_block);
                }
            }
            else if constexpr (is_owf_with_norm_proof(P::owf_v))
            {
                if ((round_j & 1) == 0)
                {
                    // "odd" case of the spec -> full-sized state
                    w_ptr += sizeof(owf_block);
                }
                else
                {
                    // "even" case of the spec -> half-sized state
                    w_ptr += sizeof(owf_block) / 2;
                }
            }
            else
            {
                w_ptr += sizeof(owf_block);
            }
        }
    }

    w_ptr += (OC::OWF_BLOCKS - 1) * OC::OWF_ENC_WITNESS_BITS_PER_BLOCK / 8;
    FAEST_ASSERT(w_ptr - (uint8_t*)&sk->witness == OC::WITNESS_BITS / 8);
    memset(w_ptr, 0, sizeof(sk->witness) - OC::WITNESS_BITS / 8);

    if constexpr (is_owf_with_aes_em(P::owf_v))
    {
        for (uint32_t i = 0; i < OC::OWF_BLOCKS; ++i)
            sk->pk.owf_output[i] = sk->pk.owf_output[i] ^ sk->sk;
    }

    return true;
}

template <typename P>
bool faest_unpack_sk_and_get_pubkey(uint8_t* pk_packed, const uint8_t* sk_packed, secret_key<P>* sk)
{
    if (!faest_unpack_secret_key(sk, sk_packed))
        return false;

    faest_pack_public_key(pk_packed, &sk->pk);
    return true;
}

template <typename P> bool faest_seckey(const uint8_t* packed_sk)
{
    secret_key<P> sk;
    if constexpr (!is_owf_with_zero_sboxes(P::owf_v))
        return faest_unpack_secret_key<P>(&sk, packed_sk);
    else if constexpr (is_owf_with_shrunk_keyspace(P::owf_v))
        // check that the first two bits of the secret key are not both 1
        return (0x3 & packed_sk[FAEST_IV_BYTES<P>]) != 0x3;
    else
        return true;
}

template <typename P> bool faest_pubkey(uint8_t* packed_pk_, const uint8_t* packed_sk_)
{
    secret_key<P> sk;
    if constexpr (!is_owf_with_zero_sboxes(P::owf_v))
    {
        return faest_unpack_sk_and_get_pubkey(packed_pk_, packed_sk_, &sk);
    }
    else
    {
        if (!faest_seckey<P>(packed_sk_))
            return false;

        using OC = P::OWF_CONSTS;
        using owf_block = OC::block_t;
        constexpr auto S = P::secpar_v;
        const auto packed_sk = packed_sk_view<P>(packed_sk_);
        const auto packed_pk = mutable_packed_pk_view<P>(packed_pk_);

        std::array<owf_block, OC::OWF_BLOCKS> input;
        std::array<owf_block, OC::OWF_BLOCKS> output;
        memcpy(input.data(), packed_sk.owf_input().data(), packed_sk.owf_input().size());

        if constexpr (is_owf_with_ctr_input(P::owf_v) && OC::OWF_BLOCKS == 2)
        {
            input[1] = input[0];
            reinterpret_cast<uint8_t*>(&input[1])[0] ^= 0x01;
        }

        if constexpr (is_owf_with_aes_ecb(P::owf_v))
        {
            block_secpar<S> aes_key;
            memcpy(&aes_key, packed_sk.aes_key().data(), packed_sk.aes_key().size());
            aes_round_keys<S> round_keys;
            output = input;
            aes_keygen_ecb<S, 1, OC::OWF_BLOCKS>(&aes_key, &round_keys, output.data());
        }
        else if constexpr (is_owf_with_aes_em(P::owf_v))
        {
            block_secpar<S> em_key;
            block_secpar<S> fixed_key;
            memcpy(&em_key, packed_sk.em_key().data(), packed_sk.em_key().size());
            memcpy(&fixed_key, packed_sk.fixed_key().data(), packed_sk.fixed_key().size());
            rijndael_round_keys<S> round_keys;
            const auto zero = block_secpar<S>::set_zero();
            uint32_t tweak = 0;
            uint32_t counter = 0;
            rijndael_keygen<S>(&round_keys, fixed_key);
            rijndael_fixed_key_ctr<S, 1, 1>(&round_keys, &em_key, zero, &tweak, &counter,
                                            output.data());
        }
        else
        {
            static_assert(false, "unsupported OWF");
        }
        memcpy(packed_pk.owf_input().data(), packed_sk.owf_input().data(),
               packed_sk.owf_input().size());
        memcpy(packed_pk.owf_output().data(), output.data(), output.size() * sizeof(output[0]));

        return true;
    }
}

} // namespace faest

#endif
