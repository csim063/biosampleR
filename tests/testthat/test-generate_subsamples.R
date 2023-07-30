ss <- generate_subsamples(BCI,
                          min_sites = 1,
                          max_sites = 5,
                          step = 1,
                          reps = 2)

test_that("generate_subsamples returns a list with length equal to reps", {
    expect_equal(length(ss), 2)
})

test_that("Each element in the list has a length of max_sites / step", {
    expect_equal(length(ss[[1]]), 5)
    expect_equal(length(ss[[2]]), 5)
})

test_that("Each lst contains data frames with rows with a minimum of 
            min_sites and a maximum of max_sites", {
    for (i in seq_len(length(ss))) {
        for (j in seq_len(length(ss[[i]]))) {
            expect_true(nrow(ss[[i]][[j]]) >= 1)
            expect_true(nrow(ss[[i]][[j]]) <= 5)
        }
    }
})