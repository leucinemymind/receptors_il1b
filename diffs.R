## Finding differences between contacts ##
## 2025-08-16 21:02 ##

# packages

library(tidyverse)

# load data

contacts_1ITB <- read_tsv("~/Dropbox/getcontacts/receptors_il1b/1itb_contacts.tsv", skip = 2)
contacts_3O4O <- read_tsv("~/Dropbox/getcontacts/receptors_il1b/3o4o_contacts.tsv", skip = 2)

# clean up column names

colnames(contacts_1ITB) <- c("frames", "interaction_type", "atom1", "atom2")
colnames(contacts_3O4O) <- c("frames", "interaction_type", "atom1", "atom2")

c1ITB_sel <- contacts_1ITB %>% select(-frames)
c3O4O_sel <- contacts_3O4O %>% select(-frames)

# find unique contacts

unique_contacts_c1ITB <- c1ITB_sel %>%
  anti_join(c3O4O_sel, by = c("atom1", "atom2")) %>%
  rename(atom1_c1ITB = atom1, atom2_c1ITB = atom2) %>%
  mutate(interaction = paste(atom1_c1ITB, atom2_c1ITB, sep = "-")) %>%
  select(interaction, interaction_type)

unique_contacts_c3O4O <- c3O4O_sel %>%
  anti_join(c1ITB_sel, by = c("atom1", "atom2")) %>%
  rename(atom1_c3O4O = atom1, atom2_c3O4O = atom2) %>%
  mutate(interaction = paste(atom1_c3O4O, atom2_c3O4O, sep = "-")) %>%
  select(interaction, interaction_type)

write.csv(unique_contacts_c1ITB, 
          "~/Dropbox/getcontacts/receptors_il1b/unique_contacts_1ITB.csv"
)

write.csv(unique_contacts_c3O4O, 
          "~/Dropbox/getcontacts/receptors_il1b/unique_contacts_3O4O.csv"
)