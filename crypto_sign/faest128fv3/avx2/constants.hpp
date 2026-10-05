#ifndef CONSTANTS_HPP
#define CONSTANTS_HPP

// Constants that are used in the implementation

#ifdef __AVX2__
#include "constants_impl.hpp"
#elifdef __aarch64__
#include "constants_impl.hpp"
#else
#error "unsupported architecture"
#endif

#include "crt_constants.hpp"
#include "parameters.hpp"

#include <variant>

namespace faest
{

template <std::size_t bits> struct block;
template <secpar S> using block_secpar = block<secpar_to_bits(S)>;
using block128 = block<128>;

// AES-related constants

// Number of AES rounds depending on the security parameter
template <secpar S>
constexpr std::size_t AES_ROUNDS = []
{
    if constexpr (S == secpar::s128)
    {
        return 10;
    }
    else if constexpr (S == secpar::s192)
    {
        return 12;
    }
    else if constexpr (S == secpar::s256)
    {
        return 14;
    }
    else
    {
        static_assert(false, "unsupported security parameter for AES");
    }
}();

// Number of Rijndael rounds depending on the security parameter
template <secpar S> constexpr std::size_t RIJNDAEL_ROUNDS = AES_ROUNDS<S>;

// Number of AES blocks to run in parallel, for maximum performance.
constexpr std::size_t AES_PREFERRED_WIDTH = (1 << AES_PREFERRED_WIDTH_SHIFT);

// Number of Rijndael256 blocks to run in parallel, for maximum performance.
constexpr std::size_t RIJNDAEL256_PREFERRED_WIDTH = (1 << RIJNDAEL256_PREFERRED_WIDTH_SHIFT);

// TODO: documentation, what about 192 bits?
template <secpar S>
constexpr std::size_t FIXED_KEY_PREFERRED_WIDTH_SHIFT = []
{
    if constexpr (S == secpar::s128)
    {
        return AES_PREFERRED_WIDTH_SHIFT;
    }
    else if constexpr (S == secpar::s256)
    {
        return RIJNDAEL256_PREFERRED_WIDTH_SHIFT;
    }
    else
    {
        static_assert(false, "unsupported security parameter for fixed-key AES");
    }
}();
template <secpar S>
constexpr std::size_t FIXED_KEY_PREFERRED_WIDTH = (1 << FIXED_KEY_PREFERRED_WIDTH_SHIFT<S>);

// Transpose-related constants
constexpr std::size_t TRANSPOSE_BITS_ROWS = 1 << TRANSPOSE_BITS_ROWS_SHIFT;

// Template containing constants that depend only on the security parameter and the one-way function
template <secpar S, owf O> struct OWF_CONSTANTS;

namespace detail
{

// Compute the number of key schedule constraints for an OWF.
template <secpar S, owf O> constexpr std::size_t compute_owf_num_key_schedule_constraints()
{
    using OC = OWF_CONSTANTS<S, O>;

    if constexpr (is_owf_with_zero_sboxes(O))
        return 2 * OC::OWF_KEY_SCHEDULE_SBOXES;
    else
        return OC::OWF_KEY_SCHEDULE_SBOXES;
}

// Compute the number of encryption constraints for an OWF.
template <secpar S, owf O> constexpr std::size_t compute_owf_num_enc_constraints()
{
    using OC = OWF_CONSTANTS<S, O>;

    if constexpr (is_owf_with_deg7_proof(O))
        return OC::OWF_BLOCKS * OC::OWF_BLOCK_SIZE * OC::OWF_ROUNDS / 2;
    else if constexpr (is_owf_with_norm_proof(O))
        return 3 * OC::OWF_BLOCKS * OC::OWF_BLOCK_SIZE * OC::OWF_ROUNDS / 2;
    else if constexpr (is_owf_with_zero_sboxes(O))
        return 2 * OC::OWF_BLOCKS * OC::OWF_BLOCK_SIZE * OC::OWF_ROUNDS;
    else
        return OC::OWF_BLOCKS * OC::OWF_BLOCK_SIZE * OC::OWF_ROUNDS;
}

template <secpar S, owf O> constexpr std::size_t compute_owf_key_witness_bits()
{
    using OC = OWF_CONSTANTS<S, O>;
    if constexpr (is_owf_with_aes_ecb(O))
        return secpar_to_bits(S) + 8 * OC::OWF_KEY_SCHEDULE_SBOXES;
    else if constexpr (is_owf_with_aes_em(O))
        return secpar_to_bits(S);
    else
        static_assert("unsupported OWF");
}

template <secpar S, owf O> constexpr std::size_t compute_owf_enc_witness_bits_per_block()
{
    using OC = OWF_CONSTANTS<S, O>;
    if constexpr (is_owf_with_deg7_proof(O))
        return 8 * (OC::OWF_BLOCK_SIZE * OC::OWF_ROUNDS / 2 - OC::OWF_BLOCK_SIZE);
    else if constexpr (is_owf_with_norm_proof(O))
        return 8 * (OC::OWF_BLOCK_SIZE * OC::OWF_ROUNDS * 3 / 4 - OC::OWF_BLOCK_SIZE);
    else
        return 8 * OC::OWF_BLOCK_SIZE * (OC::OWF_ROUNDS - 1);
}

template <secpar S, owf O> constexpr std::size_t compute_owf_witness_bits()
{
    using OC = OWF_CONSTANTS<S, O>;
    return OC::OWF_KEY_WITNESS_BITS + OC::OWF_BLOCKS * OC::OWF_ENC_WITNESS_BITS_PER_BLOCK;
}

// Compute the total number of constraints for an OWF.
template <secpar S, owf O> constexpr std::size_t compute_owf_num_constraints()
{
    std::size_t num_constraints =
        compute_owf_num_key_schedule_constraints<S, O>() + compute_owf_num_enc_constraints<S, O>();

    if constexpr (is_owf_with_shrunk_keyspace(O))
        num_constraints += 1;

    if constexpr (is_owf_with_witness_bits_check(O))
        num_constraints += compute_owf_witness_bits<S, O>();

    return num_constraints;
}

} // namespace detail

// Specialization: Constants for the AES-ECB one-way function
template <secpar S, owf O>
    requires(is_owf_with_aes_ecb(O))
struct OWF_CONSTANTS<S, O>
{
    // Number of applications of the round function per encryption (need OWF_ROUNDS + 1 round keys).
    constexpr static std::size_t OWF_ROUNDS = AES_ROUNDS<S>;
    // Block size of the cipher
    constexpr static std::size_t OWF_BLOCK_SIZE = 16;
    // Number of blocks encrypted in the OWF.
    // (1 for 128 bit, 2 for 192/256 bit to compensate for the 128 bit block size)
    constexpr static std::size_t OWF_BLOCKS = (secpar_to_bits(S) + 127) / 128;
    // Spacing in bytes of the sub_words operation in the key schedule.
    constexpr static std::size_t OWF_KEY_SCHEDULE_PERIOD = []
    {
        if constexpr (S == secpar::s256)
        {
            return 16;
        }
        else
        {
            return secpar_to_bytes(S);
        }
    }();
    // Number of S-boxes in the key schedule.
    constexpr static std::size_t OWF_KEY_SCHEDULE_SBOXES =
        4 * (((AES_ROUNDS<S> + 1) * 16 - secpar_to_bytes(S) + OWF_KEY_SCHEDULE_PERIOD - 1) /
             OWF_KEY_SCHEDULE_PERIOD);
    // Number of constraints in the key schedule.
    constexpr static std::size_t OWF_KEY_SCHEDULE_CONSTRAINTS =
        detail::compute_owf_num_key_schedule_constraints<S, O>();
    constexpr static std::size_t OWF_KEY_WITNESS_BITS =
        detail::compute_owf_key_witness_bits<S, O>();
    // Number of S-boxes in the encryption.
    constexpr static std::size_t OWF_ENC_SBOXES = OWF_BLOCK_SIZE * OWF_ROUNDS;
    constexpr static std::size_t OWF_ENC_CONSTRAINTS =
        detail::compute_owf_num_enc_constraints<S, O>();
    constexpr static std::size_t OWF_ENC_WITNESS_BITS_PER_BLOCK =
        detail::compute_owf_enc_witness_bits_per_block<S, O>();
    constexpr static std::size_t OWF_ENC_WITNESS_BITS = OWF_BLOCKS * OWF_ENC_WITNESS_BITS_PER_BLOCK;

