/** 
 * \file rsr_algorithm.h
 * \brief Functions for quasi-cyclic rank support recovery problem
 */

#ifndef RSR_ALGORITHM_H
#define RSR_ALGORITHM_H

#include "ffi_poly.h"
#include "ffi_vspace.h"

unsigned int rank_support_recoverer(ffi_vspace E, unsigned int E_expected_dim, ffi_vspace F, unsigned int F_dim, ffi_poly ec, unsigned int ec_size);

#endif

