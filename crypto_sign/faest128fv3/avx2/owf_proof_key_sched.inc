#ifndef OWF_PROOF_KEY_SCHED_INC
#define OWF_PROOF_KEY_SCHED_INC

#include "aes_defs.hpp"
#include "constants.hpp"
#include "owf_proof_tools.hpp"
#include "parameters.hpp"
#include "quicksilver.hpp"

namespace faest::zk
{

template <typename QS> static void key_sched_fwd(const QS* state, quicksilver_gf2<QS>* output)
{
    constexpr secpar S = QS::secpar_v;
    for (size_t bit_i = 0; bit_i < secpar_to_bits(S); ++bit_i)
    {
        output[bit_i] = state->get_witness_bit(bit_i);
    }
    // current index in the extended witness
    size_t i_wd = secpar_to_bits(S);
    for (size_t word_j = N_WD<S>; word_j < 4 * (AES_ROUNDS<S> + 1); ++word_j)
    {
        if (word_j % N_WD<S> == 0 || (N_WD<S> > 6 && word_j % N_WD<S> == 4))
        {
            for (size_t bit_i = 0; bit_i < 32; ++bit_i)
            {
                output[32 * word_j + bit_i] = state->get_witness_bit(i_wd + bit_i);
            }
            i_wd += 32;
        }
        else
        {
            for (size_t bit_i = 0; bit_i < 32; ++bit_i)
            {
                output[32 * word_j + bit_i] =
                    output[32 * (word_j - N_WD<S>)+bit_i] + output[32 * (word_j - 1) + bit_i];
            }
        }
    }
}

template <typename QS, size_t n>
static void lift_bits(const std::array<quicksilver_gf2<QS>, 8 * n>& bits,
                      std::array<quicksilver_gfsecpar<QS>, n>& bytes)
{
    for (size_t byte_i = 0; byte_i < n; ++byte_i)
        bytes[byte_i] = quicksilver_gfsecpar<QS>::combine_8_bits(&bits[8 * byte_i]);
}

template <typename QS, size_t n>
static void lift_bits_and_square(QS* state, const std::array<quicksilver_gf2<QS>, 8 * n>& bits,
                                 std::array<quicksilver_gfsecpar<QS>, n>& bytes,
                                 std::array<quicksilver_gfsecpar<QS>, n>& bytes_sq)
{
    auto bits_sq = state->template const_gf2_array<8>();
    for (size_t byte_i = 0; byte_i < n; ++byte_i)
    {
        square_8_bits(bits_sq.data(), &bits[8 * byte_i]);
        bytes[byte_i] = quicksilver_gfsecpar<QS>::combine_8_bits(&bits[8 * byte_i]);
        bytes_sq[byte_i] = quicksilver_gfsecpar<QS>::combine_8_bits(bits_sq.data());
        if constexpr (!QS::is_verifier)
        {
            FAEST_ASSERT((bytes[byte_i].value() * bytes[byte_i].value())
                             .template reduce_to<QS::secpar_bits>() == bytes_sq[byte_i].value());
        }
    }
}

template <typename QS, owf O>
static void key_sched_bkwd(
    const QS* state, const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    std::array<quicksilver_gf2<QS>, 8 * OWF_CONSTANTS<QS::secpar_v, O>::OWF_KEY_SCHEDULE_SBOXES>&
        inv_outputs_bits)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    size_t i_wd = 0;         // bit index to the round key word we are currently handling
    size_t i_rcon = 0;       // round constant index
    bool remove_rcon = true; // flag indicating if we need to remove the round constant from the
                             // next word
    for (size_t sbox_j = 0; sbox_j < OC::OWF_KEY_SCHEDULE_SBOXES; ++sbox_j)
    {
        // load the witness byte
        auto sbox_out = state->template const_gf2_array<8>();
        for (size_t bit_i = 0; bit_i < 8; ++bit_i)
        {
            sbox_out[bit_i] = state->get_witness_bit(secpar_to_bits(S) + sbox_j * 8 + bit_i);
            // remove the byte that was xored in
            sbox_out[bit_i] = sbox_out[bit_i] + round_key_bits[i_wd + 8 * (sbox_j % 4) + bit_i];
        }
        // (possibly) remove the round constant
        if (sbox_j % 4 == 0 && remove_rcon)
        {
            // remove the round constant from the first byte of every word coming through the sboxes
            for (size_t bit_i = 0; bit_i < 8; ++bit_i)
            {
                if ((aes_round_constants[i_rcon] >> bit_i) & 1)
                {
                    sbox_out[bit_i] = sbox_out[bit_i] + 1;
                }
            }
            ++i_rcon;
        }

        // pointer to the part of the array that corresponds to the current sbox
        auto inv_out = &inv_outputs_bits[8 * sbox_j];
        for (size_t i = 0; i < 8; ++i)
            inv_out[(i + 1) % 8] = sbox_out[i];
        for (size_t i = 0; i < 8; ++i)
            inv_out[(i + 3) % 8] = inv_out[(i + 3) % 8] + sbox_out[i];
        for (size_t i = 0; i < 8; ++i)
            inv_out[(i + 6) % 8] = inv_out[(i + 6) % 8] + sbox_out[i];
        inv_out[0] = inv_out[0] + 1;
        inv_out[2] = inv_out[2] + 1;

        if (sbox_j % 4 == 3)
        {
            // increase i_wd to point to the next word
            if (S == secpar::s192)
            {
                i_wd += 192;
            }
            else
            {
                i_wd += 128;
                if (S == secpar::s256)
                {
                    remove_rcon = !remove_rcon;
                }
            }
        }
    }
}

template <typename QS, owf O>
void key_sched_constraints(
    QS* state, owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    auto key_schedule_inv_outs_bits =
        state->template const_gf2_array<8 * OC::OWF_KEY_SCHEDULE_SBOXES>();
    key_sched_fwd(state, round_key_bits.data());
    key_sched_bkwd<QS, O>(state, round_key_bits, key_schedule_inv_outs_bits);
    auto key_schedule_inv_outs =
        state->template const_gfsecpar_array<OC::OWF_KEY_SCHEDULE_SBOXES>();
    auto key_schedule_inv_outs_sq =
        state->template const_gfsecpar_array<OC::OWF_KEY_SCHEDULE_SBOXES>();

    if constexpr (is_owf_with_norm_proof(O))
    {
        lift_bits(round_key_bits, round_key_bytes);
        lift_bits_and_square(state, key_schedule_inv_outs_bits, key_schedule_inv_outs,
                             key_schedule_inv_outs_sq);
    }
    else if constexpr (is_owf_with_zero_sboxes(O))
    {
        lift_bits_and_square(state, round_key_bits, round_key_bytes, round_key_bytes_sq);
        lift_bits_and_square(state, key_schedule_inv_outs_bits, key_schedule_inv_outs,
                             key_schedule_inv_outs_sq);
    }
    else
    {
        lift_bits(round_key_bits, round_key_bytes);
        lift_bits(key_schedule_inv_outs_bits, key_schedule_inv_outs);
    }

    // byte index of the current word to read from the round keys
    size_t i_wd = 4 * (N_WD<S> - 1);
    // for 256 bit we only rotate every second time
    bool rotate_word = true;
    auto lhss = state->template const_gfsecpar_array<4>();
    auto rhss = state->template const_gfsecpar_array<4>();
    auto lhss_sq = state->template const_gfsecpar_array<4>();
    auto rhss_sq = state->template const_gfsecpar_array<4>();
    auto bits_sq = state->template const_gf2_array<8>();
    for (size_t sboxwd_j = 0; sboxwd_j < OC::OWF_KEY_SCHEDULE_SBOXES / 4; ++sboxwd_j)
    {
        if (rotate_word)
        {
            for (size_t row_k = 0; row_k < 4; ++row_k)
            {
                lhss[(row_k + 3) % 4] = round_key_bytes[i_wd + row_k];
                rhss[row_k] = key_schedule_inv_outs[4 * sboxwd_j + row_k];
                if constexpr (is_owf_with_zero_sboxes(O))
                {
                    if constexpr (is_owf_with_norm_proof(O))
                    {
                        square_8_bits(bits_sq.data(), &round_key_bits[8 * (i_wd + row_k)]);
                        lhss_sq[(row_k + 3) % 4] =
                            quicksilver_gfsecpar<QS>::combine_8_bits(bits_sq.data());
                    }
                    else
                    {
                        lhss_sq[(row_k + 3) % 4] = round_key_bytes_sq[i_wd + row_k];
                    }
                    rhss_sq[row_k] = key_schedule_inv_outs_sq[4 * sboxwd_j + row_k];
                }
            }
        }
        else
        {
            for (size_t row_k = 0; row_k < 4; ++row_k)
            {
                lhss[row_k] = round_key_bytes[i_wd + row_k];
                rhss[row_k] = key_schedule_inv_outs[4 * sboxwd_j + row_k];
                if constexpr (is_owf_with_zero_sboxes(O))
                {
                    if constexpr (is_owf_with_norm_proof(O))
                    {
                        square_8_bits(bits_sq.data(), &round_key_bits[8 * (i_wd + row_k)]);
                        lhss_sq[row_k] = quicksilver_gfsecpar<QS>::combine_8_bits(bits_sq.data());
                    }
                    else
                    {
                        lhss_sq[row_k] = round_key_bytes_sq[i_wd + row_k];
                    }
                    rhss_sq[row_k] = key_schedule_inv_outs_sq[4 * sboxwd_j + row_k];
                }
            }
        }
        for (size_t row_k = 0; row_k < 4; ++row_k)
        {
            if constexpr (is_owf_with_zero_sboxes(O))
            {
                const auto x = lhss[row_k];
                const auto x_sq = lhss_sq[row_k];
                const auto y = rhss[row_k];
                const auto y_sq = rhss_sq[row_k];
                state->add_constraint(x_sq * y + x);
                state->add_constraint(x * y_sq + y);
            }
            else
            {
                state->add_inverse_constraints(lhss[row_k], rhss[row_k]);
            }
        }
        // increase i_wd to point to the next word
        if (S == secpar::s192)
        {
            i_wd += 24;
        }
        else
        {
            i_wd += 16;
            if (S == secpar::s256)
            {
                rotate_word = !rotate_word;
            }
        }
    }
}

// load the round keys into quicksilver values and "bake" EM secret key into the first round key
template <typename QS, owf O>
void load_fixed_round_key(
    const QS* state, owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq,
    const rijndael_round_keys<QS::secpar_v>* fixed_key)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    const uint8_t* rk_bytes = (const uint8_t*)fixed_key;
    auto bits_sq = state->template const_gf2_array<8>();

    for (size_t byte_j = 0; byte_j < OC::OWF_BLOCK_SIZE; ++byte_j)
    {
        for (size_t bit_i = 0; bit_i < 8; ++bit_i)
        {
            round_key_bits[8 * byte_j + bit_i] =
                poly1::load(rk_bytes[byte_j], bit_i) + state->get_witness_bit(8 * byte_j + bit_i);
        }
        round_key_bytes[byte_j] =
            quicksilver_gfsecpar<QS>::combine_8_bits(&round_key_bits[8 * byte_j]);
        if constexpr (is_owf_with_zero_sboxes(O) && !is_owf_with_norm_proof(O))
        {
            square_8_bits(bits_sq.data(), &round_key_bits[8 * byte_j]);
            round_key_bytes_sq[byte_j] = quicksilver_gfsecpar<QS>::combine_8_bits(bits_sq.data());
        }
    }

    for (size_t byte_j = OC::OWF_BLOCK_SIZE; byte_j < OC::OWF_BLOCK_SIZE * (OC::OWF_ROUNDS + 1);
         ++byte_j)
    {
        for (size_t bit_i = 0; bit_i < 8; ++bit_i)
        {
            round_key_bits[8 * byte_j + bit_i] =
                quicksilver_gf2<QS>(poly1::load(rk_bytes[byte_j], bit_i), state);
        }
        round_key_bytes[byte_j] =
            quicksilver_gfsecpar<QS>::combine_8_bits(&round_key_bits[8 * byte_j]);
        if constexpr (is_owf_with_zero_sboxes(O) && !is_owf_with_norm_proof(O))
        {
            square_8_bits(bits_sq.data(), &round_key_bits[8 * byte_j]);
            round_key_bytes_sq[byte_j] = quicksilver_gfsecpar<QS>::combine_8_bits(bits_sq.data());
        }
    }
}

} // namespace faest::zk

#endif
