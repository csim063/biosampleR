test_that("Abundundance matches sum of counts", {
  ind <- calc_diversity_indices(BCI)
  expect_equal(sum(ind$abundance), sum(BCI))
})

test_that("Seven columns are returned", {
  ind <- calc_diversity_indices(BCI)
  expect_equal(ncol(ind), 7)
})

test_that("Equal number of rows (sites) are returned", {
  ind <- calc_diversity_indices(BCI)
  expect_equal(nrow(ind), nrow(BCI))
})