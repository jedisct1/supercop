#ifndef rq_h
#define rq_h

#include "modq.h"
#include "small.h"

#define rq_recip3 crypto_core_invsntrup761_jumpdivsteps_rq_recip3


int rq_recip3(modq *,const small *);

#endif
