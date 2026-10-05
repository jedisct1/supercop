#ifndef FAEST_HPP
#define FAEST_HPP

#include <cstdint>

#include "constants.hpp"
#include "parameters.hpp"
#include "prgs.hpp"
#include "vector_com.hpp"

namespace faest
{

template <typename P>
constexpr std::size_t FAEST_SIGNATURE_BYTES =
    P::CONSTS::VOLE_COMMIT_SIZE + P::CONSTS::VOLE_CHECK::PROOF_BYTES +
    P::OWF_CONSTS::WITNESS_BITS / 8 + P::CONSTS::QS::PROOF_BYTES + P::bavc_t::OPEN_SIZE +
    P::secpar_bytes + 16 + P::grinding_counter_size;

// Generate a signature (of length FAEST_SIGNATURE_BYTES) for a message msg (of length msg_len)
// using a secret key sk_packed (of length FAEST_SECRET_KEY_BYTES) and randomness random_seed (of
// length random_seed_len). random_seed can be set to null for deterministic signatures. The
// randomness is mixed with pseudorandom bits generated from secret key and the message, to protect
// against bad randomness. Returns true if sk_packed is a valid secret key, and false otherwise.
template <typename P>
bool faest_sign(uint8_t* signature, const uint8_t* msg, size_t msg_len, const uint8_t* sk_packed,
                const uint8_t* random_seed, size_t random_seed_len);

// Verify a signature (of length FAEST_SIGNATURE_BYTES) for a message msg (of length msg_len)
// using a public key pk_packed (of length FAEST_PUBLIC_KEY_BYTES). Returns true for a valid
// signature and false otherwise.
template <typename P>
bool faest_verify(const uint8_t* signature, const uint8_t* msg, size_t msg_len,
                  const uint8_t* pk_packed);

} // namespace faest

#endif
