template <> struct block<192>
{
    uint64_t data[3];

    inline static block192 load(const void* p)
    {
        block192 out;
        memcpy(&out, p, sizeof(out));
        return out;
    }
    inline void store(void* p) const { memcpy(p, &data, sizeof(data)); }

    inline block192 operator^(const block192& y) const
    {
        // Plain c version for now at least. Hopefully it will be autovectorized.
        block192 out;
        out.data[0] = this->data[0] ^ y.data[0];
        out.data[1] = this->data[1] ^ y.data[1];
        out.data[2] = this->data[2] ^ y.data[2];
        return out;
    }

    inline block192 operator&(const block192& y) const
    {
        block192 out;
        out.data[0] = this->data[0] & y.data[0];
        out.data[1] = this->data[1] & y.data[1];
        out.data[2] = this->data[2] & y.data[2];
        return out;
    }

    inline block192 operator|(const block192& y) const
    {
        block192 out;
        out.data[0] = this->data[0] | y.data[0];
        out.data[1] = this->data[1] | y.data[1];
        out.data[2] = this->data[2] | y.data[2];
        return out;
    }

    inline block192 add32(const block192& y) const
    {
        uint32_t x_data[6];
        uint32_t y_data[6];
        memcpy(x_data, data, sizeof(data));
        memcpy(y_data, y.data, sizeof(y.data));
        for (int i = 0; i < 6; ++i) x_data[i] += y_data[i];

        block192 out;
        memcpy(out.data, x_data, sizeof(out.data));
        return out;
    }

    inline static block192 set_all_8(uint8_t x)
    {
        uint64_t x64 = x;
        x64 *= UINT64_MAX / 0xff;

        block192 out = {{x64, x64, x64}};
        return out;
    }

    inline static block192 set_low64(uint64_t x)
    {
        block192 out = {{x, 0, 0}};
        return out;
    }

    inline static block192 set_low32(uint32_t x) { return set_low64(x); }

    inline static block192 set_low32(uint32_t x, uint32_t y)
    {
        return set_low64(((uint64_t) y << 32) + x);
    }

    inline static block192 set_low_high32(uint32_t x, uint32_t y)
    {
        block192 out = {{x, 0, (uint64_t) y << 32}};
        return out;
    }

    inline static block192 set_zero() { return set_low64(0); }

    bool any_zeros() const;
};
