test_that("mcns_predict_group works", {
  some_vnc_neurons=data.frame(
    bodyid = c(10291L, 12976L, 14121L, 14899L, 16173L, 20489L, 22597L, 22916L,
               23685L, 25076L),
    instance = NA,
    type = NA, group = NA,
    manc_bodyid = c(153991L, 10419L, 11702L, 10758L, 15717L, 17296L, 14515L,
                    19514L, 12830L, 12416L),
    manc_group = c(11388L, 10381L, 11563L, 10603L, 15717L, 17296L, 14515L,
                   19514L, 12830L, 12416L))
    expect_equal(mcns_predict_group(some_vnc_neurons),
                 c(10291, 12976, 14121, 14899, 16173, 20489, 22597, 22916, 23685,
                   25076))
})
