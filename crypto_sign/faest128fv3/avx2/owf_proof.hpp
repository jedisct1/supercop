#ifndef OWF_PROOF_H
#define OWF_PROOF_H

#include "parameters.hpp"

namespace faest
{

template <secpar S, bool verifier, std::size_t max_deg>
    requires(max_deg >= 1)
struct quicksilver_state;

template <typename P> struct public_key;

template <typename P, bool verifier>
void owf_constraints(quicksilver_state<P::secpar_v, verifier, P::OWF_CONSTS::QS_DEGREE>* state,
                     const public_key<P>* pk);

} // namespace faest

#endif
