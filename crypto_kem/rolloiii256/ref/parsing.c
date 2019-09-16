/** 
 * \file parsing.c
 * \brief Implementation of parsing.h
 */

#include "parsing.h"
#include "string.h"
#include "parameters.h"

void rolloIII_secret_key_to_string(unsigned char* skString, const unsigned char* seed) {
	memcpy(skString, seed, SEEDEXPANDER_SEED_BYTES);
}

void rolloIII_secret_key_from_string(ffi_qre* x, ffi_qre* y, ffi_vspace* F, const unsigned char* skString) {
  unsigned char seed[40];
  memcpy(seed, skString, 40);
  AES_XOF_struct* sk_seedexpander = (AES_XOF_struct*) malloc(sizeof(AES_XOF_struct));
  seedexpander_init(sk_seedexpander, seed, seed + 32, SEEDEXPANDER_MAX_LENGTH);

  ffi_vspace_init(F, PARAM_W);
  ffi_qre_init(x);
  ffi_qre_init(y);

  ffi_vspace_set_random_full_rank_with_one(*F, PARAM_W, sk_seedexpander);
  ffi_qre_set_random_from_support(*x, *F, PARAM_W, sk_seedexpander);
  ffi_qre_set_random_from_support(*y, *F, PARAM_W, sk_seedexpander);

  free(sk_seedexpander);
}


void rolloIII_public_key_to_string(unsigned char* pkString, ffi_qre s, const unsigned char* seed) {
	ffi_vec_to_string_compact(pkString, s->v, PARAM_N);
	memcpy(pkString + FFI_VEC_N_BYTES, seed, SEEDEXPANDER_SEED_BYTES);
}

void rolloIII_public_key_from_string(ffi_qre* h, ffi_qre* s, const unsigned char* pkString) {
	ffi_qre_init(s);
	ffi_vec_from_string_compact((*s)->v, PARAM_N, pkString);

	unsigned char pk_seed[SEEDEXPANDER_SEED_BYTES];
	memcpy(pk_seed, pkString + FFI_VEC_N_BYTES, SEEDEXPANDER_SEED_BYTES);
	AES_XOF_struct* pk_seedexpander = (AES_XOF_struct*) malloc(sizeof(AES_XOF_struct));
	seedexpander_init(pk_seedexpander, pk_seed, pk_seed + 32, SEEDEXPANDER_MAX_LENGTH);

	ffi_qre_init(h);
	ffi_vec_set_random((*h)->v, PARAM_N, pk_seedexpander); 

	free(pk_seedexpander);
}


void rolloIII_ciphertext_to_string(unsigned char* ctString, ffi_qre sr, ffi_qre se) {
	ffi_vec_to_string_compact(ctString, sr->v, PARAM_N);
	ffi_vec_to_string_compact(ctString + FFI_VEC_N_BYTES, se->v, PARAM_N);
}

void rolloIII_ciphertext_from_string(ffi_qre* sr, ffi_qre* se, const unsigned char* ctString) {
	ffi_qre_init(sr);
	ffi_vec_from_string_compact((*sr)->v, PARAM_N, ctString);
	ffi_qre_init(se);
	ffi_vec_from_string_compact((*se)->v, PARAM_N, ctString + FFI_VEC_N_BYTES);
}
