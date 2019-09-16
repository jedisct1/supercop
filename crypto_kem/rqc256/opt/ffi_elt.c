/**
 * \file ffi_elt.c
 * \brief Implementation of ffi_elt.h
 */

#include "ffi.h"
#include "ffi_elt.h"
#include "rng.h"


/********************
* ffi_elt functions *
********************/

/**
 * \fn void ffi_elt_set_zero(ffi_elt o)
 * \brief This function sets a finite field element to zero
 *
 * \param[out] o Finite field element
 */
void ffi_elt_set_zero(ffi_elt o) {
  o[0] = 0;
  o[1] = 0;
  o[2] = 0;
  o[3] = 0;
}



/**
 * \fn void ffi_elt_set_one(ffi_elt o)
 * \brief This function sets a finite field element to one
 *
 * \param[out] o Finite field element
 */
void ffi_elt_set_one(ffi_elt o) {
  o[0] = 1;
  o[1] = 0;
  o[2] = 0;
  o[3] = 0;
}



/**
 * \fn void ffi_elt_set(ffi_elt o, const ffi_elt e)
 * \brief This function copies a finite field element into another one
 *
 * \param[out] o Finite field element
 * \param[in] e Finite field element
 */
void ffi_elt_set(ffi_elt o, const ffi_elt e) {
  o[0] = e[0];
  o[1] = e[1];
  o[2] = e[2];
  o[3] = 0;
}



/**
 * \fn void ffi_elt_set_random(ffi_elt o, AES_XOF_struct* ctx)
 * \brief This function sets a finite field element with random values using the NIST seed expander
 *
 * \param[out] o Finite field element
 * \param[in] ctx NIST seed expander
 */
void ffi_elt_set_random(ffi_elt o, AES_XOF_struct* ctx) {
  int bytes = (FIELD_M % 8 == 0) ? FIELD_M / 8 : FIELD_M / 8 + 1;
  unsigned char mask = (1 << FIELD_M % 8) - 1;

  ffi_elt_set_zero(o);

  unsigned char random[bytes];
  seedexpander(ctx, random, bytes);

  random[bytes - 1] &= mask;
  memcpy((uint64_t*) o, random, bytes);
}



/**
 * \fn void ffi_elt_set_random2(ffi_elt o)
 * \brief This function sets a finite field element with random values using the NIST PRNG
 *
 * \param[out] o Finite field element
 */
void ffi_elt_set_random2(ffi_elt o) {
  int bytes = (FIELD_M % 8 == 0) ? FIELD_M / 8 : FIELD_M / 8 + 1;
  unsigned char mask = (1 << FIELD_M % 8) - 1;

  ffi_elt_set_zero(o);

  unsigned char random[bytes];
  randombytes(random, bytes);

  random[bytes - 1] &= mask;
  memcpy((uint64_t*) o, random, bytes);
}



/**
 * \fn uint64_t ffi_elt_is_zero(const ffi_elt e)
 * \brief This functions tests if a finite field element is equal to zero
 *
 * \param[in] e Finite field element
 * \return 1 if <b>e</b> is equal to zero, 0 otherwise
 */
uint64_t ffi_elt_is_zero(const ffi_elt e) {
  return e[2] == 0 && e[1] == 0 && e[0] == 0;
}



/**
 * \fn uint64_t ffi_elt_is_equal_to(const ffi_elt e1, const ffi_elt e2)
 * \brief This functions tests if two finite field elements are equal
 *
 * \param[in] e1 Finite field element
 * \param[in] e2 Finite field element
 * \return 1 if <b>e1</b> and <b>e2</b> are equal, 0 otherwise
 */
uint64_t ffi_elt_is_equal_to(const ffi_elt e1, const ffi_elt e2) {
  return e1[0] == e2[0] && e1[1] == e2[1] && e1[2] == e2[2];
}



/**
 * \fn uint64_t ffi_elt_is_greater_than(const ffi_elt e1, const ffi_elt e2)
 * \brief This functions compares two finite field elements
 *
 * \param[in] e1 Finite field element
 * \param[in] e2 Finite field element
 * \return 1 if <b>e1</b> > <b>e2</b>, 0 otherwise
 */
uint64_t ffi_elt_is_greater_than(const ffi_elt e1, const ffi_elt e2) {
  if(e1[2] > e2[2]) {
    return 1;
  }

  if(e1[2] == e2[2] && e1[1] > e2[1]) {
    return 1;
  }

  if(e1[2] == e2[2] && e1[1] == e2[1] && e1[0] > e2[0]) {
    return 1;
  }
  return 0;
}



