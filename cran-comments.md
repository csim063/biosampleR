## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release. The package returns one note when running  R CMD check "no visible binding for global variable 'num_sites' and 'sd'", these are non-standard evaluation constructs used in the ggplot2 package to refer to column names in a data frame. The code works as expected and this note does not indicate a problem.
