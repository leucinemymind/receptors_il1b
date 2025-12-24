#packages + data

# t-test
library(tidyverse)
inhibition_data_tidy <- read_csv("~/Dropbox/getcontacts/receptors_il1b/autodock/il1b_inhibition_data - Sheet1 (1).csv")
inhibition_data_normal <- read_csv("~/Dropbox/getcontacts/receptors_il1b/autodock/il1b_inhibition_data - Sheet1 (2).csv")

ggplot(inhibition_data_tidy, aes(x = protein, y = affinity)) +
  geom_boxplot(fill = "skyblue") +
  geom_jitter(width = 0.1, alpha = 0.5) +
  labs(title = "Docking Affinities", x = "protein", y = "affinity (kcal/mol)") +
  theme_minimal()

t.test(inhibition_data_normal$affinity_1ITB, inhibition_data_normal$affinity_3O4O, paired = TRUE)

ggplot(data = inhibition_data_normal, aes(x = logP, y = difference)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "LogP vs Difference in Affinity", x = "LogP", y = "Difference in Affinity (1ITB - 3O4O)") +
  theme_minimal()