#define AES_BLOCK_LENGTH 32

#define ROTL32_64(x, b)                                         \
    ((x << b) & ((~(uint64_t) 0xffffffff << b) | 0xffffffff)) | \
        ((x >> (32 - b)) &                                      \
         ((0xffffffff >> (32 - b)) | (((uint64_t) 0xffffffff >> (32 - b)) << 32)))

#define LOAD64_LE(SRC) load64_le(SRC)
static inline uint64_t
load64_le(const uint8_t src[8])
{
#if defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    uint64_t w;
    memcpy(&w, src, sizeof w);
    return w;
#else
    uint64_t w = (uint64_t) src[0];
    w |= (uint64_t) src[1] << 8;
    w |= (uint64_t) src[2] << 16;
    w |= (uint64_t) src[3] << 24;
    w |= (uint64_t) src[4] << 32;
    w |= (uint64_t) src[5] << 40;
    w |= (uint64_t) src[6] << 48;
    w |= (uint64_t) src[7] << 56;
    return w;
#endif
}

#define STORE64_LE(DST, W) store64_le((DST), (W))
static inline void
store64_le(uint8_t dst[8], uint64_t w)
{
#if defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    memcpy(dst, &w, sizeof w);
#else
    dst[0] = (uint8_t) w;
    w >>= 8;
    dst[1] = (uint8_t) w;
    w >>= 8;
    dst[2] = (uint8_t) w;
    w >>= 8;
    dst[3] = (uint8_t) w;
    w >>= 8;
    dst[4] = (uint8_t) w;
    w >>= 8;
    dst[5] = (uint8_t) w;
    w >>= 8;
    dst[6] = (uint8_t) w;
    w >>= 8;
    dst[7] = (uint8_t) w;
#endif
}

#define SWAPMOVE(a, b, mask, n)                     \
    do {                                            \
        const uint64_t tmp = (b ^ (a >> n)) & mask; \
        b ^= tmp;                                   \
        a ^= (tmp << n);                            \
    } while (0)

typedef CRYPTO_ALIGN(32) uint64_t AesBlock[4];
typedef CRYPTO_ALIGN(64) uint64_t AesBlocks[32];
typedef uint64_t Sbox[8];
typedef uint8_t  AesBlocksBytes[2048];
typedef uint8_t  AesBlockBytesBase[16];
typedef uint8_t  AesBlockBytes[32];

