#ifndef QUICKSILVER_HPP
#define QUICKSILVER_HPP

#include <algorithm>
#include <array>
#include "polynomials.hpp"
#include "poly2d.hpp"
#include "universal_hash.hpp"

namespace faest
{

template <secpar S, bool verifier, size_t max_deg> requires (max_deg >= 1) struct quicksilver_state;
template <typename QS, size_t deg = 1> struct quicksilver_gf2;
template <typename QS, size_t deg = 1> struct quicksilver_gfsecpar;

// Prover keeps a MAC polynomial.
template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
struct quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg>
{
    typedef quicksilver_state<S, false, max_deg> quicksilver;

    poly2d<deg + 1, secpar_to_bits(S)> mac;

    quicksilver_gfsecpar()
    {
        // TODO: Something is uninitializd somewhere, and this seems to fix it.
        mac = poly2d<deg + 1, secpar_to_bits(S)>::set_zero();
    }

    poly_secpar<S>& value() { return mac.coeffs[deg]; }
    const poly_secpar<S>& value() const { return mac.coeffs[deg]; }

    quicksilver_gfsecpar(const quicksilver* state) :
        mac(poly2d<deg + 1, secpar_to_bits(S)>::set_zero())
    {
        (void) state;
    }

    quicksilver_gfsecpar(poly1 const_value, const quicksilver* state) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar(state)) {}
    quicksilver_gfsecpar(poly_secpar<S> const_value, const quicksilver* state) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar(state)) {}
    template <size_t deg2>
    quicksilver_gfsecpar(poly1 const_value, const quicksilver_gf2<quicksilver, deg2>& state_from) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar<quicksilver, deg2>(state_from)) {}
    template <size_t deg2>
    quicksilver_gfsecpar(poly_secpar<S> const_value, const quicksilver_gf2<quicksilver, deg2>& state_from) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar<quicksilver, deg2>(state_from)) {}

    template <size_t deg2>
    quicksilver_gfsecpar(poly1 const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from) :
        quicksilver_gfsecpar(poly_secpar<S>::from_1(const_value), state_from) {}

    template <size_t deg2>
    quicksilver_gfsecpar(poly_secpar<S> const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from) :
        mac(poly2d<deg, secpar_to_bits(S)>::set_zero())
    {
        value() = const_value;
        (void) state_from;
    }

    quicksilver_gfsecpar(const quicksilver_gf2<quicksilver, deg>& other);

    template <size_t deg2>
    quicksilver_gfsecpar(const quicksilver_gfsecpar<quicksilver, deg2>& other) requires (deg > deg2);

    template <size_t deg2>
    quicksilver_gfsecpar(const quicksilver_gf2<quicksilver, deg2>& other) requires (deg > deg2);

    quicksilver_gfsecpar operator+(const quicksilver_gfsecpar& other) const
    {
        quicksilver_gfsecpar out;
        out.mac = mac + other.mac;
        return out;
    }

    template<typename T>
    quicksilver_gfsecpar& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template<typename T>
    quicksilver_gfsecpar& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }

    static quicksilver_gfsecpar<quicksilver, deg>
    combine_8_bits(const quicksilver_gf2<quicksilver, deg>* qs_bits);
};

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
struct quicksilver_gf2<quicksilver_state<S, false, max_deg>, deg>
{
    typedef quicksilver_state<S, false, max_deg> quicksilver;

    poly2d<deg, secpar_to_bits(S)> mac;
    poly1 value_;

    poly1& value() { return value_; }
    const poly1& value() const { return value_; }

    quicksilver_gf2()
    {
        // TODO: Something is uninitializd somewhere, and this seems to fix it.
        mac = poly2d<deg, secpar_to_bits(S)>::set_zero();
        value_ = 0;
    }

    quicksilver_gf2(const quicksilver* state) :
        mac(poly2d<deg, secpar_to_bits(S)>::set_zero()),
        value_(poly1::set_zero())
    {
        (void) state;
    }

    quicksilver_gf2(poly1 const_value, const quicksilver* state) :
        quicksilver_gf2(const_value, quicksilver_gf2(state)) {}
    template <size_t deg2>
    quicksilver_gf2(poly1 const_value, const quicksilver_gf2<quicksilver, deg2>& state_from) :
        quicksilver_gf2(const_value, quicksilver_gfsecpar<quicksilver, deg2>(state_from)) {}

