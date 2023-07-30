# First, load necessary libraries
library(dplyr)
library(purrr)

# Load the dataset
data("BCI", package = "vegan")

# Define the basic structure of your documentation
doc_head <- "#' Barro-Colorado Island Tree Counts
#'
#' This dataset contains tree counts from Barro-Colorado Island. It has 50
#' rows each representing the counts taken from a separate one hectare plot
#' for each of the 225 species (columns)
#'
#'
#' @format A data frame with 50 rows and 225 columns:
#' \\describe{\n"

doc_tail <- "}\n#' @source \\url{https://www.science.org/doi/10.1126/science.1066854}\n\"BCI\""

# Generate a character vector of column descriptions
col_desc <- map_chr(names(BCI), function(name) {
  paste0("#'  \\item{", name, "}{Count for ", name, "}")
})

# Combine all parts together
doc_all <- paste0(doc_head, paste(col_desc, collapse = "\n"), doc_tail)

# Write the documentation to an R script
writeLines(doc_all, con = "R/BCI.R")

# Run devtools::document() to generate the .Rd file
#devtools::document()
