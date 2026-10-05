#ifndef VOLE_KEY_INDEX_PERMUTATION_HPP
#define VOLE_KEY_INDEX_PERMUTATION_HPP

#include <cstddef>

namespace faest
{

template <std::size_t VOLE_WIDTH_SHIFT> inline constexpr size_t vole_permute_key_index(size_t i)
{
    constexpr auto VOLE_WIDTH = 1 << VOLE_WIDTH_SHIFT;
    // Convert the high bits of i (indicating which chunk of VOLE_WIDTH keys) to Gray's code, while
    // keeping the low bits (indicating the position within the VOLE_WIDTH keys) unchanged.
    return i ^ ((i >> 1) & -VOLE_WIDTH);
}

template <std::size_t VOLE_WIDTH_SHIFT, std::size_t MAX_K>
inline constexpr size_t vole_permute_key_index_inv(size_t i)
{
    constexpr auto VOLE_WIDTH = 1 << VOLE_WIDTH_SHIFT;

    size_t j = i;

#ifdef __GNUC__
#pragma GCC unroll(5)
#endif
    for (unsigned int shift = 1; shift < MAX_K - VOLE_WIDTH_SHIFT; shift <<= 1)
        j ^= (j >> shift);

    return (j & -VOLE_WIDTH) + (i % VOLE_WIDTH);
}

// Optimized computation of vole_permute_key_index_inv(i) ^ vole_permute_key_index_inv(i + offset).
// offset must be a power of 2, and must be at most VOLE_WIDTH. Note that vole_permute_key_index_inv
// is a linear operation over GF(2), so
// vole_permute_key_index_inv(i ^ delta) ^ vole_permute_key_index_inv((i + offset) ^ delta)
// = vole_permute_key_index_inv(i) ^ vole_permute_key_index_inv(delta)
// ^ vole_permute_key_index_inv(i + offset) ^ vole_permute_key_index_inv(delta)
// = vole_permute_key_index_inv(i) ^ vole_permute_key_index_inv(i + offset)
// = vole_permute_inv_increment(i + offset)
template <std::size_t VOLE_WIDTH_SHIFT, std::size_t MAX_K>
inline constexpr size_t vole_permute_inv_increment(size_t i, size_t offset)
{
    constexpr auto VOLE_WIDTH = 1 << VOLE_WIDTH_SHIFT;
    static_assert(MAX_K < 16, "");

    size_t diff_in = i ^ (i + offset);
    size_t diff_out_even = diff_in & (0x5555 | (VOLE_WIDTH - 1));
    size_t diff_out_odd = diff_in & (0xAAAA | (VOLE_WIDTH - 1));
    return diff_out_odd > diff_out_even ? diff_out_odd : diff_out_even;
}

} // namespace faest

#endif
