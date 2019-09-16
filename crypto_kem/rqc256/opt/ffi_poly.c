/**
 * \file ffi_poly.c
 * \brief Implementation of ffi_poly.h
 */

#include "ffi.h"
#include "ffi_vec.h"
#include "ffi_poly.h"


/**
 * \fn void ffi_poly_init(ffi_poly* p, uint64_t degree)
 * \brief This function allocates the memory for a ffi_poly element
 *
 * \param[out] p Pointer to the allocated ffi_poly
 * \param[in] size Size of the polynomial
 */
void ffi_poly_init(ffi_poly* p, uint64_t degree) {
  *p = malloc(sizeof(ffi_poly_struct));
  ffi_vec_init(&((*p)->v), degree+1);
  (*p)->size = degree+1;
  (*p)->degree = degree;
}



/**
 * \fn void ffi_poly_resize(ffi_poly p, uint64_t degree)
 * \brief This function changes the allocated size of a ffi_poly
 *
 * \param p Polynomial
 * \param[in] size New allocated size for <b>p</b>
 */
void ffi_poly_resize(ffi_poly p, uint64_t size) {
  ffi_vec tmp;
  ffi_vec_init(&tmp, size+1);
  ffi_vec_set(tmp, p->v, min(p->degree+1, size+1));
  ffi_vec_clear(p->v, p->size);
  p->size = size + 1;
  p->v = tmp;
}



/**
 * \fn void ffi_poly_clear(ffi_poly p)
 * \brief This function clears the memory allocated for a ffi_poly element
 *
 * \param p Polynomial
 */
void ffi_poly_clear(ffi_poly p) {
  ffi_vec_clear(p->v, p->size);
  free(p);
  p = NULL;
}



/**
 * \fn void ffi_poly_sparse_init(ffi_poly_sparse* p, uint64_t coeff_nb, uint64_t *coeffs)
 * \brief This function allocates the memory for a ffi_poly_sparse element
 *
 * \param p Pointer to the allocated ffi_poly_sparse
 * \param[in] coeff_nb Number of coefficients
 * \param[in] coeffs Coefficients
 */
void ffi_poly_sparse_init(ffi_poly_sparse* p, uint64_t coeff_nb, uint64_t *coeffs) {
  *p = malloc(sizeof(ffi_poly_sparse_struct));
  (*p)->coeffs_nb = coeff_nb;
  (*p)->coeffs = malloc(coeff_nb * sizeof(uint64_t));
  memcpy((*p)->coeffs, coeffs, coeff_nb * sizeof(uint64_t));
}



/**
 * \fn void ffi_poly_sparse_clear(ffi_poly_sparse p)
 * \brief This function clears the memory allocated for a ffi_poly_sparse element
 *
 * \param p Polynomial
 */
void ffi_poly_sparse_clear(ffi_poly_sparse p) {
  free(p->coeffs);
  free(p);
}



/**
 * \fn void ffi_poly_set_zero(ffi_poly o, uint64_t degree)
 * \brief This functions sets a polynomial to zero
 *
 * \param[in] p Polynomial
 * \param[in] degree Degree of the polynomial
 */
void ffi_poly_set_zero(ffi_poly o, uint64_t degree) {
  if(o->size < degree + 1) {
    ffi_poly_resize(o, degree);
  }

  o->degree = degree;
  ffi_vec_set_zero(o->v, o->degree+1);
}



/**
 * \fn void ffi_poly_set(ffi_poly o, const ffi_poly p)
 * \brief This function copies a polynomial into another one
 *
 * \param[in] o Polynomial
 * \param[in] p Polynomial
 */
void ffi_poly_set(ffi_poly o, const ffi_poly p) {
  if(o->size < p->degree + 1) {
    ffi_poly_resize(o, p->degree);
  }

  o->degree = p->degree;
  ffi_vec_set(o->v, p->v, p->degree+1);
}



/**
 * \fn void ffi_poly_set_random(ffi_poly p, uint64_t deg, AES_XOF_struct* ctx)
 * \brief This function sets a polynomial with random values using NIST seed expander
 *
 * \param[out] p Polynomial
 * \param[in] degree Degree of the polynomial
 * \param[in] ctx NIST seed expander
 */
void ffi_poly_set_random(ffi_poly p, uint64_t degree, AES_XOF_struct* ctx) {
  if(p->size < degree + 1) {
    ffi_poly_resize(p, degree);
  }

  p->degree = degree;
  ffi_vec_set_random(p->v, p->degree+1, ctx);
}



