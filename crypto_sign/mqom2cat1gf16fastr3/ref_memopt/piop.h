#ifndef __PIOP_H__
#define __PIOP_H__

#if defined(MEMORY_EFFICIENT_PIOP)
#include "piop_memopt.h"
#define ComputePAlpha ComputePAlpha_memopt
#define RecomputePAlpha RecomputePAlpha_memopt
#else
#include "piop_default.h"
#define ComputePAlpha ComputePAlpha_default
#define RecomputePAlpha RecomputePAlpha_default
#endif

#endif /* __PIOP_H__ */
