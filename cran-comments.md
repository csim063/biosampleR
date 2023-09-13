## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release. The package returns one note when running  R CMD check "no visible binding for global variable 'num_sites' and 'sd'", these are non-standard evaluation constructs used in the ggplot2 package to refer to column names in a data frame. The code works as expected and this note does not indicate a problem. Package was tested on Windows, Mac and Linux.


## Resubmission v1.0.1
This is a resubmission. In this version I have:

* Removed text in the DESCRIPTION referring to chao1 which was being flagged as a spelling error. This change has simplified the package description and made it more concise.
* Removed broken links from the README.md file.

## Resubmission v1.0.2
This is a resubmission. In this version I have:

* I altered the code in "calc_delta_var.R" to remove the "No visible binding for global variable" note. This was done by replacing the "num_sites" and "sd" variables with ".data$num_sites" and ".data$sd" respectively. This change has not altered the functionality of the code.

## Resubmission v1.0.3
This is a resubmission. In this version I have:

* Added references to literature which informed the design of my biodiversity functions, in the DESCRIPTION file.

## Resubmission v1.0.4
This is a resubmission. In this version I have:

* Corrected DOI formatting in the DESCRIPTION file.