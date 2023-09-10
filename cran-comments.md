## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release. The package returns one note when running  R CMD check "no visible binding for global variable 'num_sites' and 'sd'", these are non-standard evaluation constructs used in the ggplot2 package to refer to column names in a data frame. The code works as expected and this note does not indicate a problem. Package was tested on Windows, Mac and Linux.


## Resubmission
This is a resubmission. In this version I have:

* Removed text in the DESCRIPTION referring to chao1 which was being flagged as a spelling error. This change has simplified the package description and made it more concise.
* Removed broken links from the README.md file.