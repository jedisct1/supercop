#include "blc_memopt.h"
#include "ggm_tree.h"
#include "benchmark.h"

#if defined(SUPERCOP)
#include "crypto_declassify.h"
#endif

#ifndef BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE
/* If not defined by the user, default to 1 */
#define BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE 1
#else
#if BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE > MQOM2_PARAM_NB_EVALS
#error "Error, BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE should be smaller (or equal) to MQOM2_PARAM_NB_EVALS"
#endif
#endif

/* SeedCommit variants
 * NOTE: we factorize the key schedule, the tweaked salt is inside the encryption context
 */
static inline void SeedCommit(enc_ctx *ctx1, enc_ctx *ctx2, const uint8_t seed[MQOM2_PARAM_SEED_SIZE], uint8_t seed_com[2 * MQOM2_PARAM_SEED_SIZE])
{
    uint8_t linortho_seed[MQOM2_PARAM_SEED_SIZE];
    LinOrtho(seed, linortho_seed);
    enc_encrypt_x2(ctx1, ctx2, seed, seed, &seed_com[0], &seed_com[MQOM2_PARAM_SEED_SIZE]);
    /* Xor with LinOrtho seed */
    xor_blocks(&seed_com[0], linortho_seed, &seed_com[0]);
    xor_blocks(&seed_com[MQOM2_PARAM_SEED_SIZE], linortho_seed, &seed_com[MQOM2_PARAM_SEED_SIZE]);

    return;
}

#if defined(BLC_INTERNAL_X4)
static inline void SeedCommit_x4(enc_ctx ctx1[4], enc_ctx ctx2[4], const uint8_t seed[4][MQOM2_PARAM_SEED_SIZE], uint8_t (*seed_com[4])[2 * MQOM2_PARAM_SEED_SIZE])
{
    uint8_t linortho_seed[4][MQOM2_PARAM_SEED_SIZE];
    LinOrtho(seed[0], linortho_seed[0]);
    LinOrtho(seed[1], linortho_seed[1]);
    LinOrtho(seed[2], linortho_seed[2]);
    LinOrtho(seed[3], linortho_seed[3]);

#ifdef USE_ENC_X8
    enc_encrypt_x8(&ctx1[0], &ctx2[0], &ctx1[1], &ctx2[1], &ctx1[2], &ctx2[2], &ctx1[3], &ctx2[3],
		   seed[0], seed[0], seed[1], seed[1], seed[2], seed[2], seed[3], seed[3],
		   &(*seed_com[0])[0], &(*seed_com[0])[MQOM2_PARAM_SEED_SIZE], &(*seed_com[1])[0], &(*seed_com[1])[MQOM2_PARAM_SEED_SIZE],
		   &(*seed_com[2])[0], &(*seed_com[2])[MQOM2_PARAM_SEED_SIZE], &(*seed_com[3])[0], &(*seed_com[3])[MQOM2_PARAM_SEED_SIZE]);
#else
    enc_encrypt_x4(&ctx1[0], &ctx2[0], &ctx1[1], &ctx2[1],
        seed[0], seed[0], seed[1], seed[1],
        &(*seed_com[0])[0], &(*seed_com[0])[MQOM2_PARAM_SEED_SIZE],
        &(*seed_com[1])[0], &(*seed_com[1])[MQOM2_PARAM_SEED_SIZE]);
    enc_encrypt_x4(&ctx1[2], &ctx2[2], &ctx1[3], &ctx2[3],
        seed[2], seed[2], seed[3], seed[3],
        &(*seed_com[2])[0], &(*seed_com[2])[MQOM2_PARAM_SEED_SIZE],
        &(*seed_com[3])[0], &(*seed_com[3])[MQOM2_PARAM_SEED_SIZE]);
#endif
    // Xor with LinOrtho seed
    xor_blocks(&(*seed_com[0])[0], linortho_seed[0], &(*seed_com[0])[0]);
    xor_blocks(&(*seed_com[0])[MQOM2_PARAM_SEED_SIZE], linortho_seed[0], &(*seed_com[0])[MQOM2_PARAM_SEED_SIZE]);
    xor_blocks(&(*seed_com[1])[0], linortho_seed[1], &(*seed_com[1])[0]);
    xor_blocks(&(*seed_com[1])[MQOM2_PARAM_SEED_SIZE], linortho_seed[1], &(*seed_com[1])[MQOM2_PARAM_SEED_SIZE]);
    xor_blocks(&(*seed_com[2])[0], linortho_seed[2], &(*seed_com[2])[0]);
    xor_blocks(&(*seed_com[2])[MQOM2_PARAM_SEED_SIZE], linortho_seed[2], &(*seed_com[2])[MQOM2_PARAM_SEED_SIZE]);
    xor_blocks(&(*seed_com[3])[0], linortho_seed[3], &(*seed_com[3])[0]);
    xor_blocks(&(*seed_com[3])[MQOM2_PARAM_SEED_SIZE], linortho_seed[3], &(*seed_com[3])[MQOM2_PARAM_SEED_SIZE]);

    return;
}
#endif

#define PRG_BLC_SIZE (BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N) + BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA) - MQOM2_PARAM_SEED_SIZE)

