#' Generate subsamples of a data frame with a number of sites between a minimum
#' and maximum value.
#' 
#' @param data A data frame of count data,
#'             with sites as rows and species as columns.
#' @param min_sites The minimum number of sites to include in a subsample.
#' @param max_sites The maximum number of sites to include in a subsample.
#'                  Defaults to the number of sites in the original data set.
#' @param step The number of sites to increase by at each iteration.
#' @param reps The number of subsamples with a given number of sites to create.
#' @param summary A logical indicating whether to calculate summary indices
#'               using \code{\link{calc_diversity_indices}}. Defaults to TRUE.
#' @param seed A random seed to use for reproducibility.
#' 
#' @return A list of lists of data frames, if \code{summary = FALSE}, each data
#'        frame is a subsample of the original data set. If \code{summary =
#'       TRUE}, each data frame is a subsample of the original data set with
#'      diversity indices calculated using
#'     \code{\link{calc_diversity_indices}}.
#' 
#' @export
#' 
#' @examples
#' ss <- generate_subsamples(BCI,
#'                           min_sites = 1,
#'                           max_sites = 5,
#'                           step = 1,
#'                           reps = 2)
generate_subsamples <- function(data,
                                min_sites = 1,
                                max_sites = nrow(data),
                                step = 1,
                                reps = 100,
                                summary = TRUE,
                                seed = sample(0:9999, 1)) {
    set.seed(seed)

    site_range <- seq(min_sites, max_sites, step)
    subsamples <- list()
    for (i in 1:reps){
        tmp <- list()
        for (j in site_range){
            n <- nrow(data)
            rand_inds <- sample(1:n, j, replace = TRUE)
            resample <- data[rand_inds, ]
            rownames(resample) <- NULL

            if (summary == TRUE) {
                resample <- biosampleR::calc_diversity_indices(resample)
            }

            resample$rep <- i
            resample$num_sites <- j

            tmp[[j]] <- resample
        }
        subsamples[[i]] <- tmp
    }
    return(subsamples)
}
