/*
    This file is part of the mqq-sig package for SUPERCOP.
    Copyright (C) 2010 Rune E. Jensen (runeerle@stud.ntnu.no),
                   Danilo Gligoroski (danilog@item.ntnu.no)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
/*
 * \author Rune E. Jensen and Danilo Gligoroski
 * \license GPLv3 or later
 *
 */

/*
   C code for MQQ-SIGN

   History of this code:
   Programmed by
   Danilo Gligoroski, Rune E. Jensen and Daniel Otte
   March 2010.

   Verified by Danilo Gligoroski
   March 2010.

   Tuned and optimized (supercop version) by Rune E. Jensen
   June 2010.

   Table look-up code added and verified by Rune E. Jensen
   September 2010

   Added more SSE code and additional performance improvements by Rune E. Jensen
   December 2010

*/
#pragma once

#include <array>
#include <cmath>
#include <cstdint>
#include <ctime>
#include <vector>
#ifdef _MSC_VER
#include <intrin.h>
#endif

#ifdef _MSC_VER
#define MQQALIGNED(x) __declspec(align(x))
#else
#define MQQALIGNED(x) __attribute__((aligned(x)))
#endif

#ifdef N
#undef N
#endif
#define N 160

#ifndef min
#define min(a, b) (((a) < (b)) ? (a) : (b))
#endif

namespace mqq160
{

constexpr size_t MQQBITS = 160;
constexpr size_t MQQBYTES = MQQBITS / 8;
constexpr size_t SIGNATURE_SIZE = MQQBYTES;
constexpr size_t PUBLICKEY_SIZE = 206112;
constexpr size_t PRIVATEKEY_SIZE = 410;

struct CONTEXT
{
    MQQALIGNED(16) uint8_t mqq_a[9 * 9];
    MQQALIGNED(16) uint8_t cc1[9];
    MQQALIGNED(16) uint8_t cc2[9];
    MQQALIGNED(16) uint8_t sigma1[160];
    MQQALIGNED(16) uint8_t sigmaK[160];
    MQQALIGNED(16) uint8_t privateKeyLookupTable[256 * 256 * 2];
    CONTEXT(const uint8_t sk[PRIVATEKEY_SIZE]);
};

// Select the number of bytes stored in each row of the public key.
// Padded with zeroes if needed for performance reasons (SSE2).
constexpr size_t kPublicKeyCols = 128 / 8;
constexpr size_t kSymbolicNnSize = 1 + MQQBITS + (MQQBITS * MQQBITS - MQQBITS) / 2;
constexpr size_t kPublicKeyRows = kSymbolicNnSize + 1;
constexpr size_t kPublicKeyRowsToStore = ((MQQBITS * 3) / 4); // Select how many rows to include in the public key
constexpr size_t kPublicKeyFirstRow = (MQQBITS - kPublicKeyRowsToStore);
constexpr size_t kPublicKeyLastRow = (kPublicKeyFirstRow + kPublicKeyRowsToStore);

// The ranks of the quasigroup h1 must all have this value, or greater. Affects key generation
// speed and (possibly) the security.
// Conditions (3a) and (3b) in the Technical Description Paper
constexpr size_t kMinRankQuasiGroup = 12;
// The max rank is only intended to be changed for debugging (MQQ cracking).
constexpr size_t kMaxRankQuasiGroup = 16;
// At least one of the ranks in h1 must be this value.
// Note: Ranks are always even, and can never be larger than 14.
constexpr size_t kMinRankOnceQuasiGroup = 14;
// Set minimum count of the number of kMinRankOnceQuasiGroup
constexpr size_t kMinRankOnceQuasiGroupCount = 1;

constexpr size_t kSigmaElementByteSize = 1; // SIGMA_ELEMENT_BYTE_SIZE
using uint_sigma = uint8_t;
using uint_sigma_calc = uint8_t;

constexpr size_t kPublicKeySize = (kPublicKeyRows * kPublicKeyCols);
constexpr size_t kPrivateKeySize = (MQQBITS * kSigmaElementByteSize * 2 + 9 * 9 + 9);
static_assert(PUBLICKEY_SIZE == kPublicKeySize, "Public key size mismatch");
static_assert(PRIVATEKEY_SIZE == kPrivateKeySize, "Private key size mismatchs");

static_assert(kPublicKeyRowsToStore <= MQQBITS, "Number of rows (PUBLICKEY_ROWS_TO_STORE) greater than N");
static_assert(kPublicKeyRowsToStore <= kPublicKeyCols * 8, "Public key size (kPublicKeyCols) too small");
static_assert((kPublicKeyRowsToStore % 8) == 0, "Public key size (PUBLICKEY_ROWS_TO_STORE) must be a factor of 8");
static_assert(kPublicKeyLastRow <= MQQBITS, "kPublicKeyLastRow is out of range");
static_assert(N >= kPublicKeyCols * 8, "Public key size (kPublicKeyCols) too large");

template<typename T, size_t ROWS, size_t COLS>
class Matrix
{
public:
    // Create matrix with internal memory
    Matrix()
        : sz(ROWS * COLS)
        , buffer(ROWS * COLS)
        , mp(buffer.data())
    {
    }

    // Attach to external memory
    explicit Matrix(T* p)
        : sz(ROWS * COLS)
        , mp(p)
    {
    }

    bool empty() const { return nullptr == mp; }
    T* operator[](size_t row) { return row < ROWS ? (mp + row * COLS) : nullptr; }
    const T* operator[](size_t row) const { return row < ROWS ? (mp + row * COLS) : nullptr; }
    size_t rows() const { return ROWS; }
    size_t columns() const { return COLS; }
    // size of the matrix (count of elements)
    size_t size() const { return sz; }
    size_t sizeInBytes() const { return sz * sizeof(T); }
    T* data() { return mp; }
    const T* data() const { return mp; }

private:
    const size_t sz; // count of elements (the size of matrix)
    std::vector<T> buffer;
    T* mp = nullptr;
};

template<typename T, size_t ROWS, size_t COLS>
class MatrixView
{
public:
    explicit MatrixView(const T* p)
        : buffer(p)
    {
    }

    MatrixView(MatrixView& rh)
        : buffer(rh.buffer)
    {
    }

    explicit MatrixView(const Matrix<T, ROWS, COLS>& m)
        : buffer(m.data())
    {
    }

