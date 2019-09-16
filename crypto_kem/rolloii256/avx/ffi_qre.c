/**
 * \file ffi_qre.c
 * \brief Implementation of ffi_qre.h
 */

#include "ffi.h"
#include "ffi_poly.h"
#include "ffi_qre.h"

static int init_modulus = 0;

/**
 * \fn void ffi_qre_init_modulus(uint64_t n) {
 * \brief This function init the quotient ring modulus corresponding to PARAM_N
 *
 * \param[in] n Degree of the modulus
 */
void ffi_qre_init_modulus(uint64_t n) {
  if(init_modulus == 0) {
    QRE_DEG = n-1;
    modulus = ffi_qre_get_modulus(n);
    ffi_poly_init(&modulusInv, QRE_DEG+1);
    ffi_poly_set_zero(modulusInv, QRE_DEG+1);
    for(int i=0 ; i<modulus->coeffs_nb ; i++) {
      ffi_elt_set_one(modulusInv->v[modulus->coeffs[i]]);
    }
  }
  init_modulus++;
}



/**
 * \fn void ffi_qre_init_modulus(uint64_t n) {
 * \brief This function clears the quotient ring modulus in use
 */
void ffi_qre_clear_modulus() {
  init_modulus--;
  if(init_modulus == 0) {
    ffi_poly_sparse_clear(modulus);
    ffi_poly_clear(modulusInv);
  }
}



/**
 * \fn ffi_poly_sparse ffi_qre_get_modulus(uint64_t n) {
 * \brief This function return the sparse polynomial used as the quotient ring modulus for PARAM_N
 *
 * \param[in] n Degree of the modulus
 */
