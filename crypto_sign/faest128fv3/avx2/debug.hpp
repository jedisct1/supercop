#ifndef DEBUG_HPP
#define DEBUG_HPP

#include "polynomials.hpp"
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>

namespace faest
{

inline std::string bytes_to_hex(const void* p, size_t n)
{
    const auto* buf = reinterpret_cast<const uint8_t*>(p);
    std::stringstream ss;
    for (size_t i = 0; i < n; ++i)
    {
        ss << std::hex << std::setfill('0') << std::setw(2) << (unsigned)buf[i];
    }
    return ss.str();
}

inline std::string poly_to_string(const uint8_t* buf, size_t poly_size)
{
    size_t poly_byte_size = (poly_size + 7) / 8;
    std::stringstream ss;
    ss << std::hex << "0x";
    for (size_t i = 0; i < poly_byte_size; ++i)
    {
        ss << std::hex << std::setfill('0') << std::setw(2) << (unsigned)buf[poly_byte_size - i - 1];
    }
    ss << "  # [size = " << std::dec << poly_size << "]";
    return ss.str();
}

template <std::size_t size> inline std::string poly_to_string(poly<size> pv);

template <std::size_t size>
    requires(size > 1)
inline std::string poly_to_string(poly<size> pv)
{
    std::array<uint8_t, (size + 7) / 8> buf;
    pv.store(buf.data());
    return poly_to_string(buf.data(), size);
}

template <> inline std::string poly_to_string<1>(poly<1> pv)
{
    if (pv.data)
        return "1";
    else
        return "0";
}

template <std::size_t size> inline std::ostream& operator<<(std::ostream& o, const poly<size>& pv)
{
    return o << poly_to_string(pv);
}

template <std::size_t size> inline std::ostream& operator<<(std::ostream& o, const block<size>& b)
{
    std::array<uint8_t, sizeof(b)> buf;
    memcpy(buf.data(), &b, buf.size());
    return o << poly_to_string(buf.data(), size);
}

template <secpar S> inline int poly_secpar_gf256sub(poly_secpar<S> p)
{
    for (int i = 0; i < 256; ++i)
    {
        const auto byte = static_cast<uint8_t>(i);
        if (p == poly_secpar<S>::from_8_byte(byte))
            return i;
    }
    return -1;
}

template <secpar S> inline std::string poly_secpar_gf256sub_to_string(poly_secpar<S> p)
{
    std::stringstream ss;
    auto v = poly_secpar_gf256sub<S>(p);
    if (v == -1)
        ss << "NOT_IN_256_SUBFIELD[" << poly_to_string(p) << "]";
    else
        ss << "0x" << std::hex << std::setfill('0') << std::setw(2) << v;
    return ss.str();
}

} // namespace faest

#endif
