

#' Read neuronal skeletons via neuprint
#'
#' @param ids Bodyids in any form compatible with \code{malevnc::\link[malevnc]{manc_ids}}
#' @param connectors Whether to fetch synaptic connections for the neuron
#'   (default \code{FALSE} in contrast to
#'   \code{\link[neuprintr]{neuprint_read_neurons}}).
#' @param ... Additional arguments passed to
#'   \code{\link[neuprintr]{neuprint_read_neurons}}
#' @param units Units of the returned neurons (default \code{nm})
#' @param heal.threshold The threshold for
#'
#' @return A \code{\link[nat]{neuronlist}} object containing one or more
#'   \code{\link[nat]{neuron}} objects.
#' @export
#' @family neurons
#'
#' @examples
#' # nb convert
#' n30102=read_mcns_neurons(30102)
#' # neuronlist
#' n30102
#' boundingbox(n30102)
#' # neuron
#' n30102[[1]]
#' \dontrun{
#' nclear3d()
#' plot3d(malecns.surf, alpha=.1)
#' plot3d(n30102, lwd=2, soma=2000)
#' }
#' @importFrom nat boundingbox
read_mcns_neurons <- function(ids, connectors = F,
                              units=c("nm", "raw", "microns"),
                              heal.threshold=Inf, ...) {
  units=match.arg(units)
  res <- with_mcns(
    malevnc::manc_read_neurons(ids, conn = mcns_neuprint(),
                               connectors = connectors,
                               heal.threshold = heal.threshold, ...)
    )
  switch(units, nm=res*8, microns=res*(8/1000), res)
}
