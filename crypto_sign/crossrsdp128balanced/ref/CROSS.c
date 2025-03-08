/**
 *
 * Reference ISO-C11 Implementation of CROSS.
 *
 * @version 2.0 (February 2025)
 *
 * Authors listed in alphabetical order:
 * 
 * @author: Alessandro Barenghi <alessandro.barenghi@polimi.it>
 * @author: Marco Gianvecchio <marco.gianvecchio@mail.polimi.it>
 * @author: Patrick Karl <patrick.karl@tum.de>
 * @author: Gerardo Pelosi <gerardo.pelosi@polimi.it>
 * @author: Jonas Schupp <jonas.schupp@tum.de>
 * 
 * 
 * This code is hereby placed in the public domain.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 **/
#include "crypto_sign.h"
#include "namespace.h"
#include "set.h"

#include <assert.h>
#include <stdalign.h>
#include <stdio.h>

#include "CROSS.h"
#include "csprng_hash.h"
#include "fp_arith.h"
#include "merkle_tree.h"
#include "pack_unpack.h"
#include "randombytes.h"
#include "seedtree.h"

#if defined(RSDP)
static
void expand_pk(FP_ELEM V_tr[K][N-K],
               const uint8_t seed_pk[KEYPAIR_SEED_LENGTH_BYTES]){

  /* Expansion of pk->seed, explicit domain separation for CSPRNG as in keygen */
  const uint16_t dsc_csprng_seed_pk = CSPRNG_DOMAIN_SEP_CONST + (3*T+2);

  CSPRNG_STATE_T csprng_state_mat;
  csprng_initialize(&csprng_state_mat, seed_pk, KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_pk);
  csprng_fp_mat(V_tr,&csprng_state_mat);
}
#elif defined(RSDPG)
static
void expand_pk(FP_ELEM V_tr[K][N-K],
               FZ_ELEM W_mat[M][N-M],
               const uint8_t seed_pk[KEYPAIR_SEED_LENGTH_BYTES]){

  /* Expansion of pk->seed, explicit domain separation for CSPRNG as in keygen */
  const uint16_t dsc_csprng_seed_pk = CSPRNG_DOMAIN_SEP_CONST + (3*T+2);

  CSPRNG_STATE_T csprng_state_mat;
  csprng_initialize(&csprng_state_mat, seed_pk, KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_pk);

  csprng_fz_mat(W_mat,&csprng_state_mat);
  csprng_fp_mat(V_tr,&csprng_state_mat);
}
#endif


#if defined(RSDP)
static
void expand_sk(FZ_ELEM e_bar[N],
               FP_ELEM V_tr[K][N-K],
               const uint8_t seed_sk[KEYPAIR_SEED_LENGTH_BYTES]){

  uint8_t seed_e_seed_pk[2][KEYPAIR_SEED_LENGTH_BYTES];

  /* Expansion of sk->seed, explicit domain separation for CSPRNG, as in keygen */
  const uint16_t dsc_csprng_seed_sk = CSPRNG_DOMAIN_SEP_CONST + (3*T+1);

  CSPRNG_STATE_T csprng_state;
  csprng_initialize(&csprng_state, seed_sk, KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_sk);
  csprng_randombytes((uint8_t *)seed_e_seed_pk,
                     2*KEYPAIR_SEED_LENGTH_BYTES,
                     &csprng_state);

  expand_pk(V_tr,seed_e_seed_pk[1]);

  /* Expansion of seede, explicit domain separation for CSPRNG as in keygen */
  const uint16_t dsc_csprng_seed_e = CSPRNG_DOMAIN_SEP_CONST + (3*T+3);

  CSPRNG_STATE_T csprng_state_e_bar;
  csprng_initialize(&csprng_state_e_bar, seed_e_seed_pk[0], KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_e);
  csprng_fz_vec(e_bar,&csprng_state_e_bar);
}
#elif defined(RSDPG)
static
void expand_sk(FZ_ELEM e_bar[N],
               FZ_ELEM e_G_bar[M],
               FP_ELEM V_tr[K][N-K],
               FZ_ELEM W_mat[M][N-M],
               const uint8_t seed_sk[KEYPAIR_SEED_LENGTH_BYTES]){

  uint8_t seed_e_seed_pk[2][KEYPAIR_SEED_LENGTH_BYTES];
  CSPRNG_STATE_T csprng_state;

  /* Expansion of sk->seed, explicit domain separation for CSPRNG, as in keygen */
  const uint16_t dsc_csprng_seed_sk = CSPRNG_DOMAIN_SEP_CONST + (3*T+1);

  csprng_initialize(&csprng_state, seed_sk, KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_sk);
  csprng_randombytes((uint8_t *)seed_e_seed_pk,
                     2*KEYPAIR_SEED_LENGTH_BYTES,
                     &csprng_state);

  expand_pk(V_tr,W_mat,seed_e_seed_pk[1]);

  /* Expansion of seede, explicit domain separation for CSPRNG as in keygen */
  const uint16_t dsc_csprng_seed_e = CSPRNG_DOMAIN_SEP_CONST + (3*T+3);

  CSPRNG_STATE_T csprng_state_e_bar;
  csprng_initialize(&csprng_state_e_bar, seed_e_seed_pk[0], KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_e);
  csprng_fz_inf_w(e_G_bar,&csprng_state_e_bar);
  fz_inf_w_by_fz_matrix(e_bar,e_G_bar,W_mat);
  fz_dz_norm_n(e_bar);
}
#endif


