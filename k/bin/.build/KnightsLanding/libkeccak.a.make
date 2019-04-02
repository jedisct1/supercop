all: KnightsLanding/libkeccak.a
KnightsLanding/libkeccak.a: bin/KnightsLanding/libkeccak.a
KnightsLanding/libkeccak.a.pack: bin/KnightsLanding_libkeccak.a.tar.gz

BINDIR = bin/.build/KnightsLanding/libkeccak.a
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

HEADERS := $(HEADERS) Constructions/KeccakSpongeWidth200.h
SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth200.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSpongeWidth400.h
SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth400.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSpongeWidth800.h
SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth800.h
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

HEADERS := $(HEADERS) Modes/SP800-185.inc
SOURCES := $(SOURCES) Modes/SP800-185.inc
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/SP800-185.h
SOURCES := $(SOURCES) Modes/SP800-185.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/Phases.h
SOURCES := $(SOURCES) Modes/Phases.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Constructions/KeccakDuplex-common.h
SOURCES := $(SOURCES) Constructions/KeccakDuplex-common.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplex.inc
SOURCES := $(SOURCES) Constructions/KeccakDuplex.inc
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplexWidth200.h
SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth200.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplexWidth400.h
SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth400.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplexWidth800.h
SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth800.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakDuplexWidth1600.h
SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth1600.h
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

HEADERS := $(HEADERS) Modes/KeccakPRGWidth400.h
SOURCES := $(SOURCES) Modes/KeccakPRGWidth400.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KeccakPRGWidth800.h
SOURCES := $(SOURCES) Modes/KeccakPRGWidth800.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KeccakPRGWidth1600.h
SOURCES := $(SOURCES) Modes/KeccakPRGWidth1600.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/KangarooTwelve.h
SOURCES := $(SOURCES) Modes/KangarooTwelve.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Modes/Phases.h
SOURCES := $(SOURCES) Modes/Phases.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Constructions/Kravatte.h
SOURCES := $(SOURCES) Constructions/Kravatte.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Modes/KravatteModes.h
SOURCES := $(SOURCES) Modes/KravatteModes.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) SnP/KeccakP-200/Reference/KeccakP-200-reference.h
SOURCES := $(SOURCES) SnP/KeccakP-200/Reference/KeccakP-200-reference.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-200/Reference/

HEADERS := $(HEADERS) SnP/KeccakP-200/Reference/KeccakP-200-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-200/Reference/KeccakP-200-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-200/Reference/

HEADERS := $(HEADERS) SnP/KeccakP-400/Reference/KeccakP-400-reference.h
SOURCES := $(SOURCES) SnP/KeccakP-400/Reference/KeccakP-400-reference.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-400/Reference/

HEADERS := $(HEADERS) SnP/KeccakP-400/Reference/KeccakP-400-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-400/Reference/KeccakP-400-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-400/Reference/

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

HEADERS := $(HEADERS) SnP/KeccakP-800/Optimized32/LCufull/KeccakP-800-opt32-config.h
SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/LCufull/KeccakP-800-opt32-config.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-800/Optimized32/LCufull/

HEADERS := $(HEADERS) SnP/KeccakP-1600/OptimizedAVX512/AVX512u12/KeccakP-1600-AVX512-config.h
SOURCES := $(SOURCES) SnP/KeccakP-1600/OptimizedAVX512/AVX512u12/KeccakP-1600-AVX512-config.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/OptimizedAVX512/AVX512u12/

HEADERS := $(HEADERS) SnP/KeccakP-1600/OptimizedAVX512/KeccakP-1600-SnP.h
SOURCES := $(SOURCES) SnP/KeccakP-1600/OptimizedAVX512/KeccakP-1600-SnP.h
CFLAGS := $(CFLAGS) -ISnP/KeccakP-1600/OptimizedAVX512/

HEADERS := $(HEADERS) PlSnP/KeccakP-800-times2/FallbackOn1/KeccakP-800-times2-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-800-times2/FallbackOn1/KeccakP-800-times2-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-800-times2/FallbackOn1/

HEADERS := $(HEADERS) PlSnP/Fallback/PlSnP-Fallback.inc
SOURCES := $(SOURCES) PlSnP/Fallback/PlSnP-Fallback.inc
CFLAGS := $(CFLAGS) -IPlSnP/Fallback/

