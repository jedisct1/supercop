#ifndef SMAUG_IO_H
#define SMAUG_IO_H

#include <stdlib.h>

#include "ciphertext.h"
#include "key.h"
#include "parameters.h"
#include "poly.h"
#include "verify.h"

// For ciphertext
#define save_to_string SMAUG_NAMESPACE(save_to_string)
void save_to_string(uint8_t *output, const ciphertext *ctxt);
#define save_to_file SMAUG_NAMESPACE(save_to_file)
void save_to_file(char *file_path, const uint8_t *ctxt);
#define load_from_string SMAUG_NAMESPACE(load_from_string)
void load_from_string(ciphertext *ctxt, const uint8_t *input);
#define load_from_file SMAUG_NAMESPACE(load_from_file)
void load_from_file(uint8_t *ctxt, const char *file_path);

// For secret key
#define save_to_string_sk SMAUG_NAMESPACE(save_to_string_sk)
void save_to_string_sk(uint8_t *output, const secret_key *sk);
#define save_to_file_sk SMAUG_NAMESPACE(save_to_file_sk)
void save_to_file_sk(char *file_path, const uint8_t *sk, const int isPKE);
#define load_from_string_sk SMAUG_NAMESPACE(load_from_string_sk)
void load_from_string_sk(secret_key *sk, const uint8_t *input);
#define load_from_file_sk SMAUG_NAMESPACE(load_from_file_sk)
void load_from_file_sk(uint8_t *sk, const char *file_path, const int isPKE);

// For public key
#define save_to_string_pk SMAUG_NAMESPACE(save_to_string_pk)
void save_to_string_pk(uint8_t *output, const public_key *pk);
#define save_to_file_pk SMAUG_NAMESPACE(save_to_file_pk)
void save_to_file_pk(char *file_path, const uint8_t *pk);
#define load_from_string_pk SMAUG_NAMESPACE(load_from_string_pk)
void load_from_string_pk(public_key *pk, const uint8_t *input);
#define load_from_file_pk SMAUG_NAMESPACE(load_from_file_pk)
void load_from_file_pk(uint8_t *pk, const char *file_path);

#endif // SMAUG_IO_H