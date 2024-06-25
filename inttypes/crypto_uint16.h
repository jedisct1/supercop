/* auto-generated: cd inttypes; ./autogen */

#ifndef crypto_uint16_h
#define crypto_uint16_h

#include <inttypes.h>
#define crypto_uint16 uint16_t
#define crypto_uint16_signed int16_t

#define crypto_uint16_signed_optblocker supercop_uint16_signed_optblocker
extern volatile crypto_uint16_signed crypto_uint16_signed_optblocker;

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_load(const unsigned char *crypto_uint16_s) {
  crypto_uint16 crypto_uint16_z = 0;
  crypto_uint16_z |= ((crypto_uint16) (*crypto_uint16_s++)) << 0;
  crypto_uint16_z |= ((crypto_uint16) (*crypto_uint16_s++)) << 8;
  return crypto_uint16_z;
}

__attribute__((unused))
static inline
void crypto_uint16_store(unsigned char *crypto_uint16_s,crypto_uint16 crypto_uint16_x) {
  *crypto_uint16_s++ = crypto_uint16_x >> 0;
  *crypto_uint16_s++ = crypto_uint16_x >> 8;
}

__attribute__((unused))
static inline
crypto_uint16_signed crypto_uint16_signed_negative_mask(crypto_uint16_signed crypto_uint16_x) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("sarw $15,%0" : "+r"(crypto_uint16_x) : : "cc");
  return crypto_uint16_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16_signed crypto_uint16_y;
  __asm__ ("sbfx %w0,%w1,15,1" : "=r"(crypto_uint16_y) : "r"(crypto_uint16_x) : );
  return crypto_uint16_y;
#else
  crypto_uint16_x >>= 16-6;
  crypto_uint16_x ^= crypto_uint16_signed_optblocker;
  crypto_uint16_x >>= 5;
  return crypto_uint16_x;
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_bottombit_mask(crypto_uint16 crypto_uint16_x) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("andw $1,%0" : "+r"(crypto_uint16_x) : : "cc");
  return -crypto_uint16_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_y;
  __asm__ ("sbfx %w0,%w1,0,1" : "=r"(crypto_uint16_y) : "r"(crypto_uint16_x) : );
  return crypto_uint16_y;
#else
  crypto_uint16_x &= 1 ^ crypto_uint16_signed_optblocker;
  return -crypto_uint16_x;
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_bitinrangepublicpos_mask(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_s) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("shrw %%cl,%0" : "+r"(crypto_uint16_x) : "c"(crypto_uint16_s) : "cc");
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("and %w0,%w0,65535\n lsr %w0,%w0,%w1" : "+&r"(crypto_uint16_x) : "r"(crypto_uint16_s) : );
#else
  crypto_uint16_x >>= crypto_uint16_s ^ crypto_uint16_signed_optblocker;
