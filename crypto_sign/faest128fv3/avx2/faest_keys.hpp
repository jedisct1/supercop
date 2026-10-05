#ifndef FAEST_KEYS_HPP
#define FAEST_KEYS_HPP

#include "aes.hpp"
#include "block.hpp"
#include "constants.hpp"
#include "parameters.hpp"

#include <span>
#include <expected>
#include <variant>

namespace faest
{

// The size of the input to the OWF.
template <typename P>
constexpr std::size_t FAEST_IV_BYTES = []
{
    // The size of the input of the OWF.
    if constexpr (is_owf_with_aes_ecb(P::owf_v))
    {
        if constexpr (is_owf_with_ctr_input(P::owf_v))
            // one AES block
            return P::OWF_CONSTS::OWF_BLOCK_SIZE;
        else
            // one or two AES blocks
            return P::OWF_CONSTS::OWF_BLOCKS * P::OWF_CONSTS::OWF_BLOCK_SIZE;
    }
    else if constexpr (is_owf_with_aes_em(P::owf_v))
        // one AES/Rijndael block
        return P::secpar_bytes;
    else
        static_assert(false, "unsupported OWF");
}();

// The size of the FAEST secret key is the size of the secret key and the input to the OWF.
template <typename P>
constexpr std::size_t FAEST_SECRET_KEY_BYTES = P::secpar_bytes + FAEST_IV_BYTES<P>;

// The size of the public key is the size of the input and the output of the OWF.
template <typename P>
constexpr std::size_t FAEST_PUBLIC_KEY_BYTES =
    FAEST_IV_BYTES<P> + P::OWF_CONSTS::OWF_BLOCKS * P::OWF_CONSTS::OWF_BLOCK_SIZE;

namespace detail
{

// Non-owning view of packed FAEST secret keys.
//
// - `P` is a FAEST parameter set
// - `Byte` is a byte type, e.g., `uint8_t` or `const uint8_t`
template <typename P, typename Byte>
    requires(sizeof(Byte) == 1)
struct packed_sk_view
{
    constexpr static inline size_t SIZE = FAEST_SECRET_KEY_BYTES<P>;

  private:
    using OC = P::OWF_CONSTS;
    // Span of the whole packed key.
    std::span<Byte, SIZE> const data_;

  public:
    // Construct an `sk_view` from pointer `p` that points to a buffer of at least
    // `FAEST_SECRET_KEY_BYTES<P>` bytes.  The view does *not* take ownership of the buffer and is
    // only valid as long as the provided buffer is valid.
    packed_sk_view(Byte* p) : data_(p, SIZE) {};

    // Sizes of the various fields in bytes.
    constexpr static std::size_t SIZE_OWF_INPUT = FAEST_IV_BYTES<P>;
    constexpr static std::size_t SIZE_OWF_KEY = P::secpar_bytes;

    // Offsets of the various fields in bytes from the start of the packed key.
    constexpr static std::size_t OFFSET_OWF_INPUT = 0;
    constexpr static std::size_t OFFSET_OWF_KEY = OFFSET_OWF_INPUT + SIZE_OWF_INPUT;

    // Get a span to the whole packed secret key.
    ALWAYS_INLINE std::span<uint8_t, SIZE> packed_sk() const { return data_; }
    // Get a span to the OWF input (the plaintext or the EM-key).
    ALWAYS_INLINE auto owf_input() const
    {
        return data_.template subspan<OFFSET_OWF_INPUT, SIZE_OWF_INPUT>();
    }
    // Get a span to the OWF key (the secret key or the fixed-key).
    ALWAYS_INLINE auto owf_key() const
    {
        return data_.template subspan<OFFSET_OWF_KEY, SIZE_OWF_KEY>();
    }

    // Get a span to the AES input block(s) (non-EM).
    ALWAYS_INLINE auto aes_input() const
        requires(!is_owf_with_aes_em(P::owf_v))
    {
        return owf_input();
    }

