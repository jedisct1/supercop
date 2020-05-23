/**
 * @file reed_solomon.c
 * Constant time implementation of Reed-Solomon codes
 */

#include "fft.h"
#include "gf.h"
#include "reed_solomon.h"
#include "parameters.h"
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#ifdef VERBOSE
#include <stdbool.h>
#include <stdio.h>
#endif

static uint16_t mod(uint16_t i, uint16_t modulus);
static void compute_syndromes(uint16_t* syndromes, uint8_t* cdw);
static size_t compute_elp(uint16_t *sigma, const uint16_t *syndromes);
static void compute_roots(uint8_t* error, uint16_t* error_compact, uint16_t* sigma);
static void compute_z_poly(uint16_t* z, const uint16_t* sigma, const uint8_t degree, const uint16_t* syndromes);
static void compute_error_values(uint16_t* error_values, const uint16_t* z, const uint8_t z_degree, const uint16_t* error_compact);
static void correct_errors(uint8_t* cdw, const uint8_t* error, const uint16_t* error_values);


/**
 * Returns i modulo the given modulus.
 * i must be less than 2*modulus.
 * Therefore, the return value is either i or i-modulus.
 * @returns i mod (modulus)
 * @param[in] i The integer whose modulo is taken
 * @param[in] modulus The modulus
 */
static uint16_t mod(uint16_t i, uint16_t modulus) {
	uint16_t tmp = i - modulus;

	// mask = 0xffff if(i < PARAM_GF_MUL_ORDER)
	int16_t mask = -(tmp >> 15);

	return tmp + (mask & modulus);
}



/**
 * @brief Computes the generator polynomial of the primitive Reed-Solomon code with given parameters.
 *
 * Code length is 2^m-1. <br>
 * PARAM_DELTA is the targeted correction capacity of the code
 * and receives the real correction capacity (which is at least equal to the target). <br>
 * exp and log are arrays giving antilog and log of GF(2^m) elements.
 *
 * @param[out] poly Array of size (2*PARAM_DELTA + 1) receiving the coefficients of the generator polynomial
 */
void compute_generator_poly(uint16_t* poly) {
	poly[0] = 1;
	int tmp_degree = 0;

	for (uint16_t i = 1 ; i < (2 * PARAM_DELTA + 1) ; ++i) {

		for(size_t j = tmp_degree ; j ; --j) {
			poly[j] = exp[mod(log[poly[j]] + i, PARAM_GF_MUL_ORDER)] ^ poly[j - 1];
		}

		poly[0] = exp[mod(log[poly[0]] + i, PARAM_GF_MUL_ORDER)];
		poly[++tmp_degree] = 1;

	}

	printf("\n");
	for (int i = 0 ; i < (PARAM_G) ; ++i) {
		printf("%d, ", poly[i]);
	}
	printf("\n");
}



/**
 * @brief Encodes a message message of PARAM_K bits to a Reed-Solomon codeword codeword of PARAM_N1 bytes
 *
 * Following @cite lin1983error (Chapter 4 - Cyclic Codes),
 * We perform a systematic encoding using a linear (PARAM_N1 - PARAM_K)-stage shift register
 * with feedback connections based on the generator polynomial PARAM_RS_POLY of the Reed-Solomon code.
 *
 * @param[out] cdw Array of size VEC_N1_SIZE_64 receiving the encoded message
 * @param[in] msg Array of size VEC_K_SIZE_64 storing the message
 */
void reed_solomon_encode(uint64_t* cdw, const uint64_t* msg) {
	uint8_t gate_value = 0;

	uint16_t tmp[PARAM_G] = {0};
	uint16_t PARAM_RS_POLY [] = {RS_POLY_COEFS};

	uint8_t msg_bytes[PARAM_K] = {0};
	uint8_t cdw_bytes[PARAM_N1] = {0};

	for (size_t i = 0 ; i < VEC_K_SIZE_64 ; ++i) {
		for (size_t j = 0 ; j < 8 ; ++j) {
			msg_bytes[i * 8 + j] = (uint8_t) (msg[i] >> (j * 8));
		}
	}

	for (int i = PARAM_K-1 ; i >= 0 ; --i) {
		gate_value = msg_bytes[i] ^ cdw_bytes[PARAM_N1 - PARAM_K - 1];

		for (size_t j = 0 ; j < PARAM_G ; ++j) {
			tmp[j] = gf_mul(gate_value, PARAM_RS_POLY[j]);
		}

		for(size_t k = PARAM_N1 - PARAM_K - 1 ; k ; --k) {
			cdw_bytes[k] = cdw_bytes[k - 1] ^ tmp[k];
		}

		cdw_bytes[0] = tmp[0];
	}

	memcpy(cdw_bytes + PARAM_N1 - PARAM_K, msg_bytes, PARAM_K);
	memcpy(cdw, cdw_bytes, PARAM_N1);
}



