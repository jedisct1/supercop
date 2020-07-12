/* 
  This file is for functions required for generating the control bits of the Benes network w.r.t. a random permutation
  see the Lev-Pippenger-Valiant paper https://www.computer.org/csdl/trans/tc/1981/02/06312171.pdf
*/

#ifndef CONTROLBITS_H
#define CONTROLBITS_H
#define controlbits crypto_kem_mceliece8192128_vec_controlbits
#define sort_63b crypto_kem_mceliece8192128_vec_sort_63b

#include <stdint.h>

void sort_63b(int, uint64_t []);
void controlbits(unsigned char *, uint32_t *);

#endif

