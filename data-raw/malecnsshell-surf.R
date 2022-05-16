## code to prepare `malecnsshell.surf` dataset goes here

withr::with_dir('data-raw/', {
brain_shell=malevnc:::decode_neuroglancer_mesh(readBin('brain_shell.ngmesh',what=raw(), n=file.size('brain_shell.ngmesh')))
})

brain_shell20k=Rvcg::vcgQEdecim(brain_shell, tarface = 20e3)
malecns_shell.surf=as.hxsurf(brain_shell20k)
usethis::use_data(malecns_shell.surf, overwrite = TRUE)
