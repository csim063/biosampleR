#' Create multiple resamples of a data set.
#'
#' @param data A data frame of count data,
#'              with sites as rows and species as columns.
#' @param reps The number of resamples to create.
#' @param summary A logical indicating whether to calculate summary indices
#'                using \code{\link{calc_diversity_indices}}.
#' @param seed A random seed to use for reproducibility.
#'
#' @return A list of data frames, if \code{summary = FALSE}, each data frame
#'          is a resample of the original data set. If \code{summary = TRUE},
#'          each data frame is a resample of the original data set with
#'          diversity indices calculated using
#'          \code{\link{calc_diversity_indices}}.
#' @export
#'
#' @examples
#' rs <- create_resample(BCI)
create_resample <- function(data,
                            reps = 100,
                            summary = TRUE,
                            seed = sample(0:9999, 1)) {
    set.seed(seed)
    tmp <- list()

    for (i in 1:reps){
         n <- nrow(data)
        rand_inds <- sample(1:n, n, replace = TRUE)
        resample <- data[rand_inds, ]
        rownames(resample) <- NULL

        if (summary == TRUE) {
            resample <- calc_diversity_indices(resample)
        }

        tmp[[i]] <- resample
    }

    return(tmp)
}