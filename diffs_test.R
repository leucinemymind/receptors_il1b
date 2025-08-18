# packages
library(tidyverse)

contacts_1ITB <- read_tsv("~/Dropbox/getcontacts/receptors_il1b/1itb_contacts.tsv", skip = 2)
contacts_3O4O <- read_tsv("~/Dropbox/getcontacts/receptors_il1b/3o4o_contacts.tsv", skip = 2)

colnames(contacts_1ITB) <- c("frames", "interaction_type", "atom1", "atom2")
colnames(contacts_3O4O) <- c("frames", "interaction_type", "atom1", "atom2")

c1ITB_sel <- contacts_1ITB %>% select(-frames)
c3O4O_sel <- contacts_3O4O %>% select(-frames)

# unique contacts
unique_contacts <- c1ITB_sel %>%
  anti_join(c3O4O_sel, by = c("atom1", "atom2")) %>%
  rename(atom1_c1ITB = atom1, atom2_c1ITB = atom2) %>%
  mutate(interaction = paste(atom1_c1ITB, atom2_c1ITB, sep = "-")) %>%
  select(interaction, atom1_c1ITB, atom2_c1ITB)

unique_contacts <- unique_contacts %>%
  left_join(c3O4O_sel %>% rename(atom1_c3O4O = atom1, atom2_c3O4O = atom2),
            by = c("atom1_c1ITB" = "atom1_c3O4O", "atom2_c1ITB" = "atom2_c3O4O")) 