int BLC_Commit_memopt(const uint8_t mseed[MQOM2_PARAM_SEED_SIZE], const uint8_t salt[MQOM2_PARAM_SALT_SIZE], const field_base_elt x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)], uint8_t com1[MQOM2_PARAM_DIGEST_SIZE], blc_key_memopt_t* key, field_ext_elt x0[MQOM2_PARAM_TAU][FIELD_EXT_PACKING(MQOM2_PARAM_MQ_N)], field_ext_elt u0[MQOM2_PARAM_TAU][FIELD_EXT_PACKING(MQOM2_PARAM_ETA)], field_ext_elt u1[MQOM2_PARAM_TAU][FIELD_EXT_PACKING(MQOM2_PARAM_ETA)])
{
    int ret = -1;
    uint32_t e, i;

#if defined(BLC_INTERNAL_X4)
    prg_key_sched_cache* prg_cache_x4[4] = {NULL, NULL, NULL, NULL};
#endif
    prg_key_sched_cache* prg_cache = NULL;

    /* The serialization of x */
    uint8_t _x[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)];
    /* Tree rseed PRG salt, set to 0 */
    uint8_t tree_prg_salt[MQOM2_PARAM_SALT_SIZE] = { 0 };

    /* Compute the rseed table */
    ret = PRG(tree_prg_salt, 0, mseed, MQOM2_PARAM_TAU * MQOM2_PARAM_SEED_SIZE, (uint8_t*)key->rseed, NULL); ERR(ret, err);
    /* Compute delta */
    field_base_serialize(x, MQOM2_PARAM_MQ_N, _x); 
    memcpy(key->delta, _x, MQOM2_PARAM_SEED_SIZE);
    memcpy(key->salt, salt, MQOM2_PARAM_SALT_SIZE);

    xof_context xof_ctx_hash_ls_com;
    ret = xof_init(&xof_ctx_hash_ls_com); ERR(ret, err);
    ret = xof_update(&xof_ctx_hash_ls_com, (const uint8_t*) "\x07", 1); ERR(ret, err);

