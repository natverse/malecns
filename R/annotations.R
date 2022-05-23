#' Return all DVID body annotations

#' @details See
#'   \href{https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1619201195032400}{this
#'    Slack post} from Stuart Berg for details.
#'
#'   Note that the original api call was \code{<rootuuid>:master}, but I have
#'   now just changed this to \code{<neutu-uuid>} as returned by
#'   \code{\link{manc_dvid_node}}. This was because the range query stopped
#'   working 16 May 2021, probably because of a bad node.
#' @inheritParams malevnc::manc_body_annotations
#' @param rval Whether to return a fully parsed data.frame (the default) or an R
#'   list. The data.frame is easier to work with but typically includes NAs for
#'   many values that would be missing in the list.
#' @param node A DVID node as returned by \code{\link{manc_dvid_node}}. The
#'   default is to return the current active (unlocked) node being used through
#'   neutu.
#' @param cache Whether to cache the result of this call for 5 minutes.
#'
#' @return A \code{tibble} containing with columns including \itemize{
#'
#'   \item bodyid as a \code{numeric} value
#'
#'   \item status
#'
#'   \item user
#'
#'   \item naming_user
#'
#'   \item instance
#'
#'   \item status_user
#'
#'   \item comment }
#'
#'   NB only one \code{bodyid} is used regardless of whether the key-value
#'   returned has 0, 1 or 2 bodyid fields. When the \code{ids} are specified,
#'   missing ids will have a row containing the \code{bodyid} in question and
#'   then all other columns will be \code{NA}.
#'
#' @export
#' @family annotations
#' @examples
#' \donttest{
#' mda=mcns_dvid_annotations()
#' head(mda)
#' plot(table(mda$type), ylab='Frequency')
#'
#' kcs=mcns_dvid_annotations("/KC.*")
#' mbons=mcns_dvid_annotations("/MBON.+")
#'
#' head(mbons)
#' }
mcns_dvid_annotations <- function(ids=NULL, node='neutu',
                                  rval=c("data.frame", "list"),
                                  cache=FALSE) {
  # because malevnc::manc_dvid_annotations does not pass a connection on to
  # manc_ids
  if(!is.null(ids))
    ids=mcns_ids(ids)
  with_mcns(malevnc::manc_dvid_annotations(ids=ids, node=node, rval=rval,cache=F))
}
