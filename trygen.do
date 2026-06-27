#!/bin/sh

for o in \
core hashblocks xof hash stream pow onetimeauth auth secretbox aead rng \
nP nG mGnP scalarmult box dh sign encrypt kem
do
  ./trygen.py $o > crypto_$o/try.c
done