    // Get a span to the secret AES key (non-EM).
    ALWAYS_INLINE auto aes_key() const
        requires(!is_owf_with_aes_em(P::owf_v))
    {
        return owf_key();
    }

    // Get a span to the secret Even-Mansour key (EM).
    ALWAYS_INLINE auto em_key() const
        requires(is_owf_with_aes_em(P::owf_v))
    {
        return owf_key();
    }

    // Get a span to the public fixed-key (EM).
    ALWAYS_INLINE auto fixed_key() const
        requires(is_owf_with_aes_em(P::owf_v))
    {
        return owf_input();
    }

    static_assert(OFFSET_OWF_KEY + SIZE_OWF_KEY == SIZE,
                  "The end of the last field needs to match the end of the packed key.");
};

// Non-owning view of packed FAEST public keys.
//
// - `P` is a FAEST parameter set
// - `Byte` is a byte type, e.g., `uint8_t` or `const uint8_t`
template <typename P, typename Byte>
    requires(sizeof(Byte) == 1)
struct packed_pk_view
{
    constexpr static inline size_t SIZE = FAEST_PUBLIC_KEY_BYTES<P>;

  private:
    using OC = P::OWF_CONSTS;
    // Span of the whole packed key.
    std::span<Byte, SIZE> const data_;

  public:
    // Construct an `sk_view` from pointer `p` that points to a buffer of at least
    // `FAEST_PUBLIC_KEY_BYTES<P>` bytes.  The view does *not* take ownership of the buffer and is
    // only valid as long as the provided buffer is valid.
    packed_pk_view(Byte* p) : data_(p, SIZE) {};

    // Sizes of the various fields in bytes.
    constexpr static std::size_t SIZE_OWF_INPUT = FAEST_IV_BYTES<P>;
    constexpr static std::size_t SIZE_OWF_OUTPUT = OC::OWF_BLOCKS * OC::OWF_BLOCK_SIZE;

    // Offsets of the various fields in bytes from the start of the packed key.
    constexpr static std::size_t OFFSET_OWF_INPUT = 0;
    constexpr static std::size_t OFFSET_OWF_OUTPUT = OFFSET_OWF_INPUT + SIZE_OWF_INPUT;
    constexpr static std::size_t OFFSET_FIXED_KEY = OFFSET_OWF_OUTPUT + SIZE_OWF_OUTPUT;

    // Get a span to the whole packed secret key.
    ALWAYS_INLINE std::span<uint8_t, SIZE> packed_pk() const { return data_; }
    // Get a span to the OWF input.
    ALWAYS_INLINE auto owf_input() const
    {
        return data_.template subspan<OFFSET_OWF_INPUT, SIZE_OWF_INPUT>();
    }
    // Get a span to the OWF output.
    ALWAYS_INLINE auto owf_output() const
    {
        return data_.template subspan<OFFSET_OWF_OUTPUT, SIZE_OWF_OUTPUT>();
    }
    // Get a span to the input block(s) (non-EM).
    ALWAYS_INLINE auto aes_input() const
        requires(!is_owf_with_aes_em(P::owf_v))

    {
        return owf_input();
    }
    // Get a span to the fixed key (EM).
    ALWAYS_INLINE auto fixed_key() const
        requires(is_owf_with_aes_em(P::owf_v))
    {
        return owf_input();
    }

