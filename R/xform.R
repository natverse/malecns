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

  f4=system.file("landmarks/JRCFIB2022M_plotting_landmarks.csv", package = 'malecns')
  JRCFIB2022M_plotting_landmarks=utils::read.csv(f4, header = T)
  nat.templatebrains::add_reglist(nat::tpsreg(JRCFIB2022M_plotting_landmarks[,1:3], reference = JRCFIB2022M_plotting_landmarks[,4:6]), sample="malecns", reference = "malecnsplot")

  nat.templatebrains::add_reglist(nat::tpsreg(JRCFIB2022M_plotting_landmarks[,1:3]/1e3, reference = JRCFIB2022M_plotting_landmarks[,4:6]/1e3), sample="malecnsum", reference = "malecnsumplot")
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

#' Download and register h5 bridging registrations for malecns
#'
#' @description \code{mcns_register_xforms2} registers Saalfeld lab h5
#'   deformation fields (JRCFIB2022M, JRC2018M, JRC2018U) via
#'   \code{\link[nat.jrcbrains]{register_saalfeldlab_registrations}} and adds a
#'   malecns (nm) to JRCFIB2022M (microns) scaling alias. This enables the
#'   bridging path: malecns -> JRCFIB2022M -> JRC2018M -> JRC2018U. Must be
#'   called once per session.
#'
#' @export
#' @examples
#' \dontrun{
#' # first time only
#' mcns_download_xforms2()
#' # then once per session
#' mcns_register_xforms2()
#' xform_brain(cbind(100000, 100000, 50000), sample='malecns', reference='JRC2018U')
#' }
mcns_register_xforms2 <- function() {
  check_package_available("nat.jrcbrains")
  if(is.null(getOption('nat.jrcbrains.regfolder'))) {
    message("Set options(nat.jrcbrains.regfolder=...) and run mcns_download_xforms2() ",
            "for h5 registration support.")
    return(invisible(NULL))
  }
  nat.jrcbrains::register_saalfeldlab_registrations()

  # malecns (nm) <-> JRCFIB2022M (microns) alias
  nat.templatebrains::add_reglist(
    nat::reglist(diag(c(1/1e3, 1/1e3, 1/1e3, 1))),
    reference = 'JRCFIB2022M', sample = 'malecns')
}

#' @description \code{mcns_download_xforms2} downloads JRCFIB2022M_JRC2018M and
#'   JRC2018U_JRC2018M h5 deformation fields (~3 GB total) from figshare. Only
#'   needs to be run once; the download is resumable and will skip files already
#'   present. Calls \code{mcns_register_xforms2} automatically after
#'   downloading.
#' @rdname mcns_register_xforms2
#' @export
mcns_download_xforms2 <- function() {
  check_package_available("nat.jrcbrains")
  nat.jrcbrains::download_saalfeldlab_registrations(
    filenames = c("JRCFIB2022M_JRC2018M.h5", "JRC2018U_JRC2018M.h5"),
    multi = TRUE
  )
  mcns_register_xforms2()
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
