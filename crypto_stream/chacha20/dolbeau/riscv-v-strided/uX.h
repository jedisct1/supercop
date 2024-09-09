/*
uX.h version $Date$
D. J. Bernstein
Romain Dolbeau
Public domain.

This does a variable number of blocks, depending on the V vector size.
*/

#include "uX_config.h"

#define VEC4_ROT(a,imm) __riscv_vxor_vv_u32m1(__riscv_vsll_vx_u32m1(a, imm, vc),__riscv_vsrl_vx_u32m1(a, 32-imm, vc), vc)

//#define VEC4_ROT16(a) svrevh_u32_z(svptrue_b32(), a)

#define VEC4_QUARTERROUND(a,b,c,d)                                \
   x_##a = __riscv_vadd_vv_u32m1(x_##a, x_##b, vc); t_##a = __riscv_vxor_vv_u32m1(x_##d, x_##a, vc); x_##d = VEC4_ROT(t_##a, 16); \
   x_##c = __riscv_vadd_vv_u32m1(x_##c, x_##d, vc); t_##c = __riscv_vxor_vv_u32m1(x_##b, x_##c, vc); x_##b = VEC4_ROT(t_##c, 12); \
   x_##a = __riscv_vadd_vv_u32m1(x_##a, x_##b, vc); t_##a = __riscv_vxor_vv_u32m1(x_##d, x_##a, vc); x_##d = VEC4_ROT(t_##a,  8); \
   x_##c = __riscv_vadd_vv_u32m1(x_##c, x_##d, vc); t_##c = __riscv_vxor_vv_u32m1(x_##b, x_##c, vc); x_##b = VEC4_ROT(t_##c,  7)

  if (!bytes) return;
