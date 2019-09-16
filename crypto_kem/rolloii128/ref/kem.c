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
#include "rolloII_types.h"
#include "parsing.h"

int crypto_kem_keypair(unsigned char* pk, unsigned char* sk) {
  secretKey skTmp;
  publicKey pkTmp;

  ffi_field_init();
  ffi_qre_init_modulus(PARAM_N);

  unsigned char sk_seed[SEEDEXPANDER_SEED_BYTES];
  randombytes(sk_seed, SEEDEXPANDER_SEED_BYTES);

  rolloII_secret_key_from_string(&skTmp, sk_seed);

  ffi_qre invX;
  ffi_qre_init(&invX);
  ffi_qre_inv(invX, skTmp.x);

  ffi_qre_init(&(pkTmp.h));
  ffi_qre_mul(pkTmp.h, invX, skTmp.y);

  rolloII_secret_key_to_string(sk, sk_seed);
  rolloII_public_key_to_string(sk + SEEDEXPANDER_SEED_BYTES, &pkTmp);
  rolloII_public_key_to_string(pk, &pkTmp);

  #ifdef VERBOSE
    printf("\n\nsk_seed: "); for(int i = 0 ; i < SEEDEXPANDER_SEED_BYTES ; ++i) printf("%02x", sk_seed[i]);
    printf("\n\nx: "); ffi_qre_print(skTmp.x);
    printf("\n\ny: "); ffi_qre_print(skTmp.y);
    printf("\n\nx^-1: "); ffi_qre_print(invX);
    printf("\n\nh: "); ffi_qre_print(pkTmp.h);
    printf("\n\nsk: "); for(int i = 0 ; i < SECRET_KEY_BYTES ; ++i) printf("%02x", sk[i]);
    printf("\n\npk: "); for(int i = 0 ; i < PUBLIC_KEY_BYTES ; ++i) printf("%02x", pk[i]);
  #endif

  ffi_qre_clear(invX);
  ffi_vspace_clear(skTmp.F, PARAM_D);
  ffi_qre_clear(skTmp.x);
  ffi_qre_clear(skTmp.y);
  ffi_qre_clear(pkTmp.h);
  ffi_qre_clear_modulus();

  return 0;
}

int crypto_kem_enc(unsigned char* ct, unsigned char* ss, const unsigned char* pk) {
  publicKey pkTmp;
  ciphertext ctTmp;

  ffi_field_init();
  ffi_qre_init_modulus(PARAM_N);

  rolloII_public_key_from_string(&pkTmp, pk);

  ffi_vspace E;
  ffi_vspace_init(&E, PARAM_R);

  //Computing m
  unsigned char m[CRYPTO_BYTES];
  randombytes(m, CRYPTO_BYTES);

  //Generating G function
  AES_XOF_struct G_seedexpander;
  seedexpander_init(&G_seedexpander, m, m + 32, SEEDEXPANDER_MAX_LENGTH);

  // Computing theta
  unsigned char theta[SEEDEXPANDER_SEED_BYTES];
  seedexpander(&G_seedexpander, theta, SEEDEXPANDER_SEED_BYTES);

  //Seedexpander used to encrypt
  AES_XOF_struct encSeedexpander;
  seedexpander_init(&encSeedexpander, theta, theta + 32, SEEDEXPANDER_MAX_LENGTH);

  //Support
  ffi_vspace_set_random_full_rank(E, PARAM_R, &encSeedexpander);

  ffi_poly E1, E2;

  ffi_qre_init(&E1);
  ffi_qre_init(&E2);
  ffi_qre_init(&(ctTmp.syndrom));

  //Random error vectors
  ffi_qre_set_random_from_support(E1, E, PARAM_R, &encSeedexpander);
  ffi_qre_set_random_from_support(E2, E, PARAM_R, &encSeedexpander);

  ffi_qre_mul(ctTmp.syndrom, E2, pkTmp.h);
  ffi_qre_add(ctTmp.syndrom, ctTmp.syndrom, E1);

  ffi_vec_echelonize(E, PARAM_R);

  unsigned char support[FFI_VEC_R_BYTES], hashSupp[CRYPTO_BYTES];
  ffi_vec_to_string_compact(support, E, PARAM_R);
  sha512(hashSupp, support, FFI_VEC_R_BYTES);

  for(int i=0 ; i<CRYPTO_BYTES ; i++) {
    ctTmp.v[i] = m[i] ^ hashSupp[i];
  }

  sha512(ctTmp.d, m, CRYPTO_BYTES);

  //Compute shared secret
  //Derive shared secret from m, syndrom and v
  unsigned char mc[CIPHERTEXT_BYTES];
  memcpy(mc, m, SHA512_BYTES);
  ffi_vec_to_string_compact(mc + SHA512_BYTES, ctTmp.syndrom->v, PARAM_N);
  memcpy(mc + SHA512_BYTES + FFI_VEC_N_BYTES, ctTmp.v, SHA512_BYTES);
  sha512(ss, mc, CIPHERTEXT_BYTES);

  //Ciphertext parsing
  rolloII_ciphertext_to_string(ct, &ctTmp);

  ffi_vspace_clear(E, PARAM_R);
  ffi_qre_clear(E1);
  ffi_qre_clear(E2);
  ffi_qre_clear(pkTmp.h);
  ffi_qre_clear(ctTmp.syndrom);
  ffi_qre_clear_modulus();

  return 0;
}

