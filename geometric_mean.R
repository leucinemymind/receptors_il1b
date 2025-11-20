# load in pdb
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
lines <- readLines("~/Dropbox/getcontacts/receptors_il1b/1ITB_out/1ITB_out.pdb")
lines_trimmed <- lines[4564:length(lines)]
pdb <- writeLines(lines_trimmed, "~/Dropbox/getcontacts/receptors_il1b/1ITB_out/1ITB_out_trimmed.pdb")

# pdb
pdb <- read.pdb("~/Dropbox/getcontacts/receptors_il1b/1ITB_out/1ITB_out_trimmed.pdb")

user_resnum <- 29

sub_df <- subset(pdb$atom, resno == user_resnum)

# take cortroidntes and calculute mean

coordinates <- sub_df[, c("x", "y", "z")]
geom_centre <- colMeans(coordinates)