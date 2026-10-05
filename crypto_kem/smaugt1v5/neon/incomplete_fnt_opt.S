#include "macros.i"

.align 2
.global fnt_top_opt
.global _fnt_top_opt
fnt_top_opt:
_fnt_top_opt:

    push_simd

    mov w3, 257
    dup v0.8H, w3

    ldr q7, [x0, #304]                     
    ldr q30, [x0, #256]                    
    ldr q29, [x0, #16]                     
    ldr q18, [x0, #320]                    
    ldr q24, [x0, #48]                     
    ldr q15, [x0, #288]                    
    ldr q17, [x0, #0]                      
    ldr q10, [x0, #352]                    
    shl v25.8H, v30.8H, #4                 
    ldr q6, [x0, #96]                      
    ldr q5, [x0, #64]                      
    shl v19.8H, v18.8H, #4                 
    ldr q14, [x0, #32]                     
    ldr q1, [x0, #272]                     
    shl v31.8H, v15.8H, #4                 
    ldr q23, [x1, #768]                    
    shl v12.8H, v10.8H, #4                 
    sub v3.8H, v17.8H, v25.8H              
    ldr q26, [x1, #112]                    
    shl v11.8H, v7.8H, #4                  
    ldr q8, [x1, #544]                     
    add v18.8H, v5.8H, v19.8H              
    ldr q21, [x1, #560]                    
    shl v20.8H, v1.8H, #4                  
    add v7.8H, v14.8H, v31.8H              
    sub v30.8H, v6.8H, v12.8H              
    sqrdmulh v2.8H, v3.8H, v23.8H          
    ldr q23, [x0, #336]                    
    add v22.8H, v24.8H, v11.8H             
    ldr q9, [x1, #848]                     
    add v27.8H, v6.8H, v12.8H              
    sqrdmulh v8.8H, v7.8H, v8.8H           
    ldr q28, [x1, #32]                     
    sub v6.8H, v24.8H, v11.8H              
    ldr q11, [x1, #576]                    
    sub v10.8H, v14.8H, v31.8H             
    sqrdmulh v4.8H, v22.8H, v21.8H         
    ldr q13, [x1, #16]                     
    ldr q12, [x0, #368]                    
    sub v24.8H, v29.8H, v20.8H             
    add v21.8H, v29.8H, v20.8H             
    mul v7.8H, v7.8H, v28.8H               
    ldr q16, [x1, #256]                    
    add v28.8H, v17.8H, v25.8H             
    ldr q14, [x0, #80]                     
    mls v7.8H, v8.8H, v0.8H                
    shl v8.8H, v23.8H, #4                  
    ldr q15, [x0, #112]                    
    shl v31.8H, v12.8H, #4                 
    ldr q29, [x1, #880]                    
    sub v1.8H, v5.8H, v19.8H               
    mul v25.8H, v3.8H, v16.8H              
    ldr q12, [x1, #592]                    
    add v17.8H, v14.8H, v8.8H              
    ldr q19, [x1, #288]                    
    ldr q3, [x1, #816]                     
    mls v25.8H, v2.8H, v0.8H               
    ldr q16, [x1, #80]                     
    sub v5.8H, v15.8H, v31.8H              
    add v15.8H, v15.8H, v31.8H             
    str q7, [x0, #32]                      
    sqrdmulh v20.8H, v17.8H, v12.8H        
    ldr q12, [x1, #608]                    
    ldr q7, [x1, #96]                      
    mul v17.8H, v17.8H, v16.8H             
    ldr q31, [x1, #528]                    
    str q25, [x0, #256]                    
    sqrdmulh v2.8H, v27.8H, v12.8H         
    ldr q23, [x1, #352]                    
    mls v17.8H, v20.8H, v0.8H              
    mul v12.8H, v27.8H, v7.8H              
    ldr q7, [x1, #832]                     
    mls v12.8H, v2.8H, v0.8H               
    ldr q2, [x1, #64]                      
    str q17, [x0, #80]                     
    sqrdmulh v20.8H, v5.8H, v29.8H         
    mul v2.8H, v18.8H, v2.8H               
    str q12, [x0, #96]                     
    ldr q12, [x1, #336]                    
    sqrdmulh v16.8H, v18.8H, v11.8H        
    sub v18.8H, v14.8H, v8.8H              
    ldr q8, [x1, #272]                     
    ldr q14, [x1, #800]                    
    sqrdmulh v11.8H, v21.8H, v31.8H        
    ldr q31, [x1, #784]                    
    sqrdmulh v27.8H, v18.8H, v9.8H         
    mul v25.8H, v18.8H, v12.8H             
    ldr q18, [x1, #320]                    
    ldr q12, [x1, #624]                    
    mul v17.8H, v21.8H, v13.8H             
    mul v29.8H, v1.8H, v18.8H              
    sqrdmulh v1.8H, v1.8H, v7.8H           
    mul v7.8H, v10.8H, v19.8H              
    sqrdmulh v19.8H, v10.8H, v14.8H        
    mul v18.8H, v30.8H, v23.8H             
    mul v14.8H, v15.8H, v26.8H             
    sqrdmulh v15.8H, v15.8H, v12.8H        
    mul v8.8H, v24.8H, v8.8H               
    sqrdmulh v12.8H, v24.8H, v31.8H        
    ldr q24, [x1, #864]                    
    mls v7.8H, v19.8H, v0.8H               
    sqrdmulh v23.8H, v30.8H, v24.8H        
    mls v14.8H, v15.8H, v0.8H              
    ldr q15, [x1, #304]                    
    str q7, [x0, #288]                     
    sqrdmulh v7.8H, v6.8H, v3.8H           
    mul v26.8H, v6.8H, v15.8H              
    str q14, [x0, #112]                    
    ldr q14, [x1, #48]                     
    mls v2.8H, v16.8H, v0.8H               
    mls v17.8H, v11.8H, v0.8H              
    ldr q11, [x1, #368]                    
    mls v29.8H, v1.8H, v0.8H               
    ldr q1, [x1, #512]                     
    str q2, [x0, #64]                      
    mul v2.8H, v5.8H, v11.8H               
    str q17, [x0, #16]                     
    mls v2.8H, v20.8H, v0.8H               
    ldr q20, [x1, #0]                      
    str q29, [x0, #320]                    
    mls v26.8H, v7.8H, v0.8H               
    mul v20.8H, v28.8H, v20.8H             
    str q2, [x0, #368]                     
    sqrdmulh v28.8H, v28.8H, v1.8H         
    str q26, [x0, #304]                    
    mls v8.8H, v12.8H, v0.8H               
    mls v25.8H, v27.8H, v0.8H              
    mls v20.8H, v28.8H, v0.8H              
    str q8, [x0, #272]                     
    mul v28.8H, v22.8H, v14.8H             
    str q25, [x0, #336]                    
    mls v28.8H, v4.8H, v0.8H               
    str q20, [x0, #0]                      
    mls v18.8H, v23.8H, v0.8H              
    str q28, [x0, #48]                     
    str q18, [x0, #352]                    

    pop_simd
    ret

.align 2
.global fnt_bot_opt
.global _fnt_bot_opt
fnt_bot_opt:
_fnt_bot_opt:

    push_simd
    src       .req x0
    twist     .req x1

    mov w3, 257
    dup v0.8H, w3

    ldr q18, [x0, #96]                     
    ldr q25, [x0, #224]                    
    ldr q11, [x0, #32]                     
    ldr q13, [x0, #160]                    
    ldr q19, [x0, #48]                     
    ldr q1, [x0, #112]                     
    ldr q27, [x0, #192]                    
    ldr q3, [x0, #176]                     
    sub v28.8H, v18.8H, v25.8H             
    ldr q15, [x0, #208]                    
    ldr q31, [x0, #240]                    
    add v7.8H, v18.8H, v25.8H              
    add v18.8H, v11.8H, v13.8H             
    ldr q25, [x0, #64]                     
    ldr q12, [x0, #0]                      
    ldr q10, [x0, #128]                    
    sub v4.8H, v11.8H, v13.8H              
    ldr q26, [x1, #352]                    
    add v6.8H, v19.8H, v3.8H               
    shl v17.8H, v28.8H, #4                 
    sub v20.8H, v18.8H, v7.8H              
    ldr q8, [x1, #480]                     
    add v14.8H, v1.8H, v31.8H              
    sub v22.8H, v1.8H, v31.8H              
    ldr q28, [x0, #144]                    
    sub v5.8H, v25.8H, v27.8H              
    ldr q30, [x1, #368]                    
    sub v9.8H, v19.8H, v3.8H               
    sub v16.8H, v4.8H, v17.8H              
    sub v29.8H, v6.8H, v14.8H              
    ldr q13, [x1, #112]                    
    sqrdmulh v21.8H, v20.8H, v26.8H        
    ldr q3, [x1, #240]                     
    ldr q1, [x0, #80]                      
    sub v24.8H, v12.8H, v10.8H             
    add v10.8H, v12.8H, v10.8H             
    ldr q26, [x1, #160]                    
    sqrdmulh v12.8H, v16.8H, v8.8H         
    ldr q31, [x1, #496]                    
    ldr q11, [x1, #176]                    
    shl v23.8H, v5.8H, #4                  
    sqrdmulh v30.8H, v29.8H, v30.8H        
    add v2.8H, v18.8H, v7.8H               
    ldr q8, [x1, #416]                     
    add v19.8H, v4.8H, v17.8H              
    mul v13.8H, v29.8H, v13.8H             
    shl v4.8H, v22.8H, #4                  
    sub v7.8H, v1.8H, v15.8H               
    ldr q18, [x0, #16]                     
    sqrdmulh v8.8H, v19.8H, v8.8H          
    sub v5.8H, v24.8H, v23.8H              
    sub v29.8H, v9.8H, v4.8H               
    shl v22.8H, v7.8H, #4                  
    mls v13.8H, v30.8H, v0.8H              
    add v9.8H, v9.8H, v4.8H                
    add v30.8H, v25.8H, v27.8H             
    sqrdmulh v4.8H, v29.8H, v31.8H         
    add v25.8H, v1.8H, v15.8H              
    ldr q15, [x1, #432]                    
    ldr q31, [x1, #192]                    
    mul v3.8H, v29.8H, v3.8H               
    sub v27.8H, v18.8H, v28.8H             
    ldr q29, [x1, #336]                    
    add v28.8H, v18.8H, v28.8H             
    mul v1.8H, v19.8H, v26.8H              
    add v26.8H, v6.8H, v14.8H              
    ldr q18, [x1, #144]                    
    mul v11.8H, v9.8H, v11.8H              
    ldr q6, [x1, #80]                      
    add v17.8H, v28.8H, v25.8H             
    ldr q14, [x1, #224]                    
    sub v7.8H, v27.8H, v22.8H              
    sqrdmulh v9.8H, v9.8H, v15.8H          
    add v15.8H, v27.8H, v22.8H             
    mls v1.8H, v8.8H, v0.8H                
    ldr q19, [x1, #400]                    
    ldr q22, [x1, #384]                    
    mul v18.8H, v15.8H, v18.8H             
    add v27.8H, v10.8H, v30.8H             
    sub v30.8H, v10.8H, v30.8H             
    sqrdmulh v10.8H, v15.8H, v19.8H        
    add v19.8H, v24.8H, v23.8H             
    trn1 v23.2D, v2.2D, v1.2D              
    ldr q24, [x1, #128]                    
    mls v11.8H, v9.8H, v0.8H               
    ldr q15, [x1, #320]                    
    sub v9.8H, v28.8H, v25.8H              
    trn2 v1.2D, v2.2D, v1.2D               
    sqrdmulh v8.8H, v19.8H, v22.8H         
    ldr q22, [x1, #64]                     
    mul v25.8H, v19.8H, v24.8H             
    ldr q24, [x1, #448]                    
    mls v18.8H, v10.8H, v0.8H              
    mls v3.8H, v4.8H, v0.8H                
    sqrdmulh v28.8H, v5.8H, v24.8H         
    ldr q24, [x1, #208]                    
    mls v25.8H, v8.8H, v0.8H               
    mul v19.8H, v16.8H, v14.8H             
    ldr q16, [x1, #464]                    
    mls v19.8H, v12.8H, v0.8H              
    sqrdmulh v10.8H, v7.8H, v16.8H         
    trn1 v16.2D, v13.2D, v3.2D             
    mul v12.8H, v7.8H, v24.8H              
    ldr q8, [x1, #96]                      
    mul v14.8H, v5.8H, v31.8H              
    mls v12.8H, v10.8H, v0.8H              
    sqrdmulh v10.8H, v9.8H, v29.8H         
    trn2 v31.2D, v13.2D, v3.2D             
    mul v13.8H, v9.8H, v6.8H               
    sqrdmulh v9.8H, v30.8H, v15.8H         
    mls v13.8H, v10.8H, v0.8H              
    mls v14.8H, v28.8H, v0.8H              
    trn1 v6.2D, v17.2D, v18.2D             
    trn1 v10.2D, v27.2D, v25.2D            
    mul v24.8H, v30.8H, v22.8H             
    trn2 v30.2D, v27.2D, v25.2D            
    trn2 v27.2D, v13.2D, v12.2D            
    mls v24.8H, v9.8H, v0.8H               
    trn1 v12.2D, v13.2D, v12.2D            
    trn2 v4.2D, v17.2D, v18.2D             
    mul v13.8H, v20.8H, v8.8H              
    str q27, [x0, #176]                    
    mls v13.8H, v21.8H, v0.8H              
    trn1 v25.2D, v26.2D, v11.2D            
    trn2 v29.2D, v26.2D, v11.2D            
    trn1 v28.2D, v24.2D, v14.2D            
    trn2 v14.2D, v24.2D, v14.2D            
    trn1 v11.2D, v13.2D, v19.2D            
    trn2 v15.2D, v13.2D, v19.2D            


    // loop 2
    // level3 to level6
     sub v8.8h,v10.8h,v23.8h
    sub v9.8h,v30.8h,v1.8h
    sub v18.8h,v6.8h,v25.8h
    sub v19.8h,v4.8h,v29.8h    
    add v23.8h,v10.8h,v23.8h
    add v1.8h,v30.8h,v1.8h
    add v25.8h,v6.8h,v25.8h
    add v29.8h,v4.8h,v29.8h

    sub v3.8h,v28.8h,v11.8h
    sub v13.8h,v14.8h,v15.8h
    sub v30.8h,v12.8h,v16.8h
    sub v7.8h,v27.8h,v31.8h    
    add v11.8h,v28.8h,v11.8h
    add v15.8h,v14.8h,v15.8h
    add v16.8h,v12.8h,v16.8h
    add v31.8h,v27.8h,v31.8h

    shl v18.8h,v18.8h,#4
    shl v19.8h,v19.8h,#4
    shl v30.8h,v30.8h,#4
    shl v7.8h,v7.8h,#4

    trn1 v20.4s, v25.4s, v16.4s
    trn2 v21.4s, v25.4s, v16.4s
    trn1 v28.4s, v18.4s, v30.4s
    trn1 v22.4s, v29.4s, v31.4s
    trn1 v16.4s, v23.4s, v11.4s
    trn2 v17.4s, v23.4s, v11.4s
    trn2 v23.4s, v29.4s, v31.4s
    trn2 v29.4s, v18.4s, v30.4s
    trn1 v18.4s, v1.4s,  v15.4s
    trn1 v30.4s, v19.4s, v7.4s
    trn2 v31.4s, v19.4s, v7.4s
    trn2 v19.4s, v1.4s,  v15.4s
    trn1 v24.4s, v8.4s,  v3.4s
    trn2 v25.4s, v8.4s,  v3.4s
    trn1 v26.4s, v9.4s,  v13.4s
    trn2 v27.4s, v9.4s,  v13.4s

    sub v8.8h,v16.8h,v20.8h
    sub v9.8h,v17.8h,v21.8h
    sub v10.8h,v18.8h,v22.8h
    sub v11.8h,v19.8h,v23.8h   
    add v20.8h,v16.8h,v20.8h
    add v21.8h,v17.8h,v21.8h
    add v22.8h,v18.8h,v22.8h
    add v23.8h,v19.8h,v23.8h

    sub v12.8h,v24.8h,v28.8h
    sub v13.8h,v25.8h,v29.8h
    sub v14.8h,v26.8h,v30.8h
    sub v15.8h,v27.8h,v31.8h   
    add v28.8h,v24.8h,v28.8h
    add v29.8h,v25.8h,v29.8h
    add v30.8h,v26.8h,v30.8h
    add v31.8h,v27.8h,v31.8h

    sshr v4.8h,v20.8h,#8
    sshr v5.8h,v21.8h,#8
    sshr v6.8h,v22.8h,#8
    sshr v7.8h,v23.8h,#8   
    bic v20.8h,#0xff,lsl #8
    bic v21.8h,#0xff,lsl #8
    bic v22.8h,#0xff,lsl #8
    bic v23.8h,#0xff,lsl #8 
    sub v16.8h,v20.8h,v4.8h
    sub v17.8h,v21.8h,v5.8h
    sub v18.8h,v22.8h,v6.8h
    sub v19.8h,v23.8h,v7.8h

    ldr q4,[x1,#0*16+576]
    ldr q5,[x1,#1*16+576]
    ldr q6,[x1,#2*16+576]
    ldr q7,[x1,#3*16+576] 
    mul v20.8h,v8.8h,v4.8h
    mul v21.8h,v9.8h,v5.8h
    mul v22.8h,v10.8h,v6.8h
    mul v23.8h,v11.8h,v7.8h    
    ldr q4,[x1,#256+0*16+576]
    ldr q5,[x1,#256+1*16+576]
    ldr q6,[x1,#256+2*16+576]
    ldr q7,[x1,#256+3*16+576] 
    sqrdmulh v8.8h,v8.8h,v4.8h
    sqrdmulh v9.8h,v9.8h,v5.8h
    sqrdmulh v10.8h,v10.8h,v6.8h
    sqrdmulh v11.8h,v11.8h,v7.8h   
    mls v20.8h,v8.8h,v0.8h
    mls v21.8h,v9.8h,v0.8h
    mls v22.8h,v10.8h,v0.8h
    mls v23.8h,v11.8h,v0.8h


    ldr q4,[x1,#0*16+640]
    ldr q5,[x1,#1*16+640]
    ldr q6,[x1,#2*16+640]
    ldr q7,[x1,#3*16+640] 
    mul v24.8h,v28.8h,v4.8h
    mul v25.8h,v29.8h,v5.8h
    mul v26.8h,v30.8h,v6.8h
    mul v27.8h,v31.8h,v7.8h    
    ldr q4,[x1,#256+0*16+640]
    ldr q5,[x1,#256+1*16+640]
    ldr q6,[x1,#256+2*16+640]
    ldr q7,[x1,#256+3*16+640] 
    sqrdmulh v28.8h,v28.8h,v4.8h
    sqrdmulh v29.8h,v29.8h,v5.8h
    sqrdmulh v30.8h,v30.8h,v6.8h
    sqrdmulh v31.8h,v31.8h,v7.8h   
    mls v24.8h,v28.8h,v0.8h
    mls v25.8h,v29.8h,v0.8h
    mls v26.8h,v30.8h,v0.8h
    mls v27.8h,v31.8h,v0.8h


    ldr q4,[x1,#0*16+704]
    ldr q5,[x1,#1*16+704]
    ldr q6,[x1,#2*16+704]
    ldr q7,[x1,#3*16+704] 
    mul v28.8h,v12.8h,v4.8h
    mul v29.8h,v13.8h,v5.8h
    mul v30.8h,v14.8h,v6.8h
    mul v31.8h,v15.8h,v7.8h    
    ldr q4,[x1,#256+0*16+704]
    ldr q5,[x1,#256+1*16+704]
    ldr q6,[x1,#256+2*16+704]
    ldr q7,[x1,#256+3*16+704] 
    sqrdmulh v12.8h,v12.8h,v4.8h
    sqrdmulh v13.8h,v13.8h,v5.8h
    sqrdmulh v14.8h,v14.8h,v6.8h
    sqrdmulh v15.8h,v15.8h,v7.8h   
    mls v28.8h,v12.8h,v0.8h
    mls v29.8h,v13.8h,v0.8h
    mls v30.8h,v14.8h,v0.8h
    mls v31.8h,v15.8h,v0.8h

    sub v8.8h,v16.8h,v18.8h
    sub v9.8h,v17.8h,v19.8h
    sub v10.8h,v20.8h,v22.8h
    sub v11.8h,v21.8h,v23.8h   
    add v18.8h,v16.8h,v18.8h
    add v19.8h,v17.8h,v19.8h
    add v22.8h,v20.8h,v22.8h
    add v23.8h,v21.8h,v23.8h

    sub v12.8h,v24.8h,v26.8h
    sub v13.8h,v25.8h,v27.8h
    sub v14.8h,v28.8h,v30.8h
    sub v15.8h,v29.8h,v31.8h   
    add v26.8h,v24.8h,v26.8h
    add v27.8h,v25.8h,v27.8h
    add v30.8h,v28.8h,v30.8h
    add v31.8h,v29.8h,v31.8h

    trn1 v16.8h, v18.8h, v26.8h
    trn2 v17.8h, v18.8h, v26.8h
    trn1 v18.8h, v19.8h, v27.8h
    trn2 v19.8h, v19.8h, v27.8h

    trn1 v24.8h, v22.8h, v30.8h
    trn2 v25.8h, v22.8h, v30.8h
    trn1 v26.8h, v23.8h, v31.8h
    trn2 v27.8h, v23.8h, v31.8h
    trn1 v20.8h, v8.8h, v12.8h
    trn2 v21.8h, v8.8h, v12.8h
    trn1 v22.8h, v9.8h, v13.8h
    trn2 v23.8h, v9.8h, v13.8h

    trn1 v28.8h, v10.8h, v14.8h
    trn2 v29.8h, v10.8h, v14.8h
    trn1 v30.8h, v11.8h, v15.8h
    trn2 v31.8h, v11.8h, v15.8h

    shl v22.8h,v22.8h,#4
    shl v23.8h,v23.8h,#4
    shl v30.8h,v30.8h,#4
    shl v31.8h,v31.8h,#4

    sub v8.8h,v16.8h,v18.8h
    sub v9.8h,v17.8h,v19.8h
    sub v10.8h,v20.8h,v22.8h
    sub v11.8h,v21.8h,v23.8h   
    add v18.8h,v16.8h,v18.8h
    add v19.8h,v17.8h,v19.8h
    add v22.8h,v20.8h,v22.8h
    add v23.8h,v21.8h,v23.8h

    sub v12.8h,v24.8h,v26.8h
    sub v13.8h,v25.8h,v27.8h
    sub v14.8h,v28.8h,v30.8h
    sub v15.8h,v29.8h,v31.8h   
    add v26.8h,v24.8h,v26.8h
    add v27.8h,v25.8h,v27.8h
    add v30.8h,v28.8h,v30.8h
    add v31.8h,v29.8h,v31.8h

    str q18, [x0, #0*16]
    str q19, [x0, #1*16]
    str q8, [x0, #2*16]
    str q9, [x0, #3*16]
    str q22, [x0, #4*16]
    str q23, [x0, #5*16]
    str q10, [x0, #6*16]
    str q11, [x0, #7*16]

    str q26, [x0, #8*16]
    str q27, [x0, #9*16]
    str q12, [x0, #10*16]
    str q13, [x0, #11*16]
    str q30, [x0, #12*16]
    str q31, [x0, #13*16]
    str q14, [x0, #14*16]
    str q15, [x0, #15*16]

    .unreq    src
    .unreq    twist
    pop_simd

    ret

