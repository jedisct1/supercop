#ifndef _H_MQS_CONFIG_H_
#define _H_MQS_CONFIG_H_

#include <stdint.h>

#define _MQLR

#define _MQS256_112_72



#define _TYPE MQLR

#if defined _MQS256_72_46
#define _GFSIZE 256
#define _V 72
#define _O 46
#define _HASH_LEN 64
#define MAX_DEPTH 1

#elif defined _MQS256_112_72
#define _GFSIZE 256
#define _V 112
#define _O 72
#define _HASH_LEN 64
#define MAX_DEPTH 3

#elif defined _MQS256_148_96
#define _GFSIZE 256
#define _V 148
#define _O 96
#define _HASH_LEN 64
#define MAX_DEPTH 5

#else
error: has to define a parameter.
#endif

#define STR1(x) #x
	// #define THE_NAME(gf,v,o) "MQLR(" STR1(gf) "," STR1(v) "," STR1(o) ")"
#define THE_NAME(type, gf,v,o) STR1(type) "(" STR1(gf) "," STR1(v) "," STR1(o) ")"
#define _S_NAME THE_NAME(_TYPE,_GFSIZE,_V,_O)


/// size of N, in # of gf elements.
#define _PUB_N  (_V+_O)

/// size of M, in # gf elements.
#define _PUB_M  (_O)


#define _V_BYTE (_V)
#define _O_BYTE (_O)
#define _PUB_N_BYTE  (_PUB_N)
#define _PUB_M_BYTE  (_PUB_M)
#define _HALF_O (_O/2)

#define TERMS_QUAD_POLY(N) ((N)*(N+1)/2)
#define IDX_XSQ(i,n_var) (((2*(n_var)+1-i)*(i)/2)+n_var)
/// xi <= xj
#define IDX_QTERMS_REVLEX(xi,xj) ((xj)*(xj+1)/2 + (xi))

/// 1 for length of salt
#define _PUB_KEY_LEN ((TERMS_QUAD_POLY(_PUB_N)*(_PUB_M_BYTE)) + 1)

/// length of seed for public key, in # bytes
#define LEN_PKSEED 32

/// length of seed for secret key, in # bytes
#define LEN_SKSEED 32

/// length of salt for a signature, in # bytes
#define _SALT_BYTE 32
#define _SALT_SOURCE_LEN 32

/// length of a signature
#define _SIGNATURE_BYTE (_PUB_N_BYTE + _SALT_BYTE )

#endif
