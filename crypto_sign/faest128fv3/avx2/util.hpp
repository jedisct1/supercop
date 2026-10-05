#ifndef UTIL_HPP
#define UTIL_HPP

#include <array>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <cstring>

namespace faest
{

#if defined(__GNUC__)
#define ALWAYS_INLINE inline __attribute__((__always_inline__))
#elif defined(_MSC_VER)
#define ALWAYS_INLINE __forceinline
#else
#define ALWAYS_INLINE inline
#endif

#define STRINGIZE_NO_EXPAND(x) #x
#define STRINGIZE(x) STRINGIZE_NO_EXPAND(x)

#ifdef __GNUC__
#define PRAGMA_UNROLL(x) _Pragma(STRINGIZE(GCC unroll (x)))
#else
#define PRAGMA_UNROLL(x)
#endif

#ifndef NDEBUG
#define FAEST_ASSERT(x) assert(x)
#else
#define FAEST_ASSERT(x) [[assume(x)]]
#endif

inline unsigned int count_trailing_zeros(uint64_t x)
{
#if defined(__GNUC__) || defined(__clang__)
    return __builtin_ctzll(x);
#elif defined(_MSC_VER)
    unsigned long result;
    _BitScanForward64(&result, x);
    return result;
#endif

    for (unsigned int i = 0; i < 64; ++i, x >>= 1)
        if (x & 1)
            return i;
    return 64;
}

template <typename T, size_t bit_len = std::numeric_limits<T>::digits>
constexpr T select_highest_bit_set(T x)
{
    if (bit_len == 1)
        return x & ~(x >> 1);
    else
        return select_highest_bit_set<T, bit_len / 2>(x | (x >> bit_len / 2));
}

// Expands bit i of x to a whole byte, either 0 or 0xff.
ALWAYS_INLINE uint8_t expand_bit_to_byte(unsigned long x, unsigned int i) { return -((x >> i) & 1); }

// Converts x into a little-endian expanded form, such that each bit of x is encoded as a whole
// byte, either 0 or 0xff.
ALWAYS_INLINE void expand_bits_to_bytes(uint8_t* output, size_t num_bits, size_t x)
{
    FAEST_ASSERT(num_bits <= sizeof(x) * 8);
    for (size_t i = 0; i < num_bits; ++i)
        output[i] = expand_bit_to_byte(x, i);
}

// Converts a byte string x into a little-endian expanded form, such that each bit of x is encoded
// as a whole byte, either 0 or 0xff.
ALWAYS_INLINE void expand_bits_to_bytes(uint8_t* output, size_t num_bits, const uint8_t* x)
{
    for (size_t i = 0; i < num_bits; ++i)
        output[i] = expand_bit_to_byte(x[i / 8], i % 8);
}

ALWAYS_INLINE size_t rotate_left(size_t x, unsigned int shift, unsigned int n_bits)
{
    shift %= n_bits;
    size_t mask = ((size_t)1 << n_bits) - 1;
    return ((x << shift) & mask) + ((x & mask) >> (n_bits - shift));
}

ALWAYS_INLINE size_t rotate_right(size_t x, unsigned int shift, unsigned int n_bits)
{
    shift %= n_bits;
    size_t mask = ((size_t)1 << n_bits) - 1;
    return ((x << (n_bits - shift)) & mask) + ((x & mask) >> shift);
}

template <size_t length, size_t bit_pos, typename T, typename... Args>
std::array<T, length> array_dup_impl(const T& x, Args... args)
{
    if constexpr (bit_pos == 0)
        return {args...};
    else if constexpr ((length & bit_pos) == 0)
        return array_dup_impl<length, bit_pos / 2, T>(x, args..., args...);
    else
        return array_dup_impl<length, bit_pos / 2, T>(x, x, args..., args...);
}

// Create an array contain length copies of x.
template <size_t length, typename T>
std::array<T, length> array_dup(const T& x)
{
    return array_dup_impl<length, select_highest_bit_set(length), T>(x);
}

// Read a chunk of N bits from src[pos,pos+N) (using bit indices)
// and output it in the N least significant bits of an integer.
// - We assume src contains at least ceil((pos + N) / bytes.
template <size_t N>
uint64_t extract_bits(const uint8_t* src, size_t pos)
    requires(N <= 56)
{
    constexpr uint64_t mask = (uint64_t{1} << N) - 1;
    const size_t byte_start = pos / 8;
    const size_t bit_offset = pos % 8;
    const size_t chunk_size = (bit_offset + N + 7) / 8;
    uint64_t chunk = 0;
    assert(chunk_size <= sizeof(chunk));
    memcpy(&chunk, src + byte_start, chunk_size);
    return (chunk >> bit_offset) & mask;
}

// Write the N least significant bits from val to dst[pos,pos+N) (using bit indices)
// without modifying any other bits of dst.
// - We assume dst contains at least ceil((pos + N) / bytes.
template <size_t N>
void insert_bits(uint8_t* dst, size_t pos, uint64_t val)
    requires(N <= 56)
{
    // assert(val < (uint64_t{1} << N));
    constexpr uint64_t mask = ~((uint64_t{1} << N) - 1);
    const size_t byte_start = pos / 8;
    const size_t bit_offset = pos % 8;
    const size_t chunk_size = (bit_offset + N + 7) / 8;
    uint64_t chunk = 0;
    memcpy(&chunk, dst + byte_start, chunk_size);
    chunk &= (mask << bit_offset) | ((uint64_t{1} << bit_offset) - 1);
    chunk |= val << bit_offset;
    memcpy(dst + byte_start, &chunk, chunk_size);
}

} // namespace faest

#endif
