mcns_register_xforms <- function() {
  f=system.file("landmarks/malecns_fafb14_landmarks_um_v2.csv", package = 'malecns')
  malehb_fafb14 = utils::read.csv(f, header = F,
    col.names = c("Pt", "good", "X", "Y", "Z", "X1", "Y2", "Z2")
  )
  malehb_fafb14.tps=nat::tpsreg(malehb_fafb14[3:5], malehb_fafb14[6:8])
  malehb_fafb14.tpsnm=nat::tpsreg(malehb_fafb14[3:5]*1e3, malehb_fafb14[6:8]*1e3)

  malecns_fafb14 <- malehb_fafb14
  malecns_fafb14[3:5] <- halfbrain2wholebrain(malecns_fafb14[3:5], 'microns', warn=FALSE)

  malecns_fafb14.tps=nat::tpsreg(malecns_fafb14[3:5], malecns_fafb14[6:8])
  malecns_fafb14.tpsnm=nat::tpsreg(malecns_fafb14[3:5]*1e3, malecns_fafb14[6:8]*1e3)

  nat.templatebrains::add_reglist(malehb_fafb14.tps, sample = 'malehbum', reference = "FAFB14um")
  nat.templatebrains::add_reglist(malecns_fafb14.tpsnm, sample = 'malehb', reference = "FAFB14")
  nat.templatebrains::add_reglist(malecns_fafb14.tps, sample = 'malecnsum', reference = "FAFB14um")
  nat.templatebrains::add_reglist(malecns_fafb14.tpsnm, sample = 'malecns', reference = "FAFB14")
}

halfbrain2wholebrain <- function(x, units=c("raw", "nm", "microns", "um"), warn=TRUE) {
  units=match.arg(units)
  xyz=xyzmatrix(x)
  raw_offset=4096
  raw_xlim=c(6772, 35202)
  offset=switch(units, raw=raw_offset, nm=raw_offset*8, raw_offset*8/1000)
  xlim=switch(units, raw=raw_xlim, nm=raw_xlim*8, raw_xlim*8/1000)
  nbad=sum(xyz[1,]<xlim[1] | xyz[1,]>=xlim[2], na.rm = T)
  if(nbad>0 && warn)
    warning(nbad, " points are outside the region for which a simple translation is guaranteed!")
  xyz=xyz+offset
  xyz
  # xyzmatrix<- doesn't work for a 3 vector
  if(is.vector(x) && !is.list(x) && length(x)==3 && is.numeric(x)) c(xyz) else {
    nat::xyzmatrix(x) <- xyz
    x
  }
}
