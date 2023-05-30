#include "fe.h"
#include "crypto_int64.h"

void fe_sq(fe h, const fe f)
{
  fe_mul(h, f, f);
}
