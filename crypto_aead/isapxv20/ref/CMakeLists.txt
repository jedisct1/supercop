cmake_minimum_required (VERSION 3.3.2)
project (ISAP)

############################
#   CHOOSE ISAP INSTANCE   #
############################

add_definitions(-DISAP128)
#add_definitions(-DISAP128A)

##########################
#   CHOOSE PERMUTATION   #
##########################

#add_definitions(-DASCON)
add_definitions(-DKECCAKP400)

########################
#   EN/DISABLE DEBUG   #
########################

add_definitions(-DDEBUG=0)
#add_definitions(-DDEBUG=1)

########################
#   COMPILE COMMANDS   #
########################

#set(CMAKE_C_FLAGS "-std=c99 -Wall -Wextra -Wshadow -fsanitize=address,undefined -O2")
set(CMAKE_C_FLAGS "-march=native -O3 -DNDEBUG")

add_library(
  CRYPTO_AEAD
  STATIC
  crypto_aead.c
  isap.c
  permutation.c
  lib/KeccakP-400-reference/KeccakP-400-reference.c
  lib/Ascon-reference/Ascon-reference.c
)
set_target_properties(CRYPTO_AEAD PROPERTIES OUTPUT_NAME "isap")

add_executable(EXE_GENKAT_AEAD genkat_aead.c)
target_link_libraries(EXE_GENKAT_AEAD CRYPTO_AEAD)
set_target_properties(EXE_GENKAT_AEAD PROPERTIES OUTPUT_NAME "genkat_aead" SUFFIX "")
