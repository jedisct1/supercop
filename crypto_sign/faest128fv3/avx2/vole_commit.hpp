#ifndef VOLE_COMMIT_HPP
#define VOLE_COMMIT_HPP

#include "block.hpp"
#include "util.hpp"

#include <cstdlib>
#include <expected>
#include <span>
#include <variant>

namespace faest
{

template <typename P, bool VERIFIER> struct vole_commit_data
{
  private:
    constexpr static auto S = P::secpar_v;

    block_secpar<S>* forest_ = nullptr;
    unsigned char* hashed_leaves_ = nullptr;
    vole_block* u_ = nullptr;
    vole_block* vq_columns_ = nullptr;
    block_secpar<S>* vq_ = nullptr;
    block_secpar<S>* u_mask_ = nullptr;
    block_secpar<S>* vq_mask_ = nullptr;

  public:
    ALWAYS_INLINE auto forest() const
        requires(!VERIFIER)
    {
        return std::span<block_secpar<S>, P::bavc_t::COMMIT_NODES>(forest_,
                                                                   P::bavc_t::COMMIT_NODES);
    }
    ALWAYS_INLINE auto hashed_leaves() const
        requires(!VERIFIER)
    {
        return std::span<unsigned char, P::bavc_t::COMMIT_LEAVES * P::leaf_hash_t::hash_len>(
            hashed_leaves_, P::bavc_t::COMMIT_LEAVES * P::leaf_hash_t::hash_len);
    }

    ALWAYS_INLINE auto u() const
        requires(!VERIFIER)
    {
        return std::span<vole_block, P::CONSTS::VOLE_COL_BLOCKS>(u_, P::CONSTS::VOLE_COL_BLOCKS);
    }

    ALWAYS_INLINE auto u_bytes() const
        requires(!VERIFIER)
    {
        return std::span<uint8_t, P::CONSTS::VOLE_BYTES>(reinterpret_cast<uint8_t*>(u_),
                                                         P::CONSTS::VOLE_BYTES);
    }

    ALWAYS_INLINE auto v_columns() const
        requires(!VERIFIER)
    {
        return std::span<vole_block, P::secpar_bits * P::CONSTS::VOLE_COL_BLOCKS>(
            vq_columns_, P::secpar_bits * P::CONSTS::VOLE_COL_BLOCKS);
    }

    ALWAYS_INLINE auto q_columns() const
        requires(VERIFIER)
    {
        return std::span<vole_block, P::secpar_bits * P::CONSTS::VOLE_COL_BLOCKS>(
            vq_columns_, P::secpar_bits * P::CONSTS::VOLE_COL_BLOCKS);
    }

    ALWAYS_INLINE auto v() const
        requires(!VERIFIER)
    {
        return std::span<block_secpar<S>, P::CONSTS::VOLE_ROWS_PADDED>(vq_,
                                                                       P::CONSTS::VOLE_ROWS_PADDED);
    }

    ALWAYS_INLINE auto q() const
        requires(VERIFIER)
    {
        return std::span<block_secpar<S>, P::CONSTS::VOLE_ROWS_PADDED>(vq_,
                                                                       P::CONSTS::VOLE_ROWS_PADDED);
    }

    ALWAYS_INLINE auto u_mask() const
        requires(!VERIFIER && P::use_crt_vole_masks)
    {
        return std::span<block_secpar<S>, P::CONSTS::CRT_NUM_MASK>(u_mask_,
                                                                   P::CONSTS::CRT_NUM_MASK);
    }

    ALWAYS_INLINE auto v_mask() const
        requires(!VERIFIER && P::use_crt_vole_masks)
    {
        return std::span<block_secpar<S>, P::CONSTS::CRT_NUM_MASK>(vq_mask_,
                                                                   P::CONSTS::CRT_NUM_MASK);
    }

    ALWAYS_INLINE auto q_mask() const
        requires(VERIFIER && P::use_crt_vole_masks)
    {
        return std::span<block_secpar<S>, P::CONSTS::CRT_NUM_MASK>(vq_mask_,
                                                                   P::CONSTS::CRT_NUM_MASK);
    }

    static std::expected<vole_commit_data<P, VERIFIER>, std::monostate> alloc()
    {
        using CP = P::CONSTS;
        constexpr auto S = P::secpar_v;

        // Value returned on allocation errors
        constexpr auto ERROR = std::unexpected(std::monostate{});

        // Destructor calls `free` on all pointers, no need for manual cleanup.
        vole_commit_data<P, VERIFIER> data;

        if constexpr (!VERIFIER)
        {
            data.forest_ = reinterpret_cast<block_secpar<S>*>(aligned_alloc(
                alignof(block_secpar<S>), P::bavc_t::COMMIT_NODES * sizeof(block_secpar<S>)));
            if (!data.forest_)
                return ERROR;
            data.hashed_leaves_ = reinterpret_cast<unsigned char*>(aligned_alloc(
                alignof(block_2secpar<S>), P::bavc_t::COMMIT_LEAVES * P::leaf_hash_t::hash_len));
            if (!data.hashed_leaves_)
                return ERROR;
            data.u_ = reinterpret_cast<vole_block*>(
                aligned_alloc(alignof(vole_block), CP::VOLE_COL_BLOCKS * sizeof(vole_block)));
            if (!data.u_)
                return ERROR;
            if constexpr (P::use_crt_vole_masks)
            {
                data.u_mask_ = reinterpret_cast<block_secpar<S>*>(aligned_alloc(
                    alignof(block_secpar<S>), CP::CRT_NUM_MASK * sizeof(block_secpar<S>)));
                if (!data.u_mask_)
                    return ERROR;
            }
        }
        data.vq_columns_ = reinterpret_cast<vole_block*>(aligned_alloc(
            alignof(vole_block), P::secpar_bits * CP::VOLE_COL_BLOCKS * sizeof(vole_block)));
        if (!data.vq_columns_)
            return ERROR;
        // XXX: QUICKSILVER_ROWS_PADDED or VOLE_ROWS_PADDED ?
        data.vq_ = reinterpret_cast<block_secpar<S>*>(aligned_alloc(
            alignof(block_secpar<S>), CP::VOLE_ROWS_PADDED * sizeof(block_secpar<S>)));
        if (!data.vq_)
            return ERROR;
        if constexpr (P::use_crt_vole_masks)
        {
            data.vq_mask_ = reinterpret_cast<block_secpar<S>*>(aligned_alloc(
                alignof(block_secpar<S>), CP::CRT_NUM_MASK * sizeof(block_secpar<S>)));
            if (!data.vq_mask_)
                return ERROR;
        }

        return data;
    }

    ~vole_commit_data()
    {
        std::free(this->forest_);
        std::free(this->hashed_leaves_);
        std::free(this->u_);
        std::free(this->vq_columns_);
        std::free(this->vq_);
        std::free(this->u_mask_);
        std::free(this->vq_mask_);
    }
    vole_commit_data(const vole_commit_data&) = delete;
    vole_commit_data& operator=(const vole_commit_data&) = delete;
    vole_commit_data(vole_commit_data&& other) noexcept
        : forest_(std::exchange(other.forest_, nullptr)),
          hashed_leaves_(std::exchange(other.hashed_leaves_, nullptr)),
          u_(std::exchange(other.u_, nullptr)),
          vq_columns_(std::exchange(other.vq_columns_, nullptr)),
          vq_(std::exchange(other.vq_, nullptr)), u_mask_(std::exchange(other.u_mask_, nullptr)),
          vq_mask_(std::exchange(other.vq_mask_, nullptr))
    {
    }

    vole_commit_data& operator=(vole_commit_data&& other) noexcept
    {
        if (this != &other)
        {
            std::free(this->forest_);
            std::free(this->hashed_leaves_);
            std::free(this->u_);
            std::free(this->vq_columns_);
            std::free(this->vq_);
            std::free(this->u_mask_);
            std::free(this->vq_mask_);

            this->forest_ = std::exchange(other.forest_, nullptr);
            this->hashed_leaves_ = std::exchange(other.hashed_leaves_, nullptr);
            this->u_ = std::exchange(other.u_, nullptr);
            this->vq_columns_ = std::exchange(other.vq_columns_, nullptr);
            this->vq_ = std::exchange(other.vq_, nullptr);
            this->u_mask_ = std::exchange(other.u_mask_, nullptr);
            this->vq_mask_ = std::exchange(other.vq_mask_, nullptr);
        }

        return *this;
    }

  private:
    vole_commit_data() = default;
};

// Run the vector commitment and the small vole protocols.
// - `forest` must be `VECTOR_COMMIT_NODES` blocks long.
// - `hashed_leaves` must be VECTOR_COMMIT_LEAVES * P::leaf_hash_t::hash_len bytes long.
// - `u` must be `VOLE_COL_BLOCKS` long
// - `v` must be `SECURITY_PARAM * VOLE_COL_BLOCKS` long
// - `commitment` must be `(TAU - 1) * VOLE_ROWS / 8` long
// - `check` must be `2 * SECURITY_PARAM / 8` long
template <typename P>
void vole_commit(block_secpar<P::secpar_v> seed, block128 iv,
                 const vole_commit_data<P, false>& data,
                 std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
                 std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check);

// - `q` must be `SECURITY_PARAM * VOLE_COL_BLOCKS` long
// - `delta_bytes` must be `SECURITY_PARAM` long
// - `commitment` must be `(TAU - 1) * VOLE_ROWS / 8` long
// - `check` must be `2 * SECURITY_PARAM / 8` long
// - `opening` must be `VECTOR_OPEN_SIZE` long
// Returns false if the BAVC opening is not well-formed.
template <typename P>
bool vole_reconstruct(block128 iv, const vole_commit_data<P, true>& data,
                      const uint8_t* delta_bytes,
                      std::span<const uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
                      std::span<const uint8_t, P::bavc_t::OPEN_SIZE> opening,
                      std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check);

// Round 3 VOLECommit algorithm. The first parameters are the same as in `vole_commit`.
// Additionally:
// - `u_mask`: block_secpar of length n_mask
// - `v_mask`: block_secpar of length n_mask
// - `c_mult`: n_mask x n_mult bit matrix
// XXX:
// - `commitment` are the correction values -- they are now shorter
template <typename P>
    requires(P::use_crt_vole_masks)
void crt_vole_commit(block_secpar<P::secpar_v> seed, block128 iv,
                     const vole_commit_data<P, false>& data,
                     std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
                     std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check,
                     std::span<uint8_t, P::CONSTS::CRT_CMULT_SIZE_BYTES> c_mult);

template <typename P>
    requires(P::use_crt_vole_masks)
bool crt_vole_reconstruct(
    block128 iv, const vole_commit_data<P, true>& data, block_secpar<P::secpar_v> delta,
    std::span<const uint8_t, P::CONSTS::VOLE_COMMIT_CORRECTIONS_SIZE> commitment,
    std::span<const uint8_t, P::bavc_t::OPEN_SIZE> opening,
    std::span<uint8_t, P::CONSTS::VOLE_COMMIT_CHECK_SIZE> check,
    std::span<const uint8_t, P::CONSTS::CRT_CMULT_SIZE_BYTES> c_mult);

template <typename P>
    requires(P::use_crt_vole_masks)
block_secpar<P::secpar_v> crt_lift_delta(block_secpar<P::secpar_v> delta);

} // namespace faest

#endif
