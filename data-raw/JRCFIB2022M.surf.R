withr::with_dir('data-raw/', {
  # convert to nm
  x=read.neurons('JRCFIB2022M.ply')[[1]]*8
})

JRCFIB2022M.surf=as.hxsurf(x)
attr(JRCFIB2022M.surf, 'units')='nm'
usethis::use_data(JRCFIB2022M.surf, overwrite = TRUE, version = 2)

malecns.surf <- JRCFIB2022M.surf
usethis::use_data(malecns.surf, overwrite = TRUE, version = 2)

