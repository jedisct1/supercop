/*
The eXtended Keccak Code Package (XKCP)
https://github.com/XKCP/XKCP

Implementation by Gilles Van Assche and Ronny Van Keer, hereby denoted as "the implementer".

For more information, feedback or questions, please refer to the Keccak Team website:
https://keccak.team/

To the extent possible under law, the implementer has waived all copyright
and related or neighboring rights to the source code in this file.
http://creativecommons.org/publicdomain/zero/1.0/
*/

#ifndef _align_h_
#define _align_h_

/* on Mac OS-X and possibly others, ALIGN(x) is defined in param.h, and -Werror chokes on the redef. */
#ifdef ALIGN
#undef ALIGN
#endif

#if defined(__GNUC__)
#define ALIGN(x) __attribute__ ((aligned(x)))
#elif defined(_MSC_VER)
#define ALIGN(x) __declspec(align(x))
#elif defined(__ARMCC_VERSION)
#define ALIGN(x) __align(x)
#else
#define ALIGN(x)
#endif

/*
   False positive alignment issues with sanitizers on x86.
 
   The attribute appeared in GCC 8 and Clang 4. Anything older, and any
   compiler without __has_attribute at all (MSVC among them), falls back to the
   empty definition and compiles unchanged.

   Both branches are skipped when NO_SANITIZE_ALIGNMENT is already defined, so
   a -D on the command line wins instead of being redefined over: that is what
   lets a build force the empty form to re-expose the reports, or substitute a
   spelling this header does not know about. */
#ifndef NO_SANITIZE_ALIGNMENT
#if defined(__has_attribute)
#if __has_attribute(no_sanitize)
#define NO_SANITIZE_ALIGNMENT __attribute__((no_sanitize("alignment")))
#endif
#endif
#endif
#ifndef NO_SANITIZE_ALIGNMENT
#define NO_SANITIZE_ALIGNMENT
#endif

#endif
