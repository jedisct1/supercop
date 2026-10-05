/*
Implementation by the Keccak Team, namely, Guido Bertoni, Joan Daemen,
Michael Peeters, Gilles Van Assche and Ronny Van Keer,
hereby denoted as "the implementer".

For more information, feedback or questions, please refer to our website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

#include <string.h>
#include "KeccakHashtimes8.h"

/* ---------------------------------------------------------------- */

WEAK HashReturn Keccak_HashInitializetimes8(Keccak_HashInstancetimes8 *instance,
    unsigned int rate, unsigned int capacity,
    unsigned int hashbitlen, unsigned char delimitedSuffix)
{
	HashReturn result;

	if (delimitedSuffix == 0) {
		return KECCAK_FAIL;
	}
	result = (HashReturn)KeccakWidth1600times8_SpongeInitialize(&instance->sponge, rate, capacity);
	if (result != KECCAK_SUCCESS) {
		return result;
	}
	instance->fixedOutputLength = hashbitlen;
	instance->delimitedSuffix = delimitedSuffix;
	return KECCAK_SUCCESS;
}

/* ---------------------------------------------------------------- */

WEAK HashReturn Keccak_HashUpdatetimes8(Keccak_HashInstancetimes8 *instance,
    const BitSequence **data, BitLength databitlen)
{
	if ((databitlen % 8) != 0) {
		return KECCAK_FAIL;
	}
	return (HashReturn)KeccakWidth1600times8_SpongeAbsorb(&instance->sponge, data, databitlen / 8);
}

/* ---------------------------------------------------------------- */

WEAK HashReturn Keccak_HashFinaltimes8(Keccak_HashInstancetimes8 *instance,
    BitSequence **hashval)
{
	HashReturn ret = (HashReturn)KeccakWidth1600times8_SpongeAbsorbLastFewBits(
	    &instance->sponge, instance->delimitedSuffix);
	if (ret == KECCAK_SUCCESS) {
		return (HashReturn)KeccakWidth1600times8_SpongeSqueeze(
		    &instance->sponge, hashval, instance->fixedOutputLength / 8);
	} else {
		return ret;
	}
}

/* ---------------------------------------------------------------- */

WEAK HashReturn Keccak_HashSqueezetimes8(Keccak_HashInstancetimes8 *instance,
    BitSequence **data, BitLength databitlen)
{
	if ((databitlen % 8) != 0) {
		return KECCAK_FAIL;
	}
	return (HashReturn)KeccakWidth1600times8_SpongeSqueeze(
	    &instance->sponge, data, databitlen / 8);
}
