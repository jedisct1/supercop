#ifndef AES_H
#define AES_H

#include <stdint.h>
#include <stdlib.h>
#include <immintrin.h>
#include <wmmintrin.h> 


#define AES256_KEYBYTES 32
#define AES256_NROUNDS 14

// AES with AVX implementation
void AES_256_Key_Expansion (const unsigned char *userkey, unsigned char *key);

void AES_ECB_encrypt(const unsigned char *in, 
                    unsigned char *out, 
                    const unsigned char *key, 
                    int number_of_rounds);
#endif