/**
 * @brief Computes 2 * PARAM_DELTA syndromes
 *
 * @param[out] syndromes Array of size 2 * PARAM_DELTA receiving the computed syndromes
 * @param[in] cdw Array of size PARAM_N1 storing the received vector
 */
void compute_syndromes(uint16_t* syndromes, uint8_t* cdw) {
	uint16_t tmp[PARAM_N1] = {0};

	for (size_t i = 1 ; i < PARAM_N1 ; ++i) {
		tmp[i] = log[cdw[i]];
	}

	for (size_t i = 0 ; i < 2 * PARAM_DELTA ; ++i) {
		for (size_t j = 1 ; j < PARAM_N1 ; ++j) {
			int16_t mask = (tmp[j] >> PARAM_M) - 1;
			syndromes[i] ^= (mask & exp[(tmp[j] + ((i + 1) * j)) % PARAM_GF_MUL_ORDER]);
		}
		syndromes[i] ^= cdw[0];
	}
}



/**
 * @brief Computes the error locator polynomial (ELP) sigma
 *
 * This is a constant time implementation of Berlekamp's simplified algorithm (see @cite lin1983error (Chapter 6 - BCH Codes). <br>
 * We use the letter p for rho which is initialized at -1. <br>
 * The array X_sigma_p represents the polynomial X^(mu-rho)*sigma_p(X). <br>
 * Instead of maintaining a list of sigmas, we update in place both sigma and X_sigma_p. <br>
 * sigma_copy serves as a temporary save of sigma in case X_sigma_p needs to be updated. <br>
 * We can properly correct only if the degree of sigma does not exceed PARAM_DELTA.
 * This means only the first PARAM_DELTA + 1 coefficients of sigma are of value
 * and we only need to save its first PARAM_DELTA - 1 coefficients.
 *
 * @returns the degree of the ELP sigma
 * @param[out] sigma Array of size (at least) PARAM_DELTA receiving the ELP
 * @param[in] syndromes Array of size (at least) 2*PARAM_DELTA storing the syndromes
 */
static size_t compute_elp(uint16_t *sigma, const uint16_t *syndromes) {
	sigma[0] = 1;
	size_t deg_sigma = 0;
	size_t deg_sigma_p = 0;
	uint16_t sigma_copy[PARAM_DELTA + 1] = {0};
	size_t deg_sigma_copy = 0;
	uint16_t X_sigma_p[PARAM_DELTA + 1] = {0,1};
	int32_t pp = -1; // 2*rho
	uint16_t d_p = 1;
	uint16_t d = syndromes[0];

	for (size_t mu = 0 ; (mu < (2 * PARAM_DELTA)) ; ++mu) {
		// Save sigma in case we need it to update X_sigma_p
		memcpy(sigma_copy, sigma, 2 * (PARAM_DELTA));
		deg_sigma_copy = deg_sigma;

		uint16_t dd = gf_mul(d, gf_inverse(d_p));

		for (size_t i = 1 ; (i <= mu + 1) && (i <= PARAM_DELTA) ; ++i) {
			sigma[i] ^= gf_mul(dd, X_sigma_p[i]);
		}

		size_t deg_X = mu - pp;
		size_t deg_X_sigma_p = deg_X + deg_sigma_p;

		// mask1 = 0xffff if(d != 0) and 0 otherwise
		int16_t mask1 = -((uint16_t) - d >> 15);

		// mask2 = 0xffff if(deg_X_sigma_p > deg_sigma) and 0 otherwise
		int16_t mask2 = -((uint16_t) (deg_sigma - deg_X_sigma_p) >> 15);

		// mask12 = 0xffff if the deg_sigma increased and 0 otherwise
		int16_t mask12 = mask1 & mask2;
		deg_sigma = (mask12 & deg_X_sigma_p) ^ (~mask12 & deg_sigma);

		if (mu == (2 * PARAM_DELTA - 1)) {
			break;
		}

		pp = (mask12 & mu) ^ (~mask12 & pp);
		d_p = (mask12 & d) ^ (~mask12 & d_p);
		for (size_t i = PARAM_DELTA ; i ; --i) {
			X_sigma_p[i] = (mask12 & sigma_copy[i - 1]) ^ (~mask12 & X_sigma_p[i - 1]);
		}

		deg_sigma_p = (mask12 & deg_sigma_copy) ^ (~mask12 & deg_sigma_p);
		d = syndromes[mu + 1];

		for (size_t i = 1 ; (i <= mu+1) && (i <= PARAM_DELTA) ; ++i) {
			d ^= gf_mul(sigma[i], syndromes[mu + 1 - i]);
		}
	}

	return deg_sigma;
}



