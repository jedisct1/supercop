



reg128 yplusx0123
reg128 yplusx4567
reg128 yplusx89
reg128 yminusx0123
reg128 yminusx4567
reg128 yminusx89
reg128 xy2d0123
reg128 xy2d4567
reg128 xy2d89
reg128 minusxy2d0123
reg128 minusxy2d4567
reg128 minusxy2d89
reg128 t

reg128 vmask
int32 mask
int32 u
int32 one

enter CRYPTO_NAMESPACE(ge_select)

one = 1
4x yplusx0123 = 0
yplusx0123 = one,yplusx0123[1,2,3]
4x yplusx4567 = 0
4x yplusx89 = 0
yminusx0123 = yplusx0123
4x yminusx4567 = 0
4x yminusx89 = 0
4x xy2d0123 = 0
4x xy2d4567 = 0
4x xy2d89 = 0

mask = input_2
u = input_2
mask signed>>= 7
u += mask
u ^= mask

mask ^= mask
=? u - 1
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t


mask ^= mask
=? u - 2
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t


mask ^= mask
=? u - 3
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t


mask ^= mask
=? u - 4
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t



mask ^= mask
=? u - 5
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t



mask ^= mask
=? u - 6
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t



mask ^= mask
=? u - 7
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t



mask ^= mask
=? u - 8
mask -= 1 if =
4x vmask = mask
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx0123
t &= vmask
yplusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx4567
t &= vmask
yplusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yplusx89
t &= vmask
yplusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= yminusx0123
t &= vmask
yminusx0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx4567
t &= vmask
yminusx4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= yminusx89
t &= vmask
yminusx89 ^= t

t aligned= mem128[input_1];input_1 += 16
t ^= xy2d0123
t &= vmask
xy2d0123 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d4567
t &= vmask
xy2d4567 ^= t
t aligned= mem128[input_1];input_1 += 16
t ^= xy2d89
t &= vmask
xy2d89 ^= t


mask ^= mask
signed<? input_2 - 0
mask -= 1 if signed<
4x vmask = mask

t = yplusx0123 ^ yminusx0123
t &= vmask
yplusx0123 ^= t
yminusx0123 ^= t
t = yplusx4567 ^ yminusx4567
t &= vmask
yplusx4567 ^= t
yminusx4567 ^= t
t = yplusx89 ^ yminusx89
t &= vmask
yplusx89 ^= t
yminusx89 ^= t

mem128[input_0] aligned= yplusx0123;input_0 += 16
mem128[input_0] aligned= yplusx4567;input_0 += 16
mem128[input_0] aligned= yplusx89;input_0 += 16

mem128[input_0] aligned= yminusx0123;input_0 += 16
mem128[input_0] aligned= yminusx4567;input_0 += 16
mem128[input_0] aligned= yminusx89;input_0 += 16

4x minusxy2d0123 = -xy2d0123
4x minusxy2d4567 = -xy2d4567
4x minusxy2d89 = -xy2d89
minusxy2d0123 ^= xy2d0123
minusxy2d4567 ^= xy2d4567
minusxy2d89 ^= xy2d89
minusxy2d0123 &= vmask
minusxy2d4567 &= vmask
minusxy2d89 &= vmask
xy2d0123 ^= minusxy2d0123
xy2d4567 ^= minusxy2d4567
xy2d89 ^= minusxy2d89


mem128[input_0] aligned= xy2d0123;input_0 += 16
mem128[input_0] aligned= xy2d4567;input_0 += 16
mem128[input_0] aligned= xy2d89;input_0 += 16

return
