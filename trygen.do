#!/bin/sh

for o in \
core hashblocks xof hash stream onetimeauth auth secretbox aead rng \
scalarmult box dh sign encrypt kem
do
  ./trygen.py $o > crypto_$o/try.c
done
