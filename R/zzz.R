.onLoad <- function(libname, pkgname) {

  op.malecns <- list(
    malecns.dataset="CNS"
  )
  op<-options()
  toset <- !(names(op.malecns) %in% names(op))
  if(any(toset)) options(op.malecns[toset])
  if(!requireNamespace('malevnc', quietly = T))
    packageStartupMessage("Unable to load malevnc package.\nTry running dr_malecns() and then ",
          "ask on #code or file an issue at\n",
          "https://github.com/flyconnectome/malecns/issues")
  else {
    res=try(choose_mcns(), silent = F)
    if(inherits(res, 'try-error'))
      packageStartupMessage("Trouble choosing default malecns dataset.\nTry running dr_malecns() and then ",
              "ask on #code or file an issue at\n",
              "https://github.com/flyconnectome/malecns/issues")
  }

  res=try(mcns_register_xforms())
  if(inherits(res, 'try-error'))
    packageStartupMessage("Trouble registering malencs xforms.\n",
            "Ask on #code or file an issue at https://github.com/flyconnectome/malecns/issues")
  invisible()
}
