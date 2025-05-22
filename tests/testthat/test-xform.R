test_that("xform works", {
  expect_equal(
  nat.templatebrains::xform_brain(cbind(443344, 225172, 44920),
                                  sample = 'FAFB14', reference = 'malecns'),
  matrix(c(304165, 212161.9, 117656.2), ncol = 3), tolerance = 1e-4)
})