#if defined(BLC_INTERNAL_X4)
    enc_ctx ctx_seed_commit1_x4[4], ctx_seed_commit2_x4[4];
    uint8_t lseed_x4[4][MQOM2_PARAM_SEED_SIZE];
    uint8_t ls_com_x4[4][BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE][MQOM2_PARAM_DIGEST_SIZE];
    uint8_t hash_ls_com_x4[4][MQOM2_PARAM_DIGEST_SIZE];
    uint8_t exp_x4[4*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA))];
    field_base_elt bar_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt bar_u[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_ext_elt tmp_n[FIELD_EXT_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt tmp_eta[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_base_elt acc_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    uint8_t data_folding_x4[MQOM2_PARAM_NB_EVALS_LOG][4*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA))];
    uint8_t acc_x4[4*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA))];
    uint8_t data_folding[MQOM2_PARAM_NB_EVALS_LOG][BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    uint8_t acc[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    #define ctx_seed_commit1 (ctx_seed_commit1_x4[0])
    #define ctx_seed_commit2 (ctx_seed_commit2_x4[0])
    #define lseed (lseed_x4[0])
    #define ls_com (ls_com_x4[0])
    #define hash_ls_com (hash_ls_com_x4[0])
    #define exp (&exp_x4[0])
    xof_context_x4 xof_ctx_x4;
    xof_context xof_ctx;
    ggmtree_ctx_x4_t ggm_tree_x4;
    ggmtree_ctx_t ggm_tree;
#else
    enc_ctx ctx_seed_commit1, ctx_seed_commit2;
    uint8_t lseed[MQOM2_PARAM_SEED_SIZE];
    uint8_t ls_com[BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE][MQOM2_PARAM_DIGEST_SIZE];
    uint8_t hash_ls_com[MQOM2_PARAM_DIGEST_SIZE];
    uint8_t exp[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    field_base_elt bar_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt bar_u[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_ext_elt tmp_n[FIELD_EXT_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt tmp_eta[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_base_elt acc_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    uint8_t data_folding[MQOM2_PARAM_NB_EVALS_LOG][BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    uint8_t acc[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    xof_context xof_ctx;
    ggmtree_ctx_t ggm_tree;
#endif
    uint8_t tweaked_salt[MQOM2_PARAM_SALT_SIZE];

    e = 0;
#if defined(BLC_INTERNAL_X4)
    for(; e+3 < MQOM2_PARAM_TAU; e+=4) {
        /* Initialize the PRG cache when used */
#ifndef NO_BLC_PRG_CACHE
        prg_cache_x4[0] = init_prg_cache(PRG_BLC_SIZE);
        prg_cache_x4[1] = init_prg_cache(PRG_BLC_SIZE);
        prg_cache_x4[2] = init_prg_cache(PRG_BLC_SIZE);
        prg_cache_x4[3] = init_prg_cache(PRG_BLC_SIZE);
#endif

        __BENCHMARK_START__(BS_BLC_EXPAND_TREE);
        const uint32_t es[4] = {e+0, e+1, e+2, e+3};
        ret = GGMTree_InitIncrementalExpansion_x4(&ggm_tree_x4, salt, &key->rseed[e], key->delta, es); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_EXPAND_TREE);

        __BENCHMARK_START__(BS_BLC_SEED_COMMIT);
        TweakSalt(salt, tweaked_salt, 0, e + 0, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[0], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[0], tweaked_salt); ERR(ret, err);
        TweakSalt(salt, tweaked_salt, 0, e + 1, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[1], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[1], tweaked_salt); ERR(ret, err);
        TweakSalt(salt, tweaked_salt, 0, e + 2, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[2], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[2], tweaked_salt); ERR(ret, err);
        TweakSalt(salt, tweaked_salt, 0, e + 3, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[3], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[3], tweaked_salt); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_SEED_COMMIT);

        __BENCHMARK_START__(BS_BLC_XOF);
        ret = xof_init_x4(&xof_ctx_x4); ERR(ret, err);
        const uint8_t *constant_6[4] = { (const uint8_t*) "\x06", (const uint8_t*) "\x06", (const uint8_t*) "\x06", (const uint8_t*) "\x06" };
        ret = xof_update_x4(&xof_ctx_x4, constant_6, 1); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_XOF);

        memset((uint8_t*) data_folding_x4, 0, sizeof(data_folding_x4));
        memset((uint8_t*) acc_x4, 0, sizeof(acc_x4));
        for(i = 0; i < MQOM2_PARAM_NB_EVALS; i++) {
            uint32_t i_mod = i % BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE;
            __BENCHMARK_START__(BS_BLC_EXPAND_TREE);
            GGMTree_GetNextLeaf_x4(&ggm_tree_x4, lseed_x4);
            __BENCHMARK_STOP__(BS_BLC_EXPAND_TREE);

            __BENCHMARK_START__(BS_BLC_SEED_COMMIT);
            uint8_t (*seed_com[4])[2*MQOM2_PARAM_SEED_SIZE] = {
                &ls_com_x4[0][i_mod],
                &ls_com_x4[1][i_mod],
                &ls_com_x4[2][i_mod],
                &ls_com_x4[3][i_mod],
            };
            SeedCommit_x4(&ctx_seed_commit1_x4[0], &ctx_seed_commit2_x4[0], &lseed_x4[0], seed_com);
            __BENCHMARK_STOP__(BS_BLC_SEED_COMMIT);

            if(i_mod == BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE-1) {
                __BENCHMARK_START__(BS_BLC_XOF);
                const uint8_t* ls_com_x4_ptr[4] = {(uint8_t*) ls_com_x4[0], (uint8_t*) ls_com_x4[1], (uint8_t*) ls_com_x4[2], (uint8_t*) ls_com_x4[3]};
                ret = xof_update_x4(&xof_ctx_x4, ls_com_x4_ptr, BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE*MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
                __BENCHMARK_STOP__(BS_BLC_XOF);
            }
            
            __BENCHMARK_START__(BS_BLC_PRG);
            memcpy(exp_x4 + 0*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[0], MQOM2_PARAM_SEED_SIZE);
            memcpy(exp_x4 + 1*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[1], MQOM2_PARAM_SEED_SIZE);
            memcpy(exp_x4 + 2*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[2], MQOM2_PARAM_SEED_SIZE);
            memcpy(exp_x4 + 3*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[3], MQOM2_PARAM_SEED_SIZE);
            uint8_t *exp_ptr[4] = {
                (uint8_t*) (exp_x4 + 0*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE),
                (uint8_t*) (exp_x4 + 1*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE),
                (uint8_t*) (exp_x4 + 2*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE),
                (uint8_t*) (exp_x4 + 3*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE)
            };
            ret = PRG_x4(salt, es, lseed_x4, PRG_BLC_SIZE, exp_ptr, prg_cache_x4, 4); ERR(ret, err);
            __BENCHMARK_STOP__(BS_BLC_PRG);
            
            __BENCHMARK_START__(BS_BLC_ARITH);
            uint8_t j = get_gray_code_bit_position(i);
            field_base_vect_add(acc_x4, exp_x4, acc_x4, 4*(MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU));
            field_base_vect_add(data_folding_x4[j], acc_x4, data_folding_x4[j], 4*(MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU));
            __BENCHMARK_STOP__(BS_BLC_ARITH);
        }
        /* Invalidate the PRG cache */
        destroy_prg_cache(prg_cache_x4[0]); prg_cache_x4[0] = NULL;
        destroy_prg_cache(prg_cache_x4[1]); prg_cache_x4[1] = NULL;
        destroy_prg_cache(prg_cache_x4[2]); prg_cache_x4[2] = NULL;
        destroy_prg_cache(prg_cache_x4[3]); prg_cache_x4[3] = NULL;
        
        __BENCHMARK_START__(BS_BLC_ARITH);
        for(uint32_t e_=0; e_<4; e_++) {
            memset(x0[e+e_], 0, sizeof(x0[e+e_]));
            for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
                field_base_parse(data_folding_x4[j] + e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_MQ_N, bar_x);
                field_ext_base_constant_vect_mult((1<<j), bar_x, tmp_n, MQOM2_PARAM_MQ_N);
                field_ext_vect_add(x0[e+e_], tmp_n, x0[e+e_], MQOM2_PARAM_MQ_N);
            }

            memset(u0[e+e_], 0, sizeof(u0[e+e_]));
            for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
                field_ext_parse(data_folding_x4[j] + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N) + e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_ETA, bar_u);
                field_ext_constant_vect_mult((1<<j), bar_u, tmp_eta, MQOM2_PARAM_ETA);
                field_ext_vect_add(u0[e+e_], tmp_eta, u0[e+e_], MQOM2_PARAM_ETA);
            }
        }

        field_ext_parse(acc_x4 + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N), MQOM2_PARAM_ETA, u1[e + 0]);
        field_ext_parse(acc_x4 + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N) + 1*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_ETA, u1[e + 1]);
        field_ext_parse(acc_x4 + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N) + 2*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_ETA, u1[e + 2]);
        field_ext_parse(acc_x4 + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N) + 3*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_ETA, u1[e + 3]);

        field_base_elt delta_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
        uint8_t serialized_delta_x[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)];
        for(uint32_t e_=0; e_<4; e_++) {
            field_base_parse(&acc_x4[e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA))], MQOM2_PARAM_MQ_N, acc_x);
            field_base_vect_add(x, acc_x, delta_x, MQOM2_PARAM_MQ_N);
            field_base_serialize(delta_x, MQOM2_PARAM_MQ_N, serialized_delta_x);
            memcpy(key->partial_delta_x[e + e_], serialized_delta_x+MQOM2_PARAM_SEED_SIZE, BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE);
        }
        __BENCHMARK_STOP__(BS_BLC_ARITH);

        __BENCHMARK_START__(BS_BLC_XOF);
        uint8_t *hash_ptr[4] = { hash_ls_com_x4[0], hash_ls_com_x4[1], hash_ls_com_x4[2], hash_ls_com_x4[3] };
        ret = xof_squeeze_x4(&xof_ctx_x4, hash_ptr, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[0], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[1], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[2], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[3], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_XOF);
    }
