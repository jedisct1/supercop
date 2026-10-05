#ifndef VOLE_COMMIT_INC
#define VOLE_COMMIT_INC

#include "vole_commit.hpp"

#include "crt_constants.hpp"
#include "crt_vole_helpers.inc"
#include "gfsmall.hpp"
#include "hash.hpp"
#include "prgs.hpp"
#include "small_vole.hpp"
#include "transpose_secpar.hpp"
#include "util.hpp"
#include "vector_com.inc"

#include <cstdlib>
#include <vector>

#include "debug.hpp"
#include <iostream>

namespace faest
{

namespace detail
{

template <secpar S>
static void hash_hashed_leaves_all_same_size(hash_state* __restrict__ hasher,
                                             const unsigned char* __restrict__ hashed_leaves,
                                             size_t num_trees, size_t leaves_total_size)
{
    for (size_t i = 0; (i + 4) <= num_trees; i += 4)
    {
        const void* to_hash[4];
        for (size_t j = 0; j < 4; ++j, hashed_leaves += leaves_total_size)
            to_hash[j] = hashed_leaves;

        block_2secpar<S> leaves_hashes[4];
        hash_state_x4 leaves_hasher;
        leaves_hasher.init(S);
        leaves_hasher.update(to_hash, leaves_total_size);
        leaves_hasher.update_1_byte(1);
        leaves_hasher.finalize_4(&leaves_hashes[0], &leaves_hashes[1], &leaves_hashes[2],
                                 &leaves_hashes[3], sizeof(leaves_hashes[0]));

        hasher->update(&leaves_hashes[0], sizeof(leaves_hashes));
    }

    for (size_t i = num_trees - (num_trees % 4); i < num_trees;
         ++i, hashed_leaves += leaves_total_size)
    {
        block_2secpar<S> leaves_hash;
        hash_state leaves_hasher;
        leaves_hasher.init(S);
        leaves_hasher.update(hashed_leaves, leaves_total_size);
        leaves_hasher.update_byte(1);
        leaves_hasher.finalize(&leaves_hash, sizeof(leaves_hash));

        hasher->update(&leaves_hash, sizeof(leaves_hash));
    }
}

template <typename P>
static void hash_hashed_leaves(const unsigned char* __restrict__ hashed_leaves,
                               uint8_t* __restrict__ hash_of_hashes)
{
    using CP = P::CONSTS;
    using VC = P::CONSTS::VEC_COM;

    hash_state hasher;
    hasher.init(P::secpar_v);
    hash_hashed_leaves_all_same_size<P::secpar_v>(&hasher, hashed_leaves, VC::NUM_MAX_K,
                                                  P::leaf_hash_t::hash_len << VC::MAX_K);
    hash_hashed_leaves_all_same_size<P::secpar_v>(
        &hasher, hashed_leaves + P::leaf_hash_t::hash_len * ((size_t)VC::NUM_MAX_K << VC::MAX_K),
        VC::NUM_MIN_K, P::leaf_hash_t::hash_len << VC::MIN_K);
    hasher.update_byte(1);
    hasher.finalize(hash_of_hashes, CP::VOLE_COMMIT_CHECK_SIZE);
}

template <typename P>
void vole_commit_impl(block_secpar<P::secpar_v> seed, block128 iv,
                      block_secpar<P::secpar_v>* __restrict__ forest,
                      unsigned char* __restrict__ hashed_leaves, vole_block* __restrict__ u,
                      vole_block* __restrict__ v, uint8_t* __restrict__ commitment,
                      uint8_t* __restrict__ check, uint8_t* __restrict__ u_extra)
{
    using CP = P::CONSTS;
    using VC = P::CONSTS::VEC_COM;
    constexpr auto S = P::secpar_v;
    FAEST_ASSERT((CP::VOLE_EXTRA_BYTES > 0) || (u_extra == nullptr));
    FAEST_ASSERT((u_extra != nullptr) || (CP::VOLE_EXTRA_BYTES == 0));

    block_secpar<P::secpar_v>* leaves = reinterpret_cast<block_secpar<P::secpar_v>*>(aligned_alloc(
        alignof(block_secpar<S>), P::bavc_t::COMMIT_LEAVES * sizeof(block_secpar<S>)));
    P::bavc_t::commit(seed, iv, forest, leaves, hashed_leaves);

    hash_hashed_leaves<P>(hashed_leaves, check);

    std::array<vole_block, CP::VOLE_COL_BLOCKS> correction;
    block_secpar<S>* leaves_iter = leaves;
    for (size_t i = 0; i < P::tau_v; ++i)
    {
        unsigned int k = i < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K;
        auto tweak = ((typename P::vole_prg_t::tweak_t)1 << 31) + i;
        if (!i)
            vole_sender<P>(k, leaves_iter, iv, tweak, NULL, v, u);
        else
        {
            vole_sender<P>(k, leaves_iter, iv, tweak, u, v, correction.data());
            memcpy(commitment, correction.data(), CP::VOLE_CORRECTION_BYTES);
            if constexpr (CP::VOLE_EXTRA_BYTES > 0)
            {
                memcpy(u_extra,
                       reinterpret_cast<const uint8_t*>(correction.data()) +
                           CP::VOLE_CORRECTION_BYTES,
                       CP::VOLE_EXTRA_BYTES);
                u_extra += CP::VOLE_EXTRA_BYTES;
            }
            commitment += CP::VOLE_CORRECTION_BYTES;
        }

        leaves_iter += (size_t)1 << k;
        v += CP::VOLE_COL_BLOCKS * k;
    }

    if constexpr (P::zero_bits_in_delta_v > 0)
    {
        // Clear unused VOLE columns (corresponding to 0 bits of Delta).
        memset(v, 0, CP::VOLE_COL_BLOCKS * P::zero_bits_in_delta_v * sizeof(*v));
    }

    free(leaves);
}

template <typename P>
bool vole_reconstruct_impl(block128 iv, vole_block* __restrict__ q, const uint8_t* delta_bytes,
                           const uint8_t* __restrict__ commitment,
                           const uint8_t* __restrict__ opening, uint8_t* __restrict__ check)
{
    using CP = P::CONSTS;
    using VC = P::CONSTS::VEC_COM;
    constexpr auto S = P::secpar_v;

    block_secpar<S>* leaves = reinterpret_cast<block_secpar<S>*>(aligned_alloc(
        alignof(block_secpar<S>), P::bavc_t::COMMIT_LEAVES * sizeof(block_secpar<S>)));
    unsigned char* hashed_leaves = reinterpret_cast<unsigned char*>(aligned_alloc(
        alignof(block_2secpar<S>), P::bavc_t::COMMIT_LEAVES * P::leaf_hash_t::hash_len));

    if (!P::bavc_t::verify(iv, opening, delta_bytes, leaves, hashed_leaves))
    {
        free(leaves);
        free(hashed_leaves);
        return false;
    }
    hash_hashed_leaves<P>(hashed_leaves, check);

    std::array<vole_block, CP::VOLE_CORRECTION_BLOCKS> correction;
    // Zero the last block, if not full.
    if (CP::VOLE_CORRECTION_BLOCKS * sizeof(vole_block) != CP::VOLE_CORRECTION_BYTES)
        correction[CP::VOLE_CORRECTION_BLOCKS - 1] = vole_block::set_zero();

    block_secpar<S>* leaves_iter = leaves;
    for (size_t i = 0; i < P::tau_v; ++i)
    {
        unsigned int k = i < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K;
        auto tweak = ((typename P::vole_prg_t::tweak_t)1 << 31) + i;
        if (!i)
            vole_receiver<P>(k, leaves_iter, iv, tweak, NULL, q, delta_bytes);
        else
        {
            memcpy(correction.data(), commitment, CP::VOLE_CORRECTION_BYTES);
            commitment += CP::VOLE_CORRECTION_BYTES;
            vole_receiver<P>(k, leaves_iter, iv, tweak, correction.data(), q, delta_bytes);
        }

        leaves_iter += (size_t)1 << k;
        q += CP::VOLE_COL_BLOCKS * k;
        delta_bytes += k;
    }

    if constexpr (P::zero_bits_in_delta_v > 0)
    {
        // Clear unused VOLE columns (corresponding to 0 bits of Delta).
        memset(q, 0, CP::VOLE_COL_BLOCKS * P::zero_bits_in_delta_v * sizeof(*q));
    }

    free(hashed_leaves);
    free(leaves);
    return true;
}

template <typename P>
    requires(P::use_crt_vole_masks)
void extract_u_low(const vole_block* __restrict__ u, const uint8_t* __restrict__ u_extra,
                   block_secpar<P::secpar_v>* __restrict__ u_low)
{
    using CP = P::CONSTS;
    using VC = P::CONSTS::VEC_COM;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;
    memset(u_low, 0x00, N_MASK * sizeof(u_low[0]));
    const uint8_t* src = nullptr;
    size_t dst_offset = 0;
    for (size_t i = 0; i < P::tau_v; ++i)
    {
        if (i == 0)
            src = reinterpret_cast<const uint8_t*>(u) + CP::VOLE_CORRECTION_BYTES;
        else
            src = u_extra + (i - 1) * CP::VOLE_EXTRA_BYTES;
        if (i < VC::NUM_MAX_K)
        {
            for (size_t m = 0; m < N_MASK; ++m)
            {
                const auto bits = extract_bits<VC::MAX_K>(src, m * VC::MAX_USED_K);
                insert_bits<VC::MAX_K>(reinterpret_cast<uint8_t*>(&u_low[m]), dst_offset, bits);
            }
            dst_offset += VC::MAX_K;
        }
        else
        {
            for (size_t m = 0; m < N_MASK; ++m)
            {
                const auto bits = extract_bits<VC::MIN_K>(src, m * VC::MAX_USED_K);
                insert_bits<VC::MIN_K>(reinterpret_cast<uint8_t*>(&u_low[m]), dst_offset, bits);
            }
            dst_offset += VC::MIN_K;
        }
    }
}

template <typename P>
    requires(P::use_crt_vole_masks)
void gen_u_hi(block_secpar<P::secpar_v> seed, block128 iv,
              block_secpar<P::secpar_v>* __restrict__ u_mask)
{
    using CP = P::CONSTS;
    using CRT_C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    constexpr auto S = P::secpar_v;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;
    constexpr uint32_t tweak = (uint32_t{1} << 31) - 1;
    constexpr uint32_t counter = 0;
    constexpr size_t NUM_PRG_BLOCKS = (P::zero_bits_in_delta_v * N_MASK + 127) / 128;

    const auto m_tree = poly_secpar<S>::load(CRT_C::M_TREE.data());
    std::array<block128, NUM_PRG_BLOCKS> prg_output;
    // vole_prg_t or tree_prg_t? (is the same for our instantiations)
    static_assert(std::is_same_v<block128, typename P::vole_prg_t::block_t>);
    typename P::vole_prg_t::expanded_key_t expanded_key;
    P::vole_prg_t::template init<NUM_PRG_BLOCKS>(&seed, expanded_key, iv, tweak, counter,
                                                 prg_output.data());
#pragma GCC unroll(10)
    for (size_t m = 0; m < N_MASK; ++m)
    {
        const auto u_hi_m = extract_bits<P::zero_bits_in_delta_v>(
            reinterpret_cast<const uint8_t*>(prg_output.data()), m * P::zero_bits_in_delta_v);
        const auto m_tree_x_u_hi =
            (poly64::load(&u_hi_m) * m_tree).template reduce_to<P::secpar_bits>();
        block_secpar<S> tmp;
        m_tree_x_u_hi.store(&tmp);
        u_mask[m] = u_mask[m] ^ tmp;
    }
}

template <typename P>
    requires(P::use_crt_vole_masks)
void compute_u_mask(block_secpar<P::secpar_v> seed, block128 iv, const vole_block* __restrict__ u,
                    const uint8_t* __restrict__ u_extra,
                    block_secpar<P::secpar_v>* __restrict__ u_mask)
{
    using CP = P::CONSTS;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;

    // compute u_low
    extract_u_low<P>(u, u_extra, u_mask);
    // compute first half of u_bar (applying W_crt to u_low)
#pragma GCC unroll(10)
    for (size_t m = 0; m < N_MASK; ++m)
        u_mask[m] = crt_lift_row<P>(u_mask[m]);
    // compute u_hi, multiply with M_tree, and xor into u_mask
    gen_u_hi<P>(seed, iv, u_mask);
}

template <typename P>
    requires(P::use_crt_vole_masks)
void compute_r_tilde(const block_secpar<P::secpar_v>* __restrict__ vq,
                     block_secpar<P::secpar_v>* r_tilde)
{
    using CP = P::CONSTS;
    using VC = P::CONSTS::VEC_COM;
    using CRT_C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    constexpr auto S = P::secpar_v;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;
    memset(r_tilde, 0x00, N_MASK * sizeof(r_tilde[0]));
    const block_secpar<S>* src = vq + CP::VOLE_CORRECTION_ROWS;
    for (size_t m = 0; m < N_MASK; ++m)
    {
        size_t bit_offset = 0;
        for (size_t i = 0; i < P::tau_v; ++i)
        {
            uint64_t r_tilde_m_i = 0;
            if (i < VC::NUM_MAX_K)
            {
                for (size_t t = 0; t < VC::MAX_K; ++t)
                {
                    const auto bits = extract_bits<VC::MAX_K>(
                        reinterpret_cast<const uint8_t*>(&src[t]), bit_offset);
                    r_tilde_m_i ^= bits << t;
                }
                r_tilde_m_i = barret_reduce_64_with_x64divq(r_tilde_m_i, CRT_C::M_i[i],
                                                            CRT_C::DIV_X64_by_M_i[i]);

                insert_bits<VC::MAX_K>(reinterpret_cast<uint8_t*>(&r_tilde[m]), bit_offset,
                                       r_tilde_m_i);
                bit_offset += VC::MAX_K;
            }
            else
            {
                for (size_t t = 0; t < VC::MIN_K; ++t)
                {
                    const auto bits = extract_bits<VC::MIN_K>(
                        reinterpret_cast<const uint8_t*>(&src[t]), bit_offset);
                    r_tilde_m_i ^= bits << t;
                }
                r_tilde_m_i = barret_reduce_64_with_x64divq(r_tilde_m_i, CRT_C::M_i[i],
                                                            CRT_C::DIV_X64_by_M_i[i]);

                insert_bits<VC::MIN_K>(reinterpret_cast<uint8_t*>(&r_tilde[m]), bit_offset,
                                       r_tilde_m_i);
                bit_offset += VC::MIN_K;
            }
        }
        src += VC::MAX_USED_K;
    }
}

template <typename P> constexpr auto PADDED_N_MULT = ((P::CONSTS::CRT_NUM_MULT + 15) / 16) * 16;

template <typename P, bool VERIFIER>
    requires(P::use_crt_vole_masks)
void lift_and_hash_vq(
    block128 iv, const vole_block* __restrict__ vq_columns,
    std::conditional_t<VERIFIER, std::monostate, const vole_block* __restrict__> u,
    std::span<uint16_t, P::CONSTS::CRT_NUM_MULT> hashes_0,
    std::conditional_t<VERIFIER, std::monostate, std::span<uint16_t, P::CONSTS::CRT_NUM_MULT>>
        hashes_1)
{
    using CP = P::CONSTS;
    constexpr auto S = P::secpar_v;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;
    constexpr auto N_MULT = CP::CRT_NUM_MULT;
    static_assert(N_MULT != 0);
    static_assert(N_MASK != 0);
    static_assert(N_MASK <= 16, "We assume that a hash fits into 16 bits.");
    // NB: The hash outputs 16 bits instead of N_MASK. The extra bits could be masked, but they will
    // be ignored anyway.

    if constexpr (!VERIFIER)
        FAEST_ASSERT(u != nullptr);

    [[maybe_unused]] block_secpar<S> u_prefix;
    std::array<block_secpar<S>, 4> L1;
    if constexpr (!VERIFIER)
        u_prefix = block_secpar<S>::load(u);

    std::array<block_secpar<S>, N_MULT> L0;

    // multiply v or q prefix with G
    G_lift_a<P>(L0.data(), vq_columns, CP::VOLE_COL_BLOCKS);

    // hash the resulting matrix column-wise
    hash_state_x4 hasher, hasher_copy;
    hasher.init(S);
    hasher.update_1(&iv, sizeof(iv));
    std::array<uint32_t, 4> counters = {0, 1, 2, 3};
    constexpr auto FULL_ITERATIONS = N_MULT / 4;
    constexpr auto LAST_ITERATIONS = N_MULT % 4;
    constexpr auto END_FULL_ITERATIONS = 4 * FULL_ITERATIONS;
    for (uint32_t e = 0; e < END_FULL_ITERATIONS; e += 4)
    {
        memcpy(&hasher_copy, &hasher, sizeof(hasher_copy));
        hasher_copy.update_4(&counters[0], &counters[1], &counters[2], &counters[3],
                             sizeof(counters[0]));
        hasher_copy.update_4(&L0[e], &L0[e + 1], &L0[e + 2], &L0[e + 3], sizeof(L0[0]));
        hasher_copy.update_1_byte(5);
        hasher_copy.finalize_4(&hashes_0[e], &hashes_0[e + 1], &hashes_0[e + 2], &hashes_0[e + 3],
                               sizeof(hashes_0[0]));
        if constexpr (!VERIFIER)
        {
#pragma GCC unroll(4)
            for (size_t i = 0; i < 4; ++i)
            {
                L1[i] = u_prefix ^ L0[e + i];
            }
            memcpy(&hasher_copy, &hasher, sizeof(hasher_copy));
            hasher_copy.update_4(&counters[0], &counters[1], &counters[2], &counters[3],
                                 sizeof(counters[0]));
            hasher_copy.update_4(&L1[0], &L1[1], &L1[2], &L1[3], sizeof(L1[0]));
            hasher_copy.update_1_byte(5);
            hasher_copy.finalize_4(&hashes_1[e], &hashes_1[e + 1], &hashes_1[e + 2],
                                   &hashes_1[e + 3], sizeof(hashes_1[0]));
        }
#pragma GCC unroll(4)
        for (size_t i = 0; i < 4; ++i)
        {
            counters[i] += 4;
        }
    }
    if constexpr (LAST_ITERATIONS > 0)
    {
        hash_state hasher, hasher_copy;
        hasher.init(S);
        hasher.update(&iv, sizeof(iv));
        for (uint32_t e = 0; e < LAST_ITERATIONS; e += 1)
        {
            memcpy(&hasher_copy, &hasher, sizeof(hasher_copy));
            hasher_copy.update(&counters[e], sizeof(counters[0]));
            hasher_copy.update(&L0[END_FULL_ITERATIONS + e], sizeof(L0[0]));
            hasher_copy.update_byte(5);
            hasher_copy.finalize(&hashes_0[END_FULL_ITERATIONS + e], sizeof(hashes_0[0]));
            if constexpr (!VERIFIER)
            {
                L1[0] = u_prefix ^ L0[END_FULL_ITERATIONS + e];
                memcpy(&hasher_copy, &hasher, sizeof(hasher_copy));
                hasher_copy.update(&counters[e], sizeof(counters[0]));
                hasher_copy.update(&L1[0], sizeof(L1[0]));
                hasher_copy.update_byte(5);
                hasher_copy.finalize(&hashes_1[END_FULL_ITERATIONS + e], sizeof(hashes_1[0]));
            }
        }
    }
}

template <typename P>
    requires(P::use_crt_vole_masks)
void compute_v_gate(const block_secpar<P::secpar_v>* __restrict__ u_mask,
                    std::span<uint16_t, P::CONSTS::CRT_NUM_MULT> hashes_0,
                    std::span<uint16_t, PADDED_N_MULT<P>> hashes_1,
                    block_secpar<P::secpar_v>* __restrict__ v_mask, uint8_t* __restrict__ c_mult)
{
    using CP = P::CONSTS;
    constexpr auto S = P::secpar_v;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;
    constexpr auto N_MULT = CP::CRT_NUM_MULT;
    static_assert(N_MASK != 0);
    static_assert(N_MULT != 0);
    constexpr auto N_MULT_BYTES = (N_MULT + 7) / 8;
    constexpr auto PADDED_N_MULT = ((N_MULT + 15) / 16) * 16;
    constexpr auto PADDED_N_MULT_BYTES = (PADDED_N_MULT + 7) / 8;

    // lift v_tilde with W_GATE
    std::array<uint16_t, P::secpar_bits> lifted_v_tilde{};
    gate_lift<P>(lifted_v_tilde.data(), hashes_0.data());
    // transpose
    std::array<block_secpar<S>, 16> transposed_lifted_v_tilde;
    transpose_16Nx16(reinterpret_cast<uint8_t*>(transposed_lifted_v_tilde.data()),
                     reinterpret_cast<const uint8_t*>(lifted_v_tilde.data()), P::secpar_bits / 16);
    // xor into v_mask
    for (size_t m = 0; m < N_MASK; ++m)
        v_mask[m] = v_mask[m] ^ transposed_lifted_v_tilde[m];

    // for c_mult:
    for (size_t e = 0; e < N_MULT; ++e)
        hashes_1[e] ^= hashes_0[e];
    std::array<uint8_t, 2 * PADDED_N_MULT> transposed_xored_hs{};
    // transpose
    transpose_16Nx16(transposed_xored_hs.data(), reinterpret_cast<const uint8_t*>(hashes_1.data()),
                     PADDED_N_MULT / 16);

    // - apply F to u_mask and xor into the above
    for (size_t m = 0; m < N_MASK; ++m)
    {
        F_lift_row_xor<P>(&transposed_xored_hs[m * PADDED_N_MULT_BYTES], u_mask[m]);
        memcpy(c_mult + m * N_MULT_BYTES, &transposed_xored_hs[m * PADDED_N_MULT_BYTES],
               N_MULT_BYTES);
    }
}

template <typename P>
    requires(P::use_crt_vole_masks)
void compute_v_mask_and_c_mult(const block_secpar<P::secpar_v>* __restrict__ v,
                               const block_secpar<P::secpar_v>* __restrict__ u_mask,
                               std::span<uint16_t, P::CONSTS::CRT_NUM_MULT> hashes_0,
                               std::span<uint16_t, PADDED_N_MULT<P>> hashes_1,
                               block_secpar<P::secpar_v>* __restrict__ v_mask,
                               uint8_t* __restrict__ c_mult)
{
    using CP = P::CONSTS;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;

    // compute r_tilde
    detail::compute_r_tilde<P>(v, v_mask);
    // compute first half of v_bar (applying W_tree to r_tilde)
    for (size_t m = 0; m < N_MASK; ++m)
        v_mask[m] = tree_lift_row<P>(v_mask[m]);
    // compute and second half of v_bar (applied W_gate to v_tilde) and xor into v_mask
    detail::compute_v_gate<P>(u_mask, hashes_0, hashes_1, v_mask, c_mult);
}

template <typename P>
    requires(P::use_crt_vole_masks)
void compute_q_gate(std::span<uint16_t, PADDED_N_MULT<P>> hashes, block_secpar<P::secpar_v> delta,
                    const uint8_t* __restrict__ c_mult, block_secpar<P::secpar_v>* q_mask)
{
    using CP = P::CONSTS;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;
    constexpr auto N_MULT = CP::CRT_NUM_MULT;
    constexpr auto N_MULT_BYTES = (N_MULT + 7) / 8;
    constexpr auto PADDED_N_MULT = ((N_MULT + 15) / 16) * 16;
    constexpr auto PADDED_N_MULT_BYTES = (PADDED_N_MULT + 7) / 8;
    static_assert(N_MASK != 0);
    static_assert(N_MULT != 0);

    std::array<uint8_t, N_MULT_BYTES> gamma{};
    G_lift_row_xor<P>(gamma.data(), delta);

    // transpose
    std::array<uint8_t, 2 * PADDED_N_MULT> transposed_hs;
    transpose_16Nx16(reinterpret_cast<uint8_t*>(transposed_hs.data()),
                     reinterpret_cast<const uint8_t*>(hashes.data()), PADDED_N_MULT / 16);
    for (size_t m = 0; m < N_MASK; ++m)
        for (size_t i = 0; i < N_MULT_BYTES; ++i)
            transposed_hs[m * PADDED_N_MULT_BYTES + i] ^= (gamma[i] & c_mult[m * N_MULT_BYTES + i]);

    // apply w_GATE and xor into q_mask
    for (size_t m = 0; m < N_MASK; ++m)
        q_mask[m] = q_mask[m] ^ gate_lift_public_row<P>(&transposed_hs[m * PADDED_N_MULT_BYTES]);
}

template <typename P>
    requires(P::use_crt_vole_masks)
void compute_q_mask(std::span<uint16_t, PADDED_N_MULT<P>> hashes, block_secpar<P::secpar_v> delta,
                    const block_secpar<P::secpar_v>* __restrict__ q,
                    const uint8_t* __restrict__ c_mult,
                    block_secpar<P::secpar_v>* __restrict__ q_mask)
{
    using CP = P::CONSTS;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;

    // compute r_tilde
    detail::compute_r_tilde<P>(q, q_mask);
    // compute first half of q_bar (applying W_tree to r_tilde)
    for (size_t m = 0; m < N_MASK; ++m)
        q_mask[m] = tree_lift_public_row<P>(q_mask[m]);
    // compute and second half of q_bar (applied W_gate to q_tilde) and xor into q_mask
    detail::compute_q_gate<P>(hashes, delta, c_mult, q_mask);
}

} // namespace detail

template <typename P>
void vole_commit(block_secpar<P::secpar_v> seed, block128 iv,
                 const vole_commit_data<P, false>& data,
                 std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
                 std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check)
{
    detail::vole_commit_impl<P>(seed, iv, data.forest().data(), data.hashed_leaves().data(),
                                data.u().data(), data.v_columns().data(), commitment.data(),
                                check.data(), nullptr);
}

template <typename P>
bool vole_reconstruct(block128 iv, const vole_commit_data<P, true>& data,
                      const uint8_t* delta_bytes,
                      std::span<const uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
                      std::span<const uint8_t, P::bavc_t::OPEN_SIZE> opening,
                      std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check)
{
    return detail::vole_reconstruct_impl<P>(iv, data.q_columns().data(), delta_bytes,
                                            commitment.data(), opening.data(), check.data());
}

template <typename P>
    requires(P::use_crt_vole_masks)
void crt_vole_commit(block_secpar<P::secpar_v> seed, block128 iv,
                     const vole_commit_data<P, false>& data,
                     std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
                     std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check,
                     std::span<uint8_t, P::CONSTS::CRT_CMULT_SIZE_BYTES> c_mult)
{
    using CP = P::CONSTS;
    constexpr auto S = P::secpar_v;
    constexpr auto N_MASK = CP::CRT_NUM_MASK;
    constexpr auto N_MULT = CP::CRT_NUM_MULT;
    constexpr auto PADDED_N_MULT = ((N_MULT + 15) / 16) * 16;
    static_assert(N_MASK != 0);
    static_assert(N_MULT != 0);

    std::array<uint8_t, P::delta_bits_v * CP::VOLE_EXTRA_BYTES> u_extra;

    // standard VOLECommit
    detail::vole_commit_impl<P>(seed, iv, data.forest().data(), data.hashed_leaves().data(),
                                data.u().data(), data.v_columns().data(), commitment.data(),
                                check.data(), u_extra.data());

    std::array<uint16_t, N_MULT> hashes_0;
    std::array<uint16_t, PADDED_N_MULT> hashes_1{};
    detail::lift_and_hash_vq<P, false>(iv, data.v_columns().data(), data.u().data(), hashes_0,
                                       std::span(hashes_1).template subspan<0, N_MULT>());

    // apply CRT lift to V
    crt_lift_v<P>(data.v_columns().data(), CP::VOLE_COL_BLOCKS, CP::VOLE_CORRECTION_BYTES);

    // transpose V from columns to rows
    static_assert(CP::VOLE_ROWS_PADDED % TRANSPOSE_BITS_ROWS == 0, "");
    transpose_secpar<S>(data.v_columns().data(), data.v().data(), CP::VOLE_COL_STRIDE,
                        CP::VOLE_ROWS_PADDED);

    detail::compute_u_mask<P>(seed, iv, data.u().data(), u_extra.data(), data.u_mask().data());
    detail::compute_v_mask_and_c_mult<P>(data.v().data(), data.u_mask().data(), hashes_0, hashes_1,
                                         data.v_mask().data(), c_mult.data());
}

template <typename P>
    requires(P::use_crt_vole_masks)
bool crt_vole_reconstruct(
    block128 iv, const vole_commit_data<P, true>& data, block_secpar<P::secpar_v> delta,
    std::span<const uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
    std::span<const uint8_t, P::bavc_t::OPEN_SIZE> opening,
    std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check,
    std::span<const uint8_t, P::CONSTS::CRT_CMULT_SIZE_BYTES> c_mult)
{
    using CP = P::CONSTS;
    constexpr auto S = P::secpar_v;
    constexpr auto N_MULT = CP::CRT_NUM_MULT;
    constexpr auto PADDED_N_MULT = ((N_MULT + 15) / 16) * 16;

    std::array<uint8_t, P::delta_bits_v> delta_bytes{};
    expand_bits_to_bytes(delta_bytes.data(), P::delta_bits_v,
                         reinterpret_cast<const uint8_t*>(&delta));

    // standard VOLEReconstruct
    bool success = vole_reconstruct<P>(iv, data, delta_bytes.data(), commitment, opening, check);
    if (!success)
        return false;

    std::array<uint16_t, PADDED_N_MULT> hashes{};
    detail::lift_and_hash_vq<P, true>(iv, data.q_columns().data(), std::monostate{},
                                      std::span(hashes).template subspan<0, N_MULT>(),
                                      std::monostate{});
    crt_lift_q<P>(data.q_columns().data(), CP::VOLE_COL_BLOCKS, CP::VOLE_CORRECTION_BYTES);

    // transpose V from columns to rows
    static_assert(CP::VOLE_ROWS_PADDED % TRANSPOSE_BITS_ROWS == 0, "");
    transpose_secpar<S>(data.q_columns().data(), data.q().data(), CP::VOLE_COL_STRIDE,
                        CP::VOLE_ROWS_PADDED);

    detail::compute_q_mask<P>(hashes, delta, data.q().data(), c_mult.data(), data.q_mask().data());

    return true;
}

} // namespace faest

#endif