void CROSS_keygen(sk_t *SK,
                  pk_t *PK){
  /* generation of random material for public and private key */
  randombytes(SK->seed_sk,KEYPAIR_SEED_LENGTH_BYTES);

  uint8_t seed_e_seed_pk[2][KEYPAIR_SEED_LENGTH_BYTES];

  /* Expansion of sk->seed, explicit domain separation for CSPRNG */
  const uint16_t dsc_csprng_seed_sk = CSPRNG_DOMAIN_SEP_CONST + (3*T+1);
  
  CSPRNG_STATE_T csprng_state;
  csprng_initialize(&csprng_state, SK->seed_sk, KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_sk);
  csprng_randombytes((uint8_t *)seed_e_seed_pk,
                     2*KEYPAIR_SEED_LENGTH_BYTES,
                     &csprng_state);
  memcpy(PK->seed_pk,seed_e_seed_pk[1],KEYPAIR_SEED_LENGTH_BYTES);

  /* expansion of matrix/matrices */
  FP_ELEM V_tr[K][N-K];
#if defined(RSDP)
  expand_pk(V_tr,PK->seed_pk);
#elif defined(RSDPG)
  FZ_ELEM W_mat[M][N-M];
  expand_pk(V_tr,W_mat,PK->seed_pk);
#endif

  /* expansion of secret key material */ 
  /* Expansion of seede, explicit domain separation for CSPRNG */
  const uint16_t dsc_csprng_seed_e = CSPRNG_DOMAIN_SEP_CONST + (3*T+3);

  CSPRNG_STATE_T csprng_state_e_bar;
  csprng_initialize(&csprng_state_e_bar, seed_e_seed_pk[0], KEYPAIR_SEED_LENGTH_BYTES, dsc_csprng_seed_e);

  FZ_ELEM e_bar[N];
#if defined(RSDP)
  csprng_fz_vec(e_bar,&csprng_state_e_bar);
#elif defined(RSDPG)
  FZ_ELEM e_G_bar[M];
  csprng_fz_inf_w(e_G_bar,&csprng_state_e_bar);
  fz_inf_w_by_fz_matrix(e_bar,e_G_bar,W_mat);
  fz_dz_norm_n(e_bar);
#endif
  /* compute public syndrome */
  FP_ELEM s[N-K];
  restr_vec_by_fp_matrix(s,e_bar,V_tr);
  fp_dz_norm_synd(s);
  pack_fp_syn(PK->s,s);
}