    template <size_t deg2>
    quicksilver_gf2(poly1 const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from) :
        mac(poly2d<deg, secpar_to_bits(S)>::set_zero()),
        value_(const_value)
    {
        (void) state_from;
    }

    template <size_t deg2>
    quicksilver_gf2(const quicksilver_gf2<quicksilver, deg2>& other) requires (deg > deg2);

    quicksilver_gfsecpar<quicksilver, deg> operator+(
        const quicksilver_gfsecpar<quicksilver, deg>& other) const
    {
        return other + *this;
    }

    quicksilver_gf2 operator+(const quicksilver_gf2& other) const
    {
        quicksilver_gf2 out;
        out.mac = mac + other.mac;
        out.value() = value() + other.value();
        return out;
    }

    template<typename T>
    quicksilver_gf2& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template<typename T>
    quicksilver_gf2& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

// Verifier only has the evaluation of the MAC polynomial at delta.
template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
struct quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>
{
    typedef quicksilver_state<S, true, max_deg> quicksilver;

    poly_secpar<S> mac;
    const std::array<poly_secpar<S>, max_deg>* delta_powers;

    quicksilver_gfsecpar() = default;

    quicksilver_gfsecpar(const quicksilver* state) :
        mac(poly_secpar<S>::set_zero()),
        delta_powers(&state->delta_powers) {}

    quicksilver_gfsecpar(poly1 const_value, const quicksilver* state) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar(state)) {}
    quicksilver_gfsecpar(poly_secpar<S> const_value, const quicksilver* state) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar(state)) {}
    template <size_t deg2>
    quicksilver_gfsecpar(poly1 const_value, const quicksilver_gf2<quicksilver, deg2>& state_from) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar<quicksilver, deg2>(state_from)) {}
    template <size_t deg2>
    quicksilver_gfsecpar(poly_secpar<S> const_value, const quicksilver_gf2<quicksilver, deg2>& state_from) :
        quicksilver_gfsecpar(const_value, quicksilver_gfsecpar<quicksilver, deg2>(state_from)) {}

    template <size_t deg2>
    quicksilver_gfsecpar(poly1 const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from);

    template <size_t deg2>
    quicksilver_gfsecpar(poly_secpar<S> const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from);

    template <size_t deg2>
    quicksilver_gfsecpar(const quicksilver_gfsecpar<quicksilver, deg2>& other) requires (deg > deg2);

    template <size_t deg2>
    quicksilver_gfsecpar(const quicksilver_gf2<quicksilver, deg2>& other) requires (deg > deg2);

    quicksilver_gfsecpar operator+(const quicksilver_gfsecpar& other) const
    {
        quicksilver_gfsecpar out;
        out.mac = mac + other.mac;
        FAEST_ASSERT(delta_powers == other.delta_powers);
        out.delta_powers = delta_powers;
        return out;
    }

    template<typename T>
    quicksilver_gfsecpar& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template<typename T>
    quicksilver_gfsecpar& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }

    static quicksilver_gfsecpar<quicksilver, deg>
    combine_8_bits(const quicksilver_gf2<quicksilver, deg>* qs_bits);
};

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
struct quicksilver_gf2<quicksilver_state<S, true, max_deg>, deg> :
    public quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>
{
    typedef quicksilver_state<S, true, max_deg> quicksilver;

private:
    typedef quicksilver_gfsecpar<quicksilver, deg> base;

public:
    quicksilver_gf2() = default;
    quicksilver_gf2(const quicksilver* state) : base(state) {}
    quicksilver_gf2(poly1 const_value, const quicksilver* state) :
        quicksilver_gf2(const_value, quicksilver_gf2(state)) {}
    template <size_t deg2>
    quicksilver_gf2(poly1 const_value, const quicksilver_gf2<quicksilver, deg2>& state_from) :
        quicksilver_gf2(const_value, quicksilver_gfsecpar<quicksilver, deg2>(state_from)) {}
    template <size_t deg2>
    quicksilver_gf2(poly1 const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from) :
        base(const_value, state_from) {}

    template <size_t deg2>
    quicksilver_gf2(const quicksilver_gf2<quicksilver, deg2>& other) requires (deg > deg2);

    quicksilver_gf2 operator+(const quicksilver_gf2& other) const
    {
        quicksilver_gf2 out;
        out.mac = base::mac + other.mac;
        FAEST_ASSERT(base::delta_powers == other.delta_powers);
        out.delta_powers = base::delta_powers;
        return out;
    }

    template<typename T>
    quicksilver_gf2& operator+=(const T& other)
    {
        *this = *this + other;
        return *this;
    }

    template<typename T>
    quicksilver_gf2& operator*=(const T& other)
    {
        *this = *this * other;
        return *this;
    }
};

