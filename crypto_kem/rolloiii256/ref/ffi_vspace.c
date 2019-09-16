/**
 * \file ffi_vspace.c
 * \brief Implementation of ffi_vspace.h
 */

#include "ffi.h"
#include "ffi_vspace.h"



/**
 * \fn void ffi_vspace_init(ffi_vspace* v, uint64_t size)
 * \brief This function allocates the memory for an ffi_vspace
 *
 * \param[out] v Pointer to the allocated ffi_vspace
 * \param[in] size Size of the ffi_vspace
 */
void ffi_vspace_init(ffi_vspace* v, uint64_t size) {
  ffi_vec_init(v, size);
}



/**
 * \fn void ffi_vspace_clear(ffi_vspace v, uint64_t size)
 * \brief This functions clears the memory allocated to a ffi_vspace
 *
 * \param[in] v ffi_vspace
 * \param[in] size Size of the ffi_vspace
 */
void ffi_vspace_clear(ffi_vspace v, uint64_t size) {
  ffi_vec_clear(v, size);
}



/**
 * \fn void ffi_vspace_set_zero(ffi_vspace o, uint64_t size)
 * \brief This function sets a ffi_vspace to zero
 *
 * \param[out] v ffi_vspace
 * \param[in] size Size of the ffi_vspace
 */
void ffi_vspace_set_zero(ffi_vspace o, uint64_t size) {
  ffi_vec_set_zero(o, size);
}



/**
 * \fn void ffi_vspace_set(ffi_vspace o, const ffi_vspace v, uint64_t size)
 * \brief This function copies a ffi_vspace to another one
 *
 * \param[out] o Target ffi_vspace
 * \param[in] v Source ffi_vspace
 * \param[in] size Size of the ffi_vspaces
 */
void ffi_vspace_set(ffi_vspace o, const ffi_vspace v, uint64_t size) {
  ffi_vec_set(o, v, size);
}



/** 
 * \fn void ffi_vspace_set_random_full_rank(ffi_vspace o, uint64_t size, AES_XOF_struct* ctx)
 * \brief This function sets a vector space with random values using the NIST seed expander. The returned vector space has full rank
 *
 * \param[out] o ffi_vspace
 * \param[in] size Size of the ffi_vspace
 * \param[in] ctx NIST seed expander
 */
void ffi_vspace_set_random_full_rank(ffi_vspace o, uint64_t size, AES_XOF_struct* ctx) {
  ffi_vec_set_random_full_rank(o, size, ctx);
}



/** 
 * \fn void ffi_vspace_set_random_full_rank2(ffi_vspace o, uint64_t size)
 * \brief This function sets a vector space with random values using the NIST PRNG. The returned vector space has full rank
 *
 * \param[out] o ffi_vspace
 * \param[in] size Size of the ffi_vspace
 */
void ffi_vspace_set_random_full_rank2(ffi_vspace o, uint64_t size) {
  ffi_vec_set_random_full_rank2(o, size);
}



/**
 * \fn void ffi_vspace_set_random_full_rank_with_one(ffi_vspace o, uint64_t size, AES_XOF_struct* ctx) {
 * \brief This function sets a ffi_vspace with random values using the NIST seed expander. In addition, the ffi_vspace returned by this function has full rank and contains one.
 *
 * \param[out] o ffi_vspace
 * \param[in] size Size of ffi_vspace
 * \param[in] ctx NIST seed expander
 */
void ffi_vspace_set_random_full_rank_with_one(ffi_vspace o, uint64_t size, AES_XOF_struct* ctx) {
  ffi_vec_set_random_full_rank_with_one(o, size, ctx);
}



/**
 * \fn void ffi_vspace_directsum(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size)
 * \brief This function computes the direct sum of two vector spaces
 *
 * \param[out] o Direct sum of a and b
 * \param[in] a ffi_vspace
 * \param[in] b ffi_vspace
 * \param[in] a_size Size of a
 * \param[in] b_size Size of b
 */
void ffi_vspace_directsum(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size) {
  for(int i = 0; i < a_size; i++) {
    ffi_elt_set(o[i], a[i]);
  }

  for(int i = 0; i < b_size; i++) {
    ffi_elt_set(o[i + a_size], b[i]);
  }
}



