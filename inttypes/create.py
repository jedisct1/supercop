#!/usr/bin/env python3

vars = 'k','l','p','q','r','s','x','y','z'

# ===== top

csh = '''/* auto-generated: cd inttypes; ./autogen */

#ifndef crypto_intN_h
#define crypto_intN_h

#include <inttypes.h>
#define crypto_intN intN_t
#define crypto_intN_unsigned uintN_t

#define crypto_intN_optblocker namespace_intN_optblocker
extern volatile crypto_intN crypto_intN_optblocker;

'''

cuh = '''/* auto-generated: cd inttypes; ./autogen */

#ifndef crypto_uintN_h
#define crypto_uintN_h

#include <inttypes.h>
#define crypto_uintN uintN_t
#define crypto_uintN_signed intN_t

#define crypto_uintN_signed_optblocker namespace_uintN_signed_optblocker
extern volatile crypto_uintN_signed crypto_uintN_signed_optblocker;

'''

# ===== functions

for which,fun in (

('both',
r'''TYPE TYPE_load(const unsigned char *S) {
  TYPE Z = 0;
  int K;
  for (K = 0;K < N;K += 8)
    Z |= ((TYPE) (*S++)) << K;
  return Z;
}'''
),

('both',
r'''void TYPE_store(unsigned char *S,TYPE X) {
  int K;
  for (K = 0;K < N;K += 8)
    *S++ = X >> K;
}'''
),

# could instead use X >>= (N-1) ^ SIGNED_optblocker
('both',
r'''SIGNED SIGNED_negative_mask(SIGNED X) {
#if amd64
 8:  readasm("amd64; int8 X; X signed>>= 7");
16:  readasm("amd64; int16 X; X signed>>= 15");
32:  readasm("amd64; int32 X; X signed>>= 31");
64:  readasm("amd64; int64 X; X signed>>= 63");
  return X;
#elif arm64
  SIGNED Y;
 8:  readasm("arm64; int8 X Y; Y = -(1 & (X unsigned>> 7))");
16:  readasm("arm64; int16 X Y; Y = -(1 & (X unsigned>> 15))");
32:  readasm("arm64; int32 X Y; Y = X signed>> 31");
64:  readasm("arm64; int64 X Y; Y = X signed>> 63");
  return Y;
#else
  X >>= N-6;
  X ^= SIGNED_optblocker;
  X >>= 5;
  return X;
#endif
}'''
),

('both',
r'''TYPE TYPE_bottombit_mask(TYPE X) {
#if amd64
 8:  readasm("amd64; int8 X; X &= 1");
16:  readasm("amd64; int16 X; X &= 1");
32:  readasm("amd64; int32 X; X &= 1");
64:  readasm("amd64; int64 X; X &= 1");
  return -X;
#elif arm64
  TYPE Y;
 8:  readasm("arm64; int8 X Y; Y = -(1 & (X unsigned>> 0))");
16:  readasm("arm64; int16 X Y; Y = -(1 & (X unsigned>> 0))");
32:  readasm("arm64; int32 X Y; Y = -(1 & (X unsigned>> 0))");
64:  readasm("arm64; int64 X Y; Y = -(1 & (X unsigned>> 0))");
  return Y;
#else
  X &= 1 ^ SIGNED_optblocker;
  return -X;
#endif
}'''
),

# without optblocker here, seems possible that compiler will cause trouble,
# especially if S is compile-time constant N-1
('signed',
r'''TYPE TYPE_bitinrangepublicpos_mask(TYPE X,TYPE S) {
#if amd64
 8:  readasm("amd64; int8 X S; X signed>>= S");
16:  readasm("amd64; int16 X S; X signed>>= S");
32:  readasm("amd64; int32 X S; X signed>>= S");
64:  readasm("amd64; int64 X S; X signed>>= S");
#elif arm64
 8:  readasm("arm64; int8 X S; X = (int8) X; X = X signed>> S");
16:  readasm("arm64; int16 X S; X = (int16) X; X = X signed>> S");
32:  readasm("arm64; int32 X S; X = X signed>> S");
64:  readasm("arm64; int64 X S; X = X signed>> S");
#else
  X >>= S ^ SIGNED_optblocker;
#endif
  return TYPE_bottombit_mask(X);
}'''
),

# without optblocker here, seems possible that compiler will cause trouble,
# especially if S is compile-time constant N-1
('unsigned',
r'''TYPE TYPE_bitinrangepublicpos_mask(TYPE X,TYPE S) {
#if amd64
 8:  readasm("amd64; int8 X S; X unsigned>>= S");
16:  readasm("amd64; int16 X S; X unsigned>>= S");
32:  readasm("amd64; int32 X S; X unsigned>>= S");
64:  readasm("amd64; int64 X S; X unsigned>>= S");
#elif arm64
 8:  readasm("arm64; int8 X S; X = (uint8) X; X = X unsigned>> S");
16:  readasm("arm64; int16 X S; X = (uint16) X; X = X unsigned>> S");
32:  readasm("arm64; int32 X S; X = X unsigned>> S");
64:  readasm("arm64; int64 X S; X = X unsigned>> S");
#else
  X >>= S ^ SIGNED_optblocker;
#endif
  return TYPE_bottombit_mask(X);
}'''
),

# same as (X << (S % N)) but without assuming barrel shifter
# for amd64, assumes constant-time barrel shifter
('both',
r'''TYPE TYPE_shlmod(TYPE X,TYPE S) {
#if amd64
 8:  S &= 7;
 8:  readasm("amd64; int8 X S; X <<= S");
16:  S &= 15;
16:  readasm("amd64; int16 X S; X <<= S");
32:  readasm("amd64; int32 X S; X <<= S");
64:  readasm("amd64; int64 X S; X <<= S");
#elif arm64
 8:  readasm("arm64; int8 X S; S = S & 7; X = (uint8) X; X = X << S");
16:  readasm("arm64; int16 X S; S = S & 15; X = (uint16) X; X = X << S");
32:  readasm("arm64; int32 X S; X = X << S");
64:  readasm("arm64; int64 X S; X = X << S");
#else
  int K, L;
  for (L = 0,K = 1;K < N;++L,K *= 2)
    X ^= (X ^ (X << K)) & TYPE_bitinrangepublicpos_mask(S,L);
#endif
  return X;
}'''
),

# same as (X >> (S % N)) but without assuming barrel shifter
('signed',
r'''TYPE TYPE_shrmod(TYPE X,TYPE S) {
#if amd64
 8:  S &= 7;
 8:  readasm("amd64; int8 X S; X signed>>= S");
16:  S &= 15;
16:  readasm("amd64; int16 X S; X signed>>= S");
32:  readasm("amd64; int32 X S; X signed>>= S");
64:  readasm("amd64; int64 X S; X signed>>= S");
#elif arm64
 8:  readasm("arm64; int8 X S; S = S & 7; X = (int8) X; X = X signed>> S");
16:  readasm("arm64; int16 X S; S = S & 15; X = (int16) X; X = X signed>> S");
32:  readasm("arm64; int32 X S; X = X signed>> S");
64:  readasm("arm64; int64 X S; X = X signed>> S");
#else
  int K, L;
  for (L = 0,K = 1;K < N;++L,K *= 2)
    X ^= (X ^ (X >> K)) & TYPE_bitinrangepublicpos_mask(S,L);
#endif
  return X;
}'''
),

# same as (X >> (S % N)) but without assuming barrel shifter
('unsigned',
r'''TYPE TYPE_shrmod(TYPE X,TYPE S) {
#if amd64
 8:  S &= 7;
 8:  readasm("amd64; int8 X S; X unsigned>>= S");
16:  S &= 15;
16:  readasm("amd64; int16 X S; X unsigned>>= S");
32:  readasm("amd64; int32 X S; X unsigned>>= S");
64:  readasm("amd64; int64 X S; X unsigned>>= S");
#elif arm64
 8:  readasm("arm64; int8 X S; S = S & 7; X = (uint8) X; X = X unsigned>> S");
16:  readasm("arm64; int16 X S; S = S & 15; X = (uint16) X; X = X unsigned>> S");
32:  readasm("arm64; int32 X S; X = X unsigned>> S");
64:  readasm("arm64; int64 X S; X = X unsigned>> S");
#else
  int K, L;
  for (L = 0,K = 1;K < N;++L,K *= 2)
    X ^= (X ^ (X >> K)) & TYPE_bitinrangepublicpos_mask(S,L);
#endif
  return X;
}'''
),

('both',
r'''TYPE TYPE_bitmod_mask(TYPE X,TYPE S) {
  X = TYPE_shrmod(X,S);
  return TYPE_bottombit_mask(X);
}'''
),

('both',
r'''TYPE TYPE_nonzero_mask(TYPE X) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Z; X & 255; Z = -1 if != else 0");
16:  readasm("arm64; int16 X Z; X & 65535; Z = -1 if != else 0");
32:  readasm("arm64; int32 X Z; X - 0; Z = -1 if != else 0");
64:  readasm("arm64; int64 X Z; X - 0; Z = -1 if != else 0");
  return Z;
#else
  X |= -X;
  return SIGNED_negative_mask(X);
#endif
}'''
),

('signed',
r'''TYPE TYPE_positive_mask(TYPE X)
{
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Z; Z = (int8) X; Z - 0; Z = -1 if signed> else 0");
16:  readasm("arm64; int16 X Z; Z = (int16) X; Z - 0; Z = -1 if signed> else 0");
32:  readasm("arm64; int32 X Z; X - 0; Z = -1 if signed> else 0");
64:  readasm("arm64; int64 X Z; X - 0; Z = -1 if signed> else 0");
  return Z;
#else
  TYPE Z = -X;
  Z ^= X & Z;
  return TYPE_negative_mask(Z);
#endif
}'''
),

('both',
r'''TYPE TYPE_zero_mask(TYPE X) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Z; X & 255; Z = -1 if = else 0");
16:  readasm("arm64; int16 X Z; X & 65535; Z = -1 if = else 0");
32:  readasm("arm64; int32 X Z; X - 0; Z = -1 if = else 0");
64:  readasm("arm64; int64 X Z; X - 0; Z = -1 if = else 0");
  return Z;
#else
  return ~TYPE_nonzero_mask(X);
#endif
}''',
),

('both',
r'''TYPE TYPE_unequal_mask(TYPE X,TYPE Y) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Y Z; Z = (uint8) X; Z - (uint8) Y; Z = -1 if != else 0");
16:  readasm("arm64; int16 X Y Z; Z = (uint16) X; Z - (uint16) Y; Z = -1 if != else 0");
32:  readasm("arm64; int32 X Y Z; X - Y; Z = -1 if != else 0");
64:  readasm("arm64; int64 X Y Z; X - Y; Z = -1 if != else 0");
  return Z;
#else
  return TYPE_nonzero_mask(X ^ Y);
#endif
}''',
),

('both',
r'''TYPE TYPE_equal_mask(TYPE X,TYPE Y) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Y Z; Z = (uint8) X; Z - (uint8) Y; Z = -1 if = else 0");
16:  readasm("arm64; int16 X Y Z; Z = (uint16) X; Z - (uint16) Y; Z = -1 if = else 0");
32:  readasm("arm64; int32 X Y Z; X - Y; Z = -1 if = else 0");
64:  readasm("arm64; int64 X Y Z; X - Y; Z = -1 if = else 0");
  return Z;
#else
  return ~TYPE_unequal_mask(X,Y);
#endif
}''',
),

('signed',
r'''TYPE TYPE_min(TYPE X,TYPE Y) {
#if amd64
 8:  int32_t X32 = X,Y32 = Y;
 8:  readasm("amd64; int32 X32 Y32; X32 - (int8) Y32; X32 = Y32 if signed>");
 8:  X = X32;
16:  readasm("amd64; int16 X Y; X - Y; X = Y if signed>");
32:  readasm("amd64; int32 X Y; X - Y; X = Y if signed>");
64:  readasm("amd64; int64 X Y; X - Y; X = Y if signed>");
  return X;
#elif arm64
 8:  readasm("arm64; int8 X Y; X = (int8) X; X - (int8) Y; X = X if signed< else Y");
16:  readasm("arm64; int16 X Y; X = (int16) X; X - (int16) Y; X = X if signed< else Y");
32:  readasm("arm64; int32 X Y; X - Y; X = X if signed< else Y");
64:  readasm("arm64; int64 X Y; X - Y; X = X if signed< else Y");
  return X;
#else
  TYPE R = Y ^ X;
  TYPE Z = Y - X;
  Z ^= R & (Z ^ Y);
  Z = TYPE_negative_mask(Z);
  Z &= R;
  return X ^ Z;
#endif
}'''
),

('unsigned',
r'''TYPE TYPE_min(TYPE X,TYPE Y) {
#if amd64
 8:  uint32_t X32 = X,Y32 = Y;
 8:  readasm("amd64; int32 X32 Y32; X32 - (int8) Y32; X32 = Y32 if unsigned>");
 8:  X = X32;
16:  readasm("amd64; int16 X Y; X - Y; X = Y if unsigned>");
32:  readasm("amd64; int32 X Y; X - Y; X = Y if unsigned>");
64:  readasm("amd64; int64 X Y; X - Y; X = Y if unsigned>");
  return X;
#elif arm64
 8:  readasm("arm64; int8 X Y; X = (uint8) X; X - (uint8) Y; X = X if unsigned< else Y");
16:  readasm("arm64; int16 X Y; X = (uint16) X; X - (uint16) Y; X = X if unsigned< else Y");
32:  readasm("arm64; int32 X Y; X - Y; X = X if unsigned< else Y");
64:  readasm("arm64; int64 X Y; X - Y; X = X if unsigned< else Y");
  return X;
#else
  TYPE R = Y ^ X;
  TYPE Z = Y - X;
  Z ^= R & (Z ^ Y ^ (((TYPE) 1) << (N-1)));
  Z = SIGNED_negative_mask(Z);
  Z &= R;
  return X ^ Z;
#endif
}'''
),

('signed',
r'''TYPE TYPE_max(TYPE X,TYPE Y) {
#if amd64
 8:  int32_t X32 = X,Y32 = Y;
 8:  readasm("amd64; int32 X32 Y32; X32 - (int8) Y32; X32 = Y32 if signed<");
 8:  X = X32;
16:  readasm("amd64; int16 X Y; X - Y; X = Y if signed<");
32:  readasm("amd64; int32 X Y; X - Y; X = Y if signed<");
64:  readasm("amd64; int64 X Y; X - Y; X = Y if signed<");
  return X;
#elif arm64
 8:  readasm("arm64; int8 X Y; X = (int8) X; X - (int8) Y; X = Y if signed< else X");
16:  readasm("arm64; int16 X Y; X = (int16) X; X - (int16) Y; X = Y if signed< else X");
32:  readasm("arm64; int32 X Y; X - Y; X = Y if signed< else X");
64:  readasm("arm64; int64 X Y; X - Y; X = Y if signed< else X");
  return X;
#else
  TYPE R = Y ^ X;
  TYPE Z = Y - X;
  Z ^= R & (Z ^ Y);
  Z = TYPE_negative_mask(Z);
  Z &= R;
  return Y ^ Z;
#endif
}'''
),

('unsigned',
r'''TYPE TYPE_max(TYPE X,TYPE Y) {
#if amd64
 8:  uint32_t X32 = X,Y32 = Y;
 8:  readasm("amd64; int32 X32 Y32; X32 - (int8) Y32; X32 = Y32 if unsigned<");
 8:  X = X32;
16:  readasm("amd64; int16 X Y; X - Y; X = Y if unsigned<");
32:  readasm("amd64; int32 X Y; X - Y; X = Y if unsigned<");
64:  readasm("amd64; int64 X Y; X - Y; X = Y if unsigned<");
  return X;
#elif arm64
 8:  readasm("arm64; int8 X Y; X = (uint8) X; X - (uint8) Y; X = Y if unsigned< else X");
16:  readasm("arm64; int16 X Y; X = (uint16) X; X - (uint16) Y; X = Y if unsigned< else X");
32:  readasm("arm64; int32 X Y; X - Y; X = Y if unsigned< else X");
64:  readasm("arm64; int64 X Y; X - Y; X = Y if unsigned< else X");
  return X;
#else
  TYPE R = Y ^ X;
  TYPE Z = Y - X;
  Z ^= R & (Z ^ Y ^ (((TYPE) 1) << (N-1)));
  Z = SIGNED_negative_mask(Z);
  Z &= R;
  return Y ^ Z;
#endif
}'''
),

('signed',
r'''void TYPE_minmax(TYPE *P,TYPE *Q) {
  TYPE X = *P;
  TYPE Y = *Q;
#if amd64
 8:  int32_t X32 = X,Y32 = Y,Z32;
 8:  readasm("amd64; int32 X32 Y32 Z32; X32 - (int8) Y32; Z32 = X32; X32 = Y32 if signed>; Y32 = Z32 if signed>");
 8:  X = X32; Y = Y32;
16:  TYPE Z;
16:  readasm("amd64; int16 X Y Z; X - Y; Z = X; X = Y if signed>; Y = Z if signed>");
32:  TYPE Z;
32:  readasm("amd64; int32 X Y Z; X - Y; Z = X; X = Y if signed>; Y = Z if signed>");
64:  TYPE Z;
64:  readasm("amd64; int64 X Y Z; X - Y; Z = X; X = Y if signed>; Y = Z if signed>");
  *P = X;
  *Q = Y;
#elif arm64
  TYPE R, S;
 8:  readasm("arm64; int8 X Y R S; X = (int8) X; X - (int8) Y; R = X if signed< else Y; S = Y if signed< else X");
16:  readasm("arm64; int16 X Y R S; X = (int16) X; X - (int16) Y; R = X if signed< else Y; S = Y if signed< else X");
32:  readasm("arm64; int32 X Y R S; X - Y; R = X if signed< else Y; S = Y if signed< else X");
64:  readasm("arm64; int64 X Y R S; X - Y; R = X if signed< else Y; S = Y if signed< else X");
  *P = R;
  *Q = S;
#else
  TYPE R = Y ^ X;
  TYPE Z = Y - X;
  Z ^= R & (Z ^ Y);
  Z = TYPE_negative_mask(Z);
  Z &= R;
  X ^= Z;
  Y ^= Z;
  *P = X;
  *Q = Y;
#endif
}'''
),

('unsigned',
r'''void TYPE_minmax(TYPE *P,TYPE *Q) {
  TYPE X = *P;
  TYPE Y = *Q;
#if amd64
 8:  uint32_t X32 = X,Y32 = Y,Z32;
 8:  readasm("amd64; int32 X32 Y32 Z32; X32 - (int8) Y32; Z32 = X32; X32 = Y32 if unsigned>; Y32 = Z32 if unsigned>");
 8:  X = X32; Y = Y32;
16:  TYPE Z;
16:  readasm("amd64; int16 X Y Z; X - Y; Z = X; X = Y if unsigned>; Y = Z if unsigned>");
32:  TYPE Z;
32:  readasm("amd64; int32 X Y Z; X - Y; Z = X; X = Y if unsigned>; Y = Z if unsigned>");
64:  TYPE Z;
64:  readasm("amd64; int64 X Y Z; X - Y; Z = X; X = Y if unsigned>; Y = Z if unsigned>");
  *P = X;
  *Q = Y;
#elif arm64
  TYPE R, S;
 8:  readasm("arm64; int8 X Y R S; X = (uint8) X; X - (uint8) Y; R = X if unsigned< else Y; S = Y if unsigned< else X");
16:  readasm("arm64; int16 X Y R S; X = (uint16) X; X - (uint16) Y; R = X if unsigned< else Y; S = Y if unsigned< else X");
32:  readasm("arm64; int32 X Y R S; X - Y; R = X if unsigned< else Y; S = Y if unsigned< else X");
64:  readasm("arm64; int64 X Y R S; X - Y; R = X if unsigned< else Y; S = Y if unsigned< else X");
  *P = R;
  *Q = S;
#else
  TYPE R = Y ^ X;
  TYPE Z = Y - X;
  Z ^= R & (Z ^ Y ^ (((TYPE) 1) << (N-1)));
  Z = SIGNED_negative_mask(Z);
  Z &= R;
  X ^= Z;
  Y ^= Z;
  *P = X;
  *Q = Y;
#endif
}'''
),

('signed',
r'''TYPE TYPE_smaller_mask(TYPE X,TYPE Y) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Y Z; Z = (int8) X; Z - (int8) Y; Z = -1 if signed< else 0");
16:  readasm("arm64; int16 X Y Z; Z = (int16) X; Z - (int16) Y; Z = -1 if signed< else 0");
32:  readasm("arm64; int32 X Y Z; X - Y; Z = -1 if signed< else 0");
64:  readasm("arm64; int64 X Y Z; X - Y; Z = -1 if signed< else 0");
  return Z;
#else
  TYPE R = X ^ Y;
  TYPE Z = X - Y;
  Z ^= R & (Z ^ X);
  return TYPE_negative_mask(Z);
#endif
}'''
),

('unsigned',
r'''TYPE TYPE_smaller_mask(TYPE X,TYPE Y) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Y Z; Z = (uint8) X; Z - (uint8) Y; Z = -1 if unsigned< else 0");
16:  readasm("arm64; int16 X Y Z; Z = (uint16) X; Z - (uint16) Y; Z = -1 if unsigned< else 0");
32:  readasm("arm64; int32 X Y Z; X - Y; Z = -1 if unsigned< else 0");
64:  readasm("arm64; int64 X Y Z; X - Y; Z = -1 if unsigned< else 0");
  return Z;
#else
  TYPE R = X ^ Y;
  TYPE Z = X - Y;
  Z ^= R & (Z ^ X ^ (((TYPE) 1) << (N-1)));
  return SIGNED_negative_mask(Z);
#endif
}'''
),

('signed',
r'''TYPE TYPE_leq_mask(TYPE X,TYPE Y) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Y Z; Z = (int8) X; Z - (int8) Y; Z = -1 if signed<= else 0");
16:  readasm("arm64; int16 X Y Z; Z = (int16) X; Z - (int16) Y; Z = -1 if signed<= else 0");
32:  readasm("arm64; int32 X Y Z; X - Y; Z = -1 if signed<= else 0");
64:  readasm("arm64; int64 X Y Z; X - Y; Z = -1 if signed<= else 0");
  return Z;
#else
  return ~TYPE_smaller_mask(Y,X);
#endif
}'''
),

('unsigned',
r'''TYPE TYPE_leq_mask(TYPE X,TYPE Y) {
#if arm64
  TYPE Z;
 8:  readasm("arm64; int8 X Y Z; Z = (uint8) X; Z - (uint8) Y; Z = -1 if unsigned<= else 0");
16:  readasm("arm64; int16 X Y Z; Z = (uint16) X; Z - (uint16) Y; Z = -1 if unsigned<= else 0");
32:  readasm("arm64; int32 X Y Z; X - Y; Z = -1 if unsigned<= else 0");
64:  readasm("arm64; int64 X Y Z; X - Y; Z = -1 if unsigned<= else 0");
  return Z;
#else
  return ~TYPE_smaller_mask(Y,X);
#endif
}'''
),

# XXX: consider *0x...10101 for the denouement _if_ mul is constant-time
# XXX: use popcnt if __SSE4_2__
# XXX: use cnt if arm64 cssc
# XXX: maybe use neon cnt if arm64
('both',
r'''int TYPE_ones_num(TYPE X) {
  UNSIGNED Y = X;
 8:  const TYPE C0 = 0x55;
16:  const TYPE C0 = 0x5555;
32:  const TYPE C0 = 0x55555555;
64:  const TYPE C0 = 0x5555555555555555;
 8:  const TYPE C1 = 0x33;
16:  const TYPE C1 = 0x3333;
32:  const TYPE C1 = 0x33333333;
64:  const TYPE C1 = 0x3333333333333333;
 8:  const TYPE C2 = 0x0f;
16:  const TYPE C2 = 0x0f0f;
32:  const TYPE C2 = 0x0f0f0f0f;
64:  const TYPE C2 = 0x0f0f0f0f0f0f0f0f;
  Y -= ((Y >> 1) & C0);
  Y = (Y & C1) + ((Y >> 2) & C1);
  Y = (Y + (Y >> 4)) & C2;
16:  Y = (Y + (Y >> 8)) & 0xff;
32:  Y += Y >> 8;
32:  Y = (Y + (Y >> 16)) & 0xff;
64:  Y += Y >> 8;
64:  Y += Y >> 16;
64:  Y = (Y + (Y >> 32)) & 0xff;
  return Y;
}'''
),

# XXX: use tzcnt if amd64 bmi1
# XXX: use ctz if arm64 cssc
('both',
r'''int TYPE_bottomzeros_num(TYPE X) {
#if amd64
 8:  int32_t fallback = N;
 8:  int32_t X32 = X;
 8:  readasm("amd64; int32 X32 fallback; X32 = numbottomzeros_tricky X32; X32 = fallback if =");
 8:  X = X32;
16:  TYPE fallback = N;
16:  readasm("amd64; int16 X fallback; X = numbottomzeros_tricky X; X = fallback if =");
32:  TYPE fallback = N;
32:  readasm("amd64; int32 X fallback; X = numbottomzeros_tricky X; X = fallback if =");
64:  TYPE fallback = N;
64:  readasm("amd64; int64 X fallback; X = numbottomzeros_tricky X; X = fallback if =");
  return X;
#elif arm64
  int64_t Y;
 8:  readasm("arm64; int8 X Y; Y = X | -256; Y = bitrev32 Y; Y = numbottomzeros Y");
16:  readasm("arm64; int16 X Y; Y = X | -65536; Y = bitrev32 Y; Y = numbottomzeros Y");
32:  readasm("arm64; int32 X Y; Y = bitrev32 X; Y = numbottomzeros Y");
64:  readasm("arm64; int64 X Y; Y = bitrev64 X; Y = numbottomzeros Y");
  return Y;
#else
  TYPE Y = X ^ (X-1);
  Y = ((SIGNED) Y) >> 1;
  Y &= ~(X & (((TYPE) 1) << (N-1)));
  return TYPE_ones_num(Y);
#endif
}'''
),

):
  if which in ('both','signed'):
    data = fun
    data = data.replace('TYPE','crypto_intN')
    data = data.replace('UNSIGNED','crypto_intN_unsigned')
    data = data.replace('SIGNED','crypto_intN')
    for v in vars:
      data = data.replace(v.upper(),'crypto_intN_'+v)
    csh += '__attribute__((unused))\n'
    csh += 'static inline\n'
    csh += data
    csh += '\n\n'

  if which in ('both','unsigned'):
    data = fun
    data = data.replace('TYPE','crypto_uintN')
    data = data.replace('UNSIGNED','crypto_uintN')
    data = data.replace('SIGNED','crypto_uintN_signed')
    for v in vars:
      data = data.replace(v.upper(),'crypto_uintN_'+v)
    cuh += '__attribute__((unused))\n'
    cuh += 'static inline\n'
    cuh += data
    cuh += '\n\n'

# ===== bottom

csh += '''#endif
'''

cuh += '''#endif
'''

# ===== ship it

with open('crypto_intN.h','w') as f:
  f.write(csh)

with open('crypto_uintN.h','w') as f:
  f.write(cuh)

with open('intN_optblocker.c','w') as f:
  f.write('''/* auto-generated: cd inttypes; ./autogen */
#include "crypto_intN.h"

volatile crypto_intN crypto_intN_optblocker = 0;
''')

with open('uintN_optblocker.c','w') as f:
  f.write('''/* auto-generated: cd inttypes; ./autogen */
#include "crypto_uintN.h"

volatile crypto_uintN_signed crypto_uintN_signed_optblocker = 0;
''')
