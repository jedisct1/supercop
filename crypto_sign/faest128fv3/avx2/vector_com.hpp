#ifndef VECTOR_COM_HPP
#define VECTOR_COM_HPP

#include "block.hpp"
#include "constants.hpp"
#include "polynomials.hpp"

namespace faest
{

// We implement batched all-but-one vector commitments (BAVCs) based on GGM trees.
//
// They are parameterized by
// - S, the security parameter,
// - TAU, the number of trees,
// - DELTA_BITS, the total size of the TAU indices
// - PRG used for inner nodes,
// - PRG used for the leaf nodes,
// - VOLE_WIDTH_SHIFT, a constant defined by other parameters (see constants.hpp),
//
// and provide the following interface
// - COMMIT_LEAVES
// - COMMIT_NODES
// - OPEN_BITS
// - OPEN_SIZE
// - OPEN_ALWAYS_SUCCEEDS
// - commit
// - open
// - verify
//
// The commitments are to TAU vectors v_i such that sum_i log(v_i) = secpar whose total length
// matches the security parameter. secpar_bits-many vectors split into TAU subvectors each of the

// BAVC based on TAU separate GGM trees.
template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT>
struct ggm_forest_bavc
{
    static_assert(DELTA_BITS <= secpar_to_bits(S), "invalid value of DELTA_BITS");

    using CONSTS = VECTOR_COMMITMENT_CONSTANTS<TAU, DELTA_BITS>;
    constexpr static auto secpar_v = S;
    constexpr static auto tau_v = TAU;
    constexpr static auto delta_bits_v = DELTA_BITS;
    constexpr static auto delta_bytes_v = (delta_bits_v + 7) / 8;
    constexpr static auto vole_width_shift_v = VOLE_WIDTH_SHIFT;
    using tree_prg_t = prg_type_t<S, TREE_PRG>;
    using leaf_hash_t = leaf_hash_type_t<S, TAU, LEAF_HASH>;

    // Number of leave nodes in all trees.
    constexpr static std::size_t COMMIT_LEAVES =
        (CONSTS::NUM_MIN_K << CONSTS::MIN_K) + (CONSTS::NUM_MAX_K << CONSTS::MAX_K);
    // Total number of nodes of all trees.
    constexpr static std::size_t COMMIT_NODES = 2 * COMMIT_LEAVES - TAU;
    // Size of commitment opening in bytes.
    // - DELTA_BITS seeds each of size S and TAU hashes for the unopened leaves of size
    //   leaf_hash_t::hash_len each
    constexpr static std::size_t OPEN_SIZE =
        DELTA_BITS * secpar_to_bytes(S) + TAU * leaf_hash_t::hash_len;

    // Indicates whether open can fail.
    constexpr static bool OPEN_ALWAYS_SUCCEEDS = true;

    // The GGM trees are all expanded from seed. leaves must be COMMIT_LEAVES blocks long, while
    // hashed_leaves must be COMMIT_LEAVES * leaf_hash_t::hash_len bytes long. forest must be
    // COMMIT_NODES blocks long. leaves (but not hashed_leaves) will be permuted according to
    // vole_permute_key_index.
    static void commit(const block_secpar<S> seed, block128 iv,
                       block_secpar<S>* __restrict__ forest, block_secpar<S>* __restrict__ leaves,
                       unsigned char* __restrict__ hashed_leaves);

    /// Create vector commitments given the roots instead of deriving the roots from a seed.
    /// Same interface as `commit`, except that
    /// - `roots` is of length `TAU`
    static void commit_from_roots(block_secpar<S>* roots, block128 iv,
                                  block_secpar<S>* __restrict__ forest,
                                  block_secpar<S>* __restrict__ leaves,
                                  unsigned char* __restrict__ hashed_leaves);

    // Using decommitment data from commit, open at delta. delta is represented as delta_bytes_v
    // bytes, each 0 or 0xff, with each segment (corresponding to a single VOLE) ordered in little
    // endian. opening must be OPEN_SIZE bytes long.
    // Returns if opening was successful (always true for ggm_forest).
    static bool open(const block_secpar<S>* __restrict__ forest,
                     const unsigned char* __restrict__ hashed_leaves,
                     const uint8_t* __restrict__ delta, uint8_t* __restrict__ opening);

    // Given an opening, get all but one of the leaves and all of the hashed leaves. The
    // hashed_leaves must be verified against the output from commit. leaves will be permuted
    // according to delta first, then vole_permute_key_index.
    // Returns if opening was well-formed.
    static bool verify(block128 iv, const uint8_t* __restrict__ opening,
                       const uint8_t* __restrict__ delta, block_secpar<S>* __restrict__ leaves,
                       unsigned char* __restrict__ hashed_leaves);
};

// BAVC based on the one-tree method.
template <secpar S, size_t TAU, size_t DELTA_BITS, prg TREE_PRG, leaf_hash LEAF_HASH,
          size_t VOLE_WIDTH_SHIFT, size_t OPENING_SEEDS_THRESHOLD>
struct one_tree_bavc
{
    static_assert(DELTA_BITS <= secpar_to_bits(S), "invalid value of DELTA_BITS");

