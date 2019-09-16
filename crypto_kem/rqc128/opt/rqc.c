/** 
 * \file rqc.c
 * \brief Implementation of rqc.h
 */

#include "rqc.h"
#include "parameters.h"
#include "ffi_vspace.h"
#include "ffi_qre.h"
#include "gabidulin.h"
#include "parsing.h"

/** 
 * \fn void rqc_pke_keygen(unsigned char* pk, unsigned char* sk)
 * \brief Keygen of the RQC_PKE IND-CPA scheme
 *
 * The public key is composed of the syndrom <b>s</b> as well as the <b>seed</b> used to generate vectors <b>g</b> and <b>h</b>.
 *
 * The secret key is composed of the seed used to generate vectors <b>x</b> and <b>y</b>.
 * As a technicality, the public key is appended to the secret key in order to respect the NIST API.
 *
 * \param[out] pk String containing the public key
 * \param[out] sk String containing the secret key
 */
void rqc_pke_keygen(unsigned char* pk, unsigned char* sk) {

  ffi_qre_init_modulus(PARAM_N);

  // Create seed expanders for public key and secret key
  AES_XOF_struct sk_seedexpander;
  unsigned char sk_seed[SEEDEXPANDER_SEED_BYTES];
  randombytes(sk_seed, SEEDEXPANDER_SEED_BYTES);
  seedexpander_init(&sk_seedexpander, sk_seed, sk_seed + 32, SEEDEXPANDER_MAX_LENGTH);

  AES_XOF_struct pk_seedexpander;
  unsigned char pk_seed[SEEDEXPANDER_SEED_BYTES];
  randombytes(pk_seed, SEEDEXPANDER_SEED_BYTES);
  seedexpander_init(&pk_seedexpander, pk_seed, pk_seed + 32, SEEDEXPANDER_MAX_LENGTH);

  // Compute secret key
  ffi_vspace support_w;
  ffi_vspace_init(&support_w, PARAM_W);
  ffi_vspace_set_random_full_rank_with_one(support_w, PARAM_W, &sk_seedexpander);

  ffi_qre x, y;
  ffi_qre_init(&x);
  ffi_qre_init(&y);
  ffi_qre_set_random_from_support(x, support_w, PARAM_W, &sk_seedexpander);
  ffi_qre_set_random_from_support(y, support_w, PARAM_W, &sk_seedexpander);

  // Compute public key
  ffi_qre g, h, s;
  ffi_qre_init(&g);
  ffi_qre_init(&h);
  ffi_qre_init(&s);

  ffi_qre_set_random_full_rank(g, &pk_seedexpander);
  ffi_qre_set_random(h, &pk_seedexpander); 
  
  ffi_qre_mul(s, h, y);
  ffi_qre_add(s, s, x);

  // Parse keys to string
  rqc_public_key_to_string(pk, s, pk_seed);
  rqc_secret_key_to_string(sk, sk_seed, pk);

  #ifdef VERBOSE
    printf("\n\nsk_seed: "); for(int i = 0 ; i < SEEDEXPANDER_SEED_BYTES ; ++i) printf("%02x", sk_seed[i]);
    printf("\n\npk_seed: "); for(int i = 0 ; i < SEEDEXPANDER_SEED_BYTES ; ++i) printf("%02x", pk_seed[i]);
    printf("\n\nsupport_w: "); ffi_vspace_print(support_w, PARAM_W);
    printf("\n\nx: "); ffi_qre_print(x);
    printf("\n\ny: "); ffi_qre_print(y);
    printf("\n\ng: "); ffi_qre_print(g);
    printf("\n\nh: "); ffi_qre_print(h);
    printf("\n\ns: "); ffi_qre_print(s);
    printf("\n\nsk: "); for(int i = 0 ; i < SECRET_KEY_BYTES ; ++i) printf("%02x", sk[i]);
    printf("\n\npk: "); for(int i = 0 ; i < PUBLIC_KEY_BYTES ; ++i) printf("%02x", pk[i]);
  #endif

  ffi_vspace_clear(support_w, PARAM_W);
  ffi_qre_clear(x);
  ffi_qre_clear(y);
  ffi_qre_clear(g);
  ffi_qre_clear(h);
  ffi_qre_clear(s);
  ffi_qre_clear_modulus();
}



/** 
 * \fn void rqc_pke_encrypt(ffi_qre u, ffi_qre v, const ffi_vec m, unsigned char* theta, const unsigned char* pk)
 * \brief Encryption of the RQC_PKE IND-CPA scheme
 *
 * The ciphertext is composed of the vectors <b>u</b> and <b>v</b>.
 *
 * \param[out] u Vector u (first part of the ciphertext)
 * \param[out] v Vector v (second part of the ciphertext)
 * \param[in] m Vector representing the message to encrypt
 * \param[in] theta Seed used to derive randomness required for encryption
 * \param[in] pk String containing the public key
 */
