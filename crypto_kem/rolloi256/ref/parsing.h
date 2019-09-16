/** 
 * \file parsing.h
 * \brief Functions to parse secret key, public key and ciphertext of the ROLLO scheme
 */

#ifndef PARSING_H
#define PARSING_H

#include "rolloI_types.h"

void rolloI_secret_key_to_string(unsigned char* skString, const unsigned char* seed);
void rolloI_secret_key_from_string(secretKey* sk, const unsigned char* skString);


void rolloI_public_key_to_string(unsigned char* pkString, publicKey* pk);
void rolloI_public_key_from_string(publicKey* pk, const unsigned char* pkString);


void rolloI_ciphertext_to_string(unsigned char* ctString, ciphertext* ct);
void rolloI_ciphertext_from_string(ciphertext* ct, const unsigned char* ctString);

#endif
