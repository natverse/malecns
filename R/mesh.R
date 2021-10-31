#' Read a mesh for the current segmentation
#'
#' @details \code{small} meshes are low-resolution and generated on demand
#'
#' @param type Currently only "small" meshes are supported
#' @inheritParams malevnc::manc_dvid_annotations
#' @param df A data.frame containing information about the neurons for which
#'   meshes will be fetched. Optional and if \code{ids} is a data.frame, then
#'   that will be used.
#' @param ... Additional arguments passed to \code{httr::GET}
#'
#' @return A \code{\link{neuronlist}} containing one or more \code{mesh3d}
#'   objects.
#' @export
#'
#' @examples
#' \dontrun{
#' ml=read_mcns_meshes(1796013202)
#' plot3d(ml)
#' # or if there's just one mesh, you can get more control
#' wire3d(ml[[1]])
#' }
read_mcns_meshes <- function(ids, type='small', node='neutu', df=NULL, ...) {
  if(is.data.frame(ids)) {
    df=ids
  }
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
  res=pbapply::pbsapply(ids, read_mcns_mesh, node=node, ..., simplify = F)
  return(nat::as.neuronlist(res, AddClassToNeurons=F, df=df))
}

read_mcns_mesh <- function(id, node, ...) {
  u=sprintf("https://ngsupport-bmcp5imp6q-uk.a.run.app/small-mesh?dvid=https://emdata6-erivan.janelia.org&uuid=%s&body=%s&decimation=0.5", node, id)
  malevnc:::read_neuroglancer_mesh(u, ...)
}