HEADERS := $(HEADERS) PlSnP/KeccakP-800-times4/FallbackOn1/KeccakP-800-times4-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-800-times4/FallbackOn1/KeccakP-800-times4-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-800-times4/FallbackOn1/

HEADERS := $(HEADERS) PlSnP/Fallback/PlSnP-Fallback.inc
SOURCES := $(SOURCES) PlSnP/Fallback/PlSnP-Fallback.inc
CFLAGS := $(CFLAGS) -IPlSnP/Fallback/

HEADERS := $(HEADERS) PlSnP/KeccakP-800-times8/FallbackOn1/KeccakP-800-times8-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-800-times8/FallbackOn1/KeccakP-800-times8-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-800-times8/FallbackOn1/

HEADERS := $(HEADERS) PlSnP/Fallback/PlSnP-Fallback.inc
SOURCES := $(SOURCES) PlSnP/Fallback/PlSnP-Fallback.inc
CFLAGS := $(CFLAGS) -IPlSnP/Fallback/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times2/SIMD512/KeccakP-1600-times2-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times2/SIMD512/KeccakP-1600-times2-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times2/SIMD512/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times2/SIMD512/AVX512u12/SIMD512-2-config.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times2/SIMD512/AVX512u12/SIMD512-2-config.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times2/SIMD512/AVX512u12/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times4/SIMD512/KeccakP-1600-times4-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times4/SIMD512/KeccakP-1600-times4-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times4/SIMD512/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times4/SIMD512/AVX512u12/SIMD512-4-config.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times4/SIMD512/AVX512u12/SIMD512-4-config.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times4/SIMD512/AVX512u12/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times8/SIMD512/KeccakP-1600-times8-SnP.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times8/SIMD512/KeccakP-1600-times8-SnP.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times8/SIMD512/

HEADERS := $(HEADERS) PlSnP/KeccakP-1600-times8/SIMD512/AVX512u12/SIMD512-config.h
SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times8/SIMD512/AVX512u12/SIMD512-config.h
CFLAGS := $(CFLAGS) -IPlSnP/KeccakP-1600-times8/SIMD512/AVX512u12/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/Ket.inc
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/Ket.inc
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/Ket-common.h
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/Ket-common.h
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/KetJr.h
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetJr.h
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/KetSr.h
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetSr.h
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/KetMn.h
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetMn.h
CFLAGS := $(CFLAGS) -IKetje/Ket/SnP-compliant/

HEADERS := $(HEADERS) Ketje/Ket/SnP-compliant/KetMj.h
SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetMj.h
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

HEADERS := $(HEADERS) Ketje/KetjeSr.h
SOURCES := $(SOURCES) Ketje/KetjeSr.h
CFLAGS := $(CFLAGS) -IKetje/

HEADERS := $(HEADERS) Ketje/KetjeMn.h
SOURCES := $(SOURCES) Ketje/KetjeMn.h
CFLAGS := $(CFLAGS) -IKetje/

HEADERS := $(HEADERS) Ketje/KetjeMj.h
SOURCES := $(SOURCES) Ketje/KetjeMj.h
CFLAGS := $(CFLAGS) -IKetje/

HEADERS := $(HEADERS) Ketje/Ketjev2.h
SOURCES := $(SOURCES) Ketje/Ketjev2.h
CFLAGS := $(CFLAGS) -IKetje/

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

HEADERS := $(HEADERS) Keyak/LakeKeyak.h
SOURCES := $(SOURCES) Keyak/LakeKeyak.h
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Keyak/SeaKeyak.h
SOURCES := $(SOURCES) Keyak/SeaKeyak.h
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Keyak/OceanKeyak.h
SOURCES := $(SOURCES) Keyak/OceanKeyak.h
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Keyak/LunarKeyak.h
SOURCES := $(SOURCES) Keyak/LunarKeyak.h
CFLAGS := $(CFLAGS) -IKeyak/

HEADERS := $(HEADERS) Common/align.h
SOURCES := $(SOURCES) Common/align.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth200.c
$(BINDIR)/KeccakSpongeWidth200.o: Constructions/KeccakSpongeWidth200.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakSpongeWidth200.o

SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth400.c
$(BINDIR)/KeccakSpongeWidth400.o: Constructions/KeccakSpongeWidth400.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakSpongeWidth400.o

SOURCES := $(SOURCES) Constructions/KeccakSpongeWidth800.c
$(BINDIR)/KeccakSpongeWidth800.o: Constructions/KeccakSpongeWidth800.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakSpongeWidth800.o

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

SOURCES := $(SOURCES) Modes/SP800-185.c
$(BINDIR)/SP800-185.o: Modes/SP800-185.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/SP800-185.o

SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth200.c
$(BINDIR)/KeccakDuplexWidth200.o: Constructions/KeccakDuplexWidth200.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplexWidth200.o

SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth400.c
$(BINDIR)/KeccakDuplexWidth400.o: Constructions/KeccakDuplexWidth400.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplexWidth400.o

SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth800.c
$(BINDIR)/KeccakDuplexWidth800.o: Constructions/KeccakDuplexWidth800.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplexWidth800.o

SOURCES := $(SOURCES) Constructions/KeccakDuplexWidth1600.c
$(BINDIR)/KeccakDuplexWidth1600.o: Constructions/KeccakDuplexWidth1600.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplexWidth1600.o

SOURCES := $(SOURCES) Modes/KeccakPRGWidth200.c
$(BINDIR)/KeccakPRGWidth200.o: Modes/KeccakPRGWidth200.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakPRGWidth200.o

SOURCES := $(SOURCES) Modes/KeccakPRGWidth400.c
$(BINDIR)/KeccakPRGWidth400.o: Modes/KeccakPRGWidth400.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakPRGWidth400.o

SOURCES := $(SOURCES) Modes/KeccakPRGWidth800.c
$(BINDIR)/KeccakPRGWidth800.o: Modes/KeccakPRGWidth800.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakPRGWidth800.o

SOURCES := $(SOURCES) Modes/KeccakPRGWidth1600.c
$(BINDIR)/KeccakPRGWidth1600.o: Modes/KeccakPRGWidth1600.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakPRGWidth1600.o

SOURCES := $(SOURCES) Modes/KangarooTwelve.c
$(BINDIR)/KangarooTwelve.o: Modes/KangarooTwelve.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KangarooTwelve.o

SOURCES := $(SOURCES) Constructions/Kravatte.c
$(BINDIR)/Kravatte.o: Constructions/Kravatte.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/Kravatte.o

SOURCES := $(SOURCES) Modes/KravatteModes.c
$(BINDIR)/KravatteModes.o: Modes/KravatteModes.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KravatteModes.o

SOURCES := $(SOURCES) SnP/KeccakP-200/Reference/KeccakP-200-reference.c
$(BINDIR)/KeccakP-200-reference.o: SnP/KeccakP-200/Reference/KeccakP-200-reference.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-200-reference.o

SOURCES := $(SOURCES) SnP/KeccakP-400/Reference/KeccakP-400-reference.c
$(BINDIR)/KeccakP-400-reference.o: SnP/KeccakP-400/Reference/KeccakP-400-reference.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-400-reference.o

SOURCES := $(SOURCES) SnP/KeccakP-800/Optimized32/KeccakP-800-opt32.c
$(BINDIR)/KeccakP-800-opt32.o: SnP/KeccakP-800/Optimized32/KeccakP-800-opt32.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-800-opt32.o

SOURCES := $(SOURCES) SnP/KeccakP-1600/OptimizedAVX512/KeccakP-1600-AVX512.c
$(BINDIR)/KeccakP-1600-AVX512.o: SnP/KeccakP-1600/OptimizedAVX512/KeccakP-1600-AVX512.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-AVX512.o

SOURCES := $(SOURCES) PlSnP/KeccakP-800-times2/FallbackOn1/KeccakP-800-times2-on1.c
$(BINDIR)/KeccakP-800-times2-on1.o: PlSnP/KeccakP-800-times2/FallbackOn1/KeccakP-800-times2-on1.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-800-times2-on1.o

SOURCES := $(SOURCES) PlSnP/KeccakP-800-times4/FallbackOn1/KeccakP-800-times4-on1.c
$(BINDIR)/KeccakP-800-times4-on1.o: PlSnP/KeccakP-800-times4/FallbackOn1/KeccakP-800-times4-on1.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-800-times4-on1.o