/**
 * \fn void ffi_poly_set_random2(ffi_poly p, uint64_t deg)
 * \brief This function sets a polynomial with random values using NIST PRNG
 *
 * \param[out] p Polynomial
 * \param[in] degree Degree of the polynomial
 */
void ffi_poly_set_random2(ffi_poly p, uint64_t degree) {
  if(p->size < degree + 1) {
    ffi_poly_resize(p, degree);
  }

  p->degree = degree;
  ffi_vec_set_random2(p->v, p->degree+1);
}



/**
 * \fn void ffi_poly_set_random_full_rank(ffi_poly o, uint64_t size, AES_XOF_struct* ctx)
 * \brief This function sets a polynomial with random values using the NIST seed expander. The returned polynomial has full rank
 *
 * \param[out] o Polynomial
 * \param[in] degree Degree of the polynomial
 * \param[in] ctx NIST seed expander
 */
void ffi_poly_set_random_full_rank(ffi_poly o, uint64_t degree, AES_XOF_struct* ctx) {
  if(o->size < degree + 1) {
    ffi_poly_resize(o, degree);
  }

  o->degree = degree;
  ffi_vec_set_random_full_rank(o->v, o->degree+1, ctx);
}



/**
 * \fn void ffi_poly_set_random_full_rank_with_one(ffi_poly o, uint64_t degree, AES_XOF_struct* ctx) {
 * \brief This function sets a polynomial with random values using the NIST seed expander. In addition, the polynomial returned by this function has full rank and contains one
 *
 * \param[out] o Polynomial
 * \param[in] size Degree of the polynomial
 * \param[in] ctx NIST seed expander
 */
void ffi_poly_set_random_full_rank_with_one(ffi_poly o, uint64_t degree, AES_XOF_struct* ctx) {
  if(o->size < degree + 1) {
    ffi_poly_resize(o, degree);
  }

  o->degree = degree;
  ffi_vec_set_random_full_rank_with_one(o->v, o->degree+1, ctx);
}



/**
 * \fn void ffi_poly_set_random_from_support(ffi_poly o, uint64_t degree, const ffi_vspace support, uint64_t rank, AES_XOF_struct* ctx)
 * \brief This function sets a polynomial with random values using the NIST seed expander. In addition, the support of the polynomial returned by this function is the one given in input.
 *
 * \param[out] o Polynomial
 * \param[in] degree Degree of <b>o</b>
 * \param[in] support Support of <b>o</b>
 * \param[in] rank Size of the support
 * \param[in] ctx NIST seed expander
 */
void ffi_poly_set_random_from_support(ffi_poly o, uint64_t degree, const ffi_vspace support, uint64_t rank, AES_XOF_struct* ctx) {
  if(o->size < degree + 1) {
    ffi_poly_resize(o, degree);
  }

  o->degree = degree;
  ffi_vec_set_random_from_support(o->v, o->degree+1, support, rank, ctx);
}



/**
 * \fn void ffi_poly_set_random_from_support2(ffi_poly o, uint64_t degree, const ffi_vspace support, uint64_t rank)
 * \brief This function sets a polynomial with random values using the NIST PRNG. In addition, the support of the polynomial returned by this function is the one given in input.
 *
 * \param[out] o Polynomial
 * \param[in] degree Degree of <b>o</b>
 * \param[in] support Support of <b>o</b>
 * \param[in] rank Size of the support
 */
void ffi_poly_set_random_from_support2(ffi_poly o, uint64_t degree, const ffi_vspace support, uint64_t rank) {
  if(o->size < degree + 1) {
    ffi_poly_resize(o, degree);
  }

  o->degree = degree;
  ffi_vec_set_random_from_support2(o->v, o->degree+1, support, rank);
}


/**
 * \fn void ffi_poly_update_degree(ffi_poly p, uint64_t max_degree) {
 * \brief This function updates the degree of a polynomial starting from a give position
 *
 * \param[in] p Polynomial
 * \param[in] max_degree Maximum degree of the polynomial
 *
 */
void ffi_poly_update_degree(ffi_poly p, uint64_t max_degree) {
  for(int i = max_degree ; i >= 0 ; --i) {
    if(!ffi_elt_is_zero(p->v[i])) {
      p->degree = i;
      return;
    }
  }

  p->degree = -1;
}



