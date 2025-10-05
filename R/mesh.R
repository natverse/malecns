#' Read a mesh for the current segmentation
#'
#' @details \code{dvid} meshes are pre-computed but are automatically deleted
#'   and recomputed after bodies are edited. However this process has a
#'   noticeable lag. \code{small} meshes are generated on demand in a process
#'   that can be quite slow. \code{auto} will try the \code{dvid} method and
#'   switch to \code{small} if that fails. See
#'   \href{https://flyem-cns.slack.com/archives/C01BZB05M8C/p1651719608800039}{slack}
#'    for details; this is essentially the same behaviour as the flyem clio
#'   fork.
#'
#' @param type One of \code{"auto"} (the default), \code{"dvid"} or
#'   \code{"small"} (see details).
#' @inheritParams malevnc::manc_dvid_annotations
#' @inheritParams read_mcns_neurons
#' @param df A data.frame containing information about the neurons for which
#'   meshes will be fetched. Optional and if \code{ids} is a data.frame, then
#'   that will be used.
#' @param ... Additional arguments passed to \code{httr::GET}
#'
#' @return A \code{\link{neuronlist}} containing one or more \code{mesh3d}
#'   objects.
#' @export
#' @family neurons
#' @examples
#' \dontrun{
#' ml=read_mcns_meshes(1796013202)
#' plot3d(ml)
#' # or if there's just one mesh, you can get more control with the rgl commands
#' # like wire3d
#' wire3d(ml[[1]])
#' }
read_mcns_meshes <- function(ids, units=c("nm", "raw", "microns"),
                             type=c('auto', 'dvid', 'small'),
                             node='neutu', df=NULL, ...) {
  if(is.data.frame(ids)) {
    df=ids
  }
  units=match.arg(units)

  type=match.arg(type)
  # fix default rownames, this should really happen in nat
  # see https://github.com/natverse/nat/pull/467
  if(!is.null(df) && "bodyid" %in% colnames(df)) {
    if(all(rownames(df)==seq_len(nrow(df))))
      rownames(df)=df[['bodyid']]
  }
  ids=mcns_ids(ids, mustWork=T)

  node=with_mcns({
    malevnc:::manc_nodespec(node, several.ok = F)
  })
  res=pbapply::pbsapply(ids, read_mcns_mesh, node=node, type=type, ..., simplify = F)
  res=nat::as.neuronlist(res, AddClassToNeurons=F, df=df)
  switch(units, raw=res/8, microns=res/1000, res)
}

#' @importFrom glue glue
read_mcns_mesh <- function(id, node, type, ...) {
  ss=malevnc:::flyem_servers4dataset(getOption("malecns.dataset", default = "male-cns:v0.9"))
  dvid = ss$dvid
  support = ss$support
  if(type %in% c("auto", "dvid")) {
    res <- try(with_mcns(malevnc:::read_manc_neuroglancer_mesh(id, node)))
    if(inherits(res, 'try-error')) {
      if(type=='auto') type='small'
      res=NULL
    }
  }
  if(type=='small') {
    u = glue("{support}/small-mesh?dvid={dvid}&uuid={node}&body={id}&decimation=0.5")
    res=malevnc:::read_neuroglancer_mesh(u, ...)
  }
  res
}