SOURCES := $(SOURCES) PlSnP/KeccakP-800-times8/FallbackOn1/KeccakP-800-times8-on1.c
$(BINDIR)/KeccakP-800-times8-on1.o: PlSnP/KeccakP-800-times8/FallbackOn1/KeccakP-800-times8-on1.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-800-times8-on1.o

SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times2/SIMD512/KeccakP-1600-times2-SIMD512.c
$(BINDIR)/KeccakP-1600-times2-SIMD512.o: PlSnP/KeccakP-1600-times2/SIMD512/KeccakP-1600-times2-SIMD512.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-times2-SIMD512.o

SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times4/SIMD512/KeccakP-1600-times4-SIMD512.c
$(BINDIR)/KeccakP-1600-times4-SIMD512.o: PlSnP/KeccakP-1600-times4/SIMD512/KeccakP-1600-times4-SIMD512.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-times4-SIMD512.o

SOURCES := $(SOURCES) PlSnP/KeccakP-1600-times8/SIMD512/KeccakP-1600-times8-SIMD512.c
$(BINDIR)/KeccakP-1600-times8-SIMD512.o: PlSnP/KeccakP-1600-times8/SIMD512/KeccakP-1600-times8-SIMD512.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakP-1600-times8-SIMD512.o

SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetJr.c
$(BINDIR)/KetJr.o: Ketje/Ket/SnP-compliant/KetJr.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetJr.o

SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetSr.c
$(BINDIR)/KetSr.o: Ketje/Ket/SnP-compliant/KetSr.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetSr.o

SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetMn.c
$(BINDIR)/KetMn.o: Ketje/Ket/SnP-compliant/KetMn.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetMn.o

SOURCES := $(SOURCES) Ketje/Ket/SnP-compliant/KetMj.c
$(BINDIR)/KetMj.o: Ketje/Ket/SnP-compliant/KetMj.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetMj.o

SOURCES := $(SOURCES) Ketje/KetjeJr.c
$(BINDIR)/KetjeJr.o: Ketje/KetjeJr.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetjeJr.o

SOURCES := $(SOURCES) Ketje/KetjeSr.c
$(BINDIR)/KetjeSr.o: Ketje/KetjeSr.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetjeSr.o

SOURCES := $(SOURCES) Ketje/KetjeMn.c
$(BINDIR)/KetjeMn.o: Ketje/KetjeMn.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetjeMn.o

SOURCES := $(SOURCES) Ketje/KetjeMj.c
$(BINDIR)/KetjeMj.o: Ketje/KetjeMj.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KetjeMj.o

SOURCES := $(SOURCES) Keyak/RiverKeyak.c
$(BINDIR)/RiverKeyak.o: Keyak/RiverKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/RiverKeyak.o

SOURCES := $(SOURCES) Keyak/LakeKeyak.c
$(BINDIR)/LakeKeyak.o: Keyak/LakeKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/LakeKeyak.o

SOURCES := $(SOURCES) Keyak/SeaKeyak.c
$(BINDIR)/SeaKeyak.o: Keyak/SeaKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/SeaKeyak.o

SOURCES := $(SOURCES) Keyak/OceanKeyak.c
$(BINDIR)/OceanKeyak.o: Keyak/OceanKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/OceanKeyak.o

SOURCES := $(SOURCES) Keyak/LunarKeyak.c
$(BINDIR)/LunarKeyak.o: Keyak/LunarKeyak.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/LunarKeyak.o

bin/KnightsLanding/libkeccak.a: $(BINDIR) $(OBJECTS)
	mkdir -p $(dir $@)
	mkdir -p $@.headers
	cp -f $(HEADERS) $@.headers/
	$(AR) rcsv $@ $(OBJECTS)
bin/KnightsLanding_libkeccak.a.tar.gz: $(SOURCES)
	mkdir -p bin/.pack/KnightsLanding/libkeccak.a
	rm -rf bin/.pack/KnightsLanding/libkeccak.a/*
	cp $(SOURCES) bin/.pack/KnightsLanding/libkeccak.a/
	cd bin/.pack/ ; tar -czf ../../bin/KnightsLanding_libkeccak.a.tar.gz KnightsLanding/libkeccak.a/*

