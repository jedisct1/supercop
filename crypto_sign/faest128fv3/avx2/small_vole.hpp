#ifndef SMALL_VOLE_HPP
#define SMALL_VOLE_HPP

#include "block.hpp"
#include <cassert>

namespace faest
{


// Implementation of the SoftSpoken transformation for small-field VOLE: Convert 2**k PRG keys into
// a subfield VOLE correlation of length `VOLE_ROWS` over GF(2**k).
//
// Common inputs:


// Generate sender side of the VOLE correlation.
//
// Inputs:
// - `k`: bit size of the field
//      - Must satisfy k >= VOLE_WIDTH_SHIFT
// - `keys`: 2**k PRG keys,
//       - Must be permuted according to vole_permute_key_index, i.e.,
//         keys[i] = original_keys[vole_permute_key_index(i)];
// - `iv`: initialization vector for the VOLE PRG
// - `tweak`: tweak for the VOLE PRG
// - `u`: chosen VOLE input of size `VOLE_COL_BLOCKS`
// - `v`: senders VOLE output, matrix in column-major order of dimensions `VOLE_COL_BLOCKS x k`
// - `c`: correction values of size `VOLE_COL_BLOCKS`
//      - Entries of `c` after VOLE_CORRECTION_BYTES bytes are uncorrected VOLE inputs.
template <typename P>
void vole_sender(unsigned int k, const block_secpar<P::secpar_v>* __restrict__ keys,
                 typename P::vole_prg_t::iv_t iv, typename P::vole_prg_t::tweak_t tweak,
                 const vole_block* __restrict__ u, vole_block* __restrict__ v,
                 vole_block* __restrict__ c);

// Generate receiver side of the VOLE correlation.
//
// Inputs:
// - `k`,`iv`, `tweak` as for `vole_sender` above
// - `keys`: 2**k PRG keys,
//       - Must be permuted by XOR with Delta and according to vole_permute_key_index, i.e.,
//         keys[i] = original_keys[vole_permute_key_index(i) ^ delta];
// - `c`: correction values of size `VOLE_CORRECTION_BLOCKS`
// - `q`: receivers VOLE output, matrix in column-major order of dimensions `VOLE_COL_BLOCKS x k`
// - `delta`: in little endian byte form, array of k bytes each either 0x00 or 0xff
//
// Computes `q` such that the following holds:
// After
// ```
// vole_sender(k, sender_keys, iv, tweak, u, v, c)
// vole_receiver(k, receiver_keys, iv, tweak, c_receiver, q, delta)
// ```
// with `sender/receiver_keys` permuted as discussed above and `c_receiver` being the first
// `VOLE_CORRECTION_ROWS` of `c` (padded to a full `vole_block`), we have (using row-wise indexing):
// - q[i] == u[i] * delta + v[i] for each i \in [0,VOLE_CORRECTION_ROWS)
// - q[i] == c[i] * delta + v[i] for each i \in [VOLE_CORRECTION_ROWS,VOLE_ROWS)
template <typename P>
void vole_receiver(unsigned int k, const block_secpar<P::secpar_v>* __restrict__ keys,
                   typename P::vole_prg_t::iv_t iv, typename P::vole_prg_t::tweak_t tweak,
                   const vole_block* __restrict__ c, vole_block* __restrict__ q,
                   const uint8_t* __restrict__ delta);

template <typename P>
void vole_receiver_apply_correction(size_t row_blocks, size_t cols,
                                    const vole_block* __restrict__ c, vole_block* __restrict__ q,
                                    const uint8_t* __restrict__ delta);

} // namespace faest

#endif
