#' Check if a bodyid still exists in the specified malecns DVID node
#'
#' @details For details (and there are some) please see
#'   \code{\link{manc_islatest}}
#'
#' @inheritParams malevnc::manc_islatest
#' @return A logical vector ordered by input ids
#' @export
#'
#' @examples
#' \donttest{
#' # giant fibre neuron
#' mcns_islatest(10001)
#'
#' # an expired body
#' mcns_islatest(49891)
#' }
mcns_islatest <- function(ids,node="neutu",
                          method=c("auto", "size", 'sparsevol')) {
  ids=mcns_ids(ids)
  with_mcns(malevnc::manc_islatest(ids, node=node, method=method))
}