/**
 * \fn uint64_t ffi_poly_is_equal_to(const ffi_poly p1, const ffi_poly p2)
 * \brief This function test if two polynomials are equal
 *
 * \param[in] p1 Polynomial
 * \param[in] p2 Polynomial
 * \return 1 if the polynomials are equal, 0 otherwise
 */
uint64_t ffi_poly_is_equal_to(const ffi_poly p1, const ffi_poly p2) {
  if(p1->degree != p2->degree) {
    return 0;
  }

  for(int i = 0 ; i < p1->degree ; ++i) {
    if(ffi_elt_is_equal_to(p1->v[i], p2->v[i]) == 0) {
      return 0;
    }
  }

  return 1;
}



/**
 * \fn void ffi_poly_add(ffi_poly o, const ffi_poly p1, const ffi_poly p2)
 * \brief This function adds two polynomials
 *
 * \param[out] o Sum of <b>p1</b> and <b>p2</b>
 * \param[in] p1 Polynomial
 * \param[in] p2 Polynomial
 */
void ffi_poly_add(ffi_poly o, const ffi_poly p1, const ffi_poly p2) {
  int max_degree = max(p1->degree, p2->degree);
  int min_degree = min(p1->degree, p2->degree);

  if(o->size < max_degree+1) {
    ffi_poly_resize(o, max_degree+1);
  }

  ffi_vec_add(o->v, p1->v, p2->v, min_degree+1);

  if(p1->degree > p2->degree) {
    for(int j = min_degree+1 ; j <= max_degree ; ++j) {
      ffi_elt_set(o->v[j], p1->v[j]);
    }
  }
  else {
    for(int j = min_degree+1 ; j <= max_degree ; ++j) {
      ffi_elt_set(o->v[j], p2->v[j]);
    }
  }

  ffi_poly_update_degree(o, max_degree);
}



/**
 * \fn void plain_mul(ffi_poly o, const ffi_poly p1, const ffi_poly p2)
 * \brief This function multiplies two polynomials
 *
 * This function is based on NTL multiplication of GF2EX elements
 *
 * \param[out] o Polynomial
 * \param[in] a Polynomial
 * \param[in] b Polynomial
 */
void plain_mul(ffi_poly o, const ffi_poly a, const ffi_poly b) {
  uint64_t d = a->degree + b->degree;
  if(o->size < d+1) {
    ffi_poly_resize(o, d+1);
  }

  ffi_elt acc, tmp;
  for(int i = 0 ; i <= d; ++i) {
    int jmin, jmax;
    jmin = max(0, i - b->degree);
    jmax = min(a->degree, i);

    ffi_elt_set_zero(acc);

    for(int j = jmin ; j <= jmax ; ++j) {
      ffi_elt_mul(tmp, a->v[j], b->v[i-j]);
      ffi_elt_add(acc, acc, tmp);
    }

    ffi_elt_set(o->v[i], acc);
  }

  ffi_poly_update_degree(o, d);
}



/**
 * Karatsuba multiplication of a and b using notations from
 * "A course in computational algebraic number theory" (H. Cohen), 3.1.2
 * Implementation inspired from the NTL library
 *
 * \param[out] o Polynomial
 * \param[in] a Polynomial
 * \param[in] b Polynomial
 */
void kar_fold(ffi_vec res, ffi_vec src, int max, int half_size) {
  for(int i = 0 ; i < max/2 ; ++i) {
    ffi_elt_add(res[i], src[i], src[i+half_size]);
  }

  if(max % 2 == 1) {
    ffi_elt_set(res[half_size-1], src[half_size-1]);
  }
}

