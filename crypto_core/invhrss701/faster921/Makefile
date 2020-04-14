core.s: ../faster/core.c
	echo '#define crypto_core crypto_core_invhrss701_faster921' > crypto_core.h
	gcc -fPIC -fPIE -fwrapv -O3 -march=haswell -mtune=haswell -S -I. ../faster/core.c
	rm crypto_core.h
