#ifndef BLOCK_HPP
#define BLOCK_HPP

#include "parameters.hpp"

namespace faest
{

// NB: We assume that bits is divisible by 8 and each block is exactly of size bits / 8 byte.

template <std::size_t bits> struct block;

using block128 = block<128>;
using block192 = block<192>;
using block256 = block<256>;
using block384 = block<384>;
using block512 = block<512>;

}

#ifdef __AVX2__
#include "block_impl.hpp"
#elifdef __aarch64__
#include "block_impl.hpp"
#else
#error "unsupported architecture"
#endif

namespace faest
{

template <> struct block<384>
{
    block128 data[3];

    inline static block384 load(const void* p)
    {
        block384 out;
        memcpy(&out, p, sizeof(out));
        return out;
    }
    inline void store(void* p) const { memcpy(p, &data, sizeof(data)); }

    inline block384 operator^(const block384& y) const
    {
        block384 out;
        out.data[0] = this->data[0] ^ y.data[0];
        out.data[1] = this->data[1] ^ y.data[1];
        out.data[2] = this->data[2] ^ y.data[2];
        return out;
    }
    inline block384 operator&(const block384& y) const
    {
        block384 out;
        out.data[0] = this->data[0] & y.data[0];
        out.data[1] = this->data[1] & y.data[1];
        out.data[2] = this->data[2] & y.data[2];
        return out;
    }
    inline block384 operator|(const block384& y) const
    {
        block384 out;
        out.data[0] = this->data[0] | y.data[0];
        out.data[1] = this->data[1] | y.data[1];
        out.data[2] = this->data[2] | y.data[2];
        return out;
    }
    inline block384 add32(const block384& y) const
    {
        block384 out;
        out.data[0] = this->data[0].add32(y.data[0]);
        out.data[1] = this->data[1].add32(y.data[1]);
        out.data[2] = this->data[2].add32(y.data[2]);
        return out;
    }
    inline static block384 set_zero()
    {
        block384 out;
        out.data[0] = block128::set_zero();
        out.data[1] = block128::set_zero();
        out.data[2] = block128::set_zero();
        return out;
    }
    inline static block384 set_all_8(uint8_t x)
    {
        block384 out;
        out.data[0] = block128::set_all_8(x);
        out.data[1] = block128::set_all_8(x);
        out.data[2] = block128::set_all_8(x);
        return out;
    }
    inline static block384 set_low32(uint32_t x)
    {
        block384 out = block384::set_zero();
        out.data[0] = block128::set_low32(x);
        return out;
    }
    inline static block384 set_low32(uint32_t x, uint32_t y)
    {
        block384 out = block384::set_zero();
        out.data[0] = block128::set_low32(x, y);
        return out;
    }
    inline static block384 set_low_high32(uint32_t x, uint32_t y)
    {
        block384 out = block384::set_zero();
        out.data[0] = block128::set_low32(x);
        out.data[2] = block128::set_low_high32(0, y);
        return out;
    }
    inline static block384 set_low64(uint64_t x)
    {
        block384 out = block384::set_zero();
        out.data[0] = block128::set_low64(x);
        return out;
    }
};

template <> struct block<512>
{
    block256 data[2];

    inline static block512 load(const void* p)
    {
        block512 out;
        memcpy(&out, p, sizeof(out));
        return out;
    }
    inline void store(void* p) const { memcpy(p, &data, sizeof(data)); }

    inline block512 operator^(const block512& y) const
    {
        block512 out;
        out.data[0] = this->data[0] ^ y.data[0];
        out.data[1] = this->data[1] ^ y.data[1];
        return out;
    }
    inline block512 operator&(const block512& y) const
    {
        block512 out;
        out.data[0] = this->data[0] & y.data[0];
        out.data[1] = this->data[1] & y.data[1];
        return out;
    }
    inline block512 operator|(const block512& y) const
    {
        block512 out;
        out.data[0] = this->data[0] | y.data[0];
        out.data[1] = this->data[1] | y.data[1];
        return out;
    }

    inline block512 add32(const block512& y) const
    {
        block512 out;
        out.data[0] = this->data[0].add32(y.data[0]);
        out.data[1] = this->data[1].add32(y.data[1]);
        return out;
    }

    inline static block512 set_zero()
    {
        block512 out;
        out.data[0] = block256::set_zero();
        out.data[1] = block256::set_zero();
        return out;
    }

    inline static block512 set_all_8(uint8_t x)
    {
        block512 out;
        out.data[0] = block256::set_all_8(x);
        out.data[1] = block256::set_all_8(x);
        return out;
    }

    inline static block512 set_low32(uint32_t x)
    {
        block512 out;
        out.data[0] = block256::set_low32(x);
        out.data[1] = block256::set_zero();
        return out;
    }
    inline static block512 set_low32(uint32_t x, uint32_t y)
    {
        block512 out;
        out.data[0] = block256::set_low32(x, y);
        out.data[1] = block256::set_zero();
        return out;
    }
    inline static block512 set_low_high32(uint32_t x, uint32_t y)
    {
        block512 out = block512::set_zero();
        out.data[0] = block256::set_low32(x);
        out.data[1] = block256::set_low_high32(0, y);
        return out;
    }
    inline static block512 set_low64(uint64_t x)
    {
        block512 out;
        out.data[0] = block256::set_low64(x);
        out.data[1] = block256::set_zero();
        return out;
    }
};

template <std::size_t bits> bool operator==(const block<bits>& x, const block<bits>& y)
{
    return memcmp(&x, &y, sizeof(x)) == 0;
}

static_assert(sizeof(block128) == 16, "Padding in block128.");
static_assert(sizeof(block192) == 24, "Padding in block192.");
static_assert(sizeof(block256) == 32, "Padding in block256.");
static_assert(sizeof(block384) == 48, "Padding in block384.");
static_assert(sizeof(block512) == 64, "Padding in block512.");

template <secpar S> using block_secpar = block<secpar_to_bits(S)>;

template <secpar S> using block_2secpar = block<2 * secpar_to_bits(S)>;

} // namespace faest

#endif
