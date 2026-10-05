#ifndef POLYNOMIALS_HPP
#define POLYNOMIALS_HPP

#include "block.hpp"
#include "parameters.hpp"
#include "polynomials_constants.hpp"
#include "util.hpp"
#include <cstdint>
#include <cstring>

namespace faest
{
template <std::size_t size> struct poly;

using poly1 = poly<1>;
using poly64 = poly<64>;
using poly128 = poly<128>;
using poly192 = poly<192>;
using poly256 = poly<256>;
using poly320 = poly<320>;
using poly384 = poly<384>;
using poly512 = poly<512>;

template <secpar S> using poly_secpar = poly<secpar_to_bits(S)>;
template <secpar S> using poly_secpar_plus_64 = poly<secpar_to_bits(S) + 64>;
template <secpar S> using poly_2secpar = poly<2 * secpar_to_bits(S)>;

template <std::size_t size> inline poly<size> operator+(poly<size> x, poly<size> y);
template <std::size_t size1, std::size_t size2>
poly<size1 + size2> operator*(poly<size1> x, poly<size2> y);
template <std::size_t size> poly<size> operator*(poly1 x, poly<size> y);
template <std::size_t size> inline bool operator==(poly<size> x, poly<size> y);

namespace detail
{
inline void karatsuba_mul_128_uninterpolated_other_sum(poly128 x, poly128 y, poly128 x_for_sum,
                                                       poly128 y_for_sum, poly128* out);
inline void karatsuba_mul_128_uninterpolated(poly128 x, poly128 y, poly128* out);
inline void karatsuba_mul_128_uncombined(poly128 x, poly128 y, poly128* out);
inline void combine_poly128s(poly128* out, const poly128* in, size_t n);
inline static clmul_block poly1_to_bit_mask(poly1 x);
inline void poly_shift_left_1(clmul_block* x, size_t chunks);
inline void poly_shift_left_8(clmul_block* out, const clmul_block* in, size_t chunks);
template <size_t size> poly<size> poly_exp(poly<size> base, size_t power);
} // namespace detail

// The single bit in each polynomial is duplicated for a whole byte.
template <> struct poly<1>
{
    uint8_t data;

    poly() = default;
    poly(unsigned long x) { *this = load(x, 0); }

    inline static poly1 set_zero() { return {0}; }
    inline static poly1 set_one() { return {0xff}; }

    inline static poly1 set_all(uint8_t x) { return {x}; }

    inline static poly1 load(unsigned long x, unsigned int bit_offset)
    {
        poly1 poly;
        poly.data = ((x >> bit_offset) & 1) * 0xff;
        return poly;
    }

    inline static poly1 load_offset8(const void* s, unsigned int bit_offset)
    {
        poly1 poly;
        memcpy(&poly.data, s, sizeof(poly.data));
        poly.data >>= bit_offset;
        poly.data &= 1;
        poly.data *= 0xff;
        return poly;
    }

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

// This is twice as long as it needs to be. It is treated as a poly128, with the high half of
// each 128-bit polynomial ignored.
template <> struct poly<64>
{
    clmul_block data;

    inline static poly64 load(const void* s)
    {
        uint64_t in;
        memcpy(&in, s, sizeof(in));
        return {clmul_block::set_low64(in)};
    }

    inline static poly64 load_dup(const void* s) { return load(s); }

    inline void store(void* d) const
    {
        uint64_t out = this->data.get_low64();
        memcpy(d, &out, sizeof(out));
    }

    inline poly64 extract(size_t index) const
    {
        (void)index;
        return *this;
    }

    inline static poly64 set_zero() { return {clmul_block::set_zero()}; }

    inline static poly64 set_low32(uint32_t x) { return {clmul_block::set_low32(x)}; }

    inline poly64 mul_a64_reduce64() const
    {
        poly64 modulus = set_low32(gf64_modulus);
        clmul_block high = clmul_block::clmul_ll(modulus.data, this->data); // Degree < 64 + 4
        clmul_block high_high = clmul_block::clmul_lh(modulus.data, high);  // Degree < 4 + 4

        // Only low 64 bits are correct, but the high 64 will be ignored anyway.
        return {high ^ high_high};
    }

    inline poly64 exp(size_t power) const { return detail::poly_exp(*this, power); }

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

template <> struct poly<128>
{
    clmul_block data;

    inline static poly128 load(const void* s)
    {
        poly128 out;
        memcpy(&out, s, sizeof(out));
        return out;
    }

    inline static poly128 load_dup(const void* s) { return load(s); }

    inline static poly128 from_block(block128 b) { return load(&b); }

    inline void store(void* d) const { memcpy(d, this, sizeof(*this)); }

    inline void store1(void* d) const { store(d); }

    inline block128 to_block() const
    {
        block128 b;
        store(&b);
        return b;
    }

    inline poly128 extract(size_t index) const
    {
        (void)index;
        return *this;
    }

    template <std::size_t other_size> inline static poly128 from(poly<other_size> x)
    {
        if constexpr (other_size == 1)
        {
            return from_1(x);
        }
        else if constexpr (other_size == 64)
        {
            // set the unused bits to zero
            return {x.data.zero_high64()};
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly128 set_zero() { return {clmul_block::set_zero()}; }

    inline static poly128 set_low32(uint32_t x) { return {clmul_block::set_low32(x)}; }

    template <std::size_t out_size> inline poly<out_size> reduce_to() const
    {
        if constexpr (out_size == 64)
        {
            poly64 modulus = poly64::set_low32(gf64_modulus);
            clmul_block high = clmul_block::clmul_lh(modulus.data, this->data); // Degree < 64 + 4
            clmul_block high_high = clmul_block::clmul_lh(modulus.data, high);  // Degree < 4 + 4

            // Only low 64 bits are correct, but the high 64 will be ignored anyway.
            return {this->data ^ high ^ high_high};
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly128 from_1(poly1 x) { return {clmul_block::set_low32(x.data & 1)}; }

    inline static poly128 from_8_poly1(const poly1* bits);
    inline static poly128 from_8_self(const poly128* polys);

    inline static poly128 from_8_byte(uint8_t byte)
    {
        poly1 bits[8];
        for (size_t i = 0; i < 8; ++i)
            bits[i] = poly1::set_all(expand_bit_to_byte(byte, i));
        return from_8_poly1(bits);
    }

    inline poly128 exp(size_t power) const { return detail::poly_exp(*this, power); }

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

template <> struct poly<192>
{
    poly128 data[2]; // Striped in 128-bit chunks. Highest 64 bits of each poly are ignored.

    inline static poly192 load(const void* s)
    {
        poly192 out;
        memcpy(&out, s, sizeof(block128) + sizeof(block128) / 2);
        return out;
    }

    inline static poly192 load_dup(const void* s) { return load(s); }

    inline static poly192 from_block(block192 b) { return load(&b); }

    inline void store(void* d) const { memcpy(d, this, 24); }

    inline void store1(void* d) const { store(d); }

    inline block192 to_block() const
    {
        block192 b;
        store(&b);
        return b;
    }

    inline poly192 extract(size_t index) const
    {
        (void)index;
        return *this;
    }

    template <std::size_t other_size> inline static poly192 from(poly<other_size> x)
    {
        poly192 out;
        if constexpr (other_size == 1)
        {
            return from_1(x);
        }
        else if constexpr (other_size == 64)
        {
            return from(poly128::from(x));
        }
        else if constexpr (other_size == 128)
        {
            out.data[0] = x;
            out.data[1] = {clmul_block::set_zero()};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly192 set_zero() { return {poly128::set_zero(), poly128::set_zero()}; }

    inline static poly192 set_low32(uint32_t x)
    {
        poly192 out;
        out.data[0] = poly128::set_low32(x);
        memset(&out.data[1], 0, sizeof(out.data[1]));
        return out;
    }

    template <std::size_t out_size> inline poly<out_size> reduce_to() const
    {
        if constexpr (out_size == 128)
        {
            poly64 modulus = poly64::set_low32(gf128_modulus);
            return this->data[0] + poly128{clmul_block::clmul_ll(modulus.data, this->data[1].data)};
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly192 from_1(poly1 x)
    {
        poly192 out;
        out.data[0] = poly128::from_1(x);
        out.data[1] = {clmul_block::set_zero()};
        return out;
    }

    inline static poly192 from_8_poly1(const poly1* bits);
    inline static poly192 from_8_self(const poly192* polys);

    inline static poly192 from_8_byte(uint8_t byte)
    {
        poly1 bits[8];
        for (size_t i = 0; i < 8; ++i)
            bits[i] = poly1::set_all(expand_bit_to_byte(byte, i));
        return from_8_poly1(bits);
    }

    inline poly192 exp(size_t power) const { return detail::poly_exp(*this, power); }

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

template <> struct poly<256>
{
    poly128 data[2]; // Striped in 128-bit chunks.

    inline static poly256 load(const void* s)
    {
        poly256 out;
        memcpy(&out, s, sizeof(out));
        return out;
    }

    inline static poly256 load_dup(const void* s) { return load(s); }

    inline static poly256 from_block(block256 b) { return load(&b); }

    inline void store(void* d) const { memcpy(d, this, sizeof(*this)); }

    inline void store1(void* d) const { store(d); }

    inline block256 to_block() const
    {
        block256 b;
        store(&b);
        return b;
    }

    inline poly256 extract(size_t index) const
    {
        (void)index;
        return *this;
    }

    template <std::size_t other_size> inline static poly256 from(poly<other_size> x)
    {
        poly256 out;
        if constexpr (other_size == 1)
        {
            return from_1(x);
        }
        else if constexpr (other_size == 64)
        {
            return from(poly128::from(x));
        }
        else if constexpr (other_size == 128)
        {
            out.data[0] = x;
            out.data[1] = {clmul_block::set_zero()};
            return out;
        }
        else if constexpr (other_size == 192)
        {
            out.data[0] = x.data[0];
            out.data[1] = {x.data[1].data.zero_high64()};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly256 set_zero() { return {poly128::set_zero(), poly128::set_zero()}; }

    inline static poly256 set_low32(uint32_t x)
    {
        poly256 out;
        out.data[0] = poly128::set_low32(x);
        memset(&out.data[1], 0, sizeof(out.data[1]));
        return out;
    }

    inline poly128 low_half() const { return {data[0]}; }
    inline poly128 high_half() const { return {data[1]}; }

    template <std::size_t out_size> inline poly<out_size> reduce_to() const
    {
        if constexpr (out_size == 128)
        {
            poly256 x = *this;
            poly64 modulus = poly64::set_low32(gf128_modulus);
            clmul_block reduced_192 = clmul_block::clmul_lh(modulus.data, x.data[1].data);
            x.data[0] = {x.data[0].data ^ reduced_192.shift_left_64()};
            x.data[1] = {x.data[1].data ^ (reduced_192.shift_right_64())};
            x.data[0] = {x.data[0].data ^ clmul_block::clmul_ll(modulus.data, x.data[1].data)};
            return x.data[0];
        }
        else if constexpr (out_size == 192)
        {
            poly64 modulus = poly64::set_low32(gf192_modulus);
            poly192 out;
            out.data[1] = this->data[1];
            out.data[0] = {this->data[0].data ^
                           clmul_block::clmul_lh(modulus.data, out.data[1].data)};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly256 from_1(poly1 x)
    {
        poly256 out;
        out.data[0] = poly128::from_1(x);
        out.data[1] = {clmul_block::set_zero()};
        return out;
    }

    inline static poly256 from_8_poly1(const poly1* bits);
    inline static poly256 from_8_self(const poly256* polys);

    inline static poly256 from_8_byte(uint8_t byte)
    {
        poly1 bits[8];
        for (size_t i = 0; i < 8; ++i)
            bits[i] = poly1::set_all(expand_bit_to_byte(byte, i));
        return from_8_poly1(bits);
    }

    inline poly256 shift_left_1() const;
    inline poly256 shift_left_8() const;

    inline poly256 exp(size_t power) const { return detail::poly_exp(*this, power); }

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

template <> struct poly<320>
{
    poly128 data[3]; // Striped in 128-bit chunks. Highest 64 bits of each poly are ignored.

    inline static poly320 load(const void* s)
    {
        poly320 out;
        memcpy(&out, s, 40);
        return out;
    }

    inline static poly320 load_dup(const void* s) { return load(s); }

    inline void store(void* d) const { memcpy(d, this, 40); }

    template <std::size_t other_size> inline static poly320 from(poly<other_size> x)
    {
        poly320 out;
        if constexpr (other_size == 256)
        {
            out.data[0] = x.data[0];
            out.data[1] = x.data[1];
            out.data[2] = {clmul_block::set_zero()};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly320 set_zero()
    {
        return {poly128::set_zero(), poly128::set_zero(), poly128::set_zero()};
    }

    inline static poly320 set_low32(uint32_t x)
    {
        poly320 out;
        out.data[0] = poly128::set_low32(x);
        memset(&out.data[1], 0, 2 * sizeof(out.data[1]));
        return out;
    }

    template <std::size_t out_size> inline poly<out_size> reduce_to() const
    {
        if constexpr (out_size == 256)
        {
            poly64 modulus = poly64::set_low32(gf256_modulus);
            poly256 out;
            out.data[1] = this->data[1];
            out.data[0] =
                this->data[0] + poly128{clmul_block::clmul_ll(modulus.data, this->data[2].data)};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

template <> struct poly<384>
{
    poly128 data[3]; // Striped in 128-bit chunks.

    inline static poly384 load(const void* s)
    {
        poly384 out;
        memcpy(&out, s, sizeof(out));
        return out;
    }

    inline static poly384 load_dup(const void* s) { return load(s); }

    inline void store(void* d) const { memcpy(d, this, sizeof(*this)); }

    inline poly384 extract(size_t index) const
    {
        (void)index;
        return *this;
    }

    template <std::size_t other_size> inline static poly384 from(poly<other_size> x)
    {
        poly384 out;
        if constexpr (other_size == 1)
        {
            out.data[0] = poly128::from(x);
            out.data[1] = {clmul_block::set_zero()};
            out.data[2] = {clmul_block::set_zero()};
            return out;
        }
        else if constexpr (other_size == 192)
        {
            out.data[0] = x.data[0];
            out.data[1] = {x.data[1].data.zero_high64()};
            out.data[2] = {clmul_block::set_zero()};
            return out;
        }
        else if constexpr (other_size == 256)
        {
            return {x.data[0], x.data[1], {clmul_block::set_zero()}};
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly384 set_zero()
    {
        return {poly128::set_zero(), poly128::set_zero(), poly128::set_zero()};
    }

    inline static poly384 set_low32(uint32_t x)
    {
        poly384 out;
        out.data[0] = poly128::set_low32(x);
        memset(&out.data[1], 0, 2 * sizeof(out.data[1]));
        return out;
    }

    inline poly192 low_half() const { return {data[0], data[1]}; }

    inline poly192 high_half() const
    {
        unsigned char tmp[384 / 8];
        store(tmp);
        return poly192::load(&tmp[192 / 8]);
    }

    template <std::size_t out_size> inline poly<out_size> reduce_to() const
    {
        if constexpr (out_size == 192)
        {
            poly64 modulus = poly64::set_low32(gf192_modulus);
            clmul_block reduced_320 = clmul_block::clmul_lh(modulus.data, this->data[2].data);
            clmul_block reduced_256 = clmul_block::clmul_ll(modulus.data, this->data[2].data);
            poly192 out;
            out.data[1] = {this->data[1].data ^ reduced_320};
            out.data[0] = {this->data[0].data ^ reduced_256.shift_left_64()};
            out.data[0] = {out.data[0].data ^
                           clmul_block::clmul_lh(modulus.data, out.data[1].data)};
            out.data[1] = {out.data[1].data ^ reduced_256.shift_right_64()};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    inline poly384 shift_left_1() const;
    inline poly384 shift_left_8() const;

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

template <> struct poly<512>
{
    poly128 data[4]; // Striped in 128-bit chunks.

    inline static poly512 load(const void* s)
    {
        poly512 out;
        memcpy(&out, s, sizeof(out));
        return out;
    }

    inline static poly512 load_dup(const void* s) { return load(s); }

    inline void store(void* d) const { memcpy(d, this, sizeof(*this)); }

    inline poly512 extract(size_t index) const
    {
        (void)index;
        return *this;
    }

    template <std::size_t other_size> inline static poly512 from(poly<other_size> x)
    {
        poly512 out;
        if constexpr (other_size == 1)
        {
            out.data[0] = poly128::from(x);
            out.data[1] = {clmul_block::set_zero()};
            out.data[2] = {clmul_block::set_zero()};
            out.data[3] = {clmul_block::set_zero()};
            return out;
        }
        else if constexpr (other_size == 256)
        {
            out.data[0] = x.data[0];
            out.data[1] = x.data[1];
            out.data[2] = {clmul_block::set_zero()};
            out.data[3] = {clmul_block::set_zero()};
            return out;
        }
        else if constexpr (other_size == 320)
        {
            out.data[0] = x.data[0];
            out.data[1] = x.data[1];
            out.data[2] = {x.data[2].data.zero_high64()};
            out.data[3] = {clmul_block::set_zero()};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    inline static poly512 set_zero()
    {
        return {poly128::set_zero(), poly128::set_zero(), poly128::set_zero(), poly128::set_zero()};
    }

    inline static poly512 set_low32(uint32_t x)
    {
        poly512 out;
        out.data[0] = poly128::set_low32(x);
        memset(&out.data[1], 0, 3 * sizeof(out.data[1]));
        return out;
    }

    inline poly256 low_half() const { return {data[0], data[1]}; }
    inline poly256 high_half() const { return {data[2], data[3]}; }

    template <std::size_t out_size> inline poly<out_size> reduce_to() const
    {
        if constexpr (out_size == 256)
        {
            poly64 modulus = poly64::set_low32(gf256_modulus);
            poly128 xmod[4];
            xmod[0] = poly128{clmul_block::set_zero()};
            xmod[1] = poly128{clmul_block::clmul_lh(modulus.data, this->data[2].data)};
            xmod[2] = poly128{clmul_block::clmul_ll(modulus.data, this->data[3].data)};
            xmod[3] = poly128{clmul_block::clmul_lh(modulus.data, this->data[3].data)};

            poly128 xmod_combined[3];
            detail::combine_poly128s(&xmod_combined[0], &xmod[0], 4);
            for (size_t i = 0; i < 3; ++i)
                xmod_combined[i] = xmod_combined[i] + this->data[i];
            xmod_combined[0] = xmod_combined[0] +
                               poly128{clmul_block::clmul_ll(modulus.data, xmod_combined[2].data)};

            poly256 out;
            for (size_t i = 0; i < 2; ++i)
                out.data[i] = {xmod_combined[i]};
            return out;
        }
        else
        {
            static_assert(false);
        }
    }

    inline poly512 shift_left_1() const;
    inline poly512 shift_left_8() const;

    template <typename T> poly& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template <typename T> poly& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

template <> inline bool operator==(poly1 x, poly1 y) { return x.data == y.data; }

template <> inline bool operator==(poly64 x, poly64 y)
{
    return x.data.get_low64() == y.data.get_low64();
}

template <> inline bool operator==(poly128 x, poly128 y) { return (x.data ^ y.data).all_zeros(); }

template <> inline bool operator==(poly192 x, poly192 y)
{
    return (x.data[0] == y.data[0]) && (x.data[1].data.get_low64() == y.data[1].data.get_low64());
}

template <> inline bool operator==(poly256 x, poly256 y)
{
    return (x.data[0] == y.data[0]) && (x.data[1] == y.data[1]);
}

template <> inline bool operator==(poly320 x, poly320 y)
{
    return (x.data[0] == y.data[0]) && (x.data[1] == y.data[1]) &&
           (x.data[2].data.get_low64() == y.data[2].data.get_low64());
}

template <> inline bool operator==(poly384 x, poly384 y)
{
    return (x.data[0] == y.data[0]) && (x.data[1] == y.data[1]) && (x.data[2] == y.data[2]);
}

template <> inline bool operator==(poly512 x, poly512 y)
{
    return (x.data[0] == y.data[0]) && (x.data[1] == y.data[1]) && (x.data[2] == y.data[2]) &&
           (x.data[3] == y.data[3]);
}

template <> inline poly1 operator+(poly1 x, poly1 y)
{
    return {static_cast<uint8_t>(x.data ^ y.data)};
}

template <> inline poly64 operator+(poly64 x, poly64 y) { return {x.data ^ y.data}; }

template <> inline poly128 operator+(poly128 x, poly128 y) { return {x.data ^ y.data}; }

template <> inline poly192 operator+(poly192 x, poly192 y)
{
    return {{x.data[0] + y.data[0], x.data[1] + y.data[1]}};
}

template <> inline poly256 operator+(poly256 x, poly256 y)
{
    return {{x.data[0] + y.data[0], x.data[1] + y.data[1]}};
}

template <> inline poly320 operator+(poly320 x, poly320 y)
{
    return {{x.data[0] + y.data[0], x.data[1] + y.data[1], x.data[2] + y.data[2]}};
}

template <> inline poly384 operator+(poly384 x, poly384 y)
{
    return {{x.data[0] + y.data[0], x.data[1] + y.data[1], x.data[2] + y.data[2]}};
}

template <> inline poly512 operator+(poly512 x, poly512 y)
{
    return {{x.data[0] + y.data[0], x.data[1] + y.data[1], x.data[2] + y.data[2],
             x.data[3] + y.data[3]}};
}

template <> inline poly128 operator*(poly64 x, poly64 y)
{
    return {clmul_block::clmul_ll(x.data, y.data)};
}

template <> inline poly256 operator*(poly128 x, poly128 y)
{
    poly128 karatsuba_out[3];
    detail::karatsuba_mul_128_uncombined(x, y, &karatsuba_out[0]);

    poly256 out;
    detail::combine_poly128s(&out.data[0], &karatsuba_out[0], 3);
    return out;
}

template <> inline poly384 operator*(poly192 x, poly192 y)
{
    // Something like Toom-Cook.

    // Evaluate at 0.
    poly128 xlow_ylow = {clmul_block::clmul_ll(x.data[0].data, y.data[0].data)};

    // Evaluate at infinity.
    poly128 xhigh_yhigh = {clmul_block::clmul_ll(x.data[1].data, y.data[1].data)};

    // Evaluate at 1.
    clmul_block x1_cat_y0_plus_y2 =
        clmul_block::mix_64(y.data[0].data ^ y.data[1].data, x.data[0].data);
    clmul_block xsum = x.data[0].data ^ x.data[1].data ^ x1_cat_y0_plus_y2; // Result in low.
    clmul_block ysum = y.data[0].data ^ x1_cat_y0_plus_y2;                  // Result in high.
    poly128 xsum_ysum = {clmul_block::clmul_lh(xsum, ysum)};

    // Evaluate at the root of a^2 + a + 1.
    poly128 xa = x.data[0] + poly128{x.data[1].data.broadcast_low64()};
    poly128 ya = y.data[0] + poly128{y.data[1].data.broadcast_low64()};
    // Karatsuba multiplication of two degree 1 polynomials (with deg <64 polynomial coefficients).
    poly128 karatsuba_out[3];
    detail::karatsuba_mul_128_uninterpolated_other_sum(xa, ya, x.data[0], y.data[0],
                                                       &karatsuba_out[0]);
    poly128 xya0 = karatsuba_out[0] + karatsuba_out[2];
    poly128 xya1 = karatsuba_out[0] + karatsuba_out[1];

    // Interpolate through the 4 evaluation points.
    poly128 xya0_plus_xsum_ysum = xya0 + xsum_ysum;
    poly128 interp[5];
    interp[0] = xlow_ylow;
    interp[1] = xya0_plus_xsum_ysum + xhigh_yhigh;
    interp[2] = xya0_plus_xsum_ysum + xya1;
    interp[3] = xlow_ylow + xsum_ysum + xya1;
    interp[4] = xhigh_yhigh;

    // Combine overlapping 128-bit chunks.
    poly384 out;
    detail::combine_poly128s(&out.data[0], &interp[0], 5);
    return out;
}

template <> inline poly512 operator*(poly256 x, poly256 y)
{
    // Karatsuba multiplication.
    poly128 x0y0[3], x1y1[3], xsum_ysum[3];
    detail::karatsuba_mul_128_uncombined(x.data[0], y.data[0], &x0y0[0]);
    detail::karatsuba_mul_128_uncombined(x.data[1], y.data[1], &x1y1[0]);

    poly128 xsum = x.data[0] + x.data[1];
    poly128 ysum = y.data[0] + y.data[1];
    detail::karatsuba_mul_128_uncombined(xsum, ysum, &xsum_ysum[0]);

    poly128 x0y0_2_plus_x1y1_0 = x0y0[2] + x1y1[0];

    poly128 combined[7];
    combined[0] = x0y0[0];
    combined[1] = x0y0[1];
    combined[2] = xsum_ysum[0] + x0y0[0] + x0y0_2_plus_x1y1_0;
    combined[3] = xsum_ysum[1] + x0y0[1] + x1y1[1];
    combined[4] = xsum_ysum[2] + x1y1[2] + x0y0_2_plus_x1y1_0;
    combined[5] = x1y1[1];
    combined[6] = x1y1[2];

    poly512 out;
    detail::combine_poly128s(&out.data[0], &combined[0], 7);
    return out;
}

template <> inline poly192 operator*(poly64 x, poly128 y)
{
    poly128 xy[2];
    xy[0] = poly128{clmul_block::clmul_ll(x.data, y.data)};
    xy[1] = poly128{clmul_block::clmul_lh(x.data, y.data)};

    poly192 out;
    detail::combine_poly128s(&out.data[0], &xy[0], 2);
    return out;
}

template <> inline poly256 operator*(poly64 x, poly192 y)
{
    poly128 xy[3];
    xy[0] = poly128{clmul_block::clmul_ll(x.data, y.data[0].data)};
    xy[1] = poly128{clmul_block::clmul_lh(x.data, y.data[0].data)};
    xy[2] = poly128{clmul_block::clmul_ll(x.data, y.data[1].data)};

    poly256 out;
    detail::combine_poly128s(&out.data[0], &xy[0], 3);
    return out;
}

template <> inline poly320 operator*(poly64 x, poly256 y)
{
    poly128 xy[4];
    xy[0] = poly128{clmul_block::clmul_ll(x.data, y.data[0].data)};
    xy[1] = poly128{clmul_block::clmul_lh(x.data, y.data[0].data)};
    xy[2] = poly128{clmul_block::clmul_ll(x.data, y.data[1].data)};
    xy[3] = poly128{clmul_block::clmul_lh(x.data, y.data[1].data)};

    poly320 out;
    detail::combine_poly128s(&out.data[0], &xy[0], 4);
    return out;
}

template <> inline poly128 operator*(poly1 x, poly128 y)
{
    return {detail::poly1_to_bit_mask(x) & y.data};
}

template <> inline poly192 operator*(poly1 x, poly192 y)
{
    clmul_block mask = detail::poly1_to_bit_mask(x);
    poly192 out;
    out.data[0] = {mask & y.data[0].data};
    out.data[1] = {mask & y.data[1].data};
    return out;
}

template <> inline poly256 operator*(poly1 x, poly256 y)
{
    clmul_block mask = detail::poly1_to_bit_mask(x);
    poly256 out;
    out.data[0] = {mask & y.data[0].data};
    out.data[1] = {mask & y.data[1].data};
    return out;
}

inline poly256 poly256::shift_left_1() const
{
    poly256 out = *this;
    detail::poly_shift_left_1(&out.data[0].data, 2);
    return out;
}
inline poly384 poly384::shift_left_1() const
{
    poly384 out = *this;
    detail::poly_shift_left_1(&out.data[0].data, 3);
    return out;
}
inline poly512 poly512::shift_left_1() const
{
    poly512 out = *this;
    detail::poly_shift_left_1(&out.data[0].data, 4);
    return out;
}

inline poly256 poly256::shift_left_8() const
{
    poly256 out;
    detail::poly_shift_left_8(&out.data[0].data, &this->data[0].data, 2);
    return out;
}
inline poly384 poly384::shift_left_8() const
{
    poly384 out;
    detail::poly_shift_left_8(&out.data[0].data, &this->data[0].data, 3);
    return out;
}
inline poly512 poly512::shift_left_8() const
{
    poly512 out;
    detail::poly_shift_left_8(&out.data[0].data, &this->data[0].data, 4);
    return out;
}

inline poly128 poly128::from_8_poly1(const poly1* bits)
{
    poly128 out = from_1(bits[0]);
    for (size_t i = 1; i < 8; ++i)
        out = out + bits[i] * poly128::load_dup(gf8_in_gf128[i - 1]);
    return out;
}

inline poly192 poly192::from_8_poly1(const poly1* bits)
{
    poly192 out = from_1(bits[0]);
    for (size_t i = 1; i < 8; ++i)
        out = out + bits[i] * poly192::load_dup(gf8_in_gf192[i - 1]);
    return out;
}

inline poly256 poly256::from_8_poly1(const poly1* bits)
{
    poly256 out = from_1(bits[0]);
    for (size_t i = 1; i < 8; ++i)
        out = out + bits[i] * poly256::load_dup(gf8_in_gf256[i - 1]);
    return out;
}

inline poly128 poly128::from_8_self(const poly128* polys)
{
    poly256 out = poly256::from<128>(polys[0]);
    for (size_t i = 1; i < 8; ++i)
        out = out + polys[i] * poly128::load_dup(gf8_in_gf128[i - 1]);
    return out.reduce_to<128>();
}

inline poly192 poly192::from_8_self(const poly192* polys)
{
    poly384 out = poly384::from<192>(polys[0]);
    for (size_t i = 1; i < 8; ++i)
        out = out + polys[i] * poly192::load_dup(gf8_in_gf192[i - 1]);
    return out.reduce_to<192>();
}

inline poly256 poly256::from_8_self(const poly256* polys)
{
    poly512 out = poly512::from<256>(polys[0]);
    for (size_t i = 1; i < 8; ++i)
        out = out + polys[i] * poly256::load_dup(gf8_in_gf256[i - 1]);
    return out.reduce_to<256>();
}

namespace detail
{
inline static clmul_block poly1_to_bit_mask(poly1 x) { return {clmul_block::set_all_8(x.data)}; }

// Karatsuba multiplication, but end right after the multiplications, and use a different pair of
// vectors as the inputs for the sum of x and the sum of y.
inline void karatsuba_mul_128_uninterpolated_other_sum(poly128 x, poly128 y, poly128 x_for_sum,
                                                       poly128 y_for_sum, poly128* out)
{
    poly128 x0y0 = {clmul_block::clmul_ll(x.data, y.data)};
    poly128 x1y1 = {clmul_block::clmul_hh(x.data, y.data)};
    clmul_block x1_cat_y0 = clmul_block::mix_64(y_for_sum.data, x_for_sum.data);
    clmul_block xsum = x_for_sum.data ^ x1_cat_y0; // Result in low.
    clmul_block ysum = y_for_sum.data ^ x1_cat_y0; // Result in high.
    poly128 xsum_ysum = {clmul_block::clmul_lh(xsum, ysum)};

    out[0] = x0y0;
    out[1] = xsum_ysum;
    out[2] = x1y1;
}

// Karatsuba multiplication, but end right after the multiplications.
inline void karatsuba_mul_128_uninterpolated(poly128 x, poly128 y, poly128* out)
{
    karatsuba_mul_128_uninterpolated_other_sum(x, y, x, y, out);
}

// Karatsuba multiplication, but don't combine the 3 128-bit polynomials into a 256-bit polynomial.
inline void karatsuba_mul_128_uncombined(poly128 x, poly128 y, poly128* out)
{
    karatsuba_mul_128_uninterpolated(x, y, out);
    out[1] = out[0] + out[2] + out[1];
}

// Given a sequence of n (for n >= 2) 128-bit polynomials p_i, compute the sum of x^(64*i) p_i as a
// sequence of n / 2 + 1 128-bit polynomials.
inline void combine_poly128s(poly128* out, const poly128* in, size_t n)
{
    out[0] = in[0] + poly128{in[1].data.shift_left_64()};
    for (size_t i = 1; i < n / 2; ++i)
        out[i] = in[2 * i] + poly128{clmul_block::mix_64(in[2 * i + 1].data, in[2 * i - 1].data)};
    if (n % 2)
        out[n / 2] = in[n - 1] + poly128{in[n - 2].data.shift_right_64()};
    else
        out[n / 2] = {in[n - 1].data.shift_right_64()};
}

template <size_t size> poly<size> poly_exp(poly<size> base, size_t power)
{
    poly<size> base_exp_pow2 = base;
    poly<size> base_exp = poly<size>::set_low32(1);
    bool first = true;
    for (size_t i = 1; i <= power; i <<= 1)
    {
        if (power & i)
        {
            if (first)
            {
                base_exp = base_exp_pow2;
                first = false;
            }
            else
            {
                base_exp = (base_exp * base_exp_pow2).template reduce_to<size>();
            }
        }
        if ((i << 1) <= power)
        {
            base_exp_pow2 = (base_exp_pow2 * base_exp_pow2).template reduce_to<size>();
        }
    }
    return base_exp;
}
} // namespace detail
} // namespace faest

#ifdef __AVX2__
#include "polynomials_impl.hpp"
#elifdef __aarch64__
#include "polynomials_impl.hpp"
#else
#error "unsupported architecture"
#endif

#endif
