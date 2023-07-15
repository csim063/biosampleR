# Combine all the resampled data frames into one
resamples <- Reduce("rbind", resamples)

# Calculate mean and standard deviation of the biodiversity index for each site
summary_stats <- resamples %>%
  dplyr::group_by(sites) %>%
  dplyr::summarize(mean_index = mean(richness),
                   sd_index = sd(richness),
                   .groups = "drop")

# Compare the observed biodiversity index to the distribution
BCI_named <- calc_diversity_indices(BCI)

original_data <- BCI_named %>%
  dplyr::left_join(summary_stats, by = "sites") %>%
  dplyr::mutate(percentile = pnorm(richness, mean_index, sd_index))

# The pnorm function gives the cumulative distribution function for the
# normal distribution, which will be the percentile if the data is normally distributed.
mean(original_data$percentile)
