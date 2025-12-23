#packages + data
library(tidyverse)
inhibition_data <- read_csv("~/Downloads/il1b_inhibition_data - Sheet1.csv")

t.test(inhibition_data$affinity_1ITB, inhibition_data$affinity_3O4O, paired = TRUE)