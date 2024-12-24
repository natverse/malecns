test_that("multiplication works", {
  mm=mcns_neuprint_meta("/LAL04[12]")
  # these should be the same (unless there is a bodyid accident)
  expect_equal(mcns_xyz2bodyid(mcns_somapos(mm, units='raw'), units='raw'),
               mm$bodyid)
  expect_equal(mcns_xyz(NA_character_), mcns_xyz(""))

  expect_type(mcns_somapos(mm, as_character = TRUE), 'character')
})