int crypto_kem_dec(unsigned char* ss, const unsigned char* ct, const unsigned char* sk) {
  secretKey skTmp;
  ciphertext ctTmp;

  ffi_field_init();
  ffi_qre_init_modulus(PARAM_N);

  rolloII_secret_key_from_string(&skTmp, sk);
  rolloII_ciphertext_from_string(&ctTmp, ct);

  ffi_qre xc;
  ffi_qre_init(&xc);

  ffi_qre_mul(xc, skTmp.x, ctTmp.syndrom);

  ffi_vspace E;
  unsigned int dimE = 0;

  ffi_vspace_init(&E, PARAM_N);

  dimE = rank_support_recoverer(E, PARAM_R, skTmp.F, PARAM_D, xc, PARAM_N);

  unsigned char decryptedE[SHA512_BYTES];

  if(dimE != 0) {
    unsigned char support[FFI_VEC_R_BYTES];
    ffi_vec_to_string_compact(support, E, PARAM_R);
    sha512(decryptedE, support, FFI_VEC_R_BYTES);
  } else {
    memset(decryptedE, 0, SHARED_SECRET_BYTES);
  }

  unsigned char m2[CRYPTO_BYTES];

  for(int i=0 ; i<CRYPTO_BYTES ; i++) {
    m2[i] = decryptedE[i] ^ ctTmp.v[i];
  }

  // Generating G function
  AES_XOF_struct G_seedexpander;
  seedexpander_init(&G_seedexpander, m2, m2 + 32, SEEDEXPANDER_MAX_LENGTH);

  // Computing theta
  unsigned char theta[SEEDEXPANDER_SEED_BYTES];
  seedexpander(&G_seedexpander, theta, SEEDEXPANDER_SEED_BYTES);

  //Seedexpander used to encrypt
  AES_XOF_struct encSeedexpander;
  seedexpander_init(&encSeedexpander, theta, theta + 32, SEEDEXPANDER_MAX_LENGTH);

  /******** Re encrypt part ***********/
  publicKey pkTmp;

  rolloII_public_key_from_string(&pkTmp, sk + SEEDEXPANDER_SEED_BYTES);

  ffi_vspace Eprime;
  ffi_vspace_init(&Eprime, PARAM_R);
  ffi_vspace_set_random_full_rank(Eprime, PARAM_R, &encSeedexpander);

  ffi_poly E1prime, E2prime;
  ciphertext cprime;

  ffi_qre_init(&E1prime);
  ffi_qre_init(&E2prime);
  ffi_qre_init(&(cprime.syndrom));

  //Random error vectors
  ffi_qre_set_random_from_support(E1prime, Eprime, PARAM_R, &encSeedexpander);
  ffi_qre_set_random_from_support(E2prime, Eprime, PARAM_R, &encSeedexpander);

  ffi_qre_mul(cprime.syndrom, E2prime, pkTmp.h);
  ffi_qre_add(cprime.syndrom, cprime.syndrom, E1prime);

  ffi_vec_echelonize(Eprime, PARAM_R);

  unsigned char support[FFI_VEC_R_BYTES], hashSupp[CRYPTO_BYTES];
  ffi_vec_to_string_compact(support, Eprime, PARAM_R);
  sha512(hashSupp, support, FFI_VEC_R_BYTES);

  for(int i=0 ; i<CRYPTO_BYTES ; i++) {
    cprime.v[i] = m2[i] ^ hashSupp[i];
  }

  sha512(cprime.d, m2, CRYPTO_BYTES);

  unsigned int retValue = 0;

  //d = d' ?
  if(memcmp(ctTmp.d, cprime.d, SHA512_BYTES)) retValue = 1;
  //v = v' ?
  if(memcmp(ctTmp.v, cprime.v, SHA512_BYTES)) retValue = 1;
  //u = u' ?
  for(int i=0 ; i<PARAM_N ; i++) {
    if(!ffi_elt_is_equal_to(ctTmp.syndrom->v[i], cprime.syndrom->v[i])) {
      retValue = 1;
      break;
    }
  }

  if(retValue == 0) {
    unsigned char mc[CIPHERTEXT_BYTES];
    memcpy(mc, m2, SHA512_BYTES);
    ffi_vec_to_string_compact(mc + SHA512_BYTES, ctTmp.syndrom->v, PARAM_N);
    memcpy(mc + SHA512_BYTES + FFI_VEC_N_BYTES, ctTmp.v, SHA512_BYTES);
    sha512(ss, mc, CIPHERTEXT_BYTES);
  } else {
    memset(ss, 0, sizeof(SHARED_SECRET_BYTES));
  }

  ffi_vspace_clear(E, PARAM_R);
  ffi_vspace_clear(Eprime, PARAM_R);
  ffi_qre_clear(E1prime);
  ffi_qre_clear(E2prime);

  ffi_qre_clear(xc);

  ffi_vspace_clear(skTmp.F, PARAM_D);
  ffi_qre_clear(skTmp.x);
  ffi_qre_clear(skTmp.y);
  ffi_qre_clear(ctTmp.syndrom);
  ffi_qre_clear(cprime.syndrom);
  ffi_qre_clear(pkTmp.h);
  ffi_qre_clear_modulus();

  return retValue;

  return 0;
}
