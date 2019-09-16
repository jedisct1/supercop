/**
 * \file ffi_elt.c
 * \brief Implementation of ffi_elt.h
 */

#include "ffi.h"
#include "ffi_elt.h"
#include "rng.h"

static int init_field = 0;

/********************
* ffi_elt functions *
********************/


/**
 * \fn void ffi_field_init()
 * \brief This function initializes various constants used to perform finite field arithmetic
 *
 */
void ffi_field_init() {

  if(init_field == 0) {
    // Precompute SQR_LOOKUP_TABLE
    unsigned int bit = 0;
    uint64_t mask = 0;
    memset(SQR_LOOKUP_TABLE, 0, 8*256);
    for(int i = 0 ; i < 256 ; ++i) {
      for(int j = 0 ; j < 8 ; ++j) {
        mask = 1 << j;
        bit = (mask & i) >> j;
        SQR_LOOKUP_TABLE[i] ^= (bit<<(2*j));
      }
    }
  }
}



/**
 * \fn void ffi_elt_set_zero(ffi_elt o)
 * \brief This function sets a finite field element to zero
 *
 * \param[out] o Finite field element
 */
void ffi_elt_set_zero(ffi_elt o) {
  o[0] = 0;
  o[1] = 0;
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
}



/**
 * \fn void ffi_elt_set_random(ffi_elt o, AES_XOF_struct* ctx)
 * \brief This function sets a finite field element with random values using the NIST seed expander
 *
 * \param[out] o Finite field element
 * \param[in] ctx NIST seed expander
 */
void ffi_elt_set_random(ffi_elt o, AES_XOF_struct* ctx) {
  ffi_elt_set_zero(o);

  int bytes = (FIELD_M % 8 == 0) ? FIELD_M / 8 : FIELD_M / 8 + 1;
  unsigned char random[bytes];
  seedexpander(ctx, random, bytes);

  unsigned char mask = (1 << FIELD_M % 8) - 1;
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
  ffi_elt_set_zero(o);

  int bytes = (FIELD_M % 8 == 0) ? FIELD_M / 8 : FIELD_M / 8 + 1;
  unsigned char random[bytes];
  randombytes(random, bytes);

  unsigned char mask = (1 << FIELD_M % 8) - 1;
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
  return e[1] == 0 && e[0] == 0;
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
  return e1[0] == e2[0] && e1[1] == e2[1];
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
  if(e1[1] > e2[1]) {
    return 1;
  }

  if(e1[1] == e2[1] && e1[0] > e2[0]) {
    return 1;
  }

  return 0;
}


/* external implemantion of ffi_field_init() used to precompute tables for ffi_elt_ur_sqr */
extern inline void ffi_field_init();



/**
 * \fn ffi_elt_add(ffi_elt o, const ffi_elt e1, const ffi_elt e2)
 * \brief This function adds two finite field elements
 *
 * \param[out] o Sum of <b>e1</b> and <b>e2</b>
 * \param[in] e1 Finite field element
 * \param[in] e2 Finite field element
 */
void ffi_elt_add(ffi_elt o, const ffi_elt e1, const ffi_elt e2) {
  o[0] = e1[0] ^ e2[0];
  o[1] = e1[1] ^ e2[1];
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
  ffi_elt_ur_set_zero(tmp);
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

  ffi_elt_set(u, e);
  ffi_elt_set(v, INV_POLY_FIELD);

  ffi_elt_set_one(g1);
  ffi_elt_set_zero(g2);

  while(u[0] != 1) {
    u_degree = ffi_elt_get_degree(u);
    v_degree = ffi_elt_get_degree(v);
    j = u_degree - v_degree;

    if(j < 0) {
      t[0] = u[0];
      t[1] = u[1];
      u[0] = v[0];
      u[1] = v[1];
      v[0] = t[0];
      v[1] = t[1];

      t[0] = g1[0];
      t[1] = g1[1];
      g1[0] = g2[0];
      g1[1] = g2[1];
      g2[0] = t[0];
      g2[1] = t[1];

      j = -j;
    }

    if(j == 0) {
      u[0] ^= v[0];
      u[1] ^= v[1];
      g1[0] ^= g2[0];
      g1[1] ^= g2[1];
    }

    if(j < 65 && j > 0) {
      carry = v[0] >> (64 - j);
      u[0] ^= (v[0] << j);
      u[1] ^= (v[1] << j) ^ carry;

      carry = g2[0] >> (64 - j);
      g1[0] ^= g2[0] << j;
      g1[1] ^= (g2[1] << j) ^ carry;
    }

    if(j >= 65) {
      u[1] ^= v[0] << (j - 64);
      g1[1] ^= g2[0] << (j - 64);
    }
  }

  o[0] = g1[0];
  o[1] = g1[1];
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
  // Reduce e[2]
  o[0] = 0;
  o[1] = 0;
  uint64_t tmp = e[2] << 45;
  uint64_t tmp2 = e[2] >> 12;
  o[0] ^= e[0] ^ (tmp << 2) ^ tmp ^ (tmp << 4) ^ (tmp << 7);
  o[1] ^= e[1] ^ tmp2 ^ (tmp2 >> 3) ^ (tmp2 >> 5)  ^ (tmp2 >> 7);

  // Reduce bits 83-127 of e[1]
  tmp = (o[1] >> 19);
  o[0] ^= tmp ^ (tmp << 2) ^ (tmp << 4) ^ (tmp << 7);

  // Clear reduced bits in e[1]
  o[1] &= 0x7FFFF;
}




