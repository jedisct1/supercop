#include "gf_util.h"

#include "params.h"
#include "randombytes.h"

#include <stdio.h>

gf gf_random()
{
        gf t;

        randombytes((unsigned char *) &t, sizeof(gf));
        t &= GFMASK;

        return t;
}

void gf_dump(gf a)
{
	int i;

	printf("(");
	printf("%d", a & 1);
	for (i = 1; i < GFBITS; i++)
		printf(" + %d * a^%d", (a >> i) & 1, i);
	printf(")");
}

void gf_list_dump(gf *L, int n)
{
	int i;

	printf("[");
	gf_dump(L[0]);

	for (i = 1; i < n; i++)
	{
		printf(", ");
		gf_dump(L[i]);
	}

	printf("]");
}

void GF_dump(gf *p)
{
	int i;

	printf("(");
	gf_dump(p[0]);

	for (i = 1; i < 119; i++)
	{
		printf(" + ");
		gf_dump(p[i]);
		printf(" * x^%d", i);
	}

	printf(")");
}

void gf2_list_dump(unsigned char *L, int n)
{
	int i;

	printf("[ %d", L[0] & 1);

	for (i = 1; i < n; i++)
	{
		printf(", %d", (L[i / 8] >> (i % 8)) & 1);
	}

	printf("]");
}

