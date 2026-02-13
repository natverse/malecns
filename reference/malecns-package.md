# malecns: Access to the latest 'Janelia FlyEM' datasets

Provides access to the latest 'Janelia FlyEM' datasets by providing a
thin wrapper around the 'malevnc' package.

## Package Options

There is just one package option:

- `malecns.dataset` This is to used to keep track of the active malecns
  dataset.

This is now of more than internal use as you can use it run your code
against the production dataset (still the default) or a snapshot. There
are essentially three main ways to do this, from safest/least intrusive
to most intrusive. I recommend using option 1 for one-off queries and
option 2 if you want to run a series of commands within a script.

1.  Use
    [`with_mcns`](https://flyconnectome.github.io/malecns/reference/with_mcns.md)`(dataset="<name of dataset>")`
    to run a piece of code without switching the default malecns
    dataset.

2.  Use the
    [`choose_mcns_dataset`](https://flyconnectome.github.io/malecns/reference/choose_mcns_dataset.md)
    to choose a default malecns dataset for the rest of the session (or
    until you change it again).

3.  Expert users may also wish to set the `malecns.dataset` option
    directly in their `.Rprofile` file to set a permanent default.

## Bridging registrations

Philipp Schlegel has made bridging registrations using bigwarp and the
presynapse predictions for the male half brain and male cns. See
[slack](https://flyconnectome.slack.com/archives/C02F6UCCU6B/p1652945492746389?thread_ts=1652423869.552919&cid=C02F6UCCU6B)
for details. And an [an updated
registration](https://flyconnectome.slack.com/archives/C02F6UCCU6B/p1747641901448259).

There is a special space "malecnsplot" which brings the brain and VNC
into a more aligned orientation. See examples below and [slack
message](https://flyconnectome.slack.com/archives/C02F6UCCU6B/p1747645164139839).

## See also

Useful links:

- <https://github.com/flyconnectome/malecns>

- <https://flyconnectome.github.io/malecns/>

- Report bugs at <https://github.com/flyconnectome/malecns/issues>

Other malecns-package:
[`choose_mcns_dataset()`](https://flyconnectome.github.io/malecns/reference/choose_mcns_dataset.md),
[`dr_malecns()`](https://flyconnectome.github.io/malecns/reference/dr_malecns.md),
[`with_mcns()`](https://flyconnectome.github.io/malecns/reference/with_mcns.md)

## Author

**Maintainer**: Gregory Jefferis <jefferis@gmail.com>
([ORCID](https://orcid.org/0000-0002-0587-9355))

## Examples

``` r
# \donttest{
options()[grepl("^malecns", names(options()))]
#> $malecns.dataset
#> [1] "male-cns:v0.9"
#> 
# }
if (FALSE) { # \dontrun{
dr_malecns()

# run expression without changing default malecns dataset
with_mcns(mcns_body_annotations(194965), dataset = "male-cns:v0.9")

# run expression(s) after changing default malecns dataset
choose_mcns_dataset("male-cns:v0.9")
mcns_body_annotations(194965)
choose_mcns_dataset("CNS")
mcns_body_annotations(194965)

# edit .Rprofile to set package options (expert use)
usethis::edit_r_profile()
} # }

# \donttest{
library(nat.templatebrains)
xform_brain(cbind(443344, 225172, 44920), sample = 'FAFB14',
  reference = 'malecns')
#>        [,1]     [,2]     [,3]
#> [1,] 304165 212161.9 117656.2

mcflm=system.file("landmarks/maleCNS_brain_FAFB_landmarks_um.csv", package = 'malecns')
mcflm=read.csv(mcflm)
head(mcflm)
#>   fafb14_x fafb14_y fafb14_z   mcns_x   mcns_y   mcns_z
#> 1   171253   215785   160000 43865.44 216410.1 223953.9
#> 2   171124   216806   200000 35880.51 218648.4 261855.2
#> 3   171442   255842   160000 44895.59 266018.3 229221.7
#> 4   171450   254401   200000 35704.02 268698.4 264996.7
#> 5   171976   255973   240000 25425.57 270842.7 297795.0
#> 6   172638   295765   160000 47433.39 316081.2 235692.3
if (FALSE) { # \dontrun{
library(nat.jrcbrains)
da1.hb=neuprintr::neuprint_read_neurons('/DA1.*lPN',
  conn=neuprintr::neuprint_login(server='https://neuprint.janelia.org',
    dataset = 'hemibrain:v1.2.1'))
# nb hemibrain neurons comes in 8nm raw voxel coordinates not microns
da1.hb.mcns=xform_brain(da1.hb*(8/1000), sample='JRCFIB2018F', reference='malecns')
# read in a male cns DA1 neuron
da1.1=read_mcns_meshes(11996, units='nm')
nclear3d()
plot3d(da1.hb.mcns, col='cyan')
plot3d(da1.1, col='red')
plot3d(malecns.surf, alpha=.1)

# compare plotting orientation with original templates
plot3d(malecns_shell.surf)
plot3d(malecnsvnc_shell.surf)
plot3d(xform_brain(malecnsvnc_shell.surf, sample='malecns', ref='malecnsplot'), col='red')
plot3d(xform_brain(malecns_shell.surf, sample='malecns', ref='malecnsplot'), col='red')

} # }
# }
```