    constexpr static std::size_t OWF_NUM_CONSTRAINTS = detail::compute_owf_num_constraints<S, O>();
    constexpr static std::size_t WITNESS_BITS = detail::compute_owf_witness_bits<S, O>();
    constexpr static std::size_t QS_DEGREE = []
    {
        if constexpr (is_owf_with_deg7_proof(O))
            return 7;
        else if constexpr (is_owf_with_norm_proof(O))
            return 3;
        else
            return 2;
    }();

    using block_t = block128;

    constexpr static bool valid = true;
};

// Specialization: Constants for the AES-EM one-way function
template <secpar S, owf O>
    requires(is_owf_with_aes_em(O))
struct OWF_CONSTANTS<S, O>
{
    constexpr static std::size_t OWF_KEY_SCHEDULE_SBOXES = 0;
    constexpr static std::size_t OWF_KEY_SCHEDULE_CONSTRAINTS = 0;
    constexpr static std::size_t OWF_KEY_WITNESS_BITS = secpar_to_bits(S);
    constexpr static std::size_t OWF_BLOCK_SIZE = secpar_to_bytes(S);
    constexpr static std::size_t OWF_BLOCKS = 1;
    constexpr static std::size_t OWF_ROUNDS = []
    {
        if constexpr (S == secpar::s128)
            return AES_ROUNDS<S>;
        else if constexpr (S == secpar::s192)
            return RIJNDAEL_ROUNDS<S>;
        else if constexpr (S == secpar::s256)
            return RIJNDAEL_ROUNDS<S>;
    }();
    constexpr static std::size_t OWF_ENC_SBOXES = OWF_BLOCK_SIZE * OWF_ROUNDS;
    constexpr static std::size_t OWF_ENC_CONSTRAINTS =
        detail::compute_owf_num_enc_constraints<S, O>();
    constexpr static std::size_t OWF_ENC_WITNESS_BITS_PER_BLOCK =
        detail::compute_owf_enc_witness_bits_per_block<S, O>();
    constexpr static std::size_t OWF_ENC_WITNESS_BITS = OWF_BLOCKS * OWF_ENC_WITNESS_BITS_PER_BLOCK;

