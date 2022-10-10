### Configuring Code:

* Enable/disable debug mode -> see CMakeLists.txt
* Choose ISAP instance -> see CMakeLists.txt

### Building Code:

    mkdir build
    cd build
    cmake ..
    make

### Executing Code:

    ./genkat_aead

### External Sources:

* KeccakP-400-SnP.h, KeccakP-400-reference.c:
  * From: [eXtended Keccak Code Package](https://github.com/XKCP/XKCP/tree/master/lib/low/KeccakP-400/Reference)
  * Copyright: See file header

* brg_endian.h:
  * From: [eXtended Keccak Code Package](https://github.com/XKCP/XKCP/tree/master/lib/common)
  * Copyright: See file header

* Ascon-reference.h, Ascon-reference.c:
  * From: [Ascon Software Repository](https://github.com/ascon/crypto_aead/archive/master.zip)
  * Copyright: See zip folder

### Implementation By:

* [Robert Primas](https://rprimas.github.io)