/**
 * \fn ffi_elt_add(ffi_elt o, const ffi_elt e1, const ffi_elt e2)
 * \brief This function adds two finite field elements
 *
 * \param[out] o Sum of <b>e1</b> and <b>e2</b>
 * \param[in] e1 Finite field element
 * \param[in] e2 Finite field element
 */
void ffi_elt_add(ffi_elt o, const ffi_elt e1, const ffi_elt e2) {
  __m128i tmp1 = AVX_LOAD((__m128i*) e1);
  __m128i tmp2 = AVX_LOAD((__m128i*) e2);
  tmp1 = AVX_XOR(tmp1, tmp2);
  AVX_STORE((__m128i*) o, tmp1);
  tmp1 = AVX_LOAD((__m128i*) (e1 + 2));
  tmp2 = AVX_LOAD((__m128i*) (e2 + 2));
  tmp1 = AVX_XOR(tmp1, tmp2);
  AVX_STORE((__m128i*) (o + 2), tmp1);
}



/**
 * \fn void ffi_elt_mul(ffi_elt o, const ffi_elt e1, const ffi_elt e2)
 * \brief This function multiplies two finite field elements
 *
 * \param[out] o Product of <b>e1</b> and <b>e2</b>
 * \param[in] e1 Finite field element
 * \param[in] e2 Finite field element
 */
void ffi_elt_mul(ffi_elt o, const ffi_elt e1, const ffi_elt e2) {
  ffi_elt_ur tmp;
  ffi_elt_ur_mul(tmp, e1, e2);
  ffi_elt_reduce(o, tmp);
}



/**
 * \fn uint64_t ffi_elt_get_degree(const ffi_elt e, uint64_t index)
 * \brief This function returns the degree of a finite field element
 *
 * \param[out] degree of <b>e</b>
 * \param[in] e Finite field element
 */
uint64_t ffi_elt_get_degree(const ffi_elt e) {
  uint64_t index = 0;
  if(e[2] != 0) {
    __asm__ volatile("bsr %1,%0;" : "=r"(index) : "r"(e[2]));
    return index + 128;
  }
  if(e[1] != 0) {
    __asm__ volatile("bsr %1,%0;" : "=r"(index) : "r"(e[1]));
    return index + 64;
  }
  if(e[0] != 0) {
    __asm__ volatile("bsr %1,%0;" : "=r"(index) : "r"(e[0]));
    return index;
  }
  return -1;
}



/**
 * \fn uint64_t ffi_elt_get_coefficient(const ffi_elt e, uint64_t index)
 * \brief This function returns the coefficient of the polynomial <b>e</b> at a given index.
 *
 * \param[in] e Finite field element
 * \param[in] index Index of the coefficient
 * \return Coefficient of <b>e</b> at the given index
 */
uint64_t ffi_elt_get_coefficient(const ffi_elt e, uint64_t index) {
  int position = index / 64;
  return (e[position] >> (index % 64)) & 0x01;
}



/**
 * \fn void ffi_elt_set_coefficient(ffi_elt o, uint64_t index)
 * \brief This function set a coefficient of the polynomial <b>e</b> to one
 *
 * \param[in] e Finite field element
 * \param[in] index Index of the coefficient
 */
void ffi_elt_set_coefficient(ffi_elt o, uint64_t index) {
  int position = index / 64;
  o[position] |= ((uint64_t) 0x01) << (index % 64);
}



/**
 * \fn ffi_elt_inv(ffi_elt o, const ffi_elt e)
 * \brief This function computes the multiplicative inverse of a finite field element.
 *
 * This function uses an extended euclidiean based algorithm
 *
 * \param[out] o inverse of e
 * \param[in] e an ffi_elt
 */
