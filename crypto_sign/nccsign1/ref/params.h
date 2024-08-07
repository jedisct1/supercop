#ifndef PARAMS_H
#define PARAMS_H

#include "config.h"


#define SEEDBYTES 32
#define CRHBYTES 64


#if NIMS_TRI_NTT_MODE == 1
#define N 1152
#define P 1152
#define NR 1152
#define Q 8401537
#define QINV 2245397889 // q^(-1) mod 2^32
#define MONT 1781889 // 2^32 % Q
#define D 12
#define ETA 1
#define TAU 25
#define BETA 50
#define GAMMA1 (1<<18)
#define GAMMA2 131274
#define OMEGA 80
#elif NIMS_TRI_NTT_MODE == 3
#define N 1536
#define P 1536
#define NR 1536 
#define Q 8397313
#define QINV 2080628225 // q^(-1) mod 2^32
#define MONT 3940353 // 2^32 % Q
#define D 12
#define ETA 1
#define TAU 29
#define BETA 58
#define GAMMA1 (1<<18)
#define GAMMA2 131208
#define OMEGA 80
#elif NIMS_TRI_NTT_MODE == 5
#define N 2304
#define P 2304
#define NR 2304 
#define Q 8404993
#define QINV 260030465 // q^(-1) mod 2^32
#define MONT 15873 // 2^32 % Q
#define D 13
#define ETA 1
#define TAU 32
#define BETA 64
#define GAMMA1 (1<<19)
#define GAMMA2 262656
#define OMEGA 80
#endif

//packing bytes define

#define POLYT1_PACKEDBYTES      ((N*(24-D))/8)
#define POLYT0_PACKEDBYTES      ((N*D)/8)
#define POLYH_PACKEDBYTES    (N/8)

#if (N==2304)
#define POLYZ_PACKEDBYTES       ((N*20)/8)
#else
#define POLYZ_PACKEDBYTES       ((N*19)/8)
#endif

#if (N==2304)
#define POLYW1_PACKEDBYTES      ((N*4)/8)
#else
#define POLYW1_PACKEDBYTES      ((N*5)/8)
#endif

#define POLYETA_PACKEDBYTES     ((N*3)/8)


#define crypto_PUBLICKEYBYTES   (SEEDBYTES + POLYT1_PACKEDBYTES)
#define crypto_SECRETKEYBYTES   (3*SEEDBYTES\
                                + 2*POLYETA_PACKEDBYTES\
                                + POLYT0_PACKEDBYTES)
#define crypto_BYTES            (SEEDBYTES + POLYZ_PACKEDBYTES + POLYH_PACKEDBYTES)

#endif
