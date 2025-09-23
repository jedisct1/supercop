#!/usr/bin/env python3

import sys

p = 2**256 - 2**224 + 2**192 + 2**96 - 1
a = -3
base = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5

# goal:
# if 0 <= i <= floor(256/b)
# and 1 <= j <= 2^(b-1)
# then position 2^(b-1)*i+j-1 in table
# has the point (2^(b*i)*j)*base

b = 4 # 64*8 table entries
# matching s2n-bignum choice for x25519

def inv(x):
  assert p != 0
  return pow(x,p-2,p)

def dbl(P):
  x1,y1 = P
  L = (3*x1**2+a)*inv(2*y1)
  x3 = L**2-x1-x1
  y3 = (x1-x3)*L-y1
  return x3%p,y3%p

def add(P1,P2):
  if P1 == P2: return dbl(P1)
  x1,y1 = P1
  x2,y2 = P2
  L = (y2-y1)*inv(x2-x1)
  x3 = L**2-x1-x2
  y3 = (x1-x3)*L-y1
  return x3%p,y3%p

def dbl_btimes(P):
  for d in range(b):
    P = dbl(P)
  return P

row = [base]
while len(row) < 2**(b-1):
  row += [add(row[-1],base)]

radix = 2**64
def printz(z):
  z = (z*2**256)%p
  for pos in range(4):
    sys.stdout.write(hex(z%radix)+',')
    z //= radix
  sys.stdout.write('\n')

for i in range(1+(256//b)):
  for x,y in row:
    printz(x)
    printz(y)
  row = list(map(dbl_btimes,row))