#endif
    for(; e < MQOM2_PARAM_TAU; e++) {
        /* Initialize the PRG cache when used */
#ifndef NO_BLC_PRG_CACHE
        prg_cache = init_prg_cache(PRG_BLC_SIZE);
#endif

        __BENCHMARK_START__(BS_BLC_EXPAND_TREE);
        ret = GGMTree_InitIncrementalExpansion(&ggm_tree, salt, key->rseed[e], key->delta, e); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_EXPAND_TREE);

        __BENCHMARK_START__(BS_BLC_SEED_COMMIT);
        TweakSalt(salt, tweaked_salt, 0, e, 0);
        ret = enc_key_sched(&ctx_seed_commit1, tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2, tweaked_salt); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_SEED_COMMIT);

        __BENCHMARK_START__(BS_BLC_XOF);
        ret = xof_init(&xof_ctx); ERR(ret, err);
        ret = xof_update(&xof_ctx, (const uint8_t*) "\x06", 1); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_XOF);

        memset((uint8_t*) data_folding, 0, sizeof(data_folding));
        memset((uint8_t*) acc, 0, sizeof(acc));
        for(i = 0; i < MQOM2_PARAM_NB_EVALS; i++) {
            uint32_t i_mod = i % BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE;
            __BENCHMARK_START__(BS_BLC_EXPAND_TREE);
            GGMTree_GetNextLeaf(&ggm_tree, lseed);            
            __BENCHMARK_STOP__(BS_BLC_EXPAND_TREE);

            __BENCHMARK_START__(BS_BLC_PRG);
            memcpy(exp, lseed, MQOM2_PARAM_SEED_SIZE);
            ret = PRG(salt, e, lseed, PRG_BLC_SIZE, exp + MQOM2_PARAM_SEED_SIZE, prg_cache); ERR(ret, err);
            __BENCHMARK_STOP__(BS_BLC_PRG);
            
            __BENCHMARK_START__(BS_BLC_ARITH);
            field_base_vect_add(acc, exp, acc, MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU);
            uint8_t j = get_gray_code_bit_position(i);
            field_base_vect_add(data_folding[j], acc, data_folding[j], MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU);
            __BENCHMARK_STOP__(BS_BLC_ARITH);

            __BENCHMARK_START__(BS_BLC_SEED_COMMIT);
            SeedCommit(&ctx_seed_commit1, &ctx_seed_commit2, lseed, ls_com[i_mod]);
            __BENCHMARK_STOP__(BS_BLC_SEED_COMMIT);
            
            if(i_mod == BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE-1) {
                __BENCHMARK_START__(BS_BLC_XOF);
                ret = xof_update(&xof_ctx, (uint8_t*) ls_com, BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE*MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
                __BENCHMARK_STOP__(BS_BLC_XOF);
            }
        }
        /* Invalidate the PRG cache */
        destroy_prg_cache(prg_cache);
        prg_cache = NULL;

        __BENCHMARK_START__(BS_BLC_ARITH);
        memset(x0[e], 0, sizeof(x0[e]));
        for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
            field_base_parse(data_folding[j], MQOM2_PARAM_MQ_N, bar_x);
            field_ext_base_constant_vect_mult((1<<j), bar_x, tmp_n, MQOM2_PARAM_MQ_N);
            field_ext_vect_add(x0[e], tmp_n, x0[e], MQOM2_PARAM_MQ_N);
        }
    
        memset(u0[e], 0, sizeof(u0[e]));
        for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
            field_ext_parse(data_folding[j] + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N), MQOM2_PARAM_ETA, bar_u);
            field_ext_constant_vect_mult((1<<j), bar_u, tmp_eta, MQOM2_PARAM_ETA);
            field_ext_vect_add(u0[e], tmp_eta, u0[e], MQOM2_PARAM_ETA);
        }

        field_base_parse(acc, MQOM2_PARAM_MQ_N, acc_x);
        field_ext_parse(acc + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N), MQOM2_PARAM_ETA, u1[e]);

        field_base_elt delta_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
        uint8_t serialized_delta_x[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)];
        field_base_vect_add(x, acc_x, delta_x, MQOM2_PARAM_MQ_N);
        field_base_serialize(delta_x, MQOM2_PARAM_MQ_N, serialized_delta_x);
        memcpy(key->partial_delta_x[e], serialized_delta_x+MQOM2_PARAM_SEED_SIZE, BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE);
        __BENCHMARK_STOP__(BS_BLC_ARITH);

        __BENCHMARK_START__(BS_BLC_XOF);
        ret = xof_squeeze(&xof_ctx, hash_ls_com, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        __BENCHMARK_STOP__(BS_BLC_XOF);
    }
#if defined(BLC_INTERNAL_X4)
    #undef ctx_seed_commit1
    #undef ctx_seed_commit2
    #undef lseed
    #undef ls_com
    #undef hash_ls_com
    #undef exp
