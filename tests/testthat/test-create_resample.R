test_that("create_resample creates a list of outputs equal in 
            lenght to reps", {
  rs <- create_resample(BCI, reps = 10)
  expect_equal(length(rs), 10)
  expect_type(rs, "list")
})

test_that("Each data frame in the list has the same number of rows 
            as the original data set", {
  rs <- create_resample(BCI, reps = 10)
  for (i in seq_len(length(rs))) {
    expect_equal(nrow(rs[[i]]), nrow(BCI))
  }
})