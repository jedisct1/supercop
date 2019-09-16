/**
 * \file ffi_vec.c
 * \brief Implementation of ffi_vec.h
 */

#include "ffi_vec.h"


/********************
* ffi_vec functions *
********************/

/**
 * \fn void ffi_vec_init(ffi_vec* v, uint64_t size)
 * \brief This function initiates a ffi_vec element
 *
 * \param[out] v Pointer to a ffi_vec element
 * \param[in] size Size of the vector
 */
void ffi_vec_init(ffi_vec* v, uint64_t size) {
  *v = calloc(size, sizeof(ffi_elt));
  if(v == NULL) {
    printf("ffi_vec_init: NULL pointer");
    exit(EXIT_FAILURE);
  }
}



/**
 * \fn void ffi_vec_clear(ffi_vec v, uint64_t size)
 * \brief This function clears a ffi_vec element
 *
 * \param[out] v Vector of finite field elements
 * \param[in] size Size of the vector
 */
void ffi_vec_clear(ffi_vec v, uint64_t size) {
  free(v);
}



/**
 * \fn void ffi_vec_set_zero(ffi_vec v, uint64_t size)
 * \brief This function sets a vector of finite elements to zero
 *
 * \param[out] v Vector of finite field elements
 * \param[in] size Size of the vector
 */
void ffi_vec_set_zero(ffi_vec v, uint64_t size) {
  for(int i = 0 ; i < size ; ++i) {
    ffi_elt_set_zero(v[i]);
  }
}



/**
 * \fn void ffi_vec_set(ffi_vec o, const ffi_vec v, uint64_t size)
 * \brief This function copies a vector of finite field elements to another one
 *
 * \param[out] o Vector of finite field elements
 * \param[in] v Vector of finite field elements
 * \param[in] size Size of the vectors
 */
void ffi_vec_set(ffi_vec o, const ffi_vec v, uint64_t size) {
  for(int i = 0 ; i < size ; ++i) {
    ffi_elt_set(o[i], v[i]);
  }
}



/**
 * \fn void ffi_vec_set_random(ffi_vec v, uint64_t size AES_XOF_struct* ctx)
 * \brief This function sets a vector of finite field elements with random values using NIST seed expander
 *
 * \param[out] v Vector of finite field elements
 * \param[in] size Size of the vector
 * \param[in] ctx NIST seed expander
 */
void ffi_vec_set_random(ffi_vec v, uint64_t size, AES_XOF_struct* ctx) {
  int bytes = (FIELD_M % 8 == 0) ? FIELD_M / 8 : FIELD_M / 8 + 1;
  unsigned char mask = (1 << FIELD_M % 8) - 1;

  ffi_vec_set_zero(v, size);

  unsigned char random[size * bytes];
  seedexpander(ctx, random, size * bytes);

  for(int i = 0 ; i < size ; ++i) {
    random[(i+1) * bytes - 1] &= mask;
    memcpy(v[i], random + i * bytes, bytes);
  }
}



/**
 * \fn void ffi_vec_set_random2(ffi_vec v, uint64_t size)
 * \brief This function sets a vector of finite field elements with random values using NIST PRNG
 *
 * \param[out] v Vector of finite field elements
 * \param[in] size Size of the vector
 */
void ffi_vec_set_random2(ffi_vec v, uint64_t size) {
  int bytes = (FIELD_M % 8 == 0) ? FIELD_M / 8 : FIELD_M / 8 + 1;
  unsigned char mask = (1 << FIELD_M % 8) - 1;

  ffi_vec_set_zero(v, size);

  unsigned char random[size * bytes];
  randombytes(random, size * bytes);

  for(int i = 0 ; i < size ; ++i) {
    random[(i+1) * bytes - 1] &= mask;
    memcpy(v[i], random + i * bytes, bytes);
  }
}



