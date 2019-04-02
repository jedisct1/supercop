all: libK12-AVX2.a
libK12-AVX2.a: bin/libK12-AVX2.a
libK12-AVX2.a.pack: bin/libK12-AVX2.a.tar.gz

BINDIR = bin/.build/libK12-AVX2.a
$(BINDIR):
	mkdir -p $(BINDIR)

MAKE ?= gmake
CC ?= gcc
AR = ar

CFLAGS := $(CFLAGS) -fomit-frame-pointer

CFLAGS := $(CFLAGS) -O2

CFLAGS := $(CFLAGS) -g0

CFLAGS := $(CFLAGS) -march=native

CFLAGS := $(CFLAGS) -mtune=native

HEADERS := $(HEADERS) Constructions/KeccakSponge-common.h
SOURCES := $(SOURCES) Constructions/KeccakSponge-common.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSponge.inc
SOURCES := $(SOURCES) Constructions/KeccakSponge.inc
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSpongeWidth1600.h
SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth1600.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Modes/KangarooTwelve.h
SOURCES := $(SOURCES) Modes/KangarooTwelve.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/Phases.h
SOURCES := $(SOURCES) Modes/Phases.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) SnP/KeccakP-1600/OptimizedAVX2/KeccakP-1600-AVX2.h
SOURCES := $(SOURCES) SnP/KeccakP-1600/OptimizedAVX2/KeccakP-1600-AVX2.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/OptimizedAVX2/

HEADERS := $(HEADERS) SnP/KeccakP-1600/OptimizedAVX2/KeccakP-1600-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-1600/OptimizedAVX2/KeccakP-1600-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/OptimizedAVX2/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times2/SIMD128/KeccakP-1600-times2-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times2/SIMD128/KeccakP-1600-times2-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times2/SIMD128/

HEADERS := $(HEADERS) SnP/KeccakP-1600/Optimized/KeccakP-1600-unrolling.macros
SOURCES := $(SOURCES) SnP/KeccakP-1600/Optimized/KeccakP-1600-unrolling.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/Optimized/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times2/SIMD128/SSE2u2/SIMD128-config.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times2/SIMD128/SSE2u2/SIMD128-config.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times2/SIMD128/SSE2u2/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times4/SIMD256/KeccakP-1600-times4-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times4/SIMD256/KeccakP-1600-times4-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times4/SIMD256/

HEADERS := $(HEADERS) SnP/KeccakP-1600/Optimized/KeccakP-1600-unrolling.macros
SOURCES := $(SOURCES) SnP/KeccakP-1600/Optimized/KeccakP-1600-unrolling.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/Optimized/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times4/SIMD256/AVX2u12/SIMD256-config.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times4/SIMD256/AVX2u12/SIMD256-config.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times4/SIMD256/AVX2u12/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times8/FallbackOn4/KeccakP-1600-times8-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times8/FallbackOn4/KeccakP-1600-times8-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times8/FallbackOn4/

HEADERS := $(HEADERS) PlSnP/Fallback/PlSnP-Fallback.inc
SOURCES := $(SOURCES) PlSnP/Fallback/PlSnP-Fallback.inc
CFLAGS := $(CFLAGS) -IPlSnP/Fallback/

HEADERS := $(HEADERS) Common/align.h
SOURCES := $(SOURCES) Common/align.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth1600.c
$(BINDIR)/KeccakSpongeWidth1600.o: Constructions/KeccakSpongeWidth1600.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakSpongeWidth1600.o

SOURCES := $(SOURCES) Modes/KangarooTwelve.c
$(BINDIR)/KangarooTwelve.o: Modes/KangarooTwelve.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KangarooTwelve.o

SOURCES := $(SOURCES) SnP/KeccakP-1600/OptimizedAVX2/KeccakP-1600-AVX2.cpp
$(BINDIR)/KeccakP-1600-AVX2.o: SnP/KeccakP-1600/OptimizedAVX2/KeccakP-1600-AVX2.cpp $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-AVX2.o

SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times2/SIMD128/KeccakP-1600-times2-SIMD128.c
$(BINDIR)/KeccakP-1600-times2-SIMD128.o: PlSnP/KeccakP-1600-times2/SIMD128/KeccakP-1600-times2-SIMD128.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-times2-SIMD128.o

SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times4/SIMD256/KeccakP-1600-times4-SIMD256.c
$(BINDIR)/KeccakP-1600-times4-SIMD256.o: PlSnP/KeccakP-1600-times4/SIMD256/KeccakP-1600-times4-SIMD256.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-times4-SIMD256.o

SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times8/FallbackOn4/KeccakP-1600-times8-on4.c
$(BINDIR)/KeccakP-1600-times8-on4.o: PlSnP/KeccakP-1600-times8/FallbackOn4/KeccakP-1600-times8-on4.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-times8-on4.o

bin/libK12-AVX2.a: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	mkdir -p $@.headers
	cp -f $(HEADERS) $@.headers/
	$(AR) rcsv $@ $(OBJECTS)
bin/libK12-AVX2.a.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/libK12-AVX2.a
	rm -rf bin/.pack/libK12-AVX2.a/*
	cp $(SOURCES) bin/.pack/libK12-AVX2.a/
	cd bin/.pack/ ; tar -czf ../../bin/libK12-AVX2.a.tar.gz libK12-AVX2.a/*