    const T* operator[](size_t row) const { return row < ROWS ? (buffer + row * COLS) : nullptr; }
    size_t rows() const { return ROWS; }
    size_t columns() const { return COLS; }
    size_t size() const { return ROWS * COLS; }

private:
    const T* buffer = nullptr;
};

int randomNum()
{
    return rand();
}
void srandomNum(int seed)
{
    srand(seed);
}

//template<size_t BITS>
//std::vector<uint8_t> blake3(const void* data, size_t size)
//{
//    uint8_t blake3res[64]{};
//    blake3_hasher hasher;
//    blake3_hasher_init(&hasher);
//    blake3_hasher_update(&hasher, static_cast<const unsigned char*>(data), size);
//    blake3_hasher_finalize(&hasher, blake3res, BITS);
//    return std::vector(blake3res, blake3res + BITS);
//}

// Saving of the public key to buffer
void savePublicKey(const Matrix<uint8_t, N, kSymbolicNnSize>& xxFinale, Matrix<uint8_t, kPublicKeyRows, kPublicKeyCols>& publicKey)
{
    // Make the publicKey in the binary format
    for (uint_fast16_t i = 0; i < kSymbolicNnSize; i++)
        for (uint_fast8_t j = kPublicKeyFirstRow; j < kPublicKeyLastRow; j++)
        {
            uint_fast8_t byteindex = j >> 3;
            uint_fast8_t bitindex = 0x80 >> (j & 0x07);
            if (xxFinale[j][i])
                publicKey[i][byteindex - kPublicKeyFirstRow / 8] ^= bitindex;
        }

    // Make the last column in publicKey, its all the other row's xor'ed
    for (uint_fast16_t i = 0; i < kSymbolicNnSize; i++)
        for (uint_fast8_t j = 0; j < kPublicKeyCols; j++)
            publicKey[kPublicKeyRows - 1][j] ^= publicKey[i][j];
}

// Makes a random permutation of the first numberOfValuesToShuffle values in num.
void randomPermutation(uint_sigma_calc num[], int16_t numberOfValuesToShuffle)
{
    uint16_t i, randomSwapPos;
    uint_sigma_calc temp;
    for (i = numberOfValuesToShuffle; i > 1; i--)
    {
        randomSwapPos = randomNum() % i;
        temp = num[randomSwapPos];
        num[randomSwapPos] = num[i - 1];
        num[i - 1] = temp;
    }
}

// Performs a direct copy of the constants and linear symbols in booleanSSymbolic into xx.
// Only the first 8 rows are copied.
void copyFirst8Symbolic(const Matrix<uint8_t, N, N + 1>& booleanSSymbolic, Matrix<uint8_t, N, kSymbolicNnSize>& xx)
{
    for (uint_fast8_t i = 0; i < 8; i++)
    {
        xx[i][0] ^= booleanSSymbolic[i][0]; // Add constant. TODO: Change to copy
        for (uint_sigma_calc j = 1; j < N + 1; j++)
            xx[i][j] = booleanSSymbolic[i][j]; // Copy linear components
    }
}

// Fill an 8x8 matrix with random Boolean values. The matrix is NonSingular (determinant == 1).
void makeNonSingularMatrix8x8(Matrix<uint8_t, 8, 8>& matrix)
{
    uint_fast8_t i, j, k, det;
    uint8_t tempMatrix[8][8];
    // Keep trying to find an random matrix until it is NonSingular.
    do
    {
        det = 1;
        // Fill the matrix with random boolean values.
        for (i = 0; i < 8; i++)
            for (j = 0; j < 8; j++)
                tempMatrix[i][j] = matrix[i][j] = randomNum() & 0x1;

        // Perform Gaussian elimination to check if we can construct a diagonal containing only 1's.
        for (i = 0; i < 8; i++)
        {
            // i is the row index to where we need to make tempMatrix[i][i]==1
            int_fast8_t swapped = -1;
            for (j = i; j < 8; j++)
            {
                // Perform swap?
                if (tempMatrix[j][i] && swapped == -1)
                {

                    for (k = 0; k < 8; k++)
                    {
                        uint8_t temp = tempMatrix[i][k];
                        tempMatrix[i][k] = tempMatrix[j][k];
                        tempMatrix[j][k] = temp;
                    }
                    swapped = static_cast<int_fast8_t>(j);
                }
                else if (tempMatrix[j][i] && swapped != -1)
                {
                    // Need to subtract (xor) tempMatrix[i] from tempMatrix[j]
                    for (k = 0; k < 8; k++)
                    {
                        tempMatrix[j][k] ^= tempMatrix[i][k];
                    }
                }
            }
            // In every column there must exist an non zero element, if not the determinant is 0.
            // This is the same as a swap (even between one line) as been performed for each column.
            if (swapped == -1)
            {
                det = 0;
                break;
            }
        }
    } while (det == 0);
}

// Constant part only in C: booleanS * h1
// Perform the multiplication between booleanSSymbolic and h1.
// Constant part only, the linear and quadratic terms are not touched.
void findConstants(
    const Matrix<uint8_t, 8, 137>& h,
    const Matrix<uint8_t, N, N + 1>& booleanSSymbolic,
    uint_sigma_calc startIndexOfF1,
    uint_sigma_calc startIndexOfF9,
    Matrix<uint8_t, N, kSymbolicNnSize>& xx,
    int targetIndexInxx
)
{
    for (uint_fast8_t i = 0; i < 8; i++)
    {
        int targetConstantIndexInxx = targetIndexInxx + i;
        uint_fast8_t index_h = 16 + 1; // The first quadratic expresion in h

        // Add constant from h[i]
        xx[targetConstantIndexInxx][0] ^= h[i][0]; // Location of constant in xx and h

        // Check each symbol in h[i] (x1-x8), and if it is present add the corresponding constant from booleanSSymbolic[ "x_n" ]
        // Need to add constant in booleanSSymbolic[startIndexOfF1 + offset] to xx[targetConstantIndexInxx]
        for (uint_fast8_t j = 1; j < 8 + 1; j++)
        {
            if (h[i][j])
            {
                // The symbol x_j is present in h.
                // Find the corresponding equation in booleanSSymbolic
                int indexOfX_j = startIndexOfF1 + j - 1;
                xx[targetConstantIndexInxx][0] ^= booleanSSymbolic[indexOfX_j][0]; // Location of constant in xx and booleanSSymbolic
            }
        }

        // Check each symbol in h[i] (x9-x16), and if it is present add the corresponding constant from booleanSSymbolic[ "x_j" ]
        // Need to add constant in booleanSSymbolic[startIndexOfF9 + offset] to xx[targetConstantIndexInxx]
        for (uint_fast8_t j = 1 + 8; j < 16 + 1; j++)
        {
            if (h[i][j])
            {
                // The symbol x_j is present in h.
                // Find the corresponding equation in booleanSSymbolic
                uint_sigma_calc indexOfX_j = startIndexOfF9 + j - 9;
                xx[targetConstantIndexInxx][0] ^= booleanSSymbolic[indexOfX_j][0]; // Location of constant in xx and booleanSSymbolic
            }
        }

        // Check each symbol in h[i] (x1-x8)(x9-16), and if it is present add the corresponding constant
        // from booleanSSymbolic[ "x_firstX" ] * booleanSSymbolic[ "x_secondX" ]
        // Need to add constant in booleanSSymbolic[startIndexOfF1 + offset] to xx[targetConstantIndexInxx]

        // This performs lots of useless tests  like (x1 x2)
        for (uint_fast8_t firstX = 0; firstX < 16; firstX++)
        {
            for (uint_fast8_t secondX = firstX + 1; secondX < 16; secondX++)
            {
                if (h[i][index_h])
                {
                    uint_sigma_calc indexOfX_firstX = startIndexOfF1 + firstX;       // firstX will always be in the range of 0-7
                    uint_sigma_calc indexOfX_secondX = startIndexOfF9 + secondX - 8; // secondX will always be in the range of 8-15
                    uint8_t product = booleanSSymbolic[indexOfX_firstX][0] & booleanSSymbolic[indexOfX_secondX][0];
                    // Now add the product to xx
                    xx[targetConstantIndexInxx][0] ^= product;
                }
                index_h++;
            }
        }
    }
}

// Linear symbolics part only in C: booleanSSymbolic * h1
// Perform the multiplication between booleanSSymbolic and h1.
// Linear part only (including quadratic terms of the from 'x[i] x[i]'), the constant and quadratic terms are not touched.
void findLinearSymbolics(
    const Matrix<uint8_t, 8, 137>& h,
    const Matrix<uint8_t, N, N + 1>& booleanSSymbolic,
    uint_sigma_calc startIndexOfF1,
    uint_sigma_calc startIndexOfF9,
    Matrix<uint8_t, N, kSymbolicNnSize>& xx,
    int targetIndexInxx
)
{
    for (uint_fast8_t i = 0; i < 8; i++)
    {
        int targetConstantIndexInxx = targetIndexInxx + i;
        int index_h = 16 + 1; // The first quadratic expresion in h

        // Check each symbol in h[i] (x1-x8), and if it is present add the corresponding linear part from booleanSSymbolic[ "x_n" ]
        // Need to add linear parts in booleanSSymbolic[startIndexOfF1 + offset] to xx[targetConstantIndexInxx]
        for (uint_fast8_t j = 1; j < 8 + 1; j++)
        {
            if (h[i][j])
            {
                // The symbol x_j is present in h.
                // Find the corresponding equation in booleanSSymbolic
                int indexOfX_j = startIndexOfF1 + j - 1;
                for (int k = 0; k < N; k++)
                    xx[targetConstantIndexInxx][k + 1] ^= booleanSSymbolic[indexOfX_j][k + 1]; // Location of linear parts in xx and booleanSSymbolic
            }
        }

        // Check each symbol in h[i] (x9-x16), and if it is present add the corresponding constant from booleanSSymbolic[ "x_j" ]
        // Need to add linear parts in booleanSSymbolic[startIndexOfF9 + offset] to xx[targetConstantIndexInxx]
        for (uint_fast8_t j = 1 + 8; j < 16 + 1; j++)
        {
            if (h[i][j])
            {
                // The symbol x_j is present in h.
                // Find the corresponding equation in booleanSSymbolic
                int indexOfX_j = startIndexOfF9 + j - 9;
                for (int k = 0; k < N; k++)
                    xx[targetConstantIndexInxx][k + 1] ^= booleanSSymbolic[indexOfX_j][k + 1]; // Location of linear parts in xx and booleanSSymbolic
            }
        }

        // Check each symbol in h[i] (x1-x8)(x9-16), and if it is present add the corresponding answer from
        // booleanSSymbolic[ "x_firstX" ] * booleanSSymbolic[ "x_secondX" ]
        // Need to add linear parts in booleanSSymbolic[startIndexOfF1 + offset] to xx[targetConstantIndexInxx], but
        // only if the constant part in booleanSSymbolic[startIndexOfF9 + offset] is present.
        // The same is true the other way around too.

        // This performs lots of useless tests  like (x1 x2)
        for (uint_fast8_t firstX = 0; firstX < 16; firstX++)
        {
            for (uint_fast8_t secondX = firstX + 1; secondX < 16; secondX++)
            {
                if (h[i][index_h])
                {
                    int indexOfX_firstX = startIndexOfF1 + firstX;       // firstX will always be in the range of 0-7
                    int indexOfX_secondX = startIndexOfF9 + secondX - 8; // secondX will always be in the range of 8-15

                    // Find the constant parts
                    uint8_t constantPartExistsF1 = booleanSSymbolic[indexOfX_firstX][0];
                    uint8_t constantPartExistsF9 = booleanSSymbolic[indexOfX_secondX][0];
                    if (constantPartExistsF1)
                    {
                        xx[targetConstantIndexInxx][1] ^= booleanSSymbolic[indexOfX_secondX][1];
                    }
                    if (constantPartExistsF9)
                    {
                        xx[targetConstantIndexInxx][1] ^= booleanSSymbolic[indexOfX_firstX][1];
                    }
                    for (int k = 1; k < N; k++)
                    {
                        // If constantPartExistsF1 == true, then we need to add the symbols from booleanSSymbolic[indexOfX_secondX] to xx
                        if (constantPartExistsF1)
                        {
                            xx[targetConstantIndexInxx][k + 1] ^= booleanSSymbolic[indexOfX_secondX][k + 1];
                        }

                        // If constantPartExistsF9 == true, then we need to add the symbols from booleanSSymbolic[indexOfX_firstX] to xx
                        if (constantPartExistsF9)
                        {
                            xx[targetConstantIndexInxx][k + 1] ^= booleanSSymbolic[indexOfX_firstX][k + 1];
                        }
                    }

                    // Find the quadratic parts k == k
                    for (int k = 0; k < N; k++)
                    {
                        // If constantPartExistsF1 == true, then we need to add the symbols from booleanSSymbolic[indexOfX_secondX] to xx
                        uint8_t product = booleanSSymbolic[indexOfX_firstX][k + 1] & booleanSSymbolic[indexOfX_secondX][k + 1];
                        xx[targetConstantIndexInxx][k + 1] ^= product;
                    }
                }
                index_h++;
            }
        }
    }
}

// Quadratic symbolics part only in C: booleanSSymbolic * h1
// Perform the multiplication between booleanSSymbolic and h1.
// Quadratic part only (excluding quadratic terms of the from 'x[i] x[i]'), the constant and linear terms are not touched.
void findQuadraticSymbolics(
    const Matrix<uint8_t, 8, 137>& h,
    const Matrix<uint8_t, N, N + 1>& booleanSSymbolic,
    uint_sigma_calc startIndexOfF1,
    uint_sigma_calc startIndexOfF9,
    Matrix<uint8_t, N, kSymbolicNnSize>& xx,
    int targetIndexInxx
)
{
    for (uint_fast8_t i = 0; i < 8; i++)
    {
        int targetConstantIndexInxx = targetIndexInxx + i;
        int index_h = 16 + 1; // The first quadratic expresion in h

        // This performs lots of useless tests, like (x1 x2)
        for (uint_fast8_t firstX = 0; firstX < 16; firstX++)
        {
            for (uint_fast8_t secondX = firstX + 1; secondX < 16; secondX++)
            {

                if (h[i][index_h])
                {

                    int indexOfX_firstX = startIndexOfF1 + firstX;       // firstX will always be in the range of 0-7
                    int indexOfX_secondX = startIndexOfF9 + secondX - 8; // secondX will always be in the range of 8-15

                    // Find the quadratic parts k != k
                    int index_qe1 = N + 1; // The first quadratic expression in xx
                    int index_qe2 = N + 1; // The first quadratic expression in xx

                    for (int j = 0; j < N; j++)
                    {
                        if (booleanSSymbolic[indexOfX_firstX][j + 1])
                        {
                            for (int k = j + 1; k < N; k++)
                            {
                                xx[targetConstantIndexInxx][index_qe1] ^= booleanSSymbolic[indexOfX_secondX][k + 1];
                                index_qe1++;
                            }
                        }
                        else
                            index_qe1 += N - j - 1;

                        if (booleanSSymbolic[indexOfX_secondX][j + 1])
                        {
                            for (int k = j + 1; k < N; k++)
                            {
                                xx[targetConstantIndexInxx][index_qe2] ^= booleanSSymbolic[indexOfX_firstX][k + 1];
                                index_qe2++;
                            }
                        }
                        index_qe2 = index_qe1;
                    }
                }
                index_h++;
            }
        }
    }
}

// Multiplication of booleanS (not symbolic) and xx (symbolic).
// Creates xxFinale (symbolic).
void multiplyBooleanSXX(
    const Matrix<uint8_t, N, N>& booleanS,
    const Matrix<uint8_t, N, kSymbolicNnSize>& xx,
    Matrix<uint8_t, N, kSymbolicNnSize>& xxFinale
)
{
    // Now, multiply xx with booleanS (not symbolic) and make xxFinale
    // This version reduces the number of operations needed, simplifies the later packed format version, and might be more cache friendly.
    Matrix<uint8_t, N, N> booleanSTranspose;

    // Transpose booleanS, so that the access patterns becomes cache friendly in the multiply.
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            booleanSTranspose[i][j] = booleanS[j][i];

    // Uses basic loop tiling for L2 cache, slightly more efficient.
    // Skip the parts that is not needed in the Public-key.
    for (int tile_j = 0; tile_j < kSymbolicNnSize; tile_j += 2048 - 16)
    {
        int tile_j_end = min(tile_j + 2048 - 16, kSymbolicNnSize);
        for (int i = kPublicKeyFirstRow; i < kPublicKeyLastRow; i++)
        {
            for (int k = 0; k < N; k++)
            {
                if (booleanSTranspose[k][i])
                {
                    for (int j = tile_j; j < tile_j_end; j++)
                    {
                        xxFinale[i][j] ^= xx[k][j];
                    }
                }
            }
        }
    }
}

// Save Private key
void savePrivateKey(uint_sigma mqq_sigma1__[N], uint_sigma mqq_sigmaK__[N], const Matrix<uint8_t, 8, 137>& h1, unsigned char* sk)
{
    // cc1 and cc2 are linear symbolic vectors with a constant and 8 elements (x0-x7 and x8-x15).
    uint8_t cc1[8][9];
    uint8_t cc2[8][9];
    // mqq_a1 is a linear symbolic matrix with a constant and 8 elements (x0-x7 or x8-x15).
    uint8_t mqq_a1[8][8][9];
    memset(cc1, 0, sizeof(cc1));
    memset(cc2, 0, sizeof(cc2));
    memset(mqq_a1, 0, sizeof(mqq_a1));

    // The idea is that mqq_a1 * [x0, x1, x2 ... x7] + cc1  =  h1
    // That is, mqq_a1 contains the linear x0-x7 elements and the quadratic elements of h1.
    // cc1 contains the constants and linear x8-x15 elements of h1.
    // cc2 contains the constants and linear x0-x7 elements of h1.

    // Set the constant elements in cc1 and cc2
    for (int i = 0; i < 8; i++)
    {
        cc1[i][0] = h1[i][0];
        cc2[i][0] = h1[i][0];
    }

    // Set the linear elements in cc1 and cc2
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            cc1[i][1 + j] = h1[i][1 + 8 + j]; // x8-15 from h1
            cc2[i][1 + j] = h1[i][1 + j];     // x0-x7 from h1
        }
    }

    // Set the constant elements in mqq_a1
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
            mqq_a1[i][j][0] = h1[i][1 + 8 + j]; // x8-x15 from h1
    }

    // Set the linear elements in mqq_a1
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++) // Iterate over the x0-x7 componetns in the quadratic terms
        {
            for (int k = 0; k < 8; k++) // Iterate over the x8-x15 componetns in the quadratic terms
            {
                int indexOfSymbolicQuadrat = 16 - (-29 + j) * j / 2 + k + 8;
                mqq_a1[i][j][1 + k] = h1[i][indexOfSymbolicQuadrat];
            }
        }
    }

    // cc1_bin and cc2_bin are bit packed version of cc1 and cc2.
    uint8_t cc1_bin[9];
    uint8_t cc2_bin[9];
    // mqq_a1_bin is a bit packed version of mqq_a1.
    uint8_t mqq_a1_bin[8][9];
    memset(cc1_bin, 0, sizeof(cc1_bin));
    memset(cc2_bin, 0, sizeof(cc2_bin));
    memset(mqq_a1_bin, 0, sizeof(mqq_a1_bin));

    // Create the cc1 in the binary format (cc1_bin)
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
            if (cc1[i][j + 1])
                cc1_bin[j] ^= 0x80 >> i;
        if (cc1[i][0])
            cc1_bin[8] ^= 0x80 >> (i & 0x07);
    }
    // Create the cc2 in the binary format (cc2_bin)
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
            if (cc2[i][j + 1])
                cc2_bin[j] ^= 0x80 >> i;
        if (cc2[i][0])
            cc2_bin[8] ^= 0x80 >> (i & 0x07);
    }

    // Create the mqq_a1 in the binary format (mqq_a1_bin)
    for (int k = 0; k < 8; k++)
    {
        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                if (mqq_a1[k][i][j + 1])
                    mqq_a1_bin[j][i] ^= 0x80 >> k;
            }
            if (mqq_a1[k][i][0])
                mqq_a1_bin[i][8] ^= 0x80 >> (k & 0x07);
        }
    }

    // Write the private key to the storage in pointer sk
    uint8_t* privatekey = sk;
    memcpy(privatekey, mqq_a1_bin, sizeof(mqq_a1_bin));
    privatekey += sizeof(mqq_a1_bin);
    memcpy(privatekey, cc1_bin, sizeof(cc1_bin));
    privatekey += sizeof(cc1_bin);
    memcpy(privatekey, cc2_bin, sizeof(cc2_bin));
    privatekey += sizeof(cc2_bin);
    memcpy(privatekey, mqq_sigma1__, sizeof(uint_sigma) * N);
    privatekey += sizeof(uint_sigma) * N;
    memcpy(privatekey, mqq_sigmaK__, sizeof(uint_sigma) * N);
}