void kar_mul(ffi_vec o, ffi_vec a, ffi_vec b, int a_size, int b_size, ffi_vec stack) {

  // In every call a_size must be >= b_size
  if(a_size == 1) {
    ffi_elt_mul(o[0], a[0], b[0]);
    return;
  }

  if(a_size == 2) {
    if(b_size == 2) {
      // Hardcoded mul
      ffi_elt ea2, eb2, ed;
      ffi_elt_mul(o[0], a[0], b[0]);
      ffi_elt_mul(o[2], a[1], b[1]);
      ffi_elt_add(ea2, a[0], a[1]);
      ffi_elt_add(eb2, b[0], b[1]);
      ffi_elt_mul(ed, ea2, eb2);
      ffi_elt_add(o[1], o[0], o[2]);
      ffi_elt_add(o[1], o[1], ed);
      return;
    } else { // b_size = 1
      ffi_elt_mul(o[0], a[0], b[0]);
      ffi_elt_mul(o[1], a[1], b[0]);
    }
  }

  int ha_size = (a_size + 1)/2;

  // Compute a2 = a0 + a1 and b2 = b0 + b1
  ffi_vec a2, b2;
  a2 = stack;
  b2 = stack + ha_size;

  kar_fold(a2, a, a_size, ha_size);
  kar_fold(b2, b, b_size, ha_size);

  // Computation of d = a2*b2
  
  // Reset the stack
  for(int i = 2*ha_size ; i < 4*ha_size ; ++i) {
    ffi_elt_set_zero(stack[i]);
  }

  kar_mul(stack + 2*ha_size, a2, b2, ha_size, ha_size, stack + 4*ha_size);

  for(int i = 0 ; i < 2*(a_size-ha_size-1)+1+2*ha_size ; ++i) {
    ffi_elt_set_zero(o[i]);
  }

  // Computation of c0 = a0*b0 in the low part of o
  kar_mul(o, a, b, ha_size, ha_size, stack + 4*ha_size);

  // Computation of c2 = a1*b1 in the high part of o
  kar_mul(o+2*ha_size, a+ha_size, b+ha_size, a_size-ha_size, b_size-ha_size, stack + 4*ha_size);

  // Computation of c1 = d + c2 + c0
  for(int i = 0 ; i < 2*(a_size-ha_size-1)+1 ; ++i) {
    ffi_elt_add(stack[i+2*ha_size], stack[i+2*ha_size], (o+2*ha_size)[i]);
  }

  for(int i = 0 ; i < 2*(ha_size-1)+1 ; ++i) {
    ffi_elt_add(stack[i+2*ha_size], stack[i+2*ha_size], o[i]);
  }

  // Add c1 to o
  for(int i = 0 ; i <= 2*(ha_size-1)+1 ; i++) {
    ffi_elt_add(o[i+ha_size], o[i+ha_size], stack[i+2*ha_size]);
  }
}



/**
 * \fn void ffi_poly_mul(ffi_poly o, const ffi_poly p1, const ffi_poly p2)
 * \brief This function multiplies two polynomials
 *
 * \param[in] o Product of <b>p1</b> and <b>p2</b>
 * \param[in] p1 Polynomial
 * \param[in] p2 Polynomial
 */
void ffi_poly_mul(ffi_poly o, const ffi_poly a, const ffi_poly b) {
  if(a->degree == -1 || b->degree == -1) {
    o->degree = -1;
    return;
  }

  if(a->degree <= 1 || b->degree <= 1) {
    plain_mul(o, a, b);
    return;
  }

  // Prepare polynomials such that the allocated space is big enough in every polynomial
  int max_degree = max(a->degree, b->degree);
  if(a->size < max_degree+1) ffi_poly_resize(a, max_degree+1);
  if(b->size < max_degree+1) ffi_poly_resize(b, max_degree+1);
  if(o->size < 2*(max_degree+1)) ffi_poly_resize(o, 2*(max_degree+1));

  int stack_size = 0;
  int n = max_degree;
  do {
    stack_size += 4*((n+2) >> 1);
    n >>= 1;
  } while(n > 1);

  ffi_vec stack;
  ffi_vec_init(&stack, stack_size);

  kar_mul(o->v, a->v, b->v, max_degree+1, max_degree+1, stack);
  ffi_poly_update_degree(o, a->degree + b->degree);

  ffi_vec_clear(stack, stack_size);
}



/**
 * \fn void ffi_poly_mulmod(ffi_poly o, const ffi_poly p1, const ffi_poly p2, const ffi_poly modulus)
 * \brief This function computes the product of two polynomials modulo a third one
 *
 * \param[out] o Product of <b>p1</b> and <b>p2</b> modulo <b>modulus</b>
 * \param[in] p1 Polynomial
 * \param[in] p2 Polynomial
 * \param[in] modulus Polynomial
 */
void ffi_poly_mulmod(ffi_poly o, const ffi_poly a, const ffi_poly b, const ffi_poly modulus) {
  if(o->size < modulus->degree) {
    ffi_poly_resize(o, modulus->degree);
  }

  ffi_poly unreduced;
  ffi_poly_init(&unreduced, 2*modulus->degree-1);
  ffi_poly_mul(unreduced, a, b);

  ffi_poly q, r;
  ffi_poly_init(&q, 2*modulus->degree-1);
  ffi_poly_init(&r, 2*modulus->degree-1);

  ffi_poly_div(q, r, unreduced, modulus);
  ffi_poly_set(o, r);

  ffi_poly_clear(q);
  ffi_poly_clear(r);
  ffi_poly_clear(unreduced);
}



