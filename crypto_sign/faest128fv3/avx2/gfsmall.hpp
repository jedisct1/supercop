#ifndef GFSMALL_HPP
#define GFSMALL_HPP

#ifdef __AVX2__
#include "gfsmall_impl.hpp"
#elifdef __aarch64__
#include "gfsmall_impl.hpp"
#else
#error "unsupported architecture"
#endif

#include "block.hpp"
#include "util.hpp"
#include <cstdint>
#include <cstring>

namespace faest
{

namespace detail
{

// Compute the index of the highest bit in q that is set to 1.
consteval size_t get_index_of_highest_1(uint64_t q)
{
    assert(q > 0);
    size_t n = 0;
    while (q >>= 1)
        ++n;
    return n;
}

// Divide X^64 by Q during compile time
template <uint64_t Q>
    requires(Q > 0)
consteval uint64_t div_x64_by_q()
{
    uint64_t t = 0;
    uint64_t p = 0; // p = X^64, but the 64th coefficient is implicit
    size_t deg_p = 64;
    const auto deg_q = get_index_of_highest_1(Q);
    while (deg_p >= deg_q)
    {
        const auto deg_diff = deg_p - deg_q;
        p ^= (Q << deg_diff);
        t ^= (uint64_t{1} << deg_diff);
        if (p == 0)
            break;
        deg_p = get_index_of_highest_1(p);
    }
    return t;
}

} // namespace detail

// Reduction of a polynomial of degree at most 63 modulo the given polynomial `q_in`
// and auxialiary value `x64_div_q` which must be X^64 // q.
ALWAYS_INLINE uint64_t barret_reduce_64_with_x64divq(uint64_t x_in, uint64_t q_in,
                                                     uint64_t x64_div_q)
{
    FAEST_ASSERT(q_in > 0);
    const auto x = block128::set_low64(x_in);
    // The modulus polynomial.
    const auto q = block128::set_low64(q_in);
    // X^64 // q
    const auto m = block128::set_low64(x64_div_q);
    return (x ^ block128::clmul_hl(block128::clmul_ll(x, m), q)).get_low64();
}

// Reduction of a polynomial of degree at most 63 modulo the given MODULUS polynomial.
template <uint64_t MODULUS>
    requires(MODULUS > 0)
ALWAYS_INLINE uint64_t barret_reduce_64(uint64_t x_in)
{
    return barret_reduce_64_with_x64divq(x_in, MODULUS, detail::div_x64_by_q<MODULUS>());
}

// Reduction of a polynomial of degree at most 63 modulo the GF(256) polynomial.
inline block128 gf256_barret_reduce_64(block128 x)
{
    // FAEST_ASSERT that the upper 64 bits are zero.
    FAEST_ASSERT(x.get_high64() == 0);
    // The modulus polynomial.
    const auto q8 = block128::set_low64(0b100011011);
    // X^64 // q8
    const auto m = block128::set_low64(0x11a59bcec98e023);
    return x ^ block128::clmul_hl(block128::clmul_ll(x, m), q8);
}

// Reduction of a polynomial of degree at most 119 modulo the GF(256) polynomial.
// (high 64 bits of the result might contain garbage)
inline block128 gf256_barret_reduce_120(block128 x)
{
    // FAEST_ASSERT that the upper 8 bits are zero.
    FAEST_ASSERT((x.get_high64() & 0xff00000000000000) == 0);
    // The modulus polynomial.
    const auto q8 = block128::set_low64(0b100011011);
    // X^64 // q8
    const auto m = block128::set_low64(0x11a59bcec98e023);
    // X^64 mod q8
    const auto r = block128::set_low64(0b01001101);
    const auto y = x ^ block128::clmul_hl(x, r);
    return y ^ block128::clmul_hl(block128::clmul_ll(y, m), q8);
}

inline uint8_t gf256_compress_gf16_subfield(uint8_t x)
{
    // 0, 6, 7, 2
    uint8_t y = 0;
    y |= x & 1;
    y |= (x >> 5) & 6;
    y |= (x << 1) & 8;
    return y;
}

inline uint8_t gf256_decompress_gf16_subfield(uint8_t x)
{
    // basis: [1, W^6 + W^4, W^7 + W^5 + W^4, W^3 + W^2]
    uint8_t y = 0;
    y |= x & 0b0001;
    y |= (x & 0b1000) >> 1;
    y |= x & 0b1000;
    y |= ((x & 0b0010) << 3) ^ ((x & 0b0100) << 2);
    y |= (x & 0b0100) << 3;
    y |= (x & 0b0010) << 5;
    y |= (x & 0b0100) << 5;
    return y;
}

inline uint8_t gf256_gf16_norm(uint8_t in)
{
    const auto x = block128::set_low32(in);     //   7
    const auto x2 = block128::clmul_ll(x, x);   //  14
    const auto x4 = block128::clmul_ll(x2, x2); //  28
    const auto x8 = block128::clmul_ll(x4, x4); //  56
    const auto x9 = block128::clmul_ll(x, x8);  //  63
    // const auto x16 = block128::clmul_ll(x8, x8);                           // 112
    const auto x17 = block128::clmul_ll(x8, x9); // 119
    const auto y = gf256_barret_reduce_120(x17);
    uint8_t out;
    memcpy(&out, &y, 1);
    return out;
}

inline uint8_t gf256_gf16_invnorm(uint8_t in)
{
    const auto x = block128::set_low32(in);                                //  8
    const auto x2 = block128::clmul_ll(x, x);                              // 16
    const auto x4 = block128::clmul_ll(x2, x2);                            // 32
    const auto x8 = gf256_barret_reduce_64(block128::clmul_ll(x4, x4));    //  8
    const auto x16 = block128::clmul_ll(x8, x8);                           // 16
    const auto x32 = block128::clmul_ll(x16, x16);                         // 32
    const auto x64 = gf256_barret_reduce_64(block128::clmul_ll(x32, x32)); //  8
    const auto x128 = block128::clmul_ll(x64, x64);                        // 16
    const auto x36 = gf256_barret_reduce_64(block128::clmul_ll(x4, x32));  //  8
    const auto x10 = block128::clmul_ll(x2, x8);                           // 24
    const auto x191 = block128::clmul_ll(x64, x128);                       // 24
    const auto x46 = block128::clmul_ll(x36, x10);                         // 32
    const auto x238 = block128::clmul_ll(x46, x191);                       // 56
    const auto y = gf256_barret_reduce_64(x238);
    uint8_t out;
    memcpy(&out, &y, 1);
    return out;
}

inline block128 gf256_batch_compress_gf16_subfield(block128 x)
{
    // 0, 6, 7, 2
    const auto mask_1 = block128::set_all_8(1);
    const auto mask_6 = block128::set_all_8(6);
    const auto mask_8 = block128::set_all_8(8);

    const auto x_srl_5 = x.shift_right_each_16<5>();
    const auto y = (((x & mask_1) | (x_srl_5 & mask_6)) | (x.shift_left_each_16<1>() & mask_8));
    return y;
}

template <size_t n> inline void gf256_gf16_batch_invnorm(uint8_t* out, const uint8_t* in)
{
    FAEST_ASSERT(n % 2 == 0);

    std::array<uint8_t, 16> buf;
    block128 block;
    constexpr auto complete_blocks = n / 16;
    for (size_t i = 0; i < complete_blocks; ++i, in += 16, out += 8)
    {
        memcpy(buf.data(), in, buf.size());
        // compute norms -> GF(16) subfield
        for (size_t j = 0; j < 16; ++j)
            buf[j] = gf256_gf16_norm(buf[j]);
        memcpy(&block, buf.data(), sizeof(block));
        // compress to 4 bits
        block = gf256_batch_compress_gf16_subfield(block);
        // invert in GF(16)
        block = gf256_batch_compressed_gf16_inverse(block);
        // write into output
        block = compress_gf16_vector(block);
        memcpy(out, &block, sizeof(block) / 2);
    }
    if constexpr (constexpr auto remainder = n % 16)
    {
        memcpy(buf.data(), in, remainder);
        // compute norms -> GF(16) subfield
        for (size_t j = 0; j < remainder; ++j)
            buf[j] = gf256_gf16_norm(buf[j]);
        memcpy(&block, buf.data(), sizeof(block));
        // compress to 4 bits
        block = gf256_batch_compress_gf16_subfield(block);
        // invert in GF(16)
        block = gf256_batch_compressed_gf16_inverse(block);
        // write into output
        block = compress_gf16_vector(block);
        memcpy(out, &block, remainder / 2);
    }
}

}

#endif
