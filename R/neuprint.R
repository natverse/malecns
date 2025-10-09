#' Login to male CNS neuprint server
#'
#' @details It should be possible to use the same token across public and
#'   private neuprint servers if you are using the same email address. However
#'   this does not seem to work for all users. Before giving up on this, do try
#'   using the \emph{most} recently issued token from a private server (e.g. cns
#'   dataset) rather than older tokens e.g. for hemibrain dataset. If you need
#'   to pass a specific token you can use the \code{token} argument, also
#'   setting \code{Force=T} to ensure that the specified token is used if you
#'   have already tried to log in during the current session. See examples for
#'   code.
#' @param dataset Allows you to override the neuprint dataset (which will
#'   otherwise be chosen based on the value of \code{options(malecns.dataset)}
#'   which would normally be changed by using the function
#'   \code{\link{choose_mcns_dataset}})
#' @param ... Additional arguments passed to \code{\link{neuprint_login}}
#' @param token Optional neuprint access token (see details and examples if you
#'   have trouble with multiple tokens).
#' @inheritParams neuprintr::neuprint_login
#' @return a \code{\link{neuprint_connection}} object returned by
#'   \code{\link{neuprint_login}}
#' @export
#' @family manc-neuprint
#' @examples
#' \dontrun{
#' cnsc=mcns_neuprint()
#'
#' # log in using specified token rather than the one in the neuprint_token
#' # environment variable. This should then be cached for the rest of the R
#' # session.
#' cnsc=mcns_neuprint(token="XXX", Force=T)
#'
#' anchorids <- neuprintr::neuprint_ids("status:Anchor", conn=cnsc)
#' # the last connection will be used by default
#' anchormeta <- neuprintr::neuprint_get_meta("status:Anchor")
#'
#' plot(cumsum(sort(anchormeta$pre, decreasing = TRUE)), ylab='Cumulative presynapses')
#' plot(cumsum(sort(anchormeta$post, decreasing = TRUE)), ylab='Cumulative postsynapses')
#' }
mcns_neuprint <- function(token=Sys.getenv("neuprint_token"),
                          dataset=NULL, Force=FALSE, ...) {
  if(is.null(dataset))
    dataset=getOption("malecns.dataset", default = 'male-cns:v0.9')
  dataset=tolower(dataset)
  npserver=choose_mcns(set = F)$malevnc.neuprint
  neuprintr::neuprint_login(server=npserver, dataset = dataset, token=token,
                            Force=Force, ...)
}


#' Connectivity query for CNS neurons
#'
#' @param ids A set of body ids (see \code{\link{manc_ids}} for a range of ways
#'   to specify these).
#' @param moredetails Either a logical (to add all fields when \code{TRUE}) or a
#'   character vector naming additional fields returned by
#'   \code{\link{mcns_neuprint_meta}} that will be added to the results
#'   data.frame.
#' @param summary Whether to summarise results per partner when giving multiple
#'   query neurons
#' @inheritParams malevnc::manc_connection_table
#' @inheritParams neuprintr::neuprint_connection_table
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' library(dplyr)
#' mcns_connection_table('DNa02', partners = 'out') %>% head()
#' mcns_connection_table('DNa02', partners = 'out', summary = TRUE) %>% head()
#' # return weight of outputs in the brain specifically (see ROIweight column)
#' mcns_connection_table('DNa02', partners = 'out', roi='CentralBrain') %>% head()
#'
#' \donttest{
#' joffrey.id=mcns_xyz2bodyid(cbind(24590, 13816, 26102)+4096, node = 'neuprint')
#' joffrey.us=mcns_connection_table(joffrey.id, partners = 'in')
#' joffrey.uss=mcns_connection_table(joffrey.id, partners = 'in', summary=TRUE)
#' }
#' \dontrun{
#' # open top 10 partners in neuroglancer,
#' # NB segmentation / meshes to match neuprint
#' mcns_scene(joffrey.uss$partner[1:10], open = TRUE, node='neuprint')
#' }
mcns_connection_table <- function(ids, partners=c("inputs", "outputs"),
                                  moredetails=c("group", "superclass", "somaSide"),
                                  summary=FALSE, threshold = 1L,
                                  roi=NULL, by.roi=FALSE,
                                  conn=mcns_neuprint(), ...) {
  # malevnc::manc_connection_table(ids=ids, partners=partners, moredetails = moredetails, conn=conn, summary=summary, ...)
  ids=mcns_ids(ids)
  res=neuprintr::neuprint_connection_table(ids, partners=partners, details = T,
                                           threshold = threshold, conn=conn,
                                           summary=summary,
                                           roi=roi, by.roi=by.roi, ...)
  if(!is.logical(moredetails)) {
    extrafields=moredetails;  moredetails=T
  } else extrafields=NULL
  if(moredetails && nrow(res)>0) {
    dets=mcns_neuprint_meta(unique(res$partner), conn=conn)
    if(is.null(extrafields))
      extrafields=setdiff(colnames(dets), colnames(res))
    dets=dets[union('bodyid', extrafields)]
    res=dplyr::left_join(res, dets, by=c("partner"="bodyid"))
  }
  res
}


#' Fetch neuprint metadata for malecns neurons
#'
#' @details in contrast to \code{malevnc::\link{manc_neuprint_meta}} we leave
#'   bodyids as numeric (doubles) since flyem now guarantee them to be less than
#'   2^53 i.e. within the range in which doubles can exactly represent numeric
#'   ids.
#' @param ids body ids. When missing all bodies known to DVID are returned.
#' @param simplify.xyz Whether to simplify columns containing XYZ locations to a
#'   simple \code{"x,y,z"} format rather than a longer form referencing a schema
#'   at \code{spatialreference.org}. Defaults to \code{TRUE}.
#' @inheritParams malevnc::manc_neuprint_meta
#' @return A data.frame with one row for each (unique) input id and NAs for all
#'   columns except bodyid when neuprint holds no metadata.
#' @export
#' @family annotations
#' @examples
#' \donttest{
#' library(dplyr)
#' # fetch metatada for all bodies in neuprint
#' mnm=mcns_neuprint_meta()
#' # fetch metadata for all bodies with a somaLocation
#' mnm.soma=mcns_neuprint_meta("where:exists(n.somaLocation)")
#'
#' # type or instance present
#' mnm.ti <- mcns_neuprint_meta('where:exists(n.type) OR exists(n.instance)')
#'
#' # neurons without a superclass but quite a few synapses
#' mnm.nc=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.synweight>2000")
#' mnm.nc %>% arrange(desc(synweight))
#' }
#' library(dplyr)
#' # Which neurons don't have a superclass, but possibly should
#' mnm.nsc=mcns_neuprint_meta("where:NOT exists(n.superclass)")
#' mnm.nsc %>% count(statusLabel)
#'
#' # neurons that are RT or PRT should probably have a superclass
#' mnm.nscprt=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.statusLabel CONTAINS 'Roughly'")
#' mnm.nscprt %>% count()
mcns_neuprint_meta <- function(ids=NULL, conn=mcns_neuprint(), roiInfo=FALSE,
                               simplify.xyz=TRUE, cache=NA, ...) {
  res=with_mcns(malevnc::manc_neuprint_meta(ids,conn=conn, roiInfo = roiInfo, fields.regex.exclude='^col_[0-9]+', ...))
  res$bodyid=as.numeric(res$bodyid)
  # sort by body if if we were relying on dvid annotations
  if(simplify.xyz) {
    loc_cols=grep("Location$", colnames(res))
    for(col in loc_cols) {
      res[[col]]=neuprint_simplify_xyz(res[[col]])
    }
  }
  if(is.null(ids)) res[order(res$bodyid), ] else res
}


# normalise metadata column (names)
normalise_meta <- function(x, drop_bad=F, add_missing=F,
                           conn = malecns::mcns_neuprint()) {
  cx <- if(is.data.frame(x)) colnames(x)
  else if(is.character(x)) x
  else stop("x must be a character vector or dataframe")
  npFields.orig=malevnc:::mnp_fields(conn = conn)
  npFields.corr <- neuprintr:::dfFields(npFields.orig)

  # camelCase names (but omit those with dashes like vnc-shell)
  check_package_available('snakecase')
  ncx=snakecase::to_lower_camel_case(cx)
  dashed=grepl("-", cx)
  ncx[dashed]=cx[dashed]
  # rename some special cols
  ncx2=neuprintr:::dfFields(ncx)
  if(any(duplicated(ncx2))) {
    warning("There are duplicate columns in input metadata!",
            "Please check column:", paste(cx[duplicated(ncx2)],collapse = ', '))
  }

  if(!is.data.frame(x)) {
    names(ncx2)=cx
    return(ncx2)
  }
  colnames(x)=ncx2
  if(drop_bad)
    x=x[intersect(npFields.corr, ncx2)]
  if(add_missing) {
    missing_fields=setdiff(npFields.corr, ncx2)
    if(length(missing_fields)>0) {
      x[missing_fields]=NA
      # reorder columns to match standard order
      if(drop_bad)
        x=x[intersect(npFields.corr, colnames(x))]
    }
  }
  neuprintr:::neuprint_fix_column_types(x, conn=conn)
}

