has_clio <- function() {
  tryCatch({
    malevnc::clio_token()
    TRUE
  }, error = function(e) FALSE)
}

test_that("choose_mcns v0.9 returns expected hardcoded options", {
  ops <- choose_mcns("male-cns:v0.9", set = FALSE)
  expect_equal(ops$malevnc.dataset, "male-cns:v0.9")
  expect_equal(ops$malevnc.neuprint, "https://neuprint.janelia.org")
  expect_equal(ops$malevnc.rootnode, "f3969dc575d74e4f922a8966709958c8")
  expect_equal(ops$malevnc.server, "https://emdata-mcns.janelia.org")
})

test_that("choose_mcns v0.13 returns expected options", {
  skip_if_not(has_clio(), "Clio credentials not available")
  ops <- choose_mcns("male-cns:v0.13", set = FALSE)
  expect_equal(ops$malevnc.dataset, "male-cns:v0.13")
  expect_equal(ops$malevnc.neuprint_dataset, "male-cns:v0.13")
  expect_equal(ops$malevnc.neuprint, "https://neuprint-cns.janelia.org")
  # server and rootnode should be non-empty strings derived from the CNS Clio entry
  expect_match(ops$malevnc.server, "^https://")
  expect_match(ops$malevnc.rootnode, "^[0-9a-f]{32}$")
})

test_that("can pull body annotations from v0.13 dataset", {
  skip_if_not(has_clio(), "Clio credentials not available")
  skip('v0.13 dataset not available on Clio')
  res <- with_mcns(
    mcns_body_annotations(query = list(superclass = "descending_neuron")),
    dataset = "male-cns:v0.13"
  )
  expect_s3_class(res, "data.frame")
  expect_gt(nrow(res), 0)
  expect_true("bodyid" %in% names(res))
  expect_true("superclass" %in% names(res))
})

test_that("can pull neuprint metadata from v0.13 dataset", {
  skip_if_not(has_clio(), "Clio credentials not available")
  res <- with_mcns(
    mcns_neuprint_meta("/LAL04[12]"),
    dataset = "male-cns:v0.13"
  )
  expect_s3_class(res, "data.frame")
  expect_gt(nrow(res), 0)
  expect_true("bodyid" %in% names(res))
})
