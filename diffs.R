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

colnames(contacts_1ITB) <- c("frame", "interaction_type", "atom1", "atom2")
colnames(contacts_3O4O) <- c("frame", "interaction_type", "atom1", "atom2")

# unique contacts

unique_1ITB_contacts <- anti_join(contacts_1ITB, contacts_3O4O, 
                                  by = c("interaction_type", "atom1", "atom2"))

unique_1ITB_contacts
