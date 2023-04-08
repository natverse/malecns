test_that("multiplication works", {

  df=read.table(header = T, sep="\t", text = "
  bodyid\ttype\tinstance
  1\tLAL041\tLAL041(DNa13_EM_1,LAL041)
  2\t\t(DNp58,hb1791391565)
  3\tVES055\t(DNp56,VES055)
  4\tVES056\tVES056_L
  5\tDescending\t12345_L")
  expect_equal(mcns_predict_type(df),
               c("LAL041", "DNp58,hb1791391565", "VES055", "VES056", "12345"))
})
