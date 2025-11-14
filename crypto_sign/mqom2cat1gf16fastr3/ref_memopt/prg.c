#include "prg.h"

static inline int prg_key_sched(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], uint32_t e, uint32_t i, enc_ctx *ctx, prg_key_sched_cache *cache)
{
    int ret = -1;
    uint8_t tweaked_salt[MQOM2_PARAM_SALT_SIZE];

    if(is_entry_active_prg_cache(cache, i)){
        /* The cache line is active, get the value and return */
        get_entry_prg_cache(cache, i, ctx);
    }
    else{
        /* The cache line is inactive: perform the computation and fill it */
        /* Tweak the salt and perform the key schedule */
        TweakSalt(salt, tweaked_salt, 3, e, i);
        ret = enc_key_sched(ctx, tweaked_salt); ERR(ret, err);
        set_entry_prg_cache(cache, i, ctx);
    }

    ret = 0;
err:
    return ret;
}

/* Memory efficient version of the PRG.
 * The idea is to only generate the necessary blocks, with a starting number of bytes
 * and total number of bytes to output.
 */
int PRG_memopt(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], uint32_t e, const uint8_t seed[MQOM2_PARAM_SEED_SIZE], uint32_t start_nbytes, uint32_t nbytes, uint8_t *out_data, uint8_t in_out_leftover[MQOM2_PARAM_SEED_SIZE], prg_key_sched_cache *cache)
{
    int ret = -1;
    uint32_t i, start_block, end_block, treated_bytes;
    enc_ctx ctx;
    uint8_t linortho_seed[MQOM2_PARAM_SEED_SIZE];

    /* Compute Psi(seed) once and for all */
    LinOrtho(seed, linortho_seed);

    start_block = (start_nbytes / MQOM2_PARAM_SEED_SIZE);
    end_block   = ((start_nbytes + nbytes) / MQOM2_PARAM_SEED_SIZE);
    treated_bytes = 0;
    for(i = start_block; i < end_block; i++){
        /* Deal with the beginning leftover */
        if((i == start_block) && (start_nbytes % MQOM2_PARAM_SEED_SIZE)){
		uint32_t to_copy = MQOM2_PARAM_SEED_SIZE - (start_nbytes % MQOM2_PARAM_SEED_SIZE);
		/* Directly use the leftover from a previous computation */
		memcpy(&out_data[treated_bytes], &in_out_leftover[start_nbytes % MQOM2_PARAM_SEED_SIZE], to_copy);
                treated_bytes += to_copy;
        }
        else{
            ret = prg_key_sched(salt, e, i, &ctx, cache); ERR(ret, err);
            ret = enc_encrypt(&ctx, seed, &out_data[treated_bytes]); ERR(ret, err);
            xor_blocks(&out_data[treated_bytes], linortho_seed, &out_data[treated_bytes]);
            treated_bytes += MQOM2_PARAM_SEED_SIZE;
        }
    }
    /* Deal with the possible leftover incomplete block at the end */
    if((nbytes - treated_bytes) % MQOM2_PARAM_SEED_SIZE){
        /* Do we have to recompute the leftover? */
        ret = prg_key_sched(salt, e, i, &ctx, cache); ERR(ret, err);
	ret = enc_encrypt(&ctx, seed, in_out_leftover); ERR(ret, err);
        xor_blocks(in_out_leftover, linortho_seed, in_out_leftover);
	if(treated_bytes == 0){
	        memcpy(&out_data[0], &in_out_leftover[start_nbytes % MQOM2_PARAM_SEED_SIZE], nbytes % MQOM2_PARAM_SEED_SIZE);
	}
	else{
	        memcpy(&out_data[treated_bytes], in_out_leftover, (nbytes - treated_bytes) % MQOM2_PARAM_SEED_SIZE);
	}
    }
   
    ret = 0;
err:
    return ret;
}

