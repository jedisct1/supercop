;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sparkle384f_v7m.asm: Speed-optimized ARMv7-M implementation of SPARKLE384 ;;
;; This file is part of the SPARKLE submission to NIST's LW Crypto Project.  ;;
;; Version 1.1.2 (2020-10-30), see <http://www.cryptolux.org/> for updates.  ;;
;; Authors: The SPARKLE Group (C. Beierle, A. Biryukov, L. Cardoso dos       ;;
;; Santos, J. Groszschaedl, L. Perrin, A. Udovenko, V. Velichkov, Q. Wang).  ;;
;; License: GPLv3 (see LICENSE file), other licenses available upon request. ;;
;; Copyright (C) 2019-2020 University of Luxembourg <http://www.uni.lu/>.    ;;
;; ------------------------------------------------------------------------- ;;
;; This program is free software: you can redistribute it and/or modify it   ;;
;; under the terms of the GNU General Public License as published by the     ;;
;; Free Software Foundation, either version 3 of the License, or (at your    ;;
;; option) any later version. This program is distributed in the hope that   ;;
;; it will be useful, but WITHOUT ANY WARRANTY; without even the implied     ;;
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the  ;;
;; GNU General Public License for more details. You should have received a   ;;
;; copy of the GNU General Public License along with this program. If not,   ;;
;; see <http://www.gnu.org/licenses/>.                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    THUMB
    PRESERVE8
    
    
    AREA sparkle_code, CODE, READONLY, ALIGN=2
    
    
    EXPORT sparkle384_arm [CODE]
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; REGISTER NAMES AND CONSTANTS ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
;; register sptr holds the start address of array 'state'
sptr RN r0
;; register step holds the number of steps (parameter 'steps')
step RN r1
;; registers c0w to c7w hold round constants from array 'rcon'
c0w RN r0
c1w RN r1
c2w RN r1
c3w RN r1
c4w RN r1
c5w RN r1
c6w RN r1
c7w RN r1
;; registers tmpx, tmpy hold temporary values
tmpx RN r1
tmpy RN r1
;; registers x0w to y5w hold 12 words from array 'state'
x0w RN r2
y0w RN r3
x1w RN r4
y1w RN r5
x2w RN r6
y2w RN r7
x3w RN r8
y3w RN r9
x4w RN r10
y4w RN r11
x5w RN r12
y5w RN lr
    
;; Round constants
rc0 EQU 0xB7E15162
rc1 EQU 0xBF715880
rc2 EQU 0x38B4DA56
rc3 EQU 0x324E7738
rc4 EQU 0xBB1185EB
rc5 EQU 0x4F7C7B57
rc6 EQU 0xCFBFA1C8
rc7 EQU 0xC2B3293D
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;; MACROS FOR SPARKLE384 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PROLOGUE_384
    push    {r4-r12,lr}
    ldmia   sptr, {x0w-x5w,y5w}
    push.w  {sptr,step}
    MEND
    
    MACRO
    EPILOGUE_384
    pop.w   {sptr}
    stmia.w sptr!, {x3w-x5w,y5w}
    stmia.w sptr!, {x2w,y2w}
    stmia.w sptr!, {x0w-y1w}
    pop     {r4-r12,pc}
    MEND
    
    MACRO
    RET_SLIM_384
    pop     {sptr,step}
    cmp     step, #7
    bgt.w   big_384
    stmia.w sptr!, {x4w-x5w,y5w}
    stmia.w sptr!, {x3w,y3w}
    stmia.w sptr!, {x0w-y2w}
    pop     {r4-r12,pc}
