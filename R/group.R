#' Predict the group of neurons using instance or type information
#'
#' @details Grouping information for neurons in the male cns is presently
#'   scattered in several locations. These include the numeric group field, the
#'   type field or the instance field. If the type field has the same value, the
#'   neurons should form a group. However there are some values
#'
#' @param ids Body ids in any form understood by \code{\link{mcns_ids}}. If you
#'   have a metadata dataframe as returned by \code{\link{mcns_neuprint_meta}}
#'   then this is ideal as that function is called under the hood.
#' @param method A string specifying which of 3 methods to use to identify the
#'   group. \code{"all"} means to return all 3, while \code{"auto"} (the
#'   default) means to look at each method in turn successively filling in
#'   missing group values.
#' @param badtypes Values of the type column which should be ignored for the
#'   purposes of defining cell type groups. This will be because they contain
#'   bad values or because the types are too broad to be very useful.
#'
#' @return For \code{method="all"} a dataframe as returned by
#'   \code{\link{mcns_neuprint_meta}} with additional columns
#'   \code{instance_group} and \code{type_group}. Otherwise a numeric vector.
#' @export
#' @importFrom dplyr ungroup mutate group_by filter %>% .data
#' @seealso \code{\link{mcns_predict_type}}
#' @examples
#' \donttest{
#' library(dplyr)
#' # return all body ids with a group type or instance
#' tig_ids=mcns_ids('where:exists(n.group) OR exists(n.type) OR exists (n.instance)')
#' allg=mcns_predict_group(tig_ids, method = 'all')
#' # neurons where the recorded group and instance group disagree
#' allg %>% filter(!is.na(group) & !is.na(instance_group) & group!=instance_group)
#' }
#' \dontrun{
#' # neurons where the recorded group and type group disagree
#' type_group_mismatch <- allg %>% filter(!is.na(group) & !is.na(type_group) & group!=type_group)
#' allg %>%
#'   filter(group %in% type_group_mismatch$group | type_group %in% type_group_mismatch$type_group) %>%
#'  select(bodyid, type, name, group, type_group, instance_group) %>%
#'  arrange(type, group) %>% View
#' }
mcns_predict_group <- function(ids, method=c("auto", "group", "instance", "type", "all"),
                               badtypes=c(NA, "", "Lamina_R1-R6", "Descending", "KC",
                                          "ER", "LC", "PB",  "Ascending Interneuron",
                                          "Delta", "P1_L candidate", "LT", "MeMe",
                                          "PFGs", "Mi", "VT", "ML", "EL", "FB",
                                          "Dm", "DNp", "FC", "OL", "T", "Y")) {
  method=match.arg(method)
  if(is.data.frame(ids)){
    if('instance' %in% colnames(ids))
      colnames(ids)[colnames(ids)=='instance']='name'
    if(!all(c('name', "group", "type") %in% colnames(ids)))
      stop("Dataframe must contain group and name/instance fields to define group")
    meta=ids
    ids=mcns_ids(ids)
  } else meta=mcns_neuprint_meta(ids)
  if(method=='all') {
    res=cbind(meta,
          instance_group=mcns_predict_group(meta, method = 'instance'),
          type_group=mcns_predict_group(meta, method = 'type'))
    return(res)
  }
  if(method=='group') {
    res=meta$group
  } else if(method=='instance') {
    res=stringr::str_match(meta$name, "^([0-9]+)_[LRM]$")[,2]
  } else if(method=='type') {
    # try type, but we should drop some bad ones
    meta2 <- meta %>%
      filter(!duplicated(.data$bodyid)) %>%
      filter(!.data$type %in% badtypes) %>%
      group_by(.data$type) %>%
      mutate(newgroup=min(as.numeric(.data$bodyid))) %>%
      ungroup()
    res=meta2$newgroup[match(ids, meta2$bodyid)]
  } else {
    # if we've got this far we have auto
    res=meta$group
    # because in clio we might have the empty string stored
    res[nchar(res)==0]=NA
    missing=is.na(res)
    # try instance pairs
    if(any(missing))
      res[missing]=mcns_predict_group(meta[missing,,drop=F], method = 'instance')
    still_missing=is.na(res)
    if(any(still_missing))
       res[still_missing]=mcns_predict_group(meta[still_missing,,drop=F], method = 'type')
  }
  as.numeric(res)
}

