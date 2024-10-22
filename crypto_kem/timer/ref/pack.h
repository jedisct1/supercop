#ifndef TiMER_PACK_H
#define TiMER_PACK_H

#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "parameters.h"
#include "poly.h"
#include "verify.h"

#define DATA_OFFSET 16

#define Rq_to_bytes TiMER_NAMESPACE(Rq_to_bytes)
void Rq_to_bytes(uint8_t bytes[PKPOLY_BYTES], const poly *data);
#define bytes_to_Rq TiMER_NAMESPACE(bytes_to_Rq)
void bytes_to_Rq(poly *data, const uint8_t bytes[PKPOLY_BYTES]);
#define Rq_vec_to_bytes TiMER_NAMESPACE(Rq_vec_to_bytes)
void Rq_vec_to_bytes(uint8_t bytes[PKPOLYVEC_BYTES], const polyvec *data);
#define bytes_to_Rq_vec TiMER_NAMESPACE(bytes_to_Rq_vec)
void bytes_to_Rq_vec(polyvec *data, const uint8_t bytes[PKPOLYVEC_BYTES]);
#define Rq_mat_to_bytes TiMER_NAMESPACE(Rq_mat_to_bytes)
void Rq_mat_to_bytes(uint8_t bytes[PKPOLYMAT_BYTES],
                     const polyvec data[MODULE_RANK]);
#define bytes_to_Rq_mat TiMER_NAMESPACE(bytes_to_Rq_mat)
void bytes_to_Rq_mat(polyvec data[MODULE_RANK],
                     const uint8_t bytes[PKPOLYMAT_BYTES]);

#define Rp_to_bytes TiMER_NAMESPACE(Rp_to_bytes)
void Rp_to_bytes(uint8_t bytes[CTPOLY1_BYTES], const poly *data);
#define bytes_to_Rp TiMER_NAMESPACE(bytes_to_Rp)
void bytes_to_Rp(poly *data, const uint8_t bytes[CTPOLY1_BYTES]);
#define Rp2_to_bytes TiMER_NAMESPACE(Rp2_to_bytes)
void Rp2_to_bytes(uint8_t bytes[CTPOLY2_BYTES], const poly *data);
#define bytes_to_Rp2 TiMER_NAMESPACE(bytes_to_Rp2)
void bytes_to_Rp2(poly *data, const uint8_t bytes[CTPOLY2_BYTES]);
#define Rp_vec_to_bytes TiMER_NAMESPACE(Rp_vec_to_bytes)
void Rp_vec_to_bytes(uint8_t bytes[CTPOLYVEC_BYTES], const polyvec *data);
#define bytes_to_Rp_vec TiMER_NAMESPACE(bytes_to_Rp_vec)
void bytes_to_Rp_vec(polyvec *data, const uint8_t bytes[CTPOLYVEC_BYTES]);

#define Sx_to_bytes TiMER_NAMESPACE(Sx_to_bytes)
void Sx_to_bytes(uint8_t *bytes, const poly *data);
#define bytes_to_Sx TiMER_NAMESPACE(bytes_to_Sx)
void bytes_to_Sx(poly *data, const uint8_t *bytes);

#endif // TiMER_PACK_H
