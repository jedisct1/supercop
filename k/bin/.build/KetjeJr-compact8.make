all: KetjeJr-compact8
KetjeJr-compact8: bin/KetjeJr-compact8
KetjeJr-compact8.pack: bin/KetjeJr-compact8.tar.gz

BINDIR = bin/.build/KetjeJr-compact8
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

HEADERS := $(HEADERS) SnP/KeccakP-200/Compact/KeccakP-200-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-200/Compact/KeccakP-200-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-200/Compact/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/Ket.inc
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/Ket.inc
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/Ket-common.h
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/Ket-common.h
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/KetJr.h
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetJr.h
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ketje-common.h
SOURCES := $(SOURCES) Ketje/Ketje-common.h
CFLAGS := $(CFLAGS) -IKetje/

HEADERS := $(HEADERS) Ketje/Ketjev2.inc
SOURCES := $(SOURCES) Ketje/Ketjev2.inc
CFLAGS := $(CFLAGS) -IKetje/

HEADERS := $(HEADERS) Ketje/KetjeJr.h
SOURCES := $(SOURCES) Ketje/KetjeJr.h
CFLAGS := $(CFLAGS) -IKetje/

HEADERS := $(HEADERS) Common/align.h
SOURCES := $(SOURCES) Common/align.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

SOURCES := $(SOURCES) SnP/KeccakP-200/Compact/KeccakP-200-compact.c
$(BINDIR)/KeccakP-200-compact.o: SnP/KeccakP-200/Compact/KeccakP-200-compact.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-200-compact.o

SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetJr.c
$(BINDIR)/KetJr.o: Ketje/Ket/SnP-compliant/KetJr.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetJr.o

SOURCES := $(SOURCES) Ketje/KetjeJr.c
$(BINDIR)/KetjeJr.o: Ketje/KetjeJr.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetjeJr.o

bin/KetjeJr-compact8: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	$(CC) -o $@ $(OBJECTS) $(CFLAGS)
bin/KetjeJr-compact8.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/KetjeJr-compact8
	rm -rf bin/.pack/KetjeJr-compact8/*
	cp $(SOURCES) bin/.pack/KetjeJr-compact8/
	cd bin/.pack/ ; tar -czf ../../bin/KetjeJr-compact8.tar.gz KetjeJr-compact8/*

