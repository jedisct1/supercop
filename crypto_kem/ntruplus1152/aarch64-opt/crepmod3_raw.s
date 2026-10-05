.text
.p2align 4
.global crepmod3_ternary_asm
crepmod3_ternary_asm:
mov w4, #1728
dup v0.8h, w4
mov w4, #-1728
dup v1.8h, w4
mov w4, #10923
dup v2.8h, w4
movi v3.8h, #3
mov x8, #36
.Lcrepmod3_loop:
        ldr q29, [x0, #0]
        ldr q20, [x0, #16]
        ldr q19, [x0, #32]
        ldr q30, [x0, #48]
        cmgt v21.8H, v29.8H, v0.8H
        cmgt v6.8H, v1.8H, v29.8H
        cmgt v31.8H, v20.8H, v0.8H
        cmgt v17.8H, v1.8H, v20.8H
        add v7.8H, v29.8H, v21.8H
        cmgt v28.8H, v19.8H, v0.8H
        add v22.8H, v20.8H, v31.8H
        cmgt v18.8H, v1.8H, v19.8H
        sub v25.8H, v7.8H, v6.8H
        add v7.8H, v19.8H, v28.8H
        sub v29.8H, v22.8H, v17.8H
        cmgt v16.8H, v30.8H, v0.8H
        sqrdmulh v21.8H, v25.8H, v2.8H
        sub v6.8H, v7.8H, v18.8H
        cmgt v20.8H, v1.8H, v30.8H
        sqrdmulh v31.8H, v29.8H, v2.8H
        add v16.8H, v30.8H, v16.8H
        sqrdmulh v26.8H, v6.8H, v2.8H
        sub v30.8H, v16.8H, v20.8H
        mls v25.8H, v21.8H, v3.8H
        sqrdmulh v16.8H, v30.8H, v2.8H
        mls v29.8H, v31.8H, v3.8H
        str q25, [x0, #0]
        mls v6.8H, v26.8H, v3.8H
        mls v30.8H, v16.8H, v3.8H
        str q29, [x0, #16]
        str q6, [x0, #32]
        str q30, [x0, #48]
add x0, x0, #64
subs x8, x8, #1
b.ne .Lcrepmod3_loop
ret
