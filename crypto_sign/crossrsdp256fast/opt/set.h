
#define RSDP 1
#define CATEGORY_5 1
#define SPEED 1

/* skip asserts so that verify() always returns a value */
#define SKIP_ASSERT

#if defined(SPEED)
#define NO_TREES 1
#else
#undef NO_TREES
#endif