int PRG(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], uint32_t e, const uint8_t seed[MQOM2_PARAM_SEED_SIZE], uint32_t nbytes, uint8_t *out_data, prg_key_sched_cache *cache)
{    
    int ret = -1;
    uint32_t i, filled_blocks;
    enc_ctx ctx1, ctx2, ctx3, ctx4;
#ifdef USE_ENC_X8
    enc_ctx ctx5, ctx6, ctx7, ctx8; 
    uint32_t num_blocks = 8;
#else
    uint32_t num_blocks = 4;
#endif
    uint8_t linortho_seed[MQOM2_PARAM_SEED_SIZE];

    /* Compute Psi(seed) once and for all */
    LinOrtho(seed, linortho_seed);

    /* Depending on the number of blocks, exploit the 2x, 4x or 8x variants */
    filled_blocks = 0;
    for(i = 0; i < (nbytes / (num_blocks * MQOM2_PARAM_SEED_SIZE)); i++){
        /* Key schedule */
        ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
        ret = prg_key_sched(salt, e, filled_blocks + 1, &ctx2, cache); ERR(ret, err);
        ret = prg_key_sched(salt, e, filled_blocks + 2, &ctx3, cache); ERR(ret, err);
        ret = prg_key_sched(salt, e, filled_blocks + 3, &ctx4, cache); ERR(ret, err);
#ifdef USE_ENC_X8
        ret = prg_key_sched(salt, e, filled_blocks + 4, &ctx5, cache); ERR(ret, err);
        ret = prg_key_sched(salt, e, filled_blocks + 5, &ctx6, cache); ERR(ret, err);
        ret = prg_key_sched(salt, e, filled_blocks + 6, &ctx7, cache); ERR(ret, err);
        ret = prg_key_sched(salt, e, filled_blocks + 7, &ctx8, cache); ERR(ret, err);
#endif
        /* Encryption */
#ifdef USE_ENC_X8
        ret = enc_encrypt_x8(&ctx1, &ctx2, &ctx3, &ctx4, &ctx5, &ctx6, &ctx7, &ctx8, seed, seed, seed, seed, seed, seed, seed, seed,
            &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)],
            &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)],
	    &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)],
            &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 6)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 7)]); ERR(ret, err);
#else
        ret = enc_encrypt_x4(&ctx1, &ctx2, &ctx3, &ctx4, seed, seed, seed, seed,
            &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)],
            &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]); ERR(ret, err);
#endif
        /* Xor with LinOrtho seed */
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]);
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)]);
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]);
#ifdef USE_ENC_X8
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)]);
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)]);
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 6)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 6)]);
        xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 7)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 7)]);
#endif
        filled_blocks += num_blocks;
    }
    switch((nbytes - (num_blocks * MQOM2_PARAM_SEED_SIZE * i)) / MQOM2_PARAM_SEED_SIZE){
        case 0:{
            /* No remaining block */
            break;
        }
        case 1:{
            /* One remaining block: 1x */
            ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
            ret = enc_encrypt(&ctx1, seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]); ERR(ret, err);
                    /* Xor with LinOrtho seed */
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
            filled_blocks += 1;
            break;
        }
        case 2:{
            /* Two remaining blocks: 2x */
            ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 1, &ctx2, cache); ERR(ret, err);
            ret = enc_encrypt_x2(&ctx1, &ctx2, seed, seed,
                &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]); ERR(ret, err);
                    /* Xor with LinOrtho seed */
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]);
            filled_blocks += 2;
            break;
        }
        case 3:{
            /* Three remaining blocks: 2x and then 1x */
            ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 1, &ctx2, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 2, &ctx3, cache); ERR(ret, err);
            ret = enc_encrypt_x2(&ctx1, &ctx2, seed, seed,
                &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]); ERR(ret, err);
            ret = enc_encrypt(&ctx3, seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)]); ERR(ret, err);
                    /* Xor with LinOrtho seed */
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)]);
            filled_blocks += 3;
            break;
        }
