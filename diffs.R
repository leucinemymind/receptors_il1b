### Finding differences between contacts ###
### 2025-08-16 21:02 PT ###

# packages

library(dplyr)

# reading tsv files
contacts_1ITB <- read.table(
  "~/Dropbox/getcontacts/receptors_il1b/1itb_contacts.tsv", 
  skip = 2, 
  header = FALSE, 
  fill = TRUE, 
  stringsAsFactors = FALSE
)

contacts_3O4O <- read.table(
  "~/Dropbox/getcontacts/receptors_il1b/3o4o_contacts.tsv", 
  skip = 2, 
  header = FALSE, 
  fill = TRUE, 
  stringsAsFactors = FALSE
)

# column names and selections

colnames(contacts_1ITB) <- c("frames", "interaction_type", "atom1", "atom2")
colnames(contacts_3O4O) <- c("frames", "interaction_type", "atom1", "atom2")

c1ITB_sel <- contacts_1ITB %>% select(interaction_type, atom1, atom2) %>% filter(interaction_type != "vdw")
c3O4O_sel <- contacts_3O4O %>% select(interaction_type, atom1, atom2) %>% filter(interaction_type != "vdw")

# unique to 1ITB (by atom pairs only)
unique_1ITB <- anti_join(
  c1ITB_sel, c3O4O_sel, by = c("atom1", "atom2")
)

# unique to 3O4O (by atom pairs only)
unique_3O4O <- anti_join(
  c3O4O_sel, c1ITB_sel, by = c("atom1", "atom2")
)

unique_contacts <- bind_rows(
  unique_1ITB %>% mutate(source = "1ITB") %>%
    filter(interaction_type != "vdw"),
  unique_3O4O %>% mutate(source = "3O4O") %>%
    filter(interaction_type != "vdw")
)

write.csv(unique_contacts, 
          "~/Dropbox/getcontacts/receptors_il1b/unique_contacts.csv", 
          row.names = FALSE)