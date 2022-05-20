mcns_ids <- function(ids, ..., dataset=getOption("malecns.dataset")) {
  with_mcns(malevnc::manc_ids(ids, ...))
}

#' Map XYZ locations to bodyids based on the current mcns dataset
#'
#' @param xyz	location in raw dataset pixels
#' @inheritParams malevnc::manc_xyz2bodyid
#' @return A character vector of body ids (0 is missing somas / missing
#'   locations)
#' @export
#'
#' @examples
#' # the APL
#' \dontrun{
#' mcns_xyz2bodyid(cbind(24508, 15674, 26116)+4096)
#' }
mcns_xyz2bodyid <- function(xyz, node = 'neutu', cache=FALSE) {
  with_mcns(malevnc::manc_xyz2bodyid(xyz, node=node, cache = cache))
}
