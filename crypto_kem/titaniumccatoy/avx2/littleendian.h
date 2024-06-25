/* ****************************** *
 * Titanium_CCA_toy               *
 * Implemented by Raymond K. ZHAO *
 *                                *
 * Little endian functions        *
 * ****************************** */
 
#ifndef LITTLEENDIAN_H
#define LITTLEENDIAN_H

#include <stdint.h>

static inline uint8_t load_8(const unsigned char *x)
{
	return (*x);
}

static inline void store_8(unsigned char *x, uint8_t c)
{
	*x = c;
}

static inline uint32_t load_24(const unsigned char *x)
{
	return ((uint32_t)(*x)) | (((uint32_t)(*(x + 1))) << 8) | (((uint32_t)(*(x + 2))) << 16);
}

static inline uint32_t load_32(const unsigned char *x)
{
	return *((uint32_t *)x);
}

static inline void store_32(unsigned char *x, uint32_t c)
{
	*((uint32_t *)x) = c;
}

#endif
