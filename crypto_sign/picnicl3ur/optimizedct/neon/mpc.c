/*
 *  This file is part of the optimized implementation of the Picnic signature scheme.
 *  See the accompanying documentation for complete details.
 *
 *  The code is provided under the MIT license, see LICENSE for
 *  more details.
 *  SPDX-License-Identifier: MIT
 */


#include "mpc.h"

#if !defined(_MSC_VER)
#include <stdalign.h>
#endif
#include "simd.h"

#include <string.h>

void mpc_clear(mzd_local_t* const* res, unsigned sc) {
  for (unsigned int i = 0; i < sc; i++) {
    mzd_local_clear(res[i]);
  }
}

void mpc_shift_right(mzd_local_t* const* res, mzd_local_t* const* val, unsigned count,
                     unsigned sc) {
  MPC_LOOP_CONST(mzd_shift_right, res, val, count, sc);
}

void mpc_shift_left(mzd_local_t* const* res, mzd_local_t* const* val, unsigned count, unsigned sc) {
  MPC_LOOP_CONST(mzd_shift_left, res, val, count, sc);
}

void mpc_and_const(mzd_local_t* const* result, mzd_local_t* const* first, mzd_local_t const* second,
                   unsigned sc) {
  MPC_LOOP_CONST(mzd_xor, result, first, second, sc);
}

void mpc_xor(mzd_local_t* const* result, mzd_local_t* const* first, mzd_local_t* const* second,
             unsigned sc) {
  MPC_LOOP_SHARED(mzd_xor, result, first, second, sc);
}

void mpc_and_uint64(uint64_t* res, uint64_t const* first, uint64_t const* second, uint64_t const* r,
                    view_t* view, unsigned viewshift) {
  for (unsigned m = 0; m < SC_PROOF; ++m) {
    const unsigned j = (m + 1) % SC_PROOF;
    uint64_t tmp1    = second[m] ^ second[j];
    uint64_t tmp2    = first[j] & second[m];
    tmp1             = tmp1 & first[m];
    tmp1             = tmp1 ^ tmp2;
    tmp2             = r[m] ^ r[j];
    res[m] = tmp1 = tmp1 ^ tmp2;
    if (viewshift) {
      tmp1          = tmp1 >> viewshift;
      view->t[m]    = view->t[m] ^ tmp1;
    } else {
      // on first call (viewshift == 0), view->t[0..2] == 0
      view->t[m] = tmp1;
    }
  }
}

#define mpc_and_def(type, and, xor, shift_right)                                                   \
  for (unsigned m = 0; m < SC_PROOF; ++m) {                                                        \
    const unsigned j = (m + 1) % SC_PROOF;                                                         \
    type* sm         = (type*)ASSUME_ALIGNED(FIRST_ROW(view->s[m]), alignof(type));                \
    type tmp1        = (xor)(second[m], second[j]);                                                \
    type tmp2        = (and)(first[j], second[m]);                                                 \
    tmp1             = (and)(tmp1, first[m]);                                                      \
    tmp1             = (xor)(tmp1, tmp2);                                                          \
    tmp2             = (xor)(r[m], r[j]);                                                          \
    res[m] = tmp1 = (xor)(tmp1, tmp2);                                                             \
    tmp1          = (shift_right)(tmp1, viewshift);                                                \
    *sm           = (xor)(tmp1, *sm);                                                              \
  }

#define mpc_and_def_multiple(type, and, xor, shift_right, size)                                    \
  for (unsigned m = 0; m < SC_PROOF; ++m) {                                                        \
    const unsigned j = (m + 1) % SC_PROOF;                                                         \
    type* sm         = (type*)ASSUME_ALIGNED(FIRST_ROW(view->s[m]), alignof(type));                \
    type tmp1[size], tmp2[size];                                                                   \
    (xor)(tmp1, second[m], second[j]);                                                             \
    (and)(tmp2, first[j], second[m]);                                                              \
    (and)(tmp1, tmp1, first[m]);                                                                   \
    (xor)(tmp1, tmp1, tmp2);                                                                       \
    (xor)(tmp2, r[m], r[j]);                                                                       \
    (xor)(tmp1, tmp1, tmp2);                                                                       \
    memcpy(res[m], tmp1, size * sizeof(type));                                                     \
    (shift_right)(tmp1, tmp1, viewshift);                                                          \
    (xor)(sm, tmp1, sm);                                                                           \
  }





