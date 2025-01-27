library(biostat3) # melanoma
melanoma <-
  transform(biostat3::melanoma,
    death_cancer = ifelse(status == "Dead: cancer", 1, 0),
    death_all = ifelse(status %in% c("Dead: cancer", "Dead: other"), 1, 0)
  )

distribution <- table(melanoma$stage)

print(distribution)

# Unknown Localised  Regional   Distant
# 1631      5318       350       476

# Majority of the patients are diagnosed in the localised stage, i.e. early.
# A large poportion of cases have an unknown stage at diagnosis.
# This could be due to incomplete medical records or difficulty in classifying
# certain cases. Excluding unknown cases from the analysis may introduce bias
# if the unknown cases are not randomly distributed. For example, older patients
# may be more prone to have an unknown stage.
