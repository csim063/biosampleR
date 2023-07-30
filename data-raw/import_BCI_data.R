# ----------------------------------------------------------------------------#
# Script to create example dataset for biosampleR, using the open-source
# Barro Colorado Island Tree Counts dataset from the vegan package
# ----------------------------------------------------------------------------#

# Note I use library calls here as this script is not built as part of the
# package being in "data-raw". It is for internal use only.
library(vegan)
library(devtools)

data(BCI)

# Save the dataset in the data directory of the package
# This allows users to access it
usethis::use_data(BCI, overwrite = TRUE)
