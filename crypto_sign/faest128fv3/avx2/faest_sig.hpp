#ifndef FAEST_SIG_HPP
#define FAEST_SIG_HPP

#include "constants.hpp"
#include "faest.hpp"
#include "parameters.hpp"

#include <span>

namespace faest
{

namespace detail
{

// Non-owning view of a FAEST signature.
//
// - `P` is a FAEST parameter set
// - `Byte` is a byte type, e.g., `uint8_t` or `const uint8_t`
template <typename P, typename Byte>
    requires(sizeof(Byte) == 1)
struct signature_view
{
    constexpr static inline size_t SIZE = FAEST_SIGNATURE_BYTES<P>;

  private:
    using CP = P::CONSTS;
    using OC = P::OWF_CONSTS;
    // Span of the whole signature.
    std::span<Byte, SIZE> const data_;

  public:
    // Construct a `signature_view` from pointer `p` that points to a buffer of at least
    // `FAEST_SIGNATURE_BYTES<P>` bytes.  The view does *not* take ownership of the buffer and is
    // only valid as long as the provided buffer is valid.
    signature_view(Byte* p) : data_(p, SIZE) {};

    // Sizes of the various fields in bytes.
    constexpr static std::size_t SIZE_VOLE_COMMITMENT = CP::VOLE_COMMIT_SIZE;
    constexpr static std::size_t SIZE_VOLE_COMMITMENT_CORRECTIONS =
        CP::VOLE_COMMIT_CORRECTIONS_SIZE;
    constexpr static std::size_t SIZE_VOLE_COMMITMENT_CMULT = CP::VOLE_COMMIT_CMULT_SIZE;
    static_assert(SIZE_VOLE_COMMITMENT ==
                  SIZE_VOLE_COMMITMENT_CORRECTIONS + SIZE_VOLE_COMMITMENT_CMULT);
    constexpr static std::size_t SIZE_VOLE_CHECK_PROOF = CP::VOLE_CHECK::PROOF_BYTES;
    constexpr static std::size_t SIZE_CORRECTION = (OC::WITNESS_BITS + 7) / 8;
    constexpr static std::size_t SIZE_QS_PROOF = CP::QS::PROOF_BYTES;
    constexpr static std::size_t SIZE_VECCOM_OPEN = P::bavc_t::OPEN_SIZE;
    constexpr static std::size_t SIZE_DELTA = P::secpar_bytes;
    constexpr static std::size_t SIZE_IV_PRE = 16;
    constexpr static std::size_t SIZE_GRINDING_CTR = P::use_grinding ? P::grinding_counter_size : 0;

    // Offsets of the various fields in bytes from the start of the signature.
    constexpr static std::size_t OFFSET_VOLE_COMMITMENT = 0;
    constexpr static std::size_t OFFSET_VOLE_COMMITMENT_CORRECTIONS = OFFSET_VOLE_COMMITMENT;
    constexpr static std::size_t OFFSET_VOLE_COMMITMENT_CMULT =
        OFFSET_VOLE_COMMITMENT_CORRECTIONS + SIZE_VOLE_COMMITMENT_CORRECTIONS;
    constexpr static std::size_t OFFSET_VOLE_CHECK_PROOF =
        OFFSET_VOLE_COMMITMENT + SIZE_VOLE_COMMITMENT;
    constexpr static std::size_t OFFSET_CORRECTION =
        OFFSET_VOLE_CHECK_PROOF + SIZE_VOLE_CHECK_PROOF;
    constexpr static std::size_t OFFSET_QS_PROOF = OFFSET_CORRECTION + SIZE_CORRECTION;
    constexpr static std::size_t OFFSET_VECCOM_OPEN = OFFSET_QS_PROOF + SIZE_QS_PROOF;
    constexpr static std::size_t OFFSET_DELTA = OFFSET_VECCOM_OPEN + SIZE_VECCOM_OPEN;
    constexpr static std::size_t OFFSET_IV_PRE = OFFSET_DELTA + SIZE_DELTA;
    constexpr static std::size_t OFFSET_GRINDING_CTR = OFFSET_IV_PRE + SIZE_IV_PRE;

