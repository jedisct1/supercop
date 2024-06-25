#ifndef crypto_asm_hidden_h
#define crypto_asm_hidden_h

#ifdef __APPLE__
#define ASM_HIDDEN .private_extern
#else
#define ASM_HIDDEN .hidden
#endif

#endif
