#' Predict the group of neurons using instance or type information
#'
#' @details Grouping information for neurons in the male cns is presently
#'   scattered in several locations. These include the numeric group field, the
#'   type field or the instance field. If the type field has the same value, the
#'   neurons should form a group. However there are some values that are known
#'   to be bad and these are excluded.
#'
#'   An additional source of group information comes from matches of VNC neurons
#'   to the MANC dataset. These either come as curated matches (where the
#'   \code{manc_group} column has been entered in Clio, \code{method="manc"}) or
#'   as predicted matches (based on the \code{manc_bodyid} column,
#'   \code{method="pmanc"}).
#'
#'   \code{method="pmanc"} should be used with caution since a significant
#'   percentage of these matches are wrong. However, since the majority should
#'   be correct, they may still be a useful source of group information e.g. for
#'   connectivity clustering which is typically not that sensitive to errors.
#'
#'   Given this situation \code{method='auto'} (the default) only uses curated
#'   matches (\code{method="manc"}). Select \code{method='fullauto'} to use the
#'   predicted MANC matches as a fall-back.
#'
#' @param ids Body ids in any form understood by \code{\link{mcns_ids}}. If you
#'   have a metadata dataframe as returned by \code{\link{mcns_neuprint_meta}}
#'   then this is ideal as that function is called under the hood.
#' @param method A string specifying which of 5 methods to use to identify the
#'   group. \code{"all"} means to return all 5, while \code{"fullauto"} means to
#'   look at each method in turn successively filling in missing group values.
#'   Method \code{"auto"} (the default) excludes predicted manc matches (see
#'   details).
#' @param badtypes Values of the type column which should be ignored for the
#'   purposes of defining cell type groups. This will be because they contain
#'   bad values or because the types are too broad to be very useful.
#'
#' @return For \code{method="all"} a dataframe as returned by
#'   \code{\link{mcns_neuprint_meta}} with additional columns
#'   \code{instance_group} and \code{type_group}. Otherwise a numeric vector.
#' @export
#' @importFrom dplyr ungroup mutate group_by filter %>% .data rename
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
mcns_predict_group <- function(ids,
                               method=c("auto", "fullauto", "group", "manc", "instance", "type", "pmanc", "all"),
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
          type_group=mcns_predict_group(meta, method = 'type'),
          mancGroup_group=mcns_predict_group(meta, method = 'manc'),
          pmanc_group=mcns_predict_group(meta, method = 'pmanc')
          )
    return(res)
  }
  if(method=='group') {
    res=meta$group
  } else if(method=='manc') {
    # use curated manc_group
    if("manc_group" %in% colnames(meta))
      meta=rename(meta, mancGroup=manc_group)
    # we can't do anything if missing this column
    if(!"mancGroup" %in% colnames(meta)) {
      warning("I recommend including mancGroup/manc_group in input dataframe!")
      return(rep(NA_real_, length(ids)))
    }
    meta2 <- meta %>%
      filter(!duplicated(.data$bodyid)) %>%
      filter(!is.na(.data$mancGroup)) %>%
      group_by(.data$mancGroup) %>%
      mutate(newgroup=suppressWarnings(min(as.numeric(.data$bodyid)))) %>%
      ungroup()
    res=meta2$newgroup[match(ids, meta2$bodyid)]
  } else if(method=='instance') {
    res=stringr::str_match(meta$name, "^([0-9]+)_[LRM]$")[,2]
  } else if(method=='type') {
    # try type, but we should drop some bad ones
    meta2 <- meta %>%
      filter(!duplicated(.data$bodyid)) %>%
      filter(!.data$type %in% badtypes) %>%
      group_by(.data$type) %>%
      mutate(newgroup=suppressWarnings(min(as.numeric(.data$bodyid)))) %>%
      ungroup()
    res=meta2$newgroup[match(ids, meta2$bodyid)]
  } else if(method=='pmanc') {
    # fix column names (think about doing this earlier?)
    meta=normalise_meta(meta)
    if(!"mancGroup" %in% colnames(meta)) {
      warning("I recommend including mancGroup/manc_group in input dataframe!")
      return(rep(NA_real_, length(ids)))
    }
    if(!"mancBodyid" %in% colnames(meta)) {
      warning("I recommend including mancBodyid/manc_bodyid in input dataframe!")
      return(rep(NA_real_, length(ids)))
    }
    res=mcns_predict_group_manc(meta)
  } else {
    # if we've got this far we have auto
    res=meta$group
    # because in clio we might have the empty string stored
    res[nchar(res)==0]=NA
    methods=c('manc', 'instance', "type")
    if(method=='fullauto') methods=union(methods, 'pmanc')
    for(meth in methods) {
      missing=is.na(res)
      if(any(missing))
        res[missing]=mcns_predict_group(meta[missing,,drop=F], method = meth)
    }
  }
  as.numeric(res)
}

# bodyids for groups
# having trouble getting this query to work
manc_bodyid_groups2 <- function(groups, all_segments=FALSE, ...) {
  conn=malevnc::manc_neuprint()
  cypher = glue::glue("WITH {neuprintr:::id2json(groups)} AS groups UNWIND groups AS group",
                      " MATCH (n:`{node}`) WHERE n.group=group",
                      "RETURN n.group , n.bodyId",
                      node = ifelse(all_segments, "Segment", "Neuron"))
  nc <- neuprintr::neuprint_fetch_custom(cypher = cypher, conn = conn,
                                         include_headers = FALSE, ...)
  meta <- neuprintr::neuprint_list2df(nc, return_empty_df = TRUE)
  meta <- neuprintr:::neuprint_fix_column_types(meta, conn = conn)
  meta
}

manc_bodyid_groups <- function(groupids=NULL) {
  conn=malevnc::manc_neuprint()
  nc <- neuprintr::neuprint_fetch_custom('MATCH (n:Neuron) WHERE exists(n.group) RETURN n.group , n.bodyId', conn = conn)
  meta <- neuprintr::neuprint_list2df(nc, return_empty_df = TRUE)
  meta <- neuprintr:::neuprint_fix_column_types(meta, conn = conn)
  colnames(meta)=c("group", 'bodyid')
  if(is.null(groupids)) return(meta)
  left_join(data.frame(group=malevnc::manc_ids(groupids, as_character = F)), meta, by='group')
}

#' @importFrom stats na.omit
mcns_predict_manc <- function(ids, join=FALSE) {
  if(is.data.frame(ids)){
    meta=normalise_meta(ids, add_missing = T)
    ids=mcns_ids(ids)
  } else meta=mcns_neuprint_meta(ids)
  # find the rows with mancBodyid
  # FIXME we still haven't implemented looking for
  rows_to_join=!is.na(meta$mancBodyid) | !is.na(meta$mancGroup)
  manc_ids=unique(na.omit(meta$mancBodyid))
  if(!length(manc_ids)>0) {
    warning("No matching MANC ids are recorded for those malecns ids")
    if(join) return(meta) else return(NULL)
  }
  mm=malevnc::manc_neuprint_meta()
  if(!join) return(mm)

  if(is.character(meta$mancBodyid)) mm$bodyid=malevnc::manc_ids(mm$bodyid, as_character=T)
  else mm$bodyid=malevnc::manc_ids(mm$bodyid, as_character=F)
  dplyr::left_join(meta, mm, by=c('mancBodyid'="bodyid"), suffix=c("", ".m"))
}

# predict the group column by using information from manc
# first use the manc_group column if that already exists
# then use the implied manc_group based on manc body id predictions
mcns_predict_group_manc <- function(ids) {
  if(is.data.frame(ids)){
    meta=normalise_meta(ids)
    if(!all(c("mancGroup", "mancBodyid") %in% colnames(meta)))
      stop("Dataframe must contain mancGroup and mancBodyid fields to define group")
    ids=mcns_ids(ids)
  } else meta=mcns_neuprint_meta(ids)
  mancmeta=mcns_predict_manc(meta, join = T)

  meta2 <- mancmeta %>%
    filter(!duplicated(.data$bodyid)) %>%
    mutate(newgroup=group) %>%
    # filter(is.na(group) | !nzchar(group)) %>%
    # curated manc group
    group_by(.data$mancGroup) %>%
    mutate(newgroup=case_when(
      is.na(mancGroup) ~ newgroup,
      T ~ suppressWarnings(min(as.numeric(.data$bodyid)))
    )) %>%
    ungroup() %>%
    # predicted manc group
    group_by(.data$group.m) %>%
    mutate(newgroup=case_when(
      !is.na(newgroup) ~ newgroup,
      is.na(group.m) ~ newgroup,
      T ~ suppressWarnings(min(as.numeric(.data$bodyid)))
    )) %>%
    ungroup()
  res=meta2$newgroup[match(ids, meta2$bodyid)]
  res
}