#ifdef USE_ENC_X8
        case 4:{
            /* Four remaining blocks: 4x */
            ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 1, &ctx2, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 2, &ctx3, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 3, &ctx4, cache); ERR(ret, err);
            ret = enc_encrypt_x4(&ctx1, &ctx2, &ctx3, &ctx4, seed, seed, seed, seed,
                &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)],
		&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]); ERR(ret, err);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]);
            filled_blocks += 4;
            break;
        }
        case 5:{
            /* Five remaining blocks: 4x and 1x */
            ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 1, &ctx2, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 2, &ctx3, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 3, &ctx4, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 4, &ctx5, cache); ERR(ret, err);
            ret = enc_encrypt_x4(&ctx1, &ctx2, &ctx3, &ctx4, seed, seed, seed, seed,
                &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)],
		&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]); ERR(ret, err);
            ret = enc_encrypt(&ctx5, seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)]); ERR(ret, err);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)]);
            filled_blocks += 5;
            break;
	}
        case 6:{
            /* Six remaining blocks: 4x and 2x */
            ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 1, &ctx2, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 2, &ctx3, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 3, &ctx4, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 4, &ctx5, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 5, &ctx6, cache); ERR(ret, err);
            ret = enc_encrypt_x4(&ctx1, &ctx2, &ctx3, &ctx4, seed, seed, seed, seed,
                &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)],
		&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]); ERR(ret, err);
            ret = enc_encrypt_x2(&ctx5, &ctx6, seed, seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)]); ERR(ret, err);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)]);
            filled_blocks += 6;
            break;
	}
        case 7:{
            /* Seven remaining blocks: 4x, 2x and 1x */
            ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 1, &ctx2, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 2, &ctx3, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 3, &ctx4, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 4, &ctx5, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 5, &ctx6, cache); ERR(ret, err);
            ret = prg_key_sched(salt, e, filled_blocks + 6, &ctx7, cache); ERR(ret, err);
            ret = enc_encrypt_x4(&ctx1, &ctx2, &ctx3, &ctx4, seed, seed, seed, seed,
                &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)],
		&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]); ERR(ret, err);
            ret = enc_encrypt_x2(&ctx5, &ctx6, seed, seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)], &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)]); ERR(ret, err);
            ret = enc_encrypt(&ctx7, seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 6)]); ERR(ret, err);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 1)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 2)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 3)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 4)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 5)]);
            xor_blocks(&out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 6)], linortho_seed, &out_data[MQOM2_PARAM_SEED_SIZE * (filled_blocks + 6)]);
            filled_blocks += 7;
            break;
	}
#endif
        default:{
            ret = -1;
            goto err;
        }
    }
    /* Deal with the possible leftover incomplete block */
    if(nbytes % MQOM2_PARAM_SEED_SIZE){
        uint8_t leftover[MQOM2_PARAM_SEED_SIZE];
        ret = prg_key_sched(salt, e, filled_blocks    , &ctx1, cache); ERR(ret, err);
        ret = enc_encrypt(&ctx1, seed, leftover); ERR(ret, err);
                /* Xor with LinOrtho seed */
        xor_blocks(leftover, linortho_seed, leftover);
        memcpy(&out_data[MQOM2_PARAM_SEED_SIZE * filled_blocks], leftover, nbytes % MQOM2_PARAM_SEED_SIZE);
    }
    
    ret = 0;
err:
    return ret;
}

