#ifndef CRT_VOLE_HELPERS_INC
#define CRT_VOLE_HELPERS_INC

#include "block.hpp"
#include "crt_constants.hpp"
#include "util.hpp"
#include <array>

namespace faest
{

struct split_t
{
    size_t K_MAX;
    size_t N_MAX;
    size_t K_MIN;
    size_t N_MIN;
};

// Compute how to best split N into terms of size at most K.
consteval split_t even_split(size_t N, size_t K)
{
    // number of terms
    const size_t M = (N + K - 1) / K;
    const size_t S = N / M;
    const size_t R = N % M;
    return {S + 1, R, S, M - R};
}

// constexpr implementation of count_trailing_zeros.
constexpr size_t ctz(size_t x)
{
    for (size_t i = 0; i < 8 * sizeof(x); ++i, x >>= 1)
        if (x & 1)
            return i;
    return 8 * sizeof(x);
}

template <size_t K_MAX, bool SMALL = (K_MAX <= 4)> struct gray_lookup_table_builder;

template <size_t K_MAX> struct gray_lookup_table_builder<K_MAX, false>
{
    template <typename OB, size_t N> using table_t = std::array<std::array<OB, N>, 1 << K_MAX>;

    struct setup_t
    {
        std::array<size_t, 1 << K_MAX> bit_flips;
        std::array<size_t, 1 << K_MAX> codewords;
    };

    // Output array A of length 2^K such that A[i] is the index of the bit that changes from the
    // (i-1)th to the ith code word.
    //
    // Example with K=4:
    //
    // idx  codeword    A[i]
    // ---------------------------------
    //  0   0000 =  0    3
    //  1   0001 =  1    0   = ctz(1) = 0
    //  2   0011 =  3    1   = ctz(2) = 1
    //  3   0010 =  2    0   = ctz(3) = 0
    //  4   0110 =  6    2   = ctz(4) = 2
    //  5   0111 =  7    0   = ctz(5) = 0
    //  6   0101 =  5    1   = ctz(6) = 1
    //  7   0100 =  4    0   = ctz(7) = 0
    //  8   1100 = 12    3   = ctz(8) = 3
    //  9   1101 = 13    0   = ctz(9) = 0
    // 10   1111 = 15    1   = ctz(10) = 1
    // 11   1110 = 14    0   = ctz(11) = 0
    // 12   1010 = 10    2   = ctz(12) = 2
    // 13   1011 = 11    0   = ctz(13) = 0
    // 14   1001 =  9    1   = ctz(14) = 1
    // 15   1000 =  8    0   = ctz(15) = 0
    constexpr static setup_t setup()
    {
        std::array<size_t, 1 << K_MAX> bit_flips;
        std::array<size_t, 1 << K_MAX> codewords;
        codewords[0] = 0;
        bit_flips[0] = K_MAX - 1;
        for (size_t i = 1; i < bit_flips.size(); ++i)
        {
            bit_flips[i] = ctz(i);
            codewords[i] = codewords[i - 1] ^ (1 << bit_flips[i]);
        }
        return {codewords, bit_flips};
    }

    template <typename IB, typename OB, size_t K>
    static void build_lookup_table(std::array<OB, 1 << K_MAX>& table, const IB* input,
                                   size_t stride, const setup_t& gray_tables)
        requires(K <= K_MAX)
    {
        FAEST_ASSERT(sizeof(OB) <= sizeof(IB) * stride);
        const auto& [codewords, bit_flips] = gray_tables;
        table.fill(OB{});
        OB tmp;
        for (size_t i = 1; i < (1 << K); ++i)
        {
            const auto bit_i = bit_flips[i];
            memcpy(&tmp, &input[bit_i * stride], sizeof(OB));
            table[codewords[i]] = table[codewords[i - 1]] ^ tmp;
        }
    }
};

template <size_t K_MAX>
    requires(K_MAX <= 4)
struct gray_lookup_table_builder<K_MAX, true>
{
    // constexpr static size_t K_MAX = 4;

