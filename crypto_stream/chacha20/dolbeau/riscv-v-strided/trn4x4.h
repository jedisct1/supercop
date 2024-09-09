
static inline void print_u32m4(vuint32m4_t v, unsigned long int vc) {
  uint32_t data[vc*4];
  int i;
  __riscv_vse32_v_u32m4(data, v, vc*4);
  for (i = 0 ; i < vc*4 ; i++) {
    printf("0x%08x ", data[i]);
    if ((i & 7) == 7) printf("\n");
  }
  printf("\n");
}


//trn4x4 transpose 4x4 blocks (assume native vlen is a multiple of 128 bits) from 4 vectors
static inline vuint32m4_t __riscv_trn4x4_v_u32m4(const vuint32m4_t v, const unsigned long int vc) {
	// use LMUL=4 so we can use a quadruple-width vrgather, with vl limited to a single register
	vuint32m1_t idx = __riscv_vid_v_u32m1(vc); // (0, 1, 2, 3, ...) [we only need the low vector]
	vuint32m1_t hidx = __riscv_vand_vx_u32m1(idx, -4, vc); // (0, 0, 0, 0, 4, 4, ...)
	vuint32m1_t lidx = __riscv_vand_vx_u32m1(idx, 3, vc); // (0, 1, 2, 3, 0, 1, ...)
	vuint32m1_t fidx = __riscv_vmul_vx_u32m1(lidx, __riscv_vlenb()/sizeof(uint32_t), vc); // might be mergable into macc
	fidx = __riscv_vadd_vv_u32m1(hidx, fidx, vc); // offset : (0, vl, vl*2, vl*3, 4, 4+vl, 4+2*vl
	#if 0
	//print_u32m1(__riscv_vlmul_trunc_v_u32m2_u32m1(fidx), vc);
	// 4 VL-restricted vrgather
	vuint32m1_t res0 = __riscv_vlmul_trunc_v_u32m4_u32m1(__riscv_vrgather_vv_u32m4(v, __riscv_vcreate_v_u32m1_u32m4(fidx, __riscv_vundefined_u32m1() , __riscv_vundefined_u32m1(), __riscv_vundefined_u32m1()), vc));
	fidx = __riscv_vadd_vx_u32m1(fidx, 1, vc);
	vuint32m1_t res1 = __riscv_vlmul_trunc_v_u32m4_u32m1(__riscv_vrgather_vv_u32m4(v, __riscv_vcreate_v_u32m1_u32m4(fidx, __riscv_vundefined_u32m1() , __riscv_vundefined_u32m1(), __riscv_vundefined_u32m1()), vc));
	fidx = __riscv_vadd_vx_u32m1(fidx, 1, vc);
	vuint32m1_t res2 = __riscv_vlmul_trunc_v_u32m4_u32m1(__riscv_vrgather_vv_u32m4(v, __riscv_vcreate_v_u32m1_u32m4(fidx, __riscv_vundefined_u32m1() , __riscv_vundefined_u32m1(), __riscv_vundefined_u32m1()), vc));
	fidx = __riscv_vadd_vx_u32m1(fidx, 1, vc);
	vuint32m1_t res3 = __riscv_vlmul_trunc_v_u32m4_u32m1(__riscv_vrgather_vv_u32m4(v, __riscv_vcreate_v_u32m1_u32m4(fidx, __riscv_vundefined_u32m1() , __riscv_vundefined_u32m1(), __riscv_vundefined_u32m1()), vc));	
	vuint32m4_t res =  __riscv_vcreate_v_u32m1_u32m4(res0, res1, res2, res3);
	//printf("res=\n");print_u32m4(res, vc);
	return res;
	#else
	// single massive LMUL=4 indices + vrgather
	//printf("V=\n");print_u32m4(v, vc);
	vuint32m4_t f4idx = __riscv_vcreate_v_u32m1_u32m4(fidx, __riscv_vadd_vx_u32m1(fidx, 1, vc), __riscv_vadd_vx_u32m1(fidx, 2, vc), __riscv_vadd_vx_u32m1(fidx, 3, vc));
	//printf("fidx=\n");print_u32m4(f4idx, vc);
	//vuint32m4_t res =  __riscv_vrgather_vv_u32m4(v, f4idx, vc * 4); // only works if vc is the full vector
	vuint32m4_t res =  __riscv_vrgather_vv_u32m4(v, f4idx, __riscv_vlenb()); // must do everything, if vc is half the max (which it sometimes is), then we need half of all vectors, not half the vectors!
	//printf("res=\n");print_u32m4(res, vc);
	return res;
	#endif
}
