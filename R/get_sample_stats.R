#' Calculate biodiversity measures and summary statistics for a data set
#' using repeated sampling
#' 
#' @param data A data frame of count data,
#'            with sites as rows and species as columns.
#' @param sites_col The column number of column containing site IDs.
#' @param reps The number of resamples to create.
#' @param indices A vector of indices to calculate. Use "all" to calculate
#'               all indices. Available indices are: abundance,
#'              richness, shannon, simpson, chao1, and chao_diff.
#' 
#' @return A list of two data frames. The first data frame contains site
#'         specific data with sites as rows and summary statistics as columns.
#'         The second contains an overall summary of the data.
#' 
#' @export
#' 
#' @examples
#' stats <- get_sample_stats(BCI)
get_sample_stats <- function(data,
                             sites_col = 1,
                             reps = 100,
                             indices = "all") {
    #* Define list of indices to calculate
    if (indices == "all") {
        indices <- c("abundance",
                     "richness",
                     "shannon",
                     "simpson",
                     "chao1",
                     "chao_diff")
    }

    #* Calculate indices for original data set
    orig <- calc_diversity_indices(data)

    #* Create a resample of the data set
    resamples <- create_resample(data,
                                 reps = reps,
                                 summary = TRUE)

    #* Join resamples into single data frame by row
    resamples <- Reduce("rbind", resamples)

    #* Calculate summary statistics for each index and site
    #* First split the data frame by site
    split_resamples <- split(resamples, resamples[, sites_col])

    #* Function to compute statistics
    calc_stats <- function(df) {
        # Remove the 'sites' column
        df <- df[ , -1]

        # Calculate mean, median, and 95th percentiles
        mean_vec <- apply(df, 2, mean)
        median_vec <- apply(df, 2, stats::median)
        lower_vec <- apply(df, 2,
                           function(x) stats::quantile(x, probs = 0.025))
        upper_vec <- apply(df, 2,
                           function(x) stats::quantile(x, probs = 0.975))

        # Return as a data frame
        data.frame(rbind(mean_vec, median_vec, lower_vec, upper_vec))
    }

    #* Calculate statistics for each site
    site_stats <- lapply(split_resamples, calc_stats)

    #* Combine stats
    stats_df <- do.call(rbind, site_stats)

    #* Generate a list of site values
    site_sequence <- rep(names(split_resamples), each = 4)

    #* Add site names and statistic names as new columns
    stats_df <- cbind(sites = site_sequence,
                      statistic = row.names(stats_df),
                      stats_df)

    #* Relabel statistic names
    stats_df$statistic <- gsub("mean_vec", "mean", stats_df$statistic)
    stats_df$statistic <- gsub("median_vec", "median", stats_df$statistic)
    stats_df$statistic <- gsub("lower_vec", "lower", stats_df$statistic)
    stats_df$statistic <- gsub("upper_vec", "upper", stats_df$statistic)
    stats_df$statistic <- gsub("^[0-9]*\\.", "", stats_df$statistic)

    #* Remove row names
    rownames(stats_df) <- NULL

    #* Reshape data frame to allow for joining with original data
    stats_df <- stats::reshape(stats_df,
                                idvar = "sites",
                                timevar = "statistic",
                                direction = "wide")

    #* Join with original data
    site_result_df <- merge(orig, stats_df, by = "sites")

    #* Get average values for each statistic
    #* First, remove the 'sites' column
    overall_df <- site_result_df[, -1]

    #* Calculate mean for each column
    overall_df <- apply(overall_df, 2, mean)

    #* Format as a data frame with one column per statistic
    overall_df <- data.frame(t(overall_df))

    #* Return both the site-level and overall data frames
    return(list("Per site" = site_result_df,
                "Overall" = overall_df))
}