#endif

    __BENCHMARK_START__(BS_BLC_XOF);
    for(e = 0; e < MQOM2_PARAM_TAU; e++) {
        ret = xof_update(&xof_ctx_hash_ls_com, key->partial_delta_x[e], BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE); ERR(ret, err);
    }
    ret = xof_squeeze(&xof_ctx_hash_ls_com, com1, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
    __BENCHMARK_STOP__(BS_BLC_XOF);

    ret = 0;
err:
#if defined(BLC_INTERNAL_X4)
    destroy_prg_cache(prg_cache_x4[0]);
    destroy_prg_cache(prg_cache_x4[1]);
    destroy_prg_cache(prg_cache_x4[2]);
    destroy_prg_cache(prg_cache_x4[3]);
#endif
    destroy_prg_cache(prg_cache);
    return ret;
}

int BLC_Open_memopt(const blc_key_memopt_t* key, const uint16_t i_star[MQOM2_PARAM_TAU], uint8_t opening[MQOM2_PARAM_OPENING_SIZE])
{
    int ret = -1;
    int e;
    enc_ctx ctx_seed_commit1, ctx_seed_commit2;
    uint8_t lseed[MQOM2_PARAM_SEED_SIZE];
    uint8_t tweaked_salt[MQOM2_PARAM_SALT_SIZE];

    uint8_t* path = &opening[0];
    uint8_t* out_ls_com = &opening[MQOM2_PARAM_TAU*MQOM2_PARAM_SEED_SIZE*MQOM2_PARAM_NB_EVALS_LOG];
    uint8_t* partial_delta_x = &opening[MQOM2_PARAM_TAU*(MQOM2_PARAM_SEED_SIZE*MQOM2_PARAM_NB_EVALS_LOG+MQOM2_PARAM_DIGEST_SIZE)];

    for(e = 0; e < MQOM2_PARAM_TAU; e++){
#if defined(SUPERCOP)
        /* XXX: NOTE: we explicitly declassify i_star[e] as it is public data but comes from a dataflow involving secret data
         * through hashing */
	crypto_declassify(&i_star[e], sizeof(i_star[e]));
#endif
        ret = GGMTree_ExpandPath(key->salt, key->rseed[e], key->delta, e, i_star[e], (uint8_t(*)[MQOM2_PARAM_SEED_SIZE]) &path[e*(MQOM2_PARAM_NB_EVALS_LOG*MQOM2_PARAM_SEED_SIZE)], lseed); ERR(ret, err);
        TweakSalt(key->salt, tweaked_salt, 0, e, 0);
        ret = enc_key_sched(&ctx_seed_commit1, tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2, tweaked_salt); ERR(ret, err);
        SeedCommit(&ctx_seed_commit1, &ctx_seed_commit2, lseed, &out_ls_com[e*MQOM2_PARAM_DIGEST_SIZE]);

        memcpy(&partial_delta_x[e*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE)], key->partial_delta_x[e], BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE);
    }

    ret = 0;
err:
    return ret;
}