static void
sbox(Sbox u)
{
    const uint64_t z24 = u[3] ^ u[4];
    const uint64_t q17 = u[1] ^ u[7];
    const uint64_t q16 = u[5] ^ q17;
    const uint64_t q0  = z24 ^ q16;
    const uint64_t q7  = z24 ^ u[1] ^ u[6];
    const uint64_t q2  = u[2] ^ q0;
    const uint64_t q1  = q7 ^ q2;
    const uint64_t q3  = u[0] ^ q7;
    const uint64_t q4  = u[0] ^ q2;
    const uint64_t q5  = u[1] ^ q4;
    const uint64_t q6  = u[2] ^ u[3];
    const uint64_t q10 = q6 ^ q7;
    const uint64_t q8  = u[0] ^ q10;
    const uint64_t q9  = q8 ^ q2;
    const uint64_t q12 = z24 ^ q17;
    const uint64_t q15 = u[7] ^ q4;
    const uint64_t q13 = z24 ^ q15;
    const uint64_t q14 = q15 ^ q0;
    const uint64_t q11 = u[5];

    const uint64_t t20 = NAND(q6, q12);
    const uint64_t t21 = NAND(q3, q14);
    const uint64_t t22 = NAND(q1, q16);
    const uint64_t x0  = NOR(q3, q14) ^ NAND(q0, q7) ^ (t20 ^ t22);
    const uint64_t x1  = NOR(q4, q13) ^ NAND(q10, q11) ^ (t21 ^ t20);
    const uint64_t x2  = NOR(q2, q17) ^ NAND(q5, q9) ^ (t21 ^ t22);
    const uint64_t x3  = NOR(q8, q15) ^ NAND(q2, q17) ^ (t21 ^ NAND(q4, q13));

    const uint64_t t2  = XNOR(NAND(x0, x2), NOR(x1, x3));
    const uint64_t y0  = MUX(x2, t2, x3);
    const uint64_t y2  = MUX(x0, t2, x1);
    const uint64_t y1  = MUX(t2, x3, MUX(x1, x2, ~0));
    const uint64_t y3  = MUX(t2, x1, MUX(x3, x0, ~0));
    const uint64_t y02 = y2 ^ y0;
    const uint64_t y13 = y3 ^ y1;
    const uint64_t y23 = y3 ^ y2;
    const uint64_t y01 = y1 ^ y0;
    const uint64_t y00 = y02 ^ y13;

    const uint64_t n0  = NAND(y01, q11);
    const uint64_t n1  = NAND(y0, q12);
    const uint64_t n2  = NAND(y1, q0);
    const uint64_t n3  = NAND(y23, q17);
    const uint64_t n4  = NAND(y2, q5);
    const uint64_t n5  = NAND(y3, q15);
    const uint64_t n6  = NAND(y13, q14);
    const uint64_t n7  = NAND(y00, q16);
    const uint64_t n8  = NAND(y02, q13);
    const uint64_t n9  = NAND(y01, q7);
    const uint64_t n10 = NAND(y0, q10);
    const uint64_t n11 = NAND(y1, q6);
    const uint64_t n12 = NAND(y23, q2);
    const uint64_t n13 = NAND(y2, q9);
    const uint64_t n14 = NAND(y3, q8);
    const uint64_t n15 = NAND(y13, q3);
    const uint64_t n16 = NAND(y00, q1);
    const uint64_t n17 = NAND(y02, q4);

    uint64_t h1, h2, h4, h5, h7, h8, h9, h10, h13, h14;
    h1   = n4 ^ n1 ^ n5;
    u[2] = XNOR(n2, h1);
    h2   = n9 ^ n15;
    u[6] = XNOR(h2, n11 ^ n17);
    h4   = n11 ^ n14;
    h5   = n9 ^ n12;
    u[5] = h4 ^ h5;
    h7   = u[2] ^ u[6];
    h8   = n10 ^ h7;
    u[7] = XNOR(n16 ^ h2, h8);
    h9   = n8 ^ h1;
    h10  = n13 ^ h8;
    u[3] = h5 ^ h10;
    h13  = h4 ^ n7 ^ h9 ^ h10;
    u[4] = n1 ^ h13;
    h14  = XNOR(n0, u[7]);
    u[1] = XNOR(n6, h7 ^ h9 ^ h14);
    u[0] = h13 ^ n3 ^ n4 ^ h14;
}

static void
sboxes(AesBlocks st)
{
    size_t i;

    for (i = 0; i < 4; i++) {
        sbox(st + 8 * i);
    }
}

static void
shiftrows(AesBlocks st)
{
    size_t i;

    for (i = 8; i < 16; i++) {
        st[i] = ROTL32_64(st[i], 24);
    }
    for (i = 16; i < 24; i++) {
        st[i] = ROTL32_64(st[i], 16);
    }
    for (i = 24; i < 32; i++) {
        st[i] = ROTL32_64(st[i], 8);
    }
}

