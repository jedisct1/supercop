all: PRG-AVR8
PRG-AVR8: bin/PRG-AVR8
PRG-AVR8.pack: bin/PRG-AVR8.tar.gz

BINDIR = bin/.build/PRG-AVR8
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

HEADERS := $(HEADERS) Constructions/KeccakDuplexWidth200.h
SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth200.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Modes/KeccakPRG-common.h
SOURCES := $(SOURCES) Modes/KeccakPRG-common.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KeccakPRG.inc
SOURCES := $(SOURCES) Modes/KeccakPRG.inc
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KeccakPRGWidth200.h
SOURCES := $(SOURCES) Modes/KeccakPRGWidth200.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) SnP/KeccakP-200/OptimizedAsmAVR8/KeccakP-200-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-200/OptimizedAsmAVR8/KeccakP-200-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-200/OptimizedAsmAVR8/

HEADERS := $(HEADERS) Common/align.h
SOURCES := $(SOURCES) Common/align.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth200.c
$(BINDIR)/KeccakDuplexWidth200.o: Constructions/KeccakDuplexWidth200.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplexWidth200.o

SOURCES := $(SOURCES) Modes/KeccakPRGWidth200.c
$(BINDIR)/KeccakPRGWidth200.o: Modes/KeccakPRGWidth200.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakPRGWidth200.o

SOURCES := $(SOURCES) SnP/KeccakP-200/OptimizedAsmAVR8/KeccakP-200-avr8-fast.s
$(BINDIR)/KeccakP-200-avr8-fast.o: SnP/KeccakP-200/OptimizedAsmAVR8/KeccakP-200-avr8-fast.s $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-200-avr8-fast.o

bin/PRG-AVR8: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	$(CC) -o $@ $(OBJECTS) $(CFLAGS)
bin/PRG-AVR8.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/PRG-AVR8
	rm -rf bin/.pack/PRG-AVR8/*
	cp $(SOURCES) bin/.pack/PRG-AVR8/
	cd bin/.pack/ ; tar -czf ../../bin/PRG-AVR8.tar.gz PRG-AVR8/*

