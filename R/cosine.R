#' Cosine plot
#'
#' @param ids Bodyids in any form understood by \code{\link{mcns_ids}}
#' @param labRow A string interpolated by \code{\link{glue}} using the dataframe
#'   of metadata fetched by \code{\link{mcns_neuprint_meta}}. Alternatively a
#'   character vector with as many elements as \code{ids} directly specifying
#'   the rows.
#' @param group Optional character vector specifying the grouping column for the
#'   partner neurons when constructing the cosine similarity matrix. \code{TRUE}
#'   implies to \code{'group'}.
#' @param ... additional arguments passed to \code{\link{neuprint_cosine_plot}}
#'   and eventually to \code{heatmap}.
#' @inheritParams neuprintr::neuprint_cosine_plot
#' @inheritParams neuprintr::neuprint_cosine_matrix
#' @inheritParams coconat::prepare_cosine_matrix
#'
#' @return  The result of \code{\link{heatmap}} invisibly including the row and
#'   column dendrograms.
#' @export
#'
#' @examples
#' \donttest{
#' # cosine clustering based on grouped output partners (mainly DNs right now)
#' r=mcns_cosine_plot("/name:LAL.+", partners='out', group=TRUE)
#' }
mcns_cosine_plot <- function(ids, partners=c("output", "input"), group=FALSE,
                             groupfun=NULL,
                             labRow='{name}_{group}', action=NULL, ...) {
  if(isTRUE(group)) {
    group='group' # this ensures that we fetch the group column (+ type, name)
    groupfun=function(df) {
      # the type information in this dataframe will be associated with the ids
      # in the partner column not the bodyid column
      df$bodyid=df$partner
      df$partner=NULL
      mcns_predict_group(df, method = 'auto')
    }
  }
  xt.cm <- neuprintr::neuprint_cosine_matrix(ids, group = group, groupfun=groupfun, partners = partners, threshold = 10, conn = mcns_neuprint())
  xt.cm=coconat::prepare_cosine_matrix(xt.cm, partners=partners, action=action)
  meta=mcns_neuprint_meta(rownames(xt.cm))
  neuprintr::neuprint_cosine_plot(xt.cm, labRow = glue::glue(labRow, .envir=meta), conn = mcns_neuprint(), ...)
}