    struct setup_t
    {
    };

    constexpr static setup_t setup() { return {}; }

    template <typename IB, typename OB, size_t K>
    static void build_lookup_table(std::array<OB, 1 << K_MAX>& table, const IB* input,
                                   size_t stride, const setup_t&)
        requires(K <= K_MAX)
    {
        FAEST_ASSERT(sizeof(OB) <= sizeof(IB) * stride);
        table[0] = OB{};
        OB tmp;
#define GRAY_TAB_GEN(CW, CW_PREV, FLIP)                                                            \
    memcpy(&tmp, &input[FLIP * stride], sizeof(OB));                                               \
    table[CW] = table[CW_PREV] ^ tmp;

        GRAY_TAB_GEN(1, 0, 0);
        if constexpr (K > 1)
        {
            GRAY_TAB_GEN(3, 1, 1);
            GRAY_TAB_GEN(2, 3, 0);
        }
        if constexpr (K > 2)
        {
            GRAY_TAB_GEN(6, 2, 2);
            GRAY_TAB_GEN(7, 6, 0);
            GRAY_TAB_GEN(5, 7, 1);
            GRAY_TAB_GEN(4, 5, 0);
        }
        if constexpr (K > 3)
        {
            GRAY_TAB_GEN(12, 4, 3);
            GRAY_TAB_GEN(13, 12, 0);
            GRAY_TAB_GEN(15, 13, 1);
            GRAY_TAB_GEN(14, 15, 0);
            GRAY_TAB_GEN(10, 14, 2);
            GRAY_TAB_GEN(11, 10, 0);
            GRAY_TAB_GEN(9, 11, 1);
            GRAY_TAB_GEN(8, 9, 0);
        }
#undef GRAY_TAB_GEN
    }
};

template <secpar S, size_t ROWS, size_t COLUMNS>
    requires(ROWS <= secpar_to_bits(S) && COLUMNS <= secpar_to_bits(S))
block_secpar<S> matrix_multiply_row(block_secpar<S> row, const lift_row_table_t<ROWS, COLUMNS>& W)
{
    auto output = block_secpar<S>::set_zero();
    std::array<uint64_t, sizeof(row) / sizeof(uint64_t)> row_words;
    static_assert(sizeof(row) == sizeof(row_words));
    row.store(row_words.data());
    for (size_t j = 0; j < ROWS; ++j)
    {
        const auto word_idx = j / 64;
        const auto bit_idx = j % 64;
        FAEST_ASSERT(word_idx < sizeof(row) / sizeof(uint64_t));
        // mask will contain the bit from row[j] in every position
        const auto mask = block_secpar<S>::set_all_8(((row_words[word_idx] >> bit_idx) & 1) * 0xff);
        // load row of W
        const auto w_row = block_secpar<S>::load(&W[j]);
        // masked add
        output = output ^ (mask & w_row);
    }
    return output;
}

template <secpar S, size_t ROWS, size_t COLUMNS>
    requires(COLUMNS <= secpar_to_bits(S))
block_secpar<S> matrix_multiply_row(const uint8_t* row, const lift_row_table_t<ROWS, COLUMNS>& W)
{
    auto output = block_secpar<S>::set_zero();
    for (size_t j = 0; j < ROWS; ++j)
    {
        const auto word_idx = j / 8;
        const auto bit_idx = j % 8;
        // mask will contain the bit from row[j] in every position
        const auto mask = block_secpar<S>::set_all_8(((row[word_idx] >> bit_idx) & 1) * 0xff);
        // load row of W
        const auto w_row = block_secpar<S>::load(&W[j]);
        // masked add
        output = output ^ (mask & w_row);
    }
    return output;
}

template <secpar S, size_t ROWS, size_t COLUMNS>
    requires(ROWS <= secpar_to_bits(S))
void matrix_multiply_row_xor(uint8_t* row_xor_out, block_secpar<S> row_in,
                             const lift_row_table_t<ROWS, COLUMNS>& W)
{
    std::array<uint64_t, sizeof(row_in) / sizeof(uint64_t)> row_words;
    static_assert(sizeof(row_in) == sizeof(row_words));
    row_in.store(row_words.data());
    for (size_t j = 0; j < ROWS; ++j)
    {
        const auto word_idx = j >> 6;
        const auto bit_idx = j & 0x3f;
        FAEST_ASSERT(word_idx < sizeof(row_in) / sizeof(uint64_t));
        FAEST_ASSERT(j == word_idx * 64 + bit_idx);
        // mask will contain the bit from row[j] in every position
        const uint8_t mask = ((row_words[word_idx] >> (j & 0x3f)) & 1) * 0xff;
        // xor masked row of W
        const auto* W_j_bytes = reinterpret_cast<const uint8_t*>(&W[j]);
        // masked add
        for (size_t i = 0; i < (COLUMNS + 7) / 8; ++i)
            row_xor_out[i] ^= (mask & W_j_bytes[i]);
    }
}

template <typename P>
ALWAYS_INLINE block_secpar<P::secpar_v> crt_lift_row(block_secpar<P::secpar_v> row)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    return matrix_multiply_row<P::secpar_v, P::delta_bits_v, P::delta_bits_v>(
        row, C::W_CRT_LIFT_ROW_TAB);
}

