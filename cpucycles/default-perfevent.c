// version 20251226
// public domain
// djb

// 20251226 djb: add ticks_close()
// 20251225 djb: use PERF_FLAG_FD_CLOEXEC
// 20250925 djb: do disable-enable (suggested by jim apple re graviton 3), but only if read() seems to always return 0
// 20250925 djb: try all possible exclude combinations
// 20230106 djb: read() into int64_t instead of long long
// 20230106 djb: add comment on RUNNING/ENABLED
// 20230105 djb: adapted from supercop/cpucycles/perfevent.c

/*
This code intentionally avoids dividing by the
PERF_FORMAT_TOTAL_TIME_RUNNING/ENABLED ratio.

The motivation for that ratio is as follows:

* A typical CPU has a limited number of performance-monitoring
  counters active at once. For example, there are 8 "programmable"
  counters on Intel Skylake.

* "perf stat" allows the user to enable more counters. The OS kernel
  periodically (e.g., every millisecond) changes the limited number of
  active hardware counters to a new subset of the enabled counters, and
  "perf stat" reports PERF_FORMAT_TOTAL_TIME_RUNNING/ENABLED for each
  counter, the fraction of time spent with that counter running.

For long-running programs, dividing the hardware counter by
RUNNING/ENABLED usually produces a reasonable estimate of what the count
would have been without competition from other counters.

A fixable problem with this multiplexing of counters is that the kernel
appears to simply cycle through counters, so unlucky programs can
trigger moiré effects. The fix is to select random subsets of counters.

A more fundamental problem is that cpucycles() has to be usable for
timing short subroutines, including subroutines so short that the OS has
no opportunity to change from one selection of counters to another. Say
RUNNING is 0; should cpucycles() then divide by 0?

If a caller runs cpucycles(), X(), cpucycles(), X(), etc., and the cycle
counter happens to be enabled for only 80% of the runs of X(), then
simply computing the median difference of adjacent cycle counts, with no
scaling, will filter out the zeros and correctly compute the cost of X.
Averages won't (without scaling), but averages have other problems, such
as being heavily influenced by interrupts. (Omitting kernel time from
perf results does not remove the influence of interrupts on caches.)

Given the importance of cycle counting, it is better to have cycle
counters always running. For example, on Skylake, Intel provides the 8
"programmable" counters on top of a separate cycle counter ("fixed
counter 1"), so there is no good reason for the kernel to waste a
"programmable" counter on a cycle counter, there is no good reason to
turn the cycle counter off, and there is no good reason for RUNNING to
be below ENABLED for the cycle counter.

Of course, applications that use just one performance counter at a time
don't have to worry about kernels getting this wrong, and don't have to
worry about the possibility of getting noisy or invalid results on CPUs
that have heavier constraints on the number of simultaneous counters.
*/

#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <linux/perf_event.h>
#include "cpucycles_internal.h"

#ifndef PERF_FLAG_FD_CLOEXEC
#define PERF_FLAG_FD_CLOEXEC 0
#endif

static int fdperf = -1;
static int de = 1;

long long ticks(void)
{
  int64_t result;

  if (de) ioctl(fdperf,PERF_EVENT_IOC_DISABLE,0);
  if (read(fdperf,&result,sizeof result) < sizeof result) result = 0;
  if (de) ioctl(fdperf,PERF_EVENT_IOC_ENABLE,0);
  return result;
}

void ticks_close(void)
{
  if (fdperf >= 0) close(fdperf);
  fdperf = -1;
  de = 1;
}

long long ticks_setup(void)
{
  int xkernel,xhv,loop;

  if (fdperf == -1) {
    // prefer to exclude if platform supports that
    // but fall back to non-exclude if necessary
    for (xkernel = 1;xkernel >= 0;--xkernel) {
      for (xhv = 1;xhv >= 0;--xhv) {
        static struct perf_event_attr attr;

        memset(&attr,0,sizeof attr);
        attr.type = PERF_TYPE_HARDWARE;
        attr.size = sizeof(struct perf_event_attr);
        attr.config = PERF_COUNT_HW_CPU_CYCLES;
        attr.disabled = 1;
        attr.exclude_kernel = xkernel;
        attr.exclude_hv = xhv;

        fdperf = syscall(__NR_perf_event_open,&attr,0,-1,-1,PERF_FLAG_FD_CLOEXEC);
        if (fdperf != -1) break;
      }
      if (fdperf != -1) break;
    }
    if (fdperf == -1) return cpucycles_SKIP;

    ioctl(fdperf,PERF_EVENT_IOC_RESET,0);
    ioctl(fdperf,PERF_EVENT_IOC_ENABLE,0);
  }

  for (loop = 0;loop < 100;++loop) {
    int64_t result;
    if (read(fdperf,&result,sizeof result) < sizeof result) result = 0;
    if (result != 0) { de = 0; break; }
  }

  return cpucycles_MAYBECYCLECOUNTER;
}
