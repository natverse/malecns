test_that("mcns_islatest works", {
  expect_equal(mcns_islatest(c(10001, 49891)), c(T, F))
})
