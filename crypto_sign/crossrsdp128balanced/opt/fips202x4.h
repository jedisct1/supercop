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
 *
 * Implementation of Keccak-p[1600] in parallel (x4) mode
 * with the API: init -> absorb* -> finalize -> squeeze*
 * where the absorb and squeeze phases can be executed multiple times.
 * 
 * The basis for this implemntation is the AVX2 optimized parallel Keccak in:
 * XKCP/lib/low/KeccakP-1600-times4/AVX2
 * which uses the API: InitializeAll -> AddBytes -> PermuteAll_24rounds -> ExtractBytes
 * 
 * Documentation and source files:
 * https://github.com/rtjk/keccak-parallel-incremental
 * 
 */
#include "crypto_sign.h"
#include "namespace.h"
#include "set.h"

#include "KeccakP-1600-times4-SnP.h"

/************************************************
 *  Macros
 ***********************************************/

/* SHAKE Rates (in bytes) */
#define SHAKE128_RATE (168)
#define SHAKE256_RATE (136)

/* CROSS category 1 uses SHAKE128 */
#if defined(CATEGORY_1)
    #define RATE SHAKE128_RATE
#else
    #define RATE SHAKE256_RATE
#endif

/* SHAKE Domain Separator */
#define DS (0x1F)

#define WORD (64)
#define MAX_LANES (RATE / (WORD / 8))

/************************************************
 *  Function Prototypes
 ***********************************************/

typedef struct {
    KeccakP1600times4_SIMD256_states state;
    /* - during absrbtion: "offset" is the number of absorbed bytes that have already been xored into the state but have not been permuted yet
     * - during squeezing: "offset" is the number of not-yet-squeezed bytes */
    uint64_t offset;
} par_keccak_context;

void keccak_x4_init(par_keccak_context *ctx);
void keccak_x4_absorb(
    par_keccak_context *ctx, 
    const unsigned char *in1, 
    const unsigned char *in2, 
    const unsigned char *in3, 
    const unsigned char *in4, 
    unsigned int in_len);
void keccak_x4_finalize(par_keccak_context *ctx);
void keccak_x4_squeeze(
    par_keccak_context *ctx, 
    unsigned char *out1, 
    unsigned char *out2, 
    unsigned char *out3, 
    unsigned char *out4, 
    unsigned int out_len);
