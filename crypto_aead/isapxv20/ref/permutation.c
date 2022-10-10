#include <stdio.h>
#include "isap.h"

#ifdef KECCAKP400
#include "KeccakP-400-SnP.h"
#elif defined(ASCON)
#include "Ascon-reference.h"
#endif

void print_state(void* state){
	printf("     ");
	for (size_t i = 0; i < ISAP_STATE_SZ; i++) {
		printf("%02X",((unsigned char*)state)[i]);
	}
	printf("\n");
}

void Permutation_Initialize(
	void *state
){
	if(DEBUG) printf("   # Initializing state #\n");
	#ifdef KECCAKP400
	KeccakP400_Initialize(state);
	#elif defined(ASCON)
	Ascon_Initialize(state);
	#endif
	if(DEBUG) print_state(state);
}

void Permutation_AddBytes(
	void *state,
	const unsigned char *data,
	unsigned int offset,
	unsigned int length
){
	if(DEBUG) printf("   # Adding %u bytes starting at state[%u] #\n",length,offset);
	#ifdef KECCAKP400
	KeccakP400_AddBytes(state,data,offset,length);
	#elif defined(ASCON)
	Ascon_AddBytes(state,data,offset,length);
	#endif
	if(DEBUG) print_state(state);
}

void Permutation_OverwriteBytes(
	void *state,
	const unsigned char *data,
	unsigned int offset,
	unsigned int length
){
	if(DEBUG) printf("   # Overwriting %u bytes starting at state[%u] #\n",length,offset);
	#ifdef KECCAKP400
	KeccakP400_OverwriteBytes(state,data,offset,length);
	#elif defined(ASCON)
	Ascon_OverwriteBytes(state,data,offset,length);
	#endif
	if(DEBUG) print_state(state);
}

void Permutation_Permute_Nrounds(
	void *state,
	unsigned int nrounds
){
	if(DEBUG) printf("   # Permuting %u times #\n",nrounds);
	#ifdef KECCAKP400
	KeccakP400_Permute_Nrounds(state,nrounds);
	#elif defined(ASCON)
	Ascon_Permute_Nrounds(state,nrounds);
	#endif
	if(DEBUG) print_state(state);
}

void Permutation_ExtractBytes(
	const void *state,
	unsigned char *data,
	unsigned int offset,
	unsigned int length
){
	if(DEBUG) printf("   # Extracting %u bytes starting from state[%u] #\n",length,offset);
	#ifdef KECCAKP400
	KeccakP400_ExtractBytes(state,data,offset,length);
	#elif defined(ASCON)
	Ascon_ExtractBytes(state,data,offset,length);
	#endif
}

