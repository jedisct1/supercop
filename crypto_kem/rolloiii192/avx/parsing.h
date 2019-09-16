/** 
 * \file parsing.h
 * \brief Functions to parse secret key, public key and ciphertext of the ROLLO scheme
 */

#ifndef PARSING_H
#define PARSING_H

#include "ffi_qre.h"
#include "ffi_vspace.h"

void rolloIII_secret_key_to_string(unsigned char* skString, const unsigned char* seed);
void rolloIII_secret_key_from_string(ffi_qre* x, ffi_qre* y, ffi_vspace* F, const unsigned char* skString);


void rolloIII_public_key_to_string(unsigned char* pkString, ffi_qre s, const unsigned char* seed);
void rolloIII_public_key_from_string(ffi_qre* h, ffi_qre* s, const unsigned char* pkString);


void rolloIII_ciphertext_to_string(unsigned char* ctString, ffi_qre sr, ffi_qre se);
void rolloIII_ciphertext_from_string(ffi_qre* sr, ffi_qre* se, const unsigned char* ctString);

#endif
