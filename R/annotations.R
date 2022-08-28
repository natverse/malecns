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

#' Set the DVID type, instance or group for some malecns neurons
#'
#' @details For the male CNS, the evolving standard seems to be to record the
#'   following fields (examples given for APL) \itemize{
#'
#'   \item \code{type='APL'}
#'
#'   \item \code{instance='APL_R'}
#'
#'   \item \code{group='APL_R'}
#'
#'   \item \code{type_user, instance_user, group_user='jefferisg'} to accompany
#'   all of those.
#'
#'   }
#'
#'   Note that \code{type_user, instance_user, group_user} will be set
#'   automatically using the \code{user} argument. Regrettably you cannot
#'   currently specify different users for different different fields (e.g. one
#'   user for \code{instance} and a different user for \code{type}). Should you
#'   need to do this (e.g. when making annotations on behalf of other users)
#'   then you will need to make separate calls to
#'   \code{mcns_set_dvid_annotations} for each field you need set.
#' @param ids Body ids
#' @param type Character vector specifying cell type e.g. "LHAD1g1"
#' @param side Character vector specifying the side of each neuron (\code{"L",
#'   "R"} or \code{""} when it cannot be specified)
#' @param instance Character vector specifying instances (names) for neurons
#'   (see details) \emph{or} a logical value where \code{TRUE} (the default)
#'   means to append the side to the type.
#' @param group One or more LR groups (i.e. candidate cell types) to apply.
#'   These should normally be the lowest bodyid of the group. Must be the same
#'   length as \code{ids} unless it has length 1.
#' @param user The DVID user. Defaults to \code{options("malevnc.dvid_user")}.
#' @param ... Additional arguments passed to
#'   \code{malevnc::manc_set_dvid_instance} and thence to
#'   \code{pbapply::pbmapply} when there are multiple body ids.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' mcns_set_dvid_annotations(10297, type = 'LHAD1g1')
#' mcns_set_dvid_annotations(10977, type='APL', side='L', group = 10540)
#' # only set the LR group
#' mcns_set_dvid_annotations(ids=c(13115, 14424), group = 13115)
#'
#' # unset a type (careful!)
#' mcns_set_dvid_annotations(18987, type = "", user = "becketti")
#' }
mcns_set_dvid_annotations <- function(ids, type=NULL, group=NULL, side=NULL, instance=T, user=getOption("malevnc.dvid_user"), ...) {
  if((isTRUE(instance) || isFALSE(instance)) &&
     is.null(type) && is.null(group))
    stop("You must specify one of type, group or instance")
  # don't try and autoset instance if we have no type information
  if(isTRUE(instance) && is.null(type))
    instance=FALSE
  if(isTRUE(instance)) {
    if(is.null(side))
      stop("You must specify side information to set instances")
    instance=paste0(type, "_", side)
  } else if(isFALSE(instance)) {
    instance=NULL
  }
  if(length(type)>0 || length(instance)>0) {
    with_mcns(malevnc::manc_set_dvid_instance(ids, type=type, instance = instance, user=user, ...))
  }
  if(!is.null(group)) {
    if(length(group)!=length(ids)) {
      if(length(group)!=1)
        stop("group must have length 1 or the same length as ids!")
      group=rep(group, length(ids))
    }
    invisible(with_mcns(pbapply::pbmapply(
      mcns_set_group, id=ids, group=group, user=user)))
  }
}

mcns_set_group <- function(id, group, user) {
  checkmate::checkInt(id, lower=10000L)
  id=as.integer(id)
  l=list(group=group, group_user=user)
  malevnc::manc_set_dvid_annotations(bodyid = id, annlist = l)
}
