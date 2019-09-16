/** 
 * \file parsing.h
 * \brief Functions to parse secret key, public key and ciphertext of the RQC scheme
 */

#ifndef PARSING_H
#define PARSING_H

#include "ffi_qre.h"


void rqc_secret_key_to_string(unsigned char* sk, const unsigned char* seed, const unsigned char* pk);
void rqc_secret_key_from_string(ffi_qre x, ffi_qre y, unsigned char* pk, const unsigned char* sk);

void rqc_public_key_to_string(unsigned char* pk, const ffi_qre s, const unsigned char* seed);
void rqc_public_key_from_string(ffi_qre g, ffi_qre h, ffi_qre s, const unsigned char* pk);

void rqc_kem_ciphertext_to_string(unsigned char* ct, const ffi_qre u, const ffi_qre v, const unsigned char* d);
void rqc_kem_ciphertext_from_string(ffi_qre u, ffi_qre v, unsigned char* d, const unsigned char* ct);

#endif

