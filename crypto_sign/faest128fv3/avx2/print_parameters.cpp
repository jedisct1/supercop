#include "constants.hpp"
#include "parameters.hpp"

#include <print>

using namespace faest;

template <typename C>
void print_consts() {
    std::println("    - VECTOR_COMMITMENT_CONSTANTS:");
    std::println("        - tau = {}", C::VEC_COM::tau_v);
    std::println("        - delta_bits = {}", C::VEC_COM::delta_bits_v);
    std::println("        - MIN_K = {} (k-1)", C::VEC_COM::MIN_K);
    std::println("        - MAX_K = {} (k)", C::VEC_COM::MAX_K);
    std::println("        - MAX_USED_K = {} (k_1 if \\tau_1 > 0 else k_0k)", C::VEC_COM::MAX_USED_K);
    std::println("        - NUM_MIN_K = {} (\\tau_0)", C::VEC_COM::NUM_MIN_K);
    std::println("        - NUM_MAX_K = {} (\\tau_1)", C::VEC_COM::NUM_MAX_K);
    std::println("    - VOLE CONSTANTS:");
    std::println("        - CRT_NUM_MASK = {}", C::CRT_NUM_MASK);
    std::println("        - CRT_NUM_MULT = {}", C::CRT_NUM_MULT);
    std::println("        - VOLE_ROWS = {} (divisible by 8: {})", C::VOLE_ROWS, C::VOLE_ROWS % 8 == 0);
    std::println("        - VOLE_BYTES = {}", C::VOLE_BYTES);
    std::println("        - VOLE_COL_BLOCKS = {}", C::VOLE_COL_BLOCKS);
    std::println("        - VOLE_COL_STRIDE = {}", C::VOLE_COL_STRIDE);
    std::println("        - VOLE_CORRECTION_ROWS = {} (divisible by 8: {})", C::VOLE_CORRECTION_ROWS, C::VOLE_CORRECTION_ROWS % 8 == 0);
    std::println("        - VOLE_CORRECTION_BYTES = {}", C::VOLE_CORRECTION_BYTES);
    std::println("        - VOLE_CORRECTION_BLOCKS = {}", C::VOLE_CORRECTION_BLOCKS);
    std::println("        - QUICKSILVER_ROWS = {}", C::QUICKSILVER_ROWS);
    std::println("        - QUICKSILVER_ROWS_PADDED = {}", C::QUICKSILVER_ROWS_PADDED);
    std::println("        - QUICKSILVER_ROWS_PADDED_BYTES = {}", C::QUICKSILVER_ROWS_PADDED / 8);
}

template <typename C>
void print_owf_consts() {
    std::println("    - QS_DEGREE = {}", C::QS_DEGREE);
    std::println("    - WITNESS_BITS = {}", C::WITNESS_BITS);
    std::println("    - NUM_CONSTRAINTS = {}", C::OWF_NUM_CONSTRAINTS);
}

template <typename P>
void print_params(std::string_view name) {
    std::println("===== {} =====", name);
    std::println("- secpar = {}", P::secpar_bits);
    std::println("- tau = {}", P::tau_v);
    std::println("- w_grind = zero_bits_in_delta = {}", P::zero_bits_in_delta_v);
    std::println("- delta_size = secpar - w_grind = {}", P::delta_bits_v);
    std::println("- CONSTANTS:");
    print_consts<typename P::CONSTS>();
    std::println("- OWF_CONSTANTS:");
    print_owf_consts<typename P::OWF_CONSTS>();
}

int main()
{
    std::println();
    print_params<v3::faest_128_f>("FAEST-128F");
    std::println();
    print_params<v3::faest_128_s>("FAEST-128S");
    std::println();
    print_params<v3::faest_192_f>("FAEST-192F");
    std::println();
    print_params<v3::faest_192_s>("FAEST-192S");
    std::println();
    print_params<v3::faest_256_f>("FAEST-256F");
    std::println();
    print_params<v3::faest_256_s>("FAEST-256S");
    std::println();
    print_params<v3::faest_em_128_f>("FAEST-EM-128F");
    std::println();
    print_params<v3::faest_em_128_s>("FAEST-EM-128S");
    std::println();
    print_params<v3::faest_em_192_f>("FAEST-EM-192F");
    std::println();
    print_params<v3::faest_em_192_s>("FAEST-EM-192S");
    std::println();
    print_params<v3::faest_em_256_f>("FAEST-EM-256F");
    std::println();
    print_params<v3::faest_em_256_s>("FAEST-EM-256S");

    // Not yet implemented:
    //
    static_assert(v1::faest_128_f::valid);
    static_assert(v1::faest_128_s::valid);
    static_assert(v1::faest_192_f::valid);
    static_assert(v1::faest_192_s::valid);
    static_assert(v1::faest_256_f::valid);
    static_assert(v1::faest_256_s::valid);
    static_assert(v1::faest_em_128_f::valid);
    static_assert(v1::faest_em_128_s::valid);
    static_assert(v1::faest_em_192_f::valid);
    static_assert(v1::faest_em_192_s::valid);
    static_assert(v1::faest_em_256_f::valid);
    static_assert(v1::faest_em_256_s::valid);

    static_assert(v2::faest_128_f::valid);
    static_assert(v2::faest_128_s::valid);
    static_assert(v2::faest_192_f::valid);
    static_assert(v2::faest_192_s::valid);
    static_assert(v2::faest_256_f::valid);
    static_assert(v2::faest_256_s::valid);
    static_assert(v2::faest_em_128_f::valid);
    static_assert(v2::faest_em_128_s::valid);
    static_assert(v2::faest_em_192_f::valid);
    static_assert(v2::faest_em_192_s::valid);
    static_assert(v2::faest_em_256_f::valid);
    static_assert(v2::faest_em_256_s::valid);

    static_assert(v3::faest_128_f::valid);
    static_assert(v3::faest_128_s::valid);
    static_assert(v3::faest_192_f::valid);
    static_assert(v3::faest_192_s::valid);
    static_assert(v3::faest_256_f::valid);
    static_assert(v3::faest_256_s::valid);
    static_assert(v3::faest_em_128_f::valid);
    static_assert(v3::faest_em_128_s::valid);
    static_assert(v3::faest_em_192_f::valid);
    static_assert(v3::faest_em_192_s::valid);
    static_assert(v3::faest_em_256_f::valid);
    static_assert(v3::faest_em_256_s::valid);
}
