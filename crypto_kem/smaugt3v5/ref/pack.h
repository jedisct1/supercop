// SPDX-License-Identifier: MIT

#ifndef SMAUGT_PACK_H
#define SMAUGT_PACK_H

#include "ciphertext.h"
#include "key.h"
#include "params.h"
#include "poly.h"

#include <stdint.h>

#define pack_enck SMAUGT_NAMESPACE(pack_enck)
#define unpack_enck SMAUGT_NAMESPACE(unpack_enck)

#define pack_deck SMAUGT_NAMESPACE(pack_deck)
#define unpack_deck SMAUGT_NAMESPACE(unpack_deck)

#define pack_s_poly SMAUGT_NAMESPACE(pack_s_poly)
#define unpack_s_poly SMAUGT_NAMESPACE(unpack_s_poly)

#define pack_ct SMAUGT_NAMESPACE(pack_ct)
#define unpack_ct SMAUGT_NAMESPACE(unpack_ct)

#define pack_ring SMAUGT_NAMESPACE(pack_ring)
#define unpack_ring SMAUGT_NAMESPACE(unpack_ring)

#define pack_ring_p SMAUGT_NAMESPACE(pack_ring_p)
#define unpack_ring_p SMAUGT_NAMESPACE(unpack_ring_p)

#define pack_ring_p_prime SMAUGT_NAMESPACE(pack_ring_p_prime)
#define unpack_ring_p_prime SMAUGT_NAMESPACE(unpack_ring_p_prime)

#define pack_ring_vec SMAUGT_NAMESPACE(pack_ring_vec)
#define unpack_ring_vec SMAUGT_NAMESPACE(unpack_ring_vec)

#define pack_ring_p_vec SMAUGT_NAMESPACE(pack_ring_p_vec)
#define unpack_ring_p_vec SMAUGT_NAMESPACE(unpack_ring_p_vec)

#define pack_ring_mat SMAUGT_NAMESPACE(pack_ring_mat)
#define unpack_ring_mat SMAUGT_NAMESPACE(unpack_ring_mat)

void pack_enck(uint8_t *output, const public_key *pk);
void unpack_enck(public_key *pk, const uint8_t *input);

void pack_deck(uint8_t *output, const secret_key *sk);
void unpack_deck(secret_key *sk, const uint8_t *input);

void pack_s_poly(uint8_t *bytes, const poly *data);
void unpack_s_poly(poly *data, const uint8_t *bytes);

void pack_ct(uint8_t *output, const ciphertext *ctxt);
void unpack_ct(ciphertext *ctxt, const uint8_t *input);

void pack_ring(uint8_t bytes[SMAUGT_PKPOLY_BYTES], const poly *data);
void unpack_ring(poly *data, const uint8_t bytes[SMAUGT_PKPOLY_BYTES]);

void pack_ring_p(uint8_t bytes[SMAUGT_CTPOLY1_BYTES], const poly *data);
void unpack_ring_p(poly *data, const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]);

void pack_ring_p_prime(uint8_t bytes[SMAUGT_CTPOLY2_BYTES], const poly *data);
void unpack_ring_p_prime(poly *data, const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]);

void pack_ring_vec(uint8_t bytes[SMAUGT_PKPOLYVEC_BYTES], const polyvec *data);
void unpack_ring_vec(polyvec *data,
                     const uint8_t bytes[SMAUGT_PKPOLYVEC_BYTES]);

void pack_ring_p_vec(uint8_t bytes[SMAUGT_CTPOLYVEC_BYTES],
                     const polyvec *data);
void unpack_ring_p_vec(polyvec *data,
                       const uint8_t bytes[SMAUGT_CTPOLYVEC_BYTES]);

void pack_ring_mat(uint8_t bytes[SMAUGT_PKPOLYMAT_BYTES],
                   const polyvec data[SMAUGT_K]);
void unpack_ring_mat(polyvec data[SMAUGT_K],
                     const uint8_t bytes[SMAUGT_PKPOLYMAT_BYTES]);

#endif /* !SMAUGT_PACK_H */
