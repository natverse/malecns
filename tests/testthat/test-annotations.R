test_that("schema_compare works", {
  df = data.frame(bodyid=10005, group="10005")
  expect_error(
    schema_compare(df), "Wrong types of columns: group"
  )

  df = data.frame(bodyid=10005, group=10005)
  expect_no_error(
    schema_compare(df)
  )

  df = data.frame(bodyid=10005, group=10005, abc="a")
  expect_no_error(
    schema_compare(df)
  )

})


test_that("mcns_body_annotations works", {
  expect_silent(dns.u <- mcns_body_annotations(query = list(superclass='descending_neuron'), show.extra = 'user'))
  expect_true(all(c("superclass_user", "group_user", "type_user") %in% names(dns.u)))
})
