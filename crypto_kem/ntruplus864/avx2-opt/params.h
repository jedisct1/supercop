#ifndef PARAMS_H
#define PARAMS_H

#define NTRUPLUS_ALGNAME "NTRU+864"

#define NTRUPLUS_N 864
#define NTRUPLUS_Q 3457
#define NTRUPLUS_D 3

#define NTRUPLUS_SYMBYTES  32   /* size in bytes of hashes, and seeds */
#define NTRUPLUS_SSBYTES   32   /* size in bytes of shared key */
#define NTRUPLUS_POLYBYTES 1296

#define NTRUPLUS_PUBLICKEYBYTES  NTRUPLUS_POLYBYTES
#define NTRUPLUS_SECRETKEYBYTES  ((NTRUPLUS_POLYBYTES << 1) + NTRUPLUS_SYMBYTES)
#define NTRUPLUS_CIPHERTEXTBYTES  NTRUPLUS_POLYBYTES

/*
 * The three NIST entry points keep their names (api.h).  Every other global
 * symbol of this package is ntruplus864_avx2opt_<name>: C through this macro
 * (see poly.h, consts.h, symmetric.h), assembly literally, and mlkem-native
 * through MLK_CONFIG_NAMESPACE_PREFIX (mlkem_native_config.h).
 */
#define NTRUPLUS_NAMESPACE(s) ntruplus864_avx2opt_##s

#endif