template <typename P>
ALWAYS_INLINE block_secpar<P::secpar_v> tree_lift_row(block_secpar<P::secpar_v> row)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    return matrix_multiply_row<P::secpar_v, P::delta_bits_v, P::secpar_bits>(
        row, C::W_TREE_LIFT_ROW_TAB);
}

template <typename P> ALWAYS_INLINE block_secpar<P::secpar_v> gate_lift_row(const uint8_t* row)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    return matrix_multiply_row<P::secpar_v, P::CONSTS::CRT_NUM_MULT, P::delta_bits_v>(
        row, C::W_GATE_LIFT_ROW_TAB);
}

template <typename P>
ALWAYS_INLINE void F_lift_row_xor(uint8_t* row_xor_out, block_secpar<P::secpar_v> row)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    return matrix_multiply_row_xor<P::secpar_v, P::secpar_bits, P::CONSTS::CRT_NUM_MULT>(
        row_xor_out, row, C::F_LIFT_ROW_TAB);
}

template <typename P>
ALWAYS_INLINE void G_lift_row_xor(uint8_t* row_xor_out, block_secpar<P::secpar_v> row)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    return matrix_multiply_row_xor<P::secpar_v, P::delta_bits_v, P::CONSTS::CRT_NUM_MULT>(
        row_xor_out, row, C::G_LIFT_ROW_TAB);
}

template <secpar S, size_t ROWS, size_t COLUMNS, size_t LOOKUP_BITS>
    requires(COLUMNS <= secpar_to_bits(S) && LOOKUP_BITS == 8)
block_secpar<S>
lift_public_row(const uint8_t* row_bytes,
                const lift_public_row_lookup_table_t<ROWS, COLUMNS, LOOKUP_BITS>& lookup_table)
{
    auto output = block_secpar<S>::set_zero();
    for (size_t i = 0; i < (ROWS + 7) / 8; ++i)
    {
        const auto tmp = block_secpar<S>::load(&lookup_table[i][row_bytes[i]]);
        output = output ^ tmp;
    }
    return output;
}

template <secpar S, size_t ROWS, size_t COLUMNS, size_t LOOKUP_BITS>
    requires(COLUMNS <= secpar_to_bits(S) && LOOKUP_BITS == 4)