    static_assert(OFFSET_OWF_OUTPUT + SIZE_OWF_OUTPUT == SIZE,
                  "The end of the last field needs to match the end of the packed key.");
};

} // namespace detail

// Read-only view of a packed FAEST secret key. See `detail::packed_sk_view` for documentation.
template <typename P> using packed_sk_view = detail::packed_sk_view<P, const uint8_t>;
// Mutable view of a packed FAEST secret key. See `detail::packed_sk_view` for documentation.
template <typename P> using mutable_packed_sk_view = detail::packed_sk_view<P, uint8_t>;

// Read-only view of a packed FAEST public key. See `detail::packed_pk_view` for documentation.
template <typename P> using packed_pk_view = detail::packed_pk_view<P, const uint8_t>;
// Mutable view of a packed FAEST public key. See `detail::packed_pk_view` for documentation.
template <typename P> using mutable_packed_pk_view = detail::packed_pk_view<P, uint8_t>;

template <typename P> struct public_key;

template <typename P>
    requires(is_owf_with_aes_ecb(P::owf_v))
struct public_key<P>

{
    // AES input (OWF intput)
    std::array<typename P::OWF_CONSTS::block_t, P::OWF_CONSTS::OWF_BLOCKS> owf_input;
    // AES output (OWF output)
    std::array<typename P::OWF_CONSTS::block_t, P::OWF_CONSTS::OWF_BLOCKS> owf_output;

    static public_key unpack(const uint8_t* packed_pk);
    void pack(uint8_t* packed_pk) const;
};

template <typename P>
    requires(is_owf_with_aes_em(P::owf_v))
struct public_key<P>
{
    // Fixed AES/Rijndael key (OWF input)
    block_secpar<P::secpar_v> fixed_key;
    // Expanded fixed AES key
    rijndael_round_keys<P::secpar_v> fixed_key_round_keys;
    // AES output (OWF output)
    std::array<typename P::OWF_CONSTS::block_t, P::OWF_CONSTS::OWF_BLOCKS> owf_output;

    static public_key unpack(const uint8_t* packed_pk);
    void pack(uint8_t* packed_pk) const;
};

template <typename P> struct secret_key;

template <typename P>
    requires(is_owf_with_aes_ecb(P::owf_v))
struct secret_key<P>
{
    // Public key
    public_key<P> pk;
    // Secret key (AES key)
    block_secpar<P::secpar_v> sk;
    // Expanded AES key
    aes_round_keys<P::secpar_v> round_keys;
    // Extended witness
    std::array<vole_block, P::CONSTS::WITNESS_BLOCKS> witness;

    static std::expected<secret_key, std::monostate> unpack(const uint8_t* packed_sk);
    void pack(uint8_t* packed_sk) const;
};

template <typename P>
    requires(is_owf_with_aes_em(P::owf_v))
struct secret_key<P>
{
    // Public key
    public_key<P> pk;
    // Secret key (EM key)
    block_secpar<P::secpar_v> sk;
    // Extended witness
    std::array<vole_block, P::CONSTS::WITNESS_BLOCKS> witness;

    static std::expected<secret_key, std::monostate> unpack(const uint8_t* packed_sk);
    void pack(uint8_t* packed_sk) const;
};

template <typename P> bool faest_unpack_secret_key(secret_key<P>* unpacked, const uint8_t* packed);
template <typename P> void faest_pack_public_key(uint8_t* packed, const public_key<P>* unpacked);
template <typename P> void faest_unpack_public_key(public_key<P>* unpacked, const uint8_t* packed);
template <typename P> bool faest_compute_witness(secret_key<P>* sk);
template <typename P>
bool faest_unpack_sk_and_get_pubkey(uint8_t* pk_packed, const uint8_t* sk_packed,
                                    secret_key<P>* sk);

// Check if a byte string is a valid secret key. sk_packed must be FAEST_SECRET_KEY_BYTES long.
template <typename P> bool faest_seckey(const uint8_t* sk_packed);

// Find the public key corresponding to a given secret key. Returns true if sk_packed is a valid
// secret key, and false otherwise. For key generation, this function is intended to be called
// repeatedly on random values of sk_packed until a valid key is found. pk_packed must be
// FAEST_PUBLIC_KEY_BYTES long, while sk_packed must be FAEST_SECRET_KEY_BYTES long.
template <typename P> bool faest_pubkey(uint8_t* pk_packed, const uint8_t* sk_packed);

} // namespace faest

#endif // FAEST_KEYS_H
