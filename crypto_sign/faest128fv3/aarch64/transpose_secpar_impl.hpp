#include "constants.hpp"
#include "transpose.hpp"
#include "util.hpp"

#include <cassert>
#include <cstring>

namespace faest
{

template <secpar S> constexpr size_t TRANSPOSE_BITS_COLS_SHIFT = 8;
template <> constexpr inline size_t TRANSPOSE_BITS_COLS_SHIFT<secpar::s128> = 7;

template <secpar S> constexpr size_t TRANSPOSE_BITS_COLS = (1 << TRANSPOSE_BITS_COLS_SHIFT<S>);

// TODO: test 3 and 4
#define TRANSPOSE_CHUNK_SHIFT 4
#define TRANSPOSE_CHUNK_SIZE (1 << TRANSPOSE_CHUNK_SHIFT)

// Helper for transposing byte matrices.
template <secpar S>
static ALWAYS_INLINE void transposeVxN_8_chunk(block256* __restrict__ matrix,
                                               unsigned char* __restrict__ output_mat,
                                               unsigned int i_start, unsigned int i, size_t j_chunk)
{
    size_t bit = 1 << (i % TRANSPOSE_BITS_COLS_SHIFT<S>);
    j_chunk = rotate_left(j_chunk, i_start, TRANSPOSE_BITS_COLS_SHIFT<S>);

#ifdef __GNUC__
    _Pragma(STRINGIZE(GCC unroll (TRANSPOSE_CHUNK_SIZE)))
#endif
        for (size_t j_unrotated = 0; j_unrotated < TRANSPOSE_CHUNK_SIZE; ++j_unrotated)
    {
        size_t j_in_chunk = rotate_left(j_unrotated, i_start, TRANSPOSE_BITS_COLS_SHIFT<S>);

        // Iterate over all indexes with bit i cleared.
        if (j_in_chunk & bit)
            continue;

        size_t j = j_chunk + j_in_chunk;

        block256 x = matrix[j];
        block256 y = matrix[j + bit];
        block256 out[2];

        switch (i)
        {
        case 3:
            out[0].data[0] = {vreinterpretq_u32_u8(vzip1q_u8(
                vreinterpretq_u8_u32(x.data[0].data), vreinterpretq_u8_u32(y.data[0].data)))};
            out[0].data[1] = {vreinterpretq_u32_u8(vzip1q_u8(
                vreinterpretq_u8_u32(x.data[1].data), vreinterpretq_u8_u32(y.data[1].data)))};
            out[1].data[0] = {vreinterpretq_u32_u8(vzip2q_u8(
                vreinterpretq_u8_u32(x.data[0].data), vreinterpretq_u8_u32(y.data[0].data)))};
            out[1].data[1] = {vreinterpretq_u32_u8(vzip2q_u8(
                vreinterpretq_u8_u32(x.data[1].data), vreinterpretq_u8_u32(y.data[1].data)))};
            break;
        case 4:
            out[0].data[0] = {vreinterpretq_u32_u16(vzip1q_u16(
                vreinterpretq_u16_u32(x.data[0].data), vreinterpretq_u16_u32(y.data[0].data)))};
            out[0].data[1] = {vreinterpretq_u32_u16(vzip1q_u16(
                vreinterpretq_u16_u32(x.data[1].data), vreinterpretq_u16_u32(y.data[1].data)))};
            out[1].data[0] = {vreinterpretq_u32_u16(vzip2q_u16(
                vreinterpretq_u16_u32(x.data[0].data), vreinterpretq_u16_u32(y.data[0].data)))};
            out[1].data[1] = {vreinterpretq_u32_u16(vzip2q_u16(
                vreinterpretq_u16_u32(x.data[1].data), vreinterpretq_u16_u32(y.data[1].data)))};
            break;
        case 5:
            out[0].data[0] = {vzip1q_u32(x.data[0].data, y.data[0].data)};
            out[0].data[1] = {vzip1q_u32(x.data[1].data, y.data[1].data)};
            out[1].data[0] = {vzip2q_u32(x.data[0].data, y.data[0].data)};
            out[1].data[1] = {vzip2q_u32(x.data[1].data, y.data[1].data)};
            break;
        case 6:
            out[0].data[0] = {vreinterpretq_u32_u64(vzip1q_u64(
                vreinterpretq_u64_u32(x.data[0].data), vreinterpretq_u64_u32(y.data[0].data)))};
            out[0].data[1] = {vreinterpretq_u32_u64(vzip1q_u64(
                vreinterpretq_u64_u32(x.data[1].data), vreinterpretq_u64_u32(y.data[1].data)))};
            out[1].data[0] = {vreinterpretq_u32_u64(vzip2q_u64(
                vreinterpretq_u64_u32(x.data[0].data), vreinterpretq_u64_u32(y.data[0].data)))};
            out[1].data[1] = {vreinterpretq_u32_u64(vzip2q_u64(
                vreinterpretq_u64_u32(x.data[1].data), vreinterpretq_u64_u32(y.data[1].data)))};
            break;
        case 7:
            transpose2x2_128(&out[0], x, y);
            break;
        }

        if (i < 7)
        {
            matrix[j] = out[0];
            matrix[j + bit] = out[1];
        }
        else
        {
            // Write out the final result, after fixing up the order of the blocks.

            j = rotate_right(j, 8, TRANSPOSE_BITS_COLS_SHIFT<S>);

            // Need to bit reverse in positions [3, 7), because the unpack instructions work
            // differently than transposes.
            size_t reverse_mask = 0xf << (TRANSPOSE_BITS_COLS_SHIFT<S> - 5);
            size_t shift2_mask = 0xc << (TRANSPOSE_BITS_COLS_SHIFT<S> - 5);
            size_t shift1_mask = 0xa << (TRANSPOSE_BITS_COLS_SHIFT<S> - 5);
            size_t reversed = j & reverse_mask;
            reversed = ((reversed & shift2_mask) >> 2) | ((reversed << 2) & shift2_mask);
            reversed = ((reversed & shift1_mask) >> 1) | ((reversed << 1) & shift1_mask);
            j = (j & ~reverse_mask) | reversed;

            // Remove padding that was added for case 192.
            size_t used_bytes = S == secpar::s192 ? sizeof(block192) : sizeof(block256);
            memcpy(output_mat + j * used_bytes, &out[0], used_bytes);
            memcpy(output_mat + (j + TRANSPOSE_BITS_COLS<S> / 2) * used_bytes, &out[1], used_bytes);
        }
    }
}

} // namespace faest