static void
mixcolumns(AesBlocks st)
{
    uint64_t t2_0, t2_1, t2_2, t2_3;
    uint64_t t, t_bis, t0_0, t0_1, t0_2, t0_3;
    uint64_t t1_0, t1_1, t1_2, t1_3;

    t2_0   = st[0] ^ st[8];
    t2_1   = st[8] ^ st[16];
    t2_2   = st[16] ^ st[24];
    t2_3   = st[24] ^ st[0];
    t0_0   = st[7] ^ st[15];
    t0_1   = st[15] ^ st[23];
    t0_2   = st[23] ^ st[31];
    t0_3   = st[31] ^ st[7];
    t      = st[7];
    st[7]  = t2_0 ^ t0_2 ^ st[15];
    st[15] = t2_1 ^ t0_2 ^ t;
    t      = st[23];
    st[23] = t2_2 ^ t0_0 ^ st[31];
    st[31] = t2_3 ^ t0_0 ^ t;
    t1_0   = st[6] ^ st[14];
    t1_1   = st[14] ^ st[22];
    t1_2   = st[22] ^ st[30];
    t1_3   = st[30] ^ st[6];
    t      = st[6];
    st[6]  = t0_0 ^ t2_0 ^ st[14] ^ t1_2;
    t_bis  = st[14];
    st[14] = t0_1 ^ t2_1 ^ t1_2 ^ t;
    t      = st[22];
    st[22] = t0_2 ^ t2_2 ^ t1_3 ^ t_bis;
    st[30] = t0_3 ^ t2_3 ^ t1_0 ^ t;
    t0_0   = st[5] ^ st[13];
    t0_1   = st[13] ^ st[21];
    t0_2   = st[21] ^ st[29];
    t0_3   = st[29] ^ st[5];
    t      = st[5];
    st[5]  = t1_0 ^ t0_1 ^ st[29];
    t_bis  = st[13];
    st[13] = t1_1 ^ t0_2 ^ t;
    t      = st[21];
    st[21] = t1_2 ^ t0_3 ^ t_bis;
    st[29] = t1_3 ^ t0_0 ^ t;
    t1_0   = st[4] ^ st[12];
    t1_1   = st[12] ^ st[20];
    t1_2   = st[20] ^ st[28];
    t1_3   = st[28] ^ st[4];
    t      = st[4];
    st[4]  = t0_0 ^ t2_0 ^ t1_1 ^ st[28];
    t_bis  = st[12];
    st[12] = t0_1 ^ t2_1 ^ t1_2 ^ t;
    t      = st[20];
    st[20] = t0_2 ^ t2_2 ^ t1_3 ^ t_bis;
    st[28] = t0_3 ^ t2_3 ^ t1_0 ^ t;
    t0_0   = st[3] ^ st[11];
    t0_1   = st[11] ^ st[19];
    t0_2   = st[19] ^ st[27];
    t0_3   = st[27] ^ st[3];
    t      = st[3];
    st[3]  = t1_0 ^ t2_0 ^ t0_1 ^ st[27];
    t_bis  = st[11];
    st[11] = t1_1 ^ t2_1 ^ t0_2 ^ t;
    t      = st[19];
    st[19] = t1_2 ^ t2_2 ^ t0_3 ^ t_bis;
    st[27] = t1_3 ^ t2_3 ^ t0_0 ^ t;
    t1_0   = st[2] ^ st[10];
    t1_1   = st[10] ^ st[18];
    t1_2   = st[18] ^ st[26];
    t1_3   = st[26] ^ st[2];
    t      = st[2];
    st[2]  = t0_0 ^ t1_1 ^ st[26];
    t_bis  = st[10];
    st[10] = t0_1 ^ t1_2 ^ t;
    t      = st[18];
    st[18] = t0_2 ^ t1_3 ^ t_bis;
    st[26] = t0_3 ^ t1_0 ^ t;
    t0_0   = st[1] ^ st[9];
    t0_1   = st[9] ^ st[17];
    t0_2   = st[17] ^ st[25];
    t0_3   = st[25] ^ st[1];
    t      = st[1];
    st[1]  = t1_0 ^ t0_1 ^ st[25];
    t_bis  = st[9];
    st[9]  = t1_1 ^ t0_2 ^ t;
    t      = st[17];
    st[17] = t1_2 ^ t0_3 ^ t_bis;
    st[25] = t1_3 ^ t0_0 ^ t;
    t      = st[0];
    st[0]  = t0_0 ^ t2_1 ^ st[24];
    t_bis  = st[8];
    st[8]  = t0_1 ^ t2_2 ^ t;
    t      = st[16];
    st[16] = t0_2 ^ t2_3 ^ t_bis;
    st[24] = t0_3 ^ t2_0 ^ t;
}

static void
aes_round(AesBlocks st)
{
    sboxes(st);
    shiftrows(st);
    mixcolumns(st);
}

static void
pack04(AesBlocks st)
{
    size_t i;

    SWAPMOVE(st[0], st[0 + 8], 0x00ff00ff00ff00ff, 8);
    SWAPMOVE(st[0 + 16], st[0 + 24], 0x00ff00ff00ff00ff, 8);
    SWAPMOVE(st[4], st[4 + 8], 0x00ff00ff00ff00ff, 8);
    SWAPMOVE(st[4 + 16], st[4 + 24], 0x00ff00ff00ff00ff, 8);

    SWAPMOVE(st[0], st[0 + 16], 0x0000ffff0000ffff, 16);
    SWAPMOVE(st[4], st[4 + 16], 0x0000ffff0000ffff, 16);
    SWAPMOVE(st[8], st[8 + 16], 0x0000ffff0000ffff, 16);
    SWAPMOVE(st[12], st[12 + 16], 0x0000ffff0000ffff, 16);

    for (i = 0; i < 32; i += 8) {
        SWAPMOVE(st[i + 1], st[i], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 5], st[i + 4], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 2], st[i], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 3], st[i + 1], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 6], st[i + 4], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 7], st[i + 5], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 4], st[i], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 5], st[i + 1], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 6], st[i + 2], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 7], st[i + 3], 0x0f0f0f0f0f0f0f0f, 4);
    }
}