/**
 * \fn void ffi_poly_mulmod_sparse(ffi_poly o, const ffi_poly p1, const ffi_poly p2, const ffi_poly_sparse modulus)
 * \brief This function computes the product of two polynomials modulo a sparse one
 *
 * \param[out] o Product of <b>p1</b> and <b>p2</b> modulo <b>modulus</b>
 * \param[in] p1 Polynomial
 * \param[in] p2 Polynomial
 * \param[in] modulus Sparse polynomial
 */
void ffi_poly_mulmod_sparse(ffi_poly o, const ffi_poly p1, const ffi_poly p2, const ffi_poly_sparse modulus) {
  int modulus_degree = modulus->coeffs[modulus->coeffs_nb-1];
  if(o->size < modulus_degree) {
    ffi_poly_resize(o, modulus_degree);
  }

  ffi_poly unreduced;
  ffi_poly_init(&unreduced, 2*modulus_degree-1);
  ffi_poly_set_zero(unreduced, 2*modulus_degree-1);

  ffi_poly_mul(unreduced, p1, p2);

  // Modular reduction
  for(int i = unreduced->degree - modulus_degree ; i >= 0 ; i--) {
    for(int j = 0 ; j < modulus->coeffs_nb-1 ; j++) {
      ffi_elt_add(unreduced->v[i+modulus->coeffs[j]],
      unreduced->v[i+modulus->coeffs[j]], unreduced->v[i+modulus_degree]);
    }
    ffi_elt_set_zero(unreduced->v[i+modulus_degree]);
  }

  ffi_poly_update_degree(unreduced, modulus_degree);
  ffi_poly_set(o, unreduced);
  ffi_poly_clear(unreduced);
}



/**
 * \fn void ffi_poly_div(ffi_poly q, ffi_poly r, const ffi_poly a, const ffi_poly b)
 * \brief This function performs the euclidean division of a by b such that a = b*q + r
 *
 * \param[out] q Quotient
 * \param[out] r Remainder
 * \param[in] a Polynomial
 * \param[in] b Polynomial
 */
void ffi_poly_div(ffi_poly q, ffi_poly r, const ffi_poly a, const ffi_poly b) {
  if(q->size < a->degree+1) {
    ffi_poly_resize(q, a->degree+1);
  }

  if(r->size < a->degree+1) {
    ffi_poly_resize(r, a->degree+1);
  }

  // Initialization
  ffi_poly_set(r, a);
  ffi_poly_set_zero(q, a->degree);

  ffi_elt coeff, b_inv, tmp;
  ffi_elt_inv(b_inv, b->v[b->degree]);
  while(r->degree >= b->degree) {
    ffi_elt_mul(coeff, r->v[r->degree], b_inv);

    // Update quotient
    ffi_elt_set(q->v[r->degree - b->degree], coeff);

    // Update remainder
    for(int i = r->degree; i >= r->degree - b->degree; --i) {
      ffi_elt_mul(tmp, coeff, b->v[i - r->degree + b->degree]);
      ffi_elt_add(r->v[i], r->v[i], tmp);
    }

    // Update remainder degree
    ffi_poly_update_degree(r, a->degree);
  }

  // Updates degrees
  ffi_poly_update_degree(r, a->degree);
  ffi_poly_update_degree(q, a->degree);
}