/**
 * \fn void ffi_vspace_product(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size)
 * \brief This function computes the product vector space of a and b
 *
 * \param[out] o Product vector space
 * \param[in] a ffi_vspace
 * \param[in] b ffi_vspace
 * \param[in] a_size Size of a
 * \param[in] b_size Size of b
 */
void ffi_vspace_product(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size) {
  for(int i = 0 ; i < a_size ; i++) {
    for(int j = 0 ; j < b_size ; j++) {
      ffi_elt_mul(o[i * b_size + j], a[i], b[j]);
    }
  }
}



/**
 * \fn uint64_t ffi_vspace_intersection(ffi_vspace* o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size)
 * \brief This function computes the intersection of a and b
 *
 * \param[out] o Intersection of a and b
 * \param[in] a ffi_vspace
 * \param[in] b ffi_vspace
 * \param[in] a_size Size of a
 * \param[in] b_size Size of b
 *
 * \return Dimension of o
 */
uint64_t ffi_vspace_intersection(ffi_vspace o, const ffi_vspace a, const ffi_vspace b, uint64_t a_size, uint64_t b_size) {
  if(a_size == 0 || b_size == 0) {
    return 0;
  }

  int degree, pivot;
  ffi_vspace direct_sum;
  ffi_vspace result;
  ffi_vspace_init(&direct_sum, a_size + b_size);
  ffi_vspace_init(&result, a_size + b_size);

  // Initialization
  ffi_vspace_directsum(direct_sum, a, b, a_size, b_size);
  ffi_vspace_set(result, a, a_size); 

  int targetDeg, currentDeg;
  targetDeg = FIELD_M;

  // Perform Gauss on directsum, replicating computations on result
  for(int i = 0 ; i < a_size + b_size ; ++i) {
    // Pivot computation
    pivot = i;
    currentDeg = ffi_elt_get_degree(direct_sum[pivot]);
    for(int j = pivot+1 ; j < a_size + b_size ; ++j) {
      if(currentDeg == targetDeg) break;
      int jDeg = ffi_elt_get_degree(direct_sum[j]);
      if(jDeg > currentDeg) {
        pivot = j;
        currentDeg = jDeg;
      }
    }

    // End the process if all remaining elements are null
    if(currentDeg == -1) {
      break;
    }

    targetDeg = currentDeg - 1;

    // Swap rows
    ffi_elt tmp;
    ffi_elt_set(tmp, direct_sum[i]);
    ffi_elt_set(direct_sum[i], direct_sum[pivot]);
    ffi_elt_set(direct_sum[pivot], tmp);

    ffi_elt_set(tmp, result[i]);
    ffi_elt_set(result[i], result[pivot]);
    ffi_elt_set(result[pivot], tmp);

    degree = ffi_elt_get_degree(direct_sum[i]);

    // Update other elements
    for(int j = i+1 ; j < a_size + b_size ; ++j) {
      if(!(ffi_elt_is_zero(direct_sum[j]) || ffi_elt_get_degree(direct_sum[j]) < degree)) {
        ffi_elt_add(direct_sum[j], direct_sum[j], direct_sum[i]);
        ffi_elt_add(result[j], result[j], result[i]);
      }
    }
  }

  // Find the intersection
  unsigned int index = -1;
  for(int i = 0 ; i < a_size + b_size ; ++i) {
    if(ffi_elt_is_zero(direct_sum[i])) {
      index = i;
      break;
    }
  }

  // No intersection
  if(index == -1) {
    ffi_vspace_clear(direct_sum, a_size + b_size);
    ffi_vspace_clear(result, a_size + b_size);
    return 0;
  }

  int inter_dim = a_size + b_size - index;
  for(int i = 0 ; i < inter_dim ; i++) {
    ffi_elt_set(o[i], result[index+i]);
  }

  ffi_vspace_clear(direct_sum, a_size + b_size);
  ffi_vspace_clear(result, a_size + b_size);

  return inter_dim;
}



/**
 * \fn void ffi_vspace_print(const ffi_vspace v, uint64_t size)
 * \brief This function displays a ffi_vspace
 *
 * \param[in] v ffi_vspace
 * \param[in] size Size of the ffi_vspace
 */
void ffi_vspace_print(const ffi_vspace v, uint64_t size) {
  ffi_vec_print(v, size);
}

