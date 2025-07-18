mcns_register_xforms <- function() {
  f=system.file("landmarks/malehb_fafb14_landmarks_um_v2.csv", package = 'malecns')
  malehb_fafb14 = utils::read.csv(f, header = F,
    col.names = c("Pt", "good", "X", "Y", "Z", "X1", "Y2", "Z2")
  )
  malehb_fafb14.tps=nat::tpsreg(malehb_fafb14[3:5], malehb_fafb14[6:8])
  malehb_fafb14.tpsnm=nat::tpsreg(malehb_fafb14[3:5]*1e3, malehb_fafb14[6:8]*1e3)

  f2=system.file("landmarks/maleCNS_brain_FAFB_landmarks_um.csv", package = 'malecns')
  # download.file('https://raw.githubusercontent.com/navis-org/navis-flybrains/refs/heads/main/flybrains/data/FAFB14_maleCNS_landmarks.csv', destfile = f2)
  # malecns_fafb14.old = utils::read.csv(f2, header = T)
  malecns_fafb14 = utils::read.csv(f2, header = T)

  malecns_fafb14.tps=nat::tpsreg(malecns_fafb14[1:3]/1e3, malecns_fafb14[4:6]/1e3)
  malecns_fafb14.tpsnm=nat::tpsreg(malecns_fafb14[1:3], malecns_fafb14[4:6])

  nat.templatebrains::add_reglist(malehb_fafb14.tps, sample = 'malehbum', reference = "FAFB14um")
  nat.templatebrains::add_reglist(malehb_fafb14.tpsnm, sample = 'malehb', reference = "FAFB14")
  nat.templatebrains::add_reglist(malecns_fafb14.tps, reference = 'malecnsum',
                                  sample = "FAFB14um")
  nat.templatebrains::add_reglist(malecns_fafb14.tpsnm, reference = 'malecns', sample = "FAFB14")

  f3=system.file("landmarks/maleCNS_mirror_landmarks_nm.csv", package = 'malecns')
  maleCNS_mirror_landmarks_nm <- utils::read.csv(f3)[-1]
  malecns_mirrorreg=nat::tpsreg(maleCNS_mirror_landmarks_nm[1:3], maleCNS_mirror_landmarks_nm[4:6])
  nat.templatebrains::add_reglist(malecns_mirrorreg, sample = 'malecns_mirror', reference = 'malecns')

  f4=system.file("landmarks/malehb_fafb14_landmarks_um_v2.csv", package = 'malecns')
  JRCFIB2022M_plotting_landmarks=utils::read.csv(f4, header = F)[-(1:2)]
  nat.templatebrains::add_reglist(nat::tpsreg(JRCFIB2022M_plotting_landmarks[,1:3], reference = JRCFIB2022M_plotting_landmarks[,4:6]), sample="malecns", reference = "malecnsplot")
}

# this two component registration needs special handling
register_manc_malecns <- function() {
  reg=try(nat.templatebrains::shortest_bridging_seq(reference = "MANC", sample = 'JRCFIB2022M'), silent = TRUE)
  if(inherits(reg, 'try-error'))
    return(NULL)
  ureg=unlist(reg)
  post_reg=file.path(ureg, "post_registration")
  compound_reg <- nat::reglist(post_reg, ureg, swap=c(F,F))
  nat.templatebrains::add_reglist(compound_reg, reference = 'MANC', sample = 'malecnsum')
}

halfbrain2wholebrain <- function(x, units=c("raw", "nm", "microns", "um"), warn=TRUE) {
  units=match.arg(units)
  xyz=xyzmatrix(x)
  raw_offset=4096
  raw_xlim=c(2676, 35202)
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

# register John Bogovic transforms
mcns_register_xforms2 <- function() {
  check_package_available("nat.h5reg")
  check_package_available("rappdirs")
  jdata='/Volumes/JData5/JPeople/Common/Neuroanatomy/BridgingRegistrations/malecns'
  f="CNSnm_JRC2018MumALPHA.h5"
  p=path.expand(file.path(rappdirs::user_data_dir(appname = NULL), "R/malecns", f))
  if(!file.exists(p))
    stop("Cannot find h5 file at: ", p, '. You can get it from:\n',
         jdata)
  h5p=nat.h5reg::h5reg(p)
  nat.templatebrains::add_reglist(h5p, sample = 'malecns',
                                  reference = "JRC2018M")

  f2='JRC2018U_JRC2018M.h5'
  p2=path.expand(file.path(rappdirs::user_data_dir(appname = NULL), "R/malecns", f2))
  if(!file.exists(p2))
    stop("Cannot find h5 file at: ", p2, '. You can get it from:\n',
         jdata)
  h5p=nat.h5reg::h5reg(p2)
  nat.templatebrains::add_reglist(h5p, sample = 'JRC2018U',
                                  reference = "JRC2018M")
  invisible(c(p,p2))
}

#' Mirror points in malecns space
#'
#' @param x Any objects with 3D vertices (calibrated in nm)
#' @param ... Additional arguments passed to
#'   \code{nat.templatebrains::xform_brain}
#'
#' @return The transformed object
#' @export
#' @details This mirroring could of course be improved. I used Philipp
#'   Schlegel's 69 landmarks to map malecns -> FAFB space followed by the
#'   \code{nat.jrcbrains::mirror_fafb} function to map those landmarks to the
#'   opposite side of FAFB and then brought those back to malecns.
#' @examples
#' \dontrun{
#' f3=system.file("landmarks/maleCNS_mirror_landmarks_nm.csv", package = 'malecns')
#' maleCNS_mirror_landmarks_nm <- read.csv(f3)[-1]
#' points3d(mirror_malecns(maleCNS_mirror_landmarks_nm[1:3]))
#' points3d(maleCNS_mirror_landmarks_nm[1:3], col='green')
#' # almost on top of the black points
#' points3d(maleCNS_mirror_landmarks_nm[4:6]+500, col='red')
#' }
mirror_malecns <- function(x, ...) {
  nat.templatebrains::xform_brain(x, sample = 'malecns_mirror', ref='malecns', ...)
}
