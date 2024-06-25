/* auto-generated: cd inttypes; ./autogen */

#ifndef crypto_int8_h
#define crypto_int8_h

#include <inttypes.h>
#define crypto_int8 int8_t
#define crypto_int8_unsigned uint8_t

#define crypto_int8_optblocker supercop_int8_optblocker
extern volatile crypto_int8 crypto_int8_optblocker;

__attribute__((unused))
static inline
crypto_int8 crypto_int8_load(const unsigned char *crypto_int8_s) {
  crypto_int8 crypto_int8_z = 0;
  crypto_int8_z |= ((crypto_int8) (*crypto_int8_s++)) << 0;
  return crypto_int8_z;
}

__attribute__((unused))
static inline
void crypto_int8_store(unsigned char *crypto_int8_s,crypto_int8 crypto_int8_x) {
  *crypto_int8_s++ = crypto_int8_x >> 0;
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_negative_mask(crypto_int8 crypto_int8_x) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("sarb $7,%0" : "+r"(crypto_int8_x) : : "cc");
  return crypto_int8_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_y;
  __asm__ ("sbfx %w0,%w1,7,1" : "=r"(crypto_int8_y) : "r"(crypto_int8_x) : );
  return crypto_int8_y;
#else
  crypto_int8_x >>= 8-6;
  crypto_int8_x ^= crypto_int8_optblocker;
  crypto_int8_x >>= 5;
  return crypto_int8_x;
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_bottombit_mask(crypto_int8 crypto_int8_x) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("andb $1,%0" : "+r"(crypto_int8_x) : : "cc");
  return -crypto_int8_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_y;
  __asm__ ("sbfx %w0,%w1,0,1" : "=r"(crypto_int8_y) : "r"(crypto_int8_x) : );
  return crypto_int8_y;
#else
  crypto_int8_x &= 1 ^ crypto_int8_optblocker;
  return -crypto_int8_x;
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_bitinrangepublicpos_mask(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_s) {
#if defined(__GNUC__) && defined(__x86_64__)
  __asm__ ("sarb %%cl,%0" : "+r"(crypto_int8_x) : "c"(crypto_int8_s) : "cc");
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("sxtb %w0,%w0\n asr %w0,%w0,%w1" : "+&r"(crypto_int8_x) : "r"(crypto_int8_s) : );
#else
  crypto_int8_x >>= crypto_int8_s ^ crypto_int8_optblocker;
#endif
  return crypto_int8_bottombit_mask(crypto_int8_x);
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_shlmod(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_s) {
#if defined(__GNUC__) && defined(__x86_64__)
  crypto_int8_s &= 7;
  __asm__ ("shlb %%cl,%0" : "+r"(crypto_int8_x) : "c"(crypto_int8_s) : "cc");
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("and %w0,%w0,7\n and %w1,%w1,255\n lsl %w1,%w1,%w0" : "+&r"(crypto_int8_s), "+r"(crypto_int8_x) : : );
#else
  int crypto_int8_k, crypto_int8_l;
  for (crypto_int8_l = 0,crypto_int8_k = 1;crypto_int8_k < 8;++crypto_int8_l,crypto_int8_k *= 2)
    crypto_int8_x ^= (crypto_int8_x ^ (crypto_int8_x << crypto_int8_k)) & crypto_int8_bitinrangepublicpos_mask(crypto_int8_s,crypto_int8_l);
#endif
  return crypto_int8_x;
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_shrmod(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_s) {
#if defined(__GNUC__) && defined(__x86_64__)
  crypto_int8_s &= 7;
  __asm__ ("sarb %%cl,%0" : "+r"(crypto_int8_x) : "c"(crypto_int8_s) : "cc");
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("and %w0,%w0,7\n sxtb %w1,%w1\n asr %w1,%w1,%w0" : "+&r"(crypto_int8_s), "+r"(crypto_int8_x) : : );
#else
  int crypto_int8_k, crypto_int8_l;
  for (crypto_int8_l = 0,crypto_int8_k = 1;crypto_int8_k < 8;++crypto_int8_l,crypto_int8_k *= 2)
    crypto_int8_x ^= (crypto_int8_x ^ (crypto_int8_x >> crypto_int8_k)) & crypto_int8_bitinrangepublicpos_mask(crypto_int8_s,crypto_int8_l);
#endif
  return crypto_int8_x;
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_bitmod_mask(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_s) {
  crypto_int8_x = crypto_int8_shrmod(crypto_int8_x,crypto_int8_s);
  return crypto_int8_bottombit_mask(crypto_int8_x);
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_nonzero_mask(crypto_int8 crypto_int8_x) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_z;
  __asm__ ("tst %w1,255\n csetm %w0,ne" : "=r"(crypto_int8_z) : "r"(crypto_int8_x) : "cc");
  return crypto_int8_z;
#else
  crypto_int8_x |= -crypto_int8_x;
  return crypto_int8_negative_mask(crypto_int8_x);
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_positive_mask(crypto_int8 crypto_int8_x)
{
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_z;
  __asm__ ("sxtb %w0,%w1\n cmp %w0,0\n csetm %w0,gt" : "=r"(crypto_int8_z) : "r"(crypto_int8_x) : "cc");
  return crypto_int8_z;
#else
  crypto_int8 crypto_int8_z = -crypto_int8_x;
  crypto_int8_z ^= crypto_int8_x & crypto_int8_z;
  return crypto_int8_negative_mask(crypto_int8_z);
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_zero_mask(crypto_int8 crypto_int8_x) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_z;
  __asm__ ("tst %w1,255\n csetm %w0,eq" : "=r"(crypto_int8_z) : "r"(crypto_int8_x) : "cc");
  return crypto_int8_z;
#else
  return ~crypto_int8_nonzero_mask(crypto_int8_x);
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_unequal_mask(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_z;
  __asm__ ("and %w0,%w1,255\n cmp %w0,%w2,uxtb\n csetm %w0,ne" : "=&r"(crypto_int8_z) : "r"(crypto_int8_x), "r"(crypto_int8_y) : "cc");
  return crypto_int8_z;
#else
  return crypto_int8_nonzero_mask(crypto_int8_x ^ crypto_int8_y);
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_equal_mask(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_z;
  __asm__ ("and %w0,%w1,255\n cmp %w0,%w2,uxtb\n csetm %w0,eq" : "=&r"(crypto_int8_z) : "r"(crypto_int8_x), "r"(crypto_int8_y) : "cc");
  return crypto_int8_z;
#else
  return ~crypto_int8_unequal_mask(crypto_int8_x,crypto_int8_y);
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_min(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_y) {
#if defined(__GNUC__) && defined(__x86_64__)
  int32_t crypto_int8_x32 = crypto_int8_x,crypto_int8_y32 = crypto_int8_y;
  __asm__ ("cmpb %b1,%b0\n cmovgl %1,%0" : "+q"(crypto_int8_x32) : "q"(crypto_int8_y32) : "cc");
  crypto_int8_x = crypto_int8_x32;
  return crypto_int8_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("sxtb %w0,%w0\n cmp %w0,%w1,sxtb\n csel %w0,%w0,%w1,lt" : "+&r"(crypto_int8_x) : "r"(crypto_int8_y) : "cc");
  return crypto_int8_x;
#else
  crypto_int8 crypto_int8_r = crypto_int8_y ^ crypto_int8_x;
  crypto_int8 crypto_int8_z = crypto_int8_y - crypto_int8_x;
  crypto_int8_z ^= crypto_int8_r & (crypto_int8_z ^ crypto_int8_y);
  crypto_int8_z = crypto_int8_negative_mask(crypto_int8_z);
  crypto_int8_z &= crypto_int8_r;
  return crypto_int8_x ^ crypto_int8_z;
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_max(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_y) {
#if defined(__GNUC__) && defined(__x86_64__)
  int32_t crypto_int8_x32 = crypto_int8_x,crypto_int8_y32 = crypto_int8_y;
  __asm__ ("cmpb %b1,%b0\n cmovll %1,%0" : "+q"(crypto_int8_x32) : "q"(crypto_int8_y32) : "cc");
  crypto_int8_x = crypto_int8_x32;
  return crypto_int8_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  __asm__ ("sxtb %w0,%w0\n cmp %w0,%w1,sxtb\n csel %w0,%w1,%w0,lt" : "+&r"(crypto_int8_x) : "r"(crypto_int8_y) : "cc");
  return crypto_int8_x;
#else
  crypto_int8 crypto_int8_r = crypto_int8_y ^ crypto_int8_x;
  crypto_int8 crypto_int8_z = crypto_int8_y - crypto_int8_x;
  crypto_int8_z ^= crypto_int8_r & (crypto_int8_z ^ crypto_int8_y);
  crypto_int8_z = crypto_int8_negative_mask(crypto_int8_z);
  crypto_int8_z &= crypto_int8_r;
  return crypto_int8_y ^ crypto_int8_z;
#endif
}

__attribute__((unused))
static inline
void crypto_int8_minmax(crypto_int8 *crypto_int8_p,crypto_int8 *crypto_int8_q) {
  crypto_int8 crypto_int8_x = *crypto_int8_p;
  crypto_int8 crypto_int8_y = *crypto_int8_q;
#if defined(__GNUC__) && defined(__x86_64__)
  int32_t crypto_int8_x32 = crypto_int8_x,crypto_int8_y32 = crypto_int8_y,crypto_int8_z32;
  __asm__ ("cmpb %b2,%b1\n movl %1,%0\n cmovgl %2,%1\n cmovgl %0,%2" : "=&r"(crypto_int8_z32), "+&q"(crypto_int8_x32), "+q"(crypto_int8_y32) : : "cc");
  crypto_int8_x = crypto_int8_x32; crypto_int8_y = crypto_int8_y32;
  *crypto_int8_p = crypto_int8_x;
  *crypto_int8_q = crypto_int8_y;
#elif defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_r, crypto_int8_s;
  __asm__ ("sxtb %w0,%w0\n cmp %w0,%w3,sxtb\n csel %w1,%w0,%w3,lt\n csel %w2,%w3,%w0,lt" : "+&r"(crypto_int8_x), "=&r"(crypto_int8_r), "=r"(crypto_int8_s) : "r"(crypto_int8_y) : "cc");
  *crypto_int8_p = crypto_int8_r;
  *crypto_int8_q = crypto_int8_s;
#else
  crypto_int8 crypto_int8_r = crypto_int8_y ^ crypto_int8_x;
  crypto_int8 crypto_int8_z = crypto_int8_y - crypto_int8_x;
  crypto_int8_z ^= crypto_int8_r & (crypto_int8_z ^ crypto_int8_y);
  crypto_int8_z = crypto_int8_negative_mask(crypto_int8_z);
  crypto_int8_z &= crypto_int8_r;
  crypto_int8_x ^= crypto_int8_z;
  crypto_int8_y ^= crypto_int8_z;
  *crypto_int8_p = crypto_int8_x;
  *crypto_int8_q = crypto_int8_y;
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_smaller_mask(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_z;
  __asm__ ("sxtb %w0,%w1\n cmp %w0,%w2,sxtb\n csetm %w0,lt" : "=&r"(crypto_int8_z) : "r"(crypto_int8_x), "r"(crypto_int8_y) : "cc");
  return crypto_int8_z;
#else
  crypto_int8 crypto_int8_r = crypto_int8_x ^ crypto_int8_y;
  crypto_int8 crypto_int8_z = crypto_int8_x - crypto_int8_y;
  crypto_int8_z ^= crypto_int8_r & (crypto_int8_z ^ crypto_int8_x);
  return crypto_int8_negative_mask(crypto_int8_z);
#endif
}

__attribute__((unused))
static inline
crypto_int8 crypto_int8_leq_mask(crypto_int8 crypto_int8_x,crypto_int8 crypto_int8_y) {
#if defined(__GNUC__) && defined(__aarch64__)
  crypto_int8 crypto_int8_z;
  __asm__ ("sxtb %w0,%w1\n cmp %w0,%w2,sxtb\n csetm %w0,le" : "=&r"(crypto_int8_z) : "r"(crypto_int8_x), "r"(crypto_int8_y) : "cc");
  return crypto_int8_z;
#else
  return ~crypto_int8_smaller_mask(crypto_int8_y,crypto_int8_x);
#endif
}

__attribute__((unused))
static inline
int crypto_int8_ones_num(crypto_int8 crypto_int8_x) {
  crypto_int8_unsigned crypto_int8_y = crypto_int8_x;
  const crypto_int8 C0 = 0x55;
  const crypto_int8 C1 = 0x33;
  const crypto_int8 C2 = 0x0f;
  crypto_int8_y -= ((crypto_int8_y >> 1) & C0);
  crypto_int8_y = (crypto_int8_y & C1) + ((crypto_int8_y >> 2) & C1);
  crypto_int8_y = (crypto_int8_y + (crypto_int8_y >> 4)) & C2;
  return crypto_int8_y;
}

__attribute__((unused))
static inline
int crypto_int8_bottomzeros_num(crypto_int8 crypto_int8_x) {
#if defined(__GNUC__) && defined(__x86_64__)
  int32_t fallback = 8;
  int32_t crypto_int8_x32 = crypto_int8_x;
  __asm__ ("bsfl %0,%0\n cmovel %1,%0" : "+&r"(crypto_int8_x32) : "r"(fallback) : "cc");
  crypto_int8_x = crypto_int8_x32;
  return crypto_int8_x;
#elif defined(__GNUC__) && defined(__aarch64__)
  int64_t crypto_int8_y;
  __asm__ ("orr %w0,%w1,-256\n rbit %w0,%w0\n clz %w0,%w0" : "=r"(crypto_int8_y) : "r"(crypto_int8_x) : );
  return crypto_int8_y;
#else
  crypto_int8 crypto_int8_y = crypto_int8_x ^ (crypto_int8_x-1);
  crypto_int8_y = ((crypto_int8) crypto_int8_y) >> 1;
  crypto_int8_y &= ~(crypto_int8_x & (((crypto_int8) 1) << (8-1)));
  return crypto_int8_ones_num(crypto_int8_y);
#endif
}

#endif
