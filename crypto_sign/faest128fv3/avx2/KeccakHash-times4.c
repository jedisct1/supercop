/*
The eXtended Keccak Code Package (XKCP)
https://github.com/XKCP/XKCP

Keccak, designed by Guido Bertoni, Joan Daemen, Michaël Peeters and Gilles Van Assche.

Implementation by the designers, hereby denoted as "the implementer".

For more information, feedback or questions, please refer to the Keccak Team website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

#include <string.h>
#include "KeccakHash-times4.h"

/* ---------------------------------------------------------------- */

HashReturn Keccak_HashInitialize_x4(Keccak_HashInstance_x4 *instance, unsigned int rate, unsigned int capacity, unsigned int hashbitlen, unsigned char delimitedSuffix)
{
    HashReturn result;

    if (delimitedSuffix == 0)
        return KECCAK_FAIL;
    result = (HashReturn)KeccakWidth1600x4_SpongeInitialize(&instance->sponge, rate, capacity);
    if (result != KECCAK_SUCCESS)
        return result;
    instance->fixedOutputLength = hashbitlen;
    instance->delimitedSuffix = delimitedSuffix;
    return KECCAK_SUCCESS;
}

/* ---------------------------------------------------------------- */

HashReturn Keccak_HashUpdate_x4(Keccak_HashInstance_x4 *instance, const BitSequence **data, BitLength databitlen)
{
    if ((databitlen % 8) != 0)
        return KECCAK_FAIL;
    return (HashReturn)KeccakWidth1600x4_SpongeAbsorb(&instance->sponge, data, databitlen/8);
}

/* ---------------------------------------------------------------- */

HashReturn Keccak_HashFinal_x4(Keccak_HashInstance_x4 *instance, BitSequence **hashval)
{
    HashReturn ret = (HashReturn)KeccakWidth1600x4_SpongeAbsorbLastFewBits(&instance->sponge, instance->delimitedSuffix);
    if (ret == KECCAK_SUCCESS)
        return (HashReturn)KeccakWidth1600x4_SpongeSqueeze(&instance->sponge, hashval, instance->fixedOutputLength/8);
    else
        return ret;
}

/* ---------------------------------------------------------------- */

HashReturn Keccak_HashSqueeze_x4(Keccak_HashInstance_x4 *instance, BitSequence **data, BitLength databitlen)
{
    if ((databitlen % 8) != 0)
        return KECCAK_FAIL;
    return (HashReturn)KeccakWidth1600x4_SpongeSqueeze(&instance->sponge, data, databitlen/8);
}