/**
 * \fn void ffi_elt_print(const ffi_elt e)
 * \brief Display a finite field element
 *
 * \param[in] e Finite field element
 */
void ffi_elt_print(const ffi_elt e) {
  printf("[ ");
  printf("%lu %lu", e[0], e[1]);
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
  unsigned int u;

  //precomputation u(z).b(z)
  uint64_t carry = 0;
  uint64_t w = 4;
  unsigned int size_Bu = (((FIELD_M-1) + (w-1))/64 )+1;
  uint64_t Bu[16][size_Bu];

  ffi_elt_set_zero(Bu[0]);
  ffi_elt_set_zero(Bu[1]);
  ffi_elt_set(Bu[1], e2);

  for(int i = 2; i < 16 ; i += 2) {
    Bu[i][0] = Bu[i>>1][0] << 1;

    for(int j = 1 ; j < size_Bu ; ++j) {
      carry = Bu[i>>1][j-1] >> 63;
      Bu[i][j] = (Bu[i>>1][j] << 1) ^ carry;
    }
    for(int j = 0 ; j < size_Bu ; ++j) {
      Bu[i+1][j] = Bu[i][j] ^ e2[j];
    }
  }

  //Multiplication
  for(int k = 64/w - 1 ; k > 0 ; --k) {
    for(int j = 0 ; j < FIELD_UINT64 ; ++j) {
      u = (e1[j] >> (w*k)) & 0xF;
      for(int i = 0 ; i < size_Bu ; ++i) {
        o[j+i] ^= Bu[u][i];
      }
    }

    for(int i = 2*FIELD_UINT64-1 ; i > 0 ; --i) {
      o[i] = (o[i] << 4) ^ (o[i-1] >> 60);
    }
    o[0] = o[0] << 4;
  }

  for(int j = 0 ; j < FIELD_UINT64 ; ++j) {
    u = e1[j] & 0xF;
    for(int i = 0 ; i < size_Bu ; ++i) {
      o[j+i] ^= Bu[u][i];
    }
  }
}



/**
 * \fn void ffi_elt_ur_sqr(ffi_elt o, const ffi_elt e)
 * \brief This function computes the unreduced square of a finite field element
 *
 * \param[out]  o Unreduced finite field element equal to \f$ e^{2} \f$
 * \param[in]   e Finite field element
 */
void ffi_elt_ur_sqr(ffi_elt_ur o, const ffi_elt e) {
  unsigned int u0, u1, u2, u3, u4, u5, u6, u7;

  for(int i = 0 ; i < FIELD_UINT64 ; ++i) {
    u0 = e[i] & 0xff;
    u1 = (e[i] & 0xff00) >> 8;
    u2 = (e[i] & 0xff0000) >> 16;
    u3 = (e[i] & 0xff000000) >> 24;
    u4 = (e[i] & 0xff00000000) >> 32;
    u5 = (e[i] & 0xff0000000000) >> 40;
    u6 = (e[i] & 0xff000000000000) >> 48;
    u7 = (e[i] & 0xff00000000000000) >> 56;

    o[2*i] = (SQR_LOOKUP_TABLE[u3] << 48) ^ (SQR_LOOKUP_TABLE[u2] << 32) ^ (SQR_LOOKUP_TABLE[u1] << 16) ^ SQR_LOOKUP_TABLE[u0];
    o[2*i+1] = (SQR_LOOKUP_TABLE[u7] << 48) ^ (SQR_LOOKUP_TABLE[u6] << 32) ^ (SQR_LOOKUP_TABLE[u5] << 16) ^ SQR_LOOKUP_TABLE[u4];
  }
}



/**
 * \fn void ffi_elt_ur_print(const ffi_elt_ur e)
 * \brief Display an unreduced finite field element
 *
 * \param[in] e Unreduced finite field element
 */
void ffi_elt_ur_print(const ffi_elt_ur e) {
  printf("[ ");
  printf("%lu %lu %lu %lu", e[0], e[1], e[2], e[3]);
  printf(" ]");
}





/***************************
* ffi-layer only functions *
***************************/

void ffi_elt_from_uint64(ffi_elt e, const uint64_t* u) {
  e[0] = u[0];
  e[1] = u[1];
}

void ffi_elt_to_uint64(uint64_t* o, const ffi_elt e) {
  o[0] = e[0];
  o[1] = e[1];
}

void ffi_elt_ur_set_zero(ffi_elt_ur o) {
  o[0] = 0;
  o[1] = 0;
  o[2] = 0;
  o[3] = 0;
}

void ffi_elt_ur_from_uint64(ffi_elt e, const uint64_t* u) {
  e[0] = u[0];
  e[1] = u[1];
  e[2] = u[2];
  e[3] = u[3];
}

void ffi_elt_ur_set_random(ffi_elt_ur e) {
  ffi_elt_ur_set_zero(e);
  int bytes = (2*FIELD_M-2 % 8 == 0) ? (2*FIELD_M-2) / 8 : (2*FIELD_M-2) / 8 + 1;
  unsigned char random[bytes];
  randombytes(random, bytes);

  unsigned char mask = (1 << ((2*FIELD_M-2) % 8)) - 1;
  random[bytes - 1] &= mask;
  memcpy((uint64_t*) e, random, bytes);
}
