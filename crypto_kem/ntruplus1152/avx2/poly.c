#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "symmetric.h"

/*************************************************
* Name:        crepmod3
*
* Description: Compute modulus 3 operation
*
* Arguments: - poly *a: pointer to intput integer to be reduced
*
* Returns:     integer in {-1,0,1} congruent to a modulo 3.
**************************************************/
static int16_t crepmod3(int16_t a)
{
	a += (a >> 15) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q-1)/2;
	a += (a >> 15) & NTRUPLUS_Q;
	a -= (NTRUPLUS_Q+1)/2;

	a  = (a >> 8) + (a & 255);
	a  = (a >> 4) + (a & 15);
	a  = (a >> 2) + (a & 3);
	a  = (a >> 2) + (a & 3);
	a -= 3;
	a += ((a + 1) >> 15) & 3;
	return a;
}

/*************************************************
* Name:        poly_crepmod3
*
* Description: Compute modulus 3 operation to polynomial
*
* Arguments: - poly *r: pointer to output polynomial
*            - const poly *a: pointer to input polynomial
**************************************************/
void poly_crepmod3(poly *r, const poly *a)
{
	for(int i = 0; i < NTRUPLUS_N; i++)
		r->coeffs[i] = crepmod3(a->coeffs[i]);
}