int PRG_x4(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], const uint32_t* e, const uint8_t seed[4][MQOM2_PARAM_SEED_SIZE], uint32_t nbytes, uint8_t* out_data[4], prg_key_sched_cache** cache, uint8_t nb_contexts) {
    int ret = -1;
    uint32_t i;
    enc_ctx* ctx[4];
    enc_ctx ctx_data[4];
    uint8_t linortho_seed[4][MQOM2_PARAM_SEED_SIZE];
    if(nb_contexts == 1) {
        ctx[0] = &ctx_data[0];
        ctx[1] = &ctx_data[0];
        ctx[2] = &ctx_data[0];
        ctx[3] = &ctx_data[0];
    } else if(nb_contexts == 4) {
        ctx[0] = &ctx_data[0];
        ctx[1] = &ctx_data[1];
        ctx[2] = &ctx_data[2];
        ctx[3] = &ctx_data[3];
    } else {
        goto err;
    }
    
    /* Compute Psi(seed) once and for all */
    LinOrtho(seed[0], linortho_seed[0]);
    LinOrtho(seed[1], linortho_seed[1]);
    LinOrtho(seed[2], linortho_seed[2]);
    LinOrtho(seed[3], linortho_seed[3]);

    for(i = 0; i < (nbytes / MQOM2_PARAM_SEED_SIZE); i++){
        /* Key schedule */
        if(nb_contexts == 1) {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
        } else {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
            ret = prg_key_sched(salt, e[1], i, ctx[1], cache[1]); ERR(ret, err);
            ret = prg_key_sched(salt, e[2], i, ctx[2], cache[2]); ERR(ret, err);
            ret = prg_key_sched(salt, e[3], i, ctx[3], cache[3]); ERR(ret, err);
        }
        /* Encryption */
        ret = enc_encrypt_x4(ctx[0], ctx[1], ctx[2], ctx[3], seed[0], seed[1], seed[2], seed[3],
            &out_data[0][MQOM2_PARAM_SEED_SIZE * i], &out_data[1][MQOM2_PARAM_SEED_SIZE * i],
            &out_data[2][MQOM2_PARAM_SEED_SIZE * i], &out_data[3][MQOM2_PARAM_SEED_SIZE * i]); ERR(ret, err);
        /* Xor with LinOrtho seed */
        xor_blocks(&out_data[0][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[0], &out_data[0][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[1][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[1], &out_data[1][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[2][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[2], &out_data[2][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[3][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[3], &out_data[3][MQOM2_PARAM_SEED_SIZE * i]);
    }
    /* Deal with the possible leftover incomplete block */
    uint32_t remaining_bytes = nbytes % MQOM2_PARAM_SEED_SIZE;
    if(remaining_bytes){
        uint8_t leftover[4][MQOM2_PARAM_SEED_SIZE];
        if(nb_contexts == 1) {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
        } else {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
            ret = prg_key_sched(salt, e[1], i, ctx[1], cache[1]); ERR(ret, err);
            ret = prg_key_sched(salt, e[2], i, ctx[2], cache[2]); ERR(ret, err);
            ret = prg_key_sched(salt, e[3], i, ctx[3], cache[3]); ERR(ret, err);
        }
        ret = enc_encrypt_x4(ctx[0], ctx[1], ctx[2], ctx[3], seed[0], seed[1], seed[2], seed[3],
            leftover[0], leftover[1], leftover[2], leftover[3]); ERR(ret, err);
        xor_blocks(leftover[0], linortho_seed[0], leftover[0]);
        xor_blocks(leftover[1], linortho_seed[1], leftover[1]);
        xor_blocks(leftover[2], linortho_seed[2], leftover[2]);
        xor_blocks(leftover[3], linortho_seed[3], leftover[3]);
        memcpy(&out_data[0][MQOM2_PARAM_SEED_SIZE * i], leftover[0], remaining_bytes);
        memcpy(&out_data[1][MQOM2_PARAM_SEED_SIZE * i], leftover[1], remaining_bytes);
        memcpy(&out_data[2][MQOM2_PARAM_SEED_SIZE * i], leftover[2], remaining_bytes);
        memcpy(&out_data[3][MQOM2_PARAM_SEED_SIZE * i], leftover[3], remaining_bytes);
    }

    ret = 0;
err:
    return ret;
}

int PRG_x8(const uint8_t salt[MQOM2_PARAM_SALT_SIZE], const uint32_t *e, const uint8_t seed[8][MQOM2_PARAM_SEED_SIZE], uint32_t nbytes, uint8_t* out_data[8], prg_key_sched_cache** cache, uint8_t nb_contexts) {
    int ret = -1;
    uint32_t i;
    enc_ctx* ctx[8];
    enc_ctx ctx_data[8];
    uint8_t linortho_seed[8][MQOM2_PARAM_SEED_SIZE];
    if(nb_contexts == 1) {
        ctx[0] = &ctx_data[0];
        ctx[1] = &ctx_data[0];
        ctx[2] = &ctx_data[0];
        ctx[3] = &ctx_data[0];
        ctx[4] = &ctx_data[0];
        ctx[5] = &ctx_data[0];
        ctx[6] = &ctx_data[0];
        ctx[7] = &ctx_data[0];
    } else if(nb_contexts == 8) {
        ctx[0] = &ctx_data[0];
        ctx[1] = &ctx_data[1];
        ctx[2] = &ctx_data[2];
        ctx[3] = &ctx_data[3];
        ctx[4] = &ctx_data[4];
        ctx[5] = &ctx_data[5];
        ctx[6] = &ctx_data[6];
        ctx[7] = &ctx_data[7];
    } else {
        goto err;
    }

    /* Compute Psi(seed) once and for all */
    LinOrtho(seed[0], linortho_seed[0]);
    LinOrtho(seed[1], linortho_seed[1]);
    LinOrtho(seed[2], linortho_seed[2]);
    LinOrtho(seed[3], linortho_seed[3]);
    LinOrtho(seed[4], linortho_seed[4]);
    LinOrtho(seed[5], linortho_seed[5]);
    LinOrtho(seed[6], linortho_seed[6]);
    LinOrtho(seed[7], linortho_seed[7]);

    for(i = 0; i < (nbytes / MQOM2_PARAM_SEED_SIZE); i++){
        /* Key schedule */
        if(nb_contexts == 1) {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
        } else {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
            ret = prg_key_sched(salt, e[1], i, ctx[1], cache[1]); ERR(ret, err);
            ret = prg_key_sched(salt, e[2], i, ctx[2], cache[2]); ERR(ret, err);
            ret = prg_key_sched(salt, e[3], i, ctx[3], cache[3]); ERR(ret, err);
            ret = prg_key_sched(salt, e[4], i, ctx[4], cache[4]); ERR(ret, err);
            ret = prg_key_sched(salt, e[5], i, ctx[5], cache[5]); ERR(ret, err);
            ret = prg_key_sched(salt, e[6], i, ctx[6], cache[6]); ERR(ret, err);
            ret = prg_key_sched(salt, e[7], i, ctx[7], cache[7]); ERR(ret, err);
        }
        /* Encryption */
#ifdef USE_ENC_X8
	ret = enc_encrypt_x8(ctx[0], ctx[1], ctx[2], ctx[3], ctx[4], ctx[5], ctx[6], ctx[7],
			     seed[0], seed[1], seed[2], seed[3], seed[4], seed[5], seed[6], seed[7],
			     &out_data[0][MQOM2_PARAM_SEED_SIZE * i], &out_data[1][MQOM2_PARAM_SEED_SIZE * i],
		             &out_data[2][MQOM2_PARAM_SEED_SIZE * i], &out_data[3][MQOM2_PARAM_SEED_SIZE * i],
			     &out_data[4][MQOM2_PARAM_SEED_SIZE * i], &out_data[5][MQOM2_PARAM_SEED_SIZE * i],
		             &out_data[6][MQOM2_PARAM_SEED_SIZE * i], &out_data[7][MQOM2_PARAM_SEED_SIZE * i]); ERR(ret, err);
#else
        ret = enc_encrypt_x4(ctx[0], ctx[1], ctx[2], ctx[3], seed[0], seed[1], seed[2], seed[3],
            &out_data[0][MQOM2_PARAM_SEED_SIZE * i], &out_data[1][MQOM2_PARAM_SEED_SIZE * i],
            &out_data[2][MQOM2_PARAM_SEED_SIZE * i], &out_data[3][MQOM2_PARAM_SEED_SIZE * i]); ERR(ret, err);
        ret = enc_encrypt_x4(ctx[4], ctx[5], ctx[6], ctx[7], seed[4], seed[5], seed[6], seed[7],
            &out_data[4][MQOM2_PARAM_SEED_SIZE * i], &out_data[5][MQOM2_PARAM_SEED_SIZE * i],
            &out_data[6][MQOM2_PARAM_SEED_SIZE * i], &out_data[7][MQOM2_PARAM_SEED_SIZE * i]); ERR(ret, err);
#endif
        /* Xor with LinOrtho seed */
        xor_blocks(&out_data[0][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[0], &out_data[0][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[1][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[1], &out_data[1][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[2][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[2], &out_data[2][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[3][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[3], &out_data[3][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[4][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[4], &out_data[4][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[5][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[5], &out_data[5][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[6][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[6], &out_data[6][MQOM2_PARAM_SEED_SIZE * i]);
        xor_blocks(&out_data[7][MQOM2_PARAM_SEED_SIZE * i], linortho_seed[7], &out_data[7][MQOM2_PARAM_SEED_SIZE * i]);
    }
    /* Deal with the possible leftover incomplete block */
    uint32_t remaining_bytes = nbytes % MQOM2_PARAM_SEED_SIZE;
    if(remaining_bytes){
        uint8_t leftover[8][MQOM2_PARAM_SEED_SIZE];
        if(nb_contexts == 1) {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
        } else {
            ret = prg_key_sched(salt, e[0], i, ctx[0], cache[0]); ERR(ret, err);
            ret = prg_key_sched(salt, e[1], i, ctx[1], cache[1]); ERR(ret, err);
            ret = prg_key_sched(salt, e[2], i, ctx[2], cache[2]); ERR(ret, err);
            ret = prg_key_sched(salt, e[3], i, ctx[3], cache[3]); ERR(ret, err);
            ret = prg_key_sched(salt, e[4], i, ctx[4], cache[4]); ERR(ret, err);
            ret = prg_key_sched(salt, e[5], i, ctx[5], cache[5]); ERR(ret, err);
            ret = prg_key_sched(salt, e[6], i, ctx[6], cache[6]); ERR(ret, err);
            ret = prg_key_sched(salt, e[7], i, ctx[7], cache[7]); ERR(ret, err);
        }
#ifdef PRG_ENC_X8
	ret = enc_encrypt_x8(ctx[0], ctx[1], ctx[2], ctx[3], ctx[4], ctx[5], ctx[6], ctx[7],
			     seed[0], seed[1], seed[2], seed[3], seed[4], seed[5], seed[6], seed[7],
		             leftover[0], leftover[1], leftover[2], leftover[3],
			     leftover[4], leftover[5], leftover[6], leftover[7]); ERR(ret, err);
#else
        ret = enc_encrypt_x4(ctx[0], ctx[1], ctx[2], ctx[3], seed[0], seed[1], seed[2], seed[3],
            leftover[0], leftover[1], leftover[2], leftover[3]); ERR(ret, err);
        ret = enc_encrypt_x4(ctx[4], ctx[5], ctx[6], ctx[7], seed[4], seed[5], seed[6], seed[7],
            leftover[4], leftover[5], leftover[6], leftover[7]); ERR(ret, err);
#endif
        xor_blocks(leftover[0], linortho_seed[0], leftover[0]);
        xor_blocks(leftover[1], linortho_seed[1], leftover[1]);
        xor_blocks(leftover[2], linortho_seed[2], leftover[2]);
        xor_blocks(leftover[3], linortho_seed[3], leftover[3]);
        xor_blocks(leftover[4], linortho_seed[4], leftover[4]);
        xor_blocks(leftover[5], linortho_seed[5], leftover[5]);
        xor_blocks(leftover[6], linortho_seed[6], leftover[6]);
        xor_blocks(leftover[7], linortho_seed[7], leftover[7]);
        memcpy(&out_data[0][MQOM2_PARAM_SEED_SIZE * i], leftover[0], remaining_bytes);
        memcpy(&out_data[1][MQOM2_PARAM_SEED_SIZE * i], leftover[1], remaining_bytes);
        memcpy(&out_data[2][MQOM2_PARAM_SEED_SIZE * i], leftover[2], remaining_bytes);
        memcpy(&out_data[3][MQOM2_PARAM_SEED_SIZE * i], leftover[3], remaining_bytes);
        memcpy(&out_data[4][MQOM2_PARAM_SEED_SIZE * i], leftover[4], remaining_bytes);
        memcpy(&out_data[5][MQOM2_PARAM_SEED_SIZE * i], leftover[5], remaining_bytes);
        memcpy(&out_data[6][MQOM2_PARAM_SEED_SIZE * i], leftover[6], remaining_bytes);
        memcpy(&out_data[7][MQOM2_PARAM_SEED_SIZE * i], leftover[7], remaining_bytes);
    }

    ret = 0;
err:
    return ret;
}
