#ifndef CRT_CONSTANTS_HPP
#define CRT_CONSTANTS_HPP

#include "block.hpp"
#include "parameters.hpp"
#include <array>
#include <cstddef>
#include <cstdint>

namespace faest
{

// For the CRT VOLECommit method, we need to multiply secret and public vectors
// and matrices with the following constant matrices `W`:
//
// - W_CRT: delta_bits x secpar (actually delta_bits x delta_bits since the last columns are zero)
// - W_TREE: delta_bits x secpar
// - W_GATE: n_mult x secpar
// - F: secpar x n_mult
// - G: delta_bits x n_mult
//
// Note that the matrices are transposed compared to the FAEST specification.  We use this notation
// to to apply the matrices to row vectors or matrices in row-major order by multiplication from the
// right (a * W or A * W).  When we talk about applying a matrix to columns, then we mean that the
// matrix A is stored in column-major order.
//
// This file defines a format for the constant matrices in preprocessed form which depends on a) if
// they are applied to rows or columns, and b) if they are applied to public or secret data. Note
// that we cannot use the latter as indices in lookup tables.

// (ROWS x COLUMNS) matrix in column-major order with N <= secpar to apply to row vectors.
// The rows are represented as array of 64-bit words.
template <size_t ROWS, size_t COLUMNS>
using lift_row_table_t = std::array<std::array<uint64_t, (COLUMNS + 63) / 64>, ROWS>;

// (ROWS x COLUMNS) matrix with COLUMNS <= secpar preprocessed to be used as *lookup tables* in the
// four russians method with 2^LOOKUP_BITS-sized lookup tables:
//
// - for K := LOOKUP_BITS
// - let the matrix W be split into (ROWS / K) chunks of K rows, each of length COLUMNS
// => W[i][x] contains the product of the ith chunk with the K-bit vector x
template <size_t ROWS, size_t COLUMNS, size_t LOOKUP_BITS>
using lift_public_row_lookup_table_t =
    std::array<std::array<std::array<uint64_t, (COLUMNS + 63) / 64>, 1 << LOOKUP_BITS>,
               (ROWS + LOOKUP_BITS - 1) / LOOKUP_BITS>;

// (N x N) matrix preprocessed to be used as *indices* in the four russians method with
// 2^LOOKUP_BITS-sized lookup tables:
// - for K := LOOKUP_BITS <= 8
// - let the matrix W be split vertically into (DELTA_BITS / K) chunks of K rows of length
//   DELTA_BITS each (the last chunk might consist of fewer rows)
// - each chunk is stored in column-major form
// => W[i][j] contains the LOOKUP_BITS bits in the jth column of the ith chunk
template <size_t ROWS, size_t COLUMNS, size_t LOOKUP_BITS>
    requires(LOOKUP_BITS <= 8)
using lift_columns_index_table_t =
    std::array<std::array<uint8_t, COLUMNS>, (ROWS + LOOKUP_BITS - 1) / LOOKUP_BITS>;

// This helper template will be defined by the generated headers.
template <secpar S, size_t TAU, size_t DELTA_BITS> struct N_MULT_TRAIT;

// (\secpar, \delta_bits, \tau) defines the CRT maps.
template <secpar S, size_t TAU, size_t DELTA_BITS>
    requires(DELTA_BITS <= secpar_to_bits(S))
struct CRT_CONSTANTS
{
  public:
    constexpr static auto secpar_v = S;
    constexpr static size_t SECPAR_BITS = secpar_to_bits(S);
    constexpr static size_t SECPAR_BYTES = secpar_to_bytes(S);
    constexpr static size_t SECPAR_QWORDS = SECPAR_BITS / 64;
    constexpr static auto delta_bits_v = DELTA_BITS;
    constexpr static size_t DELTA_BYTES = (DELTA_BITS + 7) / 8;
    constexpr static size_t ALIGNMENT = S == secpar::s192 ? 16 : SECPAR_BYTES;

    // N_MULT constant
    constexpr static std::size_t N_MULT = N_MULT_TRAIT<S, TAU, DELTA_BITS>::N_MULT;

