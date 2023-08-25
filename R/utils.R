#' Situation report on your malecns package installation
#'
#' @export
#' @family malecns-package
dr_malecns <- function() {

  message("Dataset/auth status:")
  cds=try(with_mcns(malevnc:::clio_datasets()))
  if(inherits(cds, "try-error"))
    message("Trouble connecting to clio to list datasets.")
  else {
    cat("* Successfully connected to clio to list datasets:\n")

    cdsl=sapply(cds, function(x) {
      cols=c("title", "tag", "description", "uuid")
      cols2=intersect(cols,names(x))
      l=x[cols2]
      l[setdiff(cols, cols2)]=NA
      as.data.frame(l)
    }, simplify = F)
    cdsdf=do.call(rbind, cdsl)
    print(cdsdf)

    ct=malevnc::clio_token()
    email=attr(ct, 'email')

    message('Clio is authenticated with email: ', email)
  }

  npds=try(neuprintr::neuprint_datasets(conn=mcns_neuprint()))
  if(inherits(npds, "try-error"))
    message("\nTrouble connecting to neuprint for CNS datasets.")
  else {
    cat("\n* Successfully connected to neuprint dataset:\n")
    print(mcns_neuprint())
    cat(names(npds), "with last mod", npds[[1]]$`last-mod`,
        "and uuid",npds[[1]]$uuid, "\n")
  }

  message("\nRelevant malecns/malevnc options:")
  with_mcns({
    print(options()[grepl("^male(cns|vnc)", names(options()))])
  })

  message("\nSuggested packages:")
  if(!requireNamespace('Morpho', quietly=TRUE))
    message("Please install suggested package Morpho for bridging registrations")

  message("\nVersions and direct package dependencies:")
  cat("R:", as.character(getRversion()),"\n")
  if(!requireNamespace('remotes'))
    warning("Please install the suggested remotes package to query dependencies")
  res=remotes::dev_package_deps(find.package("malecns"))
  print(res)

}

check_package_available <- function(pkg) {
  if(!requireNamespace(pkg, quietly = TRUE)) {
    stop("Please install suggested package: ", pkg)
  }
}
