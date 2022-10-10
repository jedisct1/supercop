;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sparkle256f_v7m.asm: Speed-optimized ARMv7-M implementation of SPARKLE256 ;;
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
    
    
    EXPORT sparkle256_arm [CODE]
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;; REGISTER NAMES AND CONSTANTS ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
;; register sptr holds the start address of array 'state'
sptr RN r0
;; register step holds the number of steps (parameter 'steps')
step RN r1
;; registers c0w to c7w hold round constants from array 'rcon'
c0w RN r2
c1w RN r3
c2w RN r4
c3w RN r5
c4w RN r1
c5w RN r1
c6w RN r1
c7w RN r1
;; registers tmpx, tmpy hold temporary values
tmpx RN r1
tmpy RN r1
;; registers x0w to y3w hold 8 words from array 'state'
x0w RN r6
y0w RN r7
x1w RN r8
y1w RN r9
x2w RN r10
y2w RN r11
x3w RN r12
y3w RN lr
    
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;; MACROS FOR SPARKLE256 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PROLOGUE_256
    push    {r4-r12,lr}
    ldmia   sptr, {x0w-x3w,y3w}
    push.w  {step}
    mov32   c0w, rc0
    mov32   c1w, rc1
    mov32   c2w, rc2
    mov32   c3w, rc3
    MEND
    
    MACRO
    EPILOGUE_256
    stmia.w sptr!, {x1w,y1w}
    stmia.w sptr!, {x0w,y0w,x3w,y3w}
    stmia.w sptr!, {x2w,y2w}
    pop     {r4-r12,pc}
    MEND
    
    MACRO
    RET_SLIM_256
    pop     {step}
    cmp     step, #7
    bgt.w   big_256
    stmia.w sptr!, {x2w-x3w,y3w}
    stmia.w sptr!, {x1w,y1w}
    stmia.w sptr!, {x0w,y0w}
    pop     {r4-r12,pc}
big_256
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
    LL_TMPX $xi, $xj
    eor     tmpx, $xi, $xj
    eor     tmpx, tmpx, tmpx, lsl #16
    MEND
    
    MACRO
    LL_TMPY $yi, $yj
    eor     tmpy, $yi, $yj
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
;;;; MACRO FOR PERMUTATION-STEP 0 OF SPARKLE256 (USING ROUND-CONSTANT RC0) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_00_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC0
    eor     $y0, $y0, c0w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 1 OF SPARKLE256 (USING ROUND-CONSTANT RC1) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_01_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC1
    eor    $y1, $y1, #1
    eor    $y0, $y0, c1w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 2 OF SPARKLE256 (USING ROUND-CONSTANT RC2) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_02_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC2
    eor    $y1, $y1, #2
    eor    $y0, $y0, c2w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 3 OF SPARKLE256 (USING ROUND-CONSTANT RC3) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_03_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC3
    eor    $y1, $y1, #3
    eor    $y0, $y0, c3w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 4 OF SPARKLE256 (USING ROUND-CONSTANT RC4) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_04_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC4
    eor    $y1, $y1, #4
    mov32  c4w, rc4
    eor    $y0, $y0, c4w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 5 OF SPARKLE256 (USING ROUND-CONSTANT RC5) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_05_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC5
    eor     $y1, $y1, #5
    mov32   c5w, rc5
    eor     $y0, $y0, c5w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 6 OF SPARKLE256 (USING ROUND-CONSTANT RC6) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_06_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC6
    eor     $y1, $y1, #6
    mov32   c6w, rc6
    eor     $y0, $y0, c6w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 7 OF SPARKLE256 (USING ROUND-CONSTANT RC7) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_07_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC7
    eor     $y1, $y1, #7
    mov32   c7w, rc7
    eor     $y0, $y0, c7w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 8 OF SPARKLE256 (USING ROUND-CONSTANT RC0) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_08_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC0
    eor     $y1, $y1, #8
    eor     $y0, $y0, c0w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; MACRO FOR PERMUTATION-STEP 9 OF SPARKLE256 (USING ROUND-CONSTANT RC1) ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MACRO
    PERM_STEP_09_256 $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3
    ;; Addition RC1
    eor     $y1, $y1, #9
    eor     $y0, $y0, c1w
    ;; ARXBOX Layer
    ARX_BOX $x0, $y0, c0w
    ARX_BOX $x1, $y1, c1w
    ARX_BOX $x2, $y2, c2w
    ARX_BOX $x3, $y3, c3w
    ;; Linear Layer
    LL_TMPX $x0, $x1
    LL_ADDY $y2, $y0
    LL_ADDY $y3, $y1
    LL_TMPY $y0, $y1
    LL_ADDX $x2, $x0
    LL_ADDX $x3, $x1
    MEND
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; SPARKLE256 PERMUTATION (FULLY UNROLLED) ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
;; Function prototype:
;; -------------------
;; void sparkle256_arm(uint32_t *state, int steps)
;;
;; Parameters:
;; -----------
;; state: pointer to an uint32_t-array containing the 8 state words
;; steps: number of steps (must be either 7 or 10)
;;
;; Return value:
;; -------------
;; None
    
sparkle256_arm PROC
    PROLOGUE_256
    PERM_STEP_00_256 x0w, y0w, x1w, y1w, x2w, y2w, x3w, y3w
    PERM_STEP_01_256 x3w, y3w, x2w, y2w, x0w, y0w, x1w, y1w
    PERM_STEP_02_256 x1w, y1w, x0w, y0w, x3w, y3w, x2w, y2w
    PERM_STEP_03_256 x2w, y2w, x3w, y3w, x1w, y1w, x0w, y0w
    PERM_STEP_04_256 x0w, y0w, x1w, y1w, x2w, y2w, x3w, y3w
    PERM_STEP_05_256 x3w, y3w, x2w, y2w, x0w, y0w, x1w, y1w
    PERM_STEP_06_256 x1w, y1w, x0w, y0w, x3w, y3w, x2w, y2w
    RET_SLIM_256 ;; return when the number of steps is slim
    PERM_STEP_07_256 x2w, y2w, x3w, y3w, x1w, y1w, x0w, y0w
    PERM_STEP_08_256 x0w, y0w, x1w, y1w, x2w, y2w, x3w, y3w
    PERM_STEP_09_256 x3w, y3w, x2w, y2w, x0w, y0w, x1w, y1w
    EPILOGUE_256
    ENDP
    
    
    END
