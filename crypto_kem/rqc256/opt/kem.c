/** 
 * \file kem.c
 * \brief Implementation of api.h
 */

#include "crypto_kem.h"
#include "ffi_qre.h"
#include "hash.h"
#include "parameters.h"
#include "parsing.h"
#include "rqc.h"
#include "string.h"

/** 
 * \fn int crypto_kem_keypair(unsigned char* pk, unsigned char* sk)
 * \brief Keygen of the RQC_KEM IND-CCA2 scheme
 *
 * The public key is composed of the syndrom <b>s</b> as well as the seed used to generate vectors <b>g</b> and <b>h</b>.
 *
 * The secret key is composed of the seed used to generate the vectors <b>x</b> and <b>y</b>.
 * As a technicality, the public key is appended to the secret key in order to respect the NIST API.
 *
 * \param[out] pk String containing the public key
 * \param[out] sk String containing the secret key
 * \return 0 if keygen is sucessfull
 */
int crypto_kem_keypair(unsigned char* pk, unsigned char* sk) {

  #ifdef VERBOSE
    printf("\n\n\n### KEYGEN ###");
  #endif

  rqc_pke_keygen(pk, sk);
  return 0;
}



/** 
 * \fn int crypto_kem_enc(unsigned char* ct, unsigned char* ss, const unsigned char* pk)
 * \brief Encapsulation of the RQC_KEM IND-CCA2 scheme
 *
 * \param[out] ct String containing the ciphertext
 * \param[out] ss String containing the shared secret
 * \param[in] pk String containing the public key
 * \return 0 if encapsulation is sucessfull
 */
int crypto_kem_enc(unsigned char* ct, unsigned char* ss, const unsigned char* pk) {

  #ifdef VERBOSE
    printf("\n\n\n\n### ENCAPS ###");
  #endif

  ffi_qre_init_modulus(PARAM_N);

  // Computing m
  ffi_vec m;
  ffi_vec_init(&m, PARAM_K);
  ffi_vec_set_random2(m, PARAM_K);

  // Generating G function
  AES_XOF_struct G_seedexpander;
  unsigned char seed_G[VEC_K_BYTES];
  ffi_vec_to_string_compact(seed_G, m, PARAM_K);
  seedexpander_init(&G_seedexpander, seed_G, seed_G + 32, SEEDEXPANDER_MAX_LENGTH);

  // Computing theta
  unsigned char theta[SEEDEXPANDER_SEED_BYTES];
  seedexpander(&G_seedexpander, theta, SEEDEXPANDER_SEED_BYTES);

  #ifdef VERBOSE
    printf("\n\npk: "); for(int i = 0 ; i < PUBLIC_KEY_BYTES ; ++i) printf("%02x", pk[i]);
    printf("\n\nm: "); ffi_vec_print(m, PARAM_K);
    printf("\n\ntheta: "); for(int i = 0 ; i < SEEDEXPANDER_SEED_BYTES ; ++i) printf("%02x", theta[i]);
  #endif

  // Encrypting m
  ffi_qre u, v;
  ffi_qre_init(&u);
  ffi_qre_init(&v);

  rqc_pke_encrypt(u, v, m, theta, pk);

  // Computing d
  unsigned char d[SHA512_BYTES];
  unsigned char mc[VEC_K_BYTES + 2 * VEC_N_BYTES];
  ffi_vec_to_string_compact(mc, m, PARAM_K);
  sha512(d, mc, VEC_K_BYTES);

  // Computing ciphertext
  rqc_kem_ciphertext_to_string(ct, u, v, d);
  
  // Computing shared secret
  ffi_qre_to_string_compact(mc + VEC_K_BYTES, u);
  ffi_qre_to_string_compact(mc + VEC_K_BYTES + VEC_N_BYTES, v);
  sha512(ss, mc, VEC_K_BYTES + 2 * VEC_N_BYTES);

  #ifdef VERBOSE
    printf("\n\nm: "); ffi_vec_print(m, PARAM_K);
    printf("\n\nd: "); for(int i = 0 ; i < SHA512_BYTES ; ++i) printf("%02x", d[i]);
    printf("\n\nciphertext: "); for(int i = 0 ; i < CIPHERTEXT_BYTES ; ++i) printf("%02x", ct[i]);
    printf("\n\nsecret 1: "); for(int i = 0 ; i < SHARED_SECRET_BYTES ; ++i) printf("%02x", ss[i]);
  #endif
  
  ffi_vec_clear(m, PARAM_K);
  ffi_qre_clear(u);
  ffi_qre_clear(v);
  ffi_qre_clear_modulus();

  return 0;
}



