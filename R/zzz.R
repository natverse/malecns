.onLoad <- function(libname, pkgname) {

  op.malecns <- list(
    malecns.dataset="CNS"
  )
  op<-options()
  toset <- !(names(op.malecns) %in% names(op))
  if(any(toset)) options(op.malecns[toset])
  res=try(malevnc::choose_flyem_dataset(set=FALSE,
                                 dataset = getOption('malecns.dataset')),
          silent = F)
  if (inherits(res, 'try-error'))
    warning(
      "Trouble choosing default malecns dataset.\nTry running dr_malecns() and then ",
      "ask on #code or file an issue at\n",
      "https://github.com/flyconnectome/malecns/issues"
    )

  res=try(mcns_register_xforms())
  res2=try(register_manc_malecns())
  if(inherits(res, 'try-error') || inherits(res2, 'try-error'))
    warning("Trouble registering malecns xforms.\n",
            "Ask on #code or file an issue at https://github.com/flyconnectome/malecns/issues")

  invisible()
}
