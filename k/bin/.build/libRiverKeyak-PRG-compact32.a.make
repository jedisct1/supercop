all: libRiverKeyak-PRG-compact32.a
libRiverKeyak-PRG-compact32.a: bin/libRiverKeyak-PRG-compact32.a
libRiverKeyak-PRG-compact32.a.pack: bin/libRiverKeyak-PRG-compact32.a.tar.gz

BINDIR = bin/.build/libRiverKeyak-PRG-compact32.a
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

HEADERS := $(HEADERS) Constructions/KeccakDuplex-common.h
SOURCES := $(SOURCES) Constructions/KeccakDuplex-common.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplex.inc
SOURCES := $(SOURCES) Constructions/KeccakDuplex.inc
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplexWidth800.h
SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth800.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Modes/KeccakPRG-common.h
SOURCES := $(SOURCES) Modes/KeccakPRG-common.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KeccakPRG.inc
SOURCES := $(SOURCES) Modes/KeccakPRG.inc
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KeccakPRGWidth800.h
SOURCES := $(SOURCES) Modes/KeccakPRGWidth800.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) SnP/KeccakP-800/Compact/KeccakP-800-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-800/Compact/KeccakP-800-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Compact/

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

SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth800.c
$(BINDIR)/KeccakDuplexWidth800.o: Constructions/KeccakDuplexWidth800.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplexWidth800.o

SOURCES := $(SOURCES) Modes/KeccakPRGWidth800.c
$(BINDIR)/KeccakPRGWidth800.o: Modes/KeccakPRGWidth800.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakPRGWidth800.o

SOURCES := $(SOURCES) SnP/KeccakP-800/Compact/KeccakP-800-compact.c
$(BINDIR)/KeccakP-800-compact.o: SnP/KeccakP-800/Compact/KeccakP-800-compact.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-800-compact.o

SOURCES := $(SOURCES) Keyak/RiverKeyak.c
$(BINDIR)/RiverKeyak.o: Keyak/RiverKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/RiverKeyak.o

bin/libRiverKeyak-PRG-compact32.a: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	mkdir -p $@.headers
	cp -f $(HEADERS) $@.headers/
	$(AR) rcsv $@ $(OBJECTS)
bin/libRiverKeyak-PRG-compact32.a.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/libRiverKeyak-PRG-compact32.a
	rm -rf bin/.pack/libRiverKeyak-PRG-compact32.a/*
	cp $(SOURCES) bin/.pack/libRiverKeyak-PRG-compact32.a/
	cd bin/.pack/ ; tar -czf ../../bin/libRiverKeyak-PRG-compact32.a.tar.gz libRiverKeyak-PRG-compact32.a/*

