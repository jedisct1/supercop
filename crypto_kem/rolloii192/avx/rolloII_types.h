/** 
 * \file rolloII_types.h
 * \brief File defining publicKey, secretKey and cipherText types for ROLLO-II
 */

#ifndef LAKE_TYPES_H
#define LAKE_TYPES_H

#include "ffi_poly.h"
#include "ffi_vspace.h"
#include "parameters.h"

typedef struct secretKey {
	ffi_vspace F;
	ffi_qre x;
	ffi_qre y;
} secretKey;

typedef struct publicKey {
	ffi_qre h;
} publicKey;

typedef struct ciphertext{
	ffi_qre syndrom;
	unsigned char v[SHA512_BYTES];
	unsigned char d[SHA512_BYTES];
} ciphertext;

#endif
