#' Calculate the change in variance with increasing number of sites
#'
#' @param data A data frame containing the biodiversity indices to analyze,
#'             for a different number of sites over multiple repetitions.
#' @param col_name The name of the column containing the biodiversity index to
#'                analyze.
#' @param site_name The name of the column containing the number of sites.
#' @param rep_name The name of the column containing the repetition number.
#' @param visualize A logical indicating whether to visualize the results.
#'
#' @return A data frame with the number of sites and the variance and standard
#'       deviation of the mean of the biodiversity index for each number of
#'     sites.
#'
#' @export
#'
#' @examples
#' ss <- generate_subsamples(BCI,
#'                          min_sites = 1,
#'                         max_sites = 10,
#'                        step = 1,
#'                      reps = 10)
#' data <- ss
#' data  <- unlist(data, recursive = FALSE)
#' data <- do.call(rbind, data)
#'
#' calc_delta_var(data,
#'              col_name = "richness",
#'            site_name = "num_sites",
#'         rep_name = "rep",
#'      visualize = TRUE)
calc_delta_var <- function(data,
                           col_name,
                           site_name = "num_sites",
                           rep_name = "rep",
                           visualize = FALSE) {
    #* Create an empty data frame to store the results
    result <- data.frame(num_sites = numeric(),
                         variance = numeric(),
                         sd = numeric(),
                         stringsAsFactors = FALSE)

    #* For each unique number of sites
    for (i in unique(data[[site_name]])) {
        #* Subset the data for that number of sites
        tmp <- data[data[[site_name]] == i, ]

        #* Remove NA rows
        tmp <- tmp[!is.na(tmp[[col_name]]), ]

        #* Calculate the mean for each repetition
        mean_per_rep <- aggregate(tmp[[col_name]],
                                  by = list(tmp[[rep_name]]),
                                  FUN = mean)

        #* Add a row to the result data frame with the
        #* variance and sd of the means
        result <- rbind(result,
                        data.frame(num_sites = i,
                                   variance = var(mean_per_rep$x),
                                   sd = sd(mean_per_rep$x),
                                   stringsAsFactors = FALSE))
    }

    if (visualize == TRUE) {
        p <- ggplot2::ggplot(result,
                            ggplot2::aes(x = num_sites,
                                        y = sd)) +
                ggplot2::geom_point() +
                ggplot2::geom_line() +
                ggplot2::labs(x = "Number of sites",
                            y = "Standard deviation") +
                ggplot2::theme_minimal()

        print(p)
    }

    return(result)
}
