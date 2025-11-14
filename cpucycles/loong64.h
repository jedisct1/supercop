/*
cpucycles_loong64.h version 20251010
D. J. Bernstein
Public domain.
*/

#ifndef CPUCYCLES_loong64_h
#define CPUCYCLES_loong64_h

#ifdef __cplusplus
extern "C" {
#endif

extern long long cpucycles_loong64(void);
extern long long cpucycles_loong64_persecond(void);

#ifdef __cplusplus
}
#endif

#ifndef cpucycles_implementation
#define cpucycles_implementation "loong64"
#define cpucycles cpucycles_loong64
#define cpucycles_persecond cpucycles_loong64_persecond
#endif

#endif