/* sign cannot fail */
void CROSS_sign(const sk_t *SK,
               const char *const m,
               const uint64_t mlen,
               CROSS_sig_t *sig){
    /* Wipe any residual information in the sig structure allocated by the 
     * caller */
    memset(sig,0,sizeof(CROSS_sig_t));
    /* Key material expansion */
    FP_ELEM V_tr[K][N-K];
    FZ_ELEM e_bar[N];
#if defined(RSDP)
    expand_sk(e_bar,V_tr,SK->seed_sk);
#elif defined(RSDPG)
    FZ_ELEM e_G_bar[M];
    FZ_ELEM W_mat[M][N-M];
    expand_sk(e_bar,e_G_bar,V_tr,W_mat,SK->seed_sk);
#endif

    uint8_t root_seed[SEED_LENGTH_BYTES];
    randombytes(root_seed,SEED_LENGTH_BYTES);
    randombytes(sig->salt,SALT_LENGTH_BYTES);

#if defined(NO_TREES)
    unsigned char round_seeds[T*SEED_LENGTH_BYTES] = {0};
    seed_leaves(round_seeds,root_seed,sig->salt);
#else
    uint8_t seed_tree[SEED_LENGTH_BYTES*NUM_NODES_SEED_TREE] = {0};
    gen_seed_tree(seed_tree,root_seed,sig->salt);
    unsigned char round_seeds[T*SEED_LENGTH_BYTES] = {0};
    seed_leaves(round_seeds, seed_tree);
#endif

    FZ_ELEM e_bar_prime[T][N];
    FZ_ELEM v_bar[T][N];
    FP_ELEM u_prime[T][N];
    FP_ELEM s_prime[N-K];

#if defined(RSDP)
    uint8_t cmt_0_i_input[DENSELY_PACKED_FP_SYN_SIZE+
                          DENSELY_PACKED_FZ_VEC_SIZE+
                          SALT_LENGTH_BYTES];
    const int offset_salt = DENSELY_PACKED_FP_SYN_SIZE+DENSELY_PACKED_FZ_VEC_SIZE;
#elif defined(RSDPG)
    FZ_ELEM e_G_bar_prime[M];
    FZ_ELEM v_G_bar[T][M];
    uint8_t cmt_0_i_input[DENSELY_PACKED_FP_SYN_SIZE+
                          DENSELY_PACKED_FZ_RSDP_G_VEC_SIZE+
                          SALT_LENGTH_BYTES];
    const int offset_salt = DENSELY_PACKED_FP_SYN_SIZE+DENSELY_PACKED_FZ_RSDP_G_VEC_SIZE;
#endif
    /* cmt_0_i_input is syndrome || v_bar resp. v_G_bar || salt ; place salt at the end */
    memcpy(cmt_0_i_input+offset_salt, sig->salt, SALT_LENGTH_BYTES);

    uint8_t cmt_1_i_input[SEED_LENGTH_BYTES+
                          SALT_LENGTH_BYTES];
    /* cmt_1_i_input is concat(seed,salt,round index + 2T-1) */
    memcpy(cmt_1_i_input+SEED_LENGTH_BYTES, sig->salt, SALT_LENGTH_BYTES);

    uint8_t cmt_0[T][HASH_DIGEST_LENGTH] = {0};
    uint8_t cmt_1[T*HASH_DIGEST_LENGTH] = {0};

    CSPRNG_STATE_T csprng_state;
    for(uint16_t i = 0; i<T; i++){
        /* CSPRNG is fed with concat(seed,salt,round index) represented
         * as a 2 bytes little endian unsigned integer */
        uint8_t csprng_input[SEED_LENGTH_BYTES+SALT_LENGTH_BYTES];
        memcpy(csprng_input,round_seeds+SEED_LENGTH_BYTES*i,SEED_LENGTH_BYTES);
        memcpy(csprng_input+SEED_LENGTH_BYTES,sig->salt,SALT_LENGTH_BYTES);

        uint16_t domain_sep_csprng = CSPRNG_DOMAIN_SEP_CONST+i+(2*T-1);

        /* expand seed[i] into seed_e and seed_u */
        csprng_initialize(&csprng_state,
                          csprng_input,
                          SEED_LENGTH_BYTES+SALT_LENGTH_BYTES,
                          domain_sep_csprng);
        /* expand e_bar_prime */
#if defined(RSDP)
        csprng_fz_vec(e_bar_prime[i], &csprng_state);
#elif defined(RSDPG)
        csprng_fz_inf_w(e_G_bar_prime, &csprng_state);
        fz_vec_sub_m(v_G_bar[i], e_G_bar, e_G_bar_prime);
        fz_dz_norm_m(v_G_bar[i]);
        fz_inf_w_by_fz_matrix(e_bar_prime[i], e_G_bar_prime, W_mat);
        fz_dz_norm_n(e_bar_prime[i]);
#endif
        fz_vec_sub_n(v_bar[i], e_bar, e_bar_prime[i]);

        FP_ELEM v[N];
        convert_restr_vec_to_fp(v, v_bar[i]);
        fz_dz_norm_n(v_bar[i]);
        /* expand u_prime */
        csprng_fp_vec(u_prime[i], &csprng_state);

        FP_ELEM u[N];
        fp_vec_by_fp_vec_pointwise(u, v, u_prime[i]);
        fp_vec_by_fp_matrix(s_prime, u, V_tr);
        fp_dz_norm_synd(s_prime);

        /* cmt_0_i_input contains s_prime || v_bar resp. v_G_bar || salt */
        pack_fp_syn(cmt_0_i_input,s_prime);

#if defined(RSDP)
        pack_fz_vec(cmt_0_i_input + DENSELY_PACKED_FP_SYN_SIZE, v_bar[i]);
#elif defined(RSDPG)
        pack_fz_rsdp_g_vec(cmt_0_i_input + DENSELY_PACKED_FP_SYN_SIZE, v_G_bar[i]);
#endif
        /* Fixed endianness marshalling of round counter */
        uint16_t domain_sep_hash = HASH_DOMAIN_SEP_CONST+i+(2*T-1);

        hash(cmt_0[i], cmt_0_i_input, sizeof(cmt_0_i_input), domain_sep_hash);
        memcpy(cmt_1_i_input,
               round_seeds+SEED_LENGTH_BYTES*i,
               SEED_LENGTH_BYTES);
        
        hash(&cmt_1[i*HASH_DIGEST_LENGTH], cmt_1_i_input, sizeof(cmt_1_i_input), domain_sep_hash);
    }

    /* vector containing d_0 and d_1 from spec */
    uint8_t digest_cmt0_cmt1[2*HASH_DIGEST_LENGTH];

#if defined(NO_TREES)
    tree_root(digest_cmt0_cmt1, cmt_0);
#else
    uint8_t merkle_tree_0[NUM_NODES_MERKLE_TREE * HASH_DIGEST_LENGTH];
    tree_root(digest_cmt0_cmt1, merkle_tree_0, cmt_0);
#endif
    hash(digest_cmt0_cmt1 + HASH_DIGEST_LENGTH, cmt_1, sizeof(cmt_1), HASH_DOMAIN_SEP_CONST);
    hash(sig->digest_cmt, digest_cmt0_cmt1, sizeof(digest_cmt0_cmt1), HASH_DOMAIN_SEP_CONST);

    /* first challenge extraction */
    uint8_t digest_msg_cmt_salt[2*HASH_DIGEST_LENGTH+SALT_LENGTH_BYTES];

    /* place digest_msg at the beginning of the input of the hash generating digest_chall_1 */
    hash(digest_msg_cmt_salt, (uint8_t*) m, mlen, HASH_DOMAIN_SEP_CONST);
    memcpy(digest_msg_cmt_salt+HASH_DIGEST_LENGTH, sig->digest_cmt, HASH_DIGEST_LENGTH);
    memcpy(digest_msg_cmt_salt+2*HASH_DIGEST_LENGTH, sig->salt, SALT_LENGTH_BYTES);

    uint8_t digest_chall_1[HASH_DIGEST_LENGTH];
    hash(digest_chall_1, digest_msg_cmt_salt, sizeof(digest_msg_cmt_salt), HASH_DOMAIN_SEP_CONST);

    // Domain separation unique for expanding chall_1
    const uint16_t dsc_csprng_chall_1 = CSPRNG_DOMAIN_SEP_CONST + (3*T-1);

    FP_ELEM chall_1[T];
    csprng_initialize(&csprng_state, digest_chall_1, sizeof(digest_chall_1), dsc_csprng_chall_1);
    csprng_fp_vec_chall_1(chall_1, &csprng_state);

    /* Computation of the first round of responses */
    FP_ELEM y[T][N];
    for(int i = 0; i < T; i++){
        fp_vec_by_restr_vec_scaled(y[i],
                                   e_bar_prime[i],
                                   chall_1[i],
                                   u_prime[i]);
        fp_dz_norm(y[i]);
    }
    /* y vectors are packed before being hashed */
    uint8_t y_digest_chall_1[T*DENSELY_PACKED_FP_VEC_SIZE+HASH_DIGEST_LENGTH];

    for(int x = 0; x < T; x++){
        pack_fp_vec(y_digest_chall_1+(x*DENSELY_PACKED_FP_VEC_SIZE),y[x]);
    }
    /* Second challenge extraction */
    memcpy(y_digest_chall_1+T*DENSELY_PACKED_FP_VEC_SIZE,digest_chall_1,HASH_DIGEST_LENGTH);

    hash(sig->digest_chall_2, y_digest_chall_1, sizeof(y_digest_chall_1), HASH_DOMAIN_SEP_CONST);

    uint8_t chall_2[T]={0};
    expand_digest_to_fixed_weight(chall_2,sig->digest_chall_2);

    /* Computation of the second round of responses */
#if defined(NO_TREES)
    tree_proof(sig->proof,cmt_0,chall_2);
    seed_path(sig->path,round_seeds,chall_2);
#else
    tree_proof(sig->proof,merkle_tree_0,chall_2);
    seed_path(sig->path,seed_tree,chall_2);
#endif

    int published_rsps = 0;
    for(int i = 0; i<T; i++){
        if(chall_2[i] == 0){
            assert(published_rsps < T-W);
            pack_fp_vec(sig->resp_0[published_rsps].y, y[i]);
#if defined(RSDP)
            pack_fz_vec(sig->resp_0[published_rsps].v_bar, v_bar[i]);
#elif defined(RSDPG)
            pack_fz_rsdp_g_vec(sig->resp_0[published_rsps].v_G_bar, v_G_bar[i]);
#endif
            memcpy(sig->resp_1[published_rsps], &cmt_1[i*HASH_DIGEST_LENGTH], HASH_DIGEST_LENGTH);
            published_rsps++;
        }
    }
}

