all: FIPS202-opt64
FIPS202-opt64: bin/FIPS202-opt64
FIPS202-opt64.pack: bin/FIPS202-opt64.tar.gz

BINDIR = bin/.build/FIPS202-opt64
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

CFLAGS := $(CFLAGS) -m64

HEADERS := $(HEADERS) Constructions/KeccakSponge-common.h
SOURCES := $(SOURCES) Constructions/KeccakSponge-common.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSponge.inc
SOURCES := $(SOURCES) Constructions/KeccakSponge.inc
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSpongeWidth1600.h
SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth1600.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Modes/SimpleFIPS202.h
SOURCES := $(SOURCES) Modes/SimpleFIPS202.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KeccakHash.h
SOURCES := $(SOURCES) Modes/KeccakHash.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) SnP/KeccakP-1600/Optimized/KeccakP-1600-unrolling.macros
SOURCES := $(SOURCES) SnP/KeccakP-1600/Optimized/KeccakP-1600-unrolling.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/Optimized/

HEADERS := $(HEADERS) SnP/KeccakP-1600/Optimized/KeccakP-1600-64.macros
SOURCES := $(SOURCES) SnP/KeccakP-1600/Optimized/KeccakP-1600-64.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/Optimized/

HEADERS := $(HEADERS) SnP/KeccakP-1600/Optimized64/KeccakP-1600-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-1600/Optimized64/KeccakP-1600-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/Optimized64/

HEADERS := $(HEADERS) SnP/SnP-Relaned.h
SOURCES := $(SOURCES) SnP/SnP-Relaned.h
CFLAGS := $(CFLAGS) -ISnP/

HEADERS := $(HEADERS) SnP/KeccakP-1600/Optimized64/ufull/KeccakP-1600-opt64-config.h
SOURCES := $(SOURCES) SnP/KeccakP-1600/Optimized64/ufull/KeccakP-1600-opt64-config.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/Optimized64/ufull/

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

SOURCES := $(SOURCES) Modes/SimpleFIPS202.c
$(BINDIR)/SimpleFIPS202.o: Modes/SimpleFIPS202.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/SimpleFIPS202.o

SOURCES := $(SOURCES) Modes/KeccakHash.c
$(BINDIR)/KeccakHash.o: Modes/KeccakHash.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakHash.o

SOURCES := $(SOURCES) SnP/KeccakP-1600/Optimized64/KeccakP-1600-opt64.c
$(BINDIR)/KeccakP-1600-opt64.o: SnP/KeccakP-1600/Optimized64/KeccakP-1600-opt64.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-opt64.o

bin/FIPS202-opt64: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	$(CC) -o $@ $(OBJECTS) $(CFLAGS)
bin/FIPS202-opt64.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/FIPS202-opt64
	rm -rf bin/.pack/FIPS202-opt64/*
	cp $(SOURCES) bin/.pack/FIPS202-opt64/
	cd bin/.pack/ ; tar -czf ../../bin/FIPS202-opt64.tar.gz FIPS202-opt64/*

