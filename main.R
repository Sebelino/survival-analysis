library(biostat3)
library(collett)
library(xtable)

data <- biostat3::colon_sample
data$status_bin <- ifelse(data$status == "Dead: cancer", 1, 0)

actuarial <- biostat3::lifetab2(Surv(surv_yy, status_bin) ~ 1,
  data = data,
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
  data = data
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

kaplan_table <- kaplan_meier(data$surv_mm, data$status_bin)

library(survminer)

plt <- ggsurvplot(
  kaplan,
  data = data,
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

truncated_fit <- survfit(Surv(entry_mm, surv_mm, status_bin) ~ 1, data = d)

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

kaplan_meier_truncated <- function(entry_time, exit_time, event) {
  # Combine the data into a data frame and order by exit_time
  data <- data.frame(entry_time, exit_time, event)
  data <- data[order(data$exit_time), ]

  # Extract unique exit times
  unique_times <- unique(data$exit_time)

  # Initialize variables
  n_at_risk <- numeric(length(unique_times))
  n_events <- numeric(length(unique_times))
  survival <- numeric(length(unique_times))

  # Loop through unique times to calculate survival probabilities
  for (i in seq_along(unique_times)) {
    t <- unique_times[i]

    # Number at risk at time t (accounting for left truncation)
    n_at_risk[i] <- sum(data$entry_time <= t & data$exit_time >= t)

    # Number of events at time t
    n_events[i] <- sum(data$exit_time == t & data$event == 1)

    # Survival probability
    if (i == 1) {
      survival[i] <- 1 - n_events[i] / n_at_risk[i]
    } else {
      survival[i] <- survival[i - 1] * (1 - n_events[i] / n_at_risk[i])
    }
  }

  # Return the results as a data frame
  return(data.frame(
    time = unique_times,
    n_at_risk = n_at_risk,
    n_events = n_events,
    survival = survival
  ))
}

kmt <- kaplan_meier_truncated(d$entry_mm, d$surv_mm, d$status_bin)
