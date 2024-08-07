// 20240806 djb: some automated conversion to cryptoint
#include "poly_r2_inv.h"
#include "poly.h"
#include "crypto_int64.h"

// TODO this costs 1764 cycles.. (implementing as S3_to_bytes results in 2108)
// This can be implemented nicely in assembly using pdep / pext functions
void poly_R2_tobytes(unsigned char *out, const poly *a)
{
  int i, j, k;
  for (i = 0; i < 12; i++) {
    for (k = 0; k < 8; k++) {
      out[i*8+k] = 0;
      for (j = 0; j < 8; j++) {
        if ((i*8+k)*8 + j < NTRU_N) {
          out[i*8+k] |= (crypto_int64_bottombit_01(a->coeffs[(i*8+k)*8 + j])) << j;
        }
      }
    }
  }
}

void poly_R2_frombytes(poly *a, const unsigned char *in)
{
  int i, j, k;
  for (i = 0; i < 12; i++) {
    for (k = 0; k < 8; k++) {
      for (j = 0; j < 8; j++) {
        if ((i*8+k)*8 + j < NTRU_N) {
          a->coeffs[(i*8+k)*8 + j] = crypto_int64_bitmod_01(in[i*8+k],j);
        }
      }
    }
  }
}

void poly_R2_inv(poly *r, const poly *a) {
    union {
      unsigned char s[96];
      __m256i s_x32[3];
    } squares[13];
    #define s(x) squares[(x)].s

    // This relies on the following addition chain:
    // 1, 2, 3, 6, 12, 15, 27, 42, 84, 168, 336, 672, 699

    poly_R2_tobytes(s(0), a); // TODO alignment

    square_1_701(s(1), s(0));
    poly_R2_mul(s(1), s(1), s(0));
    square_1_701(s(2), s(1));
    poly_R2_mul(s(2), s(2), s(0));
    square_3_701(s(3), s(2));
    poly_R2_mul(s(3), s(3), s(2));
    square_6_701(s(4), s(3));
    poly_R2_mul(s(4), s(4), s(3));
    square_3_701(s(5), s(4));
    poly_R2_mul(s(5), s(5), s(2));
    square_12_701(s(6), s(5));
    poly_R2_mul(s(6), s(6), s(4));
    square_15_701(s(7), s(6));
    poly_R2_mul(s(7), s(7), s(5));
    square_42_701(s(8), s(7));
    poly_R2_mul(s(8), s(8), s(7));
    square_84_701(s(9), s(8));
    poly_R2_mul(s(9), s(9), s(8));
    square_168_701(s(10), s(9));
    poly_R2_mul(s(10), s(10), s(9));
    square_336_701(s(11), s(10));
    poly_R2_mul(s(11), s(11), s(10));
    square_27_701(s(12), s(11));
    poly_R2_mul(s(12), s(12), s(6));
    square_1_701(s(0), s(12));

    poly_R2_frombytes(r, s(0));
    #undef s
}
