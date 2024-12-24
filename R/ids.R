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
#' # exact matches for cell types
#' mcns_ids("DA2_lPN")
#' mcns_ids("DA2_lPN", integer64=TRUE)
#' # You can also do more complex queries using regular expressions
# introduced by a slash and specifying the field to be searched
#' mcns_ids("/VL2a.+")
#' dns=mcns_ids("/type:DN.+")
#'
#' # you can also use Neo4J cypher queries by using the where: prefix
#' # note that each field of the neuron must prefixed with "n."
#' bigneurons_nosuperclass <-
#' mcns_ids("where:NOT exists(n.superclass) AND n.synweight>5000")
#'
#' bignogroupids <-
#' mcns_ids("where:NOT exists(n.group) AND n.synweight>5000 AND n.superclass CONTAINS 'neuron'")
#'
#' \dontrun{
#' # you can paste ids onto the clipboard for inspection
#' clipr::write_clip(bignogroupids)
#'
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

#' Map XYZ locations to bodyids for the male cns dataset
#'
#' @param xyz xyz	location (by default in raw malecns pixels)
#' @param units The Optional units of the incoming 3D positions. Defaults to
#'   \emph{raw}.
#' @inheritParams malevnc::manc_xyz2bodyid
#'
#' @return A character vector of body ids (0 is missing somas / missing
#'   locations)
#' @export
#'
#' @examples
#' \donttest{
#' # find the bodyids corresponding to set of soma positions
#' mcns_xyz2bodyid(mcns_somapos("/LAL04[12]", units='raw'), units='raw')
#' }
#' # the APL
#' \dontrun{
#' mcns_xyz2bodyid(cbind(24508, 15674, 26116)+4096)
#' }
mcns_xyz2bodyid <- function(xyz, units=c("raw", "nm", "microns", "um"),
                            node = "neutu", cache = FALSE) {
  xyzraw=mcns_xyz(xyz, inunits=units, outunits='raw')
  with_mcns(malevnc::manc_xyz2bodyid(xyzraw, node = "neutu", cache = FALSE))
}
