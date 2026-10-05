#include "small_vole.inc"

namespace faest
{

// clang-format off

template void vole_sender<v2::faest_128_s>(unsigned int, const block_secpar<v2::faest_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_128_f>(unsigned int, const block_secpar<v2::faest_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_192_s>(unsigned int, const block_secpar<v2::faest_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_192_f>(unsigned int, const block_secpar<v2::faest_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_256_s>(unsigned int, const block_secpar<v2::faest_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_256_f>(unsigned int, const block_secpar<v2::faest_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_em_128_s>(unsigned int, const block_secpar<v2::faest_em_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_em_128_f>(unsigned int, const block_secpar<v2::faest_em_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_em_192_s>(unsigned int, const block_secpar<v2::faest_em_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_em_192_f>(unsigned int, const block_secpar<v2::faest_em_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_em_256_s>(unsigned int, const block_secpar<v2::faest_em_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v2::faest_em_256_f>(unsigned int, const block_secpar<v2::faest_em_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_128_s>(unsigned int, const block_secpar<v3::faest_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_128_f>(unsigned int, const block_secpar<v3::faest_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_192_s>(unsigned int, const block_secpar<v3::faest_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_192_f>(unsigned int, const block_secpar<v3::faest_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_256_s>(unsigned int, const block_secpar<v3::faest_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_256_f>(unsigned int, const block_secpar<v3::faest_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_em_128_s>(unsigned int, const block_secpar<v3::faest_em_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_em_128_f>(unsigned int, const block_secpar<v3::faest_em_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_em_192_s>(unsigned int, const block_secpar<v3::faest_em_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_em_192_f>(unsigned int, const block_secpar<v3::faest_em_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_em_256_s>(unsigned int, const block_secpar<v3::faest_em_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);
template void vole_sender<v3::faest_em_256_f>(unsigned int, const block_secpar<v3::faest_em_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, vole_block* __restrict__);

template void vole_receiver<v2::faest_128_s>(unsigned int, const block_secpar<v2::faest_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_128_f>(unsigned int, const block_secpar<v2::faest_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_192_s>(unsigned int, const block_secpar<v2::faest_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_192_f>(unsigned int, const block_secpar<v2::faest_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_256_s>(unsigned int, const block_secpar<v2::faest_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_256_f>(unsigned int, const block_secpar<v2::faest_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_em_128_s>(unsigned int, const block_secpar<v2::faest_em_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_em_128_f>(unsigned int, const block_secpar<v2::faest_em_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_em_192_s>(unsigned int, const block_secpar<v2::faest_em_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_em_192_f>(unsigned int, const block_secpar<v2::faest_em_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_em_256_s>(unsigned int, const block_secpar<v2::faest_em_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v2::faest_em_256_f>(unsigned int, const block_secpar<v2::faest_em_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_128_s>(unsigned int, const block_secpar<v3::faest_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_128_f>(unsigned int, const block_secpar<v3::faest_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_192_s>(unsigned int, const block_secpar<v3::faest_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_192_f>(unsigned int, const block_secpar<v3::faest_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_256_s>(unsigned int, const block_secpar<v3::faest_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_256_f>(unsigned int, const block_secpar<v3::faest_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_em_128_s>(unsigned int, const block_secpar<v3::faest_em_128_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_em_128_f>(unsigned int, const block_secpar<v3::faest_em_128_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_em_192_s>(unsigned int, const block_secpar<v3::faest_em_192_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_em_192_f>(unsigned int, const block_secpar<v3::faest_em_192_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_em_256_s>(unsigned int, const block_secpar<v3::faest_em_256_s::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver<v3::faest_em_256_f>(unsigned int, const block_secpar<v3::faest_em_256_f::secpar_v>* __restrict__, block128, uint32_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);

template void vole_receiver_apply_correction<v2::faest_128_s>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_128_f>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_192_s>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_192_f>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_256_s>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_256_f>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_em_128_s>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_em_128_f>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_em_192_s>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_em_192_f>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_em_256_s>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);
template void vole_receiver_apply_correction<v2::faest_em_256_f>(size_t, size_t, const vole_block* __restrict__, vole_block* __restrict__, const uint8_t* __restrict__);

// clang-format on

} // namespace faest
