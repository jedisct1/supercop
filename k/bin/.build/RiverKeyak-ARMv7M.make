all: RiverKeyak-ARMv7M
RiverKeyak-ARMv7M: bin/RiverKeyak-ARMv7M
RiverKeyak-ARMv7M.pack: bin/RiverKeyak-ARMv7M.tar.gz

BINDIR = bin/.build/RiverKeyak-ARMv7M
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

HEADERS := $(HEADERS) SnP/KeccakP-800/OptimizedAsmARM/KeccakP-800-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-800/OptimizedAsmARM/KeccakP-800-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/OptimizedAsmARM/

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

SOURCES := $(SOURCES) SnP/KeccakP-800/OptimizedAsmARM/KeccakP-800-u2-armv7m-le-gcc.s
$(BINDIR)/KeccakP-800-u2-armv7m-le-gcc.o: SnP/KeccakP-800/OptimizedAsmARM/KeccakP-800-u2-armv7m-le-gcc.s $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-800-u2-armv7m-le-gcc.o

SOURCES := $(SOURCES) Keyak/RiverKeyak.c
$(BINDIR)/RiverKeyak.o: Keyak/RiverKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/RiverKeyak.o

bin/RiverKeyak-ARMv7M: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	$(CC) -o $@ $(OBJECTS) $(CFLAGS)
bin/RiverKeyak-ARMv7M.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/RiverKeyak-ARMv7M
	rm -rf bin/.pack/RiverKeyak-ARMv7M/*
	cp $(SOURCES) bin/.pack/RiverKeyak-ARMv7M/
	cd bin/.pack/ ; tar -czf ../../bin/RiverKeyak-ARMv7M.tar.gz RiverKeyak-ARMv7M/*

