test_that("multiplication works", {
  expect_warning(mcns_cosine_plot("/name:LAL.+", partners='out', group=T), 'Dropping')
})