/** 
 * \fn int crypto_kem_dec(unsigned char* ss, const unsigned char* ct, const unsigned char* sk)
 * \brief Decapsulation of the RQC_KEM IND-CCA2 scheme
 *
 * \param[out] ss String containing the shared secret
 * \param[in] ct String containing the ciphertext
 * \param[in] sk String containing the secret key
 * \return 0 if decapsulation is successfull, -1 otherwise
 */
int crypto_kem_dec(unsigned char* ss, const unsigned char* ct, const unsigned char* sk) {

  ffi_qre_init_modulus(PARAM_N);

  #ifdef VERBOSE
    printf("\n\n\n\n### DECAPS ###");
  #endif

  // Retrieving u, v and d from ciphertext
  ffi_qre u, v;
  ffi_qre_init(&u);
  ffi_qre_init(&v);
  unsigned char d[SHA512_BYTES];
  rqc_kem_ciphertext_from_string(u, v, d, ct);

  // Retrieving pk from sk
  unsigned char pk[PUBLIC_KEY_BYTES];
  memcpy(pk, sk + SEEDEXPANDER_SEED_BYTES, PUBLIC_KEY_BYTES);

  #ifdef VERBOSE
    printf("\n\npk: "); for(int i = 0 ; i < PUBLIC_KEY_BYTES ; ++i) printf("%02x", pk[i]);
    printf("\n\nsk: "); for(int i = 0 ; i < SECRET_KEY_BYTES ; ++i) printf("%02x", sk[i]);
    printf("\n\nciphertext: "); for(int i = 0 ; i < CIPHERTEXT_BYTES ; ++i) printf("%02x", ct[i]);
  #endif

  // Decrypting
  ffi_vec m;
  ffi_vec_init(&m, PARAM_K);
  rqc_pke_decrypt(m, u, v, sk);

  // Generating G function
  AES_XOF_struct G_seedexpander;
  unsigned char seed_G[VEC_K_BYTES];
  ffi_vec_to_string_compact(seed_G, m, PARAM_K);
  seedexpander_init(&G_seedexpander, seed_G, seed_G + 32, SEEDEXPANDER_MAX_LENGTH);

  // Computing theta
  unsigned char theta[SEEDEXPANDER_SEED_BYTES];
  seedexpander(&G_seedexpander, theta, SEEDEXPANDER_SEED_BYTES);

  #ifdef VERBOSE
    printf("\n\ntheta: "); for(int i = 0 ; i < SEEDEXPANDER_SEED_BYTES ; ++i) printf("%02x", theta[i]);
    printf("\n\n\n# Checking Ciphertext- Begin #");
  #endif

  // Encrypting m'
  ffi_qre u2, v2;
  ffi_qre_init(&u2);
  ffi_qre_init(&v2);

  rqc_pke_encrypt(u2, v2, m, theta, pk);

  // Checking that c = c' and abort otherwise
  int abort = 0;
  if(ffi_qre_is_equal_to(u, u2) == 0 || ffi_qre_is_equal_to(v, v2) == 0) {
    abort = 1;
  }

  // Computing d'
  unsigned char d2[SHA512_BYTES];
  unsigned char mc[VEC_K_BYTES + 2 * VEC_N_BYTES];
  ffi_vec_to_string_compact(mc, m, PARAM_K);
  sha512(d2, mc, VEC_K_BYTES);

  // Checking that d = d' and abort otherwise
  if(memcmp(d, d2, SHA512_BYTES) != 0) {
    abort = 1;
  }

  #ifdef VERBOSE
    printf("\n\nu2: "); ffi_qre_print(u2);
    printf("\n\nv2: "); ffi_qre_print(v2);
    printf("\n\nd2: "); for(int i = 0 ; i < SHA512_BYTES ; ++i) printf("%02x", d2[i]);
  #endif

  if(abort == 1) {
    #ifdef VERBOSE
      printf("\n\nCheck result : ABORT");
      printf("\n\n# Checking Ciphertext - End #\n");
    #endif

    memset(ss, 0, SHARED_SECRET_BYTES);
    return -1;
  }

  // Computing shared secret
  ffi_qre_to_string_compact(mc + VEC_K_BYTES, u);
  ffi_qre_to_string_compact(mc + VEC_K_BYTES + VEC_N_BYTES, v);
  sha512(ss, mc, VEC_K_BYTES + 2 * VEC_N_BYTES);

  #ifdef VERBOSE
    printf("\n\nCheck result: SUCCESS");
    printf("\n\n# Checking Ciphertext - End #\n");
  #endif

  ffi_vec_clear(m, PARAM_K);
  ffi_qre_clear(u);
  ffi_qre_clear(v);
  ffi_qre_clear(u2);
  ffi_qre_clear(v2);
  ffi_qre_clear_modulus();

  return 0;
}

