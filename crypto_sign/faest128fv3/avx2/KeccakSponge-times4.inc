/*
Adapted from `KeccakSponge.inc` of:

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

#define JOIN0(a, b)                     a ## b
#define JOIN(a, b)                      JOIN0(a, b)

#define Sponge                          JOIN(prefix, _Sponge)
#define SpongeInstance                  JOIN(prefix, _SpongeInstance)
#define SpongeInitialize                JOIN(prefix, _SpongeInitialize)
#define SpongeAbsorb                    JOIN(prefix, _SpongeAbsorb)
#define SpongeAbsorbLastFewBits         JOIN(prefix, _SpongeAbsorbLastFewBits)
#define SpongeSqueeze                   JOIN(prefix, _SpongeSqueeze)

#define PlSnP_GetFeatures                 JOIN(PlSnP, _GetFeatures)
#define PlSnP_StaticInitialize            JOIN(PlSnP, _StaticInitialize)
#define PlSnP_InitializeAll               JOIN(PlSnP, _InitializeAll)
#define PlSnP_AddByte                     JOIN(PlSnP, _AddByte)
#define PlSnP_AddBytes                    JOIN(PlSnP, _AddBytes)
#define PlSnP_ExtractBytes                JOIN(PlSnP, _ExtractBytes)


/* ---------------------------------------------------------------- */
/* ---------------------------------------------------------------- */
/* ---------------------------------------------------------------- */

int SpongeInitialize(SpongeInstance *instance, unsigned int rate, unsigned int capacity)
{
    if (rate+capacity != PlSnP_width)
        return 1;
    if ((rate <= 0) || (rate > PlSnP_width) || ((rate % 8) != 0))
        return 1;
    PlSnP_StaticInitialize();
    PlSnP_InitializeAll(instance->state);
    instance->rate = rate;
    instance->byteIOIndex = 0;
    instance->squeezing = 0;

    return 0;
}

/* ---------------------------------------------------------------- */

int SpongeAbsorb(SpongeInstance *instance, const unsigned char **data, size_t dataByteLen)
{
    size_t i, j;
    unsigned int partialBlock;
    const unsigned char *curData[4];
    unsigned int rateInBytes = instance->rate/8;

    if (instance->squeezing)
        return 1; /* Too late for additional input */

    i = 0;
    if (dataByteLen > 0)
        memcpy(curData, data, 4 * sizeof(data[0]));
    while(i < dataByteLen) {
        if ((instance->byteIOIndex == 0) && (dataByteLen-i >= rateInBytes)) {
            for(j=dataByteLen-i; j>=rateInBytes; j-=rateInBytes) {
                for(unsigned int instanceIndex = 0; instanceIndex < 4; instanceIndex++) {
                    PlSnP_AddBytes(instance->state, instanceIndex, curData[instanceIndex], 0, rateInBytes);
                    curData[instanceIndex]+=rateInBytes;
                }
                PlSnP_PermuteAll(instance->state);
            }
            i = dataByteLen - j;
        }
        else {
            /* normal lane: using the message queue */
            if (dataByteLen-i > rateInBytes-instance->byteIOIndex)
                partialBlock = rateInBytes-instance->byteIOIndex;
            else
                partialBlock = (unsigned int)(dataByteLen - i);
            i += partialBlock;

            for(unsigned int instanceIndex = 0; instanceIndex < 4; instanceIndex++) {
                PlSnP_AddBytes(instance->state, instanceIndex, curData[instanceIndex], instance->byteIOIndex, partialBlock);
                curData[instanceIndex] += partialBlock;
            }
            instance->byteIOIndex += partialBlock;
            if (instance->byteIOIndex == rateInBytes) {
                PlSnP_PermuteAll(instance->state);
                instance->byteIOIndex = 0;
            }
        }
    }
    return 0;
}

/* ---------------------------------------------------------------- */

int SpongeAbsorbLastFewBits(SpongeInstance *instance, unsigned char delimitedData)
{
    unsigned int rateInBytes = instance->rate/8;

    if (delimitedData == 0)
        return 1;
    if (instance->squeezing)
        return 1; /* Too late for additional input */

    /* Last few bits, whose delimiter coincides with first bit of padding */
    for(unsigned int instanceIndex = 0; instanceIndex < 4; instanceIndex++) {
        PlSnP_AddByte(instance->state, instanceIndex, delimitedData, instance->byteIOIndex);
    }
    /* If the first bit of padding is at position rate-1, we need a whole new block for the second bit of padding */
    if ((delimitedData >= 0x80) && (instance->byteIOIndex == (rateInBytes-1)))
        PlSnP_PermuteAll(instance->state);
    /* Second bit of padding */
    for(unsigned int instanceIndex = 0; instanceIndex < 4; instanceIndex++) {
        PlSnP_AddByte(instance->state, instanceIndex, 0x80, rateInBytes - 1);
    }
    PlSnP_PermuteAll(instance->state);
    instance->byteIOIndex = 0;
    instance->squeezing = 1;
    return 0;
}

/* ---------------------------------------------------------------- */

int SpongeSqueeze(SpongeInstance *instance, unsigned char **data, size_t dataByteLen)
{
    size_t i, j;
    unsigned int partialBlock;
    unsigned int rateInBytes = instance->rate/8;
    unsigned char *curData[4];

    if (!instance->squeezing)
        SpongeAbsorbLastFewBits(instance, 0x01);

    i = 0;
    if (dataByteLen > 0)
        memcpy(curData, data, 4 * sizeof(data[0]));
    while(i < dataByteLen) {
        if ((instance->byteIOIndex == rateInBytes) && (dataByteLen-i >= rateInBytes)) {
            for(j=dataByteLen-i; j>=rateInBytes; j-=rateInBytes) {
                PlSnP_PermuteAll(instance->state);
                for(unsigned int instanceIndex = 0; instanceIndex < 4; instanceIndex++) {
                    PlSnP_ExtractBytes(instance->state, instanceIndex, curData[instanceIndex], 0, rateInBytes);
                    curData[instanceIndex]+=rateInBytes;
                }
            }
            i = dataByteLen - j;
        }
        else {
            /* normal lane: using the message queue */
            if (instance->byteIOIndex == rateInBytes) {
                PlSnP_PermuteAll(instance->state);
                instance->byteIOIndex = 0;
            }
            if (dataByteLen-i > rateInBytes-instance->byteIOIndex)
                partialBlock = rateInBytes-instance->byteIOIndex;
            else
                partialBlock = (unsigned int)(dataByteLen - i);
            i += partialBlock;

            for(unsigned int instanceIndex = 0; instanceIndex < 4; instanceIndex++) {
                PlSnP_ExtractBytes(instance->state, instanceIndex, curData[instanceIndex], instance->byteIOIndex, partialBlock);
                curData[instanceIndex] += partialBlock;
            }
            instance->byteIOIndex += partialBlock;
        }
    }
    return 0;
}

/* ---------------------------------------------------------------- */

#undef Sponge
#undef SpongeInstance
#undef SpongeInitialize
#undef SpongeAbsorb
#undef SpongeAbsorbLastFewBits
#undef SpongeSqueeze
#undef PlSnP_GetFeatures
#undef PlSnP_StaticInitialize
#undef PlSnP_InitializeAll
#undef PlSnP_AddByte
#undef PlSnP_AddBytes
#undef PlSnP_ExtractBytes
