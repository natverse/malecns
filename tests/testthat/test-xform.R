test_that("xform works", {
  expect_equal(
  nat.templatebrains::xform_brain(cbind(443344, 225172, 44920),
                                  sample = 'FAFB14', reference = 'malecns'),
  matrix(c(302807.74, 215023.54, 117948.07), ncol = 3), tolerance = 1e-6)
})