big_384
    push.w  {sptr}
    MEND
    
    MACRO
    ARX_BOX $xi, $yi, $ci
    add     $xi, $xi, $yi, ror #31
    eor     $yi, $yi, $xi, ror #24
    eor     $xi, $xi, $ci
    add     $xi, $xi, $yi, ror #17
    eor     $yi, $yi, $xi, ror #17
    eors    $xi, $xi, $ci
    adds    $xi, $xi, $yi
    eor     $yi, $yi, $xi, ror #31
    eor     $xi, $xi, $ci
    add     $xi, $xi, $yi, ror #24
    eor     $yi, $yi, $xi, ror #16
    eor     $xi, $xi, $ci
    MEND
    
    MACRO
    LL_TMPX $xi, $xj, $xk
    eor     tmpx, $xi, $xj
    eor     tmpx, tmpx, $xk
    eor     tmpx, tmpx, tmpx, lsl #16
    MEND
    
    MACRO
    LL_TMPY $yi, $yj, $yk
    eor     tmpy, $yi, $yj
    eor     tmpy, tmpy, $yk
    eor     tmpy, tmpy, tmpy, lsl #16
    MEND
    
    MACRO
    LL_ADDX $xi, $xj
    eor     $xi, $xi, tmpy, ror #16
    eor     $xi, $xi, $xj
    MEND
    
    MACRO
    LL_ADDY $yi, $yj
    eor     $yi, $yi, tmpx, ror #16
    eor     $yi, $yi, $yj
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 0 OF SPARKLE384 (USING ROUND-CONSTANT RC0) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_00_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC0
    mov32   c0w, rc0
    eor     $y0, $y0, c0w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 1 OF SPARKLE384 (USING ROUND-CONSTANT RC1) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_01_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC1
    eor     $y1, $y1, #1
    mov32   c1w, rc1
    eor     $y0, $y0, c1w
    ;; ARXBOX Layer
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x0, $y0, c0w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 2 OF SPARKLE384 (USING ROUND-CONSTANT RC2) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_02_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC2
    eor     $y1, $y1, #2
    mov32   c2w, rc2
    eor     $y0, $y0, c2w
    ;; ARXBOX Layer
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 3 OF SPARKLE384 (USING ROUND-CONSTANT RC3) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_03_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC3
    eor     $y1, $y1, #3
    mov32   c3w, rc3
    eor     $y0, $y0, c3w
    ;; ARXBOX Layer
    ARX_BOX $x3, $y3, c3w
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 4 OF SPARKLE384 (USING ROUND-CONSTANT RC4) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_04_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC4
    eor     $y1, $y1, #4
    mov32   c4w, rc4
    eor     $y0, $y0, c4w
    ;; ARXBOX Layer
    ARX_BOX $x4, $y4, c4w
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 5 OF SPARKLE384 (USING ROUND-CONSTANT RC5) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_05_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC5
    eor     $y1, $y1, #5
    mov32   c5w, rc5
    eor     $y0, $y0, c5w
    ;; ARXBOX Layer
    ARX_BOX $x5, $y5, c5w
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 6 OF SPARKLE384 (USING ROUND-CONSTANT RC6) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_06_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC6
    eor     $y1, $y1, #6
    mov32   c6w, rc6
    eor     $y0, $y0, c6w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 7 OF SPARKLE384 (USING ROUND-CONSTANT RC7) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_07_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC7
    eor     $y1, $y1, #7
    mov32   c7w, rc7
    eor     $y0, $y0, c7w
    ;; ARXBOX Layer
    mov32   c0w, rc0    
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 8 OF SPARKLE384 (USING ROUND-CONSTANT RC0) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_08_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC0
    eor     $y1, $y1, #8
    eor     $y0, $y0, c0w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 9 OF SPARKLE384 (USING ROUND-CONSTANT RC1) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_09_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC1
    eor     $y1, $y1, #9
    mov32   c1w, rc1
    eor     $y0, $y0, c1w
    ;; ARXBOX Layer
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x0, $y0, c0w
    mov32   c2w, rc2
    ARX_BOX $x2, $y2, c2w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 10 OF SPARKLE384 (USING ROUND-CONSTANT RC2) ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_10_384 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $x5, $y5
    ;; Addition RC2
    eor     $y1, $y1, #10
    mov32   c2w, rc2
    eor     $y0, $y0, c2w
    ;; ARXBOX Layer
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x0, $y0, c0w
    mov32   c1w, rc1
    ARX_BOX $x1, $y1, c1w
    mov32   c3w, rc3
    ARX_BOX $x3, $y3, c3w
    mov32   c4w, rc4
    ARX_BOX $x4, $y4, c4w
    mov32   c5w, rc5
    ARX_BOX $x5, $y5, c5w
    ;; Linear Layer
    LL_TMPX $x0, $x1, $x2
    LL_ADDY $y3, $y0
    LL_ADDY $y4, $y1
    LL_ADDY $y5, $y2
    LL_TMPY $y0, $y1, $y2
    LL_ADDX $x3, $x0
    LL_ADDX $x4, $x1
    LL_ADDX $x5, $x2
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; SPARKLE384 PERMUTATION (FULLY UNROLLED) ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
;; Function prototype:
;; -------------------
;; void sparkle384_arm(uint32_t *state, int steps)
;;
;; Parameters:
;; -----------
;; state: pointer to an uint32_t-array containing the 12 state words
;; steps: number of steps (must be either 7 or 11)
;;
;; Return value:
;; -------------
;; None
    
sparkle384_arm PROC
    PROLOGUE_384
    PERM_STEP_00_384 x0w, y0w, x1w, y1w, x2w, y2w, x3w, y3w, x4w, y4w, x5w, y5w
    PERM_STEP_01_384 x4w, y4w, x5w, y5w, x3w, y3w, x0w, y0w, x1w, y1w, x2w, y2w
    PERM_STEP_02_384 x1w, y1w, x2w, y2w, x0w, y0w, x4w, y4w, x5w, y5w, x3w, y3w
    PERM_STEP_03_384 x5w, y5w, x3w, y3w, x4w, y4w, x1w, y1w, x2w, y2w, x0w, y0w
    PERM_STEP_04_384 x2w, y2w, x0w, y0w, x1w, y1w, x5w, y5w, x3w, y3w, x4w, y4w
    PERM_STEP_05_384 x3w, y3w, x4w, y4w, x5w, y5w, x2w, y2w, x0w, y0w, x1w, y1w
    PERM_STEP_06_384 x0w, y0w, x1w, y1w, x2w, y2w, x3w, y3w, x4w, y4w, x5w, y5w
    RET_SLIM_384 ;; return when the number of steps is slim
    PERM_STEP_07_384 x4w, y4w, x5w, y5w, x3w, y3w, x0w, y0w, x1w, y1w, x2w, y2w
    PERM_STEP_08_384 x1w, y1w, x2w, y2w, x0w, y0w, x4w, y4w, x5w, y5w, x3w, y3w
    PERM_STEP_09_384 x5w, y5w, x3w, y3w, x4w, y4w, x1w, y1w, x2w, y2w, x0w, y0w
    PERM_STEP_10_384 x2w, y2w, x0w, y0w, x1w, y1w, x5w, y5w, x3w, y3w, x4w, y4w
    EPILOGUE_384
    ENDP
    
    
    END
