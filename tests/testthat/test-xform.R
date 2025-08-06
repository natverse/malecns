test_that("xform works", {
  expect_equal(
  nat.templatebrains::xform_brain(cbind(443344, 225172, 44920),
                                  sample = 'FAFB14', reference = 'malecns'),
  matrix(c(304165, 212161.9, 117656.2), ncol = 3), tolerance = 1e-4)

  expect_equal(
    nat.templatebrains::xform_brain(
      xyzmatrix(c("386118.7, 227965.6, 210815.8", "406876.5 443980.0 745986.5")),
                                    sample = 'malecns', reference = 'malecnsplot'),
    matrix(c(385826.3, 227887.5, 210821.2,
             395724.7, 729367.1, 264989.2),
           byrow = T, ncol = 3),
    tolerance = 1e-5)

})
