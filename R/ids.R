mcns_ids <- function(ids, ..., dataset=getOption("malecns.dataset")) {
  with_mcns(malevnc::manc_ids(ids, ...))
}
