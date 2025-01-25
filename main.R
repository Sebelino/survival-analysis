library(biostat3)
library(collett)
library(xtable)

sample <- biostat3::colon_sample
sample$status_bin <- ifelse(sample$status == "Dead: cancer", 1, 0)

actuarial <- lifetab2(Surv(surv_yy, status_bin) ~ 1,
  data = sample,
  breaks = c(seq(0, 10, by = 1), Inf)
)

plot(actuarial,
  type = "p",
  pch = 19,
  xlab = "Survival time",
  ylab = "Estimated survivor function",
  ylim = 0:1
)
lines(actuarial, type = "s", lty = 2)

kaplan <- survfit(
  Surv(surv_mm, status_bin) ~ 1,
  data = sample
)

kaplan |> plot(
  xlab = "Discontinuation time",
  ylab = "Estimated survivor function",
  conf.int = FALSE,
  ylim = 0:1
)

kaplan_meier <- function(time, event) {
  surv <- Surv(time, event)
  fit <- survfit(surv ~ 1)
  output <- fit |>
    summary() |>
    (\(x) data.frame(
      time = x$time,
      surv = x$surv
    ))()
  return(output)
}

out <- kaplan_meier(sample$surv_mm, sample$status_bin)
