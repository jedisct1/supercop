/** 
 * \file parsing.c
 * \brief Implementation of parsing.h
 */

#include "string.h"
#include "ffi_vspace.h"
#include "ffi_qre.h"
#include "parameters.h"
#include "parsing.h"


/** 
 * \fn void rqc_secret_key_to_string(unsigned char* sk, const unsigned char* seed, const unsigned char* pk)
 * \brief This function parses a secret key into a string
 *
 * The secret key is composed of the seed used to generate vectors <b>x</b> and <b>y</b>.
 * As a technicality, the public key is appended to the secret key in order to respect the NIST API.
 *
 * \param[out] sk String containing the secret key
 * \param[in] seed Seed used to generate the vectors x and y
 * \param[in] pk String containing the public key
 */
void rqc_secret_key_to_string(unsigned char* sk, const unsigned char* seed, const unsigned char* pk) {
  memcpy(sk, seed, SEEDEXPANDER_SEED_BYTES);
  memcpy(sk + SEEDEXPANDER_SEED_BYTES, pk, PUBLIC_KEY_BYTES);
}



/** 
* \fn void rqc_secret_key_from_string(ffi_qre x, ffi_qre y, unsigned char* pk, const unsigned char* sk)
* \brief This function parses a secret key from a string
*
* The secret key is composed of the seed used to generate vectors <b>x</b> and <b>y</b>.
* As a technicality, the public key is appended to the secret key in order to respect the NIST API.
*
* \param[out] x ffi_qre representation of vector x
* \param[out] y ffi_qre representation of vector y
* \param[out] pk String containing the public key
* \param[in] sk String containing the secret key
*/
void rqc_secret_key_from_string(ffi_qre x, ffi_qre y, unsigned char* pk, const unsigned char* sk) {

  AES_XOF_struct sk_seedexpander;
  unsigned char sk_seed[SEEDEXPANDER_SEED_BYTES];
  memcpy(sk_seed, sk, SEEDEXPANDER_SEED_BYTES);
  seedexpander_init(&sk_seedexpander, sk_seed, sk_seed + 32, SEEDEXPANDER_MAX_LENGTH);

  ffi_vspace support_w;
  ffi_vspace_init(&support_w, PARAM_W);
  ffi_vspace_set_random_full_rank_with_one(support_w, PARAM_W, &sk_seedexpander);

  ffi_qre_set_random_from_support(x, support_w, PARAM_W, &sk_seedexpander);
  ffi_qre_set_random_from_support(y, support_w, PARAM_W, &sk_seedexpander);

  ffi_vspace_clear(support_w, PARAM_W);
  memcpy(pk, sk + SEEDEXPANDER_SEED_BYTES, PUBLIC_KEY_BYTES);
}



/** 
 * \fn void rqc_public_key_to_string(unsigned char* pk, const ffi_qre s, const unsigned char* seed)
 * \brief This function parses a public key into a string
 *
 * The public key is composed of the syndrom <b>s</b> as well as the seed used to generate vectors <b>g</b> and <b>h</b>.
 *
 * \param[out] pk String containing the public key
 * \param[in] s ffi_qre representation of vector s
 * \param[in] seed Seed used to generate the public key
 */
void rqc_public_key_to_string(unsigned char* pk, const ffi_qre s, const unsigned char* seed) {
  ffi_qre_to_string_compact(pk, s);
  memcpy(pk + VEC_N_BYTES, seed, SEEDEXPANDER_SEED_BYTES);
}



/** 
 * \fn void rqc_public_key_from_string(ffi_qre g, ffi_qre h, ffi_qre s, const unsigned char* pk)
 * \brief This function parses a public key from a string
 *
 * The public key is composed of the syndrom <b>s</b> as well as the seed used to generate vectors <b>g</b> and <b>h</b>.
 *
 * \param[out] g ffi_qre representation of vector g
 * \param[out] h ffi_qre representation of vector h
 * \param[out] s ffi_qre representation of vector s
 * \param[in] pk String containing the public key
 */
void rqc_public_key_from_string(ffi_qre g, ffi_qre h, ffi_qre s, const unsigned char* pk) {
  ffi_qre_from_string_compact(s, pk);

  unsigned char pk_seed[SEEDEXPANDER_SEED_BYTES];
  memcpy(pk_seed, pk + VEC_N_BYTES, SEEDEXPANDER_SEED_BYTES);

  AES_XOF_struct pk_seedexpander;
  seedexpander_init(&pk_seedexpander, pk_seed, pk_seed + 32, SEEDEXPANDER_MAX_LENGTH);

  ffi_qre_set_random_full_rank(g, &pk_seedexpander);
  ffi_qre_set_random(h, &pk_seedexpander); 
}



/** 
 * \fn void rqc_kem_ciphertext_to_string(unsigned char* ct, const ffi_qre u, const ffi_qre v, const unsigned char* d) {
 * \brief This function parses a ciphertext into a string
 *
 * The ciphertext is composed of vectors <b>u</b>, <b>v</b> and the hash <b>d</b>.
 *
 * \param[out] ct String containing the ciphertext
 * \param[in] u ffi_qre representation of vector u
 * \param[in] v ffi_qre representation of vector v
 * \param[in] d String containing the hash d
 */
void rqc_kem_ciphertext_to_string(unsigned char* ct, const ffi_qre u, const ffi_qre v, const unsigned char* d) {
  ffi_qre_to_string_compact(ct, u);
  ffi_qre_to_string_compact(ct + VEC_N_BYTES, v);
  memcpy(ct + 2 * VEC_N_BYTES, d, SHA512_BYTES);
}



/** 
 * \fn void rqc_kem_ciphertext_from_string(ffi_qre u, ffi_qre v, unsigned char* d, const unsigned char* ct)
 * \brief This function parses a ciphertext from a string
 *
 * The ciphertext is composed of vectors <b>u</b>, <b>v</b> and the hash <b>d</b>.
 *
 * \param[out] u ffi_qre representation of vector u
 * \param[out] v ffi_qre representation of vector v
 * \param[out] d String containing the hash d
 * \param[in] ct String containing the ciphertext
 */
void rqc_kem_ciphertext_from_string(ffi_qre u, ffi_qre v, unsigned char* d, const unsigned char* ct) {
  ffi_qre_from_string_compact(u, ct);
  ffi_qre_from_string_compact(v, ct + VEC_N_BYTES);
  memcpy(d, ct + 2 * VEC_N_BYTES, SHA512_BYTES);
}

