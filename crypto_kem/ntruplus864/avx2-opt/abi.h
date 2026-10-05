#ifndef NTRUPLUS_ABI_H
#define NTRUPLUS_ABI_H

/*
 * Internal header (not part of the public API in api.h): linkage attributes
 * of the C declarations of internal ntruplus864_avx2opt_* symbols.
 *   NTRUPLUS_INTERNAL  hidden visibility on ELF targets;
 *   NTRUPLUS_SYSV      the System V calling convention of the assembly kernels,
 *                      for C callers on MinGW (Windows x64 ABI by default).
 */
#if defined(__MINGW32__) || defined(__MINGW64__)
#define NTRUPLUS_INTERNAL
#define NTRUPLUS_SYSV __attribute__((sysv_abi))
#else
#define NTRUPLUS_INTERNAL __attribute__((visibility("hidden")))
#define NTRUPLUS_SYSV
#endif

#endif