#endif
  return crypto_uint16_bottombit_mask(crypto_uint16_x);
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_shlmod(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_s) {
#if defined(__GNUC__) && defined(__x86_64__)
  crypto_uint16_s &= 15;
  __asm__ ("shlw %%cl,%0" : "+r"(crypto_uint16_x) : "c"(crypto_uint16_s) : "cc");
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("and %w0,%w0,15\n and %w1,%w1,65535\n lsl %w1,%w1,%w0" : "+&r"(crypto_uint16_s), "+r"(crypto_uint16_x) : : );
#else
  int crypto_uint16_k, crypto_uint16_l;
  for (crypto_uint16_l = 0,crypto_uint16_k = 1;crypto_uint16_k < 16;++crypto_uint16_l,crypto_uint16_k *= 2)
    crypto_uint16_x ^= (crypto_uint16_x ^ (crypto_uint16_x << crypto_uint16_k)) & crypto_uint16_bitinrangepublicpos_mask(crypto_uint16_s,crypto_uint16_l);
#endif
  return crypto_uint16_x;
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_shrmod(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_s) {
#if defined(__GNUC__) && defined(__x86_64__)
  crypto_uint16_s &= 15;
  __asm__ ("shrw %%cl,%0" : "+r"(crypto_uint16_x) : "c"(crypto_uint16_s) : "cc");
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("and %w0,%w0,15\n and %w1,%w1,65535\n lsr %w1,%w1,%w0" : "+&r"(crypto_uint16_s), "+r"(crypto_uint16_x) : : );
#else
  int crypto_uint16_k, crypto_uint16_l;
  for (crypto_uint16_l = 0,crypto_uint16_k = 1;crypto_uint16_k < 16;++crypto_uint16_l,crypto_uint16_k *= 2)
    crypto_uint16_x ^= (crypto_uint16_x ^ (crypto_uint16_x >> crypto_uint16_k)) & crypto_uint16_bitinrangepublicpos_mask(crypto_uint16_s,crypto_uint16_l);
#endif
  return crypto_uint16_x;
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_bitmod_mask(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_s) {
  crypto_uint16_x = crypto_uint16_shrmod(crypto_uint16_x,crypto_uint16_s);
  return crypto_uint16_bottombit_mask(crypto_uint16_x);
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_nonzero_mask(crypto_uint16 crypto_uint16_x) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_z;
  __asm__ ("tst %w1,65535\n csetm %w0,ne" : "=r"(crypto_uint16_z) : "r"(crypto_uint16_x) : "cc");
  return crypto_uint16_z;
#else
  crypto_uint16_x |= -crypto_uint16_x;
  return crypto_uint16_signed_negative_mask(crypto_uint16_x);
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_zero_mask(crypto_uint16 crypto_uint16_x) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_z;
  __asm__ ("tst %w1,65535\n csetm %w0,eq" : "=r"(crypto_uint16_z) : "r"(crypto_uint16_x) : "cc");
  return crypto_uint16_z;
#else
  return ~crypto_uint16_nonzero_mask(crypto_uint16_x);
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_unequal_mask(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_z;
  __asm__ ("and %w0,%w1,65535\n cmp %w0,%w2,uxth\n csetm %w0,ne" : "=&r"(crypto_uint16_z) : "r"(crypto_uint16_x), "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_z;
#else
  return crypto_uint16_nonzero_mask(crypto_uint16_x ^ crypto_uint16_y);
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_equal_mask(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_z;
  __asm__ ("and %w0,%w1,65535\n cmp %w0,%w2,uxth\n csetm %w0,eq" : "=&r"(crypto_uint16_z) : "r"(crypto_uint16_x), "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_z;
#else
  return ~crypto_uint16_unequal_mask(crypto_uint16_x,crypto_uint16_y);
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_min(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_y) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("cmpw %1,%0\n cmovaw %1,%0" : "+r"(crypto_uint16_x) : "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("and %w0,%w0,65535\n cmp %w0,%w1,uxth\n csel %w0,%w0,%w1,lo" : "+&r"(crypto_uint16_x) : "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_x;
#else
  crypto_uint16 crypto_uint16_r = crypto_uint16_y ^ crypto_uint16_x;
  crypto_uint16 crypto_uint16_z = crypto_uint16_y - crypto_uint16_x;
  crypto_uint16_z ^= crypto_uint16_r & (crypto_uint16_z ^ crypto_uint16_y ^ (((crypto_uint16) 1) << (16-1)));
  crypto_uint16_z = crypto_uint16_signed_negative_mask(crypto_uint16_z);
  crypto_uint16_z &= crypto_uint16_r;
  return crypto_uint16_x ^ crypto_uint16_z;
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_max(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_y) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("cmpw %1,%0\n cmovbw %1,%0" : "+r"(crypto_uint16_x) : "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("and %w0,%w0,65535\n cmp %w0,%w1,uxth\n csel %w0,%w1,%w0,lo" : "+&r"(crypto_uint16_x) : "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_x;
#else
  crypto_uint16 crypto_uint16_r = crypto_uint16_y ^ crypto_uint16_x;
  crypto_uint16 crypto_uint16_z = crypto_uint16_y - crypto_uint16_x;
  crypto_uint16_z ^= crypto_uint16_r & (crypto_uint16_z ^ crypto_uint16_y ^ (((crypto_uint16) 1) << (16-1)));
  crypto_uint16_z = crypto_uint16_signed_negative_mask(crypto_uint16_z);
  crypto_uint16_z &= crypto_uint16_r;
  return crypto_uint16_y ^ crypto_uint16_z;
#endif
}

__attribute__((unused))
static inline
void crypto_uint16_minmax(crypto_uint16 *crypto_uint16_p,crypto_uint16 *crypto_uint16_q) {
  crypto_uint16 crypto_uint16_x = *crypto_uint16_p;
  crypto_uint16 crypto_uint16_y = *crypto_uint16_q;
#if defined(__GNUC__) && defined(__x86_64__)
  crypto_uint16 crypto_uint16_z;
  __asm__ ("cmpw %2,%1\n movw %1,%0\n cmovaw %2,%1\n cmovaw %0,%2" : "=&r"(crypto_uint16_z), "+&r"(crypto_uint16_x), "+r"(crypto_uint16_y) : : "cc");
  *crypto_uint16_p = crypto_uint16_x;
  *crypto_uint16_q = crypto_uint16_y;
#elif defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_r, crypto_uint16_s;
  __asm__ ("and %w0,%w0,65535\n cmp %w0,%w3,uxth\n csel %w1,%w0,%w3,lo\n csel %w2,%w3,%w0,lo" : "+&r"(crypto_uint16_x), "=&r"(crypto_uint16_r), "=r"(crypto_uint16_s) : "r"(crypto_uint16_y) : "cc");
  *crypto_uint16_p = crypto_uint16_r;
  *crypto_uint16_q = crypto_uint16_s;
#else
  crypto_uint16 crypto_uint16_r = crypto_uint16_y ^ crypto_uint16_x;
  crypto_uint16 crypto_uint16_z = crypto_uint16_y - crypto_uint16_x;
  crypto_uint16_z ^= crypto_uint16_r & (crypto_uint16_z ^ crypto_uint16_y ^ (((crypto_uint16) 1) << (16-1)));
  crypto_uint16_z = crypto_uint16_signed_negative_mask(crypto_uint16_z);
  crypto_uint16_z &= crypto_uint16_r;
  crypto_uint16_x ^= crypto_uint16_z;
  crypto_uint16_y ^= crypto_uint16_z;
  *crypto_uint16_p = crypto_uint16_x;
  *crypto_uint16_q = crypto_uint16_y;
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_smaller_mask(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_z;
  __asm__ ("and %w0,%w1,65535\n cmp %w0,%w2,uxth\n csetm %w0,lo" : "=&r"(crypto_uint16_z) : "r"(crypto_uint16_x), "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_z;
#else
  crypto_uint16 crypto_uint16_r = crypto_uint16_x ^ crypto_uint16_y;
  crypto_uint16 crypto_uint16_z = crypto_uint16_x - crypto_uint16_y;
  crypto_uint16_z ^= crypto_uint16_r & (crypto_uint16_z ^ crypto_uint16_x ^ (((crypto_uint16) 1) << (16-1)));
  return crypto_uint16_signed_negative_mask(crypto_uint16_z);
#endif
}

__attribute__((unused))
static inline
crypto_uint16 crypto_uint16_leq_mask(crypto_uint16 crypto_uint16_x,crypto_uint16 crypto_uint16_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_uint16 crypto_uint16_z;
  __asm__ ("and %w0,%w1,65535\n cmp %w0,%w2,uxth\n csetm %w0,ls" : "=&r"(crypto_uint16_z) : "r"(crypto_uint16_x), "r"(crypto_uint16_y) : "cc");
  return crypto_uint16_z;
#else
  return ~crypto_uint16_smaller_mask(crypto_uint16_y,crypto_uint16_x);
#endif
}

__attribute__((unused))
static inline
int crypto_uint16_ones_num(crypto_uint16 crypto_uint16_x) {
  crypto_uint16 crypto_uint16_y = crypto_uint16_x;
  const crypto_uint16 C0 = 0x5555;
  const crypto_uint16 C1 = 0x3333;
  const crypto_uint16 C2 = 0x0f0f;
  crypto_uint16_y -= ((crypto_uint16_y >> 1) & C0);
  crypto_uint16_y = (crypto_uint16_y & C1) + ((crypto_uint16_y >> 2) & C1);
  crypto_uint16_y = (crypto_uint16_y + (crypto_uint16_y >> 4)) & C2;
  crypto_uint16_y = (crypto_uint16_y + (crypto_uint16_y >> 8)) & 0xff;
  return crypto_uint16_y;
}

__attribute__((unused))
static inline
int crypto_uint16_bottomzeros_num(crypto_uint16 crypto_uint16_x) {
#if defined(__GNUC__) && defined(__x86_64__)
  crypto_uint16 fallback = 16;
  __asm__ ("bsfw %0,%0\n cmovew %1,%0" : "+&r"(crypto_uint16_x) : "r"(fallback) : "cc");
  return crypto_uint16_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  int64_t crypto_uint16_y;
  __asm__ ("orr %w0,%w1,-65536\n rbit %w0,%w0\n clz %w0,%w0" : "=r"(crypto_uint16_y) : "r"(crypto_uint16_x) : );
  return crypto_uint16_y;
#else
  crypto_uint16 crypto_uint16_y = crypto_uint16_x ^ (crypto_uint16_x-1);
  crypto_uint16_y = ((crypto_uint16_signed) crypto_uint16_y) >> 1;
  crypto_uint16_y &= ~(crypto_uint16_x & (((crypto_uint16) 1) << (16-1)));
  return crypto_uint16_ones_num(crypto_uint16_y);
#endif
}

#endif