/**
 * \fn void ffi_vec_set_random_full_rank(ffi_vec o, uint64_t size, AES_XOF_struct* ctx)
 * \brief This function sets a vector with random values using the NIST seed expander. The returned vector has full rank
 *
 * \param[out] o Vector
 * \param[in] size Size of the vector
 * \param[in] ctx NIST seed expander
 */
void ffi_vec_set_random_full_rank(ffi_vec o, uint64_t size, AES_XOF_struct* ctx) {
  unsigned int rank_max = FIELD_M < size ? FIELD_M : size;

  unsigned int rank = -1;
  while(rank != rank_max) {
    ffi_vec_set_random(o, size, ctx);
    rank = ffi_vec_get_rank(o, size);
  }
}



/**
 * \fn void ffi_vec_set_random_full_rank2(ffi_vec o, uint64_t size)
 * \brief This function sets a vector with random values using the NIST PRNG. The returned vector has full rank
 *
 * \param[out] o Vector
 * \param[in] size Size of the vector
 * \param[in] ctx NIST seed expander
 */
void ffi_vec_set_random_full_rank2(ffi_vec o, uint64_t size) {
  unsigned int rank_max = FIELD_M < size ? FIELD_M : size;

  unsigned int rank = -1;
  while(rank != rank_max) {
    ffi_vec_set_random2(o, size);
    rank = ffi_vec_get_rank(o, size);
  }
}



/**
 * \fn void ffi_vec_set_random_full_rank_with_one(ffi_vec o, uint64_t size, AES_XOF_struct* ctx) {
 * \brief This function sets a vector with random values using the NIST seed expander. In addition, the vector returned by this function has full rank and contains one.
 *
 * \param[out] o Vector
 * \param[in] size Size of the vector
 * \param[in] ctx NIST seed expander
 */
void ffi_vec_set_random_full_rank_with_one(ffi_vec o, uint64_t size, AES_XOF_struct* ctx) {
  unsigned int rank_max = FIELD_M < size ? FIELD_M : size;

  unsigned int rank = -1;
  while(rank != rank_max) {
    ffi_vec_set_random(o, size-1, ctx);
    ffi_elt_set_one(o[size-1]);
    rank = ffi_vec_get_rank(o, size);
  }
}



/**
 * \fn void ffi_vec_set_random_from_support(ffi_vec o, uint64_t size, const ffi_vec support, uint64_t rank, AES_XOF_struct* ctx)
 * \brief This function sets a vector with random values using the NIST seed expander. In addition, the support of the vector returned by this function is the one given in input.
 *
 * This function copies the support vector in rank random positions of <b>o</b>. Next, all the remaining coordinates of <b>v</b> are set using random linear combinations of the support coordinates. This does not exactly correspond to uniform sampling in the considered distribution (performance tradeoff) but can be made easily if required.
 *
 * \param[out] o Vector
 * \param[in] size Size of <b>o</b>
 * \param[in] support Support of <b>v</b>
 * \param[in] rank Size of the support
 * \param[in] ctx NIST seed expander
 */
void ffi_vec_set_random_from_support(ffi_vec o, uint64_t size, const ffi_vec support, uint64_t rank, AES_XOF_struct* ctx) {

  // Copy the support vector in rank random positions of o
  unsigned int random1_size = 2 * rank;
  unsigned char random1[random1_size];
  seedexpander(ctx, random1, random1_size);

  unsigned int i = 0;
  unsigned int j = 0;
  unsigned int position;
  while(i != rank) {
    position = random1[j];

    // Check that the position is not already taken
    if(position < size * (256 / size) && ffi_elt_is_zero(o[position % size])) {
      ffi_elt_set(o[position % size], support[i]);
      i++;
    }

    // Get more randomness if necessary
    j++;
    if(j % random1_size == 0 && i != rank) {
      seedexpander(ctx, random1, random1_size);
      j = 0;
    }
  }

  // Set all the remaining coordinates with random linear combinations of the support coordinates
  unsigned int random2_size = (rank * (size - rank)) / 8 + 1;
  unsigned char random2[random2_size];
  seedexpander(ctx, random2, random2_size);

  unsigned int k = 0;
  unsigned int l = 0;
  for(i = 0 ; i < size ; ++i) {
    if(ffi_elt_is_zero(o[i])) {

      for(j = 0 ; j < rank ; ++j) {
        if(random2[k] & 0x1) {
          ffi_elt_add(o[i], support[j], o[i]);
        }

        random2[k] = random2[k] >> 1;
        l++;
        if(l == 8) {
          l = 0;
          k++;
        }

      }
    }
  }
}



