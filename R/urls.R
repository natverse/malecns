#' Evaluate an expression after temporarily setting malevnc options
#'
#' @description \code{malecns} is a thin wrapper around \code{malevnc} which
#'   operates by changing the server/dataset options of that package. This
#'   function temporarily changes those options, runs the required expression
#'   and then sets back again.
#'
#' @param expr An expression to evaluate with a default autosegmentation
#' @param dataset The name of the dataset as reported in Clio e.g. CNS, VNC etc
#' @export
#' @examples
#' \dontrun{
#' with_mcns((malevnc::manc_dvid_node(type = 'clio'))
#' }
with_mcns <- function(expr, dataset=getOption("malecns.dataset")) {
  oldop <- choose_malevnc_dataset(dataset=dataset, set=T)
  on.exit(options(oldop))
  force(expr)
}

mcns_datasets <- function() {
  js=malevnc:::clio_datasets(json=T)
  # TODO could memoise this, takes a few seconds
  jsonlite::fromJSON(js, simplifyVector = T, simplifyDataFrame = F)
}

mcns_dataset <- function(dataset) {
  cds=mcns_datasets()
  dataset=match.arg(dataset, names(cds))
  cds[[dataset]]
}

choose_malevnc_dataset <- function(set=TRUE,
                                   dataset=getOption("malecns.dataset")) {
  ds=mcns_dataset(dataset)
  s=servers4dataset(ds)
  r=rootnode4dataset(ds)
  ops=list(malevnc.server=s$dvid,
           malevnc.rootnode=r,
           malevnc.dataset=dataset,
           malevnc.neuprint=ifelse(dataset=="CNS",
                                   'https://neuprint-cns.janelia.org',
                                   'https://neuprint-pre.janelia.org'))
  if(set) options(ops) else ops
}

scene4dataset <- memoise::memoise(function(dataset=NULL) {
  ds <- if(is.character(dataset)) mcns_dataset(dataset) else dataset
  stopifnot(!is.null(ds$neuroglancer))
  sc=fafbseg::ngl_decode_scene(ds$neuroglancer)

  # there are some key layers here
  sc2=fafbseg::ngl_decode_scene(ds$versions[[1]]$neuroglancer)
  ll=c(sc$layers[1], sc2$layers[1], sc$layers[-1], sc2$layers[-1])
  fafbseg::ngl_layers(sc) <- ll
  sc
})

servers4dataset <- memoise::memoise(function(dataset=NULL) {
  sc=scene4dataset(dataset)
  dl=dvidlayer4scene(sc)
  u=dl$source$url
  dvid=sub("dvid-service=.*", "", u)
  dvid=sub("dvid://", "", dvid)
  dvid=sub("(https://[^/]+).*", "\\1", dvid)
  list(
    dvid=dvid,
    support=sub("&.*", "", sub(".*dvid-service=", "", u))
  )
})

dvidlayer4scene <- function(sc) {
  dvidlayer <- sapply(sc$layers, function(x) isTRUE(try(grepl("dvid", x$source$url), silent = T)))
  # if(sum(dvidlayer)!=1)
  #   warning("Unable to extract a unique DVID layer!")
  dl=sc$layers[[min(which(dvidlayer))]]
  dl
}

rootnode4dataset <- memoise::memoise(function(dataset=NULL) {
  ds <- if(is.character(dataset)) mcns_dataset(dataset) else dataset
  stopifnot(!is.null(ds$uuid))
  servers=servers4dataset(ds)
  u=sprintf("%s/api/repo/%s/info", servers$dvid, ds$uuid)
  info = try(jsonlite::fromJSON(readLines(u, warn = F)))
  stopifnot(!is.null(info$Root))
  info$Root
})

mcns_scene <- function(ids=NULL, open=FALSE, dataset=getOption('malecns.dataset')) {
  sc=scene4dataset(dataset = dataset)
  dlname=dvidlayer4scene(sc)$name
  if(!is.null(ids)) {
    ids=mcns_ids(ids, as_character = T, unique = T, dataset = dataset)
    sc$layers[[dlname]]$segments=ids
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
  j=scene4dataset(dataset)
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