static void
pack(AesBlocks st)
{
    size_t i;

    for (i = 0; i < 8; i++) {
        SWAPMOVE(st[i], st[i + 8], 0x00ff00ff00ff00ff, 8);
        SWAPMOVE(st[i + 16], st[i + 24], 0x00ff00ff00ff00ff, 8);
    }
    for (i = 0; i < 16; i++) {
        SWAPMOVE(st[i], st[i + 16], 0x0000ffff0000ffff, 16);
    }
    for (i = 0; i < 32; i += 8) {
        SWAPMOVE(st[i + 1], st[i], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 3], st[i + 2], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 5], st[i + 4], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 7], st[i + 6], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 2], st[i], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 3], st[i + 1], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 6], st[i + 4], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 7], st[i + 5], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 4], st[i], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 5], st[i + 1], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 6], st[i + 2], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 7], st[i + 3], 0x0f0f0f0f0f0f0f0f, 4);
    }
}

static void
unpack(AesBlocks st)
{
    size_t i;

    for (i = 0; i < 32; i += 8) {
        SWAPMOVE(st[i + 1], st[i], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 3], st[i + 2], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 5], st[i + 4], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 7], st[i + 6], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 2], st[i], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 3], st[i + 1], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 6], st[i + 4], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 7], st[i + 5], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 4], st[i], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 5], st[i + 1], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 6], st[i + 2], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 7], st[i + 3], 0x0f0f0f0f0f0f0f0f, 4);
    }
    for (i = 0; i < 16; i++) {
        SWAPMOVE(st[i], st[i + 16], 0x0000ffff0000ffff, 16);
    }
    for (i = 0; i < 8; i++) {
        SWAPMOVE(st[i], st[i + 8], 0x00ff00ff00ff00ff, 8);
        SWAPMOVE(st[i + 16], st[i + 24], 0x00ff00ff00ff00ff, 8);
    }
}

static inline size_t
word_idx(const size_t block, const size_t word)
{
    return block + word * 8;
}

static inline void
blocks_rotr(AesBlocks st)
{
    size_t i;

    for (i = 0; i < 32; i++) {
        st[i] = (st[i] & 0xfefefefefefefefe) >> 1 | (st[i] & 0x0101010101010101) << 7;
    }
}

static inline void
blocks_put(AesBlocks st, const AesBlock s, const size_t block)
{
    size_t i;

    for (i = 0; i < 4; i++) {
        st[word_idx(block, i)] = s[i];
    }
}

static inline void
blocks_get(AesBlock s, const AesBlocks st, const size_t block)
{
    size_t i;

    for (i = 0; i < 4; i++) {
        s[i] = st[word_idx(block, i)];
    }
}

static inline void
block_from_bytes(AesBlock out, const AesBlockBytes in)
{
    out[1] = LOAD64_LE(in + 8 * 0);
    out[3] = LOAD64_LE(in + 8 * 1);
    out[0] = LOAD64_LE(in + 8 * 2);
    out[2] = LOAD64_LE(in + 8 * 3);
    SWAPMOVE(out[0], out[1], 0x00000000ffffffff, 32);
    SWAPMOVE(out[2], out[3], 0x00000000ffffffff, 32);
}

static inline void
block_to_bytes(AesBlockBytes out, AesBlock in)
{
    SWAPMOVE(in[2], in[3], 0x00000000ffffffff, 32);
    SWAPMOVE(in[0], in[1], 0x00000000ffffffff, 32);
    STORE64_LE(out + 8 * 0, in[1]);
    STORE64_LE(out + 8 * 1, in[3]);
    STORE64_LE(out + 8 * 2, in[0]);
    STORE64_LE(out + 8 * 3, in[2]);
}

