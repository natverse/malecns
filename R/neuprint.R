#' Login to male CNS neuprint server
#'
#' @param ... Additional arguments passed to \code{\link{neuprint_login}}
#'
#' @return a \code{\link{neuprint_connection}} object returned by \code{\link{neuprint_login}}
#' @export
#' @family manc-neuprint
#' @examples
#' \dontrun{
#' cnsc=mcns_neuprint()
#' anchorids <- neuprintr::neuprint_ids("status:Anchor", conn=cnsc)
#' # the last connection will be used by default
#' anchormeta <- neuprintr::neuprint_get_meta("status:Anchor")
#'
#' plot(cumsum(sort(anchormeta$pre, decreasing = TRUE)), ylab='Cumulative presynapses')
#' plot(cumsum(sort(anchormeta$post, decreasing = TRUE)), ylab='Cumulative postsynapses')
#' }
mcns_neuprint <- function(...) {
  neuprintr::neuprint_login(server='https://neuprint-cns.janelia.org', dataset = "cns", token=Sys.getenv("neuprint_token"), ...)
}


#' Connnectivity query for CNS neurons
#'
#' @param ids
#' @param partners
#' @param moredetails Not yet implemented
#' @param summary Whether to summarise results per partner when giving multiple
#'   query neurons
#' @inheritParams malevnc::manc_connection_table
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' \donttest{
#' joffrey.id=mcns_xyz2bodyid(cbind(24590, 13816, 26102), node = 'neuprint')
#' joffrey.ds=mcns_connection_table(joffrey.id, partners = 'in')
#' joffrey.dss=mcns_connection_table(joffrey.id, partners = 'in', summary=TRUE)
#' }
#' \dontrun{
#' # open top 10 partners in neuroglancer,
#' # NB segmentation / meshes to match neuprint
#' mcns_scene(joffrey.dss$partner[1:10], open = TRUE, node='neuprint')
#' }
mcns_connection_table <- function(ids, partners=c("inputs", "outputs"),
                                  moredetails=TRUE, summary=FALSE,
                                  conn=mcns_neuprint(), ...) {
  # malevnc::manc_connection_table(ids=ids, partners=partners, moredetails = moredetails, conn=conn, summary=summary, ...)

  neuprintr::neuprint_connection_table(ids, partners=partners, details = T, conn=conn, summary=summary, ...)

}
