#ifdef __AVX2__
#include "aes_impl.cpp"
#elifdef __aarch64__
#include "aes_impl.cpp"
#else
#error "unsupported architecture"
#endif

namespace faest {

template <secpar S, size_t num_keys, uint32_t num_blocks>
inline void aes_keygen_impl(
    aes_round_keys<S>* __restrict__ aeses,
    const block_secpar<S>* __restrict__ keys,
    block128* __restrict__ output)
{
    aes_keygen_state<S> keygen_states[(num_keys + KEYGEN_WIDTH - 1) / KEYGEN_WIDTH];
    aes_keygen_init(keygen_states, aeses, keys, num_keys);

    constexpr auto round_start = []
    {
        if constexpr (S == secpar::s128 || S == secpar::s192)
        {
            return 1;
        }
        else if constexpr (S == secpar::s256)
        {
            return 2;
        }
        else
        {
            static_assert(false, "unsupported security parameter for AES");
        }
    }();
    constexpr auto round_end = AES_ROUNDS<S> - round_start;
    constexpr auto unroll_rounds = []
    {
        if constexpr (S == secpar::s128)
        {
            return 1;
        }
        else if constexpr (S == secpar::s192)
        {
            return 3;
        }
        else if constexpr (S == secpar::s256)
        {
            return 2;
        }
        else
        {
            static_assert(false, "unsupported security parameter for AES");
        }
    }();

    // Separate out the first and last rounds, as they work differently.
    aes_round(aeses, output, num_keys, num_blocks, 0);
    if (round_start > 1)
        aes_round(aeses, output, num_keys, num_blocks, 1);

    for (size_t round = round_start; round <= round_end; round += unroll_rounds)
    {
        // Unroll the loop, as the key generation follows a pattern that repeats every unroll_rounds
        // iterations.

        aes_keygen_round(keygen_states, aeses, num_keys, round);
        aes_round(aeses, output, num_keys, num_blocks, round);
        if (unroll_rounds > 1)
        {
            if (round_end < round + 1)
                break;
            aes_keygen_round(keygen_states, aeses, num_keys, round + 1);
            aes_round(aeses, output, num_keys, num_blocks, round + 1);
        }
        if (unroll_rounds > 2)
        {
            if (round_end < round + 2)
                break;
            aes_keygen_round(keygen_states, aeses, num_keys, round + 2);
            aes_round(aeses, output, num_keys, num_blocks, round + 2);
        }
    }

    aes_keygen_round(keygen_states, aeses, num_keys, round_end + 1);
    aes_round(aeses, output, num_keys, num_blocks, round_end + 1);
    if (round_end + 2 <= AES_ROUNDS<S>)
    {
        aes_keygen_round(keygen_states, aeses, num_keys, round_end + 2);
        aes_round(aeses, output, num_keys, num_blocks, round_end + 2);
    }
}

// Generate all explicit template instantiations.
#define DEF_AES_KEYGEN_IMPL_SKB(secparam, num_keys, num_blocks)                                    \
    template void aes_keygen_impl<secparam, num_keys, num_blocks>(                                 \
        aes_round_keys<secparam>* __restrict__ aeses,                                              \
        const block_secpar<secparam>* __restrict__ keys, block128* __restrict__ output);
#define DEF_AES_KEYGEN_IMPL_SK(secparam, num_keys)                                                 \
    DEF_AES_KEYGEN_IMPL_SKB(secparam, num_keys, 1)                                                 \
    DEF_AES_KEYGEN_IMPL_SKB(secparam, num_keys, 2)                                                 \
    DEF_AES_KEYGEN_IMPL_SKB(secparam, num_keys, 3)                                                 \
    DEF_AES_KEYGEN_IMPL_SKB(secparam, num_keys, 4)
#define DEF_AES_KEYGEN_IMPL_S(secparam)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 1)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 2)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 3)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 4)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 5)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 6)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 7)                                                            \
    DEF_AES_KEYGEN_IMPL_SK(secparam, 8)

DEF_AES_KEYGEN_IMPL_S(secpar::s128)
DEF_AES_KEYGEN_IMPL_S(secpar::s192)
DEF_AES_KEYGEN_IMPL_S(secpar::s256)

template <secpar S> void aes_keygen(aes_round_keys<S>* round_keys, block_secpar<S> key)
{
    // There are more efficient ways to run the key schedule on a single key, but this function
    // isn't used much anyway.
    block128 empty_output;
    aes_keygen_impl<S, 1, 0>(round_keys, &key, &empty_output);
}
template void aes_keygen<secpar::s128>(aes_round_keys<secpar::s128>* round_keys,
                                       block_secpar<secpar::s128> key);
template void aes_keygen<secpar::s192>(aes_round_keys<secpar::s192>* round_keys,
                                       block_secpar<secpar::s192> key);
template void aes_keygen<secpar::s256>(aes_round_keys<secpar::s256>* round_keys,
                                       block_secpar<secpar::s256> key);

}
