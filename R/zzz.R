.onLoad <- function(libname, pkgname) {

  op.malecns <- list(
    malecns.dataset="male-cns:v0.9"
  )
  op<-options()
  toset <- !(names(op.malecns) %in% names(op))
  if(any(toset)) options(op.malecns[toset])

    ds=getOption('malecns.dataset', default = 'male-cns:v0.9')

  packageStartupMessage("Using malecns dataset `",ds,"`.")
  if(ds=='CNS') {
    packageStartupMessage(
    "You can switch to a snapshot dataset in this R session with:\n",
    'choose_mcns_dataset("male-cns:v0.9")'
    )
    res=try(malevnc::choose_flyem_dataset(set=FALSE,
                                          dataset = getOption('malecns.dataset')),
            silent = F)
    if (inherits(res, 'try-error'))
      packageStartupMessage(
        "Trouble choosing default malecns dataset.\nTry running dr_malecns() and then ",
        "ask on #code or file an issue at\n",
        "https://github.com/flyconnectome/malecns/issues"
      )

  }
  packageStartupMessage(
    'See ?malecns section Package Options for details.')

  res=try(mcns_register_xforms())
  res2=try(register_manc_malecns())
  if(inherits(res, 'try-error') || inherits(res2, 'try-error'))
    packageStartupMessage("Trouble registering malecns xforms.\n",
            "Ask on #code or file an issue at https://github.com/flyconnectome/malecns/issues")

  invisible()
}
