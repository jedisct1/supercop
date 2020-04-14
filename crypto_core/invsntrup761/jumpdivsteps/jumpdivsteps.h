#ifndef _JUMPDIVSTEPS_H_
#define _JUMPDIVSTEPS_H_


#include <immintrin.h>


#define jump32divsteps crypto_core_invsntrup761_jumpdivsteps_jump32divsteps
#define jump64divsteps crypto_core_invsntrup761_jumpdivsteps_jump64divsteps
#define jump128divsteps crypto_core_invsntrup761_jumpdivsteps_jump128divsteps
#define jump256divsteps crypto_core_invsntrup761_jumpdivsteps_jump256divsteps
#define jump16xdivsteps crypto_core_invsntrup761_jumpdivsteps_jump16xdivsteps
#define jump32xdivsteps crypto_core_invsntrup761_jumpdivsteps_jump32xdivsteps
#define jump64xdivsteps crypto_core_invsntrup761_jumpdivsteps_jump64xdivsteps
#define jump128xdivsteps crypto_core_invsntrup761_jumpdivsteps_jump128xdivsteps
#define jump256xdivsteps crypto_core_invsntrup761_jumpdivsteps_jump256xdivsteps



#ifdef  __cplusplus
extern  "C" {
#endif


int jump32divsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr);

int jump64divsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr);

int jump128divsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr);

int jump256divsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr);


int jump32xdivsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr, int t);

int jump64xdivsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr, int t);

int jump128xdivsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr, int t);

int jump256xdivsteps(int delta, __m256i *f, __m256i *g, __m256i *uvqr, int t);



#ifdef  __cplusplus
}
#endif


#endif // _JUMPDIVSTEPS_H_
