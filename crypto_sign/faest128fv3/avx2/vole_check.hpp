#ifndef VOLE_CHECK_HPP
#define VOLE_CHECK_HPP

#include <cstdint>

#include "block.hpp"
#include "constants.hpp"
#include "hash.hpp"
#include "parameters.hpp"
#include "universal_hash.hpp"

namespace faest
{

void vole_check_sender(const vole_block* __restrict__ u, const vole_block* __restrict__ v,
                       const uint8_t* __restrict__ challenge, uint8_t* __restrict__ proof,
                       uint8_t* __restrict__ check);

void vole_check_receiver(const vole_block* __restrict__ q, const uint8_t* __restrict__ delta_bytes,
                         const uint8_t* __restrict__ challenge, const uint8_t* __restrict__ proof,
                         uint8_t* __restrict__ check);

namespace detail
{

template <secpar S> struct vole_check_challenge
{
    poly_secpar<S> matrix[4];

    poly_secpar<S> key_secpar;
    poly64 key_64;

    hasher_gfsecpar_key<S> hasher_key_secpar;
    hasher_gf64_key hasher_key_64;
};

template <secpar S> static vole_check_challenge<S> load_challenge(const uint8_t* in)
{
    vole_check_challenge<S> out;
    for (size_t i = 0; i < 4; ++i, in += secpar_to_bytes(S))
        out.matrix[i] = poly_secpar<S>::load_dup(in);

    out.key_secpar = poly_secpar<S>::load_dup(in);
    out.key_64 = poly64::load_dup(in + secpar_to_bytes(S));

    out.hasher_key_secpar.init(out.key_secpar);
    out.hasher_key_64.init(out.key_64);
    return out;
}

template <typename P>
static void
vole_check_both(bool verifier, const vole_block* __restrict__ u, const vole_block* __restrict__ vq,
                const uint8_t* __restrict__ delta_bytes, const uint8_t* __restrict__ challenge,
                uint8_t* __restrict__ proof, hash_state& hasher)
{
    using CP = CONSTANTS<P>;
    constexpr secpar S = P::secpar_v;

    vole_check_challenge chal = load_challenge<S>(challenge);

    block_secpar<S> u_hash[2] = {block_secpar<S>::set_zero(), block_secpar<S>::set_zero()};
    if (verifier)
        memcpy(&u_hash[0], proof, CP::VOLE_CHECK::HASH_BYTES);

    for (int col = -!verifier; col < static_cast<ssize_t>(P::delta_bits_v); ++col)
    {
        const uint8_t* to_hash = (const uint8_t*)(col == -1 ? u : vq + CP::VOLE_COL_BLOCKS * col);

        size_t hasher_chunk_size = P::secpar_bits;
        size_t padded_rows = ((CP::QUICKSILVER_ROWS + hasher_chunk_size - 1) / hasher_chunk_size) *
                             hasher_chunk_size;

        hasher_gfsecpar_state<S> state_secpar;
        hasher_gf64_state state_64;
        state_secpar.init(padded_rows / hasher_chunk_size);
        state_64.init(padded_rows / 64);

        size_t i = 0;

        // Apply inital padding.
        if (padded_rows - CP::QUICKSILVER_ROWS >= P::secpar_bits)
        {
            size_t extra_blocks = (padded_rows - CP::QUICKSILVER_ROWS) / P::secpar_bits;
            uint8_t first_chunk[sizeof(block_secpar<S>)];
            memset(first_chunk, 0, extra_blocks * sizeof(block_secpar<S>));
            memcpy(first_chunk + extra_blocks * sizeof(block_secpar<S>), to_hash,
                   (1 - extra_blocks) * sizeof(block_secpar<S>));

            state_secpar.update(&chal.hasher_key_secpar, poly_secpar<S>::load(first_chunk));
            for (size_t j = 0; j < hasher_chunk_size; j += 64)
                state_64.update(&chal.hasher_key_64, poly64::load(&first_chunk[j / 8]));

            i = extra_blocks * P::secpar_bits;
        }

        // TODO: Maybe better to chunk the loop by HASHER_GFSECPAR_KEY_POWS.
        for (; i + hasher_chunk_size <= CP::QUICKSILVER_ROWS; i += hasher_chunk_size)
        {
            state_secpar.update(&chal.hasher_key_secpar, poly_secpar<S>::load(to_hash + i / 8));
            for (size_t j = 0; j < hasher_chunk_size; j += 64)
                state_64.update(&chal.hasher_key_64, poly64::load(to_hash + (i + j) / 8));
        }

        FAEST_ASSERT(i == CP::QUICKSILVER_ROWS - (CP::QUICKSILVER_ROWS % P::secpar_bits));
        i = CP::QUICKSILVER_ROWS -
            (CP::QUICKSILVER_ROWS % P::secpar_bits); // Let the compiler know it's constant.

        // Apply final padding.
        if (CP::QUICKSILVER_ROWS % P::secpar_bits)
        {
            uint8_t last_chunk[sizeof(block_secpar<S>)];
            memcpy(last_chunk, to_hash + i / 8, (CP::QUICKSILVER_ROWS - i) / 8);
            memset(last_chunk + (CP::QUICKSILVER_ROWS - i) / 8, 0,
                   sizeof(last_chunk) - (CP::QUICKSILVER_ROWS - i) / 8);

            state_secpar.update(&chal.hasher_key_secpar, poly_secpar<S>::load(last_chunk));
            for (size_t j = 0; j < hasher_chunk_size; j += 64)
                state_64.update(&chal.hasher_key_64, poly64::load(&last_chunk[j / 8]));
        }

        poly_secpar<S> poly_hashes[2];
        poly_hashes[0] = gfsecpar_combine_hashes<S>(chal.key_secpar, state_secpar.finalize());
        poly_hashes[1] =
            poly_secpar<S>::from(gf64_combine_hashes(chal.key_64, state_64.finalize()));

        poly_secpar<S> mapped_hashes[2];
        for (size_t j = 0; j < 2; ++j)
            mapped_hashes[j] = ((chal.matrix[2 * j + 0] * poly_hashes[0]) +
                                (chal.matrix[2 * j + 1] * poly_hashes[1]))
                                   .template reduce_to<P::secpar_bits>();

        block_secpar<S> hash_output_storage[2];
        block_secpar<S>* hash_output = col == -1 ? u_hash : hash_output_storage;
        for (size_t j = 0; j < 2; ++j)
            mapped_hashes[j].store1(&hash_output[j]);

        // Apply the mask so that this check will hide u.
        block_secpar<S> mask[2] = {block_secpar<S>::set_zero(), block_secpar<S>::set_zero()};
        memcpy(mask, to_hash + CP::QUICKSILVER_ROWS / 8, CP::VOLE_CHECK::HASH_BYTES);
        for (size_t j = 0; j < 2; ++j)
            hash_output[j] = hash_output[j] ^ mask[j];

        if (verifier)
            for (size_t j = 0; j < 2; ++j)
                hash_output[j] =
                    hash_output[j] ^ (u_hash[j] & block_secpar<S>::set_all_8(delta_bytes[col]));

        hasher.update(&hash_output[0], CP::VOLE_CHECK::HASH_BYTES);
    }
    if constexpr (P::delta_bits_v < P::secpar_bits)
    {
        for (size_t col = P::delta_bits_v; col < P::secpar_bits; ++col)
        {
            const uint8_t* to_hash = (const uint8_t*)(vq + CP::VOLE_COL_BLOCKS * col);
            hasher.update(to_hash + CP::QUICKSILVER_ROWS / 8, CP::VOLE_CHECK::HASH_BYTES);
        }
    }

    if (!verifier)
        memcpy(proof, &u_hash[0], CP::VOLE_CHECK::HASH_BYTES);
}

} // namespace detail

template <typename P>
void vole_check_sender(const vole_block* __restrict__ u, const vole_block* __restrict__ v,
                       const uint8_t* __restrict__ challenge, uint8_t* __restrict__ proof,
                       hash_state& hasher)
{
    detail::vole_check_both<P>(false, u, v, NULL, challenge, proof, hasher);
}

template <typename P>
void vole_check_receiver(const vole_block* __restrict__ q, const uint8_t* __restrict__ delta_bytes,
                         const uint8_t* __restrict__ challenge, const uint8_t* __restrict__ proof,
                         hash_state& hasher)
{
    detail::vole_check_both<P>(true, NULL, q, delta_bytes, challenge, (uint8_t*)proof, hasher);
}

} // namespace faest

#endif
