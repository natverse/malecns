#' Surface model of the cortex (rind) of the malecns brain (in nm)
#'
#' @rdname malecns
#' @docType data
#' @examples
#' boundingbox(malecns_shell.surf)
#'
#' \dontrun{
#' library(nat)
#' plot3d(malecns_shell.surf, alpha=.2, col='grey')
#' # in microns
#' plot3d(malecns_shell.surf/1e3, alpha=.2, col='grey')
#' # in raw voxels
#' plot3d(malecns_shell.surf*(8/1e3), alpha=.2, col='grey')
#' # mesh3d gives more flexibility
#' plot3d(as.mesh3d(malecns_shell.surf), alpha=.2, col='grey', type='wire', add=T)
#' }
"malecns_shell.surf"
