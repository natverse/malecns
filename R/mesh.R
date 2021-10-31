#' Read a mesh for the current segmentation
#'
#' @param id A body id
#' @param ... Additional arguments passed to \code{httr::GET}
#'
#' @return A \code{mesh3d} object
#' @export
#'
#' @examples
#' \dontrun{
#' m=read_mcns_mesh(1796013202)
#' wire3d(m)
#' }
read_mcns_mesh <- function(id, ...) {
  id=malevnc::manc_ids(id)
  u=sprintf("https://ngsupport-bmcp5imp6q-uk.a.run.app/small-mesh?dvid=https://emdata6-erivan.janelia.org&uuid=c2ece&body=%s&decimation=0.5", id)
  malevnc:::read_neuroglancer_mesh(u, ...)
}
