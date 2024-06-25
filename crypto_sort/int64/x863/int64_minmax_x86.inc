#define int64_MINMAX(a,b) \
do { \
  int64 temp1; \
  asm( \
    "cmpq %1,%0\n\t" \
    "mov %0,%2\n\t" \
    "cmovg %1,%0\n\t" \
    "cmovg %2,%1\n\t" \
    : "+r"(a), "+r"(b), "=r"(temp1) \
    : \
    : "cc" \
  ); \
} while(0)
