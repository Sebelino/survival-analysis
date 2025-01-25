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
  summary <- fit |> summary()
  var_log <- with(summary, cumsum(n.event / (n.risk * (n.risk - n.event))))
  z <- qnorm(1-(1-0.95)/2)
  lower_ci <- log(summary$surv) - z * sqrt(var_log)
  upper_ci <- log(summary$surv) + z * sqrt(var_log)
  return(data.frame(
    time = summary$time,
    surv = summary$surv,
    var_log = var_log,
    lower_ci = lower_ci,
    upper_ci = upper_ci
  ))
}

out <- kaplan_meier(sample$surv_mm, sample$status_bin)
