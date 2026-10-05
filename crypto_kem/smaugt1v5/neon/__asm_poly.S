
/*
 * We offer
 * CC0 1.0 Universal or the following MIT License for this file.
 * You may freely choose one of them that applies.
 *
 * MIT License
 *
 * Copyright (c) 2024: Vincent Hwang
 * Copyright (c) 2023: Vincent Hwang
 * Copyright (c) 2023: Hanno Becker, Vincent Hwang, Matthias J. Kannwischer, Bo-Yin Yang, and Shang-Yi Yang
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "macros.i"
//#include "params.h"


.align 2
.global DILITHIUM_AARCH64__asm_poly_pointwise_montgomery
.global _DILITHIUM_AARCH64__asm_poly_pointwise_montgomery
DILITHIUM_AARCH64__asm_poly_pointwise_montgomery:
_DILITHIUM_AARCH64__asm_poly_pointwise_montgomery:

    push_all

    ldr w20, [x3, #0]
    ldr w21, [x3, #4]

    dup v30.4S, w20
    dup v31.4S, w21

    ld1 { v0.4S}, [x1], #16
    ld1 { v1.4S}, [x1], #16
    ld1 { v2.4S}, [x1], #16
    ld1 { v3.4S}, [x1], #16
    ld1 { v4.4S}, [x2], #16
    ld1 { v5.4S}, [x2], #16
    ld1 { v6.4S}, [x2], #16
    ld1 { v7.4S}, [x2], #16

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S

    uzp1   v20.4S, v12.4S, v16.4S
    uzp1   v21.4S, v13.4S, v17.4S
    uzp1   v22.4S, v14.4S, v18.4S
    uzp1   v23.4S, v15.4S, v19.4S

    mul    v24.4S, v20.4S, v31.4S
    mul    v25.4S, v21.4S, v31.4S
    mul    v26.4S, v22.4S, v31.4S
    mul    v27.4S, v23.4S, v31.4S

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    mov x16, #15
    _poly_pointwise_montgomery_loop:

    st1 {v24.4S}, [x0], #16
    ld1 { v0.4S}, [x1], #16
    st1 {v25.4S}, [x0], #16
    ld1 { v1.4S}, [x1], #16
    st1 {v26.4S}, [x0], #16
    ld1 { v2.4S}, [x1], #16
    st1 {v27.4S}, [x0], #16
    ld1 { v3.4S}, [x1], #16

    ld1 { v4.4S}, [x2], #16
    ld1 { v5.4S}, [x2], #16
    ld1 { v6.4S}, [x2], #16
    ld1 { v7.4S}, [x2], #16

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S

    uzp1   v20.4S, v12.4S, v16.4S
    uzp1   v21.4S, v13.4S, v17.4S
    uzp1   v22.4S, v14.4S, v18.4S
    uzp1   v23.4S, v15.4S, v19.4S

    mul    v24.4S, v20.4S, v31.4S
    mul    v25.4S, v21.4S, v31.4S
    mul    v26.4S, v22.4S, v31.4S
    mul    v27.4S, v23.4S, v31.4S

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    sub x16, x16, #1
    cbnz x16, _poly_pointwise_montgomery_loop

    st1 {v24.4S}, [x0], #16
    st1 {v25.4S}, [x0], #16
    st1 {v26.4S}, [x0], #16
    st1 {v27.4S}, [x0], #16

    pop_all

    ret


.align 2
.global DILITHIUM_AARCH64__asm_polyvecl_pointwise_acc_montgomery
.global _DILITHIUM_AARCH64__asm_polyvecl_pointwise_acc_montgomery
DILITHIUM_AARCH64__asm_polyvecl_pointwise_acc_montgomery:
_DILITHIUM_AARCH64__asm_polyvecl_pointwise_acc_montgomery:

    push_all

    ldr w20, [x3, #0]          // q
    ldr w21, [x3, #4]          // qinv

    add  x5,  x1, #512*1      // a[1]
    add  x6,  x2, #512*1      // b[1]

    dup v30.4S, w20
    dup v31.4S, w21

    // ---- prologue: smull a[0]*b[0], smlal a[1]*b[1] ----
    ld1 { v0.4S}, [x1], #16
    ld1 { v1.4S}, [x1], #16
    ld1 { v2.4S}, [x1], #16
    ld1 { v3.4S}, [x1], #16
    ld1 { v4.4S}, [x2], #16
    ld1 { v5.4S}, [x2], #16
    ld1 { v6.4S}, [x2], #16
    ld1 { v7.4S}, [x2], #16

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x5], #16
    ld1 { v4.4S}, [ x6], #16
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x5], #16
    ld1 { v5.4S}, [ x6], #16
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x5], #16
    ld1 { v6.4S}, [ x6], #16
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x5], #16
    ld1 { v7.4S}, [ x6], #16


    mov x16, #15
    _polyvecl_pointwise_acc_montgomery_loop_k2:

    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S

    // ---- Montgomery reduction ----
    uzp1   v20.4S, v12.4S, v16.4S
    ld1 { v0.4S}, [x1], #16
    uzp1   v21.4S, v13.4S, v17.4S
    ld1 { v1.4S}, [x1], #16
    uzp1   v22.4S, v14.4S, v18.4S
    ld1 { v2.4S}, [x1], #16
    uzp1   v23.4S, v15.4S, v19.4S
    ld1 { v3.4S}, [x1], #16

    mul    v24.4S, v20.4S, v31.4S
    ld1 { v4.4S}, [x2], #16
    mul    v25.4S, v21.4S, v31.4S
    ld1 { v5.4S}, [x2], #16
    mul    v26.4S, v22.4S, v31.4S
    ld1 { v6.4S}, [x2], #16
    mul    v27.4S, v23.4S, v31.4S
    ld1 { v7.4S}, [x2], #16

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    smull  v12.2D,  v0.2S,  v4.2S
    smull2 v16.2D,  v0.4S,  v4.4S
    ld1 { v0.4S}, [ x5], #16
    st1 {v24.4S}, [x0], #16
    ld1 { v4.4S}, [ x6], #16
    smull  v13.2D,  v1.2S,  v5.2S
    smull2 v17.2D,  v1.4S,  v5.4S
    ld1 { v1.4S}, [ x5], #16
    st1 {v25.4S}, [x0], #16
    ld1 { v5.4S}, [ x6], #16
    smull  v14.2D,  v2.2S,  v6.2S
    smull2 v18.2D,  v2.4S,  v6.4S
    ld1 { v2.4S}, [ x5], #16
    st1 {v26.4S}, [x0], #16
    ld1 { v6.4S}, [ x6], #16
    smull  v15.2D,  v3.2S,  v7.2S
    smull2 v19.2D,  v3.4S,  v7.4S
    ld1 { v3.4S}, [ x5], #16
    st1 {v27.4S}, [x0], #16
    ld1 { v7.4S}, [ x6], #16


    sub x16, x16, #1
    cbnz x16, _polyvecl_pointwise_acc_montgomery_loop_k2

    // ---- epilogue: 最後一批 smlal + Montgomery reduction ----
    smlal  v12.2D,  v0.2S,  v4.2S
    smlal2 v16.2D,  v0.4S,  v4.4S
    smlal  v13.2D,  v1.2S,  v5.2S
    smlal2 v17.2D,  v1.4S,  v5.4S
    smlal  v14.2D,  v2.2S,  v6.2S
    smlal2 v18.2D,  v2.4S,  v6.4S
    smlal  v15.2D,  v3.2S,  v7.2S
    smlal2 v19.2D,  v3.4S,  v7.4S

    uzp1   v20.4S, v12.4S, v16.4S
    uzp1   v21.4S, v13.4S, v17.4S
    uzp1   v22.4S, v14.4S, v18.4S
    uzp1   v23.4S, v15.4S, v19.4S

    mul    v24.4S, v20.4S, v31.4S
    mul    v25.4S, v21.4S, v31.4S
    mul    v26.4S, v22.4S, v31.4S
    mul    v27.4S, v23.4S, v31.4S

    smlal  v12.2D, v24.2S, v30.2S
    smlal2 v16.2D, v24.4S, v30.4S
    smlal  v13.2D, v25.2S, v30.2S
    smlal2 v17.2D, v25.4S, v30.4S
    smlal  v14.2D, v26.2S, v30.2S
    smlal2 v18.2D, v26.4S, v30.4S
    smlal  v15.2D, v27.2S, v30.2S
    smlal2 v19.2D, v27.4S, v30.4S

    uzp2   v24.4S, v12.4S, v16.4S
    uzp2   v25.4S, v13.4S, v17.4S
    uzp2   v26.4S, v14.4S, v18.4S
    uzp2   v27.4S, v15.4S, v19.4S

    st1 {v24.4S}, [x0], #16
    st1 {v25.4S}, [x0], #16
    st1 {v26.4S}, [x0], #16
    st1 {v27.4S}, [x0], #16

    pop_all

    ret


.align 2
.global DILITHIUM_AARCH64__asm_poly_reduce
.global _DILITHIUM_AARCH64__asm_poly_reduce
DILITHIUM_AARCH64__asm_poly_reduce:
_DILITHIUM_AARCH64__asm_poly_reduce:

    ldr w4, [x1]

    dup v24.4S, w4

    add x1, x0, #0

    ld1 { v0.4S}, [x1], #16
    ld1 { v1.4S}, [x1], #16
    ld1 { v2.4S}, [x1], #16
    ld1 { v3.4S}, [x1], #16

    ld1 { v4.4S}, [x1], #16
    srshr  v16.4S, v0.4S, #23
    ld1 { v5.4S}, [x1], #16
    srshr  v17.4S, v1.4S, #23
    ld1 { v6.4S}, [x1], #16
    srshr  v18.4S, v2.4S, #23
    ld1 { v7.4S}, [x1], #16
    srshr  v19.4S, v3.4S, #23

    srshr  v20.4S, v4.4S, #23
    mls     v0.4S, v16.4S, v24.4S
    srshr  v21.4S, v5.4S, #23
    mls     v1.4S, v17.4S, v24.4S
    srshr  v22.4S, v6.4S, #23
    mls     v2.4S, v18.4S, v24.4S
    srshr  v23.4S, v7.4S, #23
    mls     v3.4S, v19.4S, v24.4S

    mls     v4.4S, v20.4S, v24.4S
    st1 { v0.4S}, [x0], #16
    mls     v5.4S, v21.4S, v24.4S
    st1 { v1.4S}, [x0], #16
    mls     v6.4S, v22.4S, v24.4S
    st1 { v2.4S}, [x0], #16
    mls     v7.4S, v23.4S, v24.4S
    st1 { v3.4S}, [x0], #16

    mov x16, #7
    _poly_reduce_loop:

    st1 { v4.4S}, [x0], #16
    ld1 { v0.4S}, [x1], #16
    st1 { v5.4S}, [x0], #16
    ld1 { v1.4S}, [x1], #16
    st1 { v6.4S}, [x0], #16
    ld1 { v2.4S}, [x1], #16
    st1 { v7.4S}, [x0], #16
    ld1 { v3.4S}, [x1], #16

    ld1 { v4.4S}, [x1], #16
    srshr  v16.4S, v0.4S, #23
    ld1 { v5.4S}, [x1], #16
    srshr  v17.4S, v1.4S, #23
    ld1 { v6.4S}, [x1], #16
    srshr  v18.4S, v2.4S, #23
    ld1 { v7.4S}, [x1], #16
    srshr  v19.4S, v3.4S, #23

    srshr  v20.4S, v4.4S, #23
    mls     v0.4S, v16.4S, v24.4S
    srshr  v21.4S, v5.4S, #23
    mls     v1.4S, v17.4S, v24.4S
    srshr  v22.4S, v6.4S, #23
    mls     v2.4S, v18.4S, v24.4S
    srshr  v23.4S, v7.4S, #23
    mls     v3.4S, v19.4S, v24.4S

    mls     v4.4S, v20.4S, v24.4S
    st1 { v0.4S}, [x0], #16
    mls     v5.4S, v21.4S, v24.4S
    st1 { v1.4S}, [x0], #16
    mls     v6.4S, v22.4S, v24.4S
    st1 { v2.4S}, [x0], #16
    mls     v7.4S, v23.4S, v24.4S
    st1 { v3.4S}, [x0], #16

    sub x16, x16, #1
    cbnz x16, _poly_reduce_loop

    st1 { v4.4S}, [x0], #16
    st1 { v5.4S}, [x0], #16
    st1 { v6.4S}, [x0], #16
    st1 { v7.4S}, [x0], #16

    ret