block_secpar<S>
lift_public_row(const uint8_t* row_bytes,
                const lift_public_row_lookup_table_t<ROWS, COLUMNS, LOOKUP_BITS>& lookup_table)
{
    auto output = block_secpar<S>::set_zero();
    for (size_t i = 0; i < ROWS / 8; ++i)
    {
        const auto tmp1 = block_secpar<S>::load(&lookup_table[2 * i][row_bytes[i] & 0x0f]);
        const auto tmp2 = block_secpar<S>::load(&lookup_table[2 * i + 1][row_bytes[i] >> 4]);
        output = output ^ tmp1 ^ tmp2;
    }
    if constexpr (ROWS % 8 != 0)
    {
        const auto tmp =
            block_secpar<S>::load(&lookup_table[2 * (ROWS / 8)][row_bytes[(ROWS / 8)] & 0x0f]);
        output = output ^ tmp;
    }
    return output;
}

template <secpar S, size_t ROWS, size_t COLUMNS, size_t LOOKUP_BITS>
    requires(COLUMNS <= secpar_to_bits(S))
ALWAYS_INLINE block_secpar<S>
lift_public_row(block_secpar<S> row,
                const lift_public_row_lookup_table_t<ROWS, COLUMNS, LOOKUP_BITS>& lookup_table)
{
    return lift_public_row<S, ROWS, COLUMNS, LOOKUP_BITS>(reinterpret_cast<const uint8_t*>(&row),
                                                          lookup_table);
}

// Performs the CRT-lift of a row
template <typename P>
ALWAYS_INLINE block_secpar<P::secpar_v> crt_lift_public_row(block_secpar<P::secpar_v> row)
{
    return crt_lift_row<P>(row);
    // using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    // return lift_public_row<P::secpar_v, P::delta_bits_v, P::delta_bits_v,
    //                        C::W_CRT_LIFT_PUBLIC_ROWS_LOOKUP_BITS>(
    //     row, C::W_CRT_LIFT_PUBLIC_ROW_LOOKUP_TAB);
}

// Performs the CRT-lift of Delta
template <typename P>
    requires(P::use_crt_vole_masks)
ALWAYS_INLINE block_secpar<P::secpar_v> crt_lift_delta(block_secpar<P::secpar_v> delta)
{
    return crt_lift_public_row<P>(delta);
}

// Performs the Tree-lift of a row
template <typename P>
ALWAYS_INLINE block_secpar<P::secpar_v> tree_lift_public_row(block_secpar<P::secpar_v> row)
{
    return tree_lift_row<P>(row);
    // using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    // return lift_public_row<P::secpar_v, P::delta_bits_v, P::secpar_bits,
    //                        C::W_TREE_LIFT_PUBLIC_ROWS_LOOKUP_BITS>(
    //     row, C::W_TREE_LIFT_PUBLIC_ROW_LOOKUP_TAB);
}

template <typename P>
ALWAYS_INLINE block_secpar<P::secpar_v> gate_lift_public_row(const uint8_t* row)
{
    return gate_lift_row<P>(row);
    // using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    // return lift_public_row<P::secpar_v, P::CONSTS::CRT_NUM_MULT, P::delta_bits_v,
    //                        C::W_GATE_LIFT_PUBLIC_ROWS_LOOKUP_BITS>(
    //     row, C::W_GATE_LIFT_PUBLIC_ROW_LOOKUP_TAB);
}

template <secpar S, size_t DELTA_BITS, size_t LOOKUP_BITS, typename BLOCK, bool FULL_BLOCK>
static void lift_columns_inplace_helper(
    vole_block* in_out, size_t stride,
    const typename gray_lookup_table_builder<LOOKUP_BITS>::setup_t& lt_setup,
    const lift_columns_index_table_t<DELTA_BITS, DELTA_BITS, LOOKUP_BITS>& index_table,
    size_t n_bytes)
{
    using lt_builder = gray_lookup_table_builder<LOOKUP_BITS>;
    constexpr auto SPLIT = even_split(DELTA_BITS, LOOKUP_BITS);
    static_assert(SPLIT.N_MAX == 0 || SPLIT.K_MAX <= LOOKUP_BITS);
    static_assert(SPLIT.K_MIN <= LOOKUP_BITS);

    // Parameters deciding the size of the lookup table:
    // - 2^LOOKUP_BITS x BLOCKS_PER_ITERATION
    std::array<BLOCK, 1 << LOOKUP_BITS> table;

    // Space to store a chunk of the output matrix before we can overwrite the input.
    std::array<BLOCK, DELTA_BITS> chunk{}; // zero-initialized

    if constexpr (SPLIT.N_MAX > 0)
    {
        for (size_t i = 0; i < SPLIT.N_MAX; ++i)
        {
            lt_builder::template build_lookup_table<vole_block, BLOCK, SPLIT.K_MAX>(
                table, &in_out[stride * i * SPLIT.K_MAX], stride, lt_setup);
            for (size_t j = 0; j < DELTA_BITS; ++j)
            {
                size_t x = index_table[i][j];
                FAEST_ASSERT(x < (1 << SPLIT.K_MAX));
                chunk[j] = chunk[j] ^ table[x];
            }
        }
    }

    if constexpr (SPLIT.N_MIN > 0)
    {
        constexpr auto OFFSET = SPLIT.N_MAX * SPLIT.K_MAX;
        for (size_t i = 0; i < SPLIT.N_MIN; ++i)
        {
            lt_builder::template build_lookup_table<vole_block, BLOCK, SPLIT.K_MIN>(
                table, &in_out[stride * (OFFSET + i * SPLIT.K_MIN)], stride, lt_setup);
            for (size_t j = 0; j < DELTA_BITS; ++j)
            {
                size_t x = index_table[SPLIT.N_MAX + i][j];
                FAEST_ASSERT(x < (1 << SPLIT.K_MIN));
                chunk[j] = chunk[j] ^ table[x];
            }
        }
    }

    // This chunk is finished, now we can overwrite the corresponding part of the input with it.
    if constexpr (FULL_BLOCK) {
        for (size_t col_j = 0; col_j < DELTA_BITS; ++col_j)
            memcpy(&in_out[col_j * stride], &chunk[col_j], sizeof(chunk[col_j]));
    } else {
        for (size_t col_j = 0; col_j < DELTA_BITS; ++col_j)
            memcpy(&in_out[col_j * stride], &chunk[col_j], n_bytes);
    }
}

// Performs the row-wise lift on a matrix.
// `in_out` is an (`rows` x `delta_bits`) matrix of `vole_block`s in column-major format. Two
// consecutive columns are separated by `stride` many `vole_block`s.
template <secpar S, size_t DELTA_BITS, size_t LOOKUP_BITS, size_t BLOCKS_PER_ITERATION = 2>
void lift_columns_inplace(
    vole_block* in_out, size_t stride, size_t row_bytes,
    const lift_columns_index_table_t<DELTA_BITS, DELTA_BITS, LOOKUP_BITS>& index_table)
{
    using lt_builder = gray_lookup_table_builder<LOOKUP_BITS>;
    constexpr auto lt_setup = lt_builder::setup();

    // constexpr auto CHUNK_SIZE = sizeof(vole_block) * BLOCKS_PER_ITERATION;
    // using CHUNK = block<8 * BLOCK_SIZE>;

    // - vole_blocks we need to touch
    size_t row_blocks = (row_bytes + 15) / 16;
    bool n_1 = row_blocks & 1;
    bool n_2 = row_blocks & 2;
    size_t n_4 = row_blocks / 4;
    FAEST_ASSERT(4 * n_4 + (n_2 ? 2 : 0) + (n_1 ? 1 : 0) == row_blocks);

    while (row_blocks > 4)
    {
        lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block512, true>(
            in_out, stride, lt_setup, index_table, 64);
        row_blocks -= 4;
        in_out += 4;
    }
    if (row_blocks == 4)
    {
        const size_t leftover_bytes = row_bytes % 64;
        if (leftover_bytes)
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block512, false>(
                in_out, stride, lt_setup, index_table, leftover_bytes);
        else
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block512, true>(
                in_out, stride, lt_setup, index_table, 64);
    }
    else if (row_blocks == 3)
    {
        lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block256, true>(
            in_out, stride, lt_setup, index_table, 32);
        in_out += 2;
        const size_t leftover_bytes = row_bytes % 16;
        if (leftover_bytes)
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block128, false>(
                in_out, stride, lt_setup, index_table, leftover_bytes);
        else
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block128, true>(
                in_out, stride, lt_setup, index_table, 16);
    }
    else if (row_blocks == 2)
    {
        const size_t leftover_bytes = row_bytes % 32;
        if (leftover_bytes)
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block256, false>(
                in_out, stride, lt_setup, index_table, leftover_bytes);
        else
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block256, true>(
                in_out, stride, lt_setup, index_table, 32);
    }
    else if (row_blocks == 1)
    {
        const size_t leftover_bytes = row_bytes % 16;
        if (leftover_bytes)
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block128, false>(
                in_out, stride, lt_setup, index_table, leftover_bytes);
        else
            lift_columns_inplace_helper<S, DELTA_BITS, LOOKUP_BITS, block128, true>(
                in_out, stride, lt_setup, index_table, 16);
    }
}