    // Modulus polynomials
    inline static const std::array<uint64_t, TAU> DIV_X64_by_M_i;
    inline static const std::array<uint64_t, TAU> M_i;
    alignas(ALIGNMENT) static const std::array<uint8_t, SECPAR_BYTES> M_TREE;

    // W_CRT (delta_bits x delta_bits) in multiple forms
    // - to lift (secret) rows
    static const lift_row_table_t<DELTA_BITS, DELTA_BITS> W_CRT_LIFT_ROW_TAB;
    // - to lift (secret) columns
    constexpr static size_t W_CRT_LIFT_COLUMNS_LOOKUP_BITS = 4;
    static const lift_columns_index_table_t<DELTA_BITS, DELTA_BITS, W_CRT_LIFT_COLUMNS_LOOKUP_BITS>
        W_CRT_LIFT_COLUMNS_INDEX_TAB;
#ifdef FAEST_ENABLE_PUBLIC_ROW_LOOKUPS
    // - to lift public rows
    constexpr static size_t W_CRT_LIFT_PUBLIC_ROWS_LOOKUP_BITS = 4;
    alignas(ALIGNMENT) static const lift_public_row_lookup_table_t<
        DELTA_BITS, SECPAR_BITS,
        W_CRT_LIFT_PUBLIC_ROWS_LOOKUP_BITS> W_CRT_LIFT_PUBLIC_ROW_LOOKUP_TAB;
#endif

    // W_TREE (delta_bits x secpar) in multiple forms
    // - to lift (secret) rows
    static const lift_row_table_t<DELTA_BITS, SECPAR_BITS> W_TREE_LIFT_ROW_TAB;
#ifdef FAEST_ENABLE_PUBLIC_ROW_LOOKUPS
    // - to lift public rows
    constexpr static size_t W_TREE_LIFT_PUBLIC_ROWS_LOOKUP_BITS = 4;
    alignas(ALIGNMENT) static const lift_public_row_lookup_table_t<
        DELTA_BITS, SECPAR_BITS,
        W_TREE_LIFT_PUBLIC_ROWS_LOOKUP_BITS> W_TREE_LIFT_PUBLIC_ROW_LOOKUP_TAB;
#endif

    // W_GATE (n_mult x secpar) in multiple forms
    // - to lift (secret) rows
    static const lift_row_table_t<N_MULT, SECPAR_BITS> W_GATE_LIFT_ROW_TAB;
    // - to lift (secret) columns
    constexpr static size_t W_GATE_LIFT_COLUMNS_LOOKUP_BITS = 4;
    static const lift_columns_index_table_t<N_MULT, SECPAR_BITS, W_GATE_LIFT_COLUMNS_LOOKUP_BITS>
        W_GATE_LIFT_COLUMNS_INDEX_TAB;
#ifdef FAEST_ENABLE_PUBLIC_ROW_LOOKUPS
    // - to lift public rows
    constexpr static size_t W_GATE_LIFT_PUBLIC_ROWS_LOOKUP_BITS = 4;
    alignas(ALIGNMENT) static const lift_public_row_lookup_table_t<
        N_MULT, SECPAR_BITS, W_GATE_LIFT_PUBLIC_ROWS_LOOKUP_BITS> W_GATE_LIFT_PUBLIC_ROW_LOOKUP_TAB;
#endif

    // F (secpar x n_mult)
    // - to lift (secret) rows
    static const lift_row_table_t<SECPAR_BITS, N_MULT> F_LIFT_ROW_TAB;

    // G (delta_bits x n_mult)
    // - to lift (secret) columns
    constexpr static size_t G_LIFT_COLUMNS_LOOKUP_BITS = 4;
    static const lift_columns_index_table_t<DELTA_BITS, N_MULT, G_LIFT_COLUMNS_LOOKUP_BITS>
        G_LIFT_COLUMNS_INDEX_TAB;
    // - to lift (secret) rows
    static const lift_row_table_t<DELTA_BITS, N_MULT> G_LIFT_ROW_TAB;
};

} // namespace faest

// Include generated headers containing the template specializations
#include "generated_crt_constants.hpp"

#endif
