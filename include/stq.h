#ifndef stq_h
#define stq_h

/*
stq_longlong sets doubles stq[0],stq[1],stq[2]
to the three stabilized quartiles of the long long input array.
See https://cr.yp.to/papers.html#rsrst for background.

stq2_longlong returns a long long close to
the second stabilized quartile of the long long input array.

The use of floating-point here avoids overflow issues
at the expense of minor rounding issues.
*/

#ifdef __cplusplus
#include <vector>
#define stq_doublearray std::vector<double>
#else
#define stq_doublearray double *
#endif

static double stq_mean(const stq_doublearray S,long long n)
{
  if (n <= 0) return 0;
  double sum = 0;
  for (long long i = 0;i < n;++i) sum += S[i];
  return sum/(double) n;
}

static void stq_sort(stq_doublearray S,long long n)
{
  if (n < 2) return;
  long long t = 1;
  while (t < n - t) t += t;
  for (long long p = t;p > 0;p >>= 1) {
    for (long long i = 0;i < n - p;++i)
      if (!(i & p))
        if (S[i] > S[i+p]) {
          double t = S[i];
          S[i] = S[i+p];
          S[i+p] = t;
        }
    for (long long q = t;q > p;q >>= 1)
      for (long long i = 0;i < n - q;++i)
        if (!(i & p))
          if (S[i+p] > S[i+q]) {
            double t = S[i+p];
            S[i+p] = S[i+q];
            S[i+q] = t;
          }
  }
}

static void stq_longlong(double *stq,const long long *x,long long n)
{
  if (n <= 0) return;
#ifdef __cplusplus
  stq_doublearray S(8*n);
#else
  double S[8*n];
#endif
  /* could skip some doublings if n already has some powers of 2 */
  for (long long i = 0;i < n;++i)
    for (long long j = 0;j < 8;++j)
      S[8*i+j] = x[i];
  stq_sort(S,8*n);
#ifdef __cplusplus
  stq_doublearray X(2*n);
  for (long long loop = 0;loop < 3;++loop) {
    for (long long i = 0;i < 2*n;++i)
      X[i] = S[n+loop*2*n+i];
    stq[loop] = stq_mean(X,2*n);
  }
#else
  stq[0] = stq_mean(S+n,2*n);
  stq[1] = stq_mean(S+3*n,2*n);
  stq[2] = stq_mean(S+5*n,2*n);
#endif
}

static long long stq2_longlong(const long long *x,long long n)
{
  if (n <= 0) return 0;
  if (n == 1) return x[0];
  double stq[3];
  stq_longlong(stq,x,n);
  long long result = stq[1];
  if (result < stq[1]-0.5) result += 1;
  if (result > stq[1]+0.5) result -= 1;
  /* or could use round() at expense of requiring -lm */
  /* or (typically) could just convert stq[1]+0.5 */
  /* in any case very unusual to care about differences of 1 here */
  return result;
}

#endif
