#ifndef atom_type_h
#define atom_type_h

#include <stdio.h>

static long long atom_type = -1;

static void atom_type_init(void)
{
  FILE *f = 0;
  int s = 0;

  if (atom_type != -1) return;
  atom_type = 0; // XXX: could use, e.g., 10 as fallback
  f = fopen("/sys/bus/event_source/devices/cpu_atom/type","r");
  if (!f) return;
  s = fscanf(f,"%lld",&atom_type);
  fclose(f);
  if (s < 1) atom_type = 0;
}

#endif
