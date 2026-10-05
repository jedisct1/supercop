
#include "macros.i"

#include "params.h"

.align 2
.global fnt_point_mul_extended_opt
.global _fnt_point_mul_extended_opt
fnt_point_mul_extended_opt:
_fnt_point_mul_extended_opt:

    push_all

    ldrsh w20, [x3]
    dup v28.8H, w20

    ldr q22, [x1, #464]                  
    ldp q17, q8, [x2, #14*16]            
    ldp q18, q11, [x2, #0*16]            
    ldr q31, [x1, #16]                   
    ldp q23, q25, [x2, #10*16]           
    ldp q0, q21, [x2, #6*16]             
    ldr q15, [x1, #208]                  
    ldp q4, q24, [x2, #8*16]             
    mul v3.8H, v22.8H, v17.8H            
    ldr q29, [x1, #48]                   
    ldp q16, q10, [x2, #12*16]           
    ldr q1, [x1, #112]                   
    ldr q27, [x1, #336]                  
    ldr q2, [x1, #400]                   
    sqrdmulh v19.8H, v31.8H, v11.8H      
    ldr q12, [x1, #368]                  
    ldr q20, [x1, #304]                  
    mul v5.8H, v15.8H, v0.8H             
    ldp q30, q9, [x2, #2*16]             
    ldr q6, [x1, #432]                   
    sqrdmulh v11.8H, v29.8H, v11.8H      
    mul v14.8H, v31.8H, v18.8H           
    mul v13.8H, v29.8H, v18.8H           
    sqrdmulh v31.8H, v2.8H, v10.8H       
    mls v14.8H, v19.8H, v28.8H           
    mls v13.8H, v11.8H, v28.8H           
    sqrdmulh v11.8H, v15.8H, v21.8H      
    ldr q29, [x1, #240]                  
    mul v26.8H, v27.8H, v23.8H           
    neg v15.8H, v13.8H                   
    mul v19.8H, v12.8H, v23.8H           
    mul v0.8H, v29.8H, v0.8H             
    stp q14, q15, [x0, #0*16]            
    ldr q14, [x1, #80]                   
    sqrdmulh v23.8H, v29.8H, v21.8H      
    ldr q29, [x1, #272]                  
    sqrdmulh v13.8H, v20.8H, v24.8H      
    mul v21.8H, v29.8H, v4.8H            
    mul v4.8H, v20.8H, v4.8H             
    sqrdmulh v18.8H, v1.8H, v9.8H        
    mul v1.8H, v1.8H, v30.8H             
    mls v4.8H, v13.8H, v28.8H            
    mul v13.8H, v14.8H, v30.8H           
    sqrdmulh v30.8H, v29.8H, v24.8H      
    ldr q29, [x1, #176]                  
    sqrdmulh v14.8H, v14.8H, v9.8H       
    mls v1.8H, v18.8H, v28.8H            
    neg v4.8H, v4.8H                     
    mls v0.8H, v23.8H, v28.8H            
    mls v13.8H, v14.8H, v28.8H           
    ldr q14, [x1, #496]                  
    mls v5.8H, v11.8H, v28.8H            
    ldp q11, q9, [x2, #4*16]             
    neg v18.8H, v0.8H                    
    neg v0.8H, v1.8H                     
    mul v24.8H, v14.8H, v17.8H           
    mul v2.8H, v2.8H, v16.8H             
    stp q13, q0, [x0, #2*16]             
    stp q5, q18, [x0, #2*16+64]          
    sqrdmulh v5.8H, v27.8H, v25.8H       
    ldr q27, [x1, #144]                  
    mls v2.8H, v31.8H, v28.8H            
    sqrdmulh v20.8H, v27.8H, v9.8H       
    sqrdmulh v17.8H, v12.8H, v25.8H      
    mul v31.8H, v27.8H, v11.8H           
    mls v31.8H, v20.8H, v28.8H           
    mul v15.8H, v29.8H, v11.8H           
    mls v26.8H, v5.8H, v28.8H            
    sqrdmulh v7.8H, v29.8H, v9.8H        
    sqrdmulh v20.8H, v6.8H, v10.8H       
    mul v29.8H, v6.8H, v16.8H            
    sqrdmulh v6.8H, v22.8H, v8.8H        
    sqrdmulh v18.8H, v14.8H, v8.8H       
    mls v19.8H, v17.8H, v28.8H           
    mls v15.8H, v7.8H, v28.8H            
    mls v29.8H, v20.8H, v28.8H           
    neg v5.8H, v19.8H                    
    mls v24.8H, v18.8H, v28.8H           
    neg v14.8H, v15.8H                   
    mls v3.8H, v6.8H, v28.8H             
    stp q26, q5, [x0, #2*16+128]         
    neg v1.8H, v29.8H                    
    mls v21.8H, v30.8H, v28.8H           
    stp q31, q14, [x0, #0*16+64]         
    neg v29.8H, v24.8H                   
    stp q2, q1, [x0, #0*16+192]          
    stp q3, q29, [x0, #2*16+192]         
    stp q21, q4, [x0, #0*16+128]         

    pop_all

    ret