void ffi_elt_inv(ffi_elt o, const ffi_elt e) {
  ffi_elt u, v, g1, g2, t;
  uint64_t u_degree, v_degree, carry;
  int64_t j;

  u[0] = e[0];
  u[1] = e[1];
  u[2] = e[2];

  v[0] = 2097153;
  v[1] = 0;
  v[2] = 512;

  ffi_elt_set_one(g1);
  ffi_elt_set_zero(g2);

  while(u[0] != 1) {
    u_degree = ffi_elt_get_degree(u);
    v_degree = ffi_elt_get_degree(v);
    j = u_degree - v_degree;

    if(j < 0) {
      t[0] = u[0];
      t[1] = u[1];
      t[2] = u[2];
      u[0] = v[0];
      u[1] = v[1];
      u[2] = v[2];
      v[0] = t[0];
      v[1] = t[1];
      v[2] = t[2];

      t[0] = g1[0];
      t[1] = g1[1];
      t[2] = g1[2];
      g1[0] = g2[0];
      g1[1] = g2[1];
      g1[2] = g2[2];
      g2[0] = t[0];
      g2[1] = t[1];
      g2[2] = t[2];

      j = -j;
    }
    if(j == 0) {
      u[0] ^= v[0];
      u[1] ^= v[1];
      u[2] ^= v[2];
      g1[0] ^= g2[0];
      g1[1] ^= g2[1];
      g1[2] ^= g2[2];
    }
    if(j < 65 && j > 0) {
      carry = v[1] >> (64 - j);
      u[2] ^= (v[2] << j) ^ carry;
      carry = v[0] >> (64 - j);
      u[1] ^= (v[1] << j) ^ carry;
      u[0] ^= (v[0] << j);

      carry = g2[1] >> (64 - j);
      g1[2] ^= (g2[2] << j) ^ carry;
      carry = g2[0] >> (64 - j);
      g1[1] ^= (g2[1] << j) ^ carry;
      g1[0] ^= g2[0] << j;
    }
    if(j >= 65 && j < 129) {
      u[1] ^= v[0] << (j - 64);
      u[2] ^= v[0] >> (j % 64);
      g1[1] ^= g2[0] << (j - 64);
      g1[2] ^= g2[0] >> (j % 64);
    }
  }
  o[0] = g1[0];
  o[1] = g1[1];
  o[2] = g1[2];
}



/**
 * \fn void ffi_elt_sqr(ffi_elt o, const ffi_elt e)
 * \brief This function computes the square of a finite field element
 *
 * \param[out] o Finite field element equal to \f$ e^{2} \f$
 * \param[in] e Finite field element
 */
void ffi_elt_sqr(ffi_elt o, const ffi_elt e) {
  ffi_elt_ur tmp;
  ffi_elt_ur_sqr(tmp, e);
  ffi_elt_reduce(o, tmp);
}



/**
 * \fn void ffi_elt_nth_root(ffi_elt o, const ffi_elt e, uint64_t n)
 * \brief This function computes the nth root of a finite field element
 *
 * \param[out] o Nth root of <b>e</b>
 * \param[in] e Finite field element
 * \param[in] n Parameter defining the nth root
 */
void ffi_elt_nth_root(ffi_elt o, const ffi_elt e, uint64_t n) {
  int exp = n * (FIELD_M - 1) % FIELD_M;

  ffi_elt_sqr(o, e);
  for(int i = 0 ; i < exp - 1 ; ++i) {
    ffi_elt_sqr(o, o);
  }
}



/**
 * \fn void ffi_elt_reduce(ffi_elt o, const ffi_elt_ur e)
 * \brief This function reduces a finite field element
 *
 * This function uses f = X^97 + X^6 + 1
 *
 * \param[out] o Finite field element equal to \f$ e \pmod f \f$
 * \param[in] e Finite field element
 */
void ffi_elt_reduce(ffi_elt o, const ffi_elt_ur e) {
  // Reduce e[4] e[3]
  ffi_elt_set_zero(o);
  uint64_t v3 = 0;
  v3 ^= e[3] ^ (e[4] >> 52);
  o[2] ^= e[2] ^ (e[4] << 12) ^ (e[4] >> 9);
  o[1] ^= e[1] ^ (e[4] << 55);

  o[2] ^= (v3 >> 52);
  o[1] ^= (v3 >> 9) ^ (v3 << 12);
  o[0] ^= e[0] ^ (v3 << 55);

  // Reduce bits 137-191 of e[2]
  uint64_t tmp = (o[2] >> 9);
  o[0] ^= tmp ^ (tmp << 21);
  o[1] ^= (tmp >> 43);

  // Clear reduced bits in e[2]
  o[2] &= 0x1FF;
}




/**
 * \fn void ffi_elt_print(const ffi_elt e)
 * \brief Display a finite field element
 *
 * \param[in] e Finite field element
 */
void ffi_elt_print(const ffi_elt e) {
  printf("[ ");
  printf("%lu %lu %lu", e[0], e[1], e[2]);
  printf(" ]");
}





/***********************
* ffi_elt_ur functions *
***********************/

