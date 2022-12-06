#' Get Male CNS ids in standard formats
#'
#' @param ids Either numeric ids (in \code{character}, \code{numeric},
#'   \code{integer} or \code{integer64}format) or a query expression
#' @inheritParams malevnc::manc_ids
#' @inheritParams with_mcns
#'
#' @return A vector of numeric ids with mode determined by \code{as_character}
#'   and \code{integer64}
#' @export
#'
#' @examples
#' mcns_ids("DA2_lPN")
#' mcns_ids("DA2_lPN", integer64=TRUE)
#' mcns_ids("/VL2a.+")
#'
#' \dontrun{
#' # throws an error
#' mcns_ids("rhubarb")
#' }
#' # returns a length 0 vector
#' mcns_ids("rhubarb", mustWork = FALSE)
mcns_ids <- function(ids,
                     mustWork = TRUE,
                     as_character = TRUE,
                     integer64 = FALSE,
                     unique = FALSE,
                     ...,
                     dataset = getOption("malecns.dataset")) {
  with_mcns(
    malevnc::manc_ids(
      ids,
      mustWork = mustWork,
      as_character = as_character,
      integer64 = integer64,
      unique = unique,
      ...
    ),
    dataset = dataset
  )
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
