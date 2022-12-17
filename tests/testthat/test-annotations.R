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
