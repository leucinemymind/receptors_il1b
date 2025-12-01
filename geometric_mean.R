# load in pdbs
# load in user-specified number
# residue number = user-specified number
# residue name = STP
# for each line that matches previous 2 conditions
# extract 3 cols, c to floats
# calc means

### did not need to convert anything because of bio3d!!!

# for better pdb access
library(bio3d)

# only taking HETATM lines
lines_1ITB <- readLines("~/Dropbox/getcontacts/receptors_il1b/1ITB_out/1ITB_out.pdb")
lines_trimmed_1ITB <- lines_1ITB[4564:length(lines_1ITB)]
pdb_1ITB <- writeLines(lines_trimmed_1ITB, "~/Dropbox/getcontacts/receptors_il1b/1ITB_out/1ITB_out_trimmed.pdb")

lines_3O4O <- readLines("~/Dropbox/getcontacts/receptors_il1b/3O4O_out/3O4O_out.pdb")
lines_trimmed_3O4O <- lines_3O4O[6395:length(lines_3O4O)]
pdb_3O4O <- writeLines(lines_trimmed_3O4O, "~/Dropbox/getcontacts/receptors_il1b/3O4O_out/3O4O_out_trimmed.pdb")

# pdb
pdb_1ITB <- read.pdb("~/Dropbox/getcontacts/receptors_il1b/1ITB_out/1ITB_out_trimmed.pdb")
pdb_3O4O <- read.pdb("~/Dropbox/getcontacts/receptors_il1b/3O4O_out/3O4O_out_trimmed.pdb")

user_resnum <- 1
code <- "1ITB"

sub_df_1ITB <- subset(pdb_1ITB$atom, resno == user_resnum)
sub_df_3O4O <- subset(pdb_3O4O$atom, resno == user_resnum)

# take cortroidntes and calculute mean

if (code == "1ITB") {
  coordinates <- sub_df_1ITB[c("x", "y", "z")]
  geom_centre <- colMeans(coordinates)
  } else if (code == "3O4O") {
  coordinates <- sub_df_3O4O[c("x", "y", "z")]
  geom_centre<- colMeans(coordinates)
  }

print(geom_centre)