static void
block_from_broadcast(AesBlock out, const AesBlockBytesBase in)
{
    AesBlockBytes tmp;

    memcpy(tmp, in, 16);
    memcpy(tmp + 16, in, 16);

    return block_from_bytes(out, tmp);
}

static inline void
block_xor(AesBlock out, const AesBlock a, const AesBlock b)
{
    size_t i;

    for (i = 0; i < 4; i++) {
        out[i] = a[i] ^ b[i];
    }
}

static inline void
blocks_xor(AesBlocks a, const AesBlocks b)
{
    size_t i;

    for (i = 0; i < 32; i++) {
        a[i] ^= b[i];
    }
}

static inline void
fold_base_block_to_bytes(uint8_t bytes[16], const AesBlock b)
{
    size_t i;

    for (i = 0; i < 4; i++) {
        STORE32_LE(bytes + i * 4, (uint32_t) b[i] ^ (uint32_t) (b[i] >> 32));
    }
}

static void
sbox2(Sbox u)
{
    const uint64_t z24 = u[3] ^ u[4];
    const uint64_t q17 = u[1] ^ u[7];
    const uint64_t q16 = u[5] ^ q17;
    const uint64_t q0  = z24 ^ q16;
    const uint64_t q7  = z24 ^ u[1] ^ u[6];
    const uint64_t q2  = u[2] ^ q0;
    const uint64_t q1  = q7 ^ q2;
    const uint64_t q3  = u[0] ^ q7;
    const uint64_t q4  = u[0] ^ q2;
    const uint64_t q5  = u[1] ^ q4;
    const uint64_t q6  = u[2] ^ u[3];
    const uint64_t q10 = q6 ^ q7;
    const uint64_t q8  = u[0] ^ q10;
    const uint64_t q9  = q8 ^ q2;
    const uint64_t q12 = z24 ^ q17;
    const uint64_t q15 = u[7] ^ q4;
    const uint64_t q13 = z24 ^ q15;
    const uint64_t q14 = q15 ^ q0;
    const uint64_t q11 = u[5];

    const uint64_t t20 = NAND(q6, q12);
    const uint64_t t21 = NAND(q3, q14);
    const uint64_t t22 = NAND(q1, q16);
    const uint64_t x0  = NOR(q3, q14) ^ NAND(q0, q7) ^ (t20 ^ t22);
    const uint64_t x1  = NOR(q4, q13) ^ NAND(q10, q11) ^ (t21 ^ t20);
    const uint64_t x2  = NOR(q2, q17) ^ NAND(q5, q9) ^ (t21 ^ t22);
    const uint64_t x3  = NOR(q8, q15) ^ NAND(q2, q17) ^ (t21 ^ NAND(q4, q13));

    const uint64_t t2  = XNOR(NAND(x0, x2), NOR(x1, x3));
    const uint64_t y0  = MUX(x2, t2, x3);
    const uint64_t y2  = MUX(x0, t2, x1);
    const uint64_t y1  = MUX(t2, x3, MUX(x1, x2, ~0));
    const uint64_t y3  = MUX(t2, x1, MUX(x3, x0, ~0));
    const uint64_t y02 = y2 ^ y0;
    const uint64_t y13 = y3 ^ y1;
    const uint64_t y23 = y3 ^ y2;
    const uint64_t y01 = y1 ^ y0;
    const uint64_t y00 = y02 ^ y13;

    const uint64_t n0  = NAND(y01, q11);
    const uint64_t n1  = NAND(y0, q12);
    const uint64_t n2  = NAND(y1, q0);
    const uint64_t n3  = NAND(y23, q17);
    const uint64_t n4  = NAND(y2, q5);
    const uint64_t n5  = NAND(y3, q15);
    const uint64_t n6  = NAND(y13, q14);
    const uint64_t n7  = NAND(y00, q16);
    const uint64_t n8  = NAND(y02, q13);
    const uint64_t n9  = NAND(y01, q7);
    const uint64_t n10 = NAND(y0, q10);
    const uint64_t n11 = NAND(y1, q6);
    const uint64_t n12 = NAND(y23, q2);
    const uint64_t n13 = NAND(y2, q9);
    const uint64_t n14 = NAND(y3, q8);
    const uint64_t n15 = NAND(y13, q3);
    const uint64_t n16 = NAND(y00, q1);
    const uint64_t n17 = NAND(y02, q4);

    uint64_t h1, h2, h4, h5, h7, h8, h9, h10, h13, h14;
    h1   = n4 ^ n1 ^ n5;
    u[2] = XNOR(n2, h1);
    h2   = n9 ^ n15;
    u[6] = XNOR(h2, n11 ^ n17);
    h4   = n11 ^ n14;
    h5   = n9 ^ n12;
    u[5] = h4 ^ h5;
    h7   = u[2] ^ u[6];
    h8   = n10 ^ h7;
    u[7] = XNOR(n16 ^ h2, h8);
    h9   = n8 ^ h1;
    h10  = n13 ^ h8;
    u[3] = h5 ^ h10;
    h13  = h4 ^ n7 ^ h9 ^ h10;
    u[4] = n1 ^ h13;
    h14  = XNOR(n0, u[7]);
    u[1] = XNOR(n6, h7 ^ h9 ^ h14);
    u[0] = h13 ^ n3 ^ n4 ^ h14;
}

