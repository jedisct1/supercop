#include "constants.hpp"
#include "owf_proof_enc_v2.inc"
#include "parameters.hpp"

namespace faest::zk
{

#define INST_ENC_CONSTRAINTS_V2_HELPER(P, ...)                                                     \
    template void enc_constraints_v2<__VA_ARGS__, P::owf_v>(                                       \
        __VA_ARGS__ * qs_state, size_t witness_bit_offset,                                         \
        const owf_round_key_bits<__VA_ARGS__, P::OWF_CONSTS>& round_key_bits,                      \
        const owf_round_key_bytes<__VA_ARGS__, P::OWF_CONSTS>& round_key_bytes,                    \
        owf_block<P::secpar_v, P::owf_v> in, owf_block<P::secpar_v, P::owf_v> out);

#define INST_ENC_CONSTRAINTS_V2(P)                                                                 \
    INST_ENC_CONSTRAINTS_V2_HELPER(                                                                \
        P, quicksilver_state<P::secpar_v, false, P::OWF_CONSTS::QS_DEGREE>)                        \
    INST_ENC_CONSTRAINTS_V2_HELPER(P,                                                              \
                                   quicksilver_state<P::secpar_v, true, P::OWF_CONSTS::QS_DEGREE>)

INST_ENC_CONSTRAINTS_V2(v2::faest_128_s);
INST_ENC_CONSTRAINTS_V2(v2::faest_192_s);
INST_ENC_CONSTRAINTS_V2(v2::faest_256_s);
INST_ENC_CONSTRAINTS_V2(v2::faest_em_128_s);
INST_ENC_CONSTRAINTS_V2(v2::faest_em_192_s);
INST_ENC_CONSTRAINTS_V2(v2::faest_em_256_s);

} // namespace faest::zk