/**
 * \fn void ffi_vec_set_random_from_support2(ffi_vec o, uint64_t size, const ffi_vec support, uint64_t rank)
 * \brief This function sets a vector with random values using the NIST PRNG. In addition, the support of the vector returned by this function is the one given in input.
 *
 * This function copies the support vector in rank random positions of <b>o</b>. Next, all the remaining coordinates of <b>v</b> are set using random linear combinations of the support coordinates. This does not exactly correspond to uniform sampling in the considered distribution (performance tradeoff) but can be made easily if required.
 *
 * \param[out] o Vector
 * \param[in] size Size of <b>o</b>
 * \param[in] support Support of <b>v</b>
 * \param[in] rank Size of the support
 */
void ffi_vec_set_random_from_support2(ffi_vec o, uint64_t size, const ffi_vec support, uint64_t rank) {

  // Copy the support vector in rank random positions of o
  unsigned int random1_size = 2 * rank;
  unsigned char random1[random1_size];
  randombytes(random1, random1_size);

  unsigned int i = 0;
  unsigned int j = 0;
  unsigned int position;
  while(i != rank) {
    position = random1[j];

    // Check that the position is not already taken
    if(position < size * (256 / size) && ffi_elt_is_zero(o[position % size])) {
      ffi_elt_set(o[position % size], support[i]);
      i++;
    }

    // Get more randomness if necessary
    j++;
    if(j % random1_size == 0 && i != rank) {
      randombytes(random1, random1_size);
      j = 0;
    }
  }

  // Set all the remaining coordinates with random linear combinations of the support coordinates
  unsigned int random2_size = (rank * (size - rank)) / 8 + 1;
  unsigned char random2[random2_size];
  randombytes(random2, random2_size);

  unsigned int k = 0;
  unsigned int l = 0;
  for(i = 0 ; i < size ; ++i) {
    if(ffi_elt_is_zero(o[i])) {

      for(j = 0 ; j < rank ; ++j) {
        if(random2[k] & 0x1) {
          ffi_elt_add(o[i], support[j], o[i]);
        }

        random2[k] = random2[k] >> 1;
        l++;
        if(l == 8) {
          l = 0;
          k++;
        }

      }
    }
  }
}



/**
 * \fn static uint64_t ffi_vec_gauss(ffi_vec v, uint64_t size)
 * \brief This function transform a vector of finite field elements to its row echelon form and returns its rank
 *
 * \param[in] v Vector of finite field elements
 * \param[in] size Size of the vector
 *
 * \return Rank of the vector <b>v</b>
 */
uint64_t ffi_vec_gauss(ffi_vec v, uint64_t size) {
  uint64_t degree;
  if(size == 0) return 0;

  int targetDeg, currentDeg;
  targetDeg = FIELD_M;

  for(int i = 0 ; i < size ; i++) {
    // Take the pivot as the greatest coordinate of v
    int pivot = i;
    currentDeg = ffi_elt_get_degree(v[pivot]);
    for(int j = pivot+1 ; j < size ; j++) {
      if(currentDeg == targetDeg) break;
      int jDeg = ffi_elt_get_degree(v[j]);
      if(jDeg > currentDeg) {
        pivot = j;
        currentDeg = jDeg;
      }
    }

    // Stop computation if the pivot is equal to zero
    if(currentDeg == -1) {
      return pivot;
    }

    targetDeg = currentDeg - 1;

    // Swap current coordinate with pivot
    ffi_elt tmp;
    ffi_elt_set(tmp, v[i]);
    ffi_elt_set(v[i], v[pivot]);
    ffi_elt_set(v[pivot], tmp);
    degree = ffi_elt_get_degree(v[i]);

    // Add matrix columns whenever necessary
    for(int j = i + 1; j < size; j++) {
      if(!(ffi_elt_is_zero(v[j]) || ffi_elt_get_degree(v[j]) < degree)) {
        ffi_elt_add(v[j], v[j], v[i]);
      }
    }
  }

  return size;
}



