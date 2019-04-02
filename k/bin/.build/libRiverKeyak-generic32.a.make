all: libRiverKeyak-generic32.a
libRiverKeyak-generic32.a: bin/libRiverKeyak-generic32.a
libRiverKeyak-generic32.a.pack: bin/libRiverKeyak-generic32.a.tar.gz

BINDIR = bin/.build/libRiverKeyak-generic32.a
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

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) SnP/KeccakP-800/Optimized32/KeccakP-800-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/KeccakP-800-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Optimized32/

HEADERS := $(HEADERS) SnP/KeccakP-800/Optimized32/KeccakP-800-opt32-bis.macros
SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/KeccakP-800-opt32-bis.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Optimized32/

HEADERS := $(HEADERS) SnP/KeccakP-800/Optimized32/KeccakP-800-opt32.macros
SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/KeccakP-800-opt32.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Optimized32/

HEADERS := $(HEADERS) SnP/KeccakP-800/Optimized32/KeccakP-800-unrolling-bis.macros
SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/KeccakP-800-unrolling-bis.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Optimized32/

HEADERS := $(HEADERS) SnP/KeccakP-800/Optimized32/KeccakP-800-unrolling.macros
SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/KeccakP-800-unrolling.macros
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Optimized32/

HEADERS := $(HEADERS) SnP/KeccakP-800/Optimized32/LCu2/KeccakP-800-opt32-config.h
SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/LCu2/KeccakP-800-opt32-config.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Optimized32/LCu2/

HEADERS := $(HEADERS) Keyak/Motorist.inc
SOURCES := $(SOURCES) Keyak/Motorist.inc
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Keyak/Keyak-common.h
SOURCES := $(SOURCES) Keyak/Keyak-common.h
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Keyak/Keyakv2.inc
SOURCES := $(SOURCES) Keyak/Keyakv2.inc
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Keyak/RiverKeyak.h
SOURCES := $(SOURCES) Keyak/RiverKeyak.h
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Common/align.h
SOURCES := $(SOURCES) Common/align.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/KeccakP-800-opt32.c
$(BINDIR)/KeccakP-800-opt32.o: SnP/KeccakP-800/Optimized32/KeccakP-800-opt32.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-800-opt32.o

SOURCES := $(SOURCES) Keyak/RiverKeyak.c
$(BINDIR)/RiverKeyak.o: Keyak/RiverKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/RiverKeyak.o

bin/libRiverKeyak-generic32.a: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	mkdir -p $@.headers
	cp -f $(HEADERS) $@.headers/
	$(AR) rcsv $@ $(OBJECTS)
bin/libRiverKeyak-generic32.a.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/libRiverKeyak-generic32.a
	rm -rf bin/.pack/libRiverKeyak-generic32.a/*
	cp $(SOURCES) bin/.pack/libRiverKeyak-generic32.a/
	cd bin/.pack/ ; tar -czf ../../bin/libRiverKeyak-generic32.a.tar.gz libRiverKeyak-generic32.a/*

