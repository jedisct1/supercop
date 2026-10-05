#ifndef PRGS_HPP
#define PRGS_HPP

#include "aes.hpp"
#include "parameters.hpp"

namespace faest
{

template <typename T>
struct prg_trait;

template <typename Derived>
struct prg_base
{
    static constexpr secpar secpar_v = prg_trait<Derived>::secpar_v;
    static constexpr size_t PREFERRED_WIDTH_SHIFT = prg_trait<Derived>::PREFERRED_WIDTH_SHIFT;
    static constexpr size_t PREFERRED_WIDTH = 1 << PREFERRED_WIDTH_SHIFT;

    using key_t = block_secpar<secpar_v>; // Key before key schedule
    using expanded_key_t = typename prg_trait<Derived>::expanded_key_t; // Output of key schedule
    using iv_t = typename prg_trait<Derived>::iv_t;
    using block_t = typename prg_trait<Derived>::block_t;
    using tweak_t = typename prg_trait<Derived>::tweak_t;
    using count_t = typename prg_trait<Derived>::count_t;

    // First, given num_keys keys, expand them all into num_keys expanded_keys. Then generate
    // blocks_per_key blocks of output from each, using the IV and num_keys tweaks and initial
    // counters. The first key gives the first blocks_per_key blocks of output, and so on. The
    // second part is equivalent to subsequently running gen(). However, this function does both to
    // allow instruction level parallism between the two parts.
    template <size_t num_keys, count_t blocks_per_key>
    static void init(const key_t* keys, expanded_key_t* expanded_keys,
                     const iv_t& iv, const tweak_t* tweaks, const count_t* counters, block_t* output)
    {
        return Derived::template init_impl<num_keys, blocks_per_key>
            (keys, expanded_keys, iv, tweaks, counters, output);
    }

    // Similar, but using the same initial counter for all keys.
    template <size_t num_keys, size_t blocks_per_key>
    static void init(const key_t* keys, expanded_key_t* expanded_keys,
                     const iv_t& iv, const tweak_t* tweaks, count_t counter, block_t* output)
    {
        std::array<count_t, num_keys> counters;
        counters.fill(counter);
        return init<num_keys, blocks_per_key>(keys, expanded_keys, iv, tweaks, counters.data(), output);
    }

    // Similar, but using the same initial counter and tweak for all keys.
    template <size_t num_keys, size_t blocks_per_key>
    static void init(const key_t* keys, expanded_key_t* expanded_keys,
                     const iv_t& iv, tweak_t tweak, count_t counter, block_t* output)
    {
        std::array<tweak_t, num_keys> tweaks;
        tweaks.fill(tweak);
        return init<num_keys, blocks_per_key>(keys, expanded_keys, iv, tweaks.data(), counter, output);
    }

    // Similar, but for a single key.
    template <size_t blocks>
    static void init(const key_t* keys, expanded_key_t& expanded_key, const iv_t& iv, tweak_t tweak,
                     count_t counter, block_t* output)
    {
        return init<1, blocks>(keys, &expanded_key, iv, tweak, counter, output);
    }

    // Given an IV and num_keys expanded keys, tweaks, and initial counters, generate blocks_per_key
    // blocks of PRG output from each key. The first key gives the first blocks_per_key blocks of
    // output, and so on.
    template <size_t num_keys, count_t blocks_per_key>
    static void gen(const expanded_key_t* expanded_keys, const iv_t& iv, const tweak_t* tweaks,
                    const count_t* counters, block_t* output)
    {
        return Derived::template gen_impl<num_keys, blocks_per_key>
            (expanded_keys, iv, tweaks, counters, output);
    }

    // Similar, but using the same initial counter for all keys.
    template <size_t num_keys, size_t blocks_per_key>
    static void gen(const expanded_key_t* expanded_keys, const iv_t& iv, const tweak_t* tweaks,
                    count_t counter, block_t* output)
    {
        std::array<count_t, num_keys> counters;
        counters.fill(counter);
        return gen<num_keys, blocks_per_key>(expanded_keys, iv, tweaks, counters.data(), output);
    }