    // Get a span to the whole signature.
    ALWAYS_INLINE std::span<uint8_t, SIZE> signature() const { return data_; }
    // Get a span to the VOLECommit commitment.
    ALWAYS_INLINE auto vole_commitment() const
    {
        return data_.template subspan<OFFSET_VOLE_COMMITMENT, SIZE_VOLE_COMMITMENT>();
    }
    // Get a span to the VOLECommit commitment corrections (which ensure all small VOLEs have the
    // same value).
    // This is a subspan of the `vole_commitment` (and identical if CRT VOLECommit is not used).
    ALWAYS_INLINE auto vole_commitment_corrections() const
    {
        return data_.template subspan<OFFSET_VOLE_COMMITMENT_CORRECTIONS,
                                      SIZE_VOLE_COMMITMENT_CORRECTIONS>();
    }
    // Get a span to the VOLECommit commitment c_mult matrix (if CRT VOLECommit is used).
    // This is a subspan of the `vole_commitment`.
    ALWAYS_INLINE auto vole_commitment_cmult() const
        requires(P::use_crt_vole_masks)
    {
        return data_.template subspan<OFFSET_VOLE_COMMITMENT_CMULT, SIZE_VOLE_COMMITMENT_CMULT>();
    }
    // Get a span to the VOLECheck proof, i.e., the VOLEHash of u.
    ALWAYS_INLINE auto vole_check_proof() const
    {
        return data_.template subspan<OFFSET_VOLE_CHECK_PROOF, SIZE_VOLE_CHECK_PROOF>();
    }
    // Get a span to the correction that correct the random VOLE to the witness.
    ALWAYS_INLINE auto correction() const
    {
        return data_.template subspan<OFFSET_CORRECTION, SIZE_CORRECTION>();
    }
    // Get a span to the QuickSilver proof, i.e., the non-constant coefficients of the ZKHash.
    ALWAYS_INLINE auto qs_proof() const
    {
        return data_.template subspan<OFFSET_QS_PROOF, SIZE_QS_PROOF>();
    }
    // Get a span to the vector commitment opening.
    ALWAYS_INLINE auto veccom_open() const
    {
        return data_.template subspan<OFFSET_VECCOM_OPEN, SIZE_VECCOM_OPEN>();
    }
    // Get a span to Delta.
    ALWAYS_INLINE auto delta() const { return data_.template subspan<OFFSET_DELTA, SIZE_DELTA>(); }
    // Get a span to iv^pre.
    ALWAYS_INLINE auto iv_pre() const
    {
        return data_.template subspan<OFFSET_IV_PRE, SIZE_IV_PRE>();
    }
    // Get a span to the grinding counter if grinding is used.
    ALWAYS_INLINE auto grinding_ctr() const
        requires(P::use_grinding)
    {
        return data_.template subspan<OFFSET_GRINDING_CTR, SIZE_GRINDING_CTR>();
    }

    // Verify that the signature is well-formed w.r.t. delta and c_mult.
    [[nodiscard("The signature must not verify if the format checks do not pass")]]
    ALWAYS_INLINE bool check_format() const
    {
        if constexpr (P::use_grinding)
        {
            // Check that the prover actually did its grinding.
            for (size_t i = P::secpar_bits - 1; i >= CP::VEC_COM::delta_bits_v; --i)
                if ((this->delta()[i / 8] >> (i % 8)) & 1)
                    return false;
        }
        if constexpr (P::use_crt_vole_masks)
        {
            // Verify that each row of c_mult is padded with zeros to full bytes.
            constexpr auto N_MASK = P::CONSTS::CRT_NUM_MASK;
            constexpr auto N_MULT = P::CONSTS::CRT_NUM_MULT;
            constexpr auto N_MULT_BYTES = P::CONSTS::CRT_NUM_MULT_BYTES;
            constexpr auto PADDING_BITS = N_MULT % 8;
            if constexpr (PADDING_BITS)
            {
                // Create mask where the upper PADDING_BITS are set.
                constexpr auto MASK = ~((uint8_t{1} << (8 - PADDING_BITS)) - 1);
                for (size_t m = 0; m < N_MASK; ++m)
                    if (this->vole_commitment_cmult()[(m + 1) * N_MULT_BYTES - 1] & MASK)
                        return false;
            }
        }
        return true;
    }

    static_assert(OFFSET_GRINDING_CTR + SIZE_GRINDING_CTR == SIZE,
                  "The end of the last field needs to match the end of the signature.");
};

} // namespace detail

// Read-only view of a FAEST signature. See `detail::signature_view` for documentation.
template <typename P> using faest_signature = detail::signature_view<P, const uint8_t>;
// Mutable view of a FAEST signature. See `detail::signature_view` for documentation.
template <typename P> using mutable_faest_signature = detail::signature_view<P, uint8_t>;

} // namespace faest

#endif
