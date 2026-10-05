#include "faest.inc"

namespace faest
{

#define INST_FAEST(P)                                                                              \
    template bool faest_unpack_secret_key(secret_key<P>*, const uint8_t*);                         \
    template void faest_pack_public_key(uint8_t*, const public_key<P>*);                           \
    template void faest_unpack_public_key(public_key<P>*, const uint8_t*);                         \
    template bool faest_seckey<P>(const uint8_t*);                                                 \
    template bool faest_pubkey<P>(uint8_t*, const uint8_t*);                                       \
    template bool faest_sign<P>(uint8_t*, const uint8_t*, size_t, const uint8_t*, const uint8_t*,  \
                                size_t);                                                           \
    template bool faest_verify<P>(const uint8_t*, const uint8_t*, size_t, const uint8_t*);

INST_FAEST(v2::faest_128_f);
INST_FAEST(v2::faest_128_s);
INST_FAEST(v2::faest_192_f);
INST_FAEST(v2::faest_192_s);
INST_FAEST(v2::faest_256_f);
INST_FAEST(v2::faest_256_s);
INST_FAEST(v2::faest_em_128_f);
INST_FAEST(v2::faest_em_128_s);
INST_FAEST(v2::faest_em_192_f);
INST_FAEST(v2::faest_em_192_s);
INST_FAEST(v2::faest_em_256_f);
INST_FAEST(v2::faest_em_256_s);

INST_FAEST(v3::faest_128_f);
INST_FAEST(v3::faest_128_s);
INST_FAEST(v3::faest_192_f);
INST_FAEST(v3::faest_192_s);
INST_FAEST(v3::faest_256_f);
INST_FAEST(v3::faest_256_s);
INST_FAEST(v3::faest_em_128_f);
INST_FAEST(v3::faest_em_128_s);
INST_FAEST(v3::faest_em_192_f);
INST_FAEST(v3::faest_em_192_s);
INST_FAEST(v3::faest_em_256_f);
INST_FAEST(v3::faest_em_256_s);

} // namespace faest
