#ifndef VECTOR_COM_INC
#define VECTOR_COM_INC

#include "vector_com.hpp"

#include <algorithm>
#include <array>
#include <bitset>
#include <cassert>
#include <climits>
#include <cstdlib>
#include <tuple>

#include "hash.hpp"
#include "parameters.hpp"
#include "prgs.hpp"
#include "util.hpp"
#include "vole_key_index_permutation.hpp"

namespace faest
{

template <typename PRG> constexpr size_t CHUNK_SIZE = PRG::PREFERRED_WIDTH / 2;
template <typename PRG> constexpr size_t CHUNK_SIZE_SHIFT = PRG::PREFERRED_WIDTH_SHIFT - 1;

template <typename PRG, secpar S = PRG::secpar_v>
static ALWAYS_INLINE void
copy_prg_output(size_t n, size_t stretch, size_t j, size_t num_blocks, size_t remaining_bytes,
                const typename PRG::block_t* prg_output, block_secpar<S>* output)
{
    size_t prg_block_size = sizeof(typename PRG::block_t);
    size_t num_bytes = std::min(remaining_bytes, num_blocks * prg_block_size);
    for (size_t k = 0; k < n; ++k)
        memcpy(((unsigned char*) &output[stretch * k]) + j * prg_block_size,
               &prg_output[num_blocks * k], num_bytes);
}

// Take each of n block_secpars from input and expand it into stretch adjacent blocks in output.
template <size_t n, size_t stretch, typename PRG, secpar S = PRG::secpar_v>
static ALWAYS_INLINE void
expand_chunk(typename PRG::iv_t iv, const typename PRG::tweak_t* tweaks,
             const block_secpar<S>* __restrict__ input, block_secpar<S>* __restrict__ output)
{
    static_assert(PRG::secpar_v == S);

    if constexpr (n > 0)
    {
        constexpr size_t prg_block_size = sizeof(typename PRG::block_t);
        constexpr size_t output_per_key = stretch * secpar_to_bytes(S);
        constexpr size_t blocks_per_key = (output_per_key + prg_block_size - 1) / prg_block_size;

        // TODO: Was this needed for optimizations?
        // constexpr size_t bytes_extra_per_key = blocks_per_key * prg_block_size - output_per_key;

        static_assert(blocks_per_key >= 2);
        constexpr size_t first_blocks = std::min(blocks_per_key, 4 - (blocks_per_key % 2));

        typename PRG::expanded_key_t expanded_keys[n];
        typename PRG::block_t prg_output[n * first_blocks];
        PRG::template init<n, first_blocks>(&input[0], &expanded_keys[0], iv, tweaks,
                                            (typename PRG::count_t) 0, &prg_output[0]);
        copy_prg_output<PRG>(n, stretch, 0, first_blocks, output_per_key, prg_output, output);

        if constexpr (first_blocks < blocks_per_key)
        {
            constexpr size_t num_blocks = 2;
            size_t remaining_bytes = output_per_key - first_blocks * prg_block_size;
            PRAGMA_UNROLL(4)
            for (size_t j = first_blocks; j < blocks_per_key;
                 j += num_blocks, remaining_bytes -= num_blocks * prg_block_size)
            {
                PRG::template gen<n, num_blocks>(&expanded_keys[0], iv, tweaks, j, &prg_output[0]);
                copy_prg_output<PRG>(n, stretch, j, num_blocks, remaining_bytes, prg_output, output);
            }
        }
    }
}

template <size_t n, size_t stretch, typename PRG, secpar S = PRG::secpar_v>
static ALWAYS_INLINE void
expand_chunk(typename PRG::iv_t iv, typename PRG::tweak_t tweak,
             const block_secpar<S>* __restrict__ input, block_secpar<S>* __restrict__ output)
{
    std::array<typename PRG::tweak_t, n> tweaks;
    tweaks.fill(tweak);
    return expand_chunk<n, stretch, PRG>(iv, tweaks.data(), input, output);
}

struct tweak_increment {};

template <size_t n, size_t stretch, typename PRG, secpar S = PRG::secpar_v>
static ALWAYS_INLINE void
expand_chunk(typename PRG::iv_t iv, typename PRG::tweak_t tweak0, tweak_increment tinc,
             const block_secpar<S>* __restrict__ input, block_secpar<S>* __restrict__ output)
{
    (void) tinc;
    std::array<typename PRG::tweak_t, n> tweaks;
    for (size_t i = 0; i < n; ++i)
        tweaks[i] = tweak0 + i;
    return expand_chunk<n, stretch, PRG>(iv, tweaks.data(), input, output);
}

template <size_t TAU, size_t DELTA_BITS> constexpr size_t TREES_IN_FOREST(bool verifier)
{
    return verifier ? DELTA_BITS : TAU;
}
template <size_t TAU, size_t DELTA_BITS> constexpr size_t PARENT(size_t x, bool verifier)
{
    return (x - TREES_IN_FOREST<TAU, DELTA_BITS>(verifier)) / 2;
}
template <size_t TAU, size_t DELTA_BITS> constexpr size_t FIRST_CHILD(size_t x, bool verifier)
{
    return 2 * x + TREES_IN_FOREST<TAU, DELTA_BITS>(verifier);
}
// Equivalent to FIRST_CHILD(..., verifier) iterated d times, starting from x.
template <size_t TAU, size_t DELTA_BITS>
constexpr size_t FIRST_DESCENDENT_DEPTH(size_t x, size_t d, bool verifier)
{
    return ((x + TREES_IN_FOREST<TAU, DELTA_BITS>(verifier)) << d) -
           TREES_IN_FOREST<TAU, DELTA_BITS>(verifier);
}

// Duplicate the same function many times for recursion, so that it will all get inlined.
// XXX: hopefully that also works with templates
template <size_t TAU, size_t DELTA_BITS, size_t depth, bool partial, typename TREE_PRG, secpar S = TREE_PRG::secpar_v>
static ALWAYS_INLINE void
expand_roots(block128 iv, block_secpar<S>* __restrict__ forest, size_t node)
{
    static_assert(TREE_PRG::secpar_v == S);

    constexpr size_t TREE_CHUNK_SIZE = CHUNK_SIZE<TREE_PRG>;
    constexpr size_t TREE_CHUNK_SIZE_SHIFT = CHUNK_SIZE_SHIFT<TREE_PRG>;
    if constexpr (depth < TREE_CHUNK_SIZE_SHIFT)
    {
        constexpr size_t this_chunk_size =
            partial ? (TREES_IN_FOREST<TAU, DELTA_BITS>(false) % TREE_CHUNK_SIZE) : TREE_CHUNK_SIZE;

        std::array<typename TREE_PRG::tweak_t, this_chunk_size> tweaks;
        size_t first_in_layer = FIRST_DESCENDENT_DEPTH<TAU, DELTA_BITS>(0, depth, false);
        for (size_t j = 0; j < this_chunk_size; ++j)
        {
            size_t tree_i = (j + node - first_in_layer) >> depth;
            tweaks[j] = (depth + 1) * TAU + tree_i;
        }

        expand_chunk<this_chunk_size, 2, TREE_PRG>(
            iv, tweaks.data(), &forest[node], &forest[FIRST_CHILD<TAU, DELTA_BITS>(node, false)]);

        expand_roots<TAU, DELTA_BITS, depth + 1, partial, TREE_PRG>(
            iv, forest, FIRST_CHILD<TAU, DELTA_BITS>(node, false));
        expand_roots<TAU, DELTA_BITS, depth + 1, partial, TREE_PRG>(
            iv, forest, FIRST_CHILD<TAU, DELTA_BITS>(node, false) + this_chunk_size);
    }
}

template <size_t TAU, size_t DELTA_BITS, size_t MAX_CHUNK_SIZE, size_t VOLE_WIDTH_SHIFT,
          typename LEAF_HASH, secpar S = LEAF_HASH::secpar_v>
static void write_leaves(const typename LEAF_HASH::iv_t& iv,
                         typename LEAF_HASH::tweak_t tweak,
                         typename LEAF_HASH::tweak_t small_tweak,
                         block_secpar<S>* __restrict__ starting_node, size_t starting_leaf_idx,
                         size_t* permuted_leaf_idx, block_secpar<S>* __restrict__ leaves,
                         unsigned char* __restrict__ hashed_leaves)
{
    using VC = VECTOR_COMMITMENT_CONSTANTS<TAU, DELTA_BITS>;
    constexpr size_t LEAF_CHUNK_SIZE = LEAF_HASH::PREFERRED_WIDTH;

    size_t perm_leaf_idx = *permuted_leaf_idx;
    size_t leaf_idx = starting_leaf_idx;

    for (size_t j = 0; j < MAX_CHUNK_SIZE; j += LEAF_CHUNK_SIZE)
    {
        unsigned char* hash_ptr = &hashed_leaves[leaf_idx * LEAF_HASH::hash_len];
        block_secpar<S>* leaf_ptrs[LEAF_CHUNK_SIZE];
        for (size_t k = 0; k < LEAF_CHUNK_SIZE; ++k)
        {
            leaf_ptrs[k] = &leaves[perm_leaf_idx];
            perm_leaf_idx ^= vole_permute_inv_increment<VOLE_WIDTH_SHIFT, VC::MAX_K>(leaf_idx, 1);
            leaf_idx++;
        }

        LEAF_HASH::template hash<LEAF_CHUNK_SIZE>(
            &starting_node[j], iv, tweak, small_tweak, leaf_ptrs, hash_ptr);
    }

    *permuted_leaf_idx = perm_leaf_idx;
}

template <bool verifier, size_t TAU, size_t DELTA_BITS, size_t VOLE_WIDTH_SHIFT,
          typename TREE_PRG, typename LEAF_HASH, secpar S = TREE_PRG::secpar_v>
static ALWAYS_INLINE void
expand_tree(size_t delta, block128 iv, const typename LEAF_HASH::iv_t& leaf_iv, size_t tree_i,
            block_secpar<S>* __restrict__ forest, unsigned int height, unsigned int tree_depth,
            size_t root, size_t starting_leaf_idx, block_secpar<S>* __restrict__ leaves,
            unsigned char* __restrict__ hashed_leaves)
{
    static_assert(TREE_PRG::secpar_v == S && LEAF_HASH::secpar_v == S);

    using VC = VECTOR_COMMITMENT_CONSTANTS<TAU, DELTA_BITS>;
    constexpr size_t TREE_CHUNK_SIZE = CHUNK_SIZE<TREE_PRG>;
    constexpr size_t LEAF_CHUNK_SIZE = LEAF_HASH::PREFERRED_WIDTH;
    constexpr size_t MAX_CHUNK_SIZE = std::max(TREE_CHUNK_SIZE, LEAF_CHUNK_SIZE);

    size_t permuted_leaf_idx =
        vole_permute_key_index_inv<VOLE_WIDTH_SHIFT, VC::MAX_K>(starting_leaf_idx ^ delta);

    // Loop over blocks of size max(TREE_CHUNK_SIZE, LEAF_CHUNK_SIZE).
    size_t pow_height = (size_t)1 << height;
    for (size_t chunk = 0; chunk < pow_height;
         chunk += MAX_CHUNK_SIZE / TREE_CHUNK_SIZE, starting_leaf_idx += TREE_CHUNK_SIZE)
    {
        size_t ancestor;
        for (size_t i = chunk; i < chunk + (MAX_CHUNK_SIZE / TREE_CHUNK_SIZE) && i < pow_height;
             ++i)
        {
            unsigned int ancestor_height = count_trailing_zeros(i | pow_height);
            unsigned int ancestor_depth = height - ancestor_height;

            ancestor = FIRST_DESCENDENT_DEPTH<TAU, DELTA_BITS>(root, ancestor_depth, verifier) +
                       TREE_CHUNK_SIZE * (i >> ancestor_height);

            for (int h = ancestor_height - 1; h >= 0; --h)
            {
                size_t first_child = FIRST_CHILD<TAU, DELTA_BITS>(ancestor, verifier);
                typename TREE_PRG::tweak_t tweak = (tree_depth - h) * TAU + tree_i;
                expand_chunk<TREE_CHUNK_SIZE, 2, TREE_PRG>(
                    iv, tweak, &forest[ancestor], &forest[first_child]);
                ancestor = first_child;
            }
        }

        if (chunk + (MAX_CHUNK_SIZE / TREE_CHUNK_SIZE) <= pow_height)
        {
            // We've just finished a block of size MAX_CHUNK_SIZE (at least LEAF_CHUNK_SIZE), so
            // apply the leaf prgs and write to leaves and hashed_leaves.
            size_t starting_node = ancestor + TREE_CHUNK_SIZE - MAX_CHUNK_SIZE;
            write_leaves<TAU, DELTA_BITS, MAX_CHUNK_SIZE, VOLE_WIDTH_SHIFT, LEAF_HASH>(
                leaf_iv, (tree_depth + 1) * TAU + tree_i, tree_i,
                &forest[starting_node], starting_leaf_idx, &permuted_leaf_idx,
                leaves, hashed_leaves);
        }
    }
}

template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT>
void ggm_forest_bavc<S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT>::commit(
    const block_secpar<S> seed, block128 iv, block_secpar<S>* __restrict__ forest,
    block_secpar<S>* __restrict__ leaves, unsigned char* __restrict__ hashed_leaves)
{
    block_secpar<S> roots[TAU];
    expand_chunk<1, TAU, tree_prg_t>(iv, (typename tree_prg_t::tweak_t) 0, &seed, &roots[0]);
    commit_from_roots(roots, iv, forest, leaves, hashed_leaves);
}

template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT>
void ggm_forest_bavc<S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT>::commit_from_roots(
    block_secpar<S>* roots, block128 iv, block_secpar<S>* __restrict__ forest,
    block_secpar<S>* __restrict__ leaves, unsigned char* __restrict__ hashed_leaves)
{
    using VC = CONSTS;
    constexpr size_t TREE_CHUNK_SIZE = CHUNK_SIZE<tree_prg_t>;
    constexpr size_t TREE_CHUNK_SIZE_SHIFT = CHUNK_SIZE_SHIFT<tree_prg_t>;

    typename leaf_hash_t::iv_t leaf_iv(iv);

    memcpy(forest, roots, TREES_IN_FOREST<TAU, DELTA_BITS>(false) * sizeof(block_secpar<S>));

    // First expand each tree far enough to have TREE_CHUNK_SIZE nodes.
    static_assert(VC::MIN_K >= TREE_CHUNK_SIZE_SHIFT, "");
    for (size_t i = 0; i + TREE_CHUNK_SIZE <= TREES_IN_FOREST<TAU, DELTA_BITS>(false);
         i += TREE_CHUNK_SIZE)
        expand_roots<TAU, DELTA_BITS, 0, false, tree_prg_t>(iv, forest, i);
    constexpr size_t remaining = TREES_IN_FOREST<TAU, DELTA_BITS>(false) % TREE_CHUNK_SIZE;
    if constexpr (remaining)
        expand_roots<TAU, DELTA_BITS, 0, true, tree_prg_t>(
            iv, forest, TREES_IN_FOREST<TAU, DELTA_BITS>(false) - remaining);

    // Expand each tree, now that they are each 1 chunk in size.
    for (size_t i = 0; i < TAU; ++i)
    {
        // First VOLES_MAX_K trees are 1 taller.
        unsigned int height = i < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K;

        size_t root = FIRST_DESCENDENT_DEPTH<TAU, DELTA_BITS>(i, TREE_CHUNK_SIZE_SHIFT, false);
        expand_tree<false, TAU, DELTA_BITS, VOLE_WIDTH_SHIFT, tree_prg_t, leaf_hash_t>(
            0, iv, leaf_iv, i, forest, height - TREE_CHUNK_SIZE_SHIFT, height, root, 0, leaves, hashed_leaves);

        size_t pow_height = (size_t)1 << height;
        leaves += pow_height;
        hashed_leaves += pow_height * leaf_hash_t::hash_len;
    }
}

template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT>
bool ggm_forest_bavc<S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT>::open(
    const block_secpar<S>* __restrict__ forest, const unsigned char* __restrict__ hashed_leaves,
    const uint8_t* __restrict__ delta, unsigned char* __restrict__ opening)
{
    using VC = CONSTS;
    const uint8_t* delta_start = delta;
    for (size_t i = 0; i < TAU; ++i)
    {
        unsigned int depth = i < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K;
        size_t node = FIRST_CHILD<TAU, DELTA_BITS>(i, false);
        size_t leaf_idx = 0;
        for (unsigned int d = 1; d <= depth; ++d)
        {
            unsigned int hole = delta[depth - d] & 1;
            leaf_idx = 2 * leaf_idx + hole;

            memcpy(opening, &forest[node + (1 - hole)], sizeof(block_secpar<S>));
            opening += sizeof(block_secpar<S>);
            node = FIRST_CHILD<TAU, DELTA_BITS>(node + hole, false);
        }

        memcpy(opening, &hashed_leaves[leaf_idx * leaf_hash_t::hash_len], leaf_hash_t::hash_len);
        opening += leaf_hash_t::hash_len;

        delta += depth;
        hashed_leaves += (leaf_hash_t::hash_len << depth);
    }
    // Check that we did not access delta out of bounds.
    FAEST_ASSERT(delta == delta_start + delta_bits_v);
    (void) delta_start;

    return true;
}

template <secpar S, size_t TAU, size_t DELTA_BITS, typename TREE_PRG, size_t depth>
static ALWAYS_INLINE void
expand_verifier_subtrees(size_t this_chunk_size, block128 iv,
                         block_secpar<S>* __restrict__ forest, size_t i, size_t node)
{
    static_assert(TREE_PRG::secpar_v == S);

    using VC = VECTOR_COMMITMENT_CONSTANTS<TAU, DELTA_BITS>;
    constexpr size_t TREE_CHUNK_SIZE = CHUNK_SIZE<TREE_PRG>;
    constexpr size_t TREE_CHUNK_SIZE_SHIFT = CHUNK_SIZE_SHIFT<TREE_PRG>;
    constexpr size_t TREES = TREES_IN_FOREST<TAU, DELTA_BITS>(true);

    if constexpr (depth < TREE_CHUNK_SIZE_SHIFT)
    {
        constexpr size_t level_lim = (TREES - (depth + 1) * TAU) << depth;
        if (i >= level_lim)
            return;

        std::array<typename TREE_PRG::tweak_t, TREE_CHUNK_SIZE> tweaks;
        for (size_t j = 0; j < this_chunk_size; ++j)
        {
            size_t root = (i + j) >> depth;
            size_t prover_root = (root < VC::NUM_MAX_K) ? root : (root - VC::NUM_MAX_K) % TAU;
            size_t root_height = (TREES - 1 - root) / TAU;
            size_t root_depth = (prover_root < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K) - root_height;
            tweaks[j] = (root_depth + depth + 1) * TAU + prover_root;
        }

        size_t child = FIRST_CHILD<TAU, DELTA_BITS>(node, true);
        if (i + this_chunk_size > level_lim)
        {
            constexpr size_t this_chunk_size = level_lim % TREE_CHUNK_SIZE;
            FAEST_ASSERT(this_chunk_size == level_lim - i); /* All preceding calls were on whole chunks. */

            expand_chunk<this_chunk_size, 2, TREE_PRG>(iv, tweaks.data(), &forest[node], &forest[child]);

            size_t output_size = 2 * this_chunk_size;
            i *= 2;
            if (output_size >= TREE_CHUNK_SIZE)
            {
                expand_verifier_subtrees<S, TAU, DELTA_BITS, TREE_PRG, depth + 1>(
                    TREE_CHUNK_SIZE, iv, forest, i, child);
                i += TREE_CHUNK_SIZE;
                child += TREE_CHUNK_SIZE;
                output_size -= TREE_CHUNK_SIZE;
            }
            expand_verifier_subtrees<S, TAU, DELTA_BITS, TREE_PRG, depth + 1>(
                output_size, iv, forest, i, child);
        }
        else
        {
            // this_chunk_size must be TREE_CHUNK_SIZE here, because at most the last call is not on a
            // whole chunk, and that call will be the one that hits the level_lim limit above.
            constexpr size_t this_chunk_size = TREE_CHUNK_SIZE;

            expand_chunk<this_chunk_size, 2, TREE_PRG>(iv, tweaks.data(), &forest[node], &forest[child]);

            expand_verifier_subtrees<S, TAU, DELTA_BITS, TREE_PRG, depth + 1>(
                TREE_CHUNK_SIZE, iv, forest, 2 * i, child);
            expand_verifier_subtrees<S, TAU, DELTA_BITS, TREE_PRG, depth + 1>(
                TREE_CHUNK_SIZE, iv, forest, 2 * i + this_chunk_size,
                child + this_chunk_size);
        }
    }
}

// Reorder the keys in the opening, to group them by height.
template <secpar S, size_t TAU, size_t DELTA_BITS, size_t HASH_LEN>
static ALWAYS_INLINE void reorder_verifier_keys(const unsigned char* opening,
                                                block_secpar<S>* reordered_keys)
{
    using VC = VECTOR_COMMITMENT_CONSTANTS<TAU, DELTA_BITS>;
    block_secpar<S>* dst = reordered_keys;
    for (size_t i = 0; i < VC::MAX_K; ++i)
    {
        size_t src_idx = i * secpar_to_bytes(S);
        for (size_t j = 0; j < VC::NUM_MAX_K; ++j, ++dst, src_idx += VC::MAX_K * secpar_to_bytes(S) + HASH_LEN)
            memcpy(dst, &opening[src_idx], sizeof(block_secpar<S>));
        if (i >= VC::MAX_K - VC::MIN_K)
        {
            src_idx -= (VC::MAX_K - VC::MIN_K) * sizeof(block_secpar<S>);
            for (size_t j = 0; j < VC::NUM_MIN_K; ++j, ++dst,
                 src_idx += VC::MIN_K * secpar_to_bytes(S) + HASH_LEN)
                memcpy(dst, &opening[src_idx], sizeof(block_secpar<S>));
        }
    }
}

template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT>
bool ggm_forest_bavc<S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT>::verify(
    block128 iv, const unsigned char* __restrict__ opening, const uint8_t* __restrict__ delta,
    block_secpar<S>* __restrict__ leaves, unsigned char* __restrict__ hashed_leaves)
{
    using VC = CONSTS;
    constexpr size_t TREE_CHUNK_SIZE = CHUNK_SIZE<tree_prg_t>;
    constexpr size_t TREE_CHUNK_SIZE_SHIFT = CHUNK_SIZE_SHIFT<tree_prg_t>;
    constexpr size_t LEAF_CHUNK_SIZE = leaf_hash_t::PREFERRED_WIDTH;
    constexpr size_t LEAF_CHUNK_SIZE_SHIFT = leaf_hash_t::PREFERRED_WIDTH_SHIFT;
    constexpr size_t MAX_CHUNK_SIZE = std::max(TREE_CHUNK_SIZE, LEAF_CHUNK_SIZE);
    constexpr size_t MAX_CHUNK_SIZE_SHIFT = std::max(TREE_CHUNK_SIZE_SHIFT, LEAF_CHUNK_SIZE_SHIFT);

    block_secpar<S>* verifier_subtrees = reinterpret_cast<block_secpar<S>*>(aligned_alloc(
        alignof(block_secpar<S>),
        TREES_IN_FOREST<TAU, DELTA_BITS>(true) * ((1 << VC::MAX_K) - 1) * sizeof(block_secpar<S>)));

    typename leaf_hash_t::iv_t leaf_iv(iv);

    // Need the keys in transposed order.
    reorder_verifier_keys<S, TAU, DELTA_BITS, leaf_hash_t::hash_len>(opening, verifier_subtrees);

    // Expand all subtrees from opening to depth TREE_CHUNK_SIZE_SHIFT, except for the ones too
    // close to the leaves, which get expanded fewer times. Splitting it up by d like this isn't
    // necessary, as the expand_verifier_subtrees_* functions already take case of splitting it up.
    // It just helps the compiler to see what things are constant.
    size_t i = 0;
#ifdef __GNUC__
#pragma GCC unroll(5)
#endif
    for (unsigned int d = TREE_CHUNK_SIZE_SHIFT; d > 0; --d)
    {
        // Expand subtrees that fully use depth d.
        size_t end = TREES_IN_FOREST<TAU, DELTA_BITS>(true) - d * TAU;
        for (; (i + TREE_CHUNK_SIZE) <= end; i += TREE_CHUNK_SIZE)
            expand_verifier_subtrees<S, TAU, DELTA_BITS, tree_prg_t, 0>(
                TREE_CHUNK_SIZE, iv, verifier_subtrees, i, i);

        // Expand the subtree that partially reaches depth d, but also has parts that only reach d-1
        // or less. But only if this subtree exists. Again, this is separated so that the compiler
        // can see that take advantage of constants.
        if (end % TREE_CHUNK_SIZE != 0)
        {
            FAEST_ASSERT(i == end - (end % TREE_CHUNK_SIZE));
            expand_verifier_subtrees<S, TAU, DELTA_BITS, tree_prg_t, 0>(
                TREE_CHUNK_SIZE, iv, verifier_subtrees, i, i);
            i += TREE_CHUNK_SIZE;
        }
    }

    // Fully expand each subtree.
    for (i = 0; i < TAU; ++i)
    {
        unsigned int tree_depth = i < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K;
        size_t root = i + (i < VC::NUM_MAX_K ? 0 : VC::NUM_MAX_K);

        size_t this_delta = 0;
        for (unsigned int d = 1; d <= tree_depth; ++d)
            this_delta = 2 * this_delta + (delta[tree_depth - d] & 1);

        block_secpar<S> last_chunk[MAX_CHUNK_SIZE];
        for (unsigned int j = 0; j < tree_depth; ++j)
        {
            unsigned int height = tree_depth - 1 - j;
            size_t pow_height = (size_t)1 << height;
            size_t leaf_index = (this_delta & -pow_height) ^ pow_height;

            // Expand the rest of this tree, and hash the leaf nodes if there are at least
            // LEAF_CHUNK_SIZE of them.
            if (height >= TREE_CHUNK_SIZE_SHIFT)
            {
                size_t tree_chunk_root =
                    FIRST_DESCENDENT_DEPTH<TAU, DELTA_BITS>(root, TREE_CHUNK_SIZE_SHIFT, true);
                expand_tree<true, TAU, DELTA_BITS, VOLE_WIDTH_SHIFT, tree_prg_t, leaf_hash_t>(
                    this_delta, iv, leaf_iv, i, verifier_subtrees,
                    height - TREE_CHUNK_SIZE_SHIFT, tree_depth, tree_chunk_root, leaf_index, leaves,
                    hashed_leaves);
            }

            if (height < MAX_CHUNK_SIZE_SHIFT)
                memcpy(
                    &last_chunk[leaf_index % MAX_CHUNK_SIZE],
                    &verifier_subtrees[FIRST_DESCENDENT_DEPTH<TAU, DELTA_BITS>(root, height, true)],
                    sizeof(block_secpar<S>) << height);

            if (i < VC::NUM_MAX_K && j == 0)
                root += VC::NUM_MAX_K;
            else
                root += TAU;
        }

        // There's 1 leaf node we cannot compute. At least stop it from being uninitialized memory.
        memset(&last_chunk[this_delta % MAX_CHUNK_SIZE], 0, sizeof(block_secpar<S>));

        // Hash the 1 remaining MAX_CHUNK_SIZE sized chunk of the tree, which didn't get hashed
        // because it was too small.
        size_t starting_leaf_idx = this_delta - (this_delta % MAX_CHUNK_SIZE);
        size_t permuted_leaf_idx =
            vole_permute_key_index_inv<VOLE_WIDTH_SHIFT, VC::MAX_K>(starting_leaf_idx ^ this_delta);
        write_leaves<TAU, DELTA_BITS, MAX_CHUNK_SIZE, VOLE_WIDTH_SHIFT, leaf_hash_t>(
            leaf_iv, (tree_depth + 1) * TAU + i, i,
            last_chunk, starting_leaf_idx, &permuted_leaf_idx, leaves,
            hashed_leaves);

        // Currently leaves[0] and hashed_leaves[this_delta * leaf_hash_t::hash_len] contain
        // garbage (specifically, PRG(0)), because we don't know the keys on the active path. Fix
        // them up.
        memset(&leaves[0], 0, sizeof(block_secpar<S>));
        memcpy(&hashed_leaves[this_delta * leaf_hash_t::hash_len],
               opening + tree_depth * sizeof(block_secpar<S>), leaf_hash_t::hash_len);

        size_t pow_tree_depth = (size_t)1 << tree_depth;
        leaves += pow_tree_depth;
        hashed_leaves += pow_tree_depth * leaf_hash_t::hash_len;
        opening += tree_depth * sizeof(block_secpar<S>) + leaf_hash_t::hash_len;
        delta += tree_depth;
    }

    free(verifier_subtrees);
    return true;
}

// Size of a long vector.
template <typename VC> constexpr static size_t BATCH_VEC_LONG_LEN = (1 << VC::MAX_K);

// Size of a short vector.
template <typename VC> constexpr static size_t BATCH_VEC_SHORT_LEN = (1 << VC::MIN_K);

// Size of the concatenated vector.
template <typename VC>
constexpr static size_t BATCH_VEC_TOTAL_LEN =
    VC::NUM_MAX_K * BATCH_VEC_LONG_LEN<VC> + VC::NUM_MIN_K * BATCH_VEC_SHORT_LEN<VC>;

// Size the vector with given index.
template <typename VC> ALWAYS_INLINE constexpr static size_t BATCH_VEC_LEN(size_t vec_index)
{
    FAEST_ASSERT(vec_index < VC::tau_v);
    return (vec_index < VC::NUM_MAX_K) ? BATCH_VEC_LONG_LEN<VC> : BATCH_VEC_SHORT_LEN<VC>;
}

// The output vector is a concatenation of first the long vectors and then the short vectors.
template <typename VC> ALWAYS_INLINE constexpr static bool BATCH_VEC_IS_LONG_VEC(size_t vec_index)
{
    FAEST_ASSERT(vec_index < VC::tau_v);
    return vec_index < VC::NUM_MAX_K;
}

// Position in the output vector of an element from a given long vector and index.
template <typename VC>
ALWAYS_INLINE constexpr static size_t BATCH_VEC_POS_IN_OUTPUT_LONG(size_t vec_index,
                                                                   size_t leaf_index)
{
    FAEST_ASSERT(BATCH_VEC_IS_LONG_VEC<VC>(vec_index)); // should be a long vector
    FAEST_ASSERT(leaf_index < BATCH_VEC_LONG_LEN<VC>);
    const auto index = vec_index * BATCH_VEC_LONG_LEN<VC> + leaf_index;
    FAEST_ASSERT(index < BATCH_VEC_TOTAL_LEN<VC>);
    return index;
}

// Position in the output vector of an element from a given short vector and index.
template <typename VC>
ALWAYS_INLINE constexpr static size_t BATCH_VEC_POS_IN_OUTPUT_SHORT(size_t vec_index,
                                                                    size_t leaf_index)
{
    static_assert(VC::MIN_K == VC::MAX_K || BATCH_VEC_LONG_LEN<VC> == 2 * BATCH_VEC_SHORT_LEN<VC>);
    FAEST_ASSERT(!BATCH_VEC_IS_LONG_VEC<VC>(vec_index)); // should be a short vector
    FAEST_ASSERT(leaf_index < BATCH_VEC_SHORT_LEN<VC>);
    // NB: This formula works because short vectors are half the length of long vectors if they are
    // distinct.
    const auto index =
        VC::NUM_MAX_K * BATCH_VEC_SHORT_LEN<VC> + vec_index * BATCH_VEC_SHORT_LEN<VC> + leaf_index;
    FAEST_ASSERT(index < BATCH_VEC_TOTAL_LEN<VC>);
    return index;
}

// Position in the output vector of an element from a given vector and index.
template <typename VC>
ALWAYS_INLINE constexpr static size_t BATCH_VEC_HASH_POS_IN_OUTPUT(size_t vec_index,
                                                                   size_t leaf_index)
{
    return BATCH_VEC_IS_LONG_VEC<VC>(vec_index)
               ? BATCH_VEC_POS_IN_OUTPUT_LONG<VC>(vec_index, leaf_index)
               : BATCH_VEC_POS_IN_OUTPUT_SHORT<VC>(vec_index, leaf_index);
}

// Position in the output vector of an element from a given vector and index after applying the
// inverse vole key index transformation on the leaf index.
template <typename VC, size_t VOLE_WIDTH_SHIFT>
ALWAYS_INLINE constexpr static size_t BATCH_VEC_LEAF_POS_IN_OUTPUT(size_t vec_index,
                                                                   size_t leaf_index)
{
    return BATCH_VEC_HASH_POS_IN_OUTPUT<VC>(
        vec_index, vole_permute_key_index_inv<VOLE_WIDTH_SHIFT, VC::MAX_K>(leaf_index));
}

// In "one tree", the output vectors are interleaved. Thus the overall output vector is
// arranged as follows. Let v_1, ..., v_l the long vectors and w_1, ..., w_s the short vectors.
//
//      v_1[1], v_2[1], ..., v_l[1], w_1[1], w_2[1], ..., w_s[1],
//      v_1[2], v_2[2], ..., v_l[2], w_1[2], w_2[2], ..., w_s[2],
//      ...
//      v_1[n_s], v_2[n_s], ..., v_l[n_s], w_1[n_s], w_2[n_s], ..., w_s[n_s],
//      v_1[n_s+1], v_2[n_s+1], ..., v_l[n_s+1],
//      v_1[n_s+2], v_2[n_s+2], ..., v_l[n_s+2],
//      ...
//      v_1[n_l], v_2[n_l], ..., v_l[n_l],
//
template <typename OTBAVC>
ALWAYS_INLINE constexpr static size_t BATCH_VEC_POS_IN_TREE(size_t vec_index, size_t leaf_index)
{
    using VC = OTBAVC::CONSTS;
    FAEST_ASSERT(vec_index <= VC::tau_v);
    FAEST_ASSERT(!BATCH_VEC_IS_LONG_VEC<VC>(vec_index) || (leaf_index < BATCH_VEC_LONG_LEN<VC>));
    FAEST_ASSERT(!!BATCH_VEC_IS_LONG_VEC<VC>(vec_index) || (leaf_index < BATCH_VEC_SHORT_LEN<VC>));
    constexpr size_t start_of_leaves = OTBAVC::COMMIT_LEAVES - 1;
    return start_of_leaves + ((leaf_index < BATCH_VEC_SHORT_LEN<VC>)
                                  ? (VC::tau_v * leaf_index + vec_index)
                                  : (VC::NUM_MIN_K * BATCH_VEC_SHORT_LEN<VC> +
                                     VC::NUM_MAX_K * leaf_index + vec_index));
}

// Inverse function of BATCH_VEC_POS_IN_TREE
template <typename OTBAVC>
ALWAYS_INLINE constexpr static std::tuple<size_t, size_t> BATCH_TREE_POS_IN_VEC(size_t tree_pos)
{
    using VC = OTBAVC::CONSTS;
    constexpr size_t leaf_pos = tree_pos - (OTBAVC::COMMIT_LEAVES - 1);
    if (leaf_pos < BATCH_VEC_SHORT_LEN<VC>)
    {
        constexpr size_t vec_index = leaf_pos % VC::tau_v;
        constexpr size_t leaf_index = leaf_pos / VC::tau_v;
        return std::make_tuple(vec_index, leaf_index);
    }
    else
    {
        constexpr size_t offset = VC::NUM_MIN_K * BATCH_VEC_SHORT_LEN<VC>;
        constexpr size_t vec_index = (leaf_pos - offset) % VC::NUM_MIN_K;
        constexpr size_t leaf_index = (leaf_pos - offset) / VC::NUM_MIN_K;
        return std::make_tuple(vec_index, leaf_index);
    }
}

template <secpar S, size_t num_nodes, size_t COMMIT_NODES>
static ALWAYS_INLINE void
write_seeds_if_not_opened(
    block_secpar<S>* __restrict__ tree, const block_secpar<S>* __restrict__ from,
    size_t node, const std::bitset<COMMIT_NODES>* dont_write)
{
    for (size_t i = 0; i < num_nodes; ++i)
        if ((*dont_write)[node + i] == 0)
            tree[node + i] = from[i];
}

template <size_t depth, size_t COMMIT_NODES, typename TREE_PRG, secpar S = TREE_PRG::secpar_v>
static ALWAYS_INLINE void
expand_one_roots(block128 iv, block_secpar<S>* __restrict__ tree, size_t node, const std::bitset<COMMIT_NODES>* dont_write = nullptr)
{
    static_assert(TREE_PRG::secpar_v == S);

    if constexpr (depth < CHUNK_SIZE_SHIFT<TREE_PRG>)
    {
        constexpr size_t this_chunk_size = 1 << depth;
        block_secpar<S> expand_tmp[2 * this_chunk_size];

        size_t child = 2 * node + 1;
        block_secpar<S>* dst = dont_write ? expand_tmp : &tree[child];
        expand_chunk<this_chunk_size, 2, TREE_PRG>(
            iv, node, tweak_increment{}, &tree[node], dst);

        if (dont_write)
            write_seeds_if_not_opened<S, 2 * this_chunk_size, COMMIT_NODES>(
                tree, expand_tmp, child, dont_write);

        expand_one_roots<depth + 1, COMMIT_NODES, TREE_PRG>(iv, tree, child, dont_write);
    }
}

// Expand the tree, once we've reached the level with width TREE_CHUNK_SIZE.
template <size_t COMMIT_NODES, size_t COMMIT_LEAVES, typename TREE_PRG, secpar S = TREE_PRG::secpar_v>
static ALWAYS_INLINE void
expand_one_tree(block128 iv, block_secpar<S>* __restrict__ tree, const std::bitset<COMMIT_NODES>* dont_write = nullptr)
{
    static_assert(TREE_PRG::secpar_v == S);
    constexpr size_t TREE_CHUNK_SIZE = CHUNK_SIZE<TREE_PRG>;

    size_t next_to_expand_from = TREE_CHUNK_SIZE - 1;
    size_t next_to_expand_to = 2 * TREE_CHUNK_SIZE - 1;
    while (next_to_expand_to <= COMMIT_NODES - 2 * TREE_CHUNK_SIZE)
    {
        block_secpar<S> expand_tmp[2 * TREE_CHUNK_SIZE];

        block_secpar<S>* dst = dont_write ? expand_tmp : &tree[next_to_expand_to];
        expand_chunk<TREE_CHUNK_SIZE, 2, TREE_PRG>(
            iv, next_to_expand_from, tweak_increment{}, &tree[next_to_expand_from], dst);

        if (dont_write)
            write_seeds_if_not_opened<S, 2 * TREE_CHUNK_SIZE, COMMIT_NODES>(
                tree, expand_tmp, next_to_expand_to, dont_write);

        next_to_expand_from += TREE_CHUNK_SIZE;
        next_to_expand_to += 2 * TREE_CHUNK_SIZE;
    }

    static_assert(COMMIT_LEAVES % TREE_CHUNK_SIZE == 0);
    FAEST_ASSERT(next_to_expand_from == COMMIT_LEAVES - 1);
    FAEST_ASSERT(next_to_expand_to == COMMIT_NODES);
}

template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT, size_t OPENING_SEEDS_THRESHOLD>
void one_tree_bavc<S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT,
                   OPENING_SEEDS_THRESHOLD>::commit(const block_secpar<S> seed, block128 iv,
                                                    block_secpar<S>* __restrict__ tree,
                                                    block_secpar<S>* __restrict__ leaves,
                                                    unsigned char* __restrict__ hashed_leaves)
{
    using VC = CONSTS;
    constexpr size_t LEAF_CHUNK_SIZE = leaf_hash_t::PREFERRED_WIDTH;

    typename leaf_hash_t::iv_t leaf_iv(iv);

    // copy seed to tree
    memcpy(tree, &seed, sizeof(block_secpar<S>));

    // expand the internals of tree far enough to have TREE_CHUNK_SIZE nodes.
    expand_one_roots<0, COMMIT_NODES, tree_prg_t>(iv, tree, 0);

    // expand rest of tree
    expand_one_tree<COMMIT_NODES, COMMIT_LEAVES, tree_prg_t>(iv, tree);

    // expand leaves, then write seeds and commitments to output
    for (size_t vec_index = 0; vec_index < TAU; vec_index++)
    {
        typename leaf_hash_t::tweak_t tweak = vec_index + COMMIT_LEAVES - 1;

        static_assert(BATCH_VEC_LONG_LEN<VC> % LEAF_CHUNK_SIZE == 0);
        static_assert(BATCH_VEC_SHORT_LEN<VC> % LEAF_CHUNK_SIZE == 0);

        size_t permuted_leaf_idx = vole_permute_key_index_inv<VOLE_WIDTH_SHIFT, VC::MAX_K>(0);
        for (size_t leaf_index_chunk = 0; leaf_index_chunk < BATCH_VEC_LEN<VC>(vec_index);
             leaf_index_chunk += LEAF_CHUNK_SIZE)
        {
            block_secpar<S> keys[LEAF_CHUNK_SIZE];
            for (size_t leaf_index_low = 0; leaf_index_low < LEAF_CHUNK_SIZE; ++leaf_index_low)
                keys[leaf_index_low] = tree[
                    BATCH_VEC_POS_IN_TREE<this_t>(vec_index, leaf_index_chunk + leaf_index_low)];

            write_leaves<TAU, DELTA_BITS, LEAF_CHUNK_SIZE, VOLE_WIDTH_SHIFT, leaf_hash_t>(
                leaf_iv, tweak, vec_index, keys, leaf_index_chunk, &permuted_leaf_idx, leaves, hashed_leaves);
        }

        leaves += BATCH_VEC_LEN<VC>(vec_index);
        hashed_leaves += BATCH_VEC_LEN<VC>(vec_index) * leaf_hash_t::hash_len;
    }
}

template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT, size_t OPENING_SEEDS_THRESHOLD>
bool one_tree_bavc<
    S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT,
    OPENING_SEEDS_THRESHOLD>::open(const block_secpar<S>* __restrict__ tree,
                                   const unsigned char* __restrict__ hashed_leaves,
                                   const uint8_t* __restrict__ delta,
                                   unsigned char* __restrict__ opening)
{
    using VC = CONSTS;
    std::bitset<COMMIT_NODES> dont_reveal{};
    size_t opening_bytes_written = 0;

    // compute size of opening first before doing all the memcpys to save cycles in aborting case
    size_t number_of_hidden_nodes = 0;
    size_t delta_parsed[TAU];
    const uint8_t* delta_ptr = delta;
    for (size_t vec_index = 0; vec_index < TAU; ++vec_index)
    {
        unsigned int depth = vec_index < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K;

        // read i-th leaf index from delta
        size_t delta_i = 0;
        for (int d = depth - 1; d >= 0; --d)
            delta_i = 2 * delta_i + (delta_ptr[d] & 1);
        delta_ptr += depth;
        delta_parsed[vec_index] = delta_i;

        // mark leaf nodes that should not be revealed
        size_t pos = BATCH_VEC_POS_IN_TREE<this_t>(vec_index, delta_parsed[vec_index]);
        dont_reveal[pos] = 1;
        number_of_hidden_nodes++;

        while (pos > 0 && dont_reveal[(pos - 1) / 2] == 0)
        {
            pos = (pos - 1) / 2;
            dont_reveal[pos] = 1;
            number_of_hidden_nodes++;
        }
    }

    if (number_of_hidden_nodes - 2 * TAU + 1 > OPENING_SEEDS_THRESHOLD)
    {
        return false;
    }

    // copy commitments to opening
    for (size_t vec_index = 0; vec_index < TAU; ++vec_index)
    {
        size_t hash_pos = BATCH_VEC_HASH_POS_IN_OUTPUT<VC>(vec_index, delta_parsed[vec_index]);
        memcpy(opening + opening_bytes_written,
               &hashed_leaves[hash_pos * leaf_hash_t::hash_len],
               leaf_hash_t::hash_len);
        opening_bytes_written += leaf_hash_t::hash_len;
    }

    // work way up tree
    for (int i = COMMIT_NODES - COMMIT_LEAVES - 1; i >= 0; i--)
    {
        // dont reveal node i if one of its children should not be revealed
        dont_reveal[i] = dont_reveal[2 * i + 1] || dont_reveal[2 * i + 2];

        // if exactly one of the children can be revealed, put it in opening
        if (dont_reveal[2 * i + 1] ^ dont_reveal[2 * i + 2])
        {
            FAEST_ASSERT(opening_bytes_written + sizeof(block_secpar<S>) <= OPEN_SIZE);
            memcpy(opening + opening_bytes_written, &tree[2 * i + 1 + dont_reveal[2 * i + 1]],
                   sizeof(block_secpar<S>));
            opening_bytes_written += sizeof(block_secpar<S>);
        }
    }

    // fill remaining part of opening (if any) with zeros.
    memset(opening + opening_bytes_written, 0, OPEN_SIZE - opening_bytes_written);

    return 1;
}

template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT, size_t OPENING_SEEDS_THRESHOLD>
bool one_tree_bavc<S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT,
                   OPENING_SEEDS_THRESHOLD>::verify(block128 iv,
                                                    const uint8_t* __restrict__ opening,
                                                    const uint8_t* __restrict__ delta,
                                                    block_secpar<S>* __restrict__ leaves,
                                                    unsigned char* __restrict__ hashed_leaves)
{
    using VC = CONSTS;
    constexpr size_t LEAF_CHUNK_SIZE = leaf_hash_t::PREFERRED_WIDTH;

    block_secpar<S>* tree = reinterpret_cast<block_secpar<S>*>(
        aligned_alloc(alignof(block_secpar<S>), COMMIT_NODES * sizeof(block_secpar<S>)));

    size_t delta_parsed[TAU]; // parse delta

    std::bitset<COMMIT_NODES> seed_in_opening{}; // Node i present <-> bit i set.

    // Place the opening seeds into the tree.
    {
        std::bitset<COMMIT_NODES> dont_reveal{};

        const uint8_t* delta_ptr = delta;
        for (size_t vec_index = 0; vec_index < TAU; ++vec_index)
        {
            unsigned int depth = vec_index < VC::NUM_MAX_K ? VC::MAX_K : VC::MIN_K;

            // read i-th leaf index from delta
            size_t delta_i = 0;
            for (int d = depth - 1; d >= 0; --d)
                delta_i = 2 * delta_i + (delta_ptr[d] & 1);
            delta_ptr += depth;
            delta_parsed[vec_index] = delta_i;

            // mark leaf nodes that should not be revealed
            size_t pos = BATCH_VEC_POS_IN_TREE<this_t>(vec_index, delta_i);
            dont_reveal[pos] = 1;
        }

        // work way up tree
        size_t opening_pos = TAU * leaf_hash_t::hash_len;
        for (int i = COMMIT_LEAVES - 2; i >= 0; i--)
        {
            // dont reveal node i if one of its children should not be revealed
            dont_reveal[i] = dont_reveal[2 * i + 1] || dont_reveal[2 * i + 2];

            // if exactly one of the children can be revealed, copy from opening
            if (dont_reveal[2 * i + 1] ^ dont_reveal[2 * i + 2])
            {
                if (opening_pos >= OPEN_SIZE)
                {
                    // opening is invalid
                    free(tree);
                    return false;
                }
                seed_in_opening[2 * i + 1 + dont_reveal[2 * i + 1]] = 1;
                memcpy(&tree[2 * i + 1 + dont_reveal[2 * i + 1]], opening + opening_pos,
                       sizeof(block_secpar<S>));
                opening_pos += sizeof(block_secpar<S>);
            }
        }

        while (opening_pos < OPEN_SIZE)
        {
            if (opening[opening_pos++] != 0)
            {
                // opening is invalid
                free(tree);
                return false;
            }
        }
    }

    typename leaf_hash_t::iv_t leaf_iv(iv);

    // Expand tree. Start by placing dummy values in tree for nodes we don't know.
    for (size_t i = 0; i < 2; ++i)
        if (!seed_in_opening[1 + i])
            tree[1 + i] = block_secpar<S>::set_zero();

    expand_one_roots<1, COMMIT_NODES, tree_prg_t>(iv, tree, 1, &seed_in_opening);

    // expand rest of tree
    expand_one_tree<COMMIT_NODES, COMMIT_LEAVES, tree_prg_t>(iv, tree, &seed_in_opening);

    // expand leaves, then write seeds and commitments to output
    for (size_t vec_index = 0; vec_index < TAU; vec_index++)
    {
        typename leaf_hash_t::tweak_t tweak = vec_index + COMMIT_LEAVES - 1;

        static_assert(BATCH_VEC_LONG_LEN<VC> % LEAF_CHUNK_SIZE == 0);
        static_assert(BATCH_VEC_SHORT_LEN<VC> % LEAF_CHUNK_SIZE == 0);

        // There's 1 leaf node we couldn't compute. At least stop it from being uninitialized memory.
        size_t delta_i = delta_parsed[vec_index];
        memset(&tree[BATCH_VEC_POS_IN_TREE<this_t>(vec_index, delta_i)], 0, sizeof(block_secpar<S>));

        size_t permuted_leaf_idx = vole_permute_key_index_inv<VOLE_WIDTH_SHIFT, VC::MAX_K>(delta_i);
        for (size_t leaf_index_chunk = 0; leaf_index_chunk < BATCH_VEC_LEN<VC>(vec_index);
             leaf_index_chunk += LEAF_CHUNK_SIZE)
        {
            block_secpar<S> keys[LEAF_CHUNK_SIZE];
            for (size_t leaf_index_low = 0; leaf_index_low < LEAF_CHUNK_SIZE; ++leaf_index_low)
                keys[leaf_index_low] = tree[
                    BATCH_VEC_POS_IN_TREE<this_t>(vec_index, leaf_index_chunk + leaf_index_low)];

            write_leaves<TAU, DELTA_BITS, LEAF_CHUNK_SIZE, VOLE_WIDTH_SHIFT, leaf_hash_t>(
                leaf_iv, tweak, vec_index, keys, leaf_index_chunk, &permuted_leaf_idx, leaves, hashed_leaves);
        }

        // Currently leaves[0] and hashed_leaves[delta_i * leaf_hash_t::hash_len] contain garbage
        // because we don't know the keys on the active path. Fix them up.
        memset(&leaves[0], 0, sizeof(block_secpar<S>));
        memcpy(&hashed_leaves[delta_i * leaf_hash_t::hash_len],
               opening + leaf_hash_t::hash_len * vec_index, leaf_hash_t::hash_len);

        leaves += BATCH_VEC_LEN<VC>(vec_index);
        hashed_leaves += BATCH_VEC_LEN<VC>(vec_index) * leaf_hash_t::hash_len;
    }

    // opening is valid
    free(tree);
    return true;
}

template <typename BAVC>
bool grind_and_open(const block_secpar<BAVC::secpar_v>* __restrict__ forest,
                    const unsigned char* __restrict__ hashed_leaves,
                    uint8_t* __restrict__ delta_out, uint8_t* __restrict__ opening,
                    const hash_state_x4* hasher, uint32_t* counter_out)
{
    constexpr auto S = BAVC::secpar_v;
    constexpr size_t ZERO_BITS_IN_DELTA = secpar_to_bits(S) - BAVC::delta_bits_v;

    // We do four hashes in parallel to exploit the SIMD implementation of Keccak.
    constexpr size_t HASHES_IN_PARALLEL = 4;
    hash_state_x4 hasher_copy;

    uint32_t counter = 0;

    // Space for one counter of size 32 bit plus 1 byte for domain separation per hash. Padded.
    std::array<uint8_t, 8 * HASHES_IN_PARALLEL> counters;

    // Set domain separator byte for each counter.
    for (size_t i = 0; i < HASHES_IN_PARALLEL; ++i)
    {
        counters[i * 8 + 4] = 8 + 3;  // H_2^3
    }

    // Space for the computed hashes.
    std::array<std::array<uint8_t, secpar_to_bytes(S)>, HASHES_IN_PARALLEL> hashes;

    do
    {
        // Setup the counters.
        PRAGMA_UNROLL(4)
        for (size_t i = 0; i < HASHES_IN_PARALLEL; ++i, ++counter)
        {
            // We store the counters in little endian.
            PRAGMA_UNROLL(4)
            for (int j = 0; j < 4; ++j)
                counters[8 * i + j] = counter >> (8 * j);
        }

        // Make a copy of the hasher state.
        memcpy(&hasher_copy, hasher, sizeof(hasher_copy));
        // Hash the counters.
        hasher_copy.update_4(&counters[0], &counters[8], &counters[16], &counters[24], 5);
        // Produce digests.
        hasher_copy.finalize_4(hashes[0].data(), hashes[1].data(), hashes[2].data(),
                               hashes[3].data(), secpar_to_bytes(S));

        for (size_t i = 0; i < 4; i++)
        {
            const auto delta = hashes[i];

            static_assert(ZERO_BITS_IN_DELTA <= 64);
            // Check if Delta is of the right size, i.e., the hash ends with ZERO_BITS_IN_DELTA
            // zeros.
            if constexpr (ZERO_BITS_IN_DELTA > 0)
            {
                // Will be optimized into a single mov.
                uint64_t last_bits = 0;
                PRAGMA_UNROLL(8)
                for (int j = 0; j < 8; ++j)
                    last_bits |= (uint64_t)delta[secpar_to_bytes(S) - 8 + j] << (8 * j);

                if (last_bits >> (64 - ZERO_BITS_IN_DELTA))
                    continue;
            }

            // Convert Delta to the "one-byte-per-bit" form.
            std::array<uint8_t, BAVC::delta_bits_v> delta_bytes;
            expand_bits_to_bytes(delta_bytes.data(), BAVC::delta_bits_v, delta.data());

            // Try to open the commitment to the given Delta.
            bool b = BAVC::open(forest, hashed_leaves, delta_bytes.data(), opening);

            // If we found a successful opening, return with the corresponding Delta and the value
            // of the counter.
            if (BAVC::OPEN_ALWAYS_SUCCEEDS || b)
            {
                *counter_out = counter - 4 + i;
                memcpy(delta_out, delta.data(), secpar_to_bytes(S));
                return 1;
            }
        }
    } while (counter != 0);

    // Exhausted all possible counter values.
    return false;
}

template <typename PRG>
template <size_t num_keys>
void prg_leaf_hash<PRG>::hash(
    const key_t* keys_in, const iv_t& iv, tweak_t tweak, tweak_t small_tweak, key_t** keys_out,
    unsigned char* hashes_out)
{
    (void) small_tweak;

    block_secpar<secpar_v> prg_output[2 * num_keys];
    expand_chunk<num_keys, 2, PRG>(iv, tweak, keys_in, prg_output);

    for (size_t i = 0; i < num_keys; ++i)
    {
        memcpy(keys_out[i], &keys_in[i], sizeof(key_t));
        memcpy(&hashes_out[hash_len * i], &prg_output[i * 2], hash_len);
    }
}

template <typename PRG, size_t num_keys>
static void stat_binding_leaf_hash_impl(
    const typename PRG::key_t* keys_in, const typename PRG::iv_t& prg_iv,
    const std::array<poly_secpar<PRG::secpar_v>, 3>& hash_iv, typename PRG::tweak_t tweak,
    typename PRG::key_t** keys_out, unsigned char* hashes_out)
{
    static constexpr secpar secpar_v = PRG::secpar_v;
    static constexpr size_t hash_len = 3 * secpar_to_bytes(secpar_v);

    block_secpar<secpar_v> prg_output[4 * num_keys];
    expand_chunk<num_keys, 4, PRG>(prg_iv, tweak, keys_in, prg_output);

    poly64 modulus;
    if constexpr (secpar_v == secpar::s128)
        modulus = poly64::set_low32(gf384_modulus);
    else if constexpr (secpar_v == secpar::s192)
        modulus = poly64::set_low32(gf576_modulus);
    else if constexpr (secpar_v == secpar::s256)
        modulus = poly64::set_low32(gf768_modulus);
    else
        static_assert(0);

    for (size_t i = 0; i < num_keys; ++i)
    {
        std::array<poly_secpar<secpar_v>, 4> hash;
        for (int j = 0; j < 3; ++j)
            hash[j] = poly_secpar<secpar_v>::load(&prg_output[i * 4 + 1 + j]);
        hash[3] = poly_secpar<secpar_v>::set_zero();

        auto seed_poly = poly_secpar<secpar_v>::load(&prg_output[i * 4]);
        for (int j = 0; j < 3; ++j)
        {
            auto prod = seed_poly * hash_iv[j];
            hash[j] += prod.low_half();
            hash[j + 1] += prod.high_half();
        }

        auto reduced = poly_2secpar<secpar_v>::from(modulus * hash[3]);
        hash[0] += reduced.low_half();
        hash[1] += reduced.high_half();

        memcpy(keys_out[i], &prg_output[i * 4], secpar_to_bytes(secpar_v));
        for (int j = 0; j < 3; ++j)
            hash[j].store(&hashes_out[hash_len * i + secpar_to_bytes(secpar_v) * j]);
    }
}

template <secpar S>
template <size_t num_keys>
void shake_leaf_hash<S>::hash(
    const key_t* keys_in, const iv_t& iv, tweak_t tweak, tweak_t small_tweak, key_t** keys_out,
    unsigned char* hashes_out)
{
    (void) small_tweak;

    unsigned char shake_output[num_keys * 3 * secpar_to_bytes(secpar_v)];
    shake_prg_impl<S>(keys_in, iv, tweak, num_keys, 3 * secpar_to_bytes(secpar_v), shake_output);

    for (size_t i = 0; i < num_keys; ++i)
    {
        memcpy(keys_out[i], &shake_output[i * 3 * secpar_to_bytes(secpar_v)], sizeof(key_t));
        memcpy(&hashes_out[hash_len * i], &shake_output[(i * 3 + 1) * secpar_to_bytes(secpar_v)], hash_len);
    }
}

} // namespace faest

#endif
