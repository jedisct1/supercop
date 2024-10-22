/*
 * hector/src/config.h version 20080403
 * Peter Schwabe & Peter Birkner
 * Public domain
*/

#ifndef CONFIG_H
#define CONFIG_H

#include "field.h"
#include "divclass.h"
#include <gmp.h>

// Number of dummy field elements we need for addition and doubling
#define NUMBER_OF_DUMMYELTS 40

// The field
extern Kfield K;

// Definition of the curve we are working with, curve equation is of the form y^2 + xy = x^5 + f3x^ 3 + x^2 + f0
extern Kelt f3;
extern Kelt f0;

// Order of the subgroup
extern mpz_t p;
// Size of p in bits
extern size_t size_of_p;

// Global dummy variables, to be used in divisor class addition and doubling:
extern Kelt dummyelts[NUMBER_OF_DUMMYELTS];

// Initalisation functions setting curve parameters
void init_all();

// Free memory of the curve 
void clear_all();

#endif // define CONFIG_H