void memxor(void* dest, const void* src, uint16_t length)
{
    while (length--)
    {
        *(reinterpret_cast<uint8_t*>(dest)) ^= *(reinterpret_cast<const uint8_t*>(src));
        dest = reinterpret_cast<uint8_t*>(dest) + 1;
        src = reinterpret_cast<const uint8_t*>(src) + 1;
    }
}

void memxor_idx(uint8_t* dest, const uint8_t* src, uint16_t length, uint8_t dist)
{
    uint8_t a, b;
    while (length--)
    {
        a = *dest;
        b = *src;
        a ^= b;
        *dest = a;
        dest = dest + 1;
        src = src + dist;
    }
}

void inverseAffineTransformation(uint8_t* input_bytes, uint8_t result[N / 8], const uint8_t sigma1[N], const uint8_t sigmaK[N], bool isSecondCall)
{
    /* The matrix SInv is given as two permutations of N elements. */
    uint8_t i;
    uint8_t j;
    MQQALIGNED(16) uint8_t rp1[64], rpK[64];

    if (isSecondCall)
    {
        for (j = 0; j < N / 8; j++)
        {
            // Take the bits from an element 64 positions later in sigmaK.
            // The condition (11) in the Technical Description Paper
            input_bytes[j] ^= (uint8_t)((sigmaK[j] & 0x0F) << 4);
            input_bytes[j] ^= (uint8_t)(sigmaK[j + 64] & 0xFF);
        }
    }

    for (j = 0; j < N / 8; j++)
    {
        // Using 16-bit variables in order to use cmove instructions.
        uint16_t accumulator1 = 0;
        uint16_t accumulatorK = 0;

        // 0
        accumulator1 = (input_bytes[sigma1[j * 8 + 0] >> 3] & (0x80 >> ((sigma1[j * 8 + 0]) & 0x07))) ? accumulator1 ^ (0x80 >> 0) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 0] >> 3] & (0x80 >> ((sigmaK[j * 8 + 0]) & 0x07))) ? accumulatorK ^ (0x80 >> 0) : accumulatorK;

        // 1
        accumulator1 = (input_bytes[sigma1[j * 8 + 1] >> 3] & (0x80 >> ((sigma1[j * 8 + 1]) & 0x07))) ? accumulator1 ^ (0x80 >> 1) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 1] >> 3] & (0x80 >> ((sigmaK[j * 8 + 1]) & 0x07))) ? accumulatorK ^ (0x80 >> 1) : accumulatorK;

        // 2
        accumulator1 = (input_bytes[sigma1[j * 8 + 2] >> 3] & (0x80 >> ((sigma1[j * 8 + 2]) & 0x07))) ? accumulator1 ^ (0x80 >> 2) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 2] >> 3] & (0x80 >> ((sigmaK[j * 8 + 2]) & 0x07))) ? accumulatorK ^ (0x80 >> 2) : accumulatorK;

        // 3
        accumulator1 = (input_bytes[sigma1[j * 8 + 3] >> 3] & (0x80 >> ((sigma1[j * 8 + 3]) & 0x07))) ? accumulator1 ^ (0x80 >> 3) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 3] >> 3] & (0x80 >> ((sigmaK[j * 8 + 3]) & 0x07))) ? accumulatorK ^ (0x80 >> 3) : accumulatorK;

        // 4
        accumulator1 = (input_bytes[sigma1[j * 8 + 4] >> 3] & (0x80 >> ((sigma1[j * 8 + 4]) & 0x07))) ? accumulator1 ^ (0x80 >> 4) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 4] >> 3] & (0x80 >> ((sigmaK[j * 8 + 4]) & 0x07))) ? accumulatorK ^ (0x80 >> 4) : accumulatorK;

        // 5
        accumulator1 = (input_bytes[sigma1[j * 8 + 5] >> 3] & (0x80 >> ((sigma1[j * 8 + 5]) & 0x07))) ? accumulator1 ^ (0x80 >> 5) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 5] >> 3] & (0x80 >> ((sigmaK[j * 8 + 5]) & 0x07))) ? accumulatorK ^ (0x80 >> 5) : accumulatorK;

        // 6
        accumulator1 = (input_bytes[sigma1[j * 8 + 6] >> 3] & (0x80 >> ((sigma1[j * 8 + 6]) & 0x07))) ? accumulator1 ^ (0x80 >> 6) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 6] >> 3] & (0x80 >> ((sigmaK[j * 8 + 6]) & 0x07))) ? accumulatorK ^ (0x80 >> 6) : accumulatorK;

        // 7
        accumulator1 = (input_bytes[sigma1[j * 8 + 7] >> 3] & (0x80 >> ((sigma1[j * 8 + 7]) & 0x07))) ? accumulator1 ^ (0x80 >> 7) : accumulator1;
        accumulatorK = (input_bytes[sigmaK[j * 8 + 7] >> 3] & (0x80 >> ((sigmaK[j * 8 + 7]) & 0x07))) ? accumulatorK ^ (0x80 >> 7) : accumulatorK;

        rp1[j] = static_cast<uint8_t>(accumulator1);
        rpK[j] = static_cast<uint8_t>(accumulatorK);
    }

    MQQALIGNED(16) uint8_t result_buf1[64];
    MQQALIGNED(16) uint8_t result_buf2[64];
    for (i = 0; i < N / 8; i++)
    {
        rp1[i + N / 8] = rp1[i];
        rpK[i + N / 8] = rpK[i];
    }
    for (i = 0; i < N / 4; i++)
        rp1[i] ^= rpK[i];