// Contains member variables that differ between prover and verifier.
template <secpar S, bool verifier, size_t max_deg> struct quicksilver_state_base;

template <secpar S, size_t max_deg>
struct quicksilver_state_base<S, false, max_deg>
{
    const uint8_t* witness;
};

template <secpar S, size_t max_deg>
struct quicksilver_state_base<S, true, max_deg>
{
    // Powers of delta starting from 1.
    std::array<poly_secpar<S>, max_deg> delta_powers;

    inline const poly_secpar<S>& delta() const
    {
        return delta_powers[0];
    }
};

// Helper functions that are independent of prover vs verifier.
template <secpar S>
class quicksilver_helpers
{
    template <secpar S_, bool verifier, size_t max_deg> requires (max_deg >= 1) friend struct quicksilver_state;

    static void finalize_hashes(const uhasher_gfsecpar<S>* state_secpar,
                                const uhasher_gfsecpar_64<S>* state_64,
                                const poly_secpar<S>* hash_combination,
                                poly_2secpar<S> mask, uint8_t* output)
    {
        poly_secpar<S> hashes[2];
        hashes[0] = state_secpar->finalize();
        hashes[1] = state_64->finalize();

        poly_2secpar<S> sum = mask;
        for (size_t i = 0; i < 2; ++i)
            sum += hash_combination[i] * hashes[i];

        sum.template reduce_to<secpar_to_bits(S)>().store1(output);
    }

    static poly_2secpar<S> combine_mac_masks(const block_secpar<S>* macs,
                                             size_t mac_masks_offset_in_witness)
    {
        poly_2secpar<S> accumulators[8];
        size_t offset = mac_masks_offset_in_witness;

        for (int j = 0; j < 8; ++j)
        {
            poly_secpar<S> x =
                poly_secpar<S>::load(&macs[offset + secpar_to_bits(S) - 8 + j]);
            accumulators[j] = poly_2secpar<S>::from(x);
        }

        for (int i = secpar_to_bits(S) - 16; i >= 0; i -= 8)
        {
            for (int j = 0; j < 8; ++j)
            {
                poly_secpar<S> x = poly_secpar<S>::load(&macs[offset + i + j]);
                accumulators[j] = accumulators[j].shift_left_8() + poly_2secpar<S>::from(x);
            }
        }

        poly_2secpar<S> total;
        memset(&total, 0, sizeof(total));
        for (int j = 8 - 1; j >= 0; --j)
        {
            for (int k = 0; k >= 0; --k)
            {
                total = total.shift_left_1();
                total = total + accumulators[j].extract(k);
            }
        }

        return total;
    }

    static void init_hashers(
        const uint8_t* challenge, size_t num_constraints, poly_secpar<S>* hash_combination,
        uhasher_gfsecpar<S>::prep_key_t* key_secpar, uhasher_gfsecpar_64<S>::prep_key_t* key_64,
        uhasher_gfsecpar<S>* state_secpar, uhasher_gfsecpar_64<S>* state_64,
        size_t num_hashes)
    {
        for (size_t i = 0; i < 2; ++i, challenge += secpar_to_bytes(S))
            hash_combination[i] = poly_secpar<S>::load_dup(challenge);
        poly_secpar<S> hash_key_secpar = poly_secpar<S>::load_dup(challenge);
        poly64 hash_key_64 = poly64::load_dup(challenge + secpar_to_bytes(S));

        *key_secpar = uhasher_gfsecpar<S>::preprocess_key(hash_key_secpar);
        *key_64 = uhasher_gfsecpar_64<S>::preprocess_key(hash_key_64);

        for (size_t i = 0; i < num_hashes; ++i)
        {
            state_secpar[i].init(num_constraints);
            state_64[i].init(num_constraints);
        }
    }
};

template <secpar S, bool verifier, size_t max_deg>
    requires (max_deg >= 1)
struct quicksilver_state : public quicksilver_state_base<S, verifier, max_deg>
{
private:
    typedef quicksilver_helpers<S> helpers;

public:
    static constexpr bool is_verifier = verifier;
    static constexpr secpar secpar_v = S;
    static constexpr size_t secpar_bits = secpar_to_bits(S);
    static constexpr size_t max_degree = max_deg;

    using verifier_mask_t = poly_2secpar<S>;
    using prover_mask_t = poly2d<max_degree, 2 * secpar_to_bits(S)>;

    uhasher_gfsecpar<S>::prep_key_t key_secpar;
    uhasher_gfsecpar_64<S>::prep_key_t key_64;
    std::array<uhasher_gfsecpar<S>, verifier ? 1 : max_degree> state_secpar;
    std::array<uhasher_gfsecpar_64<S>, verifier ? 1 : max_degree> state_64;

    poly_secpar<S> hash_combination[2];

    const block_secpar<S>* macs;

    // Initialize a prover's quicksilver_state. challenge must have length
    // QUICKSILVER_CHALLENGE_BYTES.
    quicksilver_state(const uint8_t* witness, const block_secpar<S>* macs, size_t num_constraints,
                      const uint8_t* challenge) requires (!verifier)
    {
        helpers::init_hashers(challenge, num_constraints, hash_combination,
                              &key_secpar, &key_64, state_secpar.data(), state_64.data(), max_degree);

        this->witness = witness;
        this->macs = macs;
    }

    // Initialize a verifier's quicksilver_state. challenge must have length
    // QUICKSILVER_CHALLENGE_BYTES.
    quicksilver_state(const block_secpar<S>* macs, size_t num_constraints, block_secpar<S> delta,
                      const uint8_t* challenge) requires (verifier)
    {
        helpers::init_hashers(challenge, num_constraints, hash_combination,
                              &key_secpar, &key_64, state_secpar.data(), state_64.data(), 1);

        auto delta_powers = &this->delta_powers[0];
        delta_powers[0] = poly_secpar<S>::load_dup(&delta);
        for (size_t i = 1; i < max_degree; ++i)
            delta_powers[i] = (delta_powers[i - 1] * this->delta()).template reduce_to<secpar_to_bits(S)>();

        this->macs = macs;
    }

    inline quicksilver_gf2<quicksilver_state> get_witness_bit(size_t index) const
    {
        quicksilver_gf2<quicksilver_state> out(this);
        if constexpr (!verifier)
        {
            out.value() = poly1::load(this->witness[index / 8], index % 8);
        }
        out.mac = poly_secpar<S>::load(&macs[index]);
        return out;
    }

    // Helpers to create array of constant quicksilver values.
    template <size_t len, size_t deg = 1>
    inline std::array<quicksilver_gf2<quicksilver_state, deg>, len>
    const_gf2_array(poly1 val = 0) const
    {
        quicksilver_gf2<quicksilver_state, deg> out[len];
        std::fill(std::begin(out), std::end(out), quicksilver_gf2<quicksilver_state, deg>(val, this));
        return std::to_array(out);
    }

    template <size_t len, size_t len2, size_t deg = 1>
    inline std::array<std::array<quicksilver_gf2<quicksilver_state, deg>, len>, len2>
    const_gf2_2d_array(poly1 val = 0) const
    {
        std::array<quicksilver_gf2<quicksilver_state, deg>, len> out[len2];
        std::fill(std::begin(out), std::end(out), this->const_gf2_array<len, deg>(val));
        return std::to_array(out);
    }

    template <size_t len, size_t deg = 1>
    inline std::array<quicksilver_gfsecpar<quicksilver_state, deg>, len>
    const_gfsecpar_array(poly1 val = 0) const
    {
        quicksilver_gfsecpar<quicksilver_state, deg> out[len];
        std::fill(std::begin(out), std::end(out), quicksilver_gfsecpar<quicksilver_state, deg>(val, this));
        return std::to_array(out);
    }

    template <size_t len, size_t len2, size_t deg = 1>
    inline std::array<std::array<quicksilver_gfsecpar<quicksilver_state, deg>, len>, len2>
    const_gfsecpar_2d_array(poly1 val = 0) const
    {
        std::array<quicksilver_gfsecpar<quicksilver_state, deg>, len> out[len2];
        std::fill(std::begin(out), std::end(out), this->const_gfsecpar_array<len, deg>(val));
        return std::to_array(out);
    }

    template <size_t len, size_t deg = 1>
    inline std::array<quicksilver_gfsecpar<quicksilver_state, deg>, len>
    const_gfsecpar_array(poly_secpar<S> val) const
    {
        quicksilver_gfsecpar<quicksilver_state, deg> out[len];
        std::fill(std::begin(out), std::end(out), quicksilver_gfsecpar<quicksilver_state, deg>(val, this));
        return std::to_array(out);
    }

    template <size_t len, size_t len2, size_t deg = 1>
    inline std::array<std::array<quicksilver_gfsecpar<quicksilver_state, deg>, len>, len2>
    const_gfsecpar_2d_array(poly_secpar<S> val) const
    {
        std::array<quicksilver_gf2<quicksilver_state, deg>, len> out[len2];
        std::fill(std::begin(out), std::end(out), this->const_gfsecpar_array<len, deg>(val));
        return std::to_array(out);
    }

    // load 8 consecutive bits from the witness
    inline std::array<quicksilver_gf2<quicksilver_state>, 8>
    load_witness_8_bits(size_t bit_index) const
    {
        auto qs_bits = const_gf2_array<8>();
        for (size_t bit_j = 0; bit_j < 8; ++bit_j)
            qs_bits[bit_j] = get_witness_bit(bit_index + bit_j);
        return qs_bits;
    }

    // load 8 consecutive bits from the witness and combine them into a GF(2^secpar) value in the
    // GF(2^8) subfield
    inline quicksilver_gfsecpar<quicksilver_state>
    load_witness_8_bits_and_combine(size_t bit_index) const
    {
        auto input_bits = load_witness_8_bits(bit_index);
        return quicksilver_gfsecpar<quicksilver_state>::combine_8_bits(input_bits.data());
    }

    // Add a constraint of the form x == 0.
    template <size_t deg>
    inline void add_constraint(quicksilver_gfsecpar<quicksilver_state, deg> x)
    {
        quicksilver_gfsecpar<quicksilver_state, max_degree> x_max = x;
        if constexpr (verifier)
        {
            state_secpar[0].update(key_secpar, x_max.mac);
            state_64[0].update(key_64, x_max.mac);
        }
        else
        {
            FAEST_ASSERT(x_max.value() == poly_secpar<S>::set_zero());
            for (size_t i = 0; i < max_degree; ++i)
            {
                state_secpar[i].update(key_secpar, x_max.mac.coeffs[i]);
                state_64[i].update(key_64, x_max.mac.coeffs[i]);
            }
        }
    }

    // Add a constraint of the form x == 0 || x == 1.
    template <size_t deg>
    inline void add_bit_constraint(quicksilver_gfsecpar<quicksilver_state, deg> x)
    {
        add_constraint(x * (x + 1));
    }

    // Add a constraint of the form x*y == 1.
    // (This implementation is slightly optimized and avoids
    template <size_t deg>
    inline void add_inverse_constraints(quicksilver_gfsecpar<quicksilver_state, deg> x,
                                        quicksilver_gfsecpar<quicksilver_state, deg> y)
    {
        // TODO: Bring back multiplication optimization where we know x * y = 1.
        add_constraint(x * y + 1);
    }

    // Add two constraints x^2 * y == x and y^2 * x == y to verify (x*y == 1 OR x == y == 0).
    template <size_t deg>
    inline void add_inverse_or_zero_constraints(quicksilver_gfsecpar<quicksilver_state, deg> x,
                                                quicksilver_gfsecpar<quicksilver_state, deg> x_square,
                                                quicksilver_gfsecpar<quicksilver_state, deg> y,
                                                quicksilver_gfsecpar<quicksilver_state, deg> y_square)
    {
        add_constraint(x_square * y + x);
        add_constraint(x * y_square + y);
    }