void rqc_pke_encrypt(ffi_qre u, ffi_qre v, const ffi_vec m, unsigned char* theta, const unsigned char* pk) {

  ffi_qre_init_modulus(PARAM_N);

  // Create seed_expander from theta
  AES_XOF_struct seedexpander;
  seedexpander_init(&seedexpander, theta, theta + 32, SEEDEXPANDER_MAX_LENGTH);

  // Retrieve g, h and s from public key
  ffi_qre g, h, s;
  ffi_qre_init(&g);
  ffi_qre_init(&h);
  ffi_qre_init(&s);

  rqc_public_key_from_string(g, h, s, pk);

  // Generate r1, r2 and e
  ffi_vspace support_r;
  ffi_vspace_init(&support_r, PARAM_W_R);
  ffi_vspace_set_random_full_rank(support_r, PARAM_W_R, &seedexpander);

  ffi_qre r1, r2, e;
  ffi_qre_init(&r1);
  ffi_qre_init(&r2);
  ffi_qre_init(&e);

  ffi_qre_set_random_from_support(r1, support_r, PARAM_W_R, &seedexpander);
  ffi_qre_set_random_from_support(r2, support_r, PARAM_W_R, &seedexpander);
  ffi_qre_set_random_from_support(e, support_r, PARAM_W_R, &seedexpander);

  // Compute u = r1 + h.r2
  ffi_qre_mul(u, h, r2);
  ffi_qre_add(u, u, r1);

  // Compute v = m.G by encoding the message
  gabidulin_code code = gabidulin_code_init(g, PARAM_K, PARAM_N);
  gabidulin_code_encode(v, code, m);

  // Compute v = m.G + s.r2 + e
  ffi_qre tmp;
  ffi_qre_init(&tmp);

  ffi_qre_mul(tmp, s, r2);
  ffi_qre_add(tmp, tmp, e);
  ffi_qre_add(v, v, tmp);

  #ifdef VERBOSE
    printf("\n\ng: "); ffi_qre_print(g);
    printf("\n\nh: "); ffi_qre_print(h);
    printf("\n\ns: "); ffi_qre_print(s);
    printf("\n\nsupport_r: "); ffi_vspace_print(support_r, PARAM_W_R);
    printf("\n\nr1: "); ffi_qre_print(r1);
    printf("\n\nr2: "); ffi_qre_print(r2);
    printf("\n\ne: "); ffi_qre_print(e);
    printf("\n\nu: "); ffi_qre_print(u);
    printf("\n\nv: "); ffi_qre_print(v);
  #endif

  ffi_qre_clear(g);
  ffi_qre_clear(h);
  ffi_qre_clear(s);
  ffi_vspace_clear(support_r, PARAM_W_R);
  ffi_qre_clear(r1);
  ffi_qre_clear(r2);
  ffi_qre_clear(e);
  ffi_qre_clear(tmp);
  ffi_qre_clear_modulus();
}



/** 
 * \fn void rqc_pke_decrypt(ffi_vec m, const ffi_qre& u, const ffi_qre v, const unsigned char* sk)
 * \brief Decryption of the RQC_PKE IND-CPA scheme
 *
 * \param[out] m Vector representing the decrypted message
 * \param[in] u Vector u (first part of the ciphertext)
 * \param[in] v Vector v (second part of the ciphertext)
 * \param[in] sk String containing the secret key
 */
void rqc_pke_decrypt(ffi_vec m, const ffi_qre u, const ffi_qre v, const unsigned char* sk) {

  ffi_qre_init_modulus(PARAM_N);

  // Retrieve x, y, g, h and s from secret key
  unsigned char pk[PUBLIC_KEY_BYTES];
  ffi_qre x, y, g, h, s; 

  ffi_qre_init(&x);
  ffi_qre_init(&y);
  ffi_qre_init(&g);
  ffi_qre_init(&h);
  ffi_qre_init(&s);

  rqc_secret_key_from_string(x, y, pk, sk);
  rqc_public_key_from_string(g, h, s, pk);

  // Compute v - u.y
  ffi_qre tmp;
  ffi_qre_init(&tmp);
  ffi_qre_mul(tmp, u, y);
  ffi_qre_add(tmp, v, tmp);

  #ifdef VERBOSE
    printf("\n\nu: "); ffi_qre_print(u);
    printf("\n\nnv: "); ffi_qre_print(v);
    printf("\n\ny: "); ffi_qre_print(y);
    printf("\n\nv - u.y: "); ffi_qre_print(tmp);
  #endif

  // Compute m by decoding v - u.y
  gabidulin_code code = gabidulin_code_init(g, PARAM_K, PARAM_N);
  gabidulin_code_decode(m, code, tmp);

  ffi_qre_clear(x);
  ffi_qre_clear(y);
  ffi_qre_clear(g);
  ffi_qre_clear(h);
  ffi_qre_clear(s);
  ffi_qre_clear(tmp);
  ffi_qre_clear_modulus();
}