    // Similar, but using the same initial counter and tweak for all keys.
    template <size_t num_keys, size_t blocks_per_key>
    static void gen(const expanded_key_t* expanded_keys, const iv_t& iv, tweak_t tweak,
                    count_t counter, block_t* output)
    {
        std::array<tweak_t, num_keys> tweaks;
        tweaks.fill(tweak);
        return gen<num_keys, blocks_per_key>(expanded_keys, iv, tweaks.data(), counter, output);
    }

    // Similar, but for a single key.
    template <size_t blocks>
    static void gen(const expanded_key_t& expanded_key, const iv_t& iv, tweak_t tweak,
                    count_t counter, block_t* output)
    {
        return gen<1, blocks>(&expanded_key, iv, tweak, counter, output);
    }
};

/* Example implementation of prg_base:

struct prg;

struct prg_trait<prg>
{
    using expanded_key_t = aes_round_keys<secpar::s256>; // Output of key schedule
    using iv_t = block128;
    using block_t = block128;
    using tweak_t = uint32_t;
    using count_t = uint32_t;

    static constexpr secpar secpar_v = secpar::s256;

    // log2(Preferred # of blocks to generate at once.)
    static constexpr size_t PREFERRED_WIDTH_SHIFT = 3;
};

struct prg : public prg_base<prg>
{
    // Explicit using declaration so that you can use the types inside init() and gen(). (Otherwise
    // the compiler cannot tell in general whether they are types or values.)
    typedef prg_base<prg> base;
    using typename base::key_t;
    using typename base::expanded_key_t;
    using typename base::iv_t;
    using typename base::block_t;
    using typename base::tweak_t;
    using typename base::count_t;

    template <size_t num_keys, count_t blocks_per_key>
    static void init_impl(const key_t* keys, expanded_key_t* expanded_keys,
                          const iv_t& iv, const tweak_t* tweaks, const count_t* counters, block_t* output);

    template <size_t num_keys, count_t blocks_per_key>
    static void gen_impl(const expanded_key_t* expanded_keys, const iv_t& iv, const tweak_t* tweaks,
                         const count_t* counters, block_t* output);
};
 */

template <secpar S> struct aes_ctr_prg;

template <secpar S>
struct prg_trait<aes_ctr_prg<S>>
{
    using expanded_key_t = aes_round_keys<S>;
    using iv_t = block128;
    using block_t = block128;
    using tweak_t = uint32_t;
    using count_t = uint32_t;

    static constexpr secpar secpar_v = S;
    static constexpr size_t PREFERRED_WIDTH_SHIFT = AES_PREFERRED_WIDTH_SHIFT;
};

template <secpar S>
struct aes_ctr_prg : public prg_base<aes_ctr_prg<S>>
{
    typedef prg_base<aes_ctr_prg> base;
    using typename base::key_t;
    using typename base::expanded_key_t;
    using typename base::iv_t;
    using typename base::block_t;
    using typename base::tweak_t;
    using typename base::count_t;

    template <size_t num_keys, count_t blocks_per_key>
    static void init_impl(const key_t* keys, expanded_key_t* expanded_keys,
                          const iv_t& iv, const tweak_t* tweaks, const count_t* counters,
                          block_t* output)
    {
        build_ecb_input<num_keys, blocks_per_key>(iv, tweaks, counters, output);
        aes_keygen_ecb<S, num_keys, blocks_per_key>(keys, expanded_keys, output);

        //tweak_debug<num_keys, blocks_per_key>(expanded_keys, tweaks, output);
    }