    void prove_with_mask(uint8_t* __restrict__ proof, uint8_t* __restrict__ check,
                         const prover_mask_t& masks) const
        requires(!verifier)
    {
        for (size_t i = 0; i < max_degree; ++i)
            helpers::finalize_hashes(&state_secpar[i], &state_64[i], hash_combination,
                                     masks.coeffs[i],
                                     i == 0 ? check : proof + secpar_to_bytes(S) * (i - 1));
    }

    // Use the suffix of the witness to build the mask VOLEs
    void prove(size_t witness_bits, uint8_t* __restrict__ proof, uint8_t* __restrict__ check) const
        requires(!verifier)
    {
        FAEST_ASSERT(witness_bits % 8 == 0);

        auto masks = poly2d<max_degree, 2 * secpar_to_bits(S)>::set_zero();
        for (size_t i = 0; i < max_degree - 1; ++i, witness_bits += secpar_to_bits(S))
        {
            poly_2secpar<S> mask_mac = helpers::combine_mac_masks(macs, witness_bits);
            poly_2secpar<S> mask_value =
                poly_2secpar<S>::from(poly_secpar<S>::load_dup(&this->witness[witness_bits / 8]));
            masks.coeffs[i] += mask_mac;
            masks.coeffs[i + 1] += mask_value;
        }
        this->prove_with_mask(proof, check, masks);
    }

    // Use the supplied (u_mask, v_mask)
    void prove(const block_secpar<S>* u_mask, const block_secpar<S>* v_mask,
               uint8_t* __restrict__ proof, uint8_t* __restrict__ check) const
        requires(!verifier)
    {
        prover_mask_t masks;
        {
            masks.coeffs[0] = poly_2secpar<S>::set_zero();
            for (size_t i = 0; i < max_degree - 1; ++i)
            {
                masks.coeffs[i] += poly_2secpar<S>::from(poly_secpar<S>::from_block(v_mask[i]));
                masks.coeffs[i + 1] = poly_2secpar<S>::from(poly_secpar<S>::from_block(u_mask[i]));
            }
        }
        this->prove_with_mask(proof, check, masks);
    }

    void verify_with_mask(uint8_t* __restrict__ check, const verifier_mask_t mask) const
        requires(verifier)
    {
        helpers::finalize_hashes(&state_secpar[0], &state_64[0], hash_combination, mask, check);
    }

    // Use the suffix of the witness to build the mask VOLEs
    void verify(size_t witness_bits, const uint8_t* __restrict__ proof,
                uint8_t* __restrict__ check) const
        requires(verifier)
    {
        auto mask = poly_2secpar<S>::set_zero();
        if (max_degree >= 2)
        {
            mask = helpers::combine_mac_masks(macs, witness_bits);
            for (size_t i = 1; i < max_degree - 1; ++i, proof += secpar_to_bytes(S))
            {
                witness_bits += secpar_to_bits(S);
                auto coeff =
                    poly_secpar<S>::load_dup(proof) + helpers::combine_mac_masks(macs, witness_bits)
                                                          .template reduce_to<secpar_to_bits(S)>();
                mask += coeff * this->delta_powers[i - 1];
            }
            mask += poly_secpar<S>::load_dup(proof) * this->delta_powers[max_degree - 2];
        }
        this->verify_with_mask(check, mask);
    }

    // Use the supplied q_mask
    void verify(const block_secpar<S>* q_mask, const uint8_t* __restrict__ proof,
                uint8_t* __restrict__ check) const
        requires(verifier)
    {
        auto mask = poly_2secpar<S>::set_zero();

        if (max_degree >= 2)
        {
            mask = poly_2secpar<S>::from(poly_secpar<S>::from_block(q_mask[0]));
            for (size_t i = 1; i < max_degree - 1; ++i, proof += secpar_to_bytes(S))
            {
                const auto coeff =
                    poly_secpar<S>::load(proof) + poly_secpar<S>::from_block(q_mask[i]);
                mask += coeff * this->delta_powers[i - 1];
            }
            mask += poly_secpar<S>::load(proof) * this->delta_powers[max_degree - 2];
        }
        this->verify_with_mask(check, mask);
    }
};


template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>::quicksilver_gfsecpar(
    poly1 const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from) :
    delta_powers(state_from.delta_powers)
{
    if (deg > 0)
        mac = const_value * (*delta_powers)[deg - 1];
    else
        mac = poly_secpar<S>::from_1(const_value);
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>::quicksilver_gfsecpar(
    poly_secpar<S> const_value, const quicksilver_gfsecpar<quicksilver, deg2>& state_from) :
    delta_powers(state_from.delta_powers)
{
    if (deg > 0)
        mac = (const_value * (*delta_powers)[deg - 1]).template reduce_to<secpar_to_bits(S)>();
    else
        mac = const_value;
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
inline quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg>::quicksilver_gfsecpar(
//    const quicksilver_gf2<quicksilver_state<S, false, max_deg>, deg>& other) : TODO
    const quicksilver_gf2<quicksilver, deg>& other) :
    mac(other.mac)
{
    value() = poly_secpar<S>::from_1(other.value());
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg>::quicksilver_gfsecpar(
    const quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg2>& other)
    requires (deg > deg2)
{
    mac = other.mac.template shift_left<deg - deg2>();
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gf2<quicksilver_state<S, false, max_deg>, deg>::quicksilver_gf2(
    const quicksilver_gf2<quicksilver_state<S, false, max_deg>, deg2>& other)
    requires (deg > deg2)
{
    mac = other.mac.template shift_left<deg - deg2>();
    value() = other.value();
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>::quicksilver_gfsecpar(
    const quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg2>& other)
    requires (deg > deg2)
{
    static_assert(deg - deg2 <= max_deg);
    delta_powers = other.delta_powers;
    mac = (other.mac * (*delta_powers)[deg - deg2 - 1]).template reduce_to<secpar_to_bits(S)>();
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gf2<quicksilver_state<S, true, max_deg>, deg>::quicksilver_gf2(
    const quicksilver_gf2<quicksilver_state<S, true, max_deg>, deg2>& other)
    requires (deg > deg2) :
    base(other) {}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg>::quicksilver_gfsecpar(
    const quicksilver_gf2<quicksilver_state<S, false, max_deg>, deg2>& other)
    requires (deg > deg2) :
    quicksilver_gfsecpar(quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg2>(other)) {}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
template <size_t deg2>
inline quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>::quicksilver_gfsecpar(
    const quicksilver_gf2<quicksilver_state<S, true, max_deg>, deg2>& other)
    requires (deg > deg2) :
    quicksilver_gfsecpar(quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg2>(other)) {}


template <typename QS, size_t deg>
inline quicksilver_gf2<QS, deg>
operator+(const quicksilver_gf2<QS, deg>& a, poly1 b)
{
    return a + quicksilver_gf2<QS, deg>(b, a);
}

template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator+(const quicksilver_gfsecpar<QS, deg>& a, poly1 b)
{
    return a + quicksilver_gfsecpar<QS, deg>(b, a);
}

template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator+(const quicksilver_gfsecpar<QS, deg>& a, poly_secpar<QS::secpar_v> b)
{
    return a + quicksilver_gfsecpar<QS, deg>(b, a);
}

template <typename QS, size_t deg>
inline quicksilver_gf2<QS, deg>
operator+(poly1 a, const quicksilver_gf2<QS, deg>& b)
{
    return b + a;
}

template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator+(poly1 a, const quicksilver_gfsecpar<QS, deg>& b)
{
    return b + a;
}

template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator+(poly_secpar<QS::secpare_v> a, const quicksilver_gfsecpar<QS, deg>& b)
{
    return b + a;
}

template <typename QS, size_t deg_a, size_t deg_b>
inline quicksilver_gfsecpar<QS, deg_a + deg_b>
operator*(const quicksilver_gfsecpar<QS, deg_a>& a, const quicksilver_gfsecpar<QS, deg_b>& b)
{
    quicksilver_gfsecpar<QS, deg_a + deg_b> out(0, a);
    out.mac = (a.mac * b.mac).template reduce_to<QS::secpar_bits>();
    if constexpr (QS::is_verifier)
    {
        FAEST_ASSERT(a.delta_powers == b.delta_powers);
        out.delta_powers = a.delta_powers;
    }
    return out;
}

template <typename QS, size_t deg_a, size_t deg_b>
inline quicksilver_gfsecpar<QS, deg_a + deg_b>
operator*(const quicksilver_gfsecpar<QS, deg_a>& a, const quicksilver_gf2<QS, deg_b>& b)
{
    if constexpr (!QS::is_verifier)
    {
        quicksilver_gfsecpar<QS, deg_a + deg_b> out(0, a);
        out.mac = (a.mac * b.mac).template reduce_to<QS::secpar_bits>();
        out.mac += (a.mac * b.value()).template shift_left<deg_b>();
        return out;
    }
    else
        return a * quicksilver_gfsecpar<QS, deg_b>(b);
}

template <typename QS, size_t deg_a, size_t deg_b>
inline quicksilver_gf2<QS, deg_a + deg_b>
operator*(const quicksilver_gf2<QS, deg_a>& a, const quicksilver_gf2<QS, deg_b>& b)
{
    quicksilver_gf2<QS, deg_a + deg_b> out(0, a);
    if constexpr (!QS::is_verifier)
    {
        out.mac = (a.mac * b.mac).template reduce_to<QS::secpar_bits>();
        out.mac += (a.mac * b.value()).template shift_left<deg_b>() +
                   (b.mac * a.value()).template shift_left<deg_a>();
        out.value() = a.value() * b.value();
    }
    else
    {
        auto out_gfsecpar = quicksilver_gfsecpar<QS, deg_a>(a) * quicksilver_gfsecpar<QS, deg_b>(b);
        out.mac = out_gfsecpar.mac;
        out.delta_powers = out_gfsecpar.delta_powers;
    }
    return out;
}

template <typename QS, size_t deg_a, size_t deg_b>
inline quicksilver_gfsecpar<QS, deg_a + deg_b>
operator*(const quicksilver_gf2<QS, deg_b>& a, const quicksilver_gfsecpar<QS, deg_a>& b)
{
    return b * a;
}

template <typename QS, size_t deg>
inline quicksilver_gf2<QS, deg>
operator*(poly1 const_mult, quicksilver_gf2<QS, deg> x)
{
    return quicksilver_gf2<QS, 0>(const_mult, x) * x;
}

template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator*(poly1 const_mult, quicksilver_gfsecpar<QS, deg> x)
{
    return quicksilver_gf2<QS, 0>(const_mult, x) * x;
}

template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator*(poly_secpar<QS::secpar_v> const_mult, quicksilver_gfsecpar<QS, deg> x)
{
    return quicksilver_gfsecpar<QS, 0>(const_mult, x) * x;
}

template <typename QS, size_t deg>
inline quicksilver_gf2<QS, deg>
operator*(quicksilver_gf2<QS, deg> x, poly1 const_mult) { return const_mult * x; }
template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator*(quicksilver_gfsecpar<QS, deg> x, poly1 const_mult) { return const_mult * x; }
template <typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
operator*(quicksilver_gfsecpar<QS, deg> x, poly_secpar<QS::secpar_v> const_mult)
{
    return const_mult * x;
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg>
quicksilver_gfsecpar<quicksilver_state<S, false, max_deg>, deg>::combine_8_bits(
    const quicksilver_gf2<quicksilver_state<S, false, max_deg>, deg>* qs_bits)
{
    quicksilver_gfsecpar<quicksilver, deg> out(0, qs_bits[0]);

    for (size_t i = 0; i < deg; ++i)
    {
        poly_secpar<S> macs[8];
        for (size_t j = 0; j < 8; ++j)
            macs[j] = qs_bits[j].mac.coeffs[i];
        out.mac.coeffs[i] = poly_secpar<S>::from_8_self(macs);
    }

    poly1 bits[8];
    for (size_t j = 0; j < 8; ++j)
        bits[j] = qs_bits[j].value();
    out.value() = poly_secpar<S>::from_8_poly1(bits);

    return out;
}

template <secpar S, size_t max_deg, size_t deg> requires (deg <= max_deg)
quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>
quicksilver_gfsecpar<quicksilver_state<S, true, max_deg>, deg>::combine_8_bits(
    const quicksilver_gf2<quicksilver_state<S, true, max_deg>, deg>* qs_bits)
{
    quicksilver_gfsecpar<quicksilver, deg> out(0, qs_bits[0]);

    poly_secpar<S> macs[8];
    for (size_t i = 0; i < 8; ++i)
        macs[i] = qs_bits[i].mac;
    out.mac = poly_secpar<S>::from_8_self(macs);

    return out;
}

} // namespace faest

#endif
