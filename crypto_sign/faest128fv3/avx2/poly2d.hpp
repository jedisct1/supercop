#include <array>
#include "polynomials.hpp"

namespace faest
{

// A polynomial over GF(2) in two variables, with degree < size_1 in the first variable and degree <
// size_2 in the second variable. Row-major, i.e., the last variable corresponds to consecutive
// bits in storage.
template <size_t size_1, size_t size_2>
struct poly2d
{
    typedef poly<size_2> poly_inner;
    std::array<poly_inner, size_1> coeffs;

    poly2d() = default;

    poly2d(poly<size_2> x) requires (size_1 > 0)
    {
        coeffs[0] = x;
        PRAGMA_UNROLL(4)
        for (size_t i = 1; i < size_1; ++i)
            coeffs[i] = poly<size_2>::set_zero();
    }

    template<size_t size_1_smaller>
    poly2d(poly2d<size_1_smaller, size_2> x) requires (size_1 > size_1_smaller)
    {
        PRAGMA_UNROLL(4)
        for (size_t i = 0; i < size_1_smaller; ++i)
            coeffs[i] = x.coeffs[i];
        PRAGMA_UNROLL(4)
        for (size_t i = size_1_smaller; i < size_1; ++i)
            coeffs[i] = poly<size_2>::set_zero();
    }

    static poly2d set_zero()
    {
        poly2d out;
        PRAGMA_UNROLL(4)
        for (size_t i = 0; i < size_1; ++i)
            out.coeffs[i] = poly<size_2>::set_zero();
        return out;
    }

    template<size_t shift>
    poly2d<size_1 + shift, size_2> shift_left() const
    {
        auto out = poly2d<size_1 + shift, size_2>::set_zero();
        for (size_t i = 0; i < size_1; ++i)
            out.coeffs[i + shift] = coeffs[i];
        return out;
    }

    poly2d operator+(const poly2d& other) const
    {
        poly2d out;
        PRAGMA_UNROLL(4)
        for (size_t i = 0; i < size_1; ++i)
            out.coeffs[i] = coeffs[i] + other.coeffs[i];
        return out;
    }

    poly2d& operator+=(const poly2d& other)
    {
        *this = *this + other;
        return *this;
    }

    // Reduce the inner field using one of the predefined irreducible polynomials.
    template <size_t out_size_2>
    poly2d<size_1, out_size_2> reduce_to() const
    {
        poly2d<size_1, out_size_2> out;
        PRAGMA_UNROLL(4)
        for (size_t i = 0; i < size_1; ++i)
            out.coeffs[i] = coeffs[i].template reduce_to<out_size_2>();
        return out;
    }

    // Trivial because characteristic 2
    poly2d operator-() const { return *this; }
    poly2d operator-(const poly2d& other) const { return *this + other; }
    poly2d& operator-=(const poly2d& other) const { return *this += other; }
};

// Slightly lossy in the inner degree, as I don't want to bother with polynomial types in increments
// of 1 bit.
template <size_t size_a_1, size_t size_a_2, size_t size_b_1, size_t size_b_2>
inline poly2d<size_a_1 + size_b_1 - 1, size_a_2 + size_b_2 - (size_a_2 == 1 || size_b_2 == 1)>
operator*(const poly2d<size_a_1, size_a_2>& a, const poly2d<size_b_1, size_b_2>& b)
{
    // TODO: better algorithm than schoolbook.
    typedef poly2d<size_a_1 + size_b_1 - 1, size_a_2 + size_b_2 - (size_a_2 == 1 || size_b_2 == 1)> output_poly;
    output_poly out = output_poly::set_zero();
    PRAGMA_UNROLL(4)
    for (size_t i = 0; i < size_a_1; ++i)
        PRAGMA_UNROLL(4)
        for (size_t j = 0; j < size_b_1; ++j)
            out.coeffs[i + j] += a.coeffs[i] * b.coeffs[j];
    return out;
}

}
