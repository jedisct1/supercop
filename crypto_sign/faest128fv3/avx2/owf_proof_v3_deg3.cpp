#include "owf_proof.inc"

namespace faest
{

// clang-format off

template void owf_constraints(quicksilver_state<v3_deg3::faest_128_s::secpar_v, false, v3_deg3::faest_128_s::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_128_s>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_128_f::secpar_v, false, v3_deg3::faest_128_f::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_128_f>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_192_s::secpar_v, false, v3_deg3::faest_192_s::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_192_s>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_192_f::secpar_v, false, v3_deg3::faest_192_f::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_192_f>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_256_s::secpar_v, false, v3_deg3::faest_256_s::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_256_s>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_256_f::secpar_v, false, v3_deg3::faest_256_f::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_256_f>*);

template void owf_constraints(quicksilver_state<v3_deg3::faest_128_s::secpar_v, true, v3_deg3::faest_128_s::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_128_s>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_128_f::secpar_v, true, v3_deg3::faest_128_f::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_128_f>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_192_s::secpar_v, true, v3_deg3::faest_192_s::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_192_s>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_192_f::secpar_v, true, v3_deg3::faest_192_f::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_192_f>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_256_s::secpar_v, true, v3_deg3::faest_256_s::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_256_s>*);
template void owf_constraints(quicksilver_state<v3_deg3::faest_256_f::secpar_v, true, v3_deg3::faest_256_f::OWF_CONSTS::QS_DEGREE>*, const public_key<v3_deg3::faest_256_f>*);

// clang-format on

} // namespace faest
