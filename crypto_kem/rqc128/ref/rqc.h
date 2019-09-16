/** 
 * \file rqc.h
 * \brief Functions of the RQC_PKE IND-CPA scheme
 */

#ifndef RQC_H
#define RQC_H

#include "ffi_vec.h"
#include "ffi_qre.h"


void rqc_pke_keygen(unsigned char* pk, unsigned char* sk);
void rqc_pke_encrypt(ffi_qre u, ffi_qre v, const ffi_vec m, unsigned char* theta, const unsigned char* pk);
void rqc_pke_decrypt(ffi_vec m, const ffi_qre u, const ffi_qre v, const unsigned char* sk);

#endif

