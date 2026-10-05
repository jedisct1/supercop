#ifndef OWF_PROOF_INC
#define OWF_PROOF_INC

#include "aes.hpp"
#include "constants.hpp"
#include "faest_keys.hpp"
#include "owf_proof.hpp"
#include "owf_proof_tools.hpp"
#include "parameters.hpp"
#include "quicksilver.hpp"

namespace faest
{
namespace zk
{

template <typename QS, owf O>
void key_sched_constraints(
    QS* state, owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq);

template <typename QS, owf O>
void load_fixed_round_key(
    const QS* state, owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq,
    const rijndael_round_keys<QS::secpar_v>* fixed_key);

template <typename QS, owf O>
void enc_constraints_v1(
    QS* qs_state, size_t witness_bit_offset,
    const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq,
    owf_block<QS::secpar_v, O> in, owf_block<QS::secpar_v, O> out);

template <typename QS, owf O>
void enc_constraints_v2(
    QS* qs_state, size_t witness_bit_offset,
    const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_block<QS::secpar_v, O> in, owf_block<QS::secpar_v, O> out);

template <typename QS, owf O>
void enc_constraints_v3(
    QS* qs_state, size_t witness_bit_offset,
    const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_block<QS::secpar_v, O> in, owf_block<QS::secpar_v, O> out);

template <typename QS, owf O>
static void
enc_constraints(QS* qs_state,
                const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
                const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
                const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq,
                size_t block_num, owf_block<QS::secpar_v, O> in, owf_block<QS::secpar_v, O> out)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    // compute the starting index of the witness bits corresponding to the s-boxes in this round of
    // encryption
    FAEST_ASSERT(block_num < OC::OWF_BLOCKS);
    size_t witness_bit_offset =
        OC::OWF_KEY_WITNESS_BITS + block_num * OC::OWF_ENC_WITNESS_BITS_PER_BLOCK;

    if constexpr (is_owf_with_deg7_proof(O))
    {
        enc_constraints_v3<QS, O>(qs_state, witness_bit_offset, round_key_bits, round_key_bytes, in,
                                  out);
    }
    else if constexpr (is_owf_with_norm_proof(O))
    {
        enc_constraints_v2<QS, O>(qs_state, witness_bit_offset, round_key_bits, round_key_bytes, in,
                                  out);
    }
    else
    {
        enc_constraints_v1<QS, O>(qs_state, witness_bit_offset, round_key_bits, round_key_bytes,
                                  round_key_bytes_sq, in, out);
    }
}

template <typename QS> static void shrunk_keyspace_constraint(QS* state)
{
    auto k0 = quicksilver_gfsecpar<QS>(state->get_witness_bit(0));
    auto k1 = quicksilver_gfsecpar<QS>(state->get_witness_bit(1));
    state->add_constraint(k0 * k1);
}

template <typename QS> static void witness_bit_check_constraint(QS* state, size_t witness_length)
{
    for (size_t i = 0; i < witness_length; ++i)
    {
        const auto w = quicksilver_gfsecpar<QS>(state->get_witness_bit(i));
        state->add_bit_constraint(w);
    }
}

} // namespace zk

template <typename P, bool verifier>
void owf_constraints(quicksilver_state<P::secpar_v, verifier, P::OWF_CONSTS::QS_DEGREE>* state,
                     const public_key<P>* pk)
{
    using QS = quicksilver_state<P::secpar_v, verifier, P::OWF_CONSTS::QS_DEGREE>;
    using OC = P::OWF_CONSTS;
    constexpr auto S = P::secpar_v;
    constexpr auto O = P::owf_v;

    if constexpr (is_owf_with_witness_bits_check(P::owf_v))
    {
        zk::witness_bit_check_constraint(state, OC::WITNESS_BITS);
    }

    if constexpr (is_owf_with_shrunk_keyspace(P::owf_v))
    {
        zk::shrunk_keyspace_constraint(state);
    }

    auto round_key_bits =
        state->template const_gf2_array<8 * OC::OWF_BLOCK_SIZE*(OC::OWF_ROUNDS + 1)>();
    auto round_key_bytes =
        state->template const_gfsecpar_array<OC::OWF_BLOCK_SIZE*(OC::OWF_ROUNDS + 1)>();
    auto round_key_bytes_sq =
        state->template const_gfsecpar_array<OC::OWF_BLOCK_SIZE*(OC::OWF_ROUNDS + 1)>();
    if constexpr (is_owf_with_aes_ecb(O))
    {
        zk::key_sched_constraints<QS, O>(state, round_key_bits, round_key_bytes,
                                         round_key_bytes_sq);
        for (size_t i = 0; i < OC::OWF_BLOCKS; ++i)
        {
            zk::enc_constraints<QS, O>(state, round_key_bits, round_key_bytes, round_key_bytes_sq,
                                       i, pk->owf_input[i], pk->owf_output[i]);
        }
    }
    else if constexpr (is_owf_with_aes_em(O))
    {
        zk::load_fixed_round_key<QS, O>(state, round_key_bits, round_key_bytes, round_key_bytes_sq,
                                        &pk->fixed_key_round_keys);
        zk::enc_constraints<QS, O>(state, round_key_bits, round_key_bytes, round_key_bytes_sq, 0,
                                   zk::owf_block<S, O>::set_low32(0), pk->owf_output[0]);
    }
    else
    {
        static_assert(false, "unsupported OWF");
    }
}

#define INST_OWF_CONSTRAINTS(P)                                                                    \
    template void owf_constraints(                                                                 \
        quicksilver_state<P::secpar_v, false, P::OWF_CONSTS::QS_DEGREE>*, const public_key<P>*);   \
    template void owf_constraints(quicksilver_state<P::secpar_v, true, P::OWF_CONSTS::QS_DEGREE>*, \
                                  const public_key<P>*);

} // namespace faest

#endif
