## code to prepare `malecnsshell.surf` dataset goes here

withr::with_dir('data-raw/', {
brain_shell=malevnc:::decode_neuroglancer_mesh(readBin('brain_shell.ngmesh',what=raw(), n=file.size('brain_shell.ngmesh')))
})

brain_shell20k=Rvcg::vcgQEdecim(brain_shell, tarface = 20e3)
malecns_shell.surf=as.hxsurf(brain_shell20k)
usethis::use_data(malecns_shell.surf, overwrite = TRUE)


withr::with_dir('data-raw/', {
  curl::curl_download('https://www.googleapis.com/storage/v1/b/flyem-cns-roi-7c971aa681da83f9a074a1f0e8ef60f4/o/vnc-shell%2Fmesh%2Fvnc-shell.ngmesh?alt=media&neuroglancerOrigin=https%3A%2F%2Fclio-ng.janelia.org', destfile = 'vnc-shell.ngmesh')
})

# > tools::md5sum(dir('data-raw', pattern = 'ngmesh', full.names = T))
# data-raw/brain_shell.ngmesh          data-raw/vnc-shell.ngmesh
# "86e54d92c5c2cfe8c890f587cae60a15" "170c3f4b27fed2bfaa62e000bbc38a62"

withr::with_dir('data-raw/', {
  vnc_shell=malevnc:::decode_neuroglancer_mesh(readBin('vnc-shell.ngmesh',what=raw(), n=file.size('vnc-shell.ngmesh')))
})

vnc_shell20k=Rvcg::vcgQEdecim(vnc_shell, tarface = 20e3)
malecnsvnc_shell.surf=as.hxsurf(vnc_shell20k)
usethis::use_data(malecnsvnc_shell.surf, overwrite = TRUE)

# another approach ... target edge length, but this had more triangles
# vnc_shell20k.el=Rvcg::vcgQEdecim(vnc_shell, edgeLength = 5e3)
# vnc_shell20k.el
# wire3d(vnc_shell20k.el, col='red')

withr::with_dir('data-raw/', {
  curl::curl_download('https://www.googleapis.com/storage/v1/b/flyem-cns-roi-7c971aa681da83f9a074a1f0e8ef60f4/o/vnc-neuropil-shell%2Fmesh%2Fvnc-neuropil-shell.ngmesh?alt=media&neuroglancerOrigin=https%3A%2F%2Fclio.janelia.org', destfile = 'vnc-neuropil-shell.ngmesh')
})

withr::with_dir('data-raw/', {
  vnc_neuropil_shell=malevnc:::decode_neuroglancer_mesh(readBin('vnc-neuropil-shell.ngmesh',what=raw(), n=file.size('vnc-neuropil-shell.ngmesh')))
})
vnc_neuropil20k=Rvcg::vcgQEdecim(vnc_neuropil_shell, tarface = 20e3)
malecnsvnc_neuropil.surf=as.hxsurf(vnc_neuropil20k)
usethis::use_data(malecnsvnc_neuropil.surf, overwrite = TRUE)
