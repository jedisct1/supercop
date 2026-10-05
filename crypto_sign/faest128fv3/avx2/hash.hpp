#ifndef HASH_HPP
#define HASH_HPP

#include "block.hpp"
#include <cinttypes>
#include <cstddef>
#include <span>

extern "C"
{
#include "KeccakHash-times4.h"
extern "C" {
#include <libkeccak.a.headers/KeccakHash.h>
}
}

namespace faest
{

// TODO: Is the error checking really needed?
// Either add it to hash_state_x4, or remove it from hash_state.

struct hash_state
{
    Keccak_HashInstance ctx;

    inline int init(secpar s)
    {
        if (secpar_to_bits(s) <= 128)
            return Keccak_HashInitialize_SHAKE128(&this->ctx);
        else
            return Keccak_HashInitialize_SHAKE256(&this->ctx);
    }

    inline int update(std::span<const uint8_t> input)
    {
        return this->update(input.data(), input.size());
    }

    inline int update(const void* input, size_t bytes)
    {
        return Keccak_HashUpdate(&this->ctx, (const uint8_t*)input, bytes * 8);
    }

    inline int update_byte(uint8_t b) { return this->update(&b, 1); }

    inline int finalize(std::span<uint8_t> digest)
    {
        return this->finalize(digest.data(), digest.size());
    }

    inline int finalize(void* digest, size_t bytes)
    {
        int ret = Keccak_HashFinal(&this->ctx, NULL);
        if (ret != KECCAK_SUCCESS)
            return ret;
        return Keccak_HashSqueeze(&this->ctx, (uint8_t*)digest, bytes * 8);
    }
};

// Mostly copied from Picnic: Instances that work with 4 states in parallel.
struct hash_state_x4
{
    Keccak_HashInstance_x4 ctx;

    inline void init(secpar s)
    {
        if (secpar_to_bits(s) <= 128)
            Keccak_HashInitialize_x4_SHAKE128(&this->ctx);
        else
            Keccak_HashInitialize_x4_SHAKE256(&this->ctx);
    }

    inline void update(const void** data, size_t size)
    {
        const uint8_t* data_casted[4] = {(const uint8_t*)data[0], (const uint8_t*)data[1],
                                         (const uint8_t*)data[2], (const uint8_t*)data[3]};
        Keccak_HashUpdate_x4(&this->ctx, data_casted, size << 3);
    }

    inline void update_4(const void* data0, const void* data1, const void* data2, const void* data3,
                         size_t size)
    {
        const void* data[4] = {data0, data1, data2, data3};
        this->update(data, size);
    }

    inline void update_1(std::span<const uint8_t> input)
    {
        this->update_1(input.data(), input.size());
    }

    inline void update_1(const void* data, size_t size)
    {
        this->update_4(data, data, data, data, size);
    }

    inline void update_1_byte(uint8_t b) { this->update_1(&b, 1); }

    inline void init_prefix(secpar s, const uint8_t prefix)
    {
        this->init(s);
        this->update_1(&prefix, sizeof(prefix));
    }

    inline void finalize(void** buffer, size_t buflen)
    {
        uint8_t* buffer_casted[4] = {(uint8_t*)buffer[0], (uint8_t*)buffer[1], (uint8_t*)buffer[2],
                                     (uint8_t*)buffer[3]};
        Keccak_HashFinal_x4(&this->ctx, NULL);
        Keccak_HashSqueeze_x4(&this->ctx, buffer_casted, buflen << 3);
    }

    inline void finalize_4(void* buffer0, void* buffer1, void* buffer2, void* buffer3,
                           size_t buflen)
    {
        void* buffer[4] = {buffer0, buffer1, buffer2, buffer3};
        this->finalize(buffer, buflen);
    }
};

template <secpar S>
inline void shake_prg_impl(const block_secpar<S>* __restrict__ keys, const block128& iv,
                           const uint32_t& tweak, size_t num_keys, size_t num_bytes,
                           uint8_t* __restrict__ output)
{
    size_t i;
    for (i = 0; i + 4 <= num_keys; i += 4)
    {
        const void* key_arr[4];
        void* output_arr[4];
        for (size_t j = 0; j < 4; ++j)
        {
            key_arr[j] = &keys[i + j];
            output_arr[j] = output + (i + j) * num_bytes;
        }

        hash_state_x4 hasher;
        hasher.init(S);
        hasher.update(key_arr, sizeof(keys[i]));
        hasher.update_1(&iv, sizeof(iv));
        hasher.update_1(&tweak, sizeof(tweak));
        hasher.update_1_byte(0);
        hasher.finalize(output_arr, num_bytes);
    }

    for (; i < num_keys; ++i)
    {
        hash_state hasher;
        hasher.init(S);
        hasher.update(&keys[i], sizeof(keys[i]));
        hasher.update(&iv, sizeof(iv));
        hasher.update(&tweak, sizeof(tweak));
        hasher.update_byte(0);
        hasher.finalize(output + i * num_bytes, num_bytes);
    }
}

} // namespace faest

#endif
