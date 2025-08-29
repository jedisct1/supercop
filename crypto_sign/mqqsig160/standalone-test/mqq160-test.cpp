#include "mqq160-headeronly.h"
#include <chrono>

using namespace mqq160;

constexpr uint8_t kHash[64] = {
    0, 1, 2, 3 , 4, 5, 6, 7, 8, 9,
    10, 11, 12, 13 , 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23 , 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33 , 34, 35, 36, 37, 38, 39,
    40, 41, 42, 43 , 44, 45, 46, 47, 48, 49,
    50, 51, 52, 53 , 54, 55, 56, 57, 58, 59,
    60, 61, 62, 63
};

bool testSigning(const CONTEXT& ctx, const uint8_t hash[64], const uint8_t* desiredSig = nullptr)
{
    uint8_t sigResult[SIGNATURE_SIZE]{};
    signHash(hash, ctx, sigResult);
    return desiredSig ? (0 == memcmp(sigResult, desiredSig, SIGNATURE_SIZE)) : true;
}

int main(int argc, char** argv)
{
    const int kLoops = 10000;
    int desiredLoop = 0;
    uint8_t pk[PUBLICKEY_SIZE]{};
    uint8_t sk[PRIVATEKEY_SIZE]{};
    uint8_t sig[SIGNATURE_SIZE]{};

    int i = 1;
    while(i < argc)
    {
        if (0 == strcmp(argv[i], "-n"))
        {
            ++i;
            if (i < argc)
                desiredLoop = std::strtol(argv[i], nullptr, 10);
        }
    }

    if (desiredLoop < 1)
        desiredLoop = kLoops;

    printf("Initializing ...\n");
    printf("  - Generate key pair\n");
    genKeyPair(pk, sk);
    const CONTEXT ctx(sk);
    printf("  - Generate signature\n");
    signHash(kHash, ctx, sig);
    printf("  - Verify signature\n");
    if (0 != verifyHash(kHash, sig, pk))
    {
        printf("ERROR: fail to verify signature\n");
        return 1;
    }
    printf("  - Done\n");

    printf("Test single sigining ...\n");
    if (!testSigning(ctx, kHash, sig))
    {
        printf("ERROR: test signing failed\n");
        return 1;
    }
    printf("  - Done\n");

    printf("Test sigining performance (%d loops) ...\n", desiredLoop);
    auto signingStart = std::chrono::high_resolution_clock::now();
    for (int i=0; i<desiredLoop; i++)
    {
        testSigning(ctx, kHash, nullptr);
    }
    auto signingStop = std::chrono::high_resolution_clock::now();
    std::chrono::microseconds signingDuration = std::chrono::duration_cast<std::chrono::microseconds>(signingStop - signingStart);
    printf("  - Total: %lld microseconds\n", signingDuration.count());
    double signingAvg = double(signingDuration.count()) / desiredLoop;
    printf("  - Avg: %f microseconds\n", signingAvg);
    printf("  - Done\n");

    printf("Test verifying performance (%d loops) ...\n", desiredLoop);
    auto verifyingStart = std::chrono::high_resolution_clock::now();
    for (int i=0; i<desiredLoop; i++)
    {
        verifyHash(kHash, sig, pk);
    }
    auto verifyingStop = std::chrono::high_resolution_clock::now();
    std::chrono::microseconds verifyingDuration = std::chrono::duration_cast<std::chrono::microseconds>(verifyingStop - verifyingStart);
    printf("  - Total: %lld microseconds\n", verifyingDuration.count());
    double verifyingAvg = double(verifyingDuration.count()) / desiredLoop;
    printf("  - Avg: %f microseconds\n", verifyingAvg);
    printf("  - Done\n");
}