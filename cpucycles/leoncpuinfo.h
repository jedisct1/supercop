/*
cpucycles/leoncpuinfo.h version 20250211
D. J. Bernstein
Public domain.
*/

#ifndef CPUCYCLES_leoncpuinfo_h
#define CPUCYCLES_leoncpuinfo_h

#ifdef __cplusplus
extern "C" {
#endif

extern long long cpucycles_leoncpuinfo(void);
extern long long cpucycles_leoncpuinfo_persecond(void);

#ifdef __cplusplus
}
#endif

#ifndef cpucycles_implementation
#define cpucycles_implementation "leoncpuinfo"
#define cpucycles cpucycles_leoncpuinfo
#define cpucycles_persecond cpucycles_leoncpuinfo_persecond
#endif

#endif