static void
sboxes2(AesBlocks st)
{
    size_t i;

    for (i = 0; i < 4; i++) {
        sbox2(st + 8 * i);
    }
}

static void
shiftrows2(AesBlocks st)
{
    size_t i;

    for (i = 8; i < 16; i++) {
        st[i] = ROTL32_64(st[i], 24);
    }
    for (i = 16; i < 24; i++) {
        st[i] = ROTL32_64(st[i], 16);
    }
    for (i = 24; i < 32; i++) {
        st[i] = ROTL32_64(st[i], 8);
    }
}

static void
mixcolumns2(AesBlocks st)
{
    uint64_t t2_0, t2_1, t2_2, t2_3;
    uint64_t t, t_bis, t0_0, t0_1, t0_2, t0_3;
    uint64_t t1_0, t1_1, t1_2, t1_3;

    t2_0   = st[0] ^ st[8];
    t2_1   = st[8] ^ st[16];
    t2_2   = st[16] ^ st[24];
    t2_3   = st[24] ^ st[0];
    t0_0   = st[7] ^ st[15];
    t0_1   = st[15] ^ st[23];
    t0_2   = st[23] ^ st[31];
    t0_3   = st[31] ^ st[7];
    t      = st[7];
    st[7]  = t2_0 ^ t0_2 ^ st[15];
    st[15] = t2_1 ^ t0_2 ^ t;
    t      = st[23];
    st[23] = t2_2 ^ t0_0 ^ st[31];
    st[31] = t2_3 ^ t0_0 ^ t;
    t1_0   = st[6] ^ st[14];
    t1_1   = st[14] ^ st[22];
    t1_2   = st[22] ^ st[30];
    t1_3   = st[30] ^ st[6];
    t      = st[6];
    st[6]  = t0_0 ^ t2_0 ^ st[14] ^ t1_2;
    t_bis  = st[14];
    st[14] = t0_1 ^ t2_1 ^ t1_2 ^ t;
    t      = st[22];
    st[22] = t0_2 ^ t2_2 ^ t1_3 ^ t_bis;
    st[30] = t0_3 ^ t2_3 ^ t1_0 ^ t;
    t0_0   = st[5] ^ st[13];
    t0_1   = st[13] ^ st[21];
    t0_2   = st[21] ^ st[29];
    t0_3   = st[29] ^ st[5];
    t      = st[5];
    st[5]  = t1_0 ^ t0_1 ^ st[29];
    t_bis  = st[13];
    st[13] = t1_1 ^ t0_2 ^ t;
    t      = st[21];
    st[21] = t1_2 ^ t0_3 ^ t_bis;
    st[29] = t1_3 ^ t0_0 ^ t;
    t1_0   = st[4] ^ st[12];
    t1_1   = st[12] ^ st[20];
    t1_2   = st[20] ^ st[28];
    t1_3   = st[28] ^ st[4];
    t      = st[4];
    st[4]  = t0_0 ^ t2_0 ^ t1_1 ^ st[28];
    t_bis  = st[12];
    st[12] = t0_1 ^ t2_1 ^ t1_2 ^ t;
    t      = st[20];
    st[20] = t0_2 ^ t2_2 ^ t1_3 ^ t_bis;
    st[28] = t0_3 ^ t2_3 ^ t1_0 ^ t;
    t0_0   = st[3] ^ st[11];
    t0_1   = st[11] ^ st[19];
    t0_2   = st[19] ^ st[27];
    t0_3   = st[27] ^ st[3];
    t      = st[3];
    st[3]  = t1_0 ^ t2_0 ^ t0_1 ^ st[27];
    t_bis  = st[11];
    st[11] = t1_1 ^ t2_1 ^ t0_2 ^ t;
    t      = st[19];
    st[19] = t1_2 ^ t2_2 ^ t0_3 ^ t_bis;
    st[27] = t1_3 ^ t2_3 ^ t0_0 ^ t;
    t1_0   = st[2] ^ st[10];
    t1_1   = st[10] ^ st[18];
    t1_2   = st[18] ^ st[26];
    t1_3   = st[26] ^ st[2];
    t      = st[2];
    st[2]  = t0_0 ^ t1_1 ^ st[26];
    t_bis  = st[10];
    st[10] = t0_1 ^ t1_2 ^ t;
    t      = st[18];
    st[18] = t0_2 ^ t1_3 ^ t_bis;
    st[26] = t0_3 ^ t1_0 ^ t;
    t0_0   = st[1] ^ st[9];
    t0_1   = st[9] ^ st[17];
    t0_2   = st[17] ^ st[25];
    t0_3   = st[25] ^ st[1];
    t      = st[1];
    st[1]  = t1_0 ^ t0_1 ^ st[25];
    t_bis  = st[9];
    st[9]  = t1_1 ^ t0_2 ^ t;
    t      = st[17];
    st[17] = t1_2 ^ t0_3 ^ t_bis;
    st[25] = t1_3 ^ t0_0 ^ t;
    t      = st[0];
    st[0]  = t0_0 ^ t2_1 ^ st[24];
    t_bis  = st[8];
    st[8]  = t0_1 ^ t2_2 ^ t;
    t      = st[16];
    st[16] = t0_2 ^ t2_3 ^ t_bis;
    st[24] = t0_3 ^ t2_0 ^ t;
}