#define MQQSIGN_ROLLOVER (4 + 2)
    j = 1;
    for (i = 0; i < static_cast<uint8_t>(N / 8 + MQQSIGN_ROLLOVER); i++)
    {
        result_buf1[i] = rp1[i] ^ rp1[(i + j)];
    }
    j = 2;

    for (i = 0; i < static_cast<uint8_t>(N / 8 + MQQSIGN_ROLLOVER); i++)
    {
        result_buf2[i] = result_buf1[i] ^ result_buf1[(i + j)];
    }
    j = 4;

    for (i = 0; i < N / 8; i++)
    {
        result[i] = result_buf2[i] ^ result_buf2[(i + j)];
    }

    j = 8;
    for (; j <= N / 16; j++)
    {
        for (i = 0; i < N / 8; i++)
        {
            result[i] ^= rp1[(i + j)];
        }
    }

    // j is equal to N/16 + 1
    for (i = 0; i < N / 8; i++)
        result[i] ^= rpK[(i + N / 16 + 1)];
}

uint8_t Q(uint8_t i, uint8_t b1, uint8_t b2, const uint8_t* mqq_a, const uint8_t* cc1, const uint8_t* cc2)
{
    MQQALIGNED(16) uint8_t e[16]; // Only 9 are used, the rest is for SSE.
    MQQALIGNED(16) uint16_t a[8];
    uint8_t result, column, row, k;
    int8_t j;
    uint16_t temp;
    const uint8_t* tmp_ptr = mqq_a;

    // TODO: Optimize
    if (i & 1)
    {
        memcpy(e, cc1, 9);
        while (b1)
        {
            if (b1 & 0x80)
            {
                memxor_idx((uint8_t*)e, tmp_ptr, 9, 9);
            }
            tmp_ptr++;
            b1 <<= 1;
        }
    }
    else
    {
        memcpy(e, cc2, 9);
        while (b1)
        {
            if (b1 & 0x80)
            {
                memxor((uint8_t*)e, tmp_ptr, 9);
            }
            tmp_ptr += 9;
            b1 <<= 1;
        }
    }
    /* So we finished with obtaining e0 .. e7 and e8 */

    /* We XOR e[8] with b2 and that will be initial value to transform in order to solve a linear system of equations */
    result = b2 ^ e[8];

    /*
       We can look at the bits of e0 .. e7 as a columns of a given matrix. We want to define 8 variables that have the rows
       of that matrix. The variables need to be 16-bit because we will put into the upper 8 bits the bits of e0 .. e7,
       and the bits of the variable result will be the Least Significant Bits of a[0] ... a[7].
    */

    for (j = 0; j < 8; ++j)
    {
        row = 0;
        for (k = 0; k < 8; ++k)
        {
            row |= (e[k] & 0x80) >> (k);
            e[k] <<= 1;
        }
        a[j] = (((uint16_t)row) << 8) | (result >> 7);
        result <<= 1;
    }

    /* Now we finally realize Gausian elimination */

    /* First we apply upper triangular transformation */
    for (column = 0; column < 8; column++)
    {
        row = column;
        const uint16_t mask = 0x8000 >> column;
        while ((a[row] & mask) == 0)
        {
            row++; // TODO: unroll AND -> CMOV => ~ 32*2 instructions (64 bit mode isolated)
        }

        if (row > column)
        {
            temp = a[column];
            a[column] = a[row];
            a[row] = temp;
        }

        const uint16_t org_a = a[column];
        for (j = 0; j < 8; j++)
        {
            uint16_t org = a[j] ^ org_a;
            a[j] = ((a[j] & mask) != 0) ? org : a[j];
        }
        a[column] = org_a;
    }

    /* The result is in the Least Significant Bits of a[0] ... a[7] */
    result = 0;
    for (j = 0; j < 8; ++j)
    {
        result <<= 1;
        result |= a[j] & 1;
    }

    return (result); // 20*(16+16+32*4+32*3+32*3+4) = ~7120 instructions (no SSE)
}

