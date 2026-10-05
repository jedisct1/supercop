#include "constants.hpp"
#include "owf_proof_key_sched.inc"
#include "parameters.hpp"

namespace faest::zk
{

#define INST_KEY_SCHED_CONSTRAINTS_HELPER(P, ...)                                                  \
    template void key_sched_constraints<__VA_ARGS__, P::owf_v>(                                    \
        __VA_ARGS__ * state, owf_round_key_bits<__VA_ARGS__, P::OWF_CONSTS> & round_key_bits,      \
        owf_round_key_bytes<__VA_ARGS__, P::OWF_CONSTS> & round_key_bytes,                         \
        owf_round_key_bytes<__VA_ARGS__, P::OWF_CONSTS> & round_key_bytes_sq);

#define INST_KEY_SCHED_CONSTRAINTS(P)                                                              \
    INST_KEY_SCHED_CONSTRAINTS_HELPER(                                                             \
        P, quicksilver_state<P::secpar_v, false, P::OWF_CONSTS::QS_DEGREE>)                        \
    INST_KEY_SCHED_CONSTRAINTS_HELPER(                                                             \
        P, quicksilver_state<P::secpar_v, true, P::OWF_CONSTS::QS_DEGREE>)

INST_KEY_SCHED_CONSTRAINTS(v2::faest_128_s);
INST_KEY_SCHED_CONSTRAINTS(v2::faest_192_s);
INST_KEY_SCHED_CONSTRAINTS(v2::faest_256_s);

INST_KEY_SCHED_CONSTRAINTS(v3::faest_128_s);
INST_KEY_SCHED_CONSTRAINTS(v3::faest_192_s);
INST_KEY_SCHED_CONSTRAINTS(v3::faest_256_s);

#define INST_LOAD_FIXED_ROUND_KEY_HELPER(P, ...)                                                   \
    template void load_fixed_round_key<__VA_ARGS__, P::owf_v>(                                     \
        const __VA_ARGS__* state, owf_round_key_bits<__VA_ARGS__, P::OWF_CONSTS>& round_key_bits,  \
        owf_round_key_bytes<__VA_ARGS__, P::OWF_CONSTS>& round_key_bytes,                          \
        owf_round_key_bytes<__VA_ARGS__, P::OWF_CONSTS>& round_key_bytes_sq,                       \
        const rijndael_round_keys<P::secpar_v>* fixed_key);

#define INST_LOAD_FIXED_ROUND_KEY(P)                                                               \
    INST_LOAD_FIXED_ROUND_KEY_HELPER(                                                              \
        P, quicksilver_state<P::secpar_v, false, P::OWF_CONSTS::QS_DEGREE>)                        \
    INST_LOAD_FIXED_ROUND_KEY_HELPER(                                                              \
        P, quicksilver_state<P::secpar_v, true, P::OWF_CONSTS::QS_DEGREE>)

INST_LOAD_FIXED_ROUND_KEY(v2::faest_em_128_s);
INST_LOAD_FIXED_ROUND_KEY(v2::faest_em_192_s);
INST_LOAD_FIXED_ROUND_KEY(v2::faest_em_256_s);

INST_LOAD_FIXED_ROUND_KEY(v3::faest_em_128_s);
INST_LOAD_FIXED_ROUND_KEY(v3::faest_em_192_s);
INST_LOAD_FIXED_ROUND_KEY(v3::faest_em_256_s);

} // namespace faest::zk
