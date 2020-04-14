default: mult1024.c ntt.s ntt.h

mult1024.c: ../avx/mult1024.c
	cp ../avx/mult1024.c .

ntt.h: ../avx/ntt.h
	sed 's/_avx_/_avx800_/g' ../avx/ntt.h > ntt.h

ntt.s: ../avx/ntt.c ntt.h
	cp ../avx/ntt.c .
	clang -fno-addrsig -fPIC -fPIE -fwrapv -O3 -march=haswell -mtune=haswell -S -I. ntt.c
	rm ntt.c
