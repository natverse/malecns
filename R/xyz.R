mcns_xyz <- function(xyzin, outunits=c("nm", "microns", "um", "raw"),
                     inunits=c("raw", "nm", "microns", "um"),
                     as_character=FALSE) {
  outunits=match.arg(outunits)
  inunits=match.arg(inunits)
  if(is.character(xyzin))
    xyzin <- neuprint_simplify_xyz(xyzin)
  # special case NA inputs so that xyzmatrix works ok
  # maybe we should do this in nat ...
  if(is.vector(xyzin) && any(is.na(xyzin)))
    xyzin[is.na(xyzin)]=""
  xyz=xyzmatrix(xyzin)
  if(isTRUE(outunits==inunits)) {
    if(as_character) return(nat::xyzmatrix2str(xyz))
    else return(xyz)
  }
  if(inunits=='nm')
      xyz <- xyz/8
  else if(inunits %in% c("um", "microns"))
    xyz <- xyz/(8/1000)

  if(outunits=='nm')
    xyz <- xyz*8
  else if(outunits %in% c("um", "microns"))
    xyz <- xyz*8/1000
  if(as_character) nat::xyzmatrix2str(xyz) else xyz
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
