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

# split into 3 separate columns
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
resn_lookup <- setNames(df_3O4O_split$resn1, df_3O4O_split$resnum1)
b_to_c <- setNames(mapping$receptor2_index, mapping$receptor1_index)
names(b_to_c) <- mapping$receptor1_index

# safe mapping function
safe_map <- function(resnums, df_split, b_to_c, res_col) {
  sapply(resnums, function(x) {
    mapped_num <- b_to_c[as.character(x)]
    if(!is.na(mapped_num)) {
      # pick first match if duplicates exist
      mapped_res <- df_split[[res_col]][df_split$resnum1 == mapped_num | df_split$resnum2 == mapped_num]
      if(length(mapped_res) >= 1) {
        mapped_res[1]
      } else {
        NA
      }
    } else {
      NA
    }
  })
}

# apply safe mapping
map_resn1 <- safe_map(df_1ITB_split$resnum1, df_3O4O_split, b_to_c, "resn1")
map_resn2 <- safe_map(df_1ITB_split$resnum2, df_3O4O_split, b_to_c, "resn2")

df_1ITB_split$mapped_contact <- paste0(
  map_resn1, b_to_c[as.character(df_1ITB_split$resnum1)],
  "-",
  map_resn2, b_to_c[as.character(df_1ITB_split$resnum2)]
)

# 3o4o lookup
ids_3O4O <- df_3O4O_split$contact_id

# start mapping
output_list <- list()

for(i in 1:nrow(df_1ITB_split)){
  original <- df_1ITB_split$contact_id[i]       # original 1ITB contact
  mapped   <- df_1ITB_split$mapped_contact[i]  # mapped to 3O4O numbering
  
  if(!is.na(mapped) && mapped %in% ids_3O4O){
    # contact exists in both → shared
    output_list[[i]] <- c(original, mapped, "shared")
    ids_3O4O <- setdiff(ids_3O4O, mapped)
  } else {
    # only in 1ITB
    output_list[[i]] <- c(original, mapped, "1ITB_unique")
  }
}

# add remaining contacts
start_index <- length(output_list) + 1
for(j in 1:length(ids_3O4O)){
  output_list[[start_index]] <- c(
    NA,            
    ids_3O4O[j],    
    "3O4O_unique"   
  )
  start_index <- start_index + 1
}

# combine into a data frame
output_df <- data.frame(do.call(rbind, output_list),
                        stringsAsFactors = FALSE)
colnames(output_df) <- c("1ITB_contact", "3O4O_contact", "status")

# convert status to character to avoid list errors
output_df$status <- as.character(output_df$status)

# sort by status
output_df <- output_df[order(output_df$status), ]

# save result
write.csv(output_df, "~/Dropbox/getcontacts/receptors_il1b/contact_statuses.csv", row.names = FALSE)
