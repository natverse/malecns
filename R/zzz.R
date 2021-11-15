.onLoad <- function(libname, pkgname) {

  op.malecns <- list(
    malecns.dataset="CNS"
  )
  op<-options()
  toset <- !(names(op.malecns) %in% names(op))
  if(any(toset)) options(op.malecns[toset])
  choose_mcns()
  mcns_register_xforms()
  invisible()
}