/**
 * \fn void ffi_poly_inv(ffi_poly o, const ffi_poly a, const ffi_poly modulus)
 * \brief This function computes the extended euclidean algorithm to compute u and v such that a.u + mod.v = GCD(a, mod)
 *
 * \param[out] o Inverse of <b>a</b> modulo <b>modulus</b>
 * \param[in] a Polynomial
 * \param[in] modulus Polynomial
 */
 void ffi_poly_inv(ffi_poly o, const ffi_poly a, const ffi_poly modulus) {
  unsigned int max_size = max(a->degree, modulus->degree);

  if(a->degree == -1 || modulus->degree == -1) {
    o->degree = -1;
    return;
  }

  ffi_poly q, tmp, u, v, u0, u1, u2, qu;
  ffi_poly_init(&q, max_size);
  ffi_poly_init(&tmp, max_size);
  ffi_poly_init(&u, max_size);
  ffi_poly_init(&v, max_size);
  ffi_poly_init(&u0, max_size);
  ffi_poly_init(&u1, max_size);
  ffi_poly_init(&u2, max_size);
  ffi_poly_init(&qu, 2*max_size-1);

  ffi_poly_set_zero(q, max_size);
  ffi_poly_set_zero(tmp, max_size);
  ffi_poly_set_zero(u, max_size);
  ffi_poly_set_zero(v, max_size);
  ffi_poly_set_zero(u0, max_size);
  ffi_poly_set_zero(u1, max_size);
  ffi_poly_set_zero(u2, max_size);
  ffi_poly_set_zero(qu, 2*max_size-1);

  // Initialization
  ffi_poly_set(u, a);
  ffi_poly_set(v, modulus);

  ffi_elt_set_one(u1->v[0]);
  ffi_poly_update_degree(u1, 1);

  while(v->degree != -1) {
    ffi_poly_div(q, tmp, u, v);
    ffi_poly_set(u, v);
    ffi_poly_set(v, tmp);
    ffi_poly_set(u0, u2);
    ffi_poly_mul(qu, q, u2);
    ffi_poly_add(u2, u1, qu);
    ffi_poly_set(u1, u0);
  }

  ffi_poly_set(o, u1);

  // Make the GCD monic
  ffi_elt scalar;
  ffi_elt_inv(scalar, u->v[u->degree]);
  ffi_vec_scalar_mul(o->v, o->v, scalar, o->degree+1);

  ffi_poly_clear(q);
  ffi_poly_clear(tmp);
  ffi_poly_clear(u);
  ffi_poly_clear(v);
  ffi_poly_clear(u0);
  ffi_poly_clear(u1);
  ffi_poly_clear(u2);
  ffi_poly_clear(qu);
 }



/**
 * \fn void ffi_poly_to_string(unsigned char* str, const ffi_poly p)
 * \brief This function parses a polynomial into a string using a non compact representation
 *
 * \param[out] str Output string
 * \param[in] p Polynomial
 */
void ffi_poly_to_string(unsigned char* str, const ffi_poly p) {
  ffi_vec_to_string(str, p->v, p->degree + 1);
}



/**
 * \fn void ffi_poly_from_string(ffi_poly p, const unsigned char* str)
 * \brief This function parses a string into a polynomial using a non compact representation
 *
 * \param[out] p Polynomial
 * \param[in] str String to parse
 */
void ffi_poly_from_string(ffi_poly p, const unsigned char* str) {
  ffi_vec_from_string(p->v, p->degree + 1, str);
}



/**
 * \fn void ffi_poly_to_string_compact(unsigned char* str, const ffi_poly p)
 * \brief This function parses a polynomial into a string using a compact representation
 *
 * \param[out] str Output string
 * \param[in] p Polynomial
 */
void ffi_poly_to_string_compact(unsigned char* str, const ffi_poly p) {
  ffi_vec_to_string_compact(str, p->v, p->degree + 1);
}



/**
 * \fn void ffi_poly_from_string_compact(ffi_poly p, const unsigned char* str)
 * \brief This function parses a string into a polynomial using a compact representation
 *
 * \param[out] p Polynomial
 * \param[in] str String to parse
 */
void ffi_poly_from_string_compact(ffi_poly p, const unsigned char* str) {
  ffi_vec_from_string_compact(p->v, p->degree + 1, str);
}



/**
 * \fn void ffi_poly_print(const ffi_poly p)
 * \brief This function displays a polynomial
 *
 * \param[in] p Polynomial
 */
void ffi_poly_print(const ffi_poly p) {
  for(int i = 0 ; i < p->degree + 1 ; ++i) {
    printf("\n%i - ", i);
    ffi_elt_print(p->v[i]);
  }
}



/**
 * \fn void ffi_poly_sparse_print(ffi_poly_sparse p)
 * \brief This function displays a sparse polynomial
 *
 * \param[in] p Polynomial
 */
void ffi_poly_sparse_print(ffi_poly_sparse p) {
  for(int i = 0 ; i < p->coeffs_nb-1 ; i++) {
    printf("X^%lu + ", p->coeffs[i]);
  }
  printf("X^%lu\n", p->coeffs[p->coeffs_nb-1]);
}

