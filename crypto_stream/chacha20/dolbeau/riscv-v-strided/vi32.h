/*

RISC-V V DFT/FFT demo code.

Copyright ? 2020 Romain Dolbeau <Romain.Dolbeau@sipearl.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
version 2 as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#ifndef USE_EPI_CUSTOM
//ZIP1 Interleave elements from low halves of two vectors
static inline vuint32m1_t __riscv_zip1_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_t res;
	vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...)
	//vuint32m1_t vone = __riscv_vmv_v_x_u32m1(1, vc);
	vuint32m1_t hidx = __riscv_vsrl_vx_u32m1(idx, 1, vc); // (0, 0, 1, 1, 2, 2, ...)
	vuint32m1_t v0r = __riscv_vrgather_vv_u32m1(v0, hidx, vc);
	vuint32m1_t v1r = __riscv_vrgather_vv_u32m1(v1, hidx, vc);
	vuint32m1_t mask = __riscv_vand_vx_u32m1(idx, 1, vc); // (0, 1, 0, 1, 0, ...)
	vbool32_t mmask = __riscv_vmsne_vx_u32m1_b32(mask, 0, vc); // idem, as mask
	res = __riscv_vmerge_vvm_u32m1(v0r, v1r, mmask, vc); // should give us what we want ...
	return res;
}

//ZIP2 Interleave elements from high halves of two vectors
static inline vuint32m1_t __riscv_zip2_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
        vuint32m1_t res;
        vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...)
	//vuint32m1_t vone = __riscv_vmv_v_x_u32m1(1, vc);
        vuint32m1_t hidx = __riscv_vsrl_vx_u32m1(idx, 1, vc); // (0, 0, 1, 1, 2, 2, ...)
	hidx = __riscv_vadd_vv_u32m1(hidx, __riscv_vmv_v_x_u32m1(vc/2, vc), vc); // assume vc&1==0
        vuint32m1_t v0r = __riscv_vrgather_vv_u32m1(v0, hidx, vc);
        vuint32m1_t v1r = __riscv_vrgather_vv_u32m1(v1, hidx, vc);
        vuint32m1_t mask = __riscv_vand_vx_u32m1(idx, 1, vc); // (0, 1, 0, 1, 0, ...)
	vbool32_t mmask = __riscv_vmsne_vx_u32m1_b32(mask, 0, vc); // idem, as mask
	res = __riscv_vmerge_vvm_u32m1(v0r, v1r, mmask, vc); // should give us what we want ...
        return res;
}

static inline void print_u32m1(vuint32m1_t v, unsigned long int vc) {
  uint32_t data[vc];
  int i;
  __riscv_vse32_v_u32m1(data, v, 8);
  for (i = 0 ; i < vc ; i++) {
    printf("%d ", data[i]);
  }
  printf("\n");
}

//TRN1 Interleave even elements from two vectors
static inline vuint32m1_t __riscv_trn1_vv_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
#if 1
	vuint32m1_t res;
	vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...)
#if 0
	//vuint32m1_t vone = __riscv_vmv_v_x_u32m1(1, vc);
	vuint32m1_t hidx = __riscv_vsrl_vx_u32m1(idx, 1, vc); // (0, 0, 1, 1, 2, 2, ...)
	hidx = __riscv_vsll_vx_u32m1(hidx, 1, vc); // (0, 0, 2, 2, 4, 4, ...) // vsrl+vsll could be done with & ~2
#else
	vuint32m1_t hidx = __riscv_vand_vx_u32m1(idx, -2, vc); // (0, 0, 2, 2, 4, 4, ...)
#endif
	vuint32m1_t v0r = __riscv_vrgather_vv_u32m1(v0, hidx, vc);
	vuint32m1_t v1r = __riscv_vrgather_vv_u32m1(v1, hidx, vc);
	vuint32m1_t mask = __riscv_vand_vx_u32m1(idx, 1, vc); // (0, 1, 0, 1, 0, ...)
	vbool32_t mmask = __riscv_vmsne_vx_u32m1_b32(mask, 0, vc); // idem, as mask
	res = __riscv_vmerge_vvm_u32m1(v0r, v1r, mmask, vc); // should give us what we want ...
	return res;
#else
	// use LMUL=2 so we can use a double-width vrgather, with vl limited to a single register
	// however this is slower on my Banana Pi F3 ?!?
	vuint32m1_t res;
	vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...) [we only need the low vector]
	vuint32m2_t v01 = __riscv_vcreate_v_u32m1_u32m2(v1, v0); // both input vectors concatenated *backward*
	vuint32m1_t hidx = __riscv_vand_vx_u32m1(idx, -2, vc); // (0, 0, 2, 2, 4, 4, ...)
	vuint32m1_t offset = __riscv_vreinterpret_v_u64m1_u32m1(__riscv_vmv_v_x_u64m1(__riscv_vlenb()/sizeof(uint32_t), vc >> 1)); // cheat !!! put vc in even 32-bits elements by using low half of each 64-bits
	vuint32m1_t fidx = __riscv_vadd_vv_u32m1(hidx, offset, vc); // vc+0, 0, vc+2, 2, vc+4, 4, ... )
	//print_u32m1(__riscv_vlmul_trunc_v_u32m2_u32m1(fidx), vc);
	res = __riscv_vlmul_trunc_v_u32m2_u32m1(__riscv_vrgather_vv_u32m2(v01, __riscv_vcreate_v_u32m1_u32m2(fidx, __riscv_vundefined_u32m1()), vc));
	return res;
#endif
}

//TRN2 Interleave odd elements from two vectors
static inline vuint32m1_t __riscv_trn2_vv_u32m1( vuint32m1_t v0,  vuint32m1_t v1,  unsigned long int vc) {
        vuint32m1_t res;
        vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...)
#if 0
	//vuint32m1_t vone = __riscv_vmv_v_x_u32m1(1, vc);
        vuint32m1_t hidx = __riscv_vsrl_vx_u32m1(idx, 1, vc); // (0, 0, 1, 1, 2, 2, ...)
	hidx = __riscv_vsll_vx_u32m1(hidx, 1, vc); // (0, 0, 2, 2, 4, 4, ...) // vsrl+vsll could be done with & ~2
#else
	vuint32m1_t hidx = __riscv_vand_vx_u32m1(idx, -2, vc); // (0, 0, 2, 2, 4, 4, ...)
#endif
	hidx = __riscv_vadd_vx_u32m1(hidx, 1, vc); // (1, 1, 3, 3, 5, 5, ...)
        vuint32m1_t v0r = __riscv_vrgather_vv_u32m1(v0, hidx, vc);
        vuint32m1_t v1r = __riscv_vrgather_vv_u32m1(v1, hidx, vc);
        vuint32m1_t mask = __riscv_vand_vx_u32m1(idx, 1, vc); // (0, 1, 0, 1, 0, ...)
	vbool32_t mmask = __riscv_vmsne_vx_u32m1_b32(mask, 0, vc); // idem, as mask
	res = __riscv_vmerge_vvm_u32m1(v0r, v1r, mmask, vc); // should give us what we want ... // check registers - 5 ?!?
        return res;
}

//UZP1 Concatenate even elements from two vectors
static inline vuint32m1_t __riscv_uzp1_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
        vuint32m1_t res;
        vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...)
        //vuint32m1_t vone = __riscv_vmv_v_x_u32m1(1, vc);
        vuint32m1_t hidx = __riscv_vand_vv_u32m1(idx, __riscv_vmv_v_x_u32m1(((vc/2)-1), vc), vc); // (0, 1, 2, ..., 0, 1, 2, ...) // assume vc is a power of 2 // might not be necessary, what happens if gathering non-exsitent lanes ?
	hidx = __riscv_vsll_vx_u32m1(hidx, 1, vc); // (0, 2, 4, ..., 0, 2, 4, ...)
        vuint32m1_t v0r = __riscv_vrgather_vv_u32m1(v0, hidx, vc);
        vuint32m1_t v1r = __riscv_vrgather_vv_u32m1(v1, hidx, vc);
	vbool32_t mmask = __riscv_vmsgeu_vx_u32m1_b32(idx, vc/2, vc); // (0, 0, 0, ..., 1, 1, 1)
	res = __riscv_vmerge_vvm_u32m1(v0r, v1r, mmask, vc); // should give us what we want ...
        return res;
}

//UZP2 Concatenate odd elements from two vectors
static inline vuint32m1_t __riscv_uzp2_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_t res;
	vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...)
	//vuint32m1_t vone = __riscv_vmv_v_x_u32m1(1, vc);
	vuint32m1_t hidx = __riscv_vand_vv_u32m1(idx, __riscv_vmv_v_x_u32m1(((vc/2)-1), vc), vc); // (0, 1, 2, ..., 0, 1, 2, ...) // assume vc is a power of 2 // might not be necessary, what happens if gathering non-exsitent lanes ?
	hidx = __riscv_vsll_vx_u32m1(hidx, 1, vc); // (0, 2, 4, ..., 0, 2, 4, ...)
	hidx = __riscv_vadd_vx_u32m1(hidx, 1, vc); // (1, 3, 5, ..., 1, 3, 5, ...)
	vuint32m1_t v0r = __riscv_vrgather_vv_u32m1(v0, hidx, vc);
	vuint32m1_t v1r = __riscv_vrgather_vv_u32m1(v1, hidx, vc);
	vbool32_t mmask = __riscv_vmsgeu_vx_u32m1_b32(idx, vc/2, vc); // (0, 0, 0, ..., 1, 1, 1)
	res = __riscv_vmerge_vvm_u32m1(v0r, v1r, mmask, vc); // should give us what we want ...
	return res;
}
#else // USE_EPI_CUSTOM
//ZIP1 Interleave elements from low halves of two vectors
static inline vuint32m1_t __riscv_zip1_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_tx2 res = __riscv_vzip2_u32m1x2(v0, v1, vc);
	return res.v0;
}

//ZIP2 Interleave elements from high halves of two vectors
static inline vuint32m1_t __riscv_zip2_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_tx2 res = __riscv_vzip2_u32m1x2(v0, v1, vc);
	return res.v1;
}

//TRN1 Interleave even elements from two vectors
static inline vuint32m1_t __riscv_trn1_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_tx2 res = __riscv_vtrn_u32m1x2(v0, v1, vc);
	return res.v0;
}

//TRN2 Interleave odd elements from two vectors
static inline vuint32m1_t __riscv_trn2_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_tx2 res = __riscv_vtrn_u32m1x2(v0, v1, vc);
	return res.v1;
}

//UZP1 Concatenate even elements from two vectors
static inline vuint32m1_t __riscv_uzp1_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_tx2 res = __riscv_vunzip2_u32m1x2(v0, v1, vc);
	return res.v0;
}

//UZP2 Concatenate odd elements from two vectors
static inline vuint32m1_t __riscv_uzp2_u32m1(vuint32m1_t v0, vuint32m1_t v1, unsigned long int vc) {
	vuint32m1_tx2 res = __riscv_vunzip2_u32m1x2(v0, v1, vc);
	return res.v1;
}
#endif