/**
 * @brief Computes the error polynomial error from the error locator polynomial sigma
 *
 * See function fft for more details.
 *
 * @param[out] error Array of 2^PARAM_M elements receiving the error polynomial
 * @param[out] error_compact Array of PARAM_DELTA + PARAM_N1 elements receiving a compact representation of the vector error
 * @param[in] sigma Array of 2^PARAM_FFT elements storing the error locator polynomial
 */
static void compute_roots(uint8_t* error, uint16_t* error_compact, uint16_t* sigma) {
	uint16_t w[1 << PARAM_M] = {0};

	fft(w, sigma, PARAM_DELTA + 1);
	fft_retrieve_error_poly(error, error_compact, w);
}



/**
 * @brief Computes the polynomial z(x)
 *
 * See @cite lin1983error (Chapter 6 - BCH Codes) for more details.
 *
 * @param[out] z Array of PARAM_DELTA + 1 elements receiving the polynomial z(x)
 * @param[in] sigma Array of 2^PARAM_FFT elements storing the error locator polynomial
 * @param[in] degree Integer that is the degree of polynomial sigma
 * @param[in] syndromes Array of 2 * PARAM_DELTA storing the syndromes
 */
static void compute_z_poly(uint16_t* z, const uint16_t* sigma, const uint8_t degree, const uint16_t* syndromes) {
	z[0] = 1;

	for (size_t i = 1 ; i < PARAM_DELTA + 1 ; ++i) {
		int16_t mask2 = -((uint16_t) (i - degree - 1) >> 15);
		z[i] = ((uint16_t)mask2) & sigma[i];
	}

	z[1] ^= syndromes[0];

	for (size_t i = 2 ; i <= PARAM_DELTA ; ++i) {
		int16_t mask2 = -((uint16_t) (i - degree - 1) >> 15);
		z[i] ^= ((uint16_t)mask2 & syndromes[i-1]);

		for (size_t j = 1 ; j < i ; ++j) {
			z[i] ^= ((uint16_t)mask2) & gf_mul(sigma[j], syndromes[i - j - 1]);
		}
	}
}



/**
 * @brief Computes the error values
 *
 * See @cite lin1983error (Chapter 6 - BCH Codes) for more details.
 *
 * @param[out] error_values Array of PARAM_DELTA elements receiving the error values
 * @param[in] z Array of PARAM_DELTA + 1 elements storing the polynomial z(x)
 * @param[in] z_degree Integer that is the degree of polynomial z(x)
 * @param[in] error_compact Array of PARAM_DELTA + PARAM_N1 storing compact representation of the error
 */
static void compute_error_values(uint16_t* error_values, const uint16_t* z, const uint8_t z_degree, const uint16_t* error_compact) {
	for (size_t i = 0 ; i < PARAM_DELTA ; ++i) {
		uint16_t tmp1 = 1;
		uint16_t tmp2 = 1;
		uint16_t inverse = gf_inverse(exp[error_compact[i]]);

		for (size_t j = 1 ; j <= PARAM_DELTA ; ++j) {
			tmp1 ^= gf_mul(exp[(log[inverse] * j) % PARAM_GF_MUL_ORDER] , z[j]);
		}

		for (size_t k = 0 ; k < PARAM_DELTA ; ++k) {
			int16_t val = (int16_t)(i - k);
			int16_t mask1 = val >> 15;
			val^= mask1;
			val-= mask1;
			int16_t mask2 = -((uint16_t) (k - z_degree) >> 15);
			uint16_t mask3 = ((uint16_t)mask2) & ((uint16_t) (-val >> 15) );
			tmp2 = gf_mul(tmp2, (1 ^ ((uint16_t)mask3 & exp [(log[inverse] +  error_compact[k]) % PARAM_GF_MUL_ORDER])));
		}
		error_values[i] = log[exp[((log[tmp1] - log[tmp2]) + PARAM_GF_MUL_ORDER) % PARAM_GF_MUL_ORDER]];
	}
}



/**
 * @brief Correct the errors
 *
 * @param[out] cdw Array of PARAM_N1 elements receiving the corrected vector
 * @param[in] error Array of the error vector
 * @param[in] error_values Array of PARAM_DELTA elements storing the error values
 */