static void
aes_round2(AesBlocks st)
{
    sboxes2(st);
    shiftrows2(st);
    mixcolumns2(st);
}

static void
pack2(AesBlocks st)
{
    size_t i;

    for (i = 0; i < 8; i++) {
        SWAPMOVE(st[i], st[i + 8], 0x00ff00ff00ff00ff, 8);
        SWAPMOVE(st[i + 16], st[i + 24], 0x00ff00ff00ff00ff, 8);
    }
    for (i = 0; i < 16; i++) {
        SWAPMOVE(st[i], st[i + 16], 0x0000ffff0000ffff, 16);
    }
    for (i = 0; i < 32; i += 8) {
        SWAPMOVE(st[i + 1], st[i], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 3], st[i + 2], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 5], st[i + 4], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 7], st[i + 6], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 2], st[i], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 3], st[i + 1], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 6], st[i + 4], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 7], st[i + 5], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 4], st[i], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 5], st[i + 1], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 6], st[i + 2], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 7], st[i + 3], 0x0f0f0f0f0f0f0f0f, 4);
    }
}

static void
unpack2(AesBlocks st)
{
    size_t i;

    for (i = 0; i < 32; i += 8) {
        SWAPMOVE(st[i + 1], st[i], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 3], st[i + 2], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 5], st[i + 4], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 7], st[i + 6], 0x5555555555555555, 1);
        SWAPMOVE(st[i + 2], st[i], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 3], st[i + 1], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 6], st[i + 4], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 7], st[i + 5], 0x3333333333333333, 2);
        SWAPMOVE(st[i + 4], st[i], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 5], st[i + 1], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 6], st[i + 2], 0x0f0f0f0f0f0f0f0f, 4);
        SWAPMOVE(st[i + 7], st[i + 3], 0x0f0f0f0f0f0f0f0f, 4);
    }
    for (i = 0; i < 16; i++) {
        SWAPMOVE(st[i], st[i + 16], 0x0000ffff0000ffff, 16);
    }
    for (i = 0; i < 8; i++) {
        SWAPMOVE(st[i], st[i + 8], 0x00ff00ff00ff00ff, 8);
        SWAPMOVE(st[i + 16], st[i + 24], 0x00ff00ff00ff00ff, 8);
    }
}