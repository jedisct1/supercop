#ifndef FAEST_INC
#define FAEST_INC

#include "faest.hpp"
#include "faest_keys.inc"
#include "faest_sig.hpp"

#include "hash.hpp"
#include "kos_vole_check.hpp"
#include "owf_proof.hpp"
#include "quicksilver.hpp"
#include "small_vole.hpp"
#include "transpose_secpar.hpp"
#include "util.hpp"
#include "vector_com.inc"
#include "vole_check.hpp"
#include "vole_commit.hpp"

#include <cassert>
#include <cstdlib>

namespace faest
{

template <typename P>
bool faest_sign(uint8_t* signature_p, const uint8_t* msg, size_t msg_len, const uint8_t* sk_packed,
                const uint8_t* random_seed, size_t random_seed_len)
{
    using CP = P::CONSTS;
    using OC = P::OWF_CONSTS;
    constexpr auto S = P::secpar_v;

    secret_key<P> sk;
    uint8_t pk_packed[FAEST_PUBLIC_KEY_BYTES<P>];
    if (!faest_unpack_sk_and_get_pubkey<P>(pk_packed, sk_packed, &sk))
        return false;

    const mutable_faest_signature<P> signature = signature_p;

    // TODO: Do we need to domain separate by the faest parameters?

    // SHAKE hash state the we will keep reusing.
    hash_state hasher;

    // mu <- H_2^0(pk || msg)
    block_2secpar<S> mu;
    hasher.init(S);
    hasher.update(pk_packed, FAEST_PUBLIC_KEY_BYTES<P>);
    hasher.update(msg, msg_len);
    hasher.update_byte(8 + 0);
    hasher.finalize(&mu, sizeof(mu));

    // (r, iv^pre) <- H_3(sk || mu || rho)
    block_secpar<S> seed; // r
    block128 iv;
    block128 iv_pre;
    std::array<uint8_t, sizeof(seed) + sizeof(iv_pre)> seed_iv_pre;
    hasher.init(S);
    hasher.update(&sk.sk, sizeof(sk.sk));
    hasher.update(&mu, sizeof(mu));
    if (random_seed) // rho (NB: spec assumes rho is always given and \lambda bit long)
        hasher.update(random_seed, random_seed_len);
    hasher.update_byte(3);
    hasher.finalize(seed_iv_pre.data(), sizeof(seed_iv_pre));
    memcpy(&seed, seed_iv_pre.data(), sizeof(seed));
    memcpy(&iv_pre, &seed_iv_pre[sizeof(seed)], sizeof(iv_pre));

    // iv <- H_4(iv^pre || mu)
    hasher.init(S);
    hasher.update(&iv_pre, sizeof(iv_pre));
    if constexpr (P::use_v3_hash_inputs)
    {
        hasher.update(&mu, sizeof(mu));
    }
    hasher.update_byte(4);
    hasher.finalize(reinterpret_cast<uint8_t*>(&iv), sizeof(iv));

    auto vole_com_data_e = vole_commit_data<P, false>::alloc();
    FAEST_ASSERT(vole_com_data_e);
    if (!vole_com_data_e)
        return false;
    const auto vole_com_data = std::move(*vole_com_data_e);

    std::array<uint8_t, CP::VOLE_COMMIT_CHECK_SIZE> vole_commit_check;

    if constexpr (!P::use_crt_vole_masks)
    {
        vole_commit<P>(seed, iv, vole_com_data, signature.vole_commitment_corrections(),
                       vole_commit_check);
        static_assert(CP::QUICKSILVER_ROWS_PADDED % TRANSPOSE_BITS_ROWS == 0, "");
        transpose_secpar<S>(vole_com_data.v_columns().data(), vole_com_data.v().data(),
                            CP::VOLE_COL_STRIDE, CP::QUICKSILVER_ROWS_PADDED);
    }
    else
    {
        crt_vole_commit<P>(seed, iv, vole_com_data, signature.vole_commitment_corrections(),
                           vole_commit_check, signature.vole_commitment_cmult());
    }

    // chall_1 <- H_2^1(mu || com || c_1 || ... || c_\tau-1 || iv_pre)
    std::array<uint8_t, CP::VOLE_CHECK::CHALLENGE_BYTES> chal1;
    hasher.init(S);
    hasher.update(&mu, sizeof(mu));
    hasher.update(vole_commit_check);
    hasher.update(signature.vole_commitment_corrections());
    if constexpr (P::use_crt_vole_masks)
    {
        hasher.update(signature.vole_commitment_cmult());
    }
    if constexpr (P::use_v3_hash_inputs)
    {
        // Specified in >= v3.
        hasher.update(&iv_pre, sizeof(iv_pre));
    }
    else
    {
        // Specified in v2.
        hasher.update(&iv, sizeof(iv));
    }
    hasher.update_byte(8 + 1);
    hasher.finalize(chal1);

    // chall_2 <- H_2^2(chall_1 || \tilde{u} || h_V || d)
    std::array<uint8_t, CP::QS::CHALLENGE_BYTES> chal2;
    hasher.init(S);
    hasher.update(chal1);

    if constexpr (!P::use_crt_vole_masks)
    {
        // vole_check_sender hashes u_tilde and V_tilde
        vole_check_sender<P>(vole_com_data.u().data(), vole_com_data.v_columns().data(),
                             chal1.data(), signature.vole_check_proof().data(), hasher);
    }
    else
    {

        kos_vole_check_sender<P>(
            vole_com_data.u_bytes().template subspan<0, CP::VOLE_CORRECTION_BYTES>(),
            vole_com_data.v().template subspan<0, CP::VOLE_CORRECTION_ROWS>(),
            vole_com_data.u_mask(), vole_com_data.v_mask(), chal1, signature.vole_check_proof(),
            hasher);
    }

    auto correction = signature.correction();
    constexpr size_t remainder = (OC::WITNESS_BITS / 8) % (16 * CP::VOLE_BLOCK);
    for (size_t i = 0; i < CP::WITNESS_BLOCKS - (remainder != 0); ++i)
    {
        vole_block correction_i = vole_com_data.u()[i] ^ sk.witness[i];
        memcpy(&correction[i * sizeof(vole_block)], &correction_i, sizeof(vole_block));
    }
    if constexpr (remainder)
    {
        vole_block correction_i =
            vole_com_data.u()[CP::WITNESS_BLOCKS - 1] ^ sk.witness[CP::WITNESS_BLOCKS - 1];
        memcpy(&correction[(CP::WITNESS_BLOCKS - 1) * sizeof(vole_block)], &correction_i,
               remainder);
    }

    // continue with H_2^2
    hasher.update(correction);
    FAEST_ASSERT(correction.size() == OC::WITNESS_BITS / 8);
    hasher.update_byte(8 + 2);
    hasher.finalize(chal2);

    const auto* witness = sk.witness.data();
    // With CRT VOLE Commit, we only use the first WITNESS_BITS of u, so we can avoid this copy.
    if constexpr (CP::QUICKSILVER_ROWS > OC::WITNESS_BITS){
        memcpy(vole_com_data.u().data(), &sk.witness[0], OC::WITNESS_BITS / 8);
        witness = vole_com_data.u().data();
    }

    quicksilver_state<S, false, OC::QS_DEGREE> qs(
        reinterpret_cast<const uint8_t*>(witness), vole_com_data.v().data(),
        OC::OWF_NUM_CONSTRAINTS, chal2.data());
    owf_constraints(&qs, &sk.pk);

    std::array<uint8_t, CP::QS::CHECK_BYTES> qs_check;
    if constexpr (!P::use_crt_vole_masks)
    {
        qs.prove(OC::WITNESS_BITS, signature.qs_proof().data(), qs_check.data());
    }
    else
    {
        qs.prove(vole_com_data.u_mask().data(), vole_com_data.v_mask().data(),
                 signature.qs_proof().data(), qs_check.data());
    }

    memcpy(signature.iv_pre().data(), &iv_pre, sizeof(iv_pre));

    if constexpr (!P::use_grinding)
    {
        // chall_3 <- H_2^3(chall_2 || \tilde{a}_0 || \tilde{a}_1 || \tilde{a}_2)
        hasher.init(S);
        hasher.update(chal2);
        hasher.update(qs_check);
        hasher.update(signature.qs_proof());
        hasher.update_byte(8 + 3);
        hasher.finalize(signature.delta());

        std::array<uint8_t, P::delta_bits_v> delta_bytes;
        expand_bits_to_bytes(delta_bytes.data(), P::delta_bits_v, signature.delta().data());

        P::bavc_t::open(vole_com_data.forest().data(), vole_com_data.hashed_leaves().data(),
                        delta_bytes.data(), signature.veccom_open().data());
    }
    else
    {
        // chall_3 <- H_2^3(chall_2 || \tilde{a}_0 || \tilde{a}_1 || \tilde{a}_2 || ctr)
        // Initialize a 4x hasher and hash the common input prefix.
        hash_state_x4 grinding_hasher;
        grinding_hasher.init(S);
        grinding_hasher.update_1(chal2);
        grinding_hasher.update_1(qs_check);
        grinding_hasher.update_1(signature.qs_proof());
        uint32_t counter;
        bool open_success = grind_and_open<typename P::bavc_t>(
            vole_com_data.forest().data(), vole_com_data.hashed_leaves().data(),
            signature.delta().data(), signature.veccom_open().data(), &grinding_hasher, &counter);
        // Opening fails with a negligible probability, so we can assume it succeeds.
        FAEST_ASSERT(open_success);
        if (!open_success)
            return false;
        // Store counter in the signature.
        signature.grinding_ctr()[0] = counter;
        signature.grinding_ctr()[1] = counter >> 8;
        signature.grinding_ctr()[2] = counter >> 16;
        signature.grinding_ctr()[3] = counter >> 24;
    }

    FAEST_ASSERT(signature.check_format());
    return true;
}

template <typename P>
bool faest_verify(const uint8_t* signature_p, const uint8_t* msg, size_t msg_len,
                  const uint8_t* pk_packed)
{
    using CP = P::CONSTS;
    using OC = P::OWF_CONSTS;
    constexpr auto S = P::secpar_v;

    const faest_signature<P> signature = signature_p;
    if (!signature.check_format())
        return false;

    // SHAKE hash state the we will keep reusing.
    hash_state hasher;

    // mu <- H_2^0(pk || msg)
    block_2secpar<S> mu;
    hasher.init(S);
    hasher.update(pk_packed, FAEST_PUBLIC_KEY_BYTES<P>);
    hasher.update(msg, msg_len);
    hasher.update_byte(8 + 0);
    hasher.finalize(&mu, sizeof(mu));

    block128 iv;

    // iv <- H_4(iv^pre || mu || mu || mu || mu || mu || mu || mu || mu || mu)
    hasher.init(S);
    hasher.update(signature.iv_pre());
    if constexpr (P::use_v3_hash_inputs)
    {
        hasher.update(&mu, sizeof(mu));
    }
    hasher.update_byte(4);
    hasher.finalize(reinterpret_cast<uint8_t*>(&iv), sizeof(iv));

    std::array<uint8_t, P::delta_bits_v> delta_bytes;
    expand_bits_to_bytes(delta_bytes.data(), P::delta_bits_v, signature.delta().data());
    block_secpar<S> delta;
    memcpy(&delta, signature.delta().data(), sizeof(delta));

    auto vole_com_data_e = vole_commit_data<P, true>::alloc();
    FAEST_ASSERT(vole_com_data_e);
    if (!vole_com_data_e)
        return false;
    const auto vole_com_data = std::move(*vole_com_data_e);

    std::array<uint8_t, CP::VOLE_COMMIT_CHECK_SIZE> vole_commit_check;

    if constexpr (!P::use_crt_vole_masks)
    {
        if (!vole_reconstruct<P>(iv, vole_com_data, delta_bytes.data(),
                                 signature.vole_commitment_corrections(), signature.veccom_open(),
                                 vole_commit_check))
            return false;
    }
    else
    {
        if (!crt_vole_reconstruct<P>(
                iv, vole_com_data, delta, signature.vole_commitment_corrections(),
                signature.veccom_open(), vole_commit_check, signature.vole_commitment_cmult()))
            return false;
        delta = crt_lift_delta<P>(delta);
    }

    // chall_1 <- H_2^1(mu || com || c_1 || ... || c_\tau-1 || iv_pre)
    std::array<uint8_t, CP::VOLE_CHECK::CHALLENGE_BYTES> chal1;
    hasher.init(S);
    hasher.update(&mu, sizeof(mu));
    hasher.update(vole_commit_check);
    hasher.update(signature.vole_commitment_corrections());
    if constexpr (P::use_crt_vole_masks)
    {
        hasher.update(signature.vole_commitment_cmult());
    }
    if constexpr (P::use_v3_hash_inputs)
    {
        // Specified in >= v3.
        hasher.update(signature.iv_pre());
    }
    else
    {
        // Specified in v2.
        hasher.update(&iv, sizeof(iv));
    }
    hasher.update_byte(8 + 1);
    hasher.finalize(chal1);

    // chall_2 <- H_2^2(chall_1 || \tilde{u} || h_V || d)
    std::array<uint8_t, CP::QS::CHALLENGE_BYTES> chal2;
    hasher.init(S);
    hasher.update(chal1);

    // vole_check_receiver hashes D
    if constexpr (!P::use_crt_vole_masks)
    {
        hasher.update(signature.vole_check_proof());
        vole_check_receiver<P>(vole_com_data.q_columns().data(), delta_bytes.data(), chal1.data(),
                               signature.vole_check_proof().data(), hasher);
    }
    else
    {
        kos_vole_check_receiver<P>(
            delta, vole_com_data.q().template subspan<0, CP::VOLE_CORRECTION_ROWS>(),
            vole_com_data.q_mask(), chal1, signature.vole_check_proof(), hasher);
    }

    // continue with H_2^2
    hasher.update(signature.correction());
    hasher.update_byte(8 + 2);
    hasher.finalize(chal2);

    std::array<vole_block, CP::WITNESS_BLOCKS> correction_blocks;
    memcpy(&correction_blocks, signature.correction().data(), signature.correction().size());
    memset(reinterpret_cast<uint8_t*>(correction_blocks.data()) + OC::WITNESS_BITS / 8, 0,
           sizeof(correction_blocks) - OC::WITNESS_BITS / 8);

    if constexpr (!P::use_crt_vole_masks)
    {
        vole_receiver_apply_correction<P>(CP::WITNESS_BLOCKS, P::delta_bits_v,
                                          correction_blocks.data(),
                                          vole_com_data.q_columns().data(), delta_bytes.data());

        transpose_secpar<S>(vole_com_data.q_columns().data(), vole_com_data.q().data(),
                            CP::VOLE_COL_STRIDE, CP::QUICKSILVER_ROWS_PADDED);
    }
    else
    {
        // Apply correction
        const auto d = signature.correction();
        const auto q = vole_com_data.q();
        for (size_t i = 0; i < CP::VOLE_CORRECTION_ROWS; ++i)
        {
            if ((d[i / 8] >> (i % 8)) & 1)
                q[i] = q[i] ^ delta;
        }
    }

    public_key<P> pk;
    faest_unpack_public_key(&pk, pk_packed);

    quicksilver_state<S, true, OC::QS_DEGREE> qs(vole_com_data.q().data(), OC::OWF_NUM_CONSTRAINTS,
                                                 delta, chal2.data());
    owf_constraints(&qs, &pk);

    std::array<uint8_t, CP::QS::CHECK_BYTES> qs_check;
    if constexpr (!P::use_crt_vole_masks)
    {
        qs.verify(OC::WITNESS_BITS, signature.qs_proof().data(), qs_check.data());
    }
    else
    {
        qs.verify(vole_com_data.q_mask().data(), signature.qs_proof().data(), qs_check.data());
    }

    // chall_3' <- H_2^3(chall_2 || \tilde{a}_0 || \tilde{a}_1 || \tilde{a}_2 [|| ctr])
    block_secpar<S> delta_check;
    hasher.init(S);
    hasher.update(chal2.data(), sizeof(chal2));
    hasher.update(qs_check.data(), CP::QS::CHECK_BYTES);
    hasher.update(signature.qs_proof());
    if constexpr (P::use_grinding)
    {
        hasher.update(signature.grinding_ctr());
    }
    hasher.update_byte(8 + 3);
    hasher.finalize(&delta_check, sizeof(delta_check));

    return memcmp(signature.delta().data(), &delta_check, sizeof(delta_check)) == 0;
}

} // namespace faest

#endif