int BLC_Eval_memopt(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], const uint8_t com1[MQOM2_PARAM_DIGEST_SIZE], const uint8_t opening[MQOM2_PARAM_OPENING_SIZE], const uint16_t i_star[MQOM2_PARAM_TAU], field_ext_elt x_eval[MQOM2_PARAM_TAU][FIELD_EXT_PACKING(MQOM2_PARAM_MQ_N)], field_ext_elt u_eval[MQOM2_PARAM_TAU][FIELD_EXT_PACKING(MQOM2_PARAM_ETA)])
{
    int ret = -1;
    uint32_t e, i;

#if defined(BLC_INTERNAL_X4)
    prg_key_sched_cache* prg_cache_x4[4] = {NULL, NULL, NULL, NULL};
#endif
    prg_key_sched_cache *prg_cache = NULL;

    uint8_t tweaked_salt[MQOM2_PARAM_SALT_SIZE];
    uint8_t com1_[MQOM2_PARAM_DIGEST_SIZE];

    const uint8_t* path = &opening[0];
    const uint8_t* out_ls_com = &opening[MQOM2_PARAM_TAU*MQOM2_PARAM_SEED_SIZE*MQOM2_PARAM_NB_EVALS_LOG];
    const uint8_t* partial_delta_x = &opening[MQOM2_PARAM_TAU*(MQOM2_PARAM_SEED_SIZE*MQOM2_PARAM_NB_EVALS_LOG+MQOM2_PARAM_DIGEST_SIZE)];
    
    xof_context xof_ctx_hash_ls_com;
    ret = xof_init(&xof_ctx_hash_ls_com); ERR(ret, err);
    ret = xof_update(&xof_ctx_hash_ls_com, (const uint8_t*) "\x07", 1); ERR(ret, err);

#if defined(BLC_INTERNAL_X4)
    enc_ctx ctx_seed_commit1_x4[4], ctx_seed_commit2_x4[4];
    uint8_t lseed_x4[4][MQOM2_PARAM_SEED_SIZE];
    uint8_t ls_com_x4[4][BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE][MQOM2_PARAM_DIGEST_SIZE];
    uint8_t hash_ls_com_x4[4][MQOM2_PARAM_DIGEST_SIZE];
    uint8_t exp_x4[4*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA))];
    #define ctx_seed_commit1 (ctx_seed_commit1_x4[0])
    #define ctx_seed_commit2 (ctx_seed_commit2_x4[0])
    #define lseed (lseed_x4[0])
    #define ls_com (ls_com_x4[0])
    #define hash_ls_com (hash_ls_com_x4[0])
    #define exp (&exp_x4[0])
    field_base_elt bar_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt bar_u[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_ext_elt tmp_n[FIELD_EXT_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt tmp_eta[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_base_elt acc_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    uint8_t data_folding_x4[MQOM2_PARAM_NB_EVALS_LOG][4*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA))];
    uint8_t acc_x4[4*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA))];
    uint8_t data_folding[MQOM2_PARAM_NB_EVALS_LOG][BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    uint8_t acc[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    xof_context_x4 xof_ctx_x4;
    xof_context xof_ctx;
    ggmtree_ctx_partial_x4_t ggm_tree_x4;
    ggmtree_ctx_partial_t ggm_tree;
#else
    enc_ctx ctx_seed_commit1, ctx_seed_commit2;
    uint8_t lseed[MQOM2_PARAM_SEED_SIZE];
    uint8_t ls_com[BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE][MQOM2_PARAM_DIGEST_SIZE];
    uint8_t hash_ls_com[MQOM2_PARAM_DIGEST_SIZE];
    uint8_t exp[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    uint8_t data_folding[MQOM2_PARAM_NB_EVALS_LOG][BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    uint8_t acc[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)];
    field_base_elt bar_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt bar_u[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_ext_elt tmp_n[FIELD_EXT_PACKING(MQOM2_PARAM_MQ_N)];
    field_ext_elt tmp_eta[FIELD_EXT_PACKING(MQOM2_PARAM_ETA)];
    field_base_elt acc_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
    xof_context xof_ctx;
    ggmtree_ctx_partial_t ggm_tree;
#endif
    
    e = 0;
#if defined(BLC_INTERNAL_X4)
    for(; e+3 < MQOM2_PARAM_TAU; e+=4){
        /* Initialize the PRG cache when used */
#ifndef NO_BLC_PRG_CACHE
        prg_cache_x4[0] = init_prg_cache(PRG_BLC_SIZE);
        prg_cache_x4[1] = init_prg_cache(PRG_BLC_SIZE);
        prg_cache_x4[2] = init_prg_cache(PRG_BLC_SIZE);
        prg_cache_x4[3] = init_prg_cache(PRG_BLC_SIZE);
#endif

        const uint32_t es[4] = {e+0, e+1, e+2, e+3};
        const uint8_t (*paths[4])[MQOM2_PARAM_NB_EVALS_LOG][MQOM2_PARAM_SEED_SIZE] = {
            (uint8_t(*)[MQOM2_PARAM_NB_EVALS_LOG][MQOM2_PARAM_SEED_SIZE]) &path[(e+0)*(MQOM2_PARAM_NB_EVALS_LOG*MQOM2_PARAM_SEED_SIZE)],
            (uint8_t(*)[MQOM2_PARAM_NB_EVALS_LOG][MQOM2_PARAM_SEED_SIZE]) &path[(e+1)*(MQOM2_PARAM_NB_EVALS_LOG*MQOM2_PARAM_SEED_SIZE)],
            (uint8_t(*)[MQOM2_PARAM_NB_EVALS_LOG][MQOM2_PARAM_SEED_SIZE]) &path[(e+2)*(MQOM2_PARAM_NB_EVALS_LOG*MQOM2_PARAM_SEED_SIZE)],
            (uint8_t(*)[MQOM2_PARAM_NB_EVALS_LOG][MQOM2_PARAM_SEED_SIZE]) &path[(e+3)*(MQOM2_PARAM_NB_EVALS_LOG*MQOM2_PARAM_SEED_SIZE)],
        };
        uint32_t i_star_uint32[4] = {i_star[e+0], i_star[e+1], i_star[e+2], i_star[e+3]};
        ret = GGMTree_InitIncrementalPartialExpansion_x4(&ggm_tree_x4, salt, paths, es, i_star_uint32); ERR(ret, err);

        TweakSalt(salt, tweaked_salt, 0, e + 0, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[0], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[0], tweaked_salt); ERR(ret, err);
        TweakSalt(salt, tweaked_salt, 0, e + 1, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[1], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[1], tweaked_salt); ERR(ret, err);
        TweakSalt(salt, tweaked_salt, 0, e + 2, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[2], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[2], tweaked_salt); ERR(ret, err);
        TweakSalt(salt, tweaked_salt, 0, e + 3, 0);
        ret = enc_key_sched(&ctx_seed_commit1_x4[3], tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2_x4[3], tweaked_salt); ERR(ret, err);

        ret = xof_init_x4(&xof_ctx_x4); ERR(ret, err);
        const uint8_t *constant_6[4] = { (const uint8_t*) "\x06", (const uint8_t*) "\x06", (const uint8_t*) "\x06", (const uint8_t*) "\x06" };
        ret = xof_update_x4(&xof_ctx_x4, constant_6, 1); ERR(ret, err);

        memset((uint8_t*) data_folding_x4, 0, sizeof(data_folding_x4));
        memset((uint8_t*) acc_x4, 0, sizeof(acc_x4));
        for(i = 0; i < MQOM2_PARAM_NB_EVALS; i++) {
            uint32_t i_mod = i % BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE;
            GGMTree_GetNextLeafPartial_x4(&ggm_tree_x4, lseed_x4);

            uint8_t (*seed_com[4])[2*MQOM2_PARAM_SEED_SIZE] = {
                &ls_com_x4[0][i_mod],
                &ls_com_x4[1][i_mod],
                &ls_com_x4[2][i_mod],
                &ls_com_x4[3][i_mod],
            };
            SeedCommit_x4(&ctx_seed_commit1_x4[0], &ctx_seed_commit2_x4[0], &lseed_x4[0], seed_com);
            
            for(uint32_t e_=0; e_<4; e_++) {
                if(i == i_star[e+e_]) {
                    memcpy(ls_com_x4[e_][i_mod], &out_ls_com[(e+e_)*MQOM2_PARAM_DIGEST_SIZE], MQOM2_PARAM_DIGEST_SIZE);
                }
            }

            if(i_mod == BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE-1) {
                const uint8_t* ls_com_x4_ptr[4] = {(uint8_t*) ls_com_x4[0], (uint8_t*) ls_com_x4[1], (uint8_t*) ls_com_x4[2], (uint8_t*) ls_com_x4[3]};
                ret = xof_update_x4(&xof_ctx_x4, ls_com_x4_ptr, BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE*MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
            }

            memcpy(exp_x4 + 0*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[0], MQOM2_PARAM_SEED_SIZE);
            memcpy(exp_x4 + 1*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[1], MQOM2_PARAM_SEED_SIZE);
            memcpy(exp_x4 + 2*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[2], MQOM2_PARAM_SEED_SIZE);
            memcpy(exp_x4 + 3*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), lseed_x4[3], MQOM2_PARAM_SEED_SIZE);
            uint8_t *exp_ptr[4] = {
                (uint8_t*) (exp_x4 + 0*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE),
                (uint8_t*) (exp_x4 + 1*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE),
                (uint8_t*) (exp_x4 + 2*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE),
                (uint8_t*) (exp_x4 + 3*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)) + MQOM2_PARAM_SEED_SIZE)
            };
            ret = PRG_x4(salt, es, lseed_x4, PRG_BLC_SIZE, exp_ptr, prg_cache_x4, 4); ERR(ret, err);
            for(uint32_t e_=0; e_<4; e_++) {
                if(i == i_star[e+e_]) {
                    memset(exp_x4 + e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), 0, MQOM2_PARAM_SEED_SIZE+PRG_BLC_SIZE);
                }
            }

            uint8_t j = get_gray_code_bit_position(i);
            field_base_vect_add(acc_x4, exp_x4, acc_x4, 4*(MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU));
            field_base_vect_add(data_folding_x4[j], acc_x4, data_folding_x4[j], 4*(MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU));
        }
        /* Invalidate the PRG cache */
        destroy_prg_cache(prg_cache_x4[0]); prg_cache_x4[0] = NULL;
        destroy_prg_cache(prg_cache_x4[1]); prg_cache_x4[1] = NULL;
        destroy_prg_cache(prg_cache_x4[2]); prg_cache_x4[2] = NULL;
        destroy_prg_cache(prg_cache_x4[3]); prg_cache_x4[3] = NULL;

        field_ext_elt r[4] = {
            get_evaluation_point(i_star[e+0]), get_evaluation_point(i_star[e+1]),
            get_evaluation_point(i_star[e+2]), get_evaluation_point(i_star[e+3]),
        };

        for(uint32_t e_=0; e_<4; e_++) {
            field_base_elt delta_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
            uint8_t serialized_delta_x[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)];
            memset(serialized_delta_x, 0, MQOM2_PARAM_SEED_SIZE);
            memcpy(serialized_delta_x+MQOM2_PARAM_SEED_SIZE, &partial_delta_x[(e+e_)*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE)], BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE);
            field_base_parse(serialized_delta_x, MQOM2_PARAM_MQ_N, delta_x);

            memset(x_eval[e+e_], 0, sizeof(x_eval[e+e_]));
            for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
                field_base_parse(data_folding_x4[j] + e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_MQ_N, bar_x);
                field_ext_base_constant_vect_mult((1<<j), bar_x, tmp_n, MQOM2_PARAM_MQ_N);
                field_ext_vect_add(x_eval[e+e_], tmp_n, x_eval[e+e_], MQOM2_PARAM_MQ_N);
            }
            field_base_parse(acc_x4 + e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_MQ_N, acc_x);
            field_base_vect_add(acc_x, delta_x, acc_x, MQOM2_PARAM_MQ_N);
            field_ext_base_constant_vect_mult(r[e_], acc_x, tmp_n, MQOM2_PARAM_MQ_N);
            field_ext_vect_add(x_eval[e+e_], tmp_n, x_eval[e+e_], MQOM2_PARAM_MQ_N);

            memset(u_eval[e+e_], 0, sizeof(u_eval[e+e_]));
            for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
                field_ext_parse(data_folding_x4[j] + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N) + e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_ETA, bar_u);
                field_ext_constant_vect_mult((1<<j), bar_u, tmp_eta, MQOM2_PARAM_ETA);
                field_ext_vect_add(u_eval[e+e_], tmp_eta, u_eval[e+e_], MQOM2_PARAM_ETA);
            }
            field_ext_parse(acc_x4 + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N) + e_*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)+BYTE_SIZE_FIELD_EXT(MQOM2_PARAM_ETA)), MQOM2_PARAM_ETA, tmp_eta);
            field_ext_constant_vect_mult(r[e_], tmp_eta, tmp_eta, MQOM2_PARAM_ETA);
            field_ext_vect_add(u_eval[e+e_], tmp_eta, u_eval[e+e_], MQOM2_PARAM_ETA);
        }

        uint8_t *hash_ptr[4] = { hash_ls_com_x4[0], hash_ls_com_x4[1], hash_ls_com_x4[2], hash_ls_com_x4[3] };
        ret = xof_squeeze_x4(&xof_ctx_x4, hash_ptr, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[0], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[1], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[2], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com_x4[3], MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
    }
