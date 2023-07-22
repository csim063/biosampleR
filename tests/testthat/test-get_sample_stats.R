stats <- get_sample_stats(BCI)
test_that("get_sample_stats returns a list of two", {
  expect_equal(length(stats), 2)
  expect_type(stats, "list")
})

test_that("site level results has all sites and indices", {
  expect_equal(nrow(stats[[1]]), nrow(BCI))
  expect_equal(ncol(stats[[1]]), 31)
})

test_that("overall level results has no sites and all indices", {
  expect_equal(nrow(stats[[2]]), 1)
  expect_equal(ncol(stats[[2]]), 30)
})