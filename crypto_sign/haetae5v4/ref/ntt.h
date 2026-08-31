// SPDX-License-Identifier: MIT

#ifndef HAETAE_NTT_H
#define HAETAE_NTT_H

#include "params.h"

#include <stdint.h>

#define ntt HAETAE_NAMESPACE(ntt)
void ntt(int32_t a[HAETAE_N]);

#define invntt_tomont HAETAE_NAMESPACE(invntt_tomont)
void invntt_tomont(int32_t a[HAETAE_N]);

#endif /* !HAETAE_NTT_H */