if (bytes>=256 && (((unsigned long long)m & 0x3f) == 0) && (((unsigned long long)out & 0x3f) == 0)) { // mmm, the F3 doesn't have vector unaligned access...
  unsigned long int vc = __riscv_vsetvlmax_e32m1();
  u32 in12, in13;
  vuint32m1_t x_0 = __riscv_vmv_v_x_u32m1(x[0], vc);
  vuint32m1_t x_1 = __riscv_vmv_v_x_u32m1(x[1], vc);
  vuint32m1_t x_2 = __riscv_vmv_v_x_u32m1(x[2], vc);
  vuint32m1_t x_3 = __riscv_vmv_v_x_u32m1(x[3], vc);
  vuint32m1_t x_4 = __riscv_vmv_v_x_u32m1(x[4], vc);
  vuint32m1_t x_5 = __riscv_vmv_v_x_u32m1(x[5], vc);
  vuint32m1_t x_6 = __riscv_vmv_v_x_u32m1(x[6], vc);
  vuint32m1_t x_7 = __riscv_vmv_v_x_u32m1(x[7], vc);
  vuint32m1_t x_8 = __riscv_vmv_v_x_u32m1(x[8], vc);
  vuint32m1_t x_9 = __riscv_vmv_v_x_u32m1(x[9], vc);
  vuint32m1_t x_10 = __riscv_vmv_v_x_u32m1(x[10], vc);
  vuint32m1_t x_11 = __riscv_vmv_v_x_u32m1(x[11], vc);
  vuint32m1_t x_12;// = __riscv_vmv_v_x_u32m1(x[12], vc); /* useless */
  vuint32m1_t x_13;// = __riscv_vmv_v_x_u32m1(x[13], vc); /* useless */
  vuint32m1_t x_14 = __riscv_vmv_v_x_u32m1(x[14], vc);
  vuint32m1_t x_15 = __riscv_vmv_v_x_u32m1(x[15], vc);
  vuint32m1_t orig0 = x_0;
  vuint32m1_t orig1 = x_1;
  vuint32m1_t orig2 = x_2;
  vuint32m1_t orig3 = x_3;
  vuint32m1_t orig4 = x_4;
  vuint32m1_t orig5 = x_5;
  vuint32m1_t orig6 = x_6;
  vuint32m1_t orig7 = x_7;
  vuint32m1_t orig8 = x_8;
  vuint32m1_t orig9 = x_9;
  vuint32m1_t orig10 = x_10;
  vuint32m1_t orig11 = x_11;
  vuint32m1_t orig12;// = x_12; /* useless */
  vuint32m1_t orig13;// = x_13; /* useless */
  vuint32m1_t orig14 = x_14;
  vuint32m1_t orig15 = x_15;
  vuint32m1_t t_0;
  vuint32m1_t t_1;
  vuint32m1_t t_2;
  vuint32m1_t t_3;
  vuint32m1_t t_4;
  vuint32m1_t t_5;
  vuint32m1_t t_6;
  vuint32m1_t t_7;
  vuint32m1_t t_8;
  vuint32m1_t t_9;
  vuint32m1_t t_10;
  vuint32m1_t t_11;
  vuint32m1_t t_12;
  vuint32m1_t t_13;
  vuint32m1_t t_14;
  vuint32m1_t t_15;

  while (bytes >= 256) {
{
/*   vc = bytes / 64; */
/*   vc = vc | (vc >> 1); */
/*   vc = vc | (vc >> 2); */
/*   vc = vc | (vc >> 4); */
/*   vc = vc | (vc >> 8); */
/*   vc = vc | (vc >> 16); */
/*   vc = vc | (vc >> 32); */
/*   vc = vc - (vc >> 1); // rounded to power-of-2 */
vc = bytes / 64;
vc = vc & ~3;
}
  vc = 2 * __riscv_vsetvl_e64m1(vc/2);
    x_0 = orig0;
    x_1 = orig1;
    x_2 = orig2;
    x_3 = orig3;
    x_4 = orig4;
    x_5 = orig5;
    x_6 = orig6;
    x_7 = orig7;
    x_8 = orig8;
    x_9 = orig9;
    x_10 = orig10;
    x_11 = orig11;
    //x_12 = orig12; /* useless */
    //x_13 = orig13; /* useless */
    x_14 = orig14;
    x_15 = orig15;

    in12 = x[12];
    in13 = x[13];
    u64 in1213 = ((u64)in12) | (((u64)in13) << 32);
    
    const vuint32m1_t addv = __riscv_vid_v_u32m1(vc);
    //vuint32m1_t oldx_12;
    vbool32_t carry = __riscv_vmclr_m_b32(vc);
    carry = __riscv_vmxor_mm_b32(carry, carry, vc);
    x_12 =  __riscv_vadc_vxm_u32m1(addv, in12, carry, vc);
    carry = __riscv_vmadc_vxm_u32m1_b32(addv, in12, carry, vc);
    x_13 =  __riscv_vadc_vxm_u32m1(__riscv_vmv_v_x_u32m1(0, vc), in13, carry, vc);

    orig12 = x_12;
    orig13 = x_13;

    in1213 += vc;
    
    x[12] = in1213 & 0xFFFFFFFF;
    x[13] = (in1213>>32)&0xFFFFFFFF;

    for (i = 0 ; i < ROUNDS ; i+=2) {
      VEC4_QUARTERROUND( 0, 4, 8,12);
      VEC4_QUARTERROUND( 1, 5, 9,13);
      VEC4_QUARTERROUND( 2, 6,10,14);
      VEC4_QUARTERROUND( 3, 7,11,15);
      VEC4_QUARTERROUND( 0, 5,10,15);
      VEC4_QUARTERROUND( 1, 6,11,12);
      VEC4_QUARTERROUND( 2, 7, 8,13);
      VEC4_QUARTERROUND( 3, 4, 9,14);
    }

#define ONEQUAD_TRANSPOSE_SVESTYLE(a,b,c,d)                                      \
    {                                                                   \
      vuint32m1_t t00, t01, t10, t11;                                    \
      vuint64m1_t t0, t1, t2, t3;                                        \
      x_##a = __riscv_vadd_vv_u32m1(x_##a, orig##a, vc);                                \
      x_##b = __riscv_vadd_vv_u32m1(x_##b, orig##b, vc);                                \
      x_##c = __riscv_vadd_vv_u32m1(x_##c, orig##c, vc);                                \
      x_##d = __riscv_vadd_vv_u32m1(x_##d, orig##d, vc);                                \
      t00 = __riscv_trn1_vv_u32m1(x_##a,x_##b,vc);\
      t01 = __riscv_trn2_vv_u32m1(x_##a,x_##b,vc);\
      t10 = __riscv_trn1_vv_u32m1(x_##c,x_##d,vc);\
      t11 = __riscv_trn2_vv_u32m1(x_##c,x_##d,vc);\
      x_##a = __riscv_vreinterpret_v_u64m1_u32m1(__riscv_trn1_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(t00), __riscv_vreinterpret_v_u32m1_u64m1(t10), vc/2)); \
      x_##b = __riscv_vreinterpret_v_u64m1_u32m1(__riscv_trn1_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(t01), __riscv_vreinterpret_v_u32m1_u64m1(t11), vc/2)); \
      x_##c = __riscv_vreinterpret_v_u64m1_u32m1(__riscv_trn2_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(t00), __riscv_vreinterpret_v_u32m1_u64m1(t10), vc/2)); \
      x_##d = __riscv_vreinterpret_v_u64m1_u32m1(__riscv_trn2_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(t01), __riscv_vreinterpret_v_u32m1_u64m1(t11), vc/2)); \
      t0 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##a), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+0), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+0), gvv, t0, vc/2); \
      t1 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##b), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+64), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+64), gvv, t1, vc/2); \
      t2 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##c), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+128), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+128), gvv, t2, vc/2); \
      t3 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##d), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+192), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+192), gvv, t3, vc/2); \
    }

#define ONEQUAD_TRANSPOSE_LMUL4(a,b,c,d)                                      \
    {                                                                   \
      vuint32m1_t t00, t01, t10, t11;					\
      vuint64m1_t t0, t1, t2, t3;					\
      x_##a = __riscv_vadd_vv_u32m1(x_##a, orig##a, vc);		\
      x_##b = __riscv_vadd_vv_u32m1(x_##b, orig##b, vc);		\
      x_##c = __riscv_vadd_vv_u32m1(x_##c, orig##c, vc);		\
      x_##d = __riscv_vadd_vv_u32m1(x_##d, orig##d, vc);		\
      vuint32m4_t t = __riscv_trn4x4_v_u32m4(__riscv_vcreate_v_u32m1_u32m4(x_##a, x_##b, x_##c, x_##d), vc); \
      x_##a = __riscv_vget_v_u32m4_u32m1(t, 0); \
      x_##b = __riscv_vget_v_u32m4_u32m1(t, 1); \
      x_##c = __riscv_vget_v_u32m4_u32m1(t, 2); \
      x_##d = __riscv_vget_v_u32m4_u32m1(t, 3); \
      t0 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##a), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+0), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+0), gvv, t0, vc/2); \
      t1 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##b), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+64), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+64), gvv, t1, vc/2); \
      t2 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##c), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+128), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+128), gvv, t2, vc/2); \
      t3 = __riscv_vxor_vv_u64m1(__riscv_vreinterpret_v_u32m1_u64m1(x_##d), __riscv_vluxei64_v_u64m1((unsigned long int*)(m+192), gvv, vc/2), vc/2);\
      __riscv_vsuxei64_v_u64m1((unsigned long int*)(out+192), gvv, t3, vc/2); \
    }
    
    /* strided is much faster than either transpose on the F3 */
#define ONE_STRIDED(z, o)						\
    {									\
	    vuint32m1_t t00;						\
	    x_##z = __riscv_vadd_vv_u32m1(x_##z, orig##z, vc);	\
	    t00 = __riscv_vlse32_v_u32m1((unsigned int*)(m+o), 64, vc); \
	    t00 = __riscv_vxor_vv_u32m1(x_##z, t00, vc); \
	    __riscv_vsse32_v_u32m1((unsigned int*)(out+o), 64, t00, vc); \
    }
#define ONEQUAD_STRIDED(a,b,c,d) \
    ONE_STRIDED(a,0) ONE_STRIDED(b,4) ONE_STRIDED(c,8) ONE_STRIDED(d,12) 

#if defined(RVV_QUAD_TRANSPOSE_LEGACY)
#define ONEQUAD_TRANSPOSE(a,b,c,d) ONEQUAD_TRANSPOSE_SVESTYLE(a,b,c,d)
#define ONEQUAD(a,b,c,d) ONEQUAD_TRANSPOSE(a,b,c,d)
#elif defined(RVV_QUAD_TRANSPOSE_LMUL4)
#define ONEQUAD_TRANSPOSE(a,b,c,d) ONEQUAD_TRANSPOSE_LMUL4(a,b,c,d)
#define ONEQUAD(a,b,c,d) ONEQUAD_TRANSPOSE(a,b,c,d)
#elif defined(RVV_QUAD_STRIDED)
#define ONEQUAD(a,b,c,d) ONEQUAD_STRIDED(a,b,c,d)
#else
#error "No QUAD defined"
#endif 
    

    // prep for transpose
#if defined(ONEQUAD_TRANSPOSE)
    vuint64m1_t gvv, gvvl, gvvh;
    gvvl = __riscv_vid_v_u64m1(vc/2); // (0, 1, 2, 3, ...)
    gvvl = __riscv_vsll_vx_u64m1(gvvl, 8, vc/2); // (0, 256, 512, 768, ... )
    /* emulate zip1(a,a) */
    vuint64m1_t idx = __riscv_vid_v_u64m1(vc/2); // (0, 1, 2, 3, ...)
    vuint64m1_t hidx = __riscv_vsrl_vx_u64m1(idx, 1, vc/2); // (0, 0, 1, 1, 2, 2, ...)
    gvvl = __riscv_vrgather_vv_u64m1(gvvl, hidx, vc/2); // (0, 0, 256, 256, 512, 512, ... )
    /* emulate vadd + vdupq_n_s64 with vmerge ...*/
    vuint64m1_t gvvlp8 = __riscv_vadd_vx_u64m1(gvvl, 8, vc/2); // (8, 8, 264, 264, 520, 520)
    vuint64m1_t mask = __riscv_vand_vx_u64m1(idx, 1, vc/2); // (0, 1, 0, 1, 0, ...)
    vbool64_t mmask = __riscv_vmsne_vx_u64m1_b64(mask, 0, vc/2);
    gvv = __riscv_vmerge_vvm_u64m1(gvvl, gvvlp8, mmask, vc/2); // should give us what we want ...
#endif

    ONEQUAD(0,1,2,3);
    m+=16;
    out+=16;
    ONEQUAD(4,5,6,7);
    m+=16;
    out+=16;
    ONEQUAD(8,9,10,11);
    m+=16;
    out+=16;
    ONEQUAD(12,13,14,15);
    m-=48;
    out-=48;
    
#undef ONEQUAD
#undef ONEQUAD_STRIDED
#ifdef ONEQUAD_TRANSPOSE
#undef ONEQUAD_TRANSPOSE
#endif
 
    bytes -= 64*vc;
    out += 64*vc;
    m += 64*vc;
  }
 }
#undef VEC4_ROT
#undef VEC4_QUARTERROUND