/**
 * \fn void ffi_elt_ur_mul(ffi_elt_ur o, const ffi_elt e1, const ffi_elt e2)
 * \brief This function computes the unreduced multiplication of two finite field elements
 *
 * \param[out] o Finite field element equal to \f$ e_1 \times e_2 \f$
 * \param[in] e1 Finite field element
 * \param[in] e2 Finite field element
 */
void ffi_elt_ur_mul(ffi_elt_ur o, const ffi_elt e1, const ffi_elt e2) {
  __m128i a = AVX_LOAD((__m128i*) e1);
  __m128i b = AVX_LOAD((__m128i*) e2);
  __m128i c = AVX_LOAD((__m128i*) (e1 + 2));
  __m128i d = AVX_LOAD((__m128i*) (e2 + 2));

  __m128i c1 =  AVX_CLMUL(a, b, 0x00);
  __m128i c2 =  AVX_CLMUL(a, b, 0x01);
  __m128i c3 =  AVX_CLMUL(a, d, 0x00);

  __m128i c4 =  AVX_CLMUL(a, b, 0x10);
  __m128i c5 =  AVX_CLMUL(a, b, 0x11);
  __m128i c6 =  AVX_CLMUL(a, d, 0x01);

  __m128i c7 =  AVX_CLMUL(c, b, 0x00);
  __m128i c8 =  AVX_CLMUL(c, b, 0x10);
  __m128i c9 =  AVX_CLMUL(c, d, 0x00);

  __m128i tmp = AVX_XOR(c6, c8);
  __m128i tmp2 = AVX_XOR(c7, AVX_XOR(c3, c5));
  __m128i tmp3 = AVX_XOR(c2, c4);

  o[0] = AVX_EXTRACT64(c1, 0);
  o[1] = AVX_EXTRACT64(tmp3, 0) ^ AVX_EXTRACT64(c1, 1);
  o[2] = AVX_EXTRACT64(tmp3, 1) ^ AVX_EXTRACT64(tmp2, 0);
  o[3] = AVX_EXTRACT64(tmp2, 1) ^ AVX_EXTRACT64(tmp, 0);
  o[4] = AVX_EXTRACT64(tmp, 1) ^ AVX_EXTRACT64(c9, 0);
}



/**
 * \fn void ffi_elt_ur_sqr(ffi_elt o, const ffi_elt e)
 * \brief This function computes the unreduced square of a finite field element
 *
 * \param[out]  o Unreduced finite field element equal to \f$ e^{2} \f$
 * \param[in]   e Finite field element
 */
void ffi_elt_ur_sqr(ffi_elt_ur o, const ffi_elt e) {
  __m128i* tmp = (__m128i*) malloc(2 * sizeof(__m128i));
  __m128i e_0, e_l, e_h;

  e_0 = AVX_LOAD((__m128i *) e);
  e_l = AVX_AND(e_0, SQR_MASK_LH);
  e_h = AVX_AND(AVX_SHR(e_0, 4), SQR_MASK_LH);

  e_l = AVX_PSHUFB(SQR_LOOKUP_TABLE, e_l);
  e_h = AVX_PSHUFB(SQR_LOOKUP_TABLE, e_h);

  tmp[0] = AVX_UNPACKLO(e_l, e_h);
  tmp[1] = AVX_UNPACKHI(e_l, e_h);

  AVX_STORE((__m128i*) o, tmp[0]);
  AVX_STORE((__m128i*) (o+2), tmp[1]);

  e_0 = AVX_LOAD((__m128i *) (e+2));
  e_l = AVX_AND(e_0, SQR_MASK_LH);
  e_h = AVX_AND(AVX_SHR(e_0, 4), SQR_MASK_LH);

  e_l = AVX_PSHUFB(SQR_LOOKUP_TABLE, e_l);
  e_h = AVX_PSHUFB(SQR_LOOKUP_TABLE, e_h);

  tmp[0] = AVX_UNPACKLO(e_l, e_h);
  o[4] = AVX_EXTRACT64(tmp[0], 0);

  free(tmp);
}



/**
 * \fn void ffi_elt_ur_print(const ffi_elt_ur e)
 * \brief Display an unreduced finite field element
 *
 * \param[in] e Unreduced finite field element
 */
void ffi_elt_ur_print(const ffi_elt_ur e) {
  printf("[ ");
  printf("%lu %lu %lu %lu %lu", e[0], e[1], e[2], e[3], e[4]);
  printf(" ]");
}