/* verify returns 1 if signature is ok, 0 otherwise */
int CROSS_verify(const pk_t *const PK,
                 const char *const m,
                 const uint64_t mlen,
                 const CROSS_sig_t *const sig){
    CSPRNG_STATE_T csprng_state;

    FP_ELEM V_tr[K][N-K];
#if defined(RSDP)
    expand_pk(V_tr,PK->seed_pk);
#elif defined(RSDPG)
    FZ_ELEM W_mat[M][N-M];
    expand_pk(V_tr,W_mat,PK->seed_pk);
#endif

    FP_ELEM s[N-K];
    uint8_t is_padd_key_ok;
    is_padd_key_ok = unpack_fp_syn(s,PK->s);

    uint8_t digest_msg_cmt_salt[2*HASH_DIGEST_LENGTH+SALT_LENGTH_BYTES];
    hash(digest_msg_cmt_salt, (uint8_t*) m, mlen, HASH_DOMAIN_SEP_CONST);
    memcpy(digest_msg_cmt_salt+HASH_DIGEST_LENGTH, sig->digest_cmt, HASH_DIGEST_LENGTH);
    memcpy(digest_msg_cmt_salt+2*HASH_DIGEST_LENGTH, sig->salt, SALT_LENGTH_BYTES);

    uint8_t digest_chall_1[HASH_DIGEST_LENGTH];
    hash(digest_chall_1, digest_msg_cmt_salt, sizeof(digest_msg_cmt_salt), HASH_DOMAIN_SEP_CONST);

    // Domain separation unique for expanding digest_chall_1
    const uint16_t dsc_csprng_chall_1 = CSPRNG_DOMAIN_SEP_CONST + (3*T-1);
    csprng_initialize(&csprng_state, digest_chall_1, sizeof(digest_chall_1), dsc_csprng_chall_1);

    FP_ELEM chall_1[T];
    csprng_fp_vec_chall_1(chall_1, &csprng_state);

    uint8_t chall_2[T]={0};
    expand_digest_to_fixed_weight(chall_2,sig->digest_chall_2);

    uint8_t is_stree_padding_ok = 0;
#if defined(NO_TREES)
    uint8_t round_seeds[T*SEED_LENGTH_BYTES] = {0};
    is_stree_padding_ok = rebuild_leaves(round_seeds, chall_2, sig->path);
#else
    uint8_t seed_tree[SEED_LENGTH_BYTES*NUM_NODES_SEED_TREE] = {0};
    is_stree_padding_ok = rebuild_tree(seed_tree, chall_2, sig->path, sig->salt);

    unsigned char round_seeds[T*SEED_LENGTH_BYTES] = {0};
    seed_leaves(round_seeds, seed_tree);
#endif

#if defined(RSDP)
    uint8_t cmt_0_i_input[DENSELY_PACKED_FP_SYN_SIZE+
                          DENSELY_PACKED_FZ_VEC_SIZE+
                          SALT_LENGTH_BYTES];
    const int offset_salt = DENSELY_PACKED_FP_SYN_SIZE+DENSELY_PACKED_FZ_VEC_SIZE;
#elif defined(RSDPG)
    uint8_t cmt_0_i_input[DENSELY_PACKED_FP_SYN_SIZE+
                          DENSELY_PACKED_FZ_RSDP_G_VEC_SIZE+
                          SALT_LENGTH_BYTES];
    const int offset_salt = DENSELY_PACKED_FP_SYN_SIZE+DENSELY_PACKED_FZ_RSDP_G_VEC_SIZE;
#endif
    /* cmt_0_i_input is syndrome || v_bar resp. v_G_bar || salt */
    memcpy(cmt_0_i_input+offset_salt, sig->salt, SALT_LENGTH_BYTES);

    /* cmt_1_i_input is concat(seed,salt,round index) */
    uint8_t cmt_1_i_input[SEED_LENGTH_BYTES+SALT_LENGTH_BYTES];
    memcpy(cmt_1_i_input+SEED_LENGTH_BYTES, sig->salt, SALT_LENGTH_BYTES);

    uint8_t cmt_0[T][HASH_DIGEST_LENGTH] = {0};
    uint8_t cmt_1[T*HASH_DIGEST_LENGTH] = {0};

    FZ_ELEM e_bar_prime[N];
    FP_ELEM u_prime[N];

    FP_ELEM y_prime[N] = {0};
    FP_ELEM y_prime_H[N-K] = {0};
		FP_ELEM s_prime[N-K] = {0};

    FP_ELEM y[T][N];

    int used_rsps = 0;
    int is_signature_ok = 1;
    uint8_t is_packed_padd_ok = 1;
    for(uint16_t i = 0; i< T; i++){

        uint16_t domain_sep_csprng = CSPRNG_DOMAIN_SEP_CONST + i + (2*T-1);
        uint16_t domain_sep_hash = HASH_DOMAIN_SEP_CONST + i + (2*T-1);

        if(chall_2[i] == 1){
            memcpy(cmt_1_i_input,
                   round_seeds+SEED_LENGTH_BYTES*i,
                   SEED_LENGTH_BYTES);

            hash(&cmt_1[i*HASH_DIGEST_LENGTH],cmt_1_i_input,sizeof(cmt_1_i_input), domain_sep_hash);

            /* CSPRNG is fed with concat(seed,salt,round index) represented
            * as a 2 bytes little endian unsigned integer */
            const int csprng_input_length = SALT_LENGTH_BYTES+SEED_LENGTH_BYTES;
            uint8_t csprng_input[csprng_input_length];
            memcpy(csprng_input+SEED_LENGTH_BYTES,sig->salt,SALT_LENGTH_BYTES);
            memcpy(csprng_input,round_seeds+SEED_LENGTH_BYTES*i,SEED_LENGTH_BYTES);

            /* expand seed[i] into seed_e and seed_u */
            csprng_initialize(&csprng_state, csprng_input, csprng_input_length, domain_sep_csprng);
#if defined(RSDP)
            /* expand e_bar_prime */
            csprng_fz_vec(e_bar_prime, &csprng_state);
#elif defined(RSDPG)
            FZ_ELEM e_G_bar_prime[M];
            csprng_fz_inf_w(e_G_bar_prime, &csprng_state);
            fz_inf_w_by_fz_matrix(e_bar_prime,e_G_bar_prime,W_mat);
            fz_dz_norm_n(e_bar_prime);
#endif
            /* expand u_prime */
            csprng_fp_vec(u_prime, &csprng_state);
            fp_vec_by_restr_vec_scaled(y[i],
                                       e_bar_prime,
                                       chall_1[i],
                                       u_prime);
            fp_dz_norm(y[i]);
        } else {
            /* place y[i] in the buffer for later on hashing */
            is_packed_padd_ok = is_packed_padd_ok &&
                                unpack_fp_vec(y[i], sig->resp_0[used_rsps].y);

            FZ_ELEM v_bar[N];
#if defined(RSDP)
            /*v_bar is memcpy'ed directly into cmt_0 input buffer */
            FZ_ELEM* v_bar_ptr = cmt_0_i_input+DENSELY_PACKED_FP_SYN_SIZE;
            is_packed_padd_ok = is_packed_padd_ok &&
                                unpack_fz_vec(v_bar, sig->resp_0[used_rsps].v_bar);
            memcpy(v_bar_ptr,
                   &sig->resp_0[used_rsps].v_bar,
                   DENSELY_PACKED_FZ_VEC_SIZE);
            is_signature_ok = is_signature_ok &&
                              is_fz_vec_in_restr_group_n(v_bar);
#elif defined(RSDPG)
            /*v_G_bar is memcpy'ed directly into cmt_0 input buffer */
            FZ_ELEM* v_G_bar_ptr = cmt_0_i_input+DENSELY_PACKED_FP_SYN_SIZE;
            memcpy(v_G_bar_ptr,
                   &sig->resp_0[used_rsps].v_G_bar,
                   DENSELY_PACKED_FZ_RSDP_G_VEC_SIZE);
            FZ_ELEM v_G_bar[M];
            is_packed_padd_ok = is_packed_padd_ok &&
                                unpack_fz_rsdp_g_vec(v_G_bar, sig->resp_0[used_rsps].v_G_bar);
            is_signature_ok = is_signature_ok &&
                              is_fz_vec_in_restr_group_m(v_G_bar);
            fz_inf_w_by_fz_matrix(v_bar,v_G_bar,W_mat);

#endif
            memcpy(&cmt_1[i*HASH_DIGEST_LENGTH], sig->resp_1[used_rsps], HASH_DIGEST_LENGTH);
            used_rsps++;

            FP_ELEM v[N];
            convert_restr_vec_to_fp(v,v_bar);
            fp_vec_by_fp_vec_pointwise(y_prime,v,y[i]);
            fp_vec_by_fp_matrix(y_prime_H,y_prime,V_tr);
            fp_dz_norm_synd(y_prime_H);
            fp_synd_minus_fp_vec_scaled(s_prime,
                                        y_prime_H,
                                        chall_1[i],
                                        s);
            fp_dz_norm_synd(s_prime);
            pack_fp_syn(cmt_0_i_input, s_prime);

            hash(cmt_0[i], cmt_0_i_input, sizeof(cmt_0_i_input), domain_sep_hash);
        }
    } /* end for iterating on ZKID iterations */

    #ifndef SKIP_ASSERT
    assert(is_signature_ok);
    #endif

    uint8_t digest_cmt0_cmt1[2*HASH_DIGEST_LENGTH];

    uint8_t is_mtree_padding_ok = recompute_root(digest_cmt0_cmt1,
                                                 cmt_0,
                                                 sig->proof,
                                                 chall_2);
    hash(digest_cmt0_cmt1 + HASH_DIGEST_LENGTH, cmt_1, sizeof(cmt_1), HASH_DOMAIN_SEP_CONST);

    uint8_t digest_cmt_prime[HASH_DIGEST_LENGTH];
    hash(digest_cmt_prime, digest_cmt0_cmt1 ,sizeof(digest_cmt0_cmt1), HASH_DOMAIN_SEP_CONST);

    uint8_t y_digest_chall_1[T*DENSELY_PACKED_FP_VEC_SIZE+HASH_DIGEST_LENGTH];

    for(int x = 0; x < T; x++){
        pack_fp_vec(y_digest_chall_1+(x*DENSELY_PACKED_FP_VEC_SIZE), y[x]);
    }
    memcpy(y_digest_chall_1+T*DENSELY_PACKED_FP_VEC_SIZE, digest_chall_1, HASH_DIGEST_LENGTH);

    uint8_t digest_chall_2_prime[HASH_DIGEST_LENGTH];
    hash(digest_chall_2_prime, y_digest_chall_1, sizeof(y_digest_chall_1), HASH_DOMAIN_SEP_CONST);


    int does_digest_cmt_match = ( memcmp(digest_cmt_prime,
                                        sig->digest_cmt,
                                        HASH_DIGEST_LENGTH) == 0);

    #ifndef SKIP_ASSERT
    assert(does_digest_cmt_match);
    #endif

    int does_digest_chall_2_match = ( memcmp(digest_chall_2_prime,
                                        sig->digest_chall_2,
                                        HASH_DIGEST_LENGTH) == 0);
    #ifndef SKIP_ASSERT
    assert(does_digest_chall_2_match);
    #endif

    is_signature_ok = is_signature_ok &&
                      does_digest_cmt_match &&
                      does_digest_chall_2_match && 
                      is_mtree_padding_ok &&
                      is_stree_padding_ok &&
                      is_padd_key_ok &&
                      is_packed_padd_ok;
    return is_signature_ok;
}
