#ifndef QEMU_V8A_HAL_ENV_H
#define QEMU_V8A_HAL_ENV_H

#define SEP ;

#if defined(__APPLE__)
// Mach-O uses @PAGE/@PAGEOFF instead of the ELF :lo12: relocation syntax.
#define ASM_LOAD(dst,symbol) 	\
  adrp dst, symbol@PAGE ; add  dst, dst, symbol@PAGEOFF;
#else
#define ASM_LOAD(dst,symbol) 	\
  adrp dst, symbol ; add  dst, dst, :lo12:symbol;
#endif

#endif