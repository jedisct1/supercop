// SPDX-License-Identifier: MIT

#ifndef SMAUGT_COMMON_H
#define SMAUGT_COMMON_H

#define SMAUGT_CONCAT_(x1, x2) x1##x2
#define SMAUGT_CONCAT(x1, x2) SMAUGT_CONCAT_(x1, x2)

#define SMAUGT_STR_(x) #x
#define SMAUGT_STR(x) SMAUGT_STR_(x)

#endif /* !SMAUGT_COMMON_H */
