.text
.macro SUPPORT name, raw
.global \name
.global _\name
_\name:
\name:
 stp x29,x30,[sp,#-80]!
 stp d8,d9,[sp,#16]
 stp d10,d11,[sp,#32]
 stp d12,d13,[sp,#48]
 stp d14,d15,[sp,#64]
 bl \raw
 ldp d8,d9,[sp,#16]
 ldp d10,d11,[sp,#32]
 ldp d12,d13,[sp,#48]
 ldp d14,d15,[sp,#64]
 ldp x29,x30,[sp],#80
 ret
.endm
SUPPORT poly_cbd1, raw_poly_cbd1
SUPPORT poly_sotp_encode, raw_poly_sotp_encode
SUPPORT poly_sotp_decode, raw_poly_sotp_decode
SUPPORT poly_sub, raw_poly_sub
SUPPORT poly_triple, raw_poly_triple
