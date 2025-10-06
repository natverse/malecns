#' Evaluate an expression after temporarily setting malevnc options
#'
#' @description \code{malecns} is a thin wrapper around \code{malevnc}. This
#'   function temporarily changes the server/dataset options for the malevnc
#'   while running your expression.
#'
#' @details Note that as of 11 Aug 2025 it also switches out the active dataset
#'   for the malecns package if you specify something different using the
#'   \code{dataset} argument. This is probably what people always expected and
#'   allows you to easily run the same expression for e.g. production vs
#'   snapshot malecns datasets.
#'
#' @param expr An expression involving malecns/malevnc functions to evaluate
#'   with the specified autosegmentation. .
#' @param dataset The name of the dataset as reported in Clio e.g. \code{CNS},
#'   \code{male-cns:v0.9} etc.
#' @family malecns-package
#' @export
#' @examples
#' \dontrun{
#' with_mcns(malevnc::manc_dvid_node(type = 'clio'))
#' }
#' \donttest{
#' # This should work for both clio and neuprint calls, here clio:
#' # this body was typed after the v0.9 snapshot
#' with_mcns(mcns_body_annotations(194965), dataset = "male-cns:v0.9")
#' with_mcns(mcns_body_annotations(194965), dataset = "CNS")
#' }
with_mcns <- function(expr, dataset=getOption("malecns.dataset",
                                              default = "male-cns:v0.9")) {
  oldop <- choose_mcns(dataset)
  on.exit(options(oldop))
  oldop2 <- choose_mcns_dataset(dataset)
  on.exit(options(oldop2), add = T)
  force(expr)
}

#' Switch the default dataset for \code{mcns_*} functions
#' @param dataset The name of the dataset as reported in Clio e.g. CNS,  etc
#' @family malecns-package
#' @export
#' @description \code{choose_mcns_dataset} This sets the default dataset used by
#'   all \code{mcns_*} functions. It is the recommended way to access malecns
#'   snapshots. Unlike \code{\link{choose_mcns}} it does \emph{not} permanently
#'   change the default dataset used when callers use functions from the
#'   \code{malevnc} package (such as \code{malevnc::manc_xyz2bodyid}) directly.
#'
#' @examples
#' \dontrun{
#' # use the v0.9 snapshot for the rest of this R session
#' choose_mcns_dataset("male-cns:v0.9")
#' # use production for the rest of this R session
#' choose_mcns_dataset("CNS")
#' }
choose_mcns_dataset <- function(dataset='male-cns:v0.9') {
  if(dataset=='cns') {
    dataset='CNS'
  }

  # this will check that this is a sensible value and error if not
  if(dataset!='male-cns:v0.9')
    malevnc::choose_flyem_dataset(dataset, set=F)

  old_dataset=getOption("malecns.dataset", default = 'CNS')
  if(old_dataset!=dataset)
    message("switching CNS dataset from `", old_dataset, '` to `', dataset,'`')

  options(malecns.dataset = dataset)
}

#' @export
#' @inheritParams malevnc::choose_malevnc_dataset
#' @rdname with_mcns
#' @description \code{choose_mcns} swaps out the male vnc dataset for the male
#'   cns. This means that all functions from the \code{malevnc} package should
#'   target the male cns instead. It is recommended that you use the
#'   \code{with_mcns} function to do this temporarily unless you have no
#'   intention of using the male vnc dataset. \emph{To switch the default
#'   malecns dataset please see \code{choose_mcns_dataset}}.
choose_mcns <- function(dataset=getOption("malecns.dataset", default = 'male-cns:v0.9'), set=TRUE, use_clio=NA) {

  if(dataset=='male-cns:v0.9' && !isTRUE(use_clio)) {
    # let's do this manually
    ops=list(
      malevnc.dataset=dataset,
      malevnc.neuprint='https://neuprint.janelia.org',
      malevnc.neuprint_dataset=dataset,
      malevnc.rootnode='f3969dc575d74e4f922a8966709958c8',
      malevnc.server="https://emdata-mcns.janelia.org"
    )
    if(set) return(options(ops)) else return(ops)
  } else {
    if(isFALSE(use_clio))
      stop("I must use_clio to get information about dataset:", dataset)
  }
  malevnc::choose_flyem_dataset(set=set, dataset = dataset)
}


#' Construct a neuroglancer scene for CNS dataset
#'
#' @param ids A set of bodyids
#' @param open Whether to open in your default browser
#' @param dataset Optional CNS dataset
#' @param node Optional node specifier e.g. \code{"neutu", "neuprint"}. The
#'   default is to use the latest neutu node since the malecns node specified in
#'   Clio is rarely updated and nodes are used for longer periods compared with
#'   the male vnc.
#'
#' @return character vector containing URL
#' @export
#'
#' @examples
#' \dontrun{
#' mcns_scene(4060524874, open=TRUE, node='neuprint')
#'
#' }
mcns_scene <- function(ids=NULL, open=FALSE, dataset=getOption('malecns.dataset'), node='neutu') {
  sc=malevnc:::flyem_scene4dataset(dataset = dataset)

  # make sure these are in xyz order ...
  sc$dimensions=sc$dimensions[sort(names(sc$dimensions))]
  dlname=malevnc:::flyem_dvidlayer4scene(sc)$name
  if(!is.null(ids)) {
    ids=mcns_ids(ids, as_character = T, unique = T, dataset = dataset)
    sc$layers[[dlname]]$segments=ids
    sc$layers[[dlname]]$segmentQuery=paste(ids, collapse = ' ')
  }
  # turn off skeletons by default as they seem to display slower than meshes
  if(isTRUE(sc$layers[[dlname]]$source$subsources$skeletons))
    sc$layers[[dlname]]$source$subsources$skeletons=FALSE
  # typically we are looking at neurons
  sc$layout='3d'
  sc$position=c(47592.9453125, 26679.951171875, 13109.5)
  sc$projectionScale=55000
  if(!is.null(node)) {
    u=sc$layers[[dlname]]$source$url
    if(is.null(u))
      stop("Unable to extract segmentation source URL to insert custom DVID node!")
    node=with_mcns(malevnc:::manc_nodespec(node, several.ok = F))
    sc$layers[[dlname]]$source$url=
      sub("(.+org/)([a-f0-9]+)(/segmentation)", paste0("\\1", node, "\\3"), u)
  }

  u=fafbseg::ngl_encode_url(sc, baseurl = "https://clio-ng.janelia.org")
  if(open) {
    utils::browseURL(u)
    invisible(u)
  } else u
}


#' @importFrom nat xyzmatrix
open_mcns <- function(x, s = rgl::select3d(), coords.only=FALSE,
                      open=!coords.only, sample=NULL, reference=NULL,
                      dataset=getOption('malecns.dataset'), voxdims=NULL, ...) {
  if (is.vector(x, mode = "numeric") && length(x) == 3) {
    xyz = matrix(x, ncol = 3)
  }
  else {
    xyz = xyzmatrix(x)
    if (nrow(xyz) > 1) {
      xyz = colMeans(xyz[s(xyz), , drop = F])
      xyz = matrix(xyz, ncol = 3)
    }
  }
  j=malevnc:::flyem_scene4dataset(dataset)
  if(is.null(j$position))
    stop("Sorry, this scene URL does not seem to have any navigation information!")

  if(!is.null(sample) && !is.null(reference))
    xyz=nat.templatebrains::xform_brain(xyz, sample=sample, reference = reference, ...)

  if(is.null(voxdims))
    voxdims=as.numeric(sapply(j$dimensions, "[[", 1))*1e9
  xyz=xyz/voxdims
  j$position=c(xyz)
  u <- if(coords.only) {
    paste(j$position, collapse = ',')
    # nb make sure that we use a base URL matching the sample URL we were given
  } else fafbseg::ngl_encode_url(j, baseurl = "https://clio-ng.janelia.org")
  if(open) {
    utils::browseURL(u)
    invisible(u)
  } else u
}
