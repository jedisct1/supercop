#!/usr/bin/env python3

import sys

operation = sys.argv[1]

var = []
function = []
loop = []
expected = '0'
unexpected = 'nonzero'
extrabytes = '0'

publicdata = ('PUBLICKEYBYTES','NONCEBYTES','CIPHERTEXTBYTES','variablelengthciphertext')

if operation == 'core':
  loop = 512
  var = [['h','OUTPUTBYTES'],['n','INPUTBYTES'],['k','KEYBYTES'],['c','CONSTBYTES']]
  function = [['',['h'],[],['n','k','c']]]

if operation == 'hashblocks':
  loop = 4096
  var = [['h','STATEBYTES'],['m',0]]
  function = [['',[],['h'],['m','mlen']]]
  expected = 'mlen % crypto_hashblocks_BLOCKBYTES'
  unexpected = 'unexpected value'

if operation == 'xof':
  loop = 64
  var = [['h',0],['m',0]]
  function = [['',['h','hlen'],[],['m','mlen']]]

if operation == 'hash':
  loop = 64
  var = [['h','BYTES'],['m',0]]
  function = [['',['h'],[],['m','mlen']]]

if operation == 'stream':
  loop = 512
  var = [['k','KEYBYTES'],['n','NONCEBYTES'],['m',0],['c','variablelengthciphertext'],['s',0]]
  function = [['',['s'],[],['slen','n','k']],['_xor',['c'],[],['m','mlen','n','k']]]

if operation in ['auth','onetimeauth']:
  loop = 4096
  var = [['h','BYTES'],['m',0],['k','KEYBYTES']]
  function = [['',['h'],[],['m','mlen','k']],['_verify',[],[],['h','m','mlen','k']]]

if operation == 'secretbox':
  loop = 4096
  var = [['k','KEYBYTES']]
  var += [['n','NONCEBYTES']]
  var += [['m',0]] # original message
  var += [['c','variablelengthciphertext']] # boxed message
  var += [['t',0]] # opened message
  function = [['',['c'],[],['m','mlen','n','k']]]
  function += [['_open',['t'],[],['c','clen','n','k']]]

if operation == 'aead':
  loop = 64
  var = [['k','KEYBYTES']]
  var += [['s','NSECBYTES']]
  var += [['p','NPUBBYTES']]
  var += [['a',0]] # additional data
  var += [['m',0]] # original message
  var += [['c','variablelengthciphertext']] # boxed message
  var += [['t',0]] # opened message
  var += [['r','NSECBYTES']] # opened s
  function = [['_encrypt',['c','&clen'],[],['m','mlen','a','alen','s','p','k']]]
  function += [['_decrypt',['t','&tlen','r'],[],['c','clen','a','alen','p','k']]]
  extrabytes = 'crypto_aead_ABYTES'

if operation == 'rng':
  loop = 64
  var = [['k','KEYBYTES']]
  var += [['r','OUTPUTBYTES']]
  var += [['n','KEYBYTES']]
  function = [['',['r','n'],[],['k']]]

if operation == 'scalarmult':
  loop = 64
  var = [['a','SCALARBYTES']] # alice secret key
  var += [['b','SCALARBYTES']] # bob secret key
  var += [['c','BYTES']] # alice public key
  var += [['d','BYTES']] # bob public key
  var += [['e','BYTES']] # alice shared secret
  var += [['f','BYTES']] # bob shared secret
  function = [['_base',['c'],[],['a']]]
  function += [['_base',['d'],[],['b']]]
  function += [['',['e'],[],['a','d']]]
  function += [['',['f'],[],['b','c']]]