    using CONSTS = VECTOR_COMMITMENT_CONSTANTS<TAU, DELTA_BITS>;
    constexpr static auto secpar_v = S;
    constexpr static auto tau_v = TAU;
    constexpr static auto delta_bits_v = DELTA_BITS;
    constexpr static auto delta_bytes_v = (delta_bits_v + 7) / 8;
    constexpr static auto vole_width_shift_v = VOLE_WIDTH_SHIFT;
    constexpr static auto opening_seeds_threshold_v = OPENING_SEEDS_THRESHOLD;
    using tree_prg_t = prg_type_t<S, TREE_PRG>;
    using leaf_hash_t = leaf_hash_type_t<S, TAU, LEAF_HASH>;
    using this_t = one_tree_bavc<S, TAU, DELTA_BITS, TREE_PRG, LEAF_HASH, VOLE_WIDTH_SHIFT, OPENING_SEEDS_THRESHOLD>;

    // Number of leave nodes in all trees.
    constexpr static std::size_t COMMIT_LEAVES =
        (CONSTS::NUM_MIN_K << CONSTS::MIN_K) + (CONSTS::NUM_MAX_K << CONSTS::MAX_K);
    // Total number of nodes of all trees.
    constexpr static std::size_t COMMIT_NODES = 2 * COMMIT_LEAVES - 1;
    // Size of commitment opening in bytes.
    constexpr static std::size_t OPEN_SIZE =
        (TAU * leaf_hash_t::hash_len + opening_seeds_threshold_v * secpar_to_bytes(S));

    // Indicates whether open can fail.
    constexpr static bool OPEN_ALWAYS_SUCCEEDS = false;

    static void commit(const block_secpar<S> seed, block128 iv, block_secpar<S>* __restrict__ tree,
                       block_secpar<S>* __restrict__ leaves,
                       unsigned char* __restrict__ hashed_leaves);

    static bool open(const block_secpar<S>* __restrict__ tree,
                     const unsigned char* __restrict__ hashed_leaves,
                     const uint8_t* __restrict__ delta, unsigned char* __restrict__ opening);

    static bool verify(block128 iv, const unsigned char* __restrict__ opening,
                       const uint8_t* __restrict__ delta, block_secpar<S>* __restrict__ leaves,
                       unsigned char* __restrict__ hashed_leaves);
};

struct hash_state_x4;

// Hashing the given message concatenated with increasing counter values until the hash ends with
// the right number of zeros.  Take the hash as Delta and try opening the commitment.  If
// unsuccessful continue hashing to find a new Delta.
// - forest: same as in open
// - hashed_leaves: same as in open
// - delta_out:
//  - now an output parameter (if successful),
//  - and compressed of size BAVC::delta_bytes_v bytes
// - opening: same as in open
// - message: pointer to hash input
// - message_len: length of hash input
// - out_counter: output parameter for the counter (if successful)
// Return false if 2^32 counter values have been exhausted without finding a suitable Delta.

template <typename BAVC>
bool grind_and_open(const block_secpar<BAVC::secpar_v>* __restrict__ forest,
                    const unsigned char* __restrict__ hashed_leaves,
                    uint8_t* __restrict__ delta_out, uint8_t* __restrict__ opening,
                    const hash_state_x4* hasher, uint32_t* counter_out);

/* Interface for leaf hashes:

struct leaf_hash
{
    static constexpr secpar secpar_v = secpar::s256;
    static constexpr size_t hash_len = 2 * secpar_to_bytes(secpar_v);
    using iv_t = block128;
    using key_t = block_secpar<secpar_v>;
    using tweak_t = uint32_t;

    // log2(Preferred # of keys to hash at once.)
    static constexpr size_t PREFERRED_WIDTH_SHIFT = 2;
    static constexpr size_t PREFERRED_WIDTH = 1 << PREFERRED_WIDTH_SHIFT;

    template <size_t num_keys>
    static void hash(const key_t* keys_in, iv_t iv, tweak_t tweak,
                     key_t** keys_out, unsigned char* hashes_out);
};
*/

// Hash based on assuming that a PRG is collision resistant. First secpar bits become the output
// key, then the subsequent 2 secpar bits become the hash.
template <typename PRG>
struct prg_leaf_hash
{
    static constexpr secpar secpar_v = PRG::secpar_v;
    static constexpr size_t hash_len = 2 * secpar_to_bytes(secpar_v);
    using iv_t = PRG::iv_t;
    using key_t = block_secpar<secpar_v>;
    using tweak_t = uint32_t;

    static constexpr size_t PREFERRED_WIDTH_SHIFT = PRG::PREFERRED_WIDTH_SHIFT - 1;
    static constexpr size_t PREFERRED_WIDTH = 1 << PREFERRED_WIDTH_SHIFT;

    template <size_t num_keys>
    static void hash(const key_t* keys_in, const iv_t& iv, tweak_t tweak, tweak_t small_tweak,
                     key_t** keys_out, unsigned char* hashes_out);
};

void stat_binding_leaf_hash_iv_impl(secpar secpar_v, const block128& prg_iv, unsigned char* hash_iv,
                                    uint32_t max_tweaks);

template <typename PRG, size_t num_keys>
static void stat_binding_leaf_hash_iv_impl(
    const typename PRG::key_t* keys_in, const typename PRG::iv_t& prg_iv,
    const std::array<poly_secpar<PRG::secpar_v>, 3>& hash_iv, typename PRG::tweak_t tweak,
    typename PRG::key_t** keys_out, unsigned char* hashes_out);

// Leaf hash based on a PRG, which uses a universal hash to make it statistically binding.  The
// resulting hash are each 3 secpar bits long. This requires an iv consisting of a PRG iv and a 3
// secpar bit universal hash.
//
// If SAME_HASH is true, we use the same universal hash function for all `small_tweak`s.
template <typename PRG, uint32_t MAX_TWEAKS_, bool SAME_HASH>
struct stat_binding_leaf_hash
{
    static constexpr auto MAX_TWEAKS = SAME_HASH ? 1 : MAX_TWEAKS_;
    static constexpr secpar secpar_v = PRG::secpar_v;
    static constexpr size_t hash_len = 3 * secpar_to_bytes(secpar_v);
    using key_t = block_secpar<secpar_v>;
    using tweak_t = uint32_t;

    struct iv_t
    {
        PRG::iv_t prg_iv;
        std::array<std::array<poly_secpar<secpar_v>, 3>, MAX_TWEAKS> universal_hash;

        explicit iv_t(PRG::iv_t prg_iv_) : prg_iv(prg_iv_)
        {
            std::array<uint8_t, MAX_TWEAKS * 3 * secpar_to_bytes(secpar_v)> hash_iv;
            stat_binding_leaf_hash_iv_impl(secpar_v, prg_iv, hash_iv.data(), MAX_TWEAKS);

            for (uint32_t t = 0; t < MAX_TWEAKS; ++t)
                for (int j = 0; j < 3; ++j)
                    universal_hash[t][j] = poly_secpar<secpar_v>::load(
                        &hash_iv[(3 * t + j) * secpar_to_bytes(secpar_v)]);
        }
    };

    static constexpr size_t PREFERRED_WIDTH_SHIFT = PRG::PREFERRED_WIDTH_SHIFT - 1;
    static constexpr size_t PREFERRED_WIDTH = 1 << PREFERRED_WIDTH_SHIFT;

    template <size_t num_keys>
    static void hash(const key_t* keys_in, const iv_t& iv, tweak_t tweak, tweak_t small_tweak,
                     key_t** keys_out, unsigned char* hashes_out)
    {
        if constexpr (SAME_HASH)
        {
            (void)small_tweak;
            stat_binding_leaf_hash_impl<PRG, num_keys>(keys_in, iv.prg_iv, iv.universal_hash[0],
                                                       tweak, keys_out, hashes_out);
        }
        else
        {
            FAEST_ASSERT(small_tweak < MAX_TWEAKS);
            stat_binding_leaf_hash_impl<PRG, num_keys>(
                keys_in, iv.prg_iv, iv.universal_hash[small_tweak], tweak, keys_out, hashes_out);
        }
    }
};

// Leaf hash based on shake. First secpar bits become the output key, then the subsequent 2 secpar
// bits become the hash.
template <secpar S> struct shake_leaf_hash
{
    static constexpr secpar secpar_v = S;
    static constexpr size_t hash_len = 2 * secpar_to_bytes(secpar_v);
    using iv_t = block128;
    using key_t = block_secpar<secpar_v>;
    using tweak_t = uint32_t;

    static constexpr size_t PREFERRED_WIDTH_SHIFT = 2;
    static constexpr size_t PREFERRED_WIDTH = 1 << PREFERRED_WIDTH_SHIFT;

    template <size_t num_keys>
    static void hash(const key_t* keys_in, const iv_t& iv, tweak_t tweak, tweak_t small_tweak,
                     key_t** keys_out, unsigned char* hashes_out);
};

} // namespace faest

#endif
