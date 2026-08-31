// SPDX-License-Identifier: MIT

#ifndef SMAUGT_CONFIG_H
#define SMAUGT_CONFIG_H

#include "common.h"

#define SMAUGT_MODE1 0
#define SMAUGT_MODE3 1
#define SMAUGT_MODE5 2
#define SMAUGT_MODET 3

#if !defined(SMAUGT_CONFIG_MODE)
#define SMAUGT_CONFIG_MODE SMAUGT_MODE1
#endif

#if (SMAUGT_CONFIG_MODE != SMAUGT_MODE1) &&                                    \
    (SMAUGT_CONFIG_MODE != SMAUGT_MODE3) &&                                    \
    (SMAUGT_CONFIG_MODE != SMAUGT_MODE5) &&                                    \
    (SMAUGT_CONFIG_MODE != SMAUGT_MODET)
#error "Invalid SMAUGT_CONFIG_MODE"
#endif

#if !defined(SMAUGT_CONFIG_MODE_STRING)

#if SMAUGT_CONFIG_MODE == SMAUGT_MODE1
#define SMAUGT_CONFIG_MODE_STRING mode1
#elif SMAUGT_CONFIG_MODE == SMAUGT_MODE3
#define SMAUGT_CONFIG_MODE_STRING mode3
#elif SMAUGT_CONFIG_MODE == SMAUGT_MODE5
#define SMAUGT_CONFIG_MODE_STRING mode5
#elif SMAUGT_CONFIG_MODE == SMAUGT_MODET
#define SMAUGT_CONFIG_MODE_STRING modet
#endif

#endif

#if !defined(SMAUGT_CONFIG_NAMESPACE_PREFIX)
#define SMAUGT_CONFIG_NAMESPACE_PREFIX cryptolab_smaugt_
#endif

#if !defined(SMAUGT_CONFIG_NAMESPACE_PREFIX_MODE)
#define SMAUGT_ADD_MODE(s) SMAUGT_CONCAT(s, SMAUGT_CONFIG_MODE_STRING)
#define SMAUGT_CONFIG_NAMESPACE_PREFIX_MODE                                    \
    SMAUGT_CONCAT(SMAUGT_ADD_MODE(SMAUGT_CONFIG_NAMESPACE_PREFIX), _)
#endif

#endif /* !SMAUGT_CONFIG_H */
