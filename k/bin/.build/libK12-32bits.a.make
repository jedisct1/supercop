all: libK12-32bits.a
libK12-32bits.a: bin/libK12-32bits.a
libK12-32bits.a.pack: bin/libK12-32bits.a.tar.gz

BINDIR = bin/.build/libK12-32bits.a
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

CFLAGS := $(CFLAGS) -DKeccakP1600timesN_excluded

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

HEADERS := $(HEADERS) SnP/KeccakP-1600/Inplace32BI/KeccakP-1600-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-1600/Inplace32BI/KeccakP-1600-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/Inplace32BI/

HEADERS := $(HEADERS) SnP/SnP-Relaned.h
SOURCES := $(SOURCES) SnP/SnP-Relaned.h
CFLAGS := $(CFLAGS) -ISnP/

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

SOURCES := $(SOURCES) SnP/KeccakP-1600/Inplace32BI/KeccakP-1600-inplace32BI.c
$(BINDIR)/KeccakP-1600-inplace32BI.o: SnP/KeccakP-1600/Inplace32BI/KeccakP-1600-inplace32BI.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-inplace32BI.o

bin/libK12-32bits.a: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	mkdir -p $@.headers
	cp -f $(HEADERS) $@.headers/
	$(AR) rcsv $@ $(OBJECTS)
bin/libK12-32bits.a.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/libK12-32bits.a
	rm -rf bin/.pack/libK12-32bits.a/*
	cp $(SOURCES) bin/.pack/libK12-32bits.a/
	cd bin/.pack/ ; tar -czf ../../bin/libK12-32bits.a.tar.gz libK12-32bits.a/*

