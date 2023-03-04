mcns_xyz <- function(xyzin, outunits=c("nm", "microns", "um", "raw"),
                     inunits=c("raw", "nm", "microns", "um")) {
  outunits=match.arg(outunits)
  inunits=match.arg(inunits)
  if(is.character(xyzin))
    xyzin <- neuprint_simplify_xyz(xyzin)
  xyz=xyzmatrix(xyzin)
  if(isTRUE(outunits==inunits))
    return(xyz)
  if(inunits=='nm')
      xyz <- xyz/8
  else if(inunits %in% c("um", "microns"))
    xyz <- xyz/(8/1000)

  if(outunits=='nm')
    xyz <- xyz*8
  else if(outunits %in% c("um", "microns"))
    xyz <- xyz*8/1000
  xyz
}

neuprint_simplify_xyz <- function(x) {
  longform=grepl("^list", x)
  if(any(longform)) {
    x[longform]=sub("list\\(([0-9 ,]+)\\).*", "\\1", x[longform])
    stillbad=grepl("^list", x[longform])
    if(any(stillbad)) {
      warning("failed to parse ", sum(stillbad), " locations. Setting to NA.")
      x[longform][stillbad]=NA
    }
  }
  x
}
