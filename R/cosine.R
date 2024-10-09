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
#' @param predict.manc whether to use \code{manc_bodyid} \emph{predicted}
#'   matches to define grouping information in addition to curated
#'   \code{manc_group} matches. See \code{\link{mcns_predict_group}} for
#'   details.
#' @param metadata.source Whether to use neuprint
#'   (\code{\link{mcns_neuprint_meta}}) and clio ()
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
#' \dontrun{
#' # fancier labelling of rows including soma side of neurons
#' r=mcns_cosine_plot("/name:LAL.+", partners='out', group=TRUE,
#'   labRow = '{name}_{group}_{mcns_soma_side(data.frame(bodyid, name, somaLocation))}')
#'
#' r2=mcns_cosine_plot("/name:LAL.+", partners='out', group=TRUE,
#'   labRow = '{instance}_{group}_{soma_side}', metadata.source='clio')
#'
#' # interactive version (open in browser)
#' mcns_cosine_plot('/name:Pm2.*R', group=T, interactive = T)
#'
#' # just return an hclust (dendrogram) object without plotting anything
#' pm2.hc=mcns_cosine_plot('/name:Pm2.*R', group=T, heatmap=FALSE)
#' plot(pm2.hc)
#' }
mcns_cosine_plot <- function(ids, partners=c("output", "input"), group=FALSE,
                             groupfun=NULL, labRow='{name}_{group}',
                             predict.manc=FALSE,
                             heatmap=TRUE,
                             metadata.source=c("neuprint", "clio"),
                             interactive=FALSE, action=NULL,
                             threshold = 10,
                             ...) {
  if(isTRUE(group)) {
    group='group' # this ensures that we fetch the group column (+ type, name)
    groupfun=function(df) {
      # the type information in this dataframe will be associated with the ids
      # in the partner column not the bodyid column
      df$bodyid=df$partner
      df$partner=NULL
      mcns_predict_group(df, method = ifelse(predict.manc, 'fullauto', 'auto'))
    }
  }
  xt.cm <- neuprintr::neuprint_cosine_matrix(ids, group = group, groupfun=groupfun,
                                             partners = partners, threshold = threshold,
                                             conn = mcns_neuprint(),
                                             details=c("instance","type", "group","mancGroup", "mancBodyid"))
  xt.cm=coconat::prepare_cosine_matrix(xt.cm, partners=partners, action=action)
  if(is.character(labRow) && length(labRow)==1 && any(grepl("\\{", labRow))) {
    metadata.source=match.arg(metadata.source)
    ids2=rownames(xt.cm)
    meta <- if(metadata.source=='clio')
      mcns_body_annotations(ids2) else mcns_neuprint_meta(ids2)
    labRow <- glue::glue_data(labRow, .x = meta)
  }

  coconat:::cosine_heatmap(xt.cm, interactive = interactive, labRow = labRow, heatmap=heatmap, ...)
}

