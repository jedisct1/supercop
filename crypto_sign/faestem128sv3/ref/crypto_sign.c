/*
 *  SPDX-License-Identifier: MIT
 */

#ifdef SUPERCOP
#include "crypto_sign.h"
#else
#include "api.h"
#endif

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include "faest_em_128s.h"

#include <string.h>

int crypto_sign_keypair(unsigned char* pk, unsigned char* sk) {
  return faest_em_128s_keygen(pk, sk);
}

int crypto_sign(unsigned char* sm, unsigned long long* smlen, const unsigned char* m,
                unsigned long long mlen, const unsigned char* sk) {
  *smlen = mlen + FAEST_EM_128S_SIGNATURE_SIZE;
  memmove(sm, m, mlen);

  size_t signature_len = FAEST_EM_128S_SIGNATURE_SIZE;
  return faest_em_128s_sign(sk, sm, mlen, sm + mlen, &signature_len);
}

int crypto_sign_open(unsigned char* m, unsigned long long* mlen, const unsigned char* sm,
                     unsigned long long smlen, const unsigned char* pk) {
  if (smlen < FAEST_EM_128S_SIGNATURE_SIZE) {
    // signature too short
    return -1;
  }
  unsigned long long m_length = smlen - FAEST_EM_128S_SIGNATURE_SIZE;
  if (faest_em_128s_verify(pk, sm, m_length, sm + m_length, FAEST_EM_128S_SIGNATURE_SIZE)) {
    return -1;
  }

  *mlen = m_length;
  memmove(m, sm, m_length);
  return 0;
}

// vim: ft=c
