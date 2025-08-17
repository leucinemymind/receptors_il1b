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

c1ITB_sel <- contacts_1ITB %>% select(interaction_type, atom1, atom2)
c3O4O_sel <- contacts_3O4O %>% select(interaction_type, atom1, atom2)

# full join by interaction type to comp
compare_contacts <- full_join(c1ITB_sel, c3O4O_sel, by = "interaction_type")

# unique contacts
unique_contacts <- compare_contacts %>%
  filter(contacts_1ITB$atom1 != contacts_3O4O$atom1 | contacts_1ITB$atom2 != contacts_3O4O$atom2 | interaction_type != "vdw")

write.csv(unique_contacts, 
          "~/Dropbox/getcontacts/receptors_il1b/unique_contacts.csv", 
          row.names = FALSE)