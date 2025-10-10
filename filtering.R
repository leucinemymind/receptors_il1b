### filtering out contacts that are not unique (SAVE lookup table) and original spreadsheets ###
### 2025-10-09 ###

library(readr)
library(tidyr)

df_1ITB <- read.csv("~/Dropbox/getcontacts/receptors_il1b/unique_1ITB.csv")
df_3O4O <- read.csv("~/Dropbox/getcontacts/receptors_il1b/unique_3O4O.csv")
mapping <- read.csv("~/Dropbox/getcontacts/receptors_il1b/contact_alignment.csv")

# split into 3 separate columns

df_1ITB_split <- separate(df_1ITB, col = atom1, into = c("chain1", "resn1", "resnum1"), sep = ":", convert = TRUE)
df_1ITB_split <- separate(df_1ITB_split, col = atom2, into = c("chain2", "resn2", "resnum2"), sep = ":", convert = TRUE)

df_3O4O_split <- separate(df_3O4O, col = atom1, into = c("chain1", "resn1", "resnum1"), sep = ":", convert = TRUE)
df_3O4O_split <- separate(df_3O4O_split, col = atom2, into = c("chain2", "resn2", "resnum2"), sep = ":", convert = TRUE)