//
// KeyGen
//

void genKeyPair(uint8_t pk[PUBLICKEY_SIZE], uint8_t sk[PRIVATEKEY_SIZE])
{
    // ****************************************
    // Initialize Table
    // ****************************************
    std::vector<uint_sigma_calc> sigma1(N);
    std::vector<uint_sigma_calc> sigmaK(N);
    Matrix<uint_sigma_calc, N, N / 8 + 3> candidate;
    Matrix<uint8_t, N, N> booleanSInverse;

    Matrix<uint8_t, N, N> booleanS; // Init to Identity matrix
    // We will keep the values of the public key in xx and xxFinale
    // Both xx and xxFinale are our internal variables
    Matrix<uint8_t, N, kSymbolicNnSize> xx;
    Matrix<uint8_t, N, kSymbolicNnSize> xxFinale;

    // Use the current time as a seed for the random genrator
    const int seed = (int)time(nullptr);
    srandomNum(seed);

    // ****************************************
    // Construct booleanS
    // ****************************************
    int_fast8_t det;

    for (int i = 0; i < N; i++)
    {
        sigma1[i] = sigmaK[i] = i;
    }
    do
    {
        // This loop runs over (det == 0)
        // Initialize sigma1 with values from 1 to N.
        randomPermutation(sigma1.data(), N);
        randomPermutation(sigmaK.data(), N);

        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j <= N / 16; j++)
                candidate[i][j] = sigma1[(i + j * 8) % N];
            for (int j = 0; j <= N / 16 + 1; j++)
                candidate[i][N / 16 + j + 1] = sigmaK[(i + j * 8) % N];
        }

        // Now check if the determinant is 1
        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j < N; j++)
            {
                booleanSInverse[i][j] = 0;
                booleanS[i][j] = 0;
                if (i == j)
                    booleanS[i][j] = 1; // Initialize to Identity matrix
            }
        }

        // Make a 1 in booleanSInverse from each of the locations in candidate
        for (int i = 0; i < N; i++)
        {
            for (int j = 0; j < N / 8 + 3; j++)
            {
                booleanSInverse[i][candidate[i][j]] ^= 1;
            }
        }

        // Check if the determinant of Sinverse is 0 or 1.
        // If it is 0 then a new sigmaK must be generated.
        // When the determinant is 1 the lower left triangle is already completed.
        det = 1;
        for (int i = 0; i < N; i++)
        {
            // i is the row index to where we need to make booleanSInverse[i][i]==1
            int swapped = -1;
            for (int j = i; j < N; j++)
            {
                // Perform swap?
                if (booleanSInverse[j][i] && swapped == -1)
                {
                    for (int k = 0; k < N; k++)
                    {
                        uint8_t temp = booleanSInverse[i][k];
                        booleanSInverse[i][k] = booleanSInverse[j][k];
                        booleanSInverse[j][k] = temp;

                        // Make the inverse too
                        temp = booleanS[i][k];
                        booleanS[i][k] = booleanS[j][k];
                        booleanS[j][k] = temp;
                    }
                    swapped = j;
                }
                else if (booleanSInverse[j][i] && swapped != -1)
                {
                    // Need to substract (xor) booleanSInverse[i] from booleanSInverse[j]
                    for (int k = 0; k < N; k++)
                    {
                        booleanSInverse[j][k] ^= booleanSInverse[i][k];
                        booleanS[j][k] ^= booleanS[i][k];
                    }
                }
            }
            if (swapped == -1)
            {
                det = 0;
                break;
            }
        }

        // End the loop generating a candidate (sigma1 and sigmaK) that makes Sinverse invertible (det == 1).
    } while (det == 0);

    // Assume that det is 1.
    // booleanSInverse contains 0 in the lower left triangle now, need to do change it to the identity matrix (and duplicate the operations on
    // booleanS).
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < i; j++)
        {
            // Perform swap?
            if (booleanSInverse[j][i])
            {
                // Need to substract (xor) booleanSInverse[j] from booleanSInverse[i]
                for (int k = 0; k < N; k++)
                {
                    booleanSInverse[j][k] ^= booleanSInverse[i][k];
                    booleanS[j][k] ^= booleanS[i][k];
                }
            }
        }
    }

    // ****************************************
    // Construct h1
    // ****************************************

    // h1 is the quasigrup operation * in the description of the algorithm
    // This is the h1 transform function:
    // The format is:
    // index 0:    constant
    // index 1-16: linear components x1-x16
    // index 17-136: quadratic components x1x2, x1x3, ... x1x16, x2x3, x2x4, ... x15x16
    // Although the secret quasigroup needs 81 bytes, internaly we will work with structure that has all posible
    // combinations: 137 = 1 + 16 + (16*16-16)/2
    Matrix<uint8_t, 8, 137> h1;
    Matrix<uint8_t, 8, 137> A1BTX2PX1BPCLin;
    int_fast8_t matrixRank = 0;
    // Search until the rank requirement of h1 is satisfied.
    uint_fast8_t max_rank_in_h1 = 0;
    uint_fast8_t count_min_rank_once_in_h1 = 0;

    int iterations = 0;
    do
    {
        iterations++;
        if (iterations % 64 == 0)
        {
            // This situation should never occur if the PRNG is a good one.
            // iterations = 0;
            // seed = (int) time(NULL);
            srandomNum(seed + iterations);
        }
        // Need to make 8 matrices of size 8*8, containing random Boolean values.
        // The lower left triangle (diagonal included) is always zero.
        // U are denoted as U_i in the description of the algorithm
        uint8_t U[8][8][8];

        // Clear U
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                for (int k = 0; k < 8; k++)
                    U[i][j][k] = 0;

        // Iterate over the U.
        for (int i = 0; i < 8; i++)
        {
            // Iterate over rows.
            for (int j = 0; j < i; j++)
            {
                // Start just after the diagonal (j+1), and assign random values to each element.
                for (int k = j + 1; k < 8; k++)
                {
                    // Assign a random value
                    U[i][j][k] = randomNum() & 0x01;
                }
            }
        }

        // Make 3 random 8x8 boolean non-singular matrices (determinant == 1).
        Matrix<uint8_t, 8, 8> B;
        Matrix<uint8_t, 8, 8> A1;
        Matrix<uint8_t, 8, 8> A2;

        makeNonSingularMatrix8x8(B);
        makeNonSingularMatrix8x8(A1);
        makeNonSingularMatrix8x8(A2);

        // Need to perform symbolic multiplication between U and X1Lin.
        uint8_t A1BLin[8][8][8 + 1];
        // Clear A1BLin.
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                for (int k = 0; k < 9; k++)
                    A1BLin[i][j][k] = 0;

        uint8_t A1BLinTemp[8][8][8 + 1];
        // Clear A1BLinTemp.
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                for (int k = 0; k < 9; k++)
                    A1BLinTemp[i][j][k] = 0;

        int_fast8_t matrixIndex;
        // Iterate over each matrix in U.
        // Perform symbolic multiplication between U and X1Lin (x[1] - x[8])
        for (matrixIndex = 0; matrixIndex < 8; matrixIndex++)
        {
            // Make a clean temporary matrix
            uint8_t nonTransposedA1BLinTemp[8][8 + 1];
            for (int i = 0; i < 8; i++)
                for (int j = 0; j < 9; j++)
                    nonTransposedA1BLinTemp[i][j] = 0;

            // Perform symbolic multiplication between one matrix from U and
            // X1Lin (A1) (x[1] - x[8])
            for (int i = 0; i < 8; i++)
            {
                // Iterate over rows.
                for (int j = 0; j < 8; j++)
                {
                    for (int k = 0; k < 8; k++)
                    {
                        nonTransposedA1BLinTemp[i][j + 1] ^= U[matrixIndex][i][k] & A1[k][j];
                    }
                }
            }

            nonTransposedA1BLinTemp[matrixIndex][0] = 1;

            // Write transpose of nonTransposedA1BLinTemp into A1BLinTemp[matrixIndex].
            for (int i = 0; i < 8; i++)
                for (int j = 0; j < 9; j++)
                    A1BLinTemp[i][matrixIndex][j] = nonTransposedA1BLinTemp[i][j];
        }

        // Multiply B by A1BLinTemp. A1BLinTemp is an matrix of symbolic expressions.
        for (matrixIndex = 0; matrixIndex < 8; matrixIndex++)
        {
            for (int i = 0; i < 8; i++)
            {
                // Iterate over rows.
                for (int k = 0; k < 8; k++)
                {
                    // Each element in the A1BLin matrix are symbolic expressions, so the values of B are multiplied with the entire symbolic vectors
                    if (B[matrixIndex][k])
                    {
                        for (int j = 0; j < 8 + 1; j++)
                            A1BLin[matrixIndex][i][j] ^= A1BLinTemp[k][i][j];
                    }
                }
            }
        }

        // Make a random Boolean array.
        uint8_t con[8]; // con is the vector c in the documentation
        for (int i = 0; i < 8; i++)
            con[i] = randomNum() & 0x01;

        // Make a symbolic vector BX1PConLin.
        Matrix<uint8_t, 8, 9> BX1PConLin;
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 9; j++)
                BX1PConLin[i][j] = 0;

        // Multiply B by X1Lin symbolically, using A1 directly.
        // The constant part from Con can be added directly, as there is no overlap.
        for (int i = 0; i < 8; i++)
        {
            BX1PConLin[i][0] = con[i];
            for (int j = 0; j < 8; j++)
                for (int k = 0; k < 8; k++)
                    BX1PConLin[i][j + 1] ^= B[i][k] & A1[k][j];
        }

        // Clear A1BTX2PX1BPCLin.
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 137; j++)
                A1BTX2PX1BPCLin[i][j] = 0;

        // Perform the linear part x9-x16
        for (int i = 0; i < 8; i++) // Iterate over the vectors in A1BTX2PX1BPCLin
            for (int j = 0; j < 8; j++)
                for (int k = 0; k < 8; k++)
                    A1BTX2PX1BPCLin[i][1 + 8 + j] ^= A1BLin[i][k][0] & A2[k][j];

        //  perform the quadratic part x1x9, x1x10, ... x1x16, x2x3
        for (int i = 0; i < 8; i++)
        {                                  // Iterate over the vectors in A1BTX2PX1BPCLin
            uint_fast8_t index_h = 16 + 1; // The index of the first quadratic expression in A1BTX2PX1BPCLin
            for (int_fast8_t firstX = 0; firstX < 16; firstX++)
            {
                for (int_fast8_t secondX = static_cast<int_fast8_t>(firstX + 1); secondX < 16; secondX++)
                {

                    // Only work with x1 - x8 from A1BLin, and only x9 - x16 from X2Lin
                    if (firstX < 8 && secondX >= 8)
                    {
                        uint8_t product = 0;
                        for (int k = 0; k < 8; k++)
                            product ^= A1BLin[i][k][1 + firstX] & A2[k][secondX - 8];
                        // Note that it is not xor'ed, as there is no overlap.
                        A1BTX2PX1BPCLin[i][index_h] = product;
                    }
                    index_h++;
                }
            }
        }

        for (int i = 0; i < 8; i++) // Iterate over the vectors in A1BTX2PX1BPCLin
        {
            for (int j = 0; j < 9; j++)
            {
                // Note that it is not xor'ed, as there is no overlap from the A1BLin.X2Lin part.
                A1BTX2PX1BPCLin[i][j] = BX1PConLin[i][j];
            }
        }

        // Now test the rank of A1BTX2PX1BPCLin, by trying to invert A1BTX2PX1BPCLinSymmetric.
        // The rank(s) are found by counting the rows that contained only 0's during inversion.
        Matrix<uint8_t, 8 * 2, 8 * 2> A1BTX2PX1BPCLinSymmetric;
        uint_fast8_t rowsInA1BTX2PX1BPCLin;
        for (rowsInA1BTX2PX1BPCLin = 0; rowsInA1BTX2PX1BPCLin < 8; rowsInA1BTX2PX1BPCLin++)
        {

            // Clear the matrix
            for (int i = 0; i < 8 * 2; i++)
                for (int j = 0; j < 8 * 2; j++)
                    A1BTX2PX1BPCLinSymmetric[i][j] = 0;

            // Fill A1BTX2PX1BPCLinSymmetric with the quadratic components from A1BTX2PX1BPCLin.
            int i = rowsInA1BTX2PX1BPCLin;
            uint_fast8_t index_h = 16 + 1; // The index of the first quadratic expression in A1BTX2PX1BPCLin
            for (int_fast8_t firstX = 0; firstX < 16; firstX++)
            {
                for (int_fast8_t secondX = static_cast<int_fast8_t>(firstX + 1); secondX < 16; secondX++)
                {
                    // It is symmetric, so set [i][j] = [j][i].
                    A1BTX2PX1BPCLinSymmetric[firstX][secondX] ^= A1BTX2PX1BPCLin[i][index_h];
                    A1BTX2PX1BPCLinSymmetric[secondX][firstX] ^= A1BTX2PX1BPCLin[i][index_h];
                    index_h++;
                }
            }

            // Check the rank of A1BTX2PX1BPCLinSymmetric:
            matrixRank = 0;
            for (int i = 0; i < 8 * 2; i++)
            {
                // i is the row index to where we need to make A1BTX2PX1BPCLinSymmetric[i][i]==1
                int_fast8_t swapped = -1;
                for (int j = i; j < 8 * 2; j++)
                {
                    // Perform swap?
                    if (A1BTX2PX1BPCLinSymmetric[j][i] && swapped == -1)
                    {
                        for (int k = 0; k < 8 * 2; k++)
                        {
                            uint8_t temp = A1BTX2PX1BPCLinSymmetric[i][k];
                            A1BTX2PX1BPCLinSymmetric[i][k] = A1BTX2PX1BPCLinSymmetric[j][k];
                            A1BTX2PX1BPCLinSymmetric[j][k] = temp;
                        }
                        swapped = static_cast<int_fast8_t>(j);
                    }
                    else if (A1BTX2PX1BPCLinSymmetric[j][i] && swapped != -1)
                    {
                        // Need to substract (xor) A1BTX2PX1BPCLinSymmetric[i] from A1BTX2PX1BPCLinSymmetric[j]
                        for (int k = 0; k < 8 * 2; k++)
                        {
                            A1BTX2PX1BPCLinSymmetric[j][k] ^= A1BTX2PX1BPCLinSymmetric[i][k];
                        }
                    }
                }

                if (swapped == -1)
                {
                    // A rank of 16 is not possible.
                }
                else
                {
                    matrixRank++; // Count the rank.
                }
            }

            // Keep track of the best rank.
            if (matrixRank > max_rank_in_h1)
                max_rank_in_h1 = matrixRank;

            // Count the number of ranks that satisfy the second rank requirement.
            if (matrixRank >= kMinRankOnceQuasiGroup)
                count_min_rank_once_in_h1++;

            // Restart if its impossible that count will match rank requirements.
            if (7 - rowsInA1BTX2PX1BPCLin + count_min_rank_once_in_h1 < kMinRankOnceQuasiGroupCount)
            {
                max_rank_in_h1 = 0;
                count_min_rank_once_in_h1 = 0;
                break;
            }

            // Make sure that this rank is within the good range, if not remake.
            if (matrixRank < kMinRankQuasiGroup || matrixRank > kMaxRankQuasiGroup)
            {

                max_rank_in_h1 = 0;
                count_min_rank_once_in_h1 = 0;
                break;
            }
        }

        // Make sure there is at least one rank 14 (or bigger than the MIN_RANK_QUASIGROUP requirement).
    } while (max_rank_in_h1 < kMinRankOnceQuasiGroup);
    // And h1 = A1BTX2PX1BPCLin is done *)
    // h1 is the quasigroup saved into the Private-key.
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 137; j++)
        {
            h1[i][j] = A1BTX2PX1BPCLin[i][j];
        }
    }

    // This is only needed for N==256, but is performed always for simplicity in the code.
    // Move data from 16 bit to 8 bit variables (N==256).
    uint_sigma sigma1_Nbit[N];
    uint_sigma sigmaK_Nbit[N];
    for (int i = 0; i < N; i++)
    {
        sigma1_Nbit[i] = sigma1[i];
        sigmaK_Nbit[i] = sigmaK[i];
    }

    // ****************************************
    // Save Private Key: sigma1, sigmaK and h1.
    // ****************************************
    savePrivateKey(sigma1_Nbit, sigmaK_Nbit, h1, sk);

    // ****************************************
    // Construct Public Key
    // ****************************************

    // Now get the "random" N/8 bytes v, to be used as the N constant additions.
    uint8_t v[N];
    for (int i = 0; i < N / 8; i++)
    {
        // Make an 8 bit value from the bits in two elements from sigmaK
        uint8_t random4BitsHigh = sigmaK[i] & 0x0f; // Take the 4 lowest bits
        random4BitsHigh = random4BitsHigh << 4;     // Move them to the upper 4 places
        // Take the bits from an element 64 positions later in sigmaK.
        // The condition (11) in the Technical Description Paper
        uint8_t random4BitsLow = sigmaK[64 + i];
        uint8_t randomBitsFromsigmaK = random4BitsHigh ^ random4BitsLow; // Merge them.
        // Insert each bit in randomBitsFromsigmaK into a diffrent location in v
        for (int j = 0; j < 8; j++)
            v[i * 8 + j] = (randomBitsFromsigmaK >> (7 - j)) & 0x01;
    }

    // Need a symbolic version of booleanS: booleanSSymbolic
    // booleanSSymbolic starts with the constant from v, and then contains symbols in the range x[0] - x[N-1]
    // S' in the documentation
    Matrix<uint8_t, N, N + 1> booleanSSymbolic;
    for (int i = 0; i < N; i++)
    {
        booleanSSymbolic[i][0] = v[i];
        for (int j = 0; j < N; j++)
        {
            booleanSSymbolic[i][j + 1] = booleanS[i][j];
        }
    }

    // Start the production of the public key
    // First 8 expressions are linear and copied directly
    copyFirst8Symbolic(booleanSSymbolic, xx);

    // Create the rest of the symbolic qudratic expressions stored in xx
    for (int i = 1; i < (N / 8); i++)
    {
        uint_sigma_calc inputF1 = 8 * (i - 1);
        uint_sigma_calc inputF9 = 8 * i;
        if (i % 2 == 0)
        {
            inputF1 = 8 * i;
            inputF9 = 8 * (i - 1);
        }

        // Create the symbolic xx
        // It's done in 3 stages:
        // First the constants, then the linear parts and finally the quadratic parts.
        // This staging exists mainly for debugging.
        // xx will receive values that correspond to the operations P' from the documantation
        findConstants(h1, booleanSSymbolic, inputF1, inputF9, xx, 8 * i);
        findLinearSymbolics(h1, booleanSSymbolic, inputF1, inputF9, xx, 8 * i);
        findQuadraticSymbolics(h1, booleanSSymbolic, inputF1, inputF9, xx, 8 * i);
    }

    // Now, multiply xx with booleanS (not symbolic) and make xxFinale
    multiplyBooleanSXX(booleanS, xx, xxFinale);

    // ****************************************
    // Save Public Key
    // ****************************************
    Matrix<uint8_t, kPublicKeyRows, kPublicKeyCols> publicKey(pk);
    savePublicKey(xxFinale, publicKey);
}

//
// Verify
//
#ifdef _MSC_VER
using vec16 = __m128i;
__forceinline static void xor16(vec16* dst, const vec16* src)
{
    _mm_store_si128(dst, _mm_xor_si128(_mm_load_si128(dst), _mm_loadu_si128(src)));
}
#else
using vec16 = __attribute__((vector_size(16))) unsigned int;
__attribute__((always_inline)) static void xor16(vec16* dst, const vec16* src)
{
    *dst ^= *src;
}
#endif

void verifySign(
    const uint8_t SignatureIn[SIGNATURE_SIZE],
    MatrixView<uint8_t, kPublicKeyRows, kPublicKeyCols> publicKey,
    uint8_t result[kPublicKeyCols]
)
{
    alignas(16) uint8_t Signature[SIGNATURE_SIZE];
    memcpy(Signature, SignatureIn, SIGNATURE_SIZE);
    int pubkeyIndex = 0;

    // The xor of the constant part:
    memcpy(result, publicKey[pubkeyIndex], kPublicKeyCols);

    pubkeyIndex++;

    for (int i = 0; i < N; i++)
    {
        uint8_t byteindex = i >> 3;
        uint8_t bitindex = 0x80 >> (i & 0x07);
        if (Signature[byteindex] & bitindex)
        {
            xor16(reinterpret_cast<vec16*>(result), reinterpret_cast<const vec16*>(publicKey[pubkeyIndex]));
        }
        pubkeyIndex++;
    }

    for (int firstX = 0; firstX < N; firstX++)
    {
        uint8_t byteindex_firstX = firstX >> 3;
        uint8_t bitindex_firstX = 0x80 >> (firstX & 0x07);
        if (Signature[byteindex_firstX] & bitindex_firstX)
        {
            for (int secondX = firstX + 1; secondX < N; secondX++)
            {
                // uint_fast16_t indexOfSymbolicQuadrat = pubkeyIndex;
                uint8_t byteindex_secondX = secondX >> 3;
                uint8_t bitindex_secondX = 0x80 >> (secondX & 0x07);
                // The xor:
                if (Signature[byteindex_secondX] & bitindex_secondX)
                {
                    xor16(reinterpret_cast<vec16*>(result), reinterpret_cast<const vec16*>(publicKey[pubkeyIndex]));
                }
                pubkeyIndex++;
            }
        }
        else
        {
            pubkeyIndex += N - firstX - 1;
        }
    }
}

int verifyHash(const uint8_t msgHash[64], const uint8_t sig[SIGNATURE_SIZE], const uint8_t pk[PUBLICKEY_SIZE])
{
    MQQALIGNED(16) uint8_t result[kPublicKeyCols];
    MatrixView<uint8_t, kPublicKeyRows, kPublicKeyCols> pubKey((const uint8_t*)pk);

    // Make a signature of the hash, using the public key:
    verifySign(sig, pubKey, result);

    // Check if the signature is good, -1 is returned if its not.
    if (0 != memcmp(result, msgHash + kPublicKeyFirstRow / 8, kPublicKeyRowsToStore / 8))
        return -1;

    return 0;
}

//int verify(const void* msg, size_t msglen, const uint8_t sig[SIGNATURE_SIZE], const uint8_t pk[PUBLICKEY_SIZE])
//{
//    if (nullptr == msg || 0 == msglen)
//        return -1;
//
//    MQQALIGNED(16) uint8_t result[kPublicKeyCols];
//    MatrixView<uint8_t, kPublicKeyRows, kPublicKeyCols> pubKey((const uint8_t*)pk);
//    const std::vector<uint8_t> hash = blake3<64>(msg, msglen);
//
//    // Make a signature of the hash, using the public key:
//    verifySign(sig, pubKey, result);
//
//    // Check if the signature is good, -1 is returned if its not.
//    if (0 != memcmp(result, hash.data() + kPublicKeyFirstRow / 8, kPublicKeyRowsToStore / 8))
//        return -1;
//
//    return 0;
//}

//
// Sign
//
CONTEXT::CONTEXT(const uint8_t sk[PRIVATEKEY_SIZE])
{
    const uint8_t* mqq_cc1 = sk + 72;
    const uint8_t* mqq_cc2 = sk + 81;
    const uint8_t* mqq_sigma1 = sk + 90;
    const uint8_t* mqq_sigmaK = sk + 250;

    // Set mqq_a
    memcpy(mqq_a, sk, 72);
    for (int i = 0; i < 9; i++)
        mqq_a[8 * 9 + i] = mqq_cc2[i];
    memcpy(cc1, mqq_cc1, 9);
    memcpy(cc2, mqq_cc2, 9);
    memcpy(sigma1, mqq_sigma1, N);
    memcpy(sigmaK, mqq_sigmaK, N);

    for (int i = 0; i < 256; i++)
    {
        for (int j = 0; j < 256; j++)
        {
            privateKeyLookupTable[j * 256 + i] = Q(0, j, i, mqq_a, cc1, cc2);
        }
    }

    for (int i = 0; i < 256; i++)
    {
        for (int j = 0; j < 256; j++)
        {
            privateKeyLookupTable[256 * 256 + j * 256 + i] = Q(1, j, i, mqq_a, cc1, cc2);
        }
    }
}

void signHash(const unsigned char hash[64], const CONTEXT& ctx, uint8_t result[SIGNATURE_SIZE])
{
    uint8_t i;
    MQQALIGNED(16) uint8_t localResult[N / 8];
    MQQALIGNED(16) uint8_t localHash[512 / 8];

    memcpy(localHash, hash, 64);
    inverseAffineTransformation(localHash, result, ctx.sigma1, ctx.sigmaK, false);
    localResult[0] = result[0];
    for (i = 1; i < N / 8; i++)
    {
        uint8_t res_i = result[i];
        localResult[i] = ctx.privateKeyLookupTable[256 * 256 * (i & 1) + 256 * localResult[i - 1] + res_i];
    }
    inverseAffineTransformation(localResult, result, ctx.sigma1, ctx.sigmaK, true);
}

//int sign(uint8_t sig[SIGNATURE_SIZE], const void* msg, size_t msglen, const CONTEXT& ctx)
//{
//    if (nullptr == msg || 0 == msglen)
//        return -1;
//    MQQALIGNED(16) uint8_t result[N / 8];
//    const std::vector<uint8_t> hash = blake3<64>(msg, msglen);
//    // Make a signature of the hash, using the key sk:
//    signHash(hash.data(), ctx, result);
//    // Write the signature into the start of sm:
//    memcpy(sig, result, N / 8);
//    return 0;
//}

} // namespace mqq160
