#' @keywords internal
#' @section Package Options: There is just one package option:
#'
#' \itemize{
#'
#'   \item \code{malecns.dataset} This is to used to keep track of the active
#'   malecns dataset.
#'
#'   }
#'
#'   This is now of more than internal use as you can use it run your code
#'   against the production dataset (still the default) or a snapshot. There are
#'   essentially three main ways to do this, from safest/least intrusive to most
#'   intrusive. I recommend using option 1 for one-off queries and option 2 if
#'   you want to run a series of commands within a script.
#'
#'   \enumerate{
#'
#'   \item Use \code{\link{with_mcns}(dataset="<name of dataset>")} to run a
#'   piece of code without switching the default malecns dataset.
#'
#'   \item Use the \code{\link{choose_mcns_dataset}} to choose a default malecns
#'   dataset for the rest of the session (or until you change it again).
#'
#'   \item Expert users may also wish to set the \code{malecns.dataset} option
#'   directly in their \code{.Rprofile} file to set a permanent default.
#'
#'   }
#'
#' @section Bridging registrations: Philipp Schlegel has made bridging
#'   registrations using bigwarp and the presynapse predictions for the male
#'   half brain and male cns. See
#'   \href{https://flyconnectome.slack.com/archives/C02F6UCCU6B/p1652945492746389?thread_ts=1652423869.552919&cid=C02F6UCCU6B}{slack}
#'   for details. And an
#'   \href{https://flyconnectome.slack.com/archives/C02F6UCCU6B/p1747641901448259}{an
#'   updated registration}.
#'
#'   There is a special space "malecnsplot" which brings the brain and VNC into
#'   a more aligned orientation. See examples below and
#'   \href{https://flyconnectome.slack.com/archives/C02F6UCCU6B/p1747645164139839}{slack
#'   message}.
#' @family malecns-package
#' @examples
#' \donttest{
#' options()[grepl("^malecns", names(options()))]
#' }
#' \dontrun{
#' dr_malecns()
#'
#' # run expression without changing default malecns dataset
#' with_mcns(mcns_body_annotations(194965), dataset = "male-cns:v0.9")
#'
#' # run expression(s) after changing default malecns dataset
#' choose_mcns_dataset("male-cns:v0.9")
#' mcns_body_annotations(194965)
#' choose_mcns_dataset("CNS")
#' mcns_body_annotations(194965)
#'
#' # edit .Rprofile to set package options (expert use)
#' usethis::edit_r_profile()
#' }
#'
#' \donttest{
#' library(nat.templatebrains)
#' xform_brain(cbind(443344, 225172, 44920), sample = 'FAFB14',
#'   reference = 'malecns')
#'
#' mcflm=system.file("landmarks/maleCNS_brain_FAFB_landmarks_um.csv", package = 'malecns')
#' mcflm=read.csv(mcflm)
#' head(mcflm)
#' \dontrun{
#' library(nat.jrcbrains)
#' da1.hb=neuprintr::neuprint_read_neurons('/DA1.*lPN',
#'   conn=neuprintr::neuprint_login(server='https://neuprint.janelia.org',
#'     dataset = 'hemibrain:v1.2.1'))
#' # nb hemibrain neurons comes in 8nm raw voxel coordinates not microns
#' da1.hb.mcns=xform_brain(da1.hb*(8/1000), sample='JRCFIB2018F', reference='malecns')
#' # read in a male cns DA1 neuron
#' da1.1=read_mcns_meshes(11996, units='nm')
#' nclear3d()
#' plot3d(da1.hb.mcns, col='cyan')
#' plot3d(da1.1, col='red')
#' plot3d(malecns.surf, alpha=.1)
#'
#' # compare plotting orientation with original templates
#' plot3d(malecns_shell.surf)
#' plot3d(malecnsvnc_shell.surf)
#' plot3d(xform_brain(malecnsvnc_shell.surf, sample='malecns', ref='malecnsplot'), col='red')
#' plot3d(xform_brain(malecns_shell.surf, sample='malecns', ref='malecnsplot'), col='red')
#'
#' }
#' }
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
