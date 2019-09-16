/** 
 * \file kem.c
 * \brief Implementation of api.h
 */

#include "crypto_kem.h"
#include "ffi_qre.h"
#include "hash.h"
#include "parameters.h"
#include "string.h"
#include "rsr_algorithm.h"
#include "parsing.h"

int crypto_kem_keypair(unsigned char* pk, unsigned char* sk) {
  ffi_field_init();
  ffi_qre_init_modulus(PARAM_N);

  unsigned char sk_seed[SEEDEXPANDER_SEED_BYTES];
  randombytes(sk_seed, SEEDEXPANDER_SEED_BYTES);
  AES_XOF_struct* sk_seedexpander = (AES_XOF_struct*) malloc(sizeof(AES_XOF_struct));
  seedexpander_init(sk_seedexpander, sk_seed, sk_seed + 32, SEEDEXPANDER_MAX_LENGTH);

  unsigned char pk_seed[SEEDEXPANDER_SEED_BYTES];
  randombytes(pk_seed, SEEDEXPANDER_SEED_BYTES);
  AES_XOF_struct* pk_seedexpander = (AES_XOF_struct*) malloc(sizeof(AES_XOF_struct));
  seedexpander_init(pk_seedexpander, pk_seed, pk_seed + 32, SEEDEXPANDER_MAX_LENGTH);

  //Secret key
  ffi_vspace F;
  ffi_vspace_init(&F, PARAM_W);
  ffi_vspace_set_random_full_rank_with_one(F, PARAM_W, sk_seedexpander);

  ffi_qre x, y;
  ffi_qre_init(&x);
  ffi_qre_init(&y);
  
  ffi_qre_set_random_from_support(x, F, PARAM_W, sk_seedexpander);
  ffi_qre_set_random_from_support(y, F, PARAM_W, sk_seedexpander);

  //Public key
  ffi_qre h, s;
  ffi_qre_init(&h);
  ffi_qre_init(&s);
  ffi_vec_set_random(h->v, PARAM_N, pk_seedexpander);
  ffi_qre_mul(s, h, y);
  ffi_qre_add(s, s, x);

  rolloIII_secret_key_to_string(sk, sk_seed);
  rolloIII_public_key_to_string(pk, s, pk_seed);

  #ifdef VERBOSE
    printf("\n\nsk_seed: "); for(int i = 0 ; i < SEEDEXPANDER_SEED_BYTES ; ++i) printf("%02x", sk_seed[i]);
    printf("\n\npk_seed: "); for(int i = 0 ; i < SEEDEXPANDER_SEED_BYTES ; ++i) printf("%02x", pk_seed[i]);
    printf("\n\nF: "); ffi_vspace_print(F, PARAM_W);
    printf("\n\nx: "); ffi_qre_print(x);
    printf("\n\ny: "); ffi_qre_print(y);
    printf("\n\nh: "); ffi_qre_print(h);
    printf("\n\ns: "); ffi_qre_print(s);
    printf("\n\nsk: "); for(int i = 0 ; i < SECRET_KEY_BYTES ; ++i) printf("%02x", sk[i]);
    printf("\n\npk: "); for(int i = 0 ; i < PUBLIC_KEY_BYTES ; ++i) printf("%02x", pk[i]);
  #endif

  ffi_vspace_clear(F, PARAM_W);
  ffi_qre_clear(x);
  ffi_qre_clear(y);
  ffi_qre_clear(h);
  ffi_qre_clear(s);
  ffi_qre_clear_modulus(PARAM_N);

  free(pk_seedexpander);
  free(sk_seedexpander);

  return 0;
}

