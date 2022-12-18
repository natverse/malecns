#' Login to male CNS neuprint server
#'
#' @details It should be possible to use the same token across public and
#'   private neuprint servers if you are using the same email address. However
#'   this does not seem to work for all users. Before giving up on this, do try
#'   using the \emph{most} recently issued token from a private server (e.g. cns
#'   dataset) rather than older tokens e.g. for hemibrain dataset. If you need
#'   to pass a specific token you can use the \code{token} argument, also
#'   setting \code{Force=T} to ensure that the specified token is used if you
#'   have already tried to log in during the current session. See examples for
#'   code.
#' @param ... Additional arguments passed to \code{\link{neuprint_login}}
#' @param token Optional neuprint access token (see details and examples if you
#'   have trouble with multiple tokens).
#' @inheritParams neuprintr::neuprint_login
#' @return a \code{\link{neuprint_connection}} object returned by
#'   \code{\link{neuprint_login}}
#' @export
#' @family manc-neuprint
#' @examples
#' \dontrun{
#' cnsc=mcns_neuprint()
#'
#' # log in using specified token rather than the one in the neuprint_token
#' # environment variable. This should then be cached for the rest of the R
#' # session.
#' cnsc=mcns_neuprint(token="XXX", Force=T)
#'
#' anchorids <- neuprintr::neuprint_ids("status:Anchor", conn=cnsc)
#' # the last connection will be used by default
#' anchormeta <- neuprintr::neuprint_get_meta("status:Anchor")
#'
#' plot(cumsum(sort(anchormeta$pre, decreasing = TRUE)), ylab='Cumulative presynapses')
#' plot(cumsum(sort(anchormeta$post, decreasing = TRUE)), ylab='Cumulative postsynapses')
#' }
mcns_neuprint <- function(token=Sys.getenv("neuprint_token"), Force=FALSE, ...) {
  neuprintr::neuprint_login(server='https://neuprint-cns.janelia.org', dataset = "cns", token=token, Force=Force, ...)
}


#' Connectivity query for CNS neurons
#'
#' @param ids A set of body ids (see \code{\link{manc_ids}} for a range of ways
#'   to specify these).
#' @param moredetails Either a logical (to add all fields when \code{TRUE}) or a
#'   character vector naming additional fields returned by
#'   \code{\link{mcns_neuprint_meta}} that will be added to the results
#'   data.frame.
#' @param summary Whether to summarise results per partner when giving multiple
#'   query neurons
#' @inheritParams malevnc::manc_connection_table
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' \donttest{
#' joffrey.id=mcns_xyz2bodyid(cbind(24590, 13816, 26102)+4096, node = 'neuprint')
#' joffrey.us=mcns_connection_table(joffrey.id, partners = 'in')
#' joffrey.uss=mcns_connection_table(joffrey.id, partners = 'in', summary=TRUE)
#' }
#' \dontrun{
#' # open top 10 partners in neuroglancer,
#' # NB segmentation / meshes to match neuprint
#' mcns_scene(joffrey.uss$partner[1:10], open = TRUE, node='neuprint')
#' }
mcns_connection_table <- function(ids, partners=c("inputs", "outputs"),
                                  moredetails=c("group", "class"), summary=FALSE,
                                  conn=mcns_neuprint(), ...) {
  # malevnc::manc_connection_table(ids=ids, partners=partners, moredetails = moredetails, conn=conn, summary=summary, ...)
  ids=mcns_ids(ids)
  res=neuprintr::neuprint_connection_table(ids, partners=partners, details = T, conn=conn, summary=summary, ...)
  if(!is.logical(moredetails)) {
    extrafields=moredetails;  moredetails=T
  } else extrafields=NULL
  if(moredetails && nrow(res)>0) {
    dets=mcns_neuprint_meta(unique(res$partner), conn=conn)
    if(is.null(extrafields))
      extrafields=setdiff(colnames(dets), colnames(res))
    dets=dets[union('bodyid', extrafields)]
    res=dplyr::left_join(res, dets, by=c("partner"="bodyid"))
  }
  res
}


#' Fetch neuprint metadata for malecns neurons
#'
#' @details in contrast to \code{malevnc::\link{manc_neuprint_meta}} we leave
#'   bodyids as numeric (doubles) since flyem now guarantee them to be less than
#'   2^53 i.e. within the range in which doubles can exactly represent numeric
#'   ids.
#' @param ids body ids.
#' @inheritParams malevnc::manc_neuprint_meta
#' @return A data.frame with one row for each (unique) id and NAs for all
#'   columns except bodyid when neuprint holds no metadata.
#' @export
#' @family annotations
#' @examples
#' \donttest{
#' mm=mcns_neuprint_meta()
#' }
mcns_neuprint_meta <- function(ids=NULL, conn=mcns_neuprint(), roiInfo=FALSE) {
  res=with_mcns(malevnc::manc_neuprint_meta(ids,conn=conn, roiInfo = roiInfo))
  res$bodyid=as.numeric(res$bodyid)
  # sort by body if if we were relying on dvid annotations
  if(is.null(ids)) res[order(res$bodyid), ] else res
}
