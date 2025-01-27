# survival-analysis

Build project:

```bash
make
```

Hand calculation of the estimated survival function:

https://docs.google.com/spreadsheets/d/e/2PACX-1vTItxAOyn4xjoGzQTSZ6BQMtMa41w6HzzTTXcqALzR5RlRW_q1oprasVz-vxKGeeEAIoA1vsoQxlVr_/pubhtml

## Misc

```
> d %>% select(-subsite,-stage)
      sex age mmdx yydx surv_mm surv_yy       status entry_mm status_bin
1    Male  72    2 1989       2    0.01  Dead: other        0          0
2  Female  82   12 1991       2    0.01 Dead: cancer        0          1
3    Male  73   11 1993       3    0.01 Dead: cancer        0          1
4    Male  63    6 1988       5    0.01 Dead: cancer        0          1
5    Male  67    5 1989       7    0.01 Dead: cancer        0          1
6    Male  74    7 1992       8    0.01 Dead: cancer        0          1
7  Female  56    1 1986       9    0.01 Dead: cancer        1          1
8  Female  52    5 1986      11    0.01 Dead: cancer        1          1
9    Male  64   11 1994      13    1.00        Alive        0          0
10 Female  70   10 1994      14    1.00        Alive        0          0
11 Female  83    7 1990      19    1.00  Dead: other        0          0
12   Male  64    8 1989      22    1.00 Dead: cancer        0          1
13 Female  79   11 1993      25    2.00        Alive        0          0
14 Female  70    6 1988      27    2.00 Dead: cancer        0          1
15   Male  70    9 1993      27    2.00        Alive        0          0
16 Female  68    9 1991      28    2.00 Dead: cancer        0          1
17   Male  58   11 1990      32    2.00 Dead: cancer        0          1
18   Male  54    4 1990      32    2.00 Dead: cancer        0          1
19 Female  86    4 1993      32    2.00        Alive        0          0
20   Male  31    1 1990      33    2.00 Dead: cancer        0          1
21 Female  75    1 1993      35    2.00        Alive        0          0
22 Female  85   11 1992      37    3.00        Alive        0          0
23 Female  68    7 1986      43    3.00 Dead: cancer        2          1
24   Male  54    6 1985      46    3.00 Dead: cancer       15          1
25   Male  80    6 1991      54    4.00        Alive        0          0
26 Female  52    7 1989      77    6.00        Alive        0          0
27   Male  52    6 1989      78    6.00        Alive        0          0
28   Male  65    1 1989      83    6.00        Alive        0          0
29   Male  60   11 1988      85    7.00        Alive        0          0
30 Female  71   11 1987      97    8.00        Alive        0          0
31   Male  58    8 1987     100    8.00        Alive        0          0
32 Female  80    5 1987     102    8.00 Dead: cancer        0          1
33   Male  66    1 1986     103    8.00  Dead: other        7          0
34   Male  67    3 1987     105    8.00        Alive        0          0
35 Female  56   12 1986     108    9.00        Alive        7          0
> survfit(Surv(entry_mm, surv_mm, status_bin) ~ 1, data = d) |> summary()
Call: survfit(formula = Surv(entry_mm, surv_mm, status_bin) ~ 1, data = d)

 time n.risk n.event survival std.err lower 95% CI upper 95% CI
    2     31       1    0.968  0.0317        0.908        1.000
    3     30       1    0.935  0.0441        0.853        1.000
    5     29       1    0.903  0.0531        0.805        1.000
    7     28       1    0.871  0.0602        0.761        0.997
    8     29       1    0.841  0.0652        0.722        0.979
    9     28       1    0.811  0.0694        0.686        0.959
   11     27       1    0.781  0.0731        0.650        0.938
   22     24       1    0.748  0.0769        0.612        0.915
   27     22       1    0.714  0.0806        0.573        0.891
   28     20       1    0.679  0.0841        0.532        0.865
   32     19       2    0.607  0.0891        0.455        0.810
   33     16       1    0.569  0.0913        0.416        0.779
   43     13       1    0.525  0.0942        0.370        0.747
   46     12       1    0.482  0.0960        0.326        0.712
  102      4       1    0.361  0.1267        0.182        0.718
```

Interpretation:

* t=0: Start of the study. At this point, the risk set consists of 29 patients.
The researchers are unaware that 6 more patients will enter the study later.
* t=1: Risk set: 29 patients. 2 patients now enter the study (rows 7, 8),
increasing the risk set by 2.
* t=2: Risk set: 31. One patient dies of cancer. One dies of other causes. One
person enters the study (row 23). Risk set will be reduced by 2-1=1.
* t=3: Risk set: 30. One patient dies of cancer.
* t=5: Risk set: 29. One patient dies of cancer.
