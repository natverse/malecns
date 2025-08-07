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
    packageStartupMessage(
      "Trouble choosing default malecns dataset.\nTry running dr_malecns() and then ",
      "ask on #code or file an issue at\n",
      "https://github.com/flyconnectome/malecns/issues"
    )
  ds=getOption('malecns.dataset', default = 'CNS')
  packageStartupMessage("Using malecns dataset `",ds,"`.")
  if(ds=='CNS') {
    packageStartupMessage(
    "You can switch to a snapshot dataset in this R session with:\n",
    'choose_mcns_dataset("male-cns:v0.9")'
    )
  } else {
    packageStartupMessage(
      "You can switch to the production dataset in this R session with:\n",
      "choose_mcns_dataset('CNS')"
      )
  }
  packageStartupMessage(
    'Permanently switch by setting `options("malecns.dataset"=<dataset>)` in .Rprofile')

  res=try(mcns_register_xforms())
  res2=try(register_manc_malecns())
  if(inherits(res, 'try-error') || inherits(res2, 'try-error'))
    packageStartupMessage("Trouble registering malecns xforms.\n",
            "Ask on #code or file an issue at https://github.com/flyconnectome/malecns/issues")

  invisible()
}
