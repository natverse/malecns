#' Find/predict the soma side or position of male cns neurons.
#'
#' @details the recorded \code{somaSide} column in neuPrint / \code{soma_side}
#'   in clio should be preferred but is not always available.
#'   \code{method='auto'} will prefer those columns but then cascade through
#'   instance and somaLocation to define the rest.
#'
#' @param ids A set of bodyids or a dataframe containing the \code{name} and
#'   \code{somaLocation} fields
#' @param method Whether to use the side recorded in the instance field, the
#'   soma position or each of those in turn to predict. The method manual
#'   returns manually curated soma sides recorded via Clio (see details).
#'
#' @return For \code{mcns_soma_side} a vector of sides (L, R, M, U or NA).
#'   Midline or unpaired neurons should be indicated with an M although I have
#'   seen U in the past.
#' @export
#' @family annotations
#' @examples
#' \donttest{
#' mcns_soma_side('/LAL04.*')
#' }
#' \dontrun{
#' # All neurons with a type
#' table(mcns_soma_side('/.*'), useNA='if')
#'
#' # compare manual with predictions
#' mcnswsoma=mcns_body_annotations(query=list(soma_side="exists/1"))
#' mcnswsoma$pside=mcns_soma_side(mcnswsoma$bodyid)
#' with(mcnswsoma, table(soma_side, pside))
#'
#' # compare manual with instance
#' mcnswsoma=mcns_body_annotations(query=list(soma_side="exists/1"))
#' mcnswsoma$iside=mcns_soma_side(mcnswsoma$bodyid, method='instance')
#' with(mcnswsoma, table(soma_side, iside, useNA = 'i'))
#'
#' # converse: compare instance with manual
#' mcns_instance=mcns_neuprint_meta('/name:.+')
#' if(!"somaSide" %in% colnames(mcns_instance))
#'   mcns_instance$somaSide=mcns_soma_side(mcns_instance, method='manual')
#' mcns_instance$iside=mcns_soma_side(mcns_instance, method='instance')
#' # many mismatches e.g. due to neurons without a soma including truncated
#' # sensory neurons, ascending neurons etc
#' with(mcns_instance, table(somaSide, iside, useNA = 'i'))
#'
#' # we can parse that a bit by doing
#' mcns_instance %>% filter(soma) %>% with(table(somaSide, iside, useNA = 'i'))
#' }
mcns_soma_side <- function(ids, method=c("auto", "position", "instance", "manual")) {
  method=match.arg(method)
  if(method=='manual') {
    if(is.data.frame(ids)) {
      meta=ids
      if("somaSide" %in% colnames(meta))
        return(meta$somaSide)
      else if("soma_side" %in% colnames(meta))
        return(meta$soma_side)
    }
    ids=mcns_ids(ids)
    meta=mcns_body_annotations(ids)
    return(meta$soma_side)
  }

  if(is.data.frame(ids)){

    if(method %in% c("auto", "position") &&
      !'somaLocation' %in% colnames(ids))
      stop("Data.frame must have somaLocation and name/instance fields to define soma side")
    if(method %in% c("auto", 'instance') &&
       !'name' %in% colnames(ids))
      stop("Data.frame must have somaLocation and name/instance fields to define soma side")
    meta=ids
    ids=mcns_ids(ids)
  } else meta=mcns_neuprint_meta(ids)
  if(method=='auto') {
    res=mcns_soma_side(meta, method='manual')
    missing=is.na(res)
    if(any(missing))
      res[missing]=mcns_soma_side(meta[missing,,drop=F], method='instance')
    stillmissing=is.na(res)
    if(any(stillmissing)) {
      res[stillmissing]=mcns_soma_side(meta[stillmissing,,drop=F], method = 'pos')
    }
  } else if(method=='instance') {
    res=stringr::str_match(meta$name, '_([LRMU])$')[,2]
  } else {
    somapos=mcns_somapos(meta, units="nm")
    somaposm=mirror_malecns(somapos)
    res=ifelse((somaposm[,1]-somapos[,1])>0, 'R', "L")
  }
  res
}

#'
#' @description \code{mcns_somapos} returns the XYZ location (in nm, microns or
#'   raw voxel space) of the soma position for neurons. When no valid soma
#'   position is available, then a \code{NA} value is returned.
#' @param units For \code{mcns_somapos} the units of returned 3D positions.
#'   Defaults to \emph{nm}.
#' @param as_character Whether to return the positions as Nx3 matrix (the
#'   default) or as comma separated strings.
#' @return For \code{mcns_somapos} a matrix or a character vector depending on
#'   the value of \code{as_character}

#' @export
#' @rdname mcns_soma_side
#' @examples
#' sp=mcns_somapos('/LAL04.*', units='um')
#' plot(sp[,1:2])
#' mcns_somapos('LAL042', units='um', as_character=TRUE)
mcns_somapos <- function(ids, units=c("nm", "microns", "um", "raw"),
                         as_character=FALSE) {
  units=match.arg(units)
  if(is.data.frame(ids)){
    if(!'somaLocation' %in% colnames(ids))
      stop("data.frame must contatin somaLocation fields to define soma position")
    meta=ids
    ids=mcns_ids(ids)
  } else meta=mcns_neuprint_meta(ids)
  mcns_xyz(meta$somaLocation, outunits=units, as_character=as_character)
}