ffi_poly_sparse ffi_qre_get_modulus(uint64_t n) {
  ffi_poly_sparse modulus;
  uint64_t* values;

  if(n == 47) {
    values = (uint64_t*) malloc(3 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 5;
    values[2] = 47;
    ffi_poly_sparse_init(&modulus, 3, values);
    free(values);
  } else if(n == 53) {
    values = (uint64_t*) malloc(5 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 1;
    values[2] = 2;
    values[3] = 6;
    values[4] = 53;
    ffi_poly_sparse_init(&modulus, 5, values);
    free(values);
  } else if(n == 59) {
    values = (uint64_t*) malloc(5 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 2;
    values[2] = 4;
    values[3] = 7;
    values[4] = 59;
    ffi_poly_sparse_init(&modulus, 5, values);
    free(values);
  } else if(n == 67) {
    values = (uint64_t*) malloc(5 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 1;
    values[2] = 2;
    values[3] = 5;
    values[4] = 67;
    ffi_poly_sparse_init(&modulus, 5, values);
    free(values);
  } else if(n == 101) {
    values = (uint64_t*) malloc(5 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 1;
    values[2] = 6;
    values[3] = 7;
    values[4] = 101;
    ffi_poly_sparse_init(&modulus, 5, values);
    free(values);
  } else if(n == 131) {
    values = (uint64_t*) malloc(5 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 2;
    values[2] = 3;
    values[3] = 8;
    values[4] = 131;
    ffi_poly_sparse_init(&modulus, 5, values);
    free(values);
  } else if(n == 149) {
    values = (uint64_t*) malloc(5 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 7;
    values[2] = 9;
    values[3] = 10;
    values[4] = 149;
    ffi_poly_sparse_init(&modulus, 5, values);
    free(values);
  } else if(n == 151) {
    values = (uint64_t*) malloc(3 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 3;
    values[2] = 151;
    ffi_poly_sparse_init(&modulus, 3, values);
    free(values);
  } else if(n == 157) {
    values = (uint64_t*) malloc(5 * sizeof(uint64_t));
    values[0] = 0;
    values[1] = 2;
    values[2] = 5;
    values[3] = 6;
    values[4] = 157;
    ffi_poly_sparse_init(&modulus, 5, values);
    free(values);
  }

  return modulus;
}



/**
 * \fn void ffi_qre_init(ffi_qre* e, uint64_t degree)
 * \brief This function allocates the memory for a ffi_qre element
 *
 * \param[out] e Pointer to the allocated ffi_qre
 */
void ffi_qre_init(ffi_qre* e) {
  ffi_poly_init(e, QRE_DEG);
}



/**
 * \fn void ffi_qre_clear(ffi_qre p)
 * \brief This function clears the memory allocated for a ffi_qre element
 *
 * \param e ffi_qre
 */
void ffi_qre_clear(ffi_qre e) {
  ffi_poly_clear(e);
}



/**
 * \fn void ffi_qre_set_zero(ffi_qre o)
 * \brief This functions sets a ffi_qre to zero
 *
 * \param[in] o ffi_qre
 */
void ffi_qre_set_zero(ffi_qre o) {
  ffi_poly_set_zero(o, QRE_DEG);
}



/**
 * \fn void ffi_qre_set_random(ffi_qre p, AES_XOF_struct* ctx)
 * \brief This function sets a ffi_qre with random values using NIST seed expander
 *
 * \param[out] o ffi_qre
 * \param[in] ctx NIST seed expander
 */
void ffi_qre_set_random(ffi_qre o, AES_XOF_struct* ctx) {
  ffi_poly_set_random(o, QRE_DEG, ctx);
}



/**
 * \fn void ffi_qre_set_random2(ffi_qre p, AES_XOF_struct* ctx)
 * \brief This function sets a ffi_qre with random values using NIST PRNG
 *
 * \param[out] o ffi_qre
 */
void ffi_qre_set_random2(ffi_qre o) {
  ffi_poly_set_random2(o, QRE_DEG);
}



/**
 * \fn void ffi_qre_set_random_full_rank(ffi_qre o, AES_XOF_struct* ctx)
 * \brief This function sets a ffi_qre with random values using the NIST seed expander. The returned ffi_qre has full rank
 *
 * \param[out] o ffi_qre
 * \param[in] ctx NIST seed expander
 */
void ffi_qre_set_random_full_rank(ffi_qre o, AES_XOF_struct* ctx) {
  ffi_poly_set_random_full_rank(o, QRE_DEG, ctx);
}



/**
 * \fn void ffi_qre_set_random_full_rank(ffi_qre o, AES_XOF_struct* ctx)
 * \brief This function sets a ffi_qre with random values using the NIST seed expander. The returned ffi_qre has full rank and contains one
 *
 * \param[out] o ffi_qre
 * \param[in] ctx NIST seed expander
 */
void ffi_qre_set_random_full_rank_with_one(ffi_qre o, AES_XOF_struct* ctx) {
  ffi_poly_set_random_full_rank_with_one(o, QRE_DEG, ctx);
}



/**
 * \fn void ffi_qre_set_random_from_support(ffi_qre o, const ffi_vspace support, uint64_t rank, AES_XOF_struct* ctx)
 * \brief This function sets a ffi_qre with random values using the NIST seed expander. In addition, the support of the ffi_qre returned by this function is the one given in input.
 *
 * \param[out] o ffi_qre
 * \param[in] support Support of <b>o</b>
 * \param[in] rank Size of the support
 * \param[in] ctx NIST seed expander
 */
void ffi_qre_set_random_from_support(ffi_qre o, const ffi_vspace support, uint64_t rank, AES_XOF_struct* ctx) {
  ffi_poly_set_random_from_support(o, QRE_DEG, support, rank, ctx);
}


/**
 * \fn void ffi_qre_set_random_from_support2(ffi_qre o, const ffi_vspace support, uint64_t rank)
 * \brief This function sets a ffi_qre with random values using the NIST PRNG. In addition, the support of the ffi_qre returned by this function is the one given in input.
 *
 * \param[out] o ffi_qre
 * \param[in] support Support of <b>o</b>
 * \param[in] rank Size of the support
 */
void ffi_qre_set_random_from_support2(ffi_qre o, const ffi_vspace support, uint64_t rank) {
  ffi_poly_set_random_from_support2(o, QRE_DEG, support, rank);
}


/**
 * \fn uint64_t ffi_qre_is_equal_to(const ffi_qre e1, const ffi_qre e2)
 * \brief This function test if two ffi_qre are equal
 *
 * \param[in] e1 ffi_qre
 * \param[in] e2 ffi_qre
 * \return 1 if the ffi_qre are equal, 0 otherwise
 */
uint64_t ffi_qre_is_equal_to(const ffi_qre e1, const ffi_qre e2) {
  return ffi_poly_is_equal_to(e1, e2);
}



/**
 * \fn void ffi_qre_add(ffi_qre o, const ffi_qre e1, const ffi_qre e2)
 * \brief This function adds two ffi_qre
 *
 * \param[out] o Sum of <b>e1</b> and <b>e2</b>
 * \param[in] p1 ffi_qre
 * \param[in] p2 ffi_qre
 */
void ffi_qre_add(ffi_qre o, const ffi_qre e1, const ffi_qre e2) {
  ffi_poly_add(o, e1, e2);
}



/**
 * \fn void ffi_qre_add(ffi_qre o, const ffi_qre e1, const ffi_qre e2)
 * \brief This function multiplies two ffi_qre
 *
 * \param[out] o Product of <b>e1</b> and <b>e2</b>
 * \param[in] p1 ffi_qre
 * \param[in] p2 ffi_qre
 */
void ffi_qre_mul(ffi_qre o, const ffi_qre e1, const ffi_qre e2) {
  ffi_poly_mulmod_sparse(o, e1, e2, modulus);
}



/**
 * \fn void ffi_qre_div(ffi_qre q, ffi_qre r, const ffi_qre a, const ffi_qre b)
 * \brief This function performs the euclidean division of a by b such that a = b*q + r
 *
 * \param[out] q Quotient
 * \param[out] r Remainder
 * \param[in] a ffi_qre
 * \param[in] b ffi_qre
 */
void ffi_qre_div(ffi_qre q, ffi_qre r, const ffi_qre a, const ffi_qre b) {
  ffi_poly_div(q, r, a, b);
}



/**
 * \fn void ffi_qre_inv(ffi_qre o, const ffi_qre e, const ffi_qre modulus)
 * \brief This function computes the extended euclidean algorithm to compute the inverse of e
 *
 * \param[out] o Inverse of <b>e</b> modulo <b>modulus</b>
 * \param[in] e ffi_qre
 * \param[in] modulus Polynomial
 */
void ffi_qre_inv(ffi_qre o, const ffi_qre e) {
  ffi_poly_inv(o, e, modulusInv);
}



/**
 * \fn void ffi_qre_to_string(unsigned char* str, const ffi_qre p)
 * \brief This function parses a ffi_qre into a string using a non compact representation
 *
 * \param[out] str Output string
 * \param[in] e ffi_qre
 */
void ffi_qre_to_string(unsigned char* str, const ffi_qre e) {
  ffi_poly_to_string(str, e);
}



/**
 * \fn void ffi_qre_from_string(ffi_qre e, const unsigned char* str)
 * \brief This function parses a string into a ffi_qre using a non compact representation
 *
 * \param[out] e ffi_qre
 * \param[in] str String to parse
 */
void ffi_qre_from_string(ffi_qre e, const unsigned char* str) {
  ffi_poly_from_string(e, str);
}



/**
 * \fn void ffi_qre_to_string(unsigned char* str, const ffi_qre p)
 * \brief This function parses a ffi_qre into a string using a compact representation
 *
 * \param[out] str Output string
 * \param[in] e ffi_qre
 */
void ffi_qre_to_string_compact(unsigned char* str, const ffi_qre e) {
  ffi_poly_to_string_compact(str, e);
}



/**
 * \fn void ffi_qre_from_string(ffi_qre e, const unsigned char* str)
 * \brief This function parses a string into a ffi_qre using a compact representation
 *
 * \param[out] e ffi_qre
 * \param[in] str String to parse
 */
void ffi_qre_from_string_compact(ffi_qre e, const unsigned char* str) {
  ffi_poly_from_string_compact(e, str);
}



/**
 * \fn void ffi_qre_print(const ffi_qre p)
 * \brief This function displays a ffi_qre
 *
 * \param[in] e ffi_qre
 */
void ffi_qre_print(ffi_qre e) {
  ffi_poly_print(e);
}

