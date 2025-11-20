### filtering out contacts that are not unique (SAVE lookup table) and original spreadsheets ###
### 2025-10-09 ###

library(tidyverse)

# aa conversion
aa3_to_1 <- function(aa3){
  aa_dict <- c(
    ALA="A", ARG="R", ASN="N", ASP="D", CYS="C", 
    GLN="Q", GLU="E", GLY="G", HIS="H", ILE="I",
    LEU="L", LYS="K", MET="M", PHE="F", PRO="P",
    SER="S", THR="T", TRP="W", TYR="Y", VAL="V"
  )
  aa_dict[aa3]
}

df_1ITB <- read.csv("~/Dropbox/getcontacts/receptors_il1b/unique_1ITB.csv")
df_3O4O <- read.csv("~/Dropbox/getcontacts/receptors_il1b/unique_3O4O.csv")
mapping <- read.csv("~/Dropbox/getcontacts/receptors_il1b/contact_alignment.csv")

# split into 3 separate colns
df_1ITB_split <- separate(df_1ITB, col = atom1, into = c("chain1", "resn1", "resnum1"), sep = ":", convert = TRUE)
df_1ITB_split <- separate(df_1ITB_split, col = atom2, into = c("chain2", "resn2", "resnum2"), sep = ":", convert = TRUE)

df_3O4O_split <- separate(df_3O4O, col = atom1, into = c("chain1", "resn1", "resnum1"), sep = ":", convert = TRUE)
df_3O4O_split <- separate(df_3O4O_split, col = atom2, into = c("chain2", "resn2", "resnum2"), sep = ":", convert = TRUE)

df_3O4O_split$resn1 <- aa3_to_1(df_3O4O_split$resn1)
df_3O4O_split$resn2 <- aa3_to_1(df_3O4O_split$resn2)
df_1ITB_split$resn1 <- aa3_to_1(df_1ITB_split$resn1)
df_1ITB_split$resn2 <- aa3_to_1(df_1ITB_split$resn2)

# ID
df_1ITB_split$contact_id <- paste0(df_1ITB_split$resn1,
                                   df_1ITB_split$resnum1,
                                   "-",
                                   df_1ITB_split$resn2,
                                   df_1ITB_split$resnum2)

df_3O4O_split$contact_id <- paste0(df_3O4O_split$resn1,
                                   df_3O4O_split$resnum1,
                                   "-",
                                   df_3O4O_split$resn2,
                                   df_3O4O_split$resnum2)

# mapping 1itb -> 3o4o
b_to_c <- setNames(mapping$receptor2_index, mapping$receptor1_index)

# map residues safely using sapply  %  this is where the errors started
map_resn1 <- sapply(df_1ITB_split$resnum1, function(x){
  mapped_num <- b_to_c[as.character(x)]
  print(mapped_num)
  if(!is.na(mapped_num) && mapped_num != -1){
    vals_1ITB <- df_3O4O_split$resn1[df_3O4O_split$resnum1 == mapped_num]
    vals_1ITB[1]
  } else {
    NA
  }
})

map_resn2 <- sapply(df_1ITB_split$resnum2, function(x){
  mapped_num <- b_to_c[as.character(x)]
  if(!is.na(mapped_num) && mapped_num != -1){
    vals_3O4O <- df_3O4O_split$resn2[df_3O4O_split$resnum2 == mapped_num]
    vals_3O4O[1]
  } else {
    NA
  }
})

df_1ITB_split$mapped_contact <- paste(
  map_resn1, b_to_c[as.character(df_1ITB_split$resnum1)],
  "-",
  map_resn2, b_to_c[as.character(df_1ITB_split$resnum2)]
)

# 3o4o lookup
ids_3O4O <- df_3O4O_split$contact_id

# start mapping
output_list <- vector("list", nrow(df_1ITB_split) + length(ids_3O4O))
index <- 1

for(i in 1:nrow(df_1ITB_split)){
  original <- df_1ITB_split$contact_id[i]       # original 1ITB contact
  mapped   <- df_1ITB_split$mapped_contact[i]  # mapped to 3O4O numbering
  
  if(!is.na(mapped) && mapped %in% ids_3O4O){
    output_list[[index]] <- c(original, mapped, "shared")
    ids_3O4O <- setdiff(ids_3O4O, mapped)
  } else {
    # only in 1ITB
    output_list[[index]] <- c(original, mapped, "1ITB_unique")
  }
  index <- index + 1
}

# add remaining contacts
for(j in 1:length(ids_3O4O)){
  output_list[[index]] <- c( NA, ids_3O4O[j], "3O4O_unique"
  )
  index <- index + 1
}

# combine into a data frame
output_df <- do.call(rbind, output_list)
output_df <- as.data.frame(output_df, stringsAsFactors = FALSE)
colnames(output_df) <- c("1ITB_contact", "3O4O_contact", "status")

# sort by status
output_df <- output_df[order(output_df$status), ]

# save result
write.csv(output_df, "~/Dropbox/getcontacts/receptors_il1b/contact_statuses.csv")