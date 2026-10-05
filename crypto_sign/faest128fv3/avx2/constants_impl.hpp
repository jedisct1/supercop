#ifndef CONSTANTS_IMPL_HPP
#define CONSTANTS_IMPL_HPP

#include <cstddef>

namespace faest {

constexpr std::size_t AES_MAX_CTR = 0x80;
constexpr std::size_t AES_PREFERRED_WIDTH_SHIFT = 3;
constexpr std::size_t RIJNDAEL256_PREFERRED_WIDTH_SHIFT = 2;

constexpr std::size_t TRANSPOSE_BITS_ROWS_SHIFT = 8;
constexpr std::size_t VOLE_BLOCK_SHIFT = 0;

}

#endif
