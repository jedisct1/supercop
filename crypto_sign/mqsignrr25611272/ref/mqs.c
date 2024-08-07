#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "mqs_config.h"
#include "mqs_keypair.h"
#include "mqs.h"
#include "blas.h"
#include "mqs_blas.h"
#include "utils_prng.h"
#include "utils_hash.h"
#include "utils_malloc.h"

#include "crypto_declassify.h"

#define MAX_ATTEMPT_FRMAT  128
#define _MAX_O  _O
#define _MAX_O_BYTE  _O


static inline
void transpose(uint8_t * r, const uint8_t * a)
{
	for (unsigned i = 0; i < _O; i++) {
		for (unsigned j = 0; j < _O; j++) {
			r[i * _O + j] = a[j * _O + i];
		}
	}
}

int mqrr_sign(uint8_t* signature, const sk_mqrr* sk, const uint8_t* m, const uint32_t mlen)
{
	// allocate temporary storage.
	uint8_t mat[_O * _O_BYTE];
	uint8_t mat_tmp[_O * _O_BYTE];

	uint8_t m_salt_digest[mlen + _SALT_BYTE + _HASH_LEN];
	uint8_t* salt = m_salt_digest + mlen;

	uint8_t ss[32];
	randombytes(ss, 32);

	hash_msg(salt, _SALT_BYTE, ss, _SALT_SOURCE_LEN);

	// setup PRNG
	prng_t prng_sign;
	uint8_t prng_preseed[LEN_SKSEED + _SALT_BYTE];
	memcpy(prng_preseed, sk->sk_seed, LEN_SKSEED);
	memcpy(prng_preseed + LEN_SKSEED, salt, _SALT_BYTE);

	uint8_t prng_seed[_HASH_LEN];
	hash_msg(prng_seed, _HASH_LEN, prng_preseed, LEN_SKSEED + _SALT_BYTE);
	prng_set(&prng_sign, prng_seed, _HASH_LEN);

	// clean
	for (unsigned i = 0; i < LEN_SKSEED + _SALT_BYTE; i++) prng_preseed[i] ^= prng_preseed[i];
	for (unsigned i = 0; i < _HASH_LEN; i++) prng_seed[i] ^= prng_seed[i];

	// roll vinegars.
	uint8_t vinegar[_V_BYTE];
	unsigned n_attempt = 0;
	// unsigned succ = 0;

	uint8_t y[_PUB_N_BYTE];
	uint8_t* x_v = vinegar;
	uint8_t x_o[_O_BYTE];

	uint8_t r_l1_F1[_O_BYTE] = { 0 };
	uint8_t temp_o[_MAX_O_BYTE + 32] = { 0 };

	memcpy(m_salt_digest, m, mlen);										// input: M||salt||
	memcpy(m_salt_digest + mlen + _SALT_BYTE, sk->ph, _HASH_LEN);	// input: M||salt||H(pk)
	
	hash_msg(y, _PUB_M_BYTE, m_salt_digest, mlen + _SALT_BYTE + _HASH_LEN);

	uint8_t temp_mat[_O_BYTE * _O_BYTE] __attribute__((aligned(32)));

	unsigned H_half = _O_BYTE >> 1;
	unsigned H_hh = H_half * H_half;

	uint8_t B[H_hh] __attribute__((aligned(32)));
	uint8_t C[H_hh] __attribute__((aligned(32)));
	uint8_t D[H_hh] __attribute__((aligned(32)));
	uint8_t A_inv[H_hh] __attribute__((aligned(32)));
	uint8_t CA_inv[H_hh] __attribute__((aligned(32)));

	uint8_t temp_vec[_O_BYTE] __attribute__((aligned(32)));
	uint8_t temp_vec2[_O_BYTE] __attribute__((aligned(32)));

rej: ;
	int rr = 1;
	n_attempt++;
	if (MAX_ATTEMPT_FRMAT <= n_attempt)
		goto rej_out;

	prng_gen(&prng_sign, vinegar, _V_BYTE);

	gf256mat_prod(mat_tmp, sk->Fq2, _O * _O, _V, vinegar);

	batch_quad_trimat_eval(r_l1_F1, sk->Fq1, vinegar, _V, _O);
	memcpy(temp_o, r_l1_F1, _O_BYTE);


	rr = gf256mat_solve_linear_eq(mat_tmp, _O_BYTE, B, C, D, A_inv);
	crypto_declassify(&rr,sizeof rr);
	if(!rr)
		goto rej;

// remain part of linear solve
	gf256v_add(temp_o, y, _O_BYTE);

	gf256mat_mul(CA_inv, C, A_inv, H_half); 
	gf256mat_prod(temp_vec + H_half, CA_inv, H_half, H_half, temp_o);
	gf256v_set_zero(temp_vec, H_half);

	gf256v_add(temp_vec, temp_o, _O_BYTE);

	gf256mat_mul(temp_mat, CA_inv, B, H_half);
	gf256v_add(temp_mat, D, H_half * H_half);

	gf256mat_prod(temp_vec2, A_inv, H_half, H_half, temp_vec);

	rr &= gf256mat_gaussian_elim(temp_mat, temp_vec + H_half, H_half);
	crypto_declassify(&rr,sizeof rr);
	if(!rr)
		goto rej;

	gf256mat_back_substitute(temp_vec + H_half, temp_mat, H_half);

  	memcpy(temp_vec2 + H_half, temp_vec + H_half, H_half);

	gf256mat_prod(temp_vec, B, H_half, H_half, temp_vec2 + H_half);

	gf256mat_prod(x_o, A_inv, H_half, H_half, temp_vec);

	gf256v_set_zero(x_o + H_half, H_half);
	gf256v_add(x_o, temp_vec2, _O_BYTE);
// remain part of linear solve

rej_out: ;
	//  w = T^-1 * y
	uint8_t w[_PUB_N_BYTE];
	// identity part of T.
	memcpy(w, x_v, _V_BYTE);
	memcpy(w + _V_BYTE, x_o, _O_BYTE);
	// Computing the t1 part.
	gfmat_prod(y, sk->mat_t, _V_BYTE, _O, w + _V);
	gf256v_add(w, y, _V_BYTE);

	memset(signature, 0, _SIGNATURE_BYTE);  // set the output 0
	// clean
	memset(mat, 0, _O * _O_BYTE);
	memset(&prng_sign, 0, sizeof(prng_t));
	memset(vinegar, 0, _V_BYTE);
	memset(r_l1_F1, 0, _O_BYTE);
	memset(y, 0, _PUB_N_BYTE);
	memset(x_o, 0, _O_BYTE);
	memset(temp_o, 0, sizeof(temp_o));

	// return: copy w and salt to the signature.
	if (MAX_ATTEMPT_FRMAT <= n_attempt) return -1;
	gf256v_add(signature, w, _PUB_N_BYTE);
	gf256v_add(signature + _PUB_N_BYTE, salt, _SALT_BYTE);
	return 0;
}

int mqrr_verify(const uint8_t* m, const uint32_t mlen, const uint8_t* signature, const uint8_t* pk)
{
	// assert(_O>=_O2);
	unsigned char digest_ck[_PUB_M_BYTE];
	mqrr_pubmap(digest_ck, pk, signature);

	unsigned char correct[_PUB_M_BYTE];
	unsigned char m_salt_digest[mlen + _SALT_BYTE + _HASH_LEN];
	memcpy(m_salt_digest, m, mlen);
	memcpy(m_salt_digest + mlen, signature + _PUB_N_BYTE, _SALT_BYTE);
	memcpy(m_salt_digest + mlen + _SALT_BYTE, ((pk_mqs*)pk)->ph, _HASH_LEN);
	hash_msg(correct, _PUB_M_BYTE, m_salt_digest, mlen + _SALT_BYTE + _HASH_LEN);

	unsigned char cc = 0;
	for (unsigned i = 0; i < _PUB_M_BYTE; i++) {
		cc |= (digest_ck[i] ^ correct[i]);
	}

	return (0 == cc) ? 0 : -1;
}