#include "skinny128.h"
#include "romulus.h"
#include "domain.h"
#include <string.h>

//Encryption and authentication using Romulus-N1
int crypto_aead_encrypt
    (unsigned char *c, unsigned long long *clen,
     const unsigned char *m, unsigned long long mlen,
     const unsigned char *ad, unsigned long long adlen,
     const unsigned char *nsec,
     const unsigned char *npub,
     const unsigned char *k) {

    u64 tmp_mlen = mlen;
    u32 tmp;
    const u8* m_auth = m;
    u8 final_domain = 0x30;
    skinny_128_384_tks tks;
    u8 state[BLOCKBYTES], pad[BLOCKBYTES];
    (void)nsec;

    // ----------------- Initialization -----------------
    *clen = mlen + TAGBYTES;
    memset(tks.tk1, 0x00, KEYBYTES);
    memset(state, 0x00, BLOCKBYTES);
    tks.tk1[0] = 0x01;                      // Init the 56-bit LFSR counter
    // ----------------- Initialization -----------------

    // ----------------- Process the associated data -----------------
    final_domain ^= final_ad_domain(adlen, mlen);
    SET_DOMAIN(tks, 0x28);
    while (adlen > 2*BLOCKBYTES) {          // Process double blocks but the last
        UPDATE_CTR(tks.tk1);
        XOR_BLOCK(state, state, ad);
        tkschedule_lfsr(tks.rtk, ad + BLOCKBYTES, k, SKINNY128_384_ROUNDS);
        tkschedule_perm(tks.rtk);
        tkschedule_perm_tk1(tks.rtk1, tks.tk1);
        skinny128_384(state, tks.rtk, state, tks.rtk1);
        UPDATE_CTR(tks.tk1);
        ad += 2*BLOCKBYTES;
        adlen -= 2*BLOCKBYTES;
    }
    // Pad and process the left-over blocks 
    if (adlen == 2*BLOCKBYTES) {            // Left-over complete double block
        UPDATE_CTR(tks.tk1);
        XOR_BLOCK(state, state, ad);
        tkschedule_lfsr(tks.rtk, ad + BLOCKBYTES, k, SKINNY128_384_ROUNDS);
        tkschedule_perm(tks.rtk);
        tkschedule_perm_tk1(tks.rtk1, tks.tk1);
        skinny128_384(state, tks.rtk, state, tks.rtk1);
        UPDATE_CTR(tks.tk1);
    } else if (adlen > BLOCKBYTES) {        // Left-over partial double block
        adlen -= BLOCKBYTES;
        UPDATE_CTR(tks.tk1);
        XOR_BLOCK(state, state, ad);
        memcpy(pad, ad + BLOCKBYTES, adlen);
        memset(pad + adlen, 0x00, 15 - adlen);
        pad[15] = adlen;                    // Padding
        tkschedule_lfsr(tks.rtk, pad, k, SKINNY128_384_ROUNDS);
        tkschedule_perm(tks.rtk);
        tkschedule_perm_tk1(tks.rtk1, tks.tk1);
        skinny128_384(state, tks.rtk, state, tks.rtk1);
        UPDATE_CTR(tks.tk1);
    } else {
        SET_DOMAIN(tks, 0x2C);
        UPDATE_CTR(tks.tk1);
        if (adlen == BLOCKBYTES) {          // Left-over complete single block 
            XOR_BLOCK(state, state, ad);
        } else {                            // Left-over partial single block
            for(int i =0; i < adlen; i++)
                state[i] ^= ad[i];
            state[15] ^= adlen;             // Padding
        }
        if (tmp_mlen >= BLOCKBYTES) {
            tkschedule_lfsr(tks.rtk, m_auth, k, SKINNY128_384_ROUNDS);
            tkschedule_perm(tks.rtk);
            tkschedule_perm_tk1(tks.rtk1, tks.tk1);
            skinny128_384(state, tks.rtk, state, tks.rtk1);
            m_auth += BLOCKBYTES;
            tmp_mlen -= BLOCKBYTES;
            if (tmp_mlen > BLOCKBYTES) {
                UPDATE_CTR(tks.tk1);
            }
        } else {
            memcpy(pad, m_auth, tmp_mlen);
            memset(pad + tmp_mlen, 0x00, BLOCKBYTES - tmp_mlen - 1);
            pad[15] = (u8)tmp_mlen;             // Padding
            tkschedule_lfsr(tks.rtk, pad, k, SKINNY128_384_ROUNDS);
            tkschedule_perm(tks.rtk);
            tkschedule_perm_tk1(tks.rtk1, tks.tk1);
            skinny128_384(state, tks.rtk, state, tks.rtk1);
            tmp_mlen = 0;
        }
    }
    // Process all message double blocks except the last
    SET_DOMAIN(tks, 0x2C);
    while (tmp_mlen > 32) {
        UPDATE_CTR(tks.tk1);
        XOR_BLOCK(state, state, m_auth);
        tkschedule_lfsr(tks.rtk, m_auth + BLOCKBYTES, k, SKINNY128_384_ROUNDS);
        tkschedule_perm(tks.rtk);
        tkschedule_perm_tk1(tks.rtk1, tks.tk1);
        skinny128_384(state, tks.rtk, state, tks.rtk1);
        UPDATE_CTR(tks.tk1);
        m_auth += 2 * BLOCKBYTES;
        tmp_mlen -= 2 * BLOCKBYTES;
    }
    // Process the last message double block
    if (tmp_mlen == 2 * BLOCKBYTES) {             // Last message double block is full
        UPDATE_CTR(tks.tk1);
        XOR_BLOCK(state, state, m_auth);
        tkschedule_lfsr(tks.rtk, m_auth + BLOCKBYTES, k, SKINNY128_384_ROUNDS);
        tkschedule_perm(tks.rtk);
        tkschedule_perm_tk1(tks.rtk1, tks.tk1);
        skinny128_384(state, tks.rtk, state, tks.rtk1);
    } else if (tmp_mlen > BLOCKBYTES) {         // Last message double block is partial
        tmp_mlen -= BLOCKBYTES;
        UPDATE_CTR(tks.tk1);
        XOR_BLOCK(state, state, m_auth);
        memcpy(pad, m_auth + BLOCKBYTES, tmp_mlen);
        memset(pad + tmp_mlen, 0x00, BLOCKBYTES - tmp_mlen - 1);
        pad[15] = (u8)tmp_mlen;                 // Padding
        tkschedule_lfsr(tks.rtk, pad, k, SKINNY128_384_ROUNDS);
        tkschedule_perm(tks.rtk);
        tkschedule_perm_tk1(tks.rtk1, tks.tk1);
        skinny128_384(state, tks.rtk, state, tks.rtk1);
    } else if (tmp_mlen == BLOCKBYTES) {        // Last message single block is full
        XOR_BLOCK(state, state, m_auth);
    } else if (tmp_mlen > 0) {                  // Last message single block is partial
        for(int i =0; i < (int)tmp_mlen; i++)
            state[i] ^= m_auth[i];
        state[15] ^= (u8)tmp_mlen;              // Padding
    }
    // Process the last partial block
    SET_DOMAIN(tks, final_domain);
    UPDATE_CTR(tks.tk1);
    tkschedule_lfsr(tks.rtk, npub, k, SKINNY128_384_ROUNDS);
    tkschedule_perm(tks.rtk);
    tkschedule_perm_tk1(tks.rtk1, tks.tk1);
    skinny128_384(state, tks.rtk, state, tks.rtk1);
    // ----------------- Process the associated data -----------------


    // ----------------- Generate the tag -----------------
    G(state,state);
    memcpy(c + mlen, state, TAGBYTES);
    // ----------------- Generate the tag -----------------

    memset(tks.tk1, 0x00, KEYBYTES);
    tks.tk1[0] = 0x01;                      // Init the 56-bit LFSR counter
    if (mlen > 0) {
        SET_DOMAIN(tks, 0x24);
        while (mlen > BLOCKBYTES) {
            tkschedule_perm_tk1(tks.rtk1, tks.tk1);
            skinny128_384(state, tks.rtk, state, tks.rtk1);
            RHO(state,c,m);
            UPDATE_CTR(tks.tk1);
            c += BLOCKBYTES;
            m += BLOCKBYTES;
            mlen -= BLOCKBYTES;
        }
        tkschedule_perm_tk1(tks.rtk1, tks.tk1);
        skinny128_384(state, tks.rtk, state, tks.rtk1);
        for(int i = 0; i < (int)mlen; i++) {
            tmp = m[i];                     // Use of tmp variable in case c = m
            c[i] = m[i] ^ (state[i] >> 1) ^ (state[i] & 0x80) ^ (state[i] << 7);
            state[i] ^= (u8)tmp;
        }
        state[15] ^= (u8)mlen;              // Padding
    }

    return 0;
}
