#ifndef SMALL_VOLE_INC
#define SMALL_VOLE_INC

#include <cassert>

#include "aes.hpp"
#include "block.hpp"
#include "prgs.hpp"
#include "small_vole.hpp"
#include "util.hpp"

namespace faest
{

namespace detail
{

template <typename P> static constexpr std::size_t COL_LEN = CONSTANTS<P>::VOLE_COL_BLOCKS;

// TODO: probably can ditch most of the "restrict"s in inlined functions.

// There are two different methods for efficiently reducing the PRG outputs (equivalent to computing
// a Hamming code syndrome): Divide and conquer, and a straight-line method based on Gray's code.
// These are both transposes of Hadamard encoding circuits given in "the Exact Lower Bounds of
// Encoding Circuit Sizes of Hamming Codes and Hadamard Codes". This implementation combines these
// two methods. Divide and conquer is used at the lowest level, as it is inherently parallel and has
// a fixed access pattern when unrolled. Above it, the Gray's code method is used, as it needs very
// little temporary storage.

// Output: v (or q) in in_out[1, ..., depth], and u in in_out[0].
template <typename P> static ALWAYS_INLINE void xor_reduce(vole_block* in_out)
{
    using CP = CONSTANTS<P>;
#ifdef __GNUC__
#pragma GCC unroll(5)
#endif
    for (size_t i = 0; i < CP::VOLE_WIDTH_SHIFT; i++)
    {
        size_t stride = 1 << i;
#ifdef __GNUC__
#pragma GCC unroll(32)
#endif
        for (size_t j = 0; j < CP::VOLE_WIDTH; j += 2 * stride)
        {
#ifdef __GNUC__
#pragma GCC unroll(5)
#endif
            for (size_t d = 0; d <= i; ++d)
                in_out[j + d] = in_out[j + d] ^ in_out[j + d + stride];
            in_out[j + i + 1] = in_out[j + stride];
        }
    }
}

template <typename P>
static ALWAYS_INLINE void convert_prg_output(vole_block* prg_output,
                                             const typename P::vole_prg_t::block_t* raw_prg_output,
                                             size_t blocks)
{
    using CP = CONSTANTS<P>;
    if constexpr (CP::PRG_VOLE_BLOCKS == 2)
    {
#ifdef __GNUC__
#pragma GCC unroll(32)
#endif
        for (size_t i = 0; i < blocks; ++i)
            prg_output[i] = block256::from_2_block128(raw_prg_output[CP::PRG_VOLE_BLOCKS * i],
                                                      raw_prg_output[CP::PRG_VOLE_BLOCKS * i + 1]);
    }
    else
    {
        memcpy(prg_output, raw_prg_output, blocks * sizeof(vole_block));
    }
}

template <typename P, bool ignore_0>
static ALWAYS_INLINE void process_prg_output(size_t j, unsigned int output_col, vole_block* accum,
                                             vole_block* vq,
                                             const typename P::vole_prg_t::block_t* raw_prg_output)
{
    using CP = CONSTANTS<P>;
    vole_block prg_output[CP::VOLE_WIDTH];
    if constexpr (!ignore_0)
        convert_prg_output<P>(prg_output, raw_prg_output, CP::VOLE_WIDTH);
    else
    {
        prg_output[0] = vole_block::set_zero();
        convert_prg_output<P>(&prg_output[1], raw_prg_output, CP::VOLE_WIDTH - 1);
    }

    xor_reduce<P>(prg_output);

    if constexpr (!ignore_0)
        accum[j] = accum[j] ^ prg_output[0];

    for (size_t col = 0; col < CP::VOLE_WIDTH_SHIFT; ++col)
        vq[COL_LEN<P> * col + j] = vq[COL_LEN<P> * col + j] ^ prg_output[col + 1];

    if constexpr (!ignore_0)
        // Grey's codes method. output_col is the index of the bit that will change when
        // incrementing the Gray's code.
        vq[COL_LEN<P> * output_col + j] = vq[COL_LEN<P> * output_col + j] ^ accum[j];
}

// Sender and receiver merged together, since they share most of the same code.
template <typename P, bool receiver>
static ALWAYS_INLINE void
vole(unsigned int k, const block_secpar<P::secpar_v>* __restrict__ keys,
     typename P::vole_prg_t::iv_t iv, typename P::vole_prg_t::tweak_t tweak,
     const vole_block* __restrict__ u_or_c_in, vole_block* __restrict__ vq,
     vole_block* __restrict__ c_out, const uint8_t* __restrict__ delta)
{
    using CP = CONSTANTS<P>;

    assert(k >= CP::VOLE_WIDTH_SHIFT);

    std::array<vole_block, CP::VOLE_COL_BLOCKS> accum{}; // zero-initialized

    if (receiver && u_or_c_in) // receiver only, for all but the first small VOLE
    {
        constexpr auto COL_BYTE_LEN = COL_LEN<P> * sizeof(vole_block);
        auto* q_byte_ptr = reinterpret_cast<uint8_t*>(vq);
        for (unsigned int col = 0; col < k; ++col)
        {
            if (delta[col])
            {
                // correct first rows
                memcpy(q_byte_ptr, u_or_c_in, CP::VOLE_CORRECTION_BYTES);
                // zero last rows
                memset(q_byte_ptr + CP::VOLE_CORRECTION_BYTES, 0x00,
                       COL_BYTE_LEN - CP::VOLE_CORRECTION_BYTES);
            }
            else
            {
                memset(q_byte_ptr, 0x00, COL_BYTE_LEN);
            }
            q_byte_ptr += COL_BYTE_LEN;
        }
    }
    else // sender, or receiver (for the first small VOLE)
    {
        memset(&vq[0], 0, COL_LEN<P> * k * sizeof(vole_block));
    }

    typename P::vole_prg_t::expanded_key_t expanded_keys[CP::VOLE_WIDTH];
    typename P::vole_prg_t::block_t raw_prg_output[CP::VOLE_WIDTH * CP::PRG_VOLE_BLOCKS];

    size_t i = 0;
    if constexpr (receiver) // receiver only
    {
        // Handle first iteration separately, since the 0th PRG key is a dummy.

        P::vole_prg_t::template init<CP::VOLE_WIDTH - 1, CP::PRG_VOLE_BLOCKS>(
            &keys[1], expanded_keys, iv, tweak, 0, raw_prg_output);
        process_prg_output<P, true>(0, 0, accum.data(), vq, raw_prg_output);

        for (size_t j = 1; j < COL_LEN<P>; ++j)
        {
            P::vole_prg_t::template gen<CP::VOLE_WIDTH - 1, CP::PRG_VOLE_BLOCKS>(
                expanded_keys, iv, tweak, j * CP::PRG_VOLE_BLOCKS, raw_prg_output);
            process_prg_output<P, true>(j, 0, accum.data(), vq, raw_prg_output);
        }

        i = CP::VOLE_WIDTH;
    }

    for (; i < (size_t)1 << k; i += CP::VOLE_WIDTH)
    {
        // Bitwise or is to make output_col be k - 1 when i + VOLE_WIDTH = 2**k, rather than k.
        unsigned int output_col = count_trailing_zeros((i + CP::VOLE_WIDTH) | (1 << (k - 1)));

        P::vole_prg_t::template init<CP::VOLE_WIDTH, CP::PRG_VOLE_BLOCKS>(
            &keys[i], expanded_keys, iv, tweak, 0, raw_prg_output);
        process_prg_output<P, false>(0, output_col, accum.data(), vq, raw_prg_output);

        for (size_t j = 1; j < COL_LEN<P>; ++j)
        {
            P::vole_prg_t::template gen<CP::VOLE_WIDTH, CP::PRG_VOLE_BLOCKS>(
                expanded_keys, iv, tweak, j * CP::PRG_VOLE_BLOCKS, raw_prg_output);
            process_prg_output<P, false>(j, output_col, accum.data(), vq, raw_prg_output);
        }
    }

    if constexpr (!receiver) // sender only
    {
        if (u_or_c_in) // for all but the first small VOLE
        {
            constexpr auto FULL_VOLE_CORRECTION_BLOCKS =
                CP::VOLE_CORRECTION_ROWS / (128 * CP::VOLE_BLOCK);
            constexpr auto LEFTOVER_CORRECTION_BYTES =
                (CP::VOLE_CORRECTION_ROWS % (128 * CP::VOLE_BLOCK)) / 8;
            constexpr auto START_UNCORRECTED_BLOCKS =
                FULL_VOLE_CORRECTION_BLOCKS + (LEFTOVER_CORRECTION_BYTES == 0 ? 0 : 1);
            // correct first full blocks
            for (size_t j = 0; j < FULL_VOLE_CORRECTION_BLOCKS; ++j)
                c_out[j] = u_or_c_in[j] ^ accum[j];
            // handle a potentially mixed block
            if constexpr (LEFTOVER_CORRECTION_BYTES > 0)
            {
                // create a `vole_block` mask that has the first LEFTOVER_CORRECTION_BYTES set
                // to 0xff
                constexpr auto mask_bytes = [] consteval
                {
                    alignas(alignof(vole_block)) std::array<uint8_t, sizeof(vole_block)>
                        mask_bytes = {};
                    std::fill_n(mask_bytes.begin(), LEFTOVER_CORRECTION_BYTES, 0xff);
                    return mask_bytes;
                }();
                const auto mask = std::bit_cast<const vole_block>(mask_bytes);
                // use this mask to choose the correction or not
                c_out[FULL_VOLE_CORRECTION_BLOCKS] =
                    (mask & u_or_c_in[FULL_VOLE_CORRECTION_BLOCKS]) ^
                    accum[FULL_VOLE_CORRECTION_BLOCKS];
            }
            if constexpr (START_UNCORRECTED_BLOCKS < CP::VOLE_COL_BLOCKS)
            {
                // copy u for the remainder
                memcpy(&c_out[START_UNCORRECTED_BLOCKS], &accum[START_UNCORRECTED_BLOCKS],
                       (CP::VOLE_COL_BLOCKS - START_UNCORRECTED_BLOCKS) * sizeof(vole_block));
            }
        }
        else // for the first small VOLE
            memcpy(c_out, accum.data(), sizeof(accum));
    }
}

} // namespace detail

template <typename P>
void vole_sender(unsigned int k, const block_secpar<P::secpar_v>* __restrict__ keys,
                 typename P::vole_prg_t::iv_t iv, typename P::vole_prg_t::tweak_t tweak,
                 const vole_block* __restrict__ u, vole_block* __restrict__ v,
                 vole_block* __restrict__ c)
{
    detail::vole<P, false>(k, keys, iv, tweak, u, v, c, NULL);
}

template <typename P>
void vole_receiver(unsigned int k, const block_secpar<P::secpar_v>* __restrict__ keys,
                   typename P::vole_prg_t::iv_t iv, typename P::vole_prg_t::tweak_t tweak,
                   const vole_block* __restrict__ c, vole_block* __restrict__ q,
                   const uint8_t* __restrict__ delta)
{
    detail::vole<P, true>(k, keys, iv, tweak, c, q, NULL, delta);
}

template <typename P>
void vole_receiver_apply_correction(size_t row_blocks, size_t cols,
                                    const vole_block* __restrict__ c, vole_block* __restrict__ q,
                                    const uint8_t* __restrict__ delta)
{
    for (unsigned int col = 0; col < cols; ++col)
        for (size_t j = 0; j < row_blocks; ++j)
            q[col * detail::COL_LEN<P> + j] =
                q[col * detail::COL_LEN<P> + j] ^ c[j] & vole_block::set_all_8(delta[col]);
}

} // namespace faest

#endif