template <secpar S, size_t ROWS, size_t COLUMNS, size_t LOOKUP_BITS>
    requires(ROWS <= secpar_to_bits(S))
void lift_columns_secpar_prefix(
    block_secpar<S>* out, const vole_block* in, size_t in_stride,
    const lift_columns_index_table_t<ROWS, COLUMNS, LOOKUP_BITS>& index_table)
{
    // The columns need to be at least S bits long.
    FAEST_ASSERT(in_stride * sizeof(vole_block) >= secpar_to_bytes(S));

    // Parameters deciding the size of the lookup table:
    // - 2^LOOKUP_BITS x BLOCKS_PER_ITERATION
    std::array<block_secpar<S>, 1 << LOOKUP_BITS> table;

    using lt_builder = gray_lookup_table_builder<LOOKUP_BITS>;
    constexpr auto lt_setup = lt_builder::setup();
    constexpr auto SPLIT = even_split(ROWS, LOOKUP_BITS);

    // Clear output to work on
    memset(out, 0x00, COLUMNS * sizeof(block_secpar<S>));

    if constexpr (SPLIT.N_MAX > 0)
    {
        for (size_t i = 0; i < SPLIT.N_MAX; ++i)
        {
            lt_builder::template build_lookup_table<vole_block, block_secpar<S>, SPLIT.K_MAX>(
                table, &in[in_stride * i * SPLIT.K_MAX], in_stride, lt_setup);
            for (size_t j = 0; j < COLUMNS; ++j)
            {
                size_t x = index_table[i][j];
                FAEST_ASSERT(x < (1 << SPLIT.K_MAX));
                out[j] = out[j] ^ table[x];
            }
        }
    }
    if constexpr (SPLIT.N_MIN > 0)
    {
        constexpr auto OFFSET = SPLIT.N_MAX * SPLIT.K_MAX;
        for (size_t i = 0; i < SPLIT.N_MIN; ++i)
        {
            lt_builder::template build_lookup_table<vole_block, block_secpar<S>, SPLIT.K_MIN>(
                table, &in[in_stride * (OFFSET + i * SPLIT.K_MIN)], in_stride, lt_setup);
            for (size_t j = 0; j < COLUMNS; ++j)
            {
                size_t x = index_table[SPLIT.N_MAX + i][j];
                FAEST_ASSERT(x < (1 << SPLIT.K_MIN));
                out[j] = out[j] ^ table[x];
            }
        }
    }
}

