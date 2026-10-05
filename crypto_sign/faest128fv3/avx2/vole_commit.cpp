#include "vole_commit.inc"

namespace faest
{

#define INST_VOLE_COMMIT_RECONSTRUCT(P)                                                            \
    template void vole_commit<P>(                                                                  \
        block_secpar<P::secpar_v> seed, block128 iv, const vole_commit_data<P, false>& data,       \
        std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,                    \
        std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check);                              \
    template bool vole_reconstruct<P>(                                                             \
        block128 iv, const vole_commit_data<P, true>& data, const uint8_t* delta_bytes,            \
        std::span<const uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,              \
        std::span<const uint8_t, P::bavc_t::OPEN_SIZE> opening,                                    \
        std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check);

#define INST_CRT_VOLE_COMMIT_RECONSTRUCT(P)                                                        \
    template void crt_vole_commit<P>(                                                              \
        block_secpar<P::secpar_v> seed, block128 iv, const vole_commit_data<P, false>& data,       \
        std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,                    \
        std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check,                               \
        std::span<uint8_t, P::CONSTS::CRT_CMULT_SIZE_BYTES> c_mult);                               \
    template bool crt_vole_reconstruct<P>(                                                         \
        block128 iv, const vole_commit_data<P, true>& data, block_secpar<P::secpar_v> delta,       \
        std::span<const uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,              \
        std::span<const uint8_t, P::bavc_t::OPEN_SIZE> opening,                                    \
        std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check,                               \
        std::span<const uint8_t, P::CONSTS::CRT_CMULT_SIZE_BYTES> c_mult);                         \
    template block_secpar<P::secpar_v> crt_lift_delta<P>(block_secpar<P::secpar_v> delta);

INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_128_f);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_128_s);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_192_f);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_192_s);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_256_f);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_256_s);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_em_128_f);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_em_128_s);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_em_192_f);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_em_192_s);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_em_256_f);
INST_VOLE_COMMIT_RECONSTRUCT(v2::faest_em_256_s);

INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_128_f);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_128_s);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_192_f);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_192_s);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_256_f);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_256_s);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_em_128_f);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_em_128_s);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_em_192_f);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_em_192_s);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_em_256_f);
INST_CRT_VOLE_COMMIT_RECONSTRUCT(v3::faest_em_256_s);

} // namespace faest
