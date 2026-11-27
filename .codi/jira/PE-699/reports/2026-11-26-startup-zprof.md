# Startup measurement (zprof) — PE-699

Context: OpenSpec change `review-zsh-modules-lifecycle`, acceptance test 7. Measure startup with `ZSH_DEBUG=1` (`zprof`) before and after the change on Linux and macOS; verify no regression greater than 10%.

## Linux methodology

- `ZSH_DEBUG=1` enabled zprof.
- 5 alternating wall-clock runs per state, best-of-4 zprof profiles.
- Before state: `fh33-before` cache dir; after state: `fh33` cache dir.
- Profiles captured in `/home/lucho/tmp/opencode/pb_4.out` (before) and `/home/lucho/tmp/opencode/pa_4.out` (after).

## Linux results

- Wall-clock median: 0.808s → 0.633s.
- zprof total self: 904ms → 772ms = −14.6%.
- No regression greater than 10%.

## Top-10 zprof entries — BEFORE (pb_4.out)

```
 1)    5          54.47    10.89   12.05%     54.47    10.89   12.05%  __rvm_db
 2)    1          46.08    46.08   10.19%     46.08    46.08   10.19%  antidote-zsh
 3)    1          28.44    28.44    6.29%     28.44    28.44    6.29%  _mise_hook
 4)    1          30.75    30.75    6.80%     27.84    27.84    6.16%  __rvm_check_rvmrc_trustworthiness
 5)    1         202.01   202.01   44.69%     26.86    26.86    5.94%  rvm::internal::rvm::load
 6)    1         100.59   100.59   22.25%     18.67    18.67    4.13%  load_rvm_scripts
 7)    6          18.19     3.03    4.02%     18.19     3.03    4.02%  git
 8)    1          45.18    45.18    9.99%     16.56    16.56    3.66%  devops::mise::internal::load
 9)    1          22.52    22.52    4.98%     14.88    14.88    3.29%  __rvm_detect_system
10)    2          13.76     6.88    3.04%     13.76     6.88    3.04%  __rvm_grep
```

## Top-10 zprof entries — AFTER (pa_4.out)

```
 1)    1          55.90    55.90   14.48%     55.90    55.90   14.48%  antidote-zsh
 2)    5          31.71     6.34    8.22%     31.71     6.34    8.22%  __rvm_db
 3)    1         149.80   149.80   38.81%     29.00    29.00    7.51%  rvm::internal::rvm::load
 4)    1          79.23    79.23   20.53%     25.13    25.13    6.51%  load_rvm_scripts
 5)    6          18.09     3.02    4.69%     18.09     3.02    4.69%  git
 6)    1          16.14    16.14    4.18%     16.14    16.14    4.18%  _mise_hook
 7)    1          91.39    91.39   23.68%     15.08    15.08    3.91%  antidote-load
 8)    1          13.97    13.97    3.62%     12.83    12.83    3.32%  __rvm_check_rvmrc_trustworthiness
 9)    1          28.67    28.67    7.43%     12.40    12.40    3.21%  devops::mise::internal::load
10)    1          17.48    17.48    4.53%     11.11    11.11    2.88%  __rvm_detect_system
```

## macOS pending

Task 5.6 remains open until macOS data is collected. Run on a macOS host:

```
ZSH_DEBUG=1 zsh -i -c exit
```

Capture the zprof output (best-of-4) and record wall-clock median plus top-10 entries here; mark task 5.6 complete only after macOS data is recorded.
