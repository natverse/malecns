test_that("xform works", {
  expect_equal(
  nat.templatebrains::xform_brain(cbind(443344, 225172, 44920),
                                  sample = 'FAFB14', reference = 'malecns'),
  matrix(c(302808, 215024, 117948), ncol = 3), tolerance = 1e-4)
})
