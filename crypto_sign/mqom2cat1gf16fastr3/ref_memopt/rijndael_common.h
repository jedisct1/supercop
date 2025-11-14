#ifndef __RIJNDAEL_COMMON_H__
#define __RIJNDAEL_COMMON_H__

/* Common includes for all the implementation variants of
 * Rijndael */
#include <stdint.h>
#include <string.h>

typedef enum {
    AES128 = 0, /* Actually Rijndael_128_128 */
    AES256 = 1, /* Actually Rijndael_128_256  */
    RIJNDAEL_256_256 = 2,
} rijndael_type;

#endif /* __RIJNDAEL_COMMON_H__ */
