#include <vector_com.inc>

namespace faest
{

void stat_binding_leaf_hash_iv_impl(secpar secpar_v, const block128& prg_iv, unsigned char* hash_iv,
                                    uint32_t max_tweaks)
{
    hash_state hasher;
    hasher.init(secpar_v);
    hasher.update(&prg_iv, sizeof(prg_iv));
    hasher.update_byte(0);
    hasher.finalize(hash_iv, (size_t) max_tweaks * 3 * secpar_to_bytes(secpar_v));
}

} // namespace faest