int crypto_kem_enc(unsigned char* ct, unsigned char* ss, const unsigned char* pk) {
  ffi_field_init();
  ffi_qre_init_modulus(PARAM_N);

  ffi_qre h, s;
  rolloIII_public_key_from_string(&h, &s, pk);

  ffi_vspace E;
  ffi_vspace_init(&E, PARAM_W_R);

  //Support
  ffi_vspace_set_random_full_rank2(E, PARAM_W_R);

  ffi_qre r1, r2, er;

  ffi_qre_init(&r1);
  ffi_qre_init(&r2);
  ffi_qre_init(&er);

  //Random error vectors
  ffi_qre_set_random_from_support2(r1, E, PARAM_W_R);
  ffi_qre_set_random_from_support2(r2, E, PARAM_W_R);
  ffi_qre_set_random_from_support2(er, E, PARAM_W_R);

  ffi_qre sr;
  ffi_qre_init(&sr);
  ffi_qre_mul(sr, h, r2);
  ffi_qre_add(sr, sr, r1);

  ffi_qre se;
  ffi_qre_init(&se);
  ffi_qre_mul(se, s, r2);
  ffi_qre_add(se, se, er);

  rolloIII_ciphertext_to_string(ct, sr, se);

  ffi_vec_echelonize(E, PARAM_W_R);

  unsigned char support[FFI_VEC_R_BYTES];
  ffi_vec_to_string_compact(support, E, PARAM_W_R);
  sha512(ss, support, FFI_VEC_R_BYTES);

  #ifdef VERBOSE
    printf("\n\nE: "); ffi_vspace_print(E, PARAM_W_R);
    printf("\n\nsupport: "); for(int i = 0 ; i < FFI_VEC_R_BYTES ; ++i) printf("%02x", support[i]);
    printf("\n\nr1: "); ffi_qre_print(r1);
    printf("\n\nr2: "); ffi_qre_print(r2);
    printf("\n\nsr: "); ffi_qre_print(sr);
    printf("\n\nse: "); ffi_qre_print(se);
    printf("\n\nss: "); for(int i = 0 ; i < SHARED_SECRET_BYTES ; ++i) printf("%02x", ss[i]);
  #endif

  ffi_qre_clear(h);
  ffi_qre_clear(s);
  ffi_vspace_clear(E, PARAM_W_R);
  ffi_qre_clear(r1);
  ffi_qre_clear(r2);
  ffi_qre_clear(er);
  ffi_qre_clear(sr);
  ffi_qre_clear(se);
  ffi_qre_clear_modulus(PARAM_N);

  return 0;
}

int crypto_kem_dec(unsigned char* ss, const unsigned char* ct, const unsigned char* sk) {
  ffi_field_init();
  ffi_qre_init_modulus(PARAM_N);

  ffi_qre sr, se;
  rolloIII_ciphertext_from_string(&sr, &se, ct);

  ffi_vspace F;
  ffi_qre x, y;
  rolloIII_secret_key_from_string(&x, &y, &F, sk);

  ffi_qre ec;
  ffi_qre_init(&ec);
  ffi_qre_mul(ec, y, sr);
  ffi_qre_add(ec, ec, se);

  ffi_vspace E;
  unsigned int dimE = 0;

  ffi_vspace_init(&E, PARAM_N);

  dimE = rank_support_recoverer(E, PARAM_W_R, F, PARAM_W, ec, PARAM_N);

  if(dimE != 0) {
    unsigned char support[FFI_VEC_R_BYTES];
    ffi_vec_to_string_compact(support, E, PARAM_W_R);
    sha512(ss, support, FFI_VEC_R_BYTES);
  } else {
    memset(ss, 0, SHARED_SECRET_BYTES);
  }

  #ifdef VERBOSE
    printf("\n\nRecovered E: "); ffi_vspace_print(E, dimE);
    printf("\n\nec: "); ffi_qre_print(ec);
    printf("\n\nss: "); for(int i = 0 ; i < SHARED_SECRET_BYTES ; ++i) printf("%02x", ss[i]);
  #endif

  ffi_vspace_clear(E, PARAM_N);
  ffi_qre_clear(sr);
  ffi_qre_clear(se);
  ffi_vspace_clear(F, PARAM_W);
  ffi_qre_clear(x);
  ffi_qre_clear(y);
  ffi_qre_clear(ec);
  ffi_qre_clear_modulus(PARAM_N);

  if(dimE != PARAM_W_R) return 1;

  return 0;
}
