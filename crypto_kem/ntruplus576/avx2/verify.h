#ifndef VERIFY_H
#define VERIFY_H

#include <stddef.h>
#include <stdint.h>
#include "params.h"

int verify(const uint8_t *a, const uint8_t *b, size_t len);

#endif
