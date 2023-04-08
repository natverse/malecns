#' Predict the cell type of male cns neurons from type and name/instance fields
#'
#' @details For the time being when the instance is of the form 12345_L then
#'   12345 will be returned as the type. This obviously isn't very useful for
#'   most purposes (use \code{\link{mcns_predict_group}} if you want the group).
#'
#'
#' @param ids Body ids in any form understandable by \code{\link{mcns_ids}}
#' @param method The prediction method to use (type, instance or auto, which
#'   uses type when available, instance otherwise). The special value of all
#'   adds 3 columns to the metadata data.frame \code{type_t, type_i, type_a}
#'   containing the results of each of the other methods.
#'
#' @return A data.frame when \code{type='all'}, a character vector otherwise.
#' @export
#' @seealso \code{\link{mcns_predict_group}}
#' @examples
#' \donttest{
#' mnm.ti <- mcns_neuprint_meta('where:exists(n.type) OR exists(n.instance)')
#' # Descending neurons with the wrong class
#' mnm.ti %>%
#'   mutate(ptype=mcns_predict_type(.)) %>%
#'   filter(grepl("DN[abdgpx]", ptype)) %>%
#'   filter(class!='Descending' | is.na(class))
#' }
#' @importFrom dplyr case_when mutate filter
mcns_predict_type <- function(ids, method=c("auto", "instance", "type", "all")) {
  badtypes=c(NA, "", "Lamina_R1-R6", "Descending", "KC",
             "ER", "LC", "PB",  "Ascending Interneuron",
             "Delta", "P1_L candidate", "LT", "MeMe",
             "PFGs", "Mi", "VT", "ML", "EL", "FB",
             "Dm", "DNp", "FC", "OL", "T", "Y")
  method=match.arg(method)
  if(is.data.frame(ids)){
    if('instance' %in% colnames(ids))
      colnames(ids)[colnames(ids)=='instance']='name'
    if(!all(c('name', "type") %in% colnames(ids)))
      stop("Dataframe must contain type and name/instance fields to define type")
    meta=ids
    ids=mcns_ids(ids)
  } else {
    ids=mcns_ids(ids)
    meta=mcns_neuprint_meta(ids)
  }
  if(method=='all') {
    res=cbind(meta,
              type_t=mcns_predict_type(meta, method = 'type'),
              type_i=mcns_predict_type(meta, method = 'instance'),
              type_a=mcns_predict_type(meta, method = 'auto'))
    return(res)
  }
  if(method=='instance') {
    meta2 <- meta %>%
      filter(!duplicated(.data$bodyid)) %>%
      # filter(!.data$type %in% badtypes) %>%
      mutate(name2=sub("_[LRM]$", "", name)) %>%
      mutate(name2=gsub(" ", ",", name2)) %>%
      mutate(name2=case_when(
        substr(name2,1,1)=='(' ~ gsub("[()]", "", name2),
        grepl("[(]", name2) ~ sub("^(.+)[(].*", "\\1", name2),
        T ~ name2
      )) %>%
      mutate(name2=trimws(name2),
             name2=case_when(
               nchar(name2)==0 ~ NA_character_,
               T ~ name2
               )
             )
    res=meta2$name2[match(ids, meta2$bodyid)]
  } else if(method=='type') {
    # try type, but we should drop some bad ones
    meta2 <- meta %>%
      filter(!duplicated(.data$bodyid)) %>%
      filter(!.data$type %in% badtypes) %>%
      mutate(type=gsub("[()]", "", type))
    res=meta2$type[match(ids, meta2$bodyid)]
  } else {
    # if we've got this far we have auto
    res=mcns_predict_type(meta, method = 'type')
    # because in clio we might have the empty string stored
    res[nchar(res)==0]=NA
    missing=is.na(res)
    # try instance pairs
    if(any(missing))
      res[missing]=mcns_predict_type(meta[missing,,drop=F], method = 'instance')
  }
  res
}