static void correct_errors(uint8_t* cdw, const uint8_t* error, const uint16_t* error_values) {
	int8_t one_pos = -1;

	for (size_t i = 0 ; i < PARAM_N1 ; ++i) {
		one_pos += error[i];
		cdw[i] ^= error[i] * exp[error_values[one_pos * error[i]]];
	}
}



/**
 * @brief Decodes the received word
 *
 * This function relies on six steps:
 *    <ol>
 *    <li> The first step, is the computation of the 2*PARAM_DELTA syndromes.
 *    <li> The second step is the computation of the error-locator polynomial sigma.
 *    <li> The third step, done by additive FFT, is finding the error-locator numbers by calculating the roots of the polynomial sigma and takings their inverses.
 *    <li> The fourth step, is the polynomial z(x).
 *    <li> The fifth step, is the computation of the error values.
 *    <li> The sixth step is the correction of the errors in the received polynomial.
 *    </ol>
 * For a more complete picture on Reed-Solomon decoding, see Shu. Lin and Daniel J. Costello in Error Control Coding: Fundamentals and Applications @cite lin1983error
 *
 * @param[out] msg Array of size VEC_K_SIZE_64 receiving the decoded message
 * @param[in] cdw Array of size VEC_N1_SIZE_64 storing the received word
 */
void reed_solomon_decode(uint64_t* msg, uint64_t* cdw) {
	uint8_t cdw_bytes[PARAM_N1] = {0};
	uint16_t syndromes[2 * PARAM_DELTA] = {0};
	uint16_t sigma[1 << PARAM_FFT] = {0};
	uint8_t error[1 << PARAM_M] = {0};
	uint16_t error_compact[PARAM_DELTA + PARAM_N1] = {0};
	uint16_t z[PARAM_DELTA + 1] = {0};
	uint16_t error_values[PARAM_DELTA] = {0};

	// Copy the vector in an array of bytes
	memcpy(cdw_bytes, cdw, PARAM_N1);

	// Calculate the 2*PARAM_DELTA syndromes
	compute_syndromes(syndromes, cdw_bytes);

	// Compute the error locator polynomial sigma
	// Sigma's degree is at most PARAM_DELTA but the FFT requires the extra room
	size_t deg = compute_elp(sigma, syndromes);

	// Compute the error polynomial error
	compute_roots(error, error_compact, sigma);

	// Compute the polynomial z(x)
	compute_z_poly(z, sigma, deg, syndromes);

	// Compute the error values
	compute_error_values(error_values, z, deg, error_compact);

	// Correct the errors
	correct_errors(cdw_bytes, error, error_values);

	// Retrieve the message from the decoded codeword
	memcpy(msg, cdw_bytes + (PARAM_G - 1) , PARAM_K);

	#ifdef VERBOSE
		printf("\n\nThe syndromes: ");
		for (size_t i = 0 ; i < 2*PARAM_DELTA ; ++i) {
			printf("%u ", syndromes[i]);
		}
		printf("\n\nThe error locator polynomial: sigma(x) = ");
		bool first_coeff = true;
		if (sigma[0]) {
			printf("%u", sigma[0]);
			first_coeff = false;
		}
		for (size_t i = 1 ; i < (1 << PARAM_FFT) ; ++i) {
			if (sigma[i] == 0)
				continue;
			if (!first_coeff)
				printf(" + ");
			first_coeff = false;
			if(sigma[i] != 1)
				printf("%u ", sigma[i]);
			if (i == 1)
				printf("x");
			else
				printf("x^%zu", i);
		}
		if (first_coeff)
			printf("0");

		printf("\n\nThe polynomial: z(x) = ");
		bool first_coeff_1 = true;
		if (z[0]) {
			printf("%u", z[0]);
			first_coeff_1 = false;
		}
		for (size_t i = 1 ; i < (PARAM_DELTA + 1) ; ++i) {
			if (z[i] == 0)
				continue;
			if (!first_coeff_1)
				printf(" + ");
			first_coeff_1 = false;
			if(z[i] != 1)
				printf("%u ", z[i]);
			if (i == 1)
				printf("x");
			else
				printf("x^%zu", i);
		}
		if (first_coeff_1)
			printf("0");

		printf("\n\nThe pairs of (error locator numbers, error values): ");
		size_t j = 0;
		for (size_t i = 0 ; i < PARAM_N1 ; ++i) {
			if(error[i]){
				printf("(%zu, %d) ", i, error_values[j]);
				j++;
			}
		}
		printf("\n");
	#endif
}