/**
 * \fn uint64_t ffi_vec_get_rank(const ffi_vec v, uint64_t size)
 * \brief This function computes the rank of a vector of finite field elements
 *
 * \param[in] v Vector of finite field elements
 * \param[in] size Size of the vector
 *
 * \return Rank of the vector <b>v</b>
 */
uint64_t ffi_vec_get_rank(const ffi_vec v, uint64_t size) {
  ffi_vec copy;
  ffi_vec_init(&copy, size);
  ffi_vec_set(copy, v, size);

  uint64_t dimension = ffi_vec_gauss(copy, size);

  ffi_vec_clear(copy, size);
  return dimension;
}



/**
 * \fn uint64_t ffi_vec_echelonize(ffi_vec v, uint64_t size)
 * \brief This function computes the row reduced echelon form of a vector of finite field elements and returns its rank
 *
 * \param[in] v Vector of finite field elements
 * \param[in] size Size of the vector
 *
 * \return Rank of the vector <b>v</b>
 */
uint64_t ffi_vec_echelonize(ffi_vec v, uint64_t size) {
  uint64_t degree;
  uint64_t dimension = ffi_vec_gauss(v, size);

  for(int i = dimension-1 ; i >= 1 ; i--) {
    degree = ffi_elt_get_degree(v[i]);

    for(int j = i-1 ; j >= 0 ; j--) {
      if(ffi_elt_get_coefficient(v[j], degree) == 1) {
        ffi_elt_add(v[j], v[j], v[i]);
      }
    }
  }

  return dimension;
}



/**
 * \fn void ffi_vec_add(ffi_vec o, const ffi_vec v1, const ffi_vec v2, uint64_t size)
 * \brief This function adds two vectors of finite field elements.
 *
 * \param[out] o Sum of <b>v1</b> and <b>v2</b>
 * \param[in] v1  Vector of finite field elements
 * \param[in] v2  Vector of finite field elements
 * \param[in] size  Size of the vectors
 */
void ffi_vec_add(ffi_vec o, const ffi_vec v1, const ffi_vec v2, uint64_t size) {
  for(int i = 0 ; i < size ; ++i) {
    ffi_elt_add(o[i], v1[i], v2[i]);
  }
}



/**
 * \fn void ffi_vec_scalar_mul(ffi_vec o, const ffi_vec v, const ffi_elt e, uint64_t size)
 * \brief This functions multiplies a vector of finite field elements by a scalar
 *
 * \param[out] o Vector equal to \f$ e \times v \f$
 * \param[in] v Vector of finite field elements
 * \param[in] e Finite field element
 * \param[in] size Size of the vector
 */
void ffi_vec_scalar_mul(ffi_vec o, const ffi_vec v, const ffi_elt e, uint64_t size) {
  for(int i = 0 ; i < size ; ++i) {
    ffi_elt_mul(o[i], v[i], e);
  }
}



/**
 * \fn void ffi_vec_to_string(unsigned char* str, const ffi_vec v, uint64_t size)
 * \brief This function parses a vector of finite field elements into a string using a non compact representation
 *
 * \param[out] str Output string
 * \param[in] v Vector of finite field elements
 * \param[in] size Size of the vector
 */
void ffi_vec_to_string(unsigned char* str, const ffi_vec v, uint64_t size) {
  memcpy(str, v, 8 * FIELD_UINT64 * size);
}



/**
 * \fn void ffi_vec_from_string(ffi_vec v, uint64_t size, const unsigned char* str)
 * \brief This function parses a string into a vector of finite field elements using a non compact representation
 *
 * \param[out] v Output vector
 * \param[in] size Size of the vector
 * \param[in] str String to parse
 */
void ffi_vec_from_string(ffi_vec v, uint64_t size, const unsigned char *str) {
  memcpy(v, str, 8 * FIELD_UINT64 * size);
}



/**
 * \fn void get_bit(unsigned char* b, unsigned char c, unsigned int position)
 * \brief This function reads a bit from a byte
 *
 * \param[out] b Read bit stored as a byte
 * \param[in] c Byte to read from
 * \param[in] position Position of the bit to read
 */
inline static void get_bit(unsigned char* b, unsigned char c, unsigned int position) {
  *b = (c >> position) & 0x01;
}



/**
 * \fn void set_bit(unsigned char* c, unsigned int position)
 * \brief This function sets a bit to 1 in a byte
 *
 * \param[out] c Byte to modify
 * \param[in] position Position of the bit to set
 */
inline static void set_bit(unsigned char* c, unsigned int position) {
  *c = *c | (1 << position);
}



/**
 * \fn void ffi_vec_to_string_compact(unsigned char* str, const ffi_vec v, uint64_t size)
 * \brief This function parses a vector of finite field elements into a string using a compact representation
 *
 * \param[out] str Output string
 * \param[in] v Vector of finite field elements
 * \param[in] size Size of the vector
 */
void ffi_vec_to_string_compact(unsigned char* str, const ffi_vec v, uint64_t size) {
  int bytes1 = FIELD_M / 8;

  int str_size = ((size * FIELD_M) % 8 == 0) ? size * FIELD_M / 8 : size * FIELD_M / 8 + 1;
  memset(str, 0, str_size);

  for(int i = 0 ; i < size ; i++) {
    memcpy(str + i * bytes1, v[i], bytes1);
  }

  int index = bytes1 * size;
  int bytes2 = FIELD_M % 8;
  int k = 0;
  for(int i = 0 ; i < size ; i++) {
    for(int j = 1 ; j <= bytes2 ; j++) {
      int bit = ffi_elt_get_coefficient(v[i], FIELD_M - j);
      if(bit == 1) {
        set_bit(str + index, k % 8);
      }
      k++;
      if(k % 8 == 0) index++;
    }
  }
}



/**
 * \fn void ffi_vec_from_string_compact(ffi_vec v, uint64_t size, const unsigned char* str)
 * \brief This function parses a string into a vector of finite field elements using a compact representation
 *
 * \param[out] v Output vector
 * \param[in] size Size of the vector
 * \param[in] str String to parse
 */
void ffi_vec_from_string_compact(ffi_vec v, uint64_t size, const unsigned char* str) {
  int bytes1 = FIELD_M / 8;

  ffi_vec_set_zero(v, size);

  for(int i = 0 ; i < size ; i++) {
    memcpy(v[i], str + i * bytes1, bytes1);
  }

  int index = bytes1 * size;
  int bytes2 = FIELD_M % 8;
  int k = 0;
  for(int i = 0 ; i < size ; i++) {
    for(int j = 1 ; j <= bytes2 ; j++) {
      unsigned char bit = 0;
      get_bit(&bit, str[index], k % 8);
      if(bit == 1) {
        ffi_elt_set_coefficient(v[i], FIELD_M - j);
      }
      k++;
      if(k % 8 == 0) index++;
    }
  }
}



/**
 * \fn void ffi_vec_print(ffi_vec v, uint64_t size)
 * \brief Display an ffi_vec element
 *
 * \param[out] v Output vector
 * \param[in] size Size of the vector
 */
void ffi_vec_print(ffi_vec v, uint64_t size) {
  printf("[\n");
  for(int i = 0 ; i < size ; ++i) {
    ffi_elt_print(v[i]);
    printf("\n");
  }
  printf("]\n");
}

