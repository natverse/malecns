test_that("choose_mcns v0.9 returns expected hardcoded options", {
  ops <- choose_mcns("male-cns:v0.9", set = FALSE)
  expect_equal(ops$malevnc.dataset, "male-cns:v0.9")
  expect_equal(ops$malevnc.neuprint, "https://neuprint.janelia.org")
  expect_equal(ops$malevnc.rootnode, "f3969dc575d74e4f922a8966709958c8")
  expect_equal(ops$malevnc.server, "https://emdata-mcns.janelia.org")
})

test_that("choose_mcns v1.0 returns expected hardcoded options", {
  ops <- choose_mcns("male-cns:v1.0", set = FALSE)
  expect_equal(ops$malevnc.dataset, "male-cns:v1.0")
  expect_equal(ops$malevnc.neuprint_dataset, "male-cns:v1.0")
  expect_equal(ops$malevnc.neuprint, "https://neuprint.janelia.org")
  expect_equal(ops$malevnc.rootnode, "f3969dc575d74e4f922a8966709958c8")
  expect_equal(ops$malevnc.server, "https://emdata-mcns.janelia.org")
})

test_that("can pull body annotations from v1.0 dataset", {
  skip_if_not(has_clio(), "Clio auth is not available")
  res <- with_mcns(
    mcns_body_annotations(query = list(superclass = "descending_neuron")),
    dataset = "male-cns:v1.0"
  )
  expect_s3_class(res, "data.frame")
  expect_gt(nrow(res), 0)
  expect_true("bodyid" %in% names(res))
  expect_true("superclass" %in% names(res))
})

test_that("can pull neuprint metadata from v1.0 dataset", {
  res <- with_mcns(
    mcns_neuprint_meta("/LAL04[12]"),
    dataset = "male-cns:v1.0"
  )
  expect_s3_class(res, "data.frame")
  expect_gt(nrow(res), 0)
  expect_true("bodyid" %in% names(res))
})
