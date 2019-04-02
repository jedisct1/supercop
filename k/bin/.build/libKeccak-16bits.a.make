all: libKeccak-16bits.a
libKeccak-16bits.a: bin/libKeccak-16bits.a
libKeccak-16bits.a.pack: bin/libKeccak-16bits.a.tar.gz

BINDIR = bin/.build/libKeccak-16bits.a
$(BINDIR):
	mkdir -p $(BINDIR)

MAKE ?= gmake
CC ?= gcc
AR = ar

HEADERS := $(HEADERS) Constructions/KeccakSponge-common.h
SOURCES := $(SOURCES) Constructions/KeccakSponge-common.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSponge.inc
SOURCES := $(SOURCES) Constructions/KeccakSponge.inc
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSpongeWidth400.h
SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth400.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplex-common.h
SOURCES := $(SOURCES) Constructions/KeccakDuplex-common.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplex.inc
SOURCES := $(SOURCES) Constructions/KeccakDuplex.inc
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplexWidth400.h
SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth400.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) SnP/KeccakP-400/Reference/KeccakP-400-reference.h
SOURCES := $(SOURCES) SnP/KeccakP-400/Reference/KeccakP-400-reference.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-400/Reference/

HEADERS := $(HEADERS) SnP/KeccakP-400/Reference/KeccakP-400-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-400/Reference/KeccakP-400-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-400/Reference/

HEADERS := $(HEADERS) Common/align.h
SOURCES := $(SOURCES) Common/align.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth400.c
$(BINDIR)/KeccakSpongeWidth400.o: Constructions/KeccakSpongeWidth400.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakSpongeWidth400.o

SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth400.c
$(BINDIR)/KeccakDuplexWidth400.o: Constructions/KeccakDuplexWidth400.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplexWidth400.o

SOURCES := $(SOURCES) SnP/KeccakP-400/Reference/KeccakP-400-reference.c
$(BINDIR)/KeccakP-400-reference.o: SnP/KeccakP-400/Reference/KeccakP-400-reference.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-400-reference.o

bin/libKeccak-16bits.a: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	mkdir -p $@.headers
	cp -f $(HEADERS) $@.headers/
	$(AR) rcsv $@ $(OBJECTS)
bin/libKeccak-16bits.a.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/libKeccak-16bits.a
	rm -rf bin/.pack/libKeccak-16bits.a/*
	cp $(SOURCES) bin/.pack/libKeccak-16bits.a/
	cd bin/.pack/ ; tar -czf ../../bin/libKeccak-16bits.a.tar.gz libKeccak-16bits.a/*