    constexpr static std::size_t OWF_NUM_CONSTRAINTS = detail::compute_owf_num_constraints<S, O>();
    constexpr static std::size_t WITNESS_BITS = detail::compute_owf_witness_bits<S, O>();
    constexpr static std::size_t QS_DEGREE = []
    {
        if constexpr (is_owf_with_deg7_proof(O))
            return 7;
        else if constexpr (is_owf_with_norm_proof(O))
            return 3;
        else
            return 2;
    }();

    using block_t = block_secpar<S>;

    constexpr static bool valid = true;
};

// Constants for the QuickSilver implementation
template <secpar S, size_t max_deg> struct QS_CONSTANTS
{
    // Number of whole-field VOLEs needed for the QuickSilver masks.
    constexpr static size_t NUM_MASKS = max_deg - 1;
    constexpr static size_t CHALLENGE_BYTES = ((3 * secpar_to_bits(S) + 64) / 8);
    constexpr static size_t PROOF_BYTES = (max_deg - 1) * secpar_to_bytes(S);
    constexpr static size_t CHECK_BYTES = secpar_to_bytes(S);

    constexpr static bool valid = true;
};

template <secpar S, bool crt_vole_check> struct VOLE_CHECK_CONSTANTS;

// Constants for the classic VOLE check (for FAEST version <= 2)
template <secpar S> struct VOLE_CHECK_CONSTANTS<S, false>
{
    // - extra VOLEs to mask the VOLEHash
    constexpr static std::size_t HASH_VOLES = secpar_to_bits(S) + 16;
    constexpr static std::size_t HASH_BYTES = HASH_VOLES / 8;
    // - size of the challenge, i.e., the universal hash functions
    constexpr static std::size_t CHALLENGE_BYTES = (5 * secpar_to_bits(S) + 64) / 8;
    // - size of the universal hash
    constexpr static std::size_t PROOF_BYTES = HASH_BYTES;
    // - unused
    [[deprecated]] constexpr static std::size_t CHECK_BYTES = 2 * secpar_to_bytes(S);

    static_assert(HASH_VOLES % 8 == 0, "HASH_VOLES needs to be a multiple of 8");
    constexpr static bool valid = true;
};

template <secpar S> struct VOLE_CHECK_CONSTANTS<S, true>
{
    // - number of whole-field VOLEs to mask the check
    constexpr static std::size_t NUM_MASKS = 4;
    // - size of the challenge, i.e., the universal hash functions
    constexpr static std::size_t CHALLENGE_BYTES = (8 * secpar_to_bits(S) + 64) / 8;
    // - size of the VOLE hash
    constexpr static std::size_t HASH_BYTES = 4 * secpar_to_bytes(S);
    constexpr static std::size_t PROOF_BYTES = HASH_BYTES;

    constexpr static bool valid = true;
};

// Constants related to the vector commitments
template <size_t TAU, size_t DELTA_BITS> struct VECTOR_COMMITMENT_CONSTANTS
{
    constexpr static size_t tau_v = TAU;
    constexpr static size_t delta_bits_v = DELTA_BITS;

    // The homomorphic commitments use small field VOLE with a mix of two values of k: MIN_K and
    // MAX_K. k is the number of bits of Delta input to a single VOLE.
    constexpr static std::size_t MAX_K = (DELTA_BITS / TAU) + 1; // floor(DELTA_BITS / TAU) + 1
    constexpr static std::size_t MIN_K = MAX_K - 1;

    // Number of VOLEs that use MIN_K and MAX_K.
    constexpr static std::size_t NUM_MAX_K = DELTA_BITS % TAU;
    constexpr static std::size_t NUM_MIN_K = TAU - NUM_MAX_K;

    // The largest k that is actually used. Use this instead of MAX_K for example if you need the
    // largest k for an array size.
    constexpr static std::size_t MAX_USED_K = (NUM_MAX_K > 0) ? MAX_K : MIN_K;

    // Compile-time sanity checks
    static_assert(NUM_MIN_K > 0, "NUM_MIN_K (\\tau_0) must be positive");
    static_assert((NUM_MAX_K == 0) || (MAX_K == MIN_K + 1),
                  "If NUM_MAX_K > 0, then MAX_K (k) must me one more than MIN_K (k-1)");
    static_assert(NUM_MAX_K + NUM_MIN_K == TAU, "We want \\tau trees in total");
    static_assert(NUM_MAX_K * MAX_K + NUM_MIN_K * MIN_K == DELTA_BITS,
                  "The overall bit size should be delta_bits");
    constexpr static bool valid = true;
};

// Implementation constants that depend on the parameter set
template <typename P> struct CONSTANTS
{

    using QS = QS_CONSTANTS<P::secpar_v, P::OWF_CONSTS::QS_DEGREE>;
    using VOLE_CHECK = VOLE_CHECK_CONSTANTS<P::secpar_v, P::use_crt_vole_masks>;
    using VEC_COM = VECTOR_COMMITMENT_CONSTANTS<P::tau_v, P::delta_bits_v>;
    static_assert(QS::valid, "QS is invalid");
    static_assert(VOLE_CHECK::valid, "VOLE_CHECK is invalid");
    static_assert(VEC_COM::valid, "VEC_COM is invalid");

    // VOLE-related constants
    // - Size of a `vole_block` in multiples of 128 bit.
    constexpr static std::size_t VOLE_BLOCK = 1 << VOLE_BLOCK_SHIFT;
    // - Size of the witness as number of `vole_block`s.
    constexpr static std::size_t WITNESS_BLOCKS =
        (P::OWF_CONSTS::WITNESS_BITS + 128 * VOLE_BLOCK - 1) / (128 * VOLE_BLOCK);

    // - Number of VOLEs needed for QuickSilver (witness + mask).
    // XXX: for CRT VOLE, we compute the mask in a different way, so maybe don't count it here
    constexpr static std::size_t QUICKSILVER_ROWS = []
    {
        if constexpr (P::use_crt_vole_masks)
            return P::OWF_CONSTS::WITNESS_BITS;
        else
            return P::OWF_CONSTS::WITNESS_BITS + QS::NUM_MASKS * P::secpar_bits;
    }();
    // - The transpose before QuickSilver requires padding to a multiple of TRANSPOSE_BITS_ROWS.
    //   If a `vole_block` is larger, we need more padding.
    constexpr static std::size_t QUICKSILVER_ROW_PAD_TO =
        (128 * VOLE_BLOCK > TRANSPOSE_BITS_ROWS) ? (128 * VOLE_BLOCK) : TRANSPOSE_BITS_ROWS;
    // - The number of VOLEs padded for QuickSilver.
    constexpr static std::size_t QUICKSILVER_ROWS_PADDED =
        ((QUICKSILVER_ROWS + QUICKSILVER_ROW_PAD_TO - 1) / QUICKSILVER_ROW_PAD_TO) *
        QUICKSILVER_ROW_PAD_TO;

    constexpr static std::size_t CRT_NUM_MASK = []
    {
        if constexpr (P::use_crt_vole_masks)
            return QS::NUM_MASKS + VOLE_CHECK::NUM_MASKS;
        else
            return 0;
    }();
    using CRT_CONSTS =
        std::conditional_t<P::use_crt_vole_masks,
                           CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>, std::monostate>;
    constexpr static std::size_t CRT_NUM_MULT = []
    {
        if constexpr (P::use_crt_vole_masks)
            return CRT_CONSTS::N_MULT;
        else
            return 0;
    }();
    // size of CRT_NUM_MULT bits packed into bites
    constexpr static std::size_t CRT_NUM_MULT_BYTES = (CRT_NUM_MULT + 7) / 8;
    constexpr static std::size_t CRT_CMULT_SIZE_BYTES = CRT_NUM_MASK * CRT_NUM_MULT_BYTES;

    // - Total number of VOLEs needed, including for the QuickSilver masks and the VOLE check.
    constexpr static std::size_t VOLE_ROWS = []
    {
        if constexpr (P::use_crt_vole_masks)
            return QUICKSILVER_ROWS + CRT_NUM_MASK * VEC_COM::MAX_USED_K;
        else
            return QUICKSILVER_ROWS + VOLE_CHECK::HASH_BYTES * 8;
    }();
    // - Number of bytes needed to represent all VOLEs
    constexpr static std::size_t VOLE_BYTES = (VOLE_ROWS + 7) / 8;
    // Number of VOLE rows to correct:
    // - For version <= 2, we correct the small VOLEs to the same bit for all rows, and then compose
    //   secpar rows into a VOLE over F_2^secpar for each masking term.
    // - With the CRT method (for version >= 3), we will only correct VOLES corresponding to the
    //   witness bits, but not the additional rows for the masking terms.
    constexpr static std::size_t VOLE_CORRECTION_ROWS = []
    {
        if constexpr (P::use_crt_vole_masks)
            return QUICKSILVER_ROWS;
        else
            return VOLE_ROWS;
    }();
    constexpr static std::size_t VOLE_CORRECTION_BYTES = VOLE_CORRECTION_ROWS / 8;
    constexpr static std::size_t VOLE_CORRECTION_BLOCKS =
        (VOLE_CORRECTION_ROWS + 128 * VOLE_BLOCK - 1) / (128 * VOLE_BLOCK);

    // - Number of additional, uncorected VOLEs in byte.
    constexpr static std::size_t VOLE_EXTRA_BYTES = VOLE_BYTES - VOLE_CORRECTION_BYTES;

    // We need to pad the VOLE_ROWS for the transpose
    // - Length of a VOLE column padded to a multiple of max(size of a vole_block,
    // TRANSPOSE_BITS_ROWS)
    constexpr static std::size_t VOLE_ROWS_PAD_TO =
        (128 * VOLE_BLOCK > TRANSPOSE_BITS_ROWS) ? (128 * VOLE_BLOCK) : TRANSPOSE_BITS_ROWS;
    constexpr static std::size_t VOLE_ROWS_PADDED =
        ((VOLE_ROWS + VOLE_ROWS_PAD_TO - 1) / VOLE_ROWS_PAD_TO) * VOLE_ROWS_PAD_TO;

    // - Length of a padded VOLE column (in blocks)
    constexpr static std::size_t VOLE_COL_BLOCKS =
        (VOLE_ROWS_PADDED + 128 * VOLE_BLOCK - 1) / (128 * VOLE_BLOCK);
    // - Length of a VOLE column padded to full blocks (in bytes)
    constexpr static std::size_t VOLE_COL_STRIDE = VOLE_COL_BLOCKS * 16 * VOLE_BLOCK;

    // vole-commit-related constants
    constexpr static std::size_t VOLE_COMMIT_CORRECTIONS_SIZE =
        VOLE_CORRECTION_BYTES * (P::tau_v - 1);
    constexpr static std::size_t VOLE_COMMIT_CMULT_SIZE =
        P::use_crt_vole_masks ? CRT_CMULT_SIZE_BYTES : 0;
    constexpr static std::size_t VOLE_COMMIT_SIZE =
        VOLE_COMMIT_CORRECTIONS_SIZE + VOLE_COMMIT_CMULT_SIZE;
    constexpr static std::size_t VOLE_COMMIT_CHECK_SIZE = 2 * P::secpar_bytes;

    constexpr static std::size_t PRG_VOLE_BLOCK_SIZE_SHIFT = []
    {
        if constexpr (P::vole_prg_v == prg::rijndael_fixed_key_ctr && P::secpar_v == secpar::s256)
            return 1;
        else
            return 0;
    }();
    // Number of block128s in a prg_vole_block.
    constexpr static std::size_t PRG_VOLE_BLOCK_SIZE = 1 << PRG_VOLE_BLOCK_SIZE_SHIFT;

    // Number of prg_vole_block in a vole_block.
    constexpr static std::size_t PRG_VOLE_BLOCKS_SHIFT =
        VOLE_BLOCK_SHIFT - PRG_VOLE_BLOCK_SIZE_SHIFT;
    constexpr static std::size_t PRG_VOLE_BLOCKS = 1 << PRG_VOLE_BLOCKS_SHIFT;

    // VOLE is performed in chunks of VOLE_WIDTH keys, with each column consisting of 1
    // vole_block.
    constexpr static std::size_t VOLE_WIDTH_SHIFT =
        AES_PREFERRED_WIDTH_SHIFT - PRG_VOLE_BLOCKS_SHIFT;
    constexpr static std::size_t VOLE_WIDTH = 1 << VOLE_WIDTH_SHIFT;

    // Compile-time consistency checks
    static_assert(P::OWF_CONSTS::WITNESS_BITS % 8 == 0,
                  "The witness size needs to be divisible by 8.");
    // static_assert(VOLE_ROWS % 8 == 0, "VOLE_ROWS needs to be divisible by 8.");
    static_assert(VOLE_CORRECTION_ROWS % 8 == 0,
                  "VOLE_CORRECTION_ROWS needs to be divisible by 8.");
    static_assert(VOLE_CORRECTION_ROWS <= VOLE_ROWS,
                  "We cannot correct more VOLE rows than we have.");
    static_assert(VOLE_ROWS_PADDED % (128 * VOLE_BLOCK) == 0,
                  "VOLE_ROWS_PADDED should be padded to a muliple of `vole_block` size");
    static_assert(VOLE_ROWS_PADDED % TRANSPOSE_BITS_ROWS == 0,
                  "VOLE_ROWS_PADDED should be padded to a muliple of `TRANSPOSE_BITS_ROWS`");
    // static_assert(PRG_VOLE_BLOCK_SIZE * 16 == sizeof(typename P::vole_prg_t::block_t), "a
    // `P::vole_prg_t::block_t` must be 16 * PRG_VOLE_BLOCK_SIZE");

    constexpr static bool valid = true;
};

} // namespace faest

#endif
