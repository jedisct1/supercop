/** 
 * \file rolloI_types.h
 * \brief File defining publicKey, secretKey and cipherText types for ROLLO-I
 */

#ifndef LAKE_TYPES_H
#define LAKE_TYPES_H

#include "ffi_qre.h"
#include "ffi_vspace.h"

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
} ciphertext;

#endif
