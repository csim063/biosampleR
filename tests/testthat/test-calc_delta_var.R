ss <- generate_subsamples(BCI,
                          min_sites = 1,
                          max_sites = 10,
                          step = 1,
                          reps = 10)
data <- ss
data  <- unlist(data, recursive = FALSE)
data <- do.call(rbind, data)
dv <- calc_delta_var(data,
                     col_name = "richness",
                     site_name = "num_sites",
                     rep_name = "rep",
                     visualize = FALSE)

test_that("calc_delta_var creates a data frame with three columns and rows
           equal to the number of unique sites in data", {
    expect_equal(ncol(dv), 3)
    expect_equal(nrow(dv), length(unique(data$sites)))
})
