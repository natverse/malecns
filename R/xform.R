mcns_register_xforms <- function() {
  f=system.file("landmarks/malecns_fafb14_landmarks_um_v2.csv", package = 'malecns')
  malecns_fafb14 = utils::read.csv(f, header = F,
    col.names = c("Pt", "good", "X", "Y", "Z", "X1", "Y2", "Z2")
  )

  malecns_fafb14.tps=nat::tpsreg(malecns_fafb14[3:5], malecns_fafb14[6:8])
  malecns_fafb14.tpsnm=nat::tpsreg(malecns_fafb14[3:5]*1e3, malecns_fafb14[6:8]*1e3)

  nat.templatebrains::add_reglist(malecns_fafb14.tps, sample = 'malecnsum', reference = "FAFB14um")
  nat.templatebrains::add_reglist(malecns_fafb14.tpsnm, sample = 'malecns', reference = "FAFB14")
}
