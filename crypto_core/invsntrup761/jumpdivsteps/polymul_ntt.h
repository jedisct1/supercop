#ifndef _POLYMUL_NTT_H_
#define _POLYMUL_NTT_H_

#include <immintrin.h>



#define polymul_ntt512_256_prepare crypto_core_invsntrup761_jumpdivsteps_polymul_ntt512_256_prepare
#define polymul_ntt512_finale crypto_core_invsntrup761_jumpdivsteps_polymul_ntt512_finale
#define polymul_ntt512_mul crypto_core_invsntrup761_jumpdivsteps_polymul_ntt512_mul
#define polymul_ntt512_add crypto_core_invsntrup761_jumpdivsteps_polymul_ntt512_add

#define polymul_ntt768_256_prepare crypto_core_invsntrup761_jumpdivsteps_polymul_ntt768_256_prepare
#define polymul_ntt768_512_prepare crypto_core_invsntrup761_jumpdivsteps_polymul_ntt768_512_prepare
#define polymul_ntt768_finale crypto_core_invsntrup761_jumpdivsteps_polymul_ntt768_finale
#define polymul_ntt768_mul crypto_core_invsntrup761_jumpdivsteps_polymul_ntt768_mul
#define polymul_ntt768_add crypto_core_invsntrup761_jumpdivsteps_polymul_ntt768_add

#define polymul_ntt512_256x256_test crypto_core_invsntrup761_jumpdivsteps_polymul_ntt512_256x256_test
#define polymul_ntt768_256x256_test crypto_core_invsntrup761_jumpdivsteps_polymul_ntt768_256x256_test




#ifdef  __cplusplus
extern  "C" {
#endif


extern void polymul_ntt512_256_prepare(__m256i *b, __m256i *a );
extern void polymul_ntt512_finale(__m256i *b, __m256i *a);
extern void polymul_ntt512_mul(__m256i *h, __m256i *f, __m256i *g );
extern void polymul_ntt512_add(__m256i *h, __m256i *f, __m256i *g );

extern void polymul_ntt768_256_prepare(__m256i *b, __m256i *a );
extern void polymul_ntt768_512_prepare(__m256i *b, __m256i *a );
extern void polymul_ntt768_finale(__m256i *b, __m256i *a);
extern void polymul_ntt768_mul(__m256i *h, __m256i *f, __m256i *g);
extern void polymul_ntt768_add(__m256i *h, __m256i *f, __m256i *g);


////////// tester  ////////////////

extern void polymul_ntt512_256x256_test(__m256i *h, __m256i *f, __m256i *g);
extern void polymul_ntt768_256x256_test(__m256i *h, __m256i *f, __m256i *g);


#ifdef  __cplusplus
}
#endif


#endif
