/** 
 * \file parsing.c
 * \brief Implementation of parsing.h
 */

#include "parsing.h"
#include "string.h"
#include "parameters.h"

void rolloI_secret_key_to_string(unsigned char* skString, const unsigned char* seed) {
	memcpy(skString, seed, SEEDEXPANDER_SEED_BYTES);
}

void rolloI_secret_key_from_string(secretKey* sk, const unsigned char* skString) {
  unsigned char seed[40];
  memcpy(seed, skString, 40);
  AES_XOF_struct* sk_seedexpander = (AES_XOF_struct*) malloc(sizeof(AES_XOF_struct));
  seedexpander_init(sk_seedexpander, seed, seed + 32, SEEDEXPANDER_MAX_LENGTH);

  ffi_vspace_init(&(sk->F), PARAM_D);
  ffi_qre_init(&(sk->x));
  ffi_qre_init(&(sk->y));

  ffi_vspace_set_random_full_rank(sk->F, PARAM_D, sk_seedexpander);
  ffi_qre_set_random_from_support(sk->x, sk->F, PARAM_D, sk_seedexpander);
  ffi_qre_set_random_from_support(sk->y, sk->F, PARAM_D, sk_seedexpander);

  free(sk_seedexpander);
}


void rolloI_public_key_to_string(unsigned char* pkString, publicKey* pk) {
	ffi_vec_to_string_compact(pkString, pk->h->v, PARAM_N);
}

void rolloI_public_key_from_string(publicKey* pk, const unsigned char* pkString) {
	ffi_qre_init(&(pk->h));
	ffi_vec_from_string_compact(pk->h->v, PARAM_N, pkString);
}


void rolloI_ciphertext_to_string(unsigned char* ctString, ciphertext* ct) {
	ffi_vec_to_string_compact(ctString, ct->syndrom->v, PARAM_N);
}

void rolloI_ciphertext_from_string(ciphertext* ct, const unsigned char* ctString) {
	ffi_qre_init(&(ct->syndrom));
	ffi_vec_from_string_compact(ct->syndrom->v, PARAM_N, ctString);
}
