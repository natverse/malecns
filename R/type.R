#' Predict the cell type of male cns neurons from type and name/instance fields
#'
#' @details For the time being when the instance is of the form 12345_L then
#'   12345 will be returned as the type. This obviously isn't very useful for
#'   most purposes (use \code{\link{mcns_predict_group}} if you want the group).
#'
#' @param ids Body ids in any form understandable by \code{\link{mcns_ids}}
#' @param method The prediction method to use (type, instance or auto, which
#'   uses type when available, instance otherwise). The special value of all
#'   adds 3 columns to the metadata data.frame \code{type_t, type_i, type_a}
#'   containing the results of each of the other methods.
#' @param prefer.foreign Whether to prefer a foreign type (flywire, manc,
#'   hemibrain) when available. This may be useful for integration across
#'   datasets (see details).
#'
#' @details Note that when \code{prefer.foreign=TRUE} or
#'   \code{method='foreign_type'}, if both flywire and manc types are available,
#'   the flywire type will be preferred \emph{except} for (sensory) ascending
#'   neurons. The thinking behind this exception is that the types given in
#'   flywire for the truncated axons of the ascending neurons are unlikely to be
#'   canonical.
#'
#' @return A data.frame when \code{type='all'}, a character vector otherwise.
#' @export
#' @seealso \code{\link{mcns_predict_group}}
#' @examples
#' \donttest{
#' mnm.ti <- mcns_neuprint_meta('where:exists(n.type) OR exists(n.instance)')
#' # Descending neurons with the wrong superclass
#' mnm.ti %>%
#'   mutate(ptype=mcns_predict_type(.)) %>%
#'   filter(grepl("DN[abdgpx]", ptype)) %>%
#'   filter(superclass!='Descending' | is.na(superclass))
#'
#' # report all the different types available for these two VPNs
#' mcns_predict_type("LoVP106", method = 'all') |>
#'   select(matches('.ype'))
#' # report just one type, preferring malecns type (the default)
#' mcns_predict_type("LoVP106")
#' # ... or preferring the foreign type (flywire in this case)
#' mcns_predict_type("LoVP106", prefer.foreign=TRUE)
#' }
#'
#' @importFrom dplyr case_when mutate filter
mcns_predict_type <- function(ids, method=c("auto", "instance", "type",
                                            "foreign_type", "all"),
                              prefer.foreign=FALSE) {
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
              type_f=mcns_predict_type(meta, method = 'foreign_type'),
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
  } else if(method=='foreign_type') {
    meta=normalise_meta(meta)
    if(!all(c("flywireType", "mancType", "hemibrainType") %in% colnames(meta)))
      meta=mcns_neuprint_meta(meta$bodyid)
    meta2 <- meta %>%
      # nb if both manc and flywire types exist, we will prefer manc for ascendings
      mutate(type=case_when(
        !is.na(.data$flywireType) & nzchar(.data$flywireType) & !grepl('ascending', superclass) ~ .data$flywireType,
        !is.na(.data$mancType) & nzchar(.data$mancType) ~ .data$mancType,
        !is.na(.data$flywireType) & nzchar(.data$flywireType) ~ .data$flywireType,
        !is.na(.data$hemibrainType) & nzchar(.data$hemibrainType) ~ .data$hemibrainType,
        T ~ .data$type
      )) %>%
      filter(!duplicated(.data$bodyid)) %>%
      mutate(type=gsub("[()]", "", type))
    res=meta2$type[match(ids, meta2$bodyid)]

  } else {
    # if we've got this far we have auto
    methods=c('type', 'foreign_type', 'instance')
    if(prefer.foreign)
      methods=c('foreign_type', 'type', 'instance')

    missing=rep(TRUE, nrow(meta))
    res=rep(NA_character_, nrow(meta))
    for(meth in methods) {
      if(!any(missing)) break
      res[missing]=mcns_predict_type(meta[missing,,drop=F], method=meth)
      # because in clio we might have the empty string stored
      res[nchar(res)==0]=NA
      missing=is.na(res)
    }
  }
  res
}