if operation == 'box':
  loop = 512
  var = [['a','SECRETKEYBYTES']] # alice secret key
  var += [['b','SECRETKEYBYTES']] # bob secret key
  var += [['y','PUBLICKEYBYTES']] # alice public key
  var += [['z','PUBLICKEYBYTES']] # bob public key
  var += [['e','BEFORENMBYTES']] # alice shared secret
  var += [['f','BEFORENMBYTES']] # bob shared secret
  var += [['n','NONCEBYTES']]
  var += [['m',0]] # original message
  var += [['c','variablelengthciphertext']] # boxed message
  var += [['d','variablelengthciphertext']] # boxed message, second try
  var += [['t',0]] # opened message
  function = [['_keypair',['y','a'],[],[]]]
  function += [['_keypair',['z','b'],[],[]]]
  function += [['',['c'],[],['m','mlen','n','z','a']]]
  function += [['_open',['t'],[],['c','clen','n','y','b']]]
  function += [['_beforenm',['e'],[],['z','a']]]
  function += [['_beforenm',['f'],[],['y','b']]]
  function += [['_afternm',['d'],[],['m','mlen','n','e']]]
  function += [['_open_afternm',['t'],[],['d','dlen','n','f']]]

if operation == 'dh':
  loop = 64
  var = [['a','SECRETKEYBYTES']] # alice secret key
  var += [['b','SECRETKEYBYTES']] # bob secret key
  var += [['c','PUBLICKEYBYTES']] # alice public key
  var += [['d','PUBLICKEYBYTES']] # bob public key
  var += [['e','BYTES']] # alice shared secret
  var += [['f','BYTES']] # bob shared secret
  function = [['_keypair',['c','a'],[],[]]]
  function += [['_keypair',['d','b'],[],[]]]
  function += [['',['e'],[],['d','a']]]
  function += [['',['f'],[],['c','b']]]

if operation == 'sign':
  loop = 8
  var = [['p','PUBLICKEYBYTES']]
  var += [['s','SECRETKEYBYTES']]
  var += [['m',0]] # original message
  var += [['c','variablelengthciphertext']] # signed message
  var += [['t',0]] # opened message
  function = [['_keypair',['p','s'],[],[]]]
  function += [['',['c','&clen'],[],['m','mlen','s']]]
  function += [['_open',['t','&tlen'],[],['c','clen','p']]]
  extrabytes = 'crypto_sign_BYTES'

if operation == 'encrypt':
  loop = 8
  var = [['p','PUBLICKEYBYTES']]
  var += [['s','SECRETKEYBYTES']]
  var += [['m',0]] # original message
  var += [['c','variablelengthciphertext']] # encrypted message
  var += [['t',0]] # opened message
  function = [['_keypair',['p','s'],[],[]]]
  function += [['',['c','&clen'],[],['m','mlen','p']]]
  function += [['_open',['t','&tlen'],[],['c','clen','s']]]
  extrabytes = 'crypto_encrypt_BYTES'

if operation == 'kem':
  loop = 8
  var = [['p','PUBLICKEYBYTES']]
  var += [['s','SECRETKEYBYTES']]
  var += [['k','BYTES']]
  var += [['c','CIPHERTEXTBYTES']]
  var += [['t','BYTES']]
  function = [['_keypair',['p','s'],[],[]]]
  function += [['_enc',['c','k'],[],['p']]]
  function += [['_dec',['t'],[],['c','s']]]

length = dict()
for v,n in var: length[v] = n

print('/*')
print(' * crypto_%s/try.c version 20240530' % operation)
print(' * D. J. Bernstein')
print(' * Public domain.')
print(' * Auto-generated by trygen.py; do not edit.')
print(' */')
print('')
print('#include "crypto_%s.h"' % operation)
print('#include "try.h"')
if operation in ['box','encrypt','scalarmult','sign']:
  print('#include "randombytes.h"')
print('')
print('const char *primitiveimplementation = crypto_%s_IMPLEMENTATION;' % operation)
print('')

tunebytes = not operation in ['core','dh','scalarmult']
if tunebytes:
  print('#define TUNE_BYTES 1536')
  print('#ifdef SMALL')
  print('#define MAXTEST_BYTES 128')
  print('#else')
  if operation == 'xof':
    print('#define MAXTEST_BYTES 16384')
  else:
    print('#define MAXTEST_BYTES 4096')
  print('#endif')

