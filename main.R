library(biostat3)
library(collett)
library(xtable)

sample <- biostat3::colon_sample
sample$status_bin <- ifelse(sample$status == "Dead: cancer", 1, 0)

actuarial <- biostat3::lifetab2(Surv(surv_yy, status_bin) ~ 1,
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
  ylim = 0:1
)

kaplan_meier <- function(time, event) {
  surv <- Surv(time, event)
  fit <- survfit(surv ~ 1)
  summary <- fit |> summary()
  var_log <- with(summary, cumsum(n.event / (n.risk * (n.risk - n.event))))
  z <- qnorm(1 - (1 - 0.95) / 2)
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

library(survminer)

plt <- ggsurvplot(
  kaplan,
  data = sample,
  conf.int = TRUE,
  risk.table = FALSE,
  xlab = "Discontinuation time",
  ylab = "Estimated survivor function",
  title = "Kaplan-Meier Survival Curve",
  ggtheme = theme_minimal()
)
print(plt)

set.seed(12345)
d <- biostat3::colon_sample |>
  transform(entry_mm = ifelse(
    yydx == 1985,
    sample(13:24, 35, replace = TRUE),
    ifelse(
      yydx == 1986,
      sample(1:12, 35, replace = TRUE),
      0
    )
  ))
## check that all of the entry dates are less than the survival times
stopifnot(with(d, all(entry_mm < surv_mm)))
d$status_bin <- ifelse(d$status == "Dead: cancer", 1, 0)
truncated_fit <- survfit(Surv(entry_mm, surv_mm, status_bin)~1, data=d)

plt <- ggsurvplot(
  truncated_fit,
  data = d,
  conf.int = TRUE,
  risk.table = FALSE,
  xlab = "Discontinuation time",
  ylab = "Estimated survivor function",
  title = "Kaplan-Meier Survival Curve",
  ggtheme = theme_minimal()
)
print(plt)