template <size_t ROWS, size_t COLUMNS, size_t LOOKUP_BITS>
void lift_columns_16bit(uint16_t* out, const uint16_t* in,
                        const lift_columns_index_table_t<ROWS, COLUMNS, LOOKUP_BITS>& index_table)
{
    // Parameters deciding the size of the lookup table:
    // - 2^LOOKUP_BITS x BLOCKS_PER_ITERATION
    std::array<uint16_t, 1 << LOOKUP_BITS> table;

    using lt_builder = gray_lookup_table_builder<LOOKUP_BITS>;
    constexpr auto lt_setup = lt_builder::setup();
    constexpr auto SPLIT = even_split(ROWS, LOOKUP_BITS);

    // Clear output to work on
    memset(out, 0x00, COLUMNS * sizeof(uint16_t));

    if constexpr (SPLIT.N_MAX > 0)
    {
        for (size_t i = 0; i < SPLIT.N_MAX; ++i)
        {
            lt_builder::template build_lookup_table<uint16_t, uint16_t, SPLIT.K_MAX>(
                table, &in[i * SPLIT.K_MAX], 1, lt_setup);
            for (size_t j = 0; j < COLUMNS; ++j)
            {
                size_t x = index_table[i][j];
                FAEST_ASSERT(x < (1 << SPLIT.K_MAX));
                out[j] = out[j] ^ table[x];
            }
        }
    }
    if constexpr (SPLIT.N_MIN > 0)
    {
        constexpr auto OFFSET = SPLIT.N_MAX * SPLIT.K_MAX;
        for (size_t i = 0; i < SPLIT.N_MIN; ++i)
        {
            lt_builder::template build_lookup_table<uint16_t, uint16_t, SPLIT.K_MIN>(
                table, &in[OFFSET + i * SPLIT.K_MIN], 1, lt_setup);
            for (size_t j = 0; j < COLUMNS; ++j)
            {
                size_t x = index_table[SPLIT.N_MAX + i][j];
                FAEST_ASSERT(x < (1 << SPLIT.K_MIN));
                out[j] = out[j] ^ table[x];
            }
        }
    }
}

// Performs the row-wise CRT-lift on the matrix V
// `in_out` is an (`rows` x `delta_bits`) matrix of  in column-major format. Two consecutive columns
// are separated by `stride` many `vole_block`s.
template <typename P> ALWAYS_INLINE void crt_lift_v(vole_block* in_out, size_t stride, size_t rows)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    lift_columns_inplace<P::secpar_v, P::delta_bits_v, C::W_CRT_LIFT_COLUMNS_LOOKUP_BITS>(
        in_out, stride, rows, C::W_CRT_LIFT_COLUMNS_INDEX_TAB);
}

// Performs the row-wise CRT-lift on the matrix Q
// `in_out` is an (`rows` x `delta_bits`) matrix of  in column-major format. Two consecutive columns
// are separated by `stride` many `vole_block`s.
template <typename P> ALWAYS_INLINE void crt_lift_q(vole_block* in_out, size_t stride, size_t rows)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    lift_columns_inplace<P::secpar_v, P::delta_bits_v, C::W_CRT_LIFT_COLUMNS_LOOKUP_BITS>(
        in_out, stride, rows, C::W_CRT_LIFT_COLUMNS_INDEX_TAB);
}

template <typename P> ALWAYS_INLINE void gate_lift(uint16_t* out, const uint16_t* in)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    lift_columns_16bit<P::CONSTS::CRT_NUM_MULT, P::secpar_bits, C::W_GATE_LIFT_COLUMNS_LOOKUP_BITS>(
        out, in, C::W_GATE_LIFT_COLUMNS_INDEX_TAB);
}

template <typename P>
ALWAYS_INLINE void G_lift_a(block_secpar<P::secpar_v>* out, const vole_block* in, size_t in_stride)
{
    using C = CRT_CONSTANTS<P::secpar_v, P::tau_v, P::delta_bits_v>;
    lift_columns_secpar_prefix<P::secpar_v, P::delta_bits_v, P::CONSTS::CRT_NUM_MULT,
                               C::G_LIFT_COLUMNS_LOOKUP_BITS>(out, in, in_stride,
                                                              C::G_LIFT_COLUMNS_INDEX_TAB);
}

} // namespace faest

#endif