print('#ifdef TIMECOP')
print('#define LOOPS TIMECOP_LOOPS')
print('#else')
print('#ifdef SMALL')
print('#define LOOPS %s' % loop)
print('#else')
print('#define LOOPS %s' % (loop * 8))
print('#endif')
print('#endif')
print('')
print('#include "test-loops.inc"')
print('')

for v,n in var:
  print('static unsigned char *%s;' % v)

for v,n in var:
  print('static unsigned char *%s2;' % v)

for v,n in var:
  if n in (0,'variablelengthciphertext'):
    print('unsigned long long %slen;' % v)
  else:
    print('#define %slen crypto_%s_%s' % (v,operation,n))

# preallocate(): before resource limits are set
print('')
print('void preallocate(void)')
print('{')
if operation in ['dh','encrypt','kem','sign']:
  print('#ifdef RAND_R_PRNG_NOT_SEEDED')
  print('  RAND_status();')
  print('#endif')
print('}')

# allocate(): set aside storage for test, predoit, doit
print('')
print('void allocate(void)')
print('{')
print('  unsigned long long alloclen = 0;')
if tunebytes:
  if extrabytes != '0':
    print('  if (alloclen < TUNE_BYTES + %s) alloclen = TUNE_BYTES + %s;' % (extrabytes,extrabytes))
    print('  if (alloclen < MAXTEST_BYTES + %s) alloclen = MAXTEST_BYTES + %s;' % (extrabytes,extrabytes))
  else:
    print('  if (alloclen < TUNE_BYTES) alloclen = TUNE_BYTES;')
    print('  if (alloclen < MAXTEST_BYTES) alloclen = MAXTEST_BYTES;')
for v,n in var:
  if n in (0,'variablelengthciphertext'):
    pass
  else:
    print('  if (alloclen < crypto_%s_%s) alloclen = crypto_%s_%s;' % (operation,n,operation,n))
for v,n in var:
  print('  %s = alignedcalloc(alloclen);' % v)
for v,n in var:
  print('  %s2 = alignedcalloc(alloclen);' % v)
print('}')

print('')
print('void unalign(void)')
print('{')
for v,n in var:
  print('  ++%s;' % v)
for v,n in var:
  print('  ++%s2;' % v)
print('}')

print('')
print('void realign(void)')
print('{')
for v,n in var:
  print('  --%s;' % v)
for v,n in var:
  print('  --%s2;' % v)
print('}')

# predoit(): precomputations for doit
print('')
print('void predoit(void)')
print('{')
if operation == 'scalarmult':
  print('  randombytes(a,alen);')
  print('  randombytes(b,blen);')
if operation == 'box':
  print('  crypto_box_keypair(y,a);')
  print('  crypto_box_keypair(z,b);')
  print('  unpoison(y,crypto_box_PUBLICKEYBYTES);')
  print('  unpoison(z,crypto_box_PUBLICKEYBYTES);')
  print('  randombytes(m,mlen);')
  print('  randombytes(n,nlen);')
if operation == 'encrypt':
  print('  crypto_encrypt_keypair(p,s);')
  print('  unpoison(p,crypto_encrypt_PUBLICKEYBYTES);')
  print('  mlen = TUNE_BYTES;')
  print('  clen = 0;')
  print('  randombytes(m,mlen);')
if operation == 'kem':
  print('  crypto_kem_keypair(p,s);')
  print('  unpoison(p,crypto_kem_PUBLICKEYBYTES);')
if operation == 'sign':
  print('  crypto_sign_keypair(p,s);')
  print('  unpoison(p,crypto_sign_PUBLICKEYBYTES);')
  print('  mlen = TUNE_BYTES;')
  print('  clen = 0;')
  print('  randombytes(m,mlen);')
print('}')

# doit(): main computations to select implementation
print('')
print('void doit(void)')
print('{')
if operation == 'aead':
  print('  crypto_aead_encrypt(c,&clen,m,TUNE_BYTES,a,TUNE_BYTES,s,p,k);')
  print('  unpoison(c,clen);')
  print('  crypto_aead_decrypt(t,&tlen,r,c,clen,a,TUNE_BYTES,p,k);')
if operation == 'auth':
  print('  crypto_auth(h,m,TUNE_BYTES,k);')
  print('  crypto_auth_verify(h,m,TUNE_BYTES,k);')
if operation == 'box':
  print('  crypto_box(c,m,TUNE_BYTES + crypto_box_ZEROBYTES,n,y,b);')
  print('  unpoison(c,clen);')
  print('  crypto_box_open(t,c,TUNE_BYTES + crypto_box_ZEROBYTES,n,z,a);')
if operation == 'core':
  print('  crypto_core(h,n,k,c);')
if operation == 'dh':
  print('  crypto_dh_keypair(c,a);')
  print('  crypto_dh_keypair(d,b);')
  print('  unpoison(c,crypto_dh_PUBLICKEYBYTES);')
  print('  unpoison(d,crypto_dh_PUBLICKEYBYTES);')
  print('  crypto_dh(e,d,a);')
  print('  crypto_dh(f,c,b);')
if operation == 'encrypt':
  print('  crypto_encrypt(c,&clen,m,mlen,p);')
  print('  unpoison(c,clen);')
  print('  crypto_encrypt_open(t,&tlen,c,clen,s);')
if operation == 'kem':
  print('  crypto_kem_enc(c,k,p);')
  print('  unpoison(c,clen);')
  print('  crypto_kem_dec(t,c,s);')
if operation == 'hashblocks':
  print('  crypto_hashblocks(h,m,TUNE_BYTES);')
if operation == 'xof':
  print('  crypto_xof(h,TUNE_BYTES,m,TUNE_BYTES);')
if operation == 'hash':
  print('  crypto_hash(h,m,TUNE_BYTES);')
if operation == 'onetimeauth':
  print('  crypto_onetimeauth(h,m,TUNE_BYTES,k);')
  print('  crypto_onetimeauth_verify(h,m,TUNE_BYTES,k);')
if operation == 'rng':
  print('  crypto_rng(r,n,k);')
if operation == 'scalarmult':
  print('  crypto_scalarmult_base(c,a);')
  print('  crypto_scalarmult_base(d,b);')
  print('  crypto_scalarmult(e,a,d);')
  print('  crypto_scalarmult(f,b,c);')
if operation == 'secretbox':
  print('  crypto_secretbox(c,m,TUNE_BYTES + crypto_secretbox_ZEROBYTES,n,k);')
  print('  unpoison(c,clen);')
  print('  crypto_secretbox_open(t,c,TUNE_BYTES + crypto_secretbox_ZEROBYTES,n,k);')
if operation == 'sign':
  print('  crypto_sign(c,&clen,m,mlen,s);')
  print('  unpoison(c,clen);')
  print('  crypto_sign_open(t,&tlen,c,clen,p);')
if operation == 'stream':
  print('  crypto_stream_xor(c,m,TUNE_BYTES,n,k);')
if operation == 'verify':
  print('  crypto_verify(x,y);')
print('}')

# test(): try test vectors, compute checksum
print('')
print('void test(void)')
print('{')
indent = '  '
if operation in ['stream','secretbox','box']:
  print(indent+'unsigned long long j;')
print(indent+'unsigned long long loop;')
if operation not in ['xof']:
  print(indent+'int result;')
print(indent)
print(indent+'for (loop = 0;loop < LOOPS;++loop) {')
indent += '  '

if not operation in ['core','rng','scalarmult','dh','kem']:
  print(indent+'mlen = myrandom() % (MAXTEST_BYTES + 1);')

if operation == 'xof':
  print(indent+'hlen = myrandom() % (MAXTEST_BYTES + 1);')
if operation == 'aead':
  print(indent+'alen = myrandom() % (MAXTEST_BYTES + 1);')
if operation == 'stream':
  print(indent+'clen = mlen;')
  print(indent+'slen = mlen;')
if operation == 'secretbox':
  print(indent+'clen = mlen;')
  print(indent+'tlen = mlen;')
  print(indent+'if (mlen < crypto_%s_ZEROBYTES) continue;' % operation)
if operation == 'box':
  print(indent+'clen = mlen;')
  print(indent+'dlen = mlen;')
  print(indent+'tlen = mlen;')
  print(indent+'if (mlen < crypto_%s_ZEROBYTES) continue;' % operation)

initialized = set()

for f,output,inout,input in function:
  print(indent)
  cof = 'crypto_'+operation+f

  if cof in ['crypto_aead_encrypt']:
    print(indent+'clen = mlen + crypto_%s_ABYTES;' % operation)
  if cof in ['crypto_encrypt','crypto_sign']:
    print(indent+'clen = mlen + %s_BYTES;' % cof)
  if cof in ['crypto_encrypt_open','crypto_sign_open','crypto_aead_decrypt']:
    print(indent+'tlen = clen;')

  for v in output:
    if len(v) == 1:
      print(indent+'output_prepare(%s2,%s,%slen);' % (v,v,v))
      # v now has CDE where C is canary, D is canary, E is canary
      # v2 now has same CDE
      # D is at start of v with specified length
      # C is 16 bytes before beginning
      # E is 16 bytes past end
  for v in input + inout:
    if len(v) == 1:
      if v in initialized:
        print(indent+'memcpy(%s2,%s,%slen);' % (v,v,v))
        print(indent+'double_canary(%s2,%s,%slen);' % (v,v,v))
      else:
        print(indent+'input_prepare(%s2,%s,%slen);' % (v,v,v))
        # v now has CTE where C is canary, T is test data, E is canary
        # v2 has same CTE
        initialized.add(v)

  if cof in ['crypto_secretbox','crypto_box']:
    print(indent+'for (j = 0;j < %s_ZEROBYTES;++j) m[j] = 0;' % cof)
    print(indent+'for (j = 0;j < %s_ZEROBYTES;++j) m2[j] = 0;' % cof)

  for v in inout + input:
    if len(v) == 1:
      if length[v] in publicdata:
        print(indent+'unpoison(%s,%slen);' % (v,v))
      else:
        print(indent+'poison(%s,%slen);' % (v,v))

  args = ','.join(output + inout + input)
  if operation in ['xof']:
    print(indent+'%s(%s);' % (cof,args))
  else:
    print(indent+'result = %s(%s);' % (cof,args))
    print(indent+'unpoison(&result,sizeof result);')
    print(indent+'if (result != %s) fail("%s returns %s");' % (expected,cof,unexpected))

  for v in output + inout + input:
    if len(v) == 1:
      print(indent+'unpoison(%s,%slen);' % (v,v))

  if cof in ['crypto_encrypt','crypto_sign','crypto_aead_encrypt']:
    print(indent+'if (clen < mlen) fail("%s returns smaller output than input");' % cof)
    print(indent+'if (clen > mlen + %s) fail("%s returns more than %s extra bytes");' % (extrabytes,cof,extrabytes))
  if cof in ['crypto_encrypt_open','crypto_sign_open','crypto_aead_decrypt']:
    print(indent+'if (tlen != mlen) fail("%s does not match mlen");' % cof)
  if cof in ['crypto_encrypt_open','crypto_sign_open','crypto_aead_decrypt','crypto_secretbox_open','crypto_box_open','crypto_box_open_afternm']:
    print(indent+'if (memcmp(t,m,mlen) != 0) fail("%s does not match m");' % cof)
  if cof in ['crypto_kem_dec']:
    print(indent+'if (memcmp(t,k,klen) != 0) fail("%s does not match k");' % cof)
  if cof in ['crypto_aead_decrypt']:
    print(indent+'if (memcmp(r,s,slen) != 0) fail("%s does not match s");' % cof)
  if cof in ['crypto_box_afternm']:
    print(indent+'if (memcmp(d,c,clen) != 0) fail("%s does not match c");' % cof)
  if cof in ['crypto_secretbox','crypto_box']:
    print(indent+'for (j = 0;j < %s_BOXZEROBYTES;++j)' % cof)
    print(indent+'  if (c[j] != 0) fail("%s does not clear extra bytes");' % cof)

  if cof == 'crypto_stream_xor':
    print(indent)
    print(indent+'for (j = 0;j < mlen;++j)')
    print(indent+'  if ((s[j] ^ m[j]) != c[j]) fail("crypto_stream_xor does not match crypto_stream");')

  for v in output + inout:
    if len(v) == 1:
      print(indent+'checksum(%s,%slen);' % (v,v))
      # output v,v2 now has COE,CDE where O is output; checksum O
      initialized.add(v)
  for v in output + inout:
    if len(v) == 1:
      if cof == 'crypto_sign_open' and v == 't':
        print(indent+'output_compare(%s2,%s,%slen,"%s");' % (v,v,'c',cof))
      elif cof == 'crypto_encrypt_open' and v == 't':
        print(indent+'output_compare(%s2,%s,%slen,"%s");' % (v,v,'c',cof))
      elif cof == 'crypto_aead_decrypt' and v == 't':
        print(indent+'output_compare(%s2,%s,%slen,"%s");' % (v,v,'c',cof))
      else:
        print(indent+'output_compare(%s2,%s,%slen,"%s");' % (v,v,v,cof))
        # output_compare checks COE,CDE for equal C, equal E
  for v in input:
    if len(v) == 1:
      print(indent+'input_compare(%s2,%s,%slen,"%s");' % (v,v,v,cof))
      # input_compare checks CTE,CTE for equal C, equal T, equal E

  deterministic = True
  if inout + input == []: deterministic = False
  if cof == 'crypto_encrypt': deterministic = False
  if cof == 'crypto_kem_enc': deterministic = False

  if deterministic:
    print(indent)
    if cof == 'crypto_sign': print('#if crypto_sign_DETERMINISTIC == 1')
    for v in output + inout + input:
      if len(v) == 1:
        print(indent+'double_canary(%s2,%s,%slen);' % (v,v,v))
        # old output v,v2: COE,CDE; new v,v2: FOG,FDG where F,G are new canaries
        # old inout v,v2: COE,CTE; new v,v2: FOG,FTG
        # old input v,v2: CTE,CTE; new v,v2: FTG,FTG

    for v in inout + input:
      if len(v) == 1:
        if length[v] in publicdata:
          print(indent+'unpoison(%s2,%slen);' % (v,v))
        else:
          print(indent+'poison(%s2,%slen);' % (v,v))

    args = ','.join([v if v[-3:] == 'len' else v+'2' for v in output + inout + input])
    if operation in ['xof']:
      print(indent+'%s(%s);' % (cof,args))
    else:
      print(indent+'result = %s(%s);' % (cof,args))
      print(indent+'unpoison(&result,sizeof result);')
      print(indent+'if (result != %s) fail("%s returns %s");' % (expected,cof,unexpected))

    for v in output + inout + input:
      if len(v) == 1:
        print(indent+'unpoison(%s2,%slen);' % (v,v))

    for w in output + inout:
      if len(w) == 1:
        # w,w2: COE,COE; goal now is to compare O
        print(indent+'if (memcmp(%s2,%s,%slen) != 0) fail("%s is nondeterministic");' % (w,w,w,cof))
    if cof == 'crypto_sign': print('#endif')

  overlap = deterministic
  if inout != []: overlap = False
  if cof == 'crypto_stream': overlap = False

  if overlap:
    for y in output:
      if len(y) == 1:
        print(indent)
        if cof == 'crypto_sign': print('#if crypto_sign_DETERMINISTIC == 1')
        if operation == 'aead': print('#if crypto_aead_NOOVERLAP == 1')
        if operation == 'aead': print('#else')
        if operation == 'xof': print('#if crypto_xof_NOOVERLAP == 1')
        if operation == 'xof': print('#else')
        for v in output:
          if len(v) == 1:
            print(indent+'double_canary(%s2,%s,%slen);' % (v,v,v))
        for v in input:
          if len(v) == 1:
            print(indent+'double_canary(%s2,%s,%slen);' % (v,v,v))
        # redundant: have already created output for this input
        # args = ','.join(output + input)
        # print(indent+'if (%s(%s) != %s) fail("%s returns %s");' % (cof,args,expected,cof,unexpected))
        for x in input:
          if len(x) == 1:
            # try writing to x2 instead of y, while reading x2
            args = ','.join([x+'2' if v==y else v for v in output] + [x+'2' if v==x else v for v in input])

            for v in input:
              v2 = x+'2' if v==x else v
              if len(v) == 1:
                if length[v] in publicdata:
                  print(indent+'unpoison(%s,%slen);' % (v2,v))
                else:
                  print(indent+'poison(%s,%slen);' % (v2,v))

            if operation in ['xof']:
              print(indent+'%s(%s);' % (cof,args))
            else:
              print(indent+'result = %s(%s);' % (cof,args))
              print(indent+'unpoison(&result,sizeof result);')
              print(indent+'if (result != %s) fail("%s with %s=%s overlap returns %s");' % (expected,cof,x,y,unexpected))

            for v in output:
              v2 = x+'2' if v==y else v
              if len(v) == 1:
                print(indent+'unpoison(%s,%slen);' % (v2,v))
            for v in input:
              if v == x: continue
              if len(v) == 1:
                print(indent+'unpoison(%s,%slen);' % (v,v))

            print(indent+'if (memcmp(%s2,%s,%slen) != 0) fail("%s does not handle %s=%s overlap");' % (x,y,y,cof,x,y))
            print(indent+'memcpy(%s2,%s,%slen);' % (x,x,x))
        if cof == 'crypto_sign': print('#endif')
        if operation == 'aead': print('#endif')
        if operation == 'xof': print('#endif')

  if cof in ['crypto_auth_verify','crypto_onetimeauth_verify']:
    print(indent)
    for tweaks in range(3):
      print(indent+'h[myrandom() % hlen] += 1 + (myrandom() % 255);')
      print(indent+'if (%s(h,m,mlen,k) == 0)' % cof)
      print(indent+'  if (memcmp(h2,h,hlen) != 0)')
      print(indent+'    fail("%s accepts modified authenticators");' % cof)

  if cof in ['crypto_sign_open']:
    print(indent)
    for tweaks in range(3):
      print(indent+'c[myrandom() % clen] += 1 + (myrandom() % 255);')
      print(indent+'if (%s(t,&tlen,c,clen,p) == 0)' % cof)
      print(indent+'  if ((tlen != mlen) || (memcmp(t,m,mlen) != 0))')
      print(indent+'    fail("%s allows trivial forgeries");' % cof)

  if cof in ['crypto_kem_dec']:
    print(indent)
    for tweaks in range(3):
      print(indent+'c[myrandom() % clen] += 1 + (myrandom() % 255);')
      print(indent+'if (%s(t,c,s) == 0)' % cof)
      print(indent+'  checksum(t,tlen);')
      print(indent+'else')
      print(indent+'  checksum(c,clen);')

  if cof in ['crypto_aead_decrypt']:
    print(indent)
    for tweaks in range(3):
      print(indent+'c[myrandom() % clen] += 1 + (myrandom() % 255);')
      print(indent+'if (%s(t,&tlen,r,c,clen,a,alen,p,k) == 0)' % cof)
      print(indent+'  if ((tlen != mlen) || (memcmp(t,m,mlen) != 0) || (memcmp(r,s,slen) != 0))')
      print(indent+'    fail("%s allows trivial forgeries");' % cof)

  if cof in ['crypto_dh','crypto_scalarmult'] and output == ['f']:
    print(indent)
    print(indent+'if (memcmp(f,e,elen) != 0) fail("%s not associative");' % cof)

indent = indent[:-2]
print(indent+'}')
print('#include "test-more.inc"')
print('}')
