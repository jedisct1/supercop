#ifndef _GENSECRETMQS_GF2_H
#define _GENSECRETMQS_GF2_H

#include "prefix_name.h"
#include "MQS_gf2.h"
#include "gf2nx.h"
#include "arch.h"


int PREFIX_NAME(genSecretMQS_gf2_ref)(mqsnv_gf2n MQS, cst_sparse_monic_gf2nx F);

#define genSecretMQS_gf2_ref PREFIX_NAME(genSecretMQS_gf2_ref)


#define genSecretMQS_gf2 genSecretMQS_gf2_ref


#endif

