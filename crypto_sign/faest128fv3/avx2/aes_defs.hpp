#ifndef AES_DEFS_HPP
#define AES_DEFS_HPP

#include "block.hpp"
#include "constants.hpp"
#include <type_traits>

namespace faest
{

template <secpar S> struct aes_round_keys
{
    block128 keys[AES_ROUNDS<S> + 1];
};

template <secpar S> struct rijndael_round_keys_impl
{
    block_secpar<S> keys[RIJNDAEL_ROUNDS<S> + 1];
};
using rijndael192_round_keys = rijndael_round_keys_impl<secpar::s192>;
using rijndael256_round_keys = rijndael_round_keys_impl<secpar::s256>;

template <secpar S>
using rijndael_round_keys = std::conditional_t<
    S == secpar::s128, aes_round_keys<S>,
    std::conditional_t<S == secpar::s192, rijndael192_round_keys,
                       std::conditional_t<S == secpar::s256, rijndael256_round_keys, void>>>;

constexpr unsigned char aes_round_constants[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40,
                                                 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d};

} // namespace faest

#endif