void mpc_and_verify_uint64(uint64_t* res, uint64_t const* first, uint64_t const* second,
                           uint64_t const* r, view_t* view, uint64_t const mask,
                           unsigned viewshift) {
  for (unsigned m = 0; m < (SC_VERIFY - 1); ++m) {
    const unsigned j = (m + 1);
    uint64_t tmp1    = second[m] ^ second[j];
    uint64_t tmp2    = first[j] & second[m];
    tmp1             = tmp1 & first[m];
    tmp1             = tmp1 ^ tmp2;
    tmp2             = r[m] ^ r[j];
    res[m] = tmp1 = tmp1 ^ tmp2;
    if (viewshift || m) {
      tmp1          = tmp1 >> viewshift;
      view->t[m]    = view->t[m] ^ tmp1;
    } else {
      // on first call (viewshift == 0), view->t[0] == 0
      view->t[m] = tmp1;
    }
  }

  const uint64_t rsc       = view->t[SC_VERIFY - 1] << viewshift;
  res[SC_VERIFY - 1] = rsc & mask;
}

#define mpc_and_verify_def(type, and, xor, shift_right, shift_left)                                \
  for (unsigned m = 0; m < (SC_VERIFY - 1); ++m) {                                                 \
    const unsigned j = (m + 1);                                                                    \
    type* sm         = (type*)ASSUME_ALIGNED(FIRST_ROW(view->s[m]), alignof(type));                \
    type tmp1        = (xor)(second[m], second[j]);                                                \
    type tmp2        = (and)(first[j], second[m]);                                                 \
    tmp1             = (and)(tmp1, first[m]);                                                      \
    tmp1             = (xor)(tmp1, tmp2);                                                          \
    tmp2             = (xor)(r[m], r[j]);                                                          \
    res[m] = tmp1 = (xor)(tmp1, tmp2);                                                             \
    tmp1          = (shift_right)(tmp1, viewshift);                                                \
    *sm           = (xor)(tmp1, *sm);                                                              \
  }                                                                                                \
  type const* s1 =                                                                                 \
      (type const*)ASSUME_ALIGNED(CONST_FIRST_ROW(view->s[SC_VERIFY - 1]), alignof(type));         \
  type rsc           = (shift_left)(*s1, viewshift);                                               \
  res[SC_VERIFY - 1] = (and)(rsc, mask);

#define mpc_and_verify_def_multiple(type, and, xor, shift_right, shift_left, size)                 \
  for (unsigned m = 0; m < (SC_VERIFY - 1); ++m) {                                                 \
    const unsigned j = (m + 1);                                                                    \
    type* sm         = (type*)ASSUME_ALIGNED(FIRST_ROW(view->s[m]), alignof(type));                \
    type tmp1[size], tmp2[size];                                                                   \
    (xor)(tmp1, second[m], second[j]);                                                             \
    (and)(tmp2, first[j], second[m]);                                                              \
    (and)(tmp1, tmp1, first[m]);                                                                   \
    (xor)(tmp1, tmp1, tmp2);                                                                       \
    (xor)(tmp2, r[m], r[j]);                                                                       \
    (xor)(tmp1, tmp1, tmp2);                                                                       \
    memcpy(res[m], tmp1, size * sizeof(type));                                                     \
    (shift_right)(tmp1, tmp1, viewshift);                                                          \
    (xor)(sm, tmp1, sm);                                                                           \
    uint64_t* tmp = (uint64_t*)&(view->t[m]);                                                      \
    *tmp ^= ((uint64_t*)&tmp1)[sizeof(type) / sizeof(uint64_t) - 1];                               \
  }                                                                                                \
  type const* s1 =                                                                                 \
      (type const*)ASSUME_ALIGNED(CONST_FIRST_ROW(view->s[SC_VERIFY - 1]), alignof(type));         \
  type rsc[size];                                                                                  \
  (shift_left)(rsc, s1, viewshift);                                                                \
  (and)(res[SC_VERIFY - 1], rsc, mask);





void mpc_copy(mzd_local_t** out, mzd_local_t* const* in, unsigned sc) {
  for (unsigned i = 0; i < sc; ++i) {
    mzd_local_copy(out[i], in[i]);
  }
}
