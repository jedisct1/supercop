#ifdef SUPERCOP
#include "crypto_sign.h"
#else
#include "apiorig.h"
#endif

#define PICNIC_INSTANCE Picnic_L1_UR
#include "sign.c.template"
