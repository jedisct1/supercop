#ifndef _NTT_H_
#define _NTT_H_

#include "stdint.h"

typedef int16_t int16;


#define ntt512_256_7681 crypto_core_invsntrup761_jumpdivsteps_ntt512_256_7681
#define invntt512_7681 crypto_core_invsntrup761_jumpdivsteps_invntt512_7681
#define ntt512_256_10753 crypto_core_invsntrup761_jumpdivsteps_ntt512_256_10753
#define invntt512_10753 crypto_core_invsntrup761_jumpdivsteps_invntt512_10753
#define ntt512_256_12289 crypto_core_invsntrup761_jumpdivsteps_ntt512_256_12289
#define invntt512_12289 crypto_core_invsntrup761_jumpdivsteps_invntt512_12289


#define ntt768_769 crypto_core_invsntrup761_jumpdivsteps_ntt768_769
#define ntt768_7681 crypto_core_invsntrup761_jumpdivsteps_ntt768_7681
#define ntt768_10753 crypto_core_invsntrup761_jumpdivsteps_ntt768_10753
#define ntt768_512_769 crypto_core_invsntrup761_jumpdivsteps_ntt768_512_769
#define ntt768_512_7681 crypto_core_invsntrup761_jumpdivsteps_ntt768_512_7681
#define ntt768_512_10753 crypto_core_invsntrup761_jumpdivsteps_ntt768_512_10753
#define ntt768_256_769 crypto_core_invsntrup761_jumpdivsteps_ntt768_256_769
#define ntt768_256_7681 crypto_core_invsntrup761_jumpdivsteps_ntt768_256_7681
#define ntt768_256_10753 crypto_core_invsntrup761_jumpdivsteps_ntt768_256_10753
#define invntt768_769 crypto_core_invsntrup761_jumpdivsteps_invntt768_769
#define invntt768_7681 crypto_core_invsntrup761_jumpdivsteps_invntt768_7681
#define invntt768_10753 crypto_core_invsntrup761_jumpdivsteps_invntt768_10753
#define pointwise768_769 crypto_core_invsntrup761_jumpdivsteps_pointwise768_769
#define pointwise768_7681 crypto_core_invsntrup761_jumpdivsteps_pointwise768_7681
#define pointwise768_10753 crypto_core_invsntrup761_jumpdivsteps_pointwise768_10753
#define crt768 crypto_core_invsntrup761_jumpdivsteps_crt768




#ifdef  __cplusplus
extern  "C" {
#endif


void ntt512_256_7681(int16 *f,int reps);
void invntt512_7681(int16 *f,int reps);
void ntt512_256_10753(int16 *f,int reps);
void invntt512_10753(int16 *f,int reps);
void ntt512_256_12289(int16 *f,int reps);
void invntt512_12289(int16 *f,int reps);



void ntt768_769(int16*,int);
void ntt768_7681(int16*,int);
void ntt768_10753(int16*,int);
void ntt768_512_769(int16*,int);
void ntt768_512_7681(int16*,int);
void ntt768_512_10753(int16*,int);
void ntt768_256_769(int16*,int);
void ntt768_256_7681(int16*,int);
void ntt768_256_10753(int16*,int);
void invntt768_769(int16*,int);
void invntt768_7681(int16*,int);
void invntt768_10753(int16*,int);
void pointwise768_769(int16*,int16*);
void pointwise768_7681(int16*,int16*);
void pointwise768_10753(int16*,int16*);
void crt768(int16*);

#ifdef  __cplusplus
}
#endif



#endif
