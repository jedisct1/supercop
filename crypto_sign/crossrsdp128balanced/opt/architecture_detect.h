/**
 *
 * Reference ISO-C11 Implementation of CROSS.
 *
 * @version 2.0 (February 2025)
 *
 * Authors listed in alphabetical order:
 * 
 * @author: Alessandro Barenghi <alessandro.barenghi@polimi.it>
 * @author: Marco Gianvecchio <marco.gianvecchio@mail.polimi.it>
 * @author: Patrick Karl <patrick.karl@tum.de>
 * @author: Gerardo Pelosi <gerardo.pelosi@polimi.it>
 * @author: Jonas Schupp <jonas.schupp@tum.de>
 * 
 * 
 * This code is hereby placed in the public domain.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 **/
#include "crypto_sign.h"
#include "namespace.h"
#include "set.h"

#pragma once

/* Set of GCC/LLVM macros set by the -march=nocona and more recent CPUs */
/* these ISA extensions are present in all AMD64 architecture CPUS */
#if defined(__MMX__)    && defined(__SSE__)       && defined(__SSE_MATH__) && \
    defined(__SSE2__)   && defined(__SSE2_MATH__) && defined(__SSE3__)     && \
    defined(__SSE4_1__) && defined(__SSE4_2__)    && defined(__POPCNT__)   && \
    defined(__PCLMUL__) && defined(__AES__)       && defined(__AVX__)      && \
    defined(__amd64__)

#define HIGH_COMPATIBILITY_X86_64

#include <x86intrin.h>
#include <wmmintrin.h>
#include <immintrin.h>
#include <stdalign.h>

#endif

/* Set of GCC/LLVM macros set by the -march=haswell and more recent CPUs
 * these ISA extensions are present in all haswell and newer CPUs from Intel
 * with haswell being the target microarchitecture for NIST benchmarks    */
#if defined(HIGH_COMPATIBILITY_X86_64)            && \
    defined(__BMI__)  && defined(__BMI2__) && \
    defined(__AVX2__) && defined(__LZCNT__)

#define HIGH_PERFORMANCE_X86_64
#include <pmmintrin.h>
#endif

#define EPI8_PER_REG 32
#define EPI16_PER_REG 16
#define EPI32_PER_REG 8
