# survival-analysis

Build project:

```bash
make
```

Hand calculation of the estimated survival function:

https://docs.google.com/spreadsheets/d/e/2PACX-1vTItxAOyn4xjoGzQTSZ6BQMtMa41w6HzzTTXcqALzR5RlRW_q1oprasVz-vxKGeeEAIoA1vsoQxlVr_/pubhtml

## Misc

```
      sex age     stage mmdx yydx surv_mm surv_yy       status                subsite entry_mm status_bin
1    Male  72 Localised    2 1989       2    0.01  Dead: other Descending and sigmoid        0          0
2  Female  82   Distant   12 1991       2    0.01 Dead: cancer Descending and sigmoid        0          1
3    Male  73   Distant   11 1993       3    0.01 Dead: cancer Descending and sigmoid        0          1
4    Male  63   Distant    6 1988       5    0.01 Dead: cancer             Transverse        0          1
5    Male  67 Localised    5 1989       7    0.01 Dead: cancer             Transverse        0          1
6    Male  74  Regional    7 1992       8    0.01 Dead: cancer   Coecum and ascending        0          1
7  Female  56   Distant    1 1986       9    0.01 Dead: cancer             Transverse        1          1
8  Female  52   Distant    5 1986      11    0.01 Dead: cancer   Coecum and ascending        1          1
9    Male  64 Localised   11 1994      13    1.00        Alive Descending and sigmoid        0          0
10 Female  70 Localised   10 1994      14    1.00        Alive Descending and sigmoid        0          0
11 Female  83 Localised    7 1990      19    1.00  Dead: other Descending and sigmoid        0          0
12   Male  64   Distant    8 1989      22    1.00 Dead: cancer Descending and sigmoid        0          1
13 Female  79 Localised   11 1993      25    2.00        Alive Descending and sigmoid        0          0
14 Female  70   Distant    6 1988      27    2.00 Dead: cancer   Coecum and ascending        0          1
15   Male  70  Regional    9 1993      27    2.00        Alive   Coecum and ascending        0          0
16 Female  68   Distant    9 1991      28    2.00 Dead: cancer Descending and sigmoid        0          1
17   Male  58 Localised   11 1990      32    2.00 Dead: cancer Descending and sigmoid        0          1
18   Male  54   Distant    4 1990      32    2.00 Dead: cancer   Coecum and ascending        0          1
19 Female  86 Localised    4 1993      32    2.00        Alive Descending and sigmoid        0          0
20   Male  31 Localised    1 1990      33    2.00 Dead: cancer   Coecum and ascending        0          1
21 Female  75 Localised    1 1993      35    2.00        Alive Descending and sigmoid        0          0
22 Female  85 Localised   11 1992      37    3.00        Alive   Coecum and ascending        0          0
23 Female  68   Distant    7 1986      43    3.00 Dead: cancer Descending and sigmoid        2          1
24   Male  54  Regional    6 1985      46    3.00 Dead: cancer             Transverse       15          1
25   Male  80 Localised    6 1991      54    4.00        Alive   Coecum and ascending        0          0
26 Female  52 Localised    7 1989      77    6.00        Alive             Transverse        0          0
27   Male  52 Localised    6 1989      78    6.00        Alive Descending and sigmoid        0          0
28   Male  65 Localised    1 1989      83    6.00        Alive Descending and sigmoid        0          0
29   Male  60 Localised   11 1988      85    7.00        Alive             Transverse        0          0
30 Female  71 Localised   11 1987      97    8.00        Alive Descending and sigmoid        0          0
31   Male  58 Localised    8 1987     100    8.00        Alive Descending and sigmoid        0          0
32 Female  80 Localised    5 1987     102    8.00 Dead: cancer Descending and sigmoid        0          1
33   Male  66 Localised    1 1986     103    8.00  Dead: other   Coecum and ascending        7          0
34   Male  67 Localised    3 1987     105    8.00        Alive   Coecum and ascending        0          0
35 Female  56   Distant   12 1986     108    9.00        Alive             Transverse        7          0
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
