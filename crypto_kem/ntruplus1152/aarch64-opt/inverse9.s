.text
.global packed_i9
packed_i9:
        mov w10, #3457
        ldr q26, [x2, #768]
        ldr q11, [x2, #1536]
        mov w8, #3469
        ldr q22, [x2, #1280]
        dup v16.8H, w8
        mov w8, #6844
        ldr q8, [x2, #512]
        ldr q12, [x2, #2048]
        ldr q3, [x3, #0]
        dup v17.8H, w10
        mov w10, #722
        ldr q23, [x2, #1792]
        dup v0.8H, w10
        ldr q4, [x2, #1024]
        ldr q13, [x3, #112]
        ldr q2, [x2, #256]
        sub v31.8H, v26.8H, v11.8H
        ldr q29, [x2, #0]
        dup v14.8H, w8
        sub v10.8H, v8.8H, v22.8H
        mul v30.8H, v31.8H, v0.8H
        add v5.8H, v12.8H, v8.8H
        sub v15.8H, v4.8H, v23.8H
        ldr q20, [x3, #32]
        add v24.8H, v5.8H, v22.8H
        mul v1.8H, v10.8H, v0.8H
        add v19.8H, v29.8H, v26.8H
        sqrdmulh v21.8H, v15.8H, v14.8H
        sub v6.8H, v2.8H, v23.8H
        add v27.8H, v19.8H, v11.8H
        sqrdmulh v28.8H, v10.8H, v14.8H
        add v9.8H, v2.8H, v4.8H
        mov w11, #366
        sub v5.8H, v27.8H, v24.8H
        mul v10.8H, v15.8H, v0.8H
        sub v15.8H, v29.8H, v11.8H
        mov w8, #1124
        sub v18.8H, v12.8H, v8.8H
        mls v10.8H, v21.8H, v17.8H
        add v25.8H, v9.8H, v23.8H
        sub v11.8H, v25.8H, v24.8H
        mls v1.8H, v28.8H, v17.8H
        sub v23.8H, v27.8H, v25.8H
        add v19.8H, v27.8H, v25.8H
        sqrdmulh v25.8H, v31.8H, v14.8H
        add v8.8H, v6.8H, v10.8H
        dup v6.8H, w11
        sub v28.8H, v12.8H, v22.8H
        sqrdmulh v27.8H, v11.8H, v14.8H
        mul v22.8H, v11.8H, v0.8H
        sub v12.8H, v2.8H, v4.8H
        mls v30.8H, v25.8H, v17.8H
        sub v11.8H, v12.8H, v10.8H
        mls v22.8H, v27.8H, v17.8H
        add v12.8H, v28.8H, v1.8H
        dup v9.8H, w8
        sub v28.8H, v18.8H, v1.8H
        mov w8, #10654
        sqrdmulh v21.8H, v8.8H, v16.8H
        sub v4.8H, v29.8H, v26.8H
        ldr q29, [x3, #256]
        mul v2.8H, v8.8H, v6.8H
        sub v27.8H, v4.8H, v30.8H
        dup v4.8H, w8
        add v7.8H, v5.8H, v22.8H
        mul v25.8H, v28.8H, v6.8H
        add v5.8H, v19.8H, v24.8H
        sqrdmulh v31.8H, v12.8H, v4.8H
        mul v26.8H, v12.8H, v9.8H
        mul v24.8H, v5.8H, v3.8H
        add v1.8H, v15.8H, v30.8H
        ldr q15, [x3, #96]
        sqrdmulh v13.8H, v7.8H, v13.8H
        mls v2.8H, v21.8H, v17.8H
        mul v10.8H, v11.8H, v9.8H
        ldr q9, [x3, #144]
        ldr q12, [x3, #16]
        ldr q19, [x3, #48]
        mls v26.8H, v31.8H, v17.8H
        sqrdmulh v8.8H, v11.8H, v4.8H
        sqrdmulh v11.8H, v28.8H, v16.8H
        mul v30.8H, v7.8H, v15.8H
        mls v10.8H, v8.8H, v17.8H
        add v8.8H, v1.8H, v2.8H
        mls v25.8H, v11.8H, v17.8H
        add v3.8H, v8.8H, v26.8H
        sub v11.8H, v2.8H, v26.8H
        sqrdmulh v16.8H, v3.8H, v19.8H
        mls v30.8H, v13.8H, v17.8H
        sub v4.8H, v27.8H, v25.8H
        sqrdmulh v13.8H, v11.8H, v14.8H
        sub v18.8H, v10.8H, v25.8H
        sqrdmulh v21.8H, v18.8H, v14.8H
        ldr q6, [x3, #208]
        sub v14.8H, v1.8H, v26.8H
        ldr q26, [x3, #80]
        sub v8.8H, v23.8H, v22.8H
        mul v22.8H, v11.8H, v0.8H
        str q30, [x0, #768]
        mul v30.8H, v18.8H, v0.8H
        sub v15.8H, v1.8H, v2.8H
        mls v30.8H, v21.8H, v17.8H
        ldr q11, [x3, #240]
        sqrdmulh v6.8H, v8.8H, v6.8H
        add v21.8H, v27.8H, v10.8H
        mls v22.8H, v13.8H, v17.8H
        add v7.8H, v4.8H, v30.8H
        ldr q13, [x3, #192]
        sqrdmulh v5.8H, v5.8H, v12.8H
        add v23.8H, v21.8H, v25.8H
        sub v25.8H, v27.8H, v10.8H
        sqrdmulh v28.8H, v7.8H, v26.8H
        ldr q26, [x3, #128]
        add v31.8H, v14.8H, v22.8H
        sub v0.8H, v15.8H, v22.8H
        mul v21.8H, v8.8H, v13.8H
        ldr q12, [x3, #224]
        mul v1.8H, v3.8H, v20.8H
        mls v1.8H, v16.8H, v17.8H
        mul v22.8H, v31.8H, v26.8H
        ldr q8, [x3, #160]
        sqrdmulh v15.8H, v31.8H, v9.8H
        ldr q19, [x3, #272]
        str q1, [x0, #256]
        mul v14.8H, v0.8H, v12.8H
        mls v21.8H, v6.8H, v17.8H
        sqrdmulh v6.8H, v23.8H, v19.8H
        sqrdmulh v2.8H, v0.8H, v11.8H
        str q21, [x0, #1536]
        mul v20.8H, v23.8H, v29.8H
        ldr q12, [x3, #176]
        mls v24.8H, v5.8H, v17.8H
        mls v14.8H, v2.8H, v17.8H
        mls v20.8H, v6.8H, v17.8H
        sub v2.8H, v25.8H, v30.8H
        mls v22.8H, v15.8H, v17.8H
        ldr q25, [x3, #64]
        str q24, [x0, #0]
        mul v30.8H, v2.8H, v8.8H
        str q14, [x0, #1792]
        sqrdmulh v9.8H, v2.8H, v12.8H
        str q22, [x0, #1024]
        mul v3.8H, v7.8H, v25.8H
        str q20, [x0, #2048]
        mls v3.8H, v28.8H, v17.8H
        mls v30.8H, v9.8H, v17.8H
        str q3, [x0, #512]
        str q30, [x0, #1280]
ret
