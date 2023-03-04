#' Find/predict the soma side of male cns neurons.
#'
#' @details this should soon be overtaken by an actual recorded somaSide column
#'   but will likely still be helpful beyond this for new neurons.
#'
#' @param ids A set of bodyids or a dataframe containing the name and
#'   somaLocation fields
#' @param method Whether to use the side recorded in the instance field, the
#'   soma position or each of those in turn to predict.
#'
#' @return For \code{mcns_soma_side} a vector of sides (L, R, M, U or NA).
#'   Midline or unpaired neurons should be indicated with an M although I have
#'   seen U in the past.
#' @export
#'
#' @examples
#' \donttest{
#' mcns_soma_side('/LAL04.*')
#' }
#' \dontrun{
#' # All neurons with a type
#' table(mcns_soma_side('/.*'), useNA='if')
#' }
mcns_soma_side <- function(ids, method=c("auto", "position", "instance")) {
  method=match.arg(method)
  if(is.data.frame(ids)){
    if(!all(c('somaLocation', 'name') %in% colnames(ids)))
      stop("Must contatin somaLocation and name/instance fields to define soma side")
    meta=ids
    ids=mcns_ids(ids)
  } else meta=mcns_neuprint_meta(ids)
  if(method=='auto') {
    res=mcns_soma_side(meta, method='instance')
    missing=is.na(res)
    if(any(missing)) {
      res[missing]=mcns_soma_side(meta[missing,,drop=F], method = 'pos')
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
#'   Defaults to \epmh{nm}.
#' @export
#' @rdname mcns_soma_side
#' @examples
#' sp=mcns_somapos('/LAL04.*', units='um')
#' plot(sp[,1:2])
mcns_somapos <- function(ids, units=c("nm", "microns", "um", "raw")) {
  units=match.arg(units)
  if(is.data.frame(ids)){
    if(!'somaLocation' %in% colnames(ids))
      stop("data.frame must contatin somaLocation fields to define soma position")
    meta=ids
    ids=mcns_ids(ids)
  } else meta=mcns_neuprint_meta(ids)
  mcns_xyz(meta$somaLocation, outunits=units)
}