#endif
    for(; e < MQOM2_PARAM_TAU; e++){
        /* Initialize the PRG cache when used */
#ifndef NO_BLC_PRG_CACHE
        prg_cache = init_prg_cache(PRG_BLC_SIZE);
#endif

        ret = GGMTree_InitIncrementalPartialExpansion(&ggm_tree, salt, (uint8_t(*)[MQOM2_PARAM_SEED_SIZE]) &path[e*(MQOM2_PARAM_NB_EVALS_LOG*MQOM2_PARAM_SEED_SIZE)], e, i_star[e]); ERR(ret, err);

        TweakSalt(salt, tweaked_salt, 0, e, 0);
        ret = enc_key_sched(&ctx_seed_commit1, tweaked_salt); ERR(ret, err);
        tweaked_salt[0] ^= 0x01;
        ret = enc_key_sched(&ctx_seed_commit2, tweaked_salt); ERR(ret, err);

        ret = xof_init(&xof_ctx); ERR(ret, err);
        ret = xof_update(&xof_ctx, (const uint8_t*) "\x06", 1); ERR(ret, err);
                
        memset((uint8_t*) data_folding, 0, sizeof(data_folding));
        memset((uint8_t*) acc, 0, sizeof(acc));
        for(i = 0; i < MQOM2_PARAM_NB_EVALS; i++) {
            uint32_t i_mod = i % BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE;
            GGMTree_GetNextLeafPartial(&ggm_tree, lseed);

            if(i != i_star[e]) {
                memcpy(exp, lseed, MQOM2_PARAM_SEED_SIZE);
                ret = PRG(salt, e, lseed, PRG_BLC_SIZE, exp + MQOM2_PARAM_SEED_SIZE, prg_cache); ERR(ret, err);
            
                SeedCommit(&ctx_seed_commit1, &ctx_seed_commit2, lseed, ls_com[i_mod]);
            } else {
                memset(exp, 0, MQOM2_PARAM_SEED_SIZE + PRG_BLC_SIZE);
                memcpy(ls_com[i_mod], &out_ls_com[e*MQOM2_PARAM_DIGEST_SIZE], MQOM2_PARAM_DIGEST_SIZE);
            }

            field_base_vect_add(acc, exp, acc, MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU);
            uint8_t j = get_gray_code_bit_position(i);
            field_base_vect_add(data_folding[j], acc, data_folding[j], MQOM2_PARAM_MQ_N+MQOM2_PARAM_ETA*MQOM2_PARAM_MU);

            if(i_mod == BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE-1) {
                ret = xof_update(&xof_ctx, (uint8_t*) ls_com, BLC_NB_SEED_COMMITMENTS_PER_HASH_UPDATE*MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
            }
        }
        /* Invalidate the PRG cache */
        destroy_prg_cache(prg_cache);
        prg_cache = NULL;

        field_ext_elt r = get_evaluation_point(i_star[e]);

        field_base_elt delta_x[FIELD_BASE_PACKING(MQOM2_PARAM_MQ_N)];
        uint8_t serialized_delta_x[BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)];
        memset(serialized_delta_x, 0, MQOM2_PARAM_SEED_SIZE);
        memcpy(serialized_delta_x+MQOM2_PARAM_SEED_SIZE, &partial_delta_x[e*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE)], BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE);
        field_base_parse(serialized_delta_x, MQOM2_PARAM_MQ_N, delta_x);

        memset(x_eval[e], 0, sizeof(x_eval[e]));
        for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
            field_base_parse(data_folding[j], MQOM2_PARAM_MQ_N, bar_x);
            field_ext_base_constant_vect_mult((1<<j), bar_x, tmp_n, MQOM2_PARAM_MQ_N);
            field_ext_vect_add(x_eval[e], tmp_n, x_eval[e], MQOM2_PARAM_MQ_N);
        }
        field_base_parse(acc, MQOM2_PARAM_MQ_N, acc_x);
        field_base_vect_add(acc_x, delta_x, acc_x, MQOM2_PARAM_MQ_N);
        field_ext_base_constant_vect_mult(r, acc_x, tmp_n, MQOM2_PARAM_MQ_N);
        field_ext_vect_add(x_eval[e], tmp_n, x_eval[e], MQOM2_PARAM_MQ_N);

        memset(u_eval[e], 0, sizeof(u_eval[e]));
        for(uint32_t j=0; j<MQOM2_PARAM_NB_EVALS_LOG; j++) {
            field_ext_parse(data_folding[j] + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N), MQOM2_PARAM_ETA, bar_u);
            field_ext_constant_vect_mult((1<<j), bar_u, tmp_eta, MQOM2_PARAM_ETA);
            field_ext_vect_add(u_eval[e], tmp_eta, u_eval[e], MQOM2_PARAM_ETA);
        }
        field_ext_parse(acc + BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N), MQOM2_PARAM_ETA, tmp_eta);
        field_ext_constant_vect_mult(r, tmp_eta, tmp_eta, MQOM2_PARAM_ETA);
        field_ext_vect_add(u_eval[e], tmp_eta, u_eval[e], MQOM2_PARAM_ETA);

        ret = xof_squeeze(&xof_ctx, hash_ls_com, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
        ret = xof_update(&xof_ctx_hash_ls_com, hash_ls_com, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);
    }

    for(e = 0; e < MQOM2_PARAM_TAU; e++) {
        ret = xof_update(&xof_ctx_hash_ls_com, &partial_delta_x[e*(BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE)], BYTE_SIZE_FIELD_BASE(MQOM2_PARAM_MQ_N)-MQOM2_PARAM_SEED_SIZE); ERR(ret, err);
    }
    ret = xof_squeeze(&xof_ctx_hash_ls_com, com1_, MQOM2_PARAM_DIGEST_SIZE); ERR(ret, err);

    if(memcmp(com1, com1_, MQOM2_PARAM_DIGEST_SIZE) != 0) {
        ret = -1;
        goto err;
    }
    
    ret = 0;
err:
    destroy_prg_cache(prg_cache);
    return ret;
}