    template <size_t num_keys, count_t blocks_per_key>
    static void gen_impl(const expanded_key_t* expanded_keys, const iv_t& iv, const tweak_t* tweaks,
                         const count_t* counters, block_t* output)
    {
        build_ecb_input<num_keys, blocks_per_key>(iv, tweaks, counters, output);
        aes_ecb<S, num_keys, blocks_per_key>(expanded_keys, output);

        //tweak_debug<num_keys, blocks_per_key>(expanded_keys, tweaks, output);
    }

private:
    template <size_t num_keys, count_t blocks_per_key>
    static void build_ecb_input(const iv_t& __restrict__ iv, const tweak_t* __restrict__ tweaks,
                                const count_t* __restrict__ counters, block_t* __restrict__ ecb_blocks)
    {
        for (size_t i = 0; i < num_keys; ++i)
        {
            tweak_t twk = tweaks[i];
            for (count_t j = 0, cnt = counters[i]; j < blocks_per_key; ++j, ++cnt)
                ecb_blocks[i * blocks_per_key + j] = iv.add32(block_t::set_low_high32(cnt, twk));
        }
    }

    template <size_t num_keys, count_t blocks_per_key>
    static void tweak_debug(const expanded_key_t* expanded_keys, const tweak_t* __restrict__ tweaks,
                            block_t* __restrict__ output)
    {
        if constexpr (S == secpar::s128)
        {
            for (size_t i = 0; i < num_keys; ++i)
            {
                tweak_t twk = tweaks[i];
                block128 shifted_key = {_mm_slli_si128(expanded_keys[i].keys[0].data, 2)};
                for (count_t j = 0; j < blocks_per_key; ++j)
                    output[i * blocks_per_key + j] = shifted_key.add32(block_t::set_low32(twk));
            }
        }
    }
};

template <secpar S> struct rijndael_fixed_key_ctr_prg;

template <secpar S>
struct prg_trait<rijndael_fixed_key_ctr_prg<S>>
{
    using expanded_key_t = block_secpar<S>;
    using iv_t = block_secpar<S>;
    using block_t = block_secpar<S>;
    using tweak_t = uint32_t;
    using count_t = uint32_t;

    static constexpr secpar secpar_v = S;
    static constexpr size_t PREFERRED_WIDTH_SHIFT = FIXED_KEY_PREFERRED_WIDTH_SHIFT<S>;
};

template <secpar S>
struct rijndael_fixed_key_ctr_prg : public prg_base<rijndael_fixed_key_ctr_prg<S>>
{
    typedef prg_base<rijndael_fixed_key_ctr_prg> base;
    using typename base::key_t;
    using typename base::expanded_key_t;
    using typename base::iv_t;
    using typename base::block_t;
    using typename base::tweak_t;
    using typename base::count_t;

    template <size_t num_keys, count_t blocks_per_key>
    static void init_impl(const key_t* keys, expanded_key_t* expanded_keys,
                          const iv_t& iv, const tweak_t* tweaks, const count_t* counters,
                          block_t* output)
    {
        memcpy(expanded_keys, keys, num_keys * sizeof(keys[0]));
        base::template gen<num_keys, blocks_per_key>(expanded_keys, iv, tweaks, counters, output);
    }

    template <size_t num_keys, count_t blocks_per_key>
    static void gen_impl(const expanded_key_t* expanded_keys, const iv_t& iv, const tweak_t* tweaks,
                         const count_t* counters, block_t* output)
    {
        rijndael_fixed_key_ctr<S, num_keys, blocks_per_key>(
            &get_fixed_key(), expanded_keys, iv, tweaks, counters, output);
    }

private:
    struct fixed_key_initializer
    {
        rijndael_round_keys<S> round_keys;

        fixed_key_initializer(block_secpar<S> fixed_key)
        {
            rijndael_keygen<S>(&round_keys, fixed_key);
        }
    };

    static const rijndael_round_keys<S>& get_fixed_key()
    {
        static const fixed_key_initializer initializer(block_secpar<S>::set_zero());
        return initializer.round_keys;
    }
};

} // namespace faest

#endif
