# SPDX-License-Identifier: MIT

CC = gcc
CFLAGS += -I. -O3 -Wall -Wextra -march=native -fomit-frame-pointer
NISTFLAGS = -Wno-sign-compare -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-result
AVX2FLAGS = -mavx2 -mpclmul

EXECUTABLE_TESTAIM2  = tests/test_aim2
EXECUTABLE_TESTSIGN  = tests/test_sign
EXECUTABLE_TESTSPEED = tests/test_speed
EXECUTABLE_KAT       = PQCgenKAT_sign

.PHONY: all

all: $(EXECUTABLE_TESTAIM2) $(EXECUTABLE_TESTSIGN) $(EXECUTABLE_TESTSPEED) $(EXECUTABLE_KAT)

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

$(EXECUTABLE_TESTAIM2): $(EXECUTABLE_TESTAIM2).c aim2.c field.c hash.c common/keccak_avx2/fips202.c common/keccak_avx2/KeccakP-1600-AVX2.s common/keccak4x/KeccakP-1600-times4-SIMD256.c
	$(CC) $(CFLAGS) $(AVX2FLAGS) $^ -o $@

$(EXECUTABLE_TESTSIGN): $(EXECUTABLE_TESTSIGN).c aim2.c field.c hash.c sign.c tree.c common/aes.c common/keccak_avx2/fips202.c common/keccak_avx2/KeccakP-1600-AVX2.s common/keccak4x/KeccakP-1600-times4-SIMD256.c common/rng.c
	$(CC) $(CFLAGS) $(AVX2FLAGS) $^ -o $@

$(EXECUTABLE_TESTSPEED): $(EXECUTABLE_TESTSPEED).c aim2.c field.c hash.c sign.c tree.c common/aes.c common/speed_print.c common/cpucycles.c common/keccak_avx2/fips202.c common/keccak_avx2/KeccakP-1600-AVX2.s common/keccak4x/KeccakP-1600-times4-SIMD256.c common/rng.c
	$(CC) $(CFLAGS) $(AVX2FLAGS) $^ -o $@

$(EXECUTABLE_KAT): common/$(EXECUTABLE_KAT).c aim2.c field.c hash.c sign.c tree.c common/aes.c common/keccak_avx2/fips202.c common/keccak_avx2/KeccakP-1600-AVX2.s common/keccak4x/KeccakP-1600-times4-SIMD256.c common/rng.c
	$(CC) $(CFLAGS) $(AVX2FLAGS) $^ -o $@

clean:
	rm -f $(wildcard *.o) $(EXECUTABLE_TESTAIM2) $(EXECUTABLE_TESTSIGN) $(EXECUTABLE_TESTSPEED) $(EXECUTABLE_KAT) PQCsignKAT_*.rsp PQCsignKAT_*.req
