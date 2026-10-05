#ifndef KOS_VOLE_CHECK_HPP
#define KOS_VOLE_CHECK_HPP

#include "constants.hpp"
#include "hash.hpp"
#include "parameters.hpp"
#include "polynomials.hpp"
#include "universal_hash.hpp"

#include <span>

namespace faest
{

namespace detail
{

template <secpar S> struct kos_vole_check_challenge
{
    constexpr static size_t CHALLENGE_BYTES = 8 * secpar_to_bytes(S) + 8;
    std::array<poly_secpar<S>, 4> matrix;

    std::array<poly_secpar<S>, 4> keys;
    poly64 key_4;

    std::array<typename uhasher_gfsecpar<S>::prep_key_t, 4> hasher_keys;
    typename uhasher_gfsecpar_64<S>::prep_key_t hasher_key_4;

    static kos_vole_check_challenge<S> load(std::span<const uint8_t, CHALLENGE_BYTES> sd)
    {
        const auto* in = sd.data();
        kos_vole_check_challenge<S> out;
        for (size_t i = 0; i < 4; ++i, in += secpar_to_bytes(S))
            out.matrix[i] = poly_secpar<S>::load(in);

        for (size_t i = 0; i < 4; ++i, in += secpar_to_bytes(S))
            out.keys[i] = poly_secpar<S>::load(in);
        out.key_4 = poly64::load(in);

        for (size_t i = 0; i < 4; ++i)
            out.hasher_keys[i] = uhasher_gfsecpar<S>::preprocess_key(out.keys[i]);
        out.hasher_key_4 = uhasher_gfsecpar_64<S>::preprocess_key(out.key_4);

        return out;
    }

  private:
    kos_vole_check_challenge() = default;
};

// - combine the universal hashes
template <secpar S>
ALWAYS_INLINE static void combine_hashes(const kos_vole_check_challenge<S>& chall,
                                         const block_secpar<S>* __restrict__ vole_hash_mask,
                                         std::span<uhasher_gfsecpar<S>, 4> states,
                                         uhasher_gfsecpar_64<S>& state_4,
                                         std::span<poly_secpar<S>, 4> h)
{
    for (size_t i = 0; i < 3; ++i)
        h[i] = poly_secpar<S>::from_block(vole_hash_mask[i]) + states[i + 1].finalize();
    h[3] = poly_secpar<S>::from_block(vole_hash_mask[3]) + state_4.finalize();
    const auto y0 = states[0].finalize();
    for (size_t i = 0; i < 4; ++i)
        h[i] += (y0 * chall.matrix[i]).template reduce_to<secpar_to_bits(S)>();
}

template <secpar S>
ALWAYS_INLINE static void hash_mask(size_t n_hash_extra, const kos_vole_check_challenge<S>& chall,
                                    const block_secpar<S>* __restrict__ mask,
                                    std::span<uhasher_gfsecpar<S>, 4> states,
                                    uhasher_gfsecpar_64<S>& state_4)
{
    // - hash the rows of {u,v,q}_mask not used for the VOLE check
    for (size_t i = 0; i < n_hash_extra; ++i)
    {
        const auto p = poly_secpar<S>::from_block(mask[i]);
        for (size_t j = 0; j < 4; ++j)
            states[j].update(chall.hasher_keys[j], p);
        state_4.update(chall.hasher_key_4, p);
    }
}

template <secpar S>
static void
kos_vole_check_both(bool verifier, size_t n_hash, size_t n_hash_extra,
                    const uint8_t* __restrict__ u, const block_secpar<S>* __restrict__ vq,
                    const block_secpar<S>* __restrict__ u_mask,
                    const block_secpar<S>* __restrict__ vq_mask, const block_secpar<S> delta,
                    const uint8_t* __restrict__ challenge, uint8_t* __restrict__ proof_out,
                    const uint8_t* __restrict__ proof_in, hash_state& hasher)
{
    using VOLE_CHECK_CONSTS = VOLE_CHECK_CONSTANTS<S, true>;
    // using CP = P::CONSTS;
    const auto chall = kos_vole_check_challenge<S>::load(
        std::span<const uint8_t, kos_vole_check_challenge<S>::CHALLENGE_BYTES>(
            challenge, kos_vole_check_challenge<S>::CHALLENGE_BYTES));
    const auto L = n_hash + n_hash_extra;

    FAEST_ASSERT(!verifier || ((proof_out == nullptr) && (proof_in != nullptr)));
    FAEST_ASSERT(verifier || ((proof_out != nullptr) && (proof_in == nullptr)));

    std::array<uhasher_gfsecpar<S>, 4> states;
    uhasher_gfsecpar_64<S> state_4;
    if (verifier)
    {
        // Hash received proof
        hasher.update(proof_in, VOLE_CHECK_CONSTS::PROOF_BYTES);
    }
    else
    {
        // Apply VOLEHash to u
        // - initialize the hashers
        for (size_t j = 0; j < 4; ++j)
            states[j].init(L);
        state_4.init(L);

        // - hash the rows of u
        FAEST_ASSERT(n_hash % 8 == 0);
        const auto n_hash_bytes = n_hash / 8;
        for (size_t i = 0; i < n_hash_bytes; ++i)
        {
            for (size_t j = 0; j < 4; ++j)
                states[j].update_byte(chall.hasher_keys[j], u[i]);
            state_4.update_byte(chall.hasher_key_4, u[i]);
        }

        hash_mask<S>(n_hash_extra, chall, u_mask, states, state_4);
        std::array<poly_secpar<S>, 4> h;
        combine_hashes<S>(chall, u_mask + n_hash_extra, states, state_4, h);

        // - write the VOLEHash into the proof
        for (size_t i = 0; i < 4; ++i)
        {
            const auto tmp = h[i].to_block();
            memcpy(proof_out + i * secpar_to_bytes(S), &tmp, sizeof(tmp));
        }
        // - hash the VOLEHash
        hasher.update(proof_out, VOLE_CHECK_CONSTS::PROOF_BYTES);
    }

    // Apply VOLEHash to V/Q
    {
        // - initialize the hashers
        for (size_t j = 0; j < 4; ++j)
            states[j].init(L);
        state_4.init(L);

        // - hash the rows of V/Q
        for (size_t i = 0; i < n_hash; ++i)
        {
            const auto p = poly_secpar<S>::from_block(vq[i]);
            for (size_t j = 0; j < 4; ++j)
                states[j].update(chall.hasher_keys[j], p);
            state_4.update(chall.hasher_key_4, p);
        }

        hash_mask<S>(n_hash_extra, chall, vq_mask, states, state_4);
        std::array<poly_secpar<S>, 4> h;
        combine_hashes<S>(chall, vq_mask + n_hash_extra, states, state_4, h);

        if (verifier)
        {
            // - correct the VOLEHash with Delta
            const auto delta_p = poly_secpar<S>::from_block(delta);
            for (size_t i = 0; i < 4; ++i)
            {
                const auto u_hash_i = poly_secpar<S>::load(proof_in + i * secpar_to_bytes(S));
                h[i] += (delta_p * u_hash_i).template reduce_to<secpar_to_bits(S)>();
            }
        }

        // - hash the VOLEHash
        for (size_t i = 0; i < 4; ++i)
        {
            const auto tmp = h[i].to_block();
            hasher.update(&tmp, sizeof(tmp));
        }
    }
}

} // namespace detail

template <typename P>
    requires(P::use_crt_vole_masks)
ALWAYS_INLINE void
kos_vole_check_sender(std::span<const uint8_t, P::CONSTS::VOLE_CORRECTION_BYTES> u,
                      std::span<const block_secpar<P::secpar_v>, P::CONSTS::VOLE_CORRECTION_ROWS> v,
                      std::span<const block_secpar<P::secpar_v>, P::CONSTS::CRT_NUM_MASK> u_mask,
                      std::span<const block_secpar<P::secpar_v>, P::CONSTS::CRT_NUM_MASK> v_mask,
                      std::span<const uint8_t, P::CONSTS::VOLE_CHECK::CHALLENGE_BYTES> challenge,
                      std::span<uint8_t, P::CONSTS::VOLE_CHECK::PROOF_BYTES> proof,
                      hash_state& hasher)
{
    using CP = P::CONSTS;
    using OC = P::OWF_CONSTS;
    constexpr auto S = P::secpar_v;
    detail::kos_vole_check_both<S>(false, CP::VOLE_CORRECTION_ROWS, OC::QS_DEGREE - 1, u.data(),
                                   v.data(), u_mask.data(), v_mask.data(),
                                   block_secpar<S>::set_zero(), challenge.data(), proof.data(),
                                   nullptr, hasher);
}
template <typename P>
    requires(P::use_crt_vole_masks)
ALWAYS_INLINE void kos_vole_check_receiver(
    block_secpar<P::secpar_v> delta,
    std::span<const block_secpar<P::secpar_v>, P::CONSTS::VOLE_CORRECTION_ROWS> q,
    std::span<const block_secpar<P::secpar_v>, P::CONSTS::CRT_NUM_MASK> q_mask,
    std::span<const uint8_t, P::CONSTS::VOLE_CHECK::CHALLENGE_BYTES> challenge,
    std::span<const uint8_t, P::CONSTS::VOLE_CHECK::PROOF_BYTES> proof, hash_state& hasher)
{
    using CP = P::CONSTS;
    using OC = P::OWF_CONSTS;
    constexpr auto S = P::secpar_v;
    detail::kos_vole_check_both<S>(true, CP::VOLE_CORRECTION_ROWS, OC::QS_DEGREE - 1, nullptr,
                                   q.data(), nullptr, q_mask.data(), delta, challenge.data(),
                                   nullptr, proof.data(), hasher);
}

} // namespace faest

#endif
