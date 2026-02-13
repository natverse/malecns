# Download and register h5 bridging registrations for malecns

`mcns_register_xforms2` registers Saalfeld lab h5 deformation fields
(JRCFIB2022M, JRC2018M, JRC2018U) via
[`register_saalfeldlab_registrations`](https://rdrr.io/pkg/nat.jrcbrains/man/register_saalfeldlab_registrations.html)
and adds a malecns (nm) to JRCFIB2022M (microns) scaling alias. This
enables the bridging path: malecns -\> JRCFIB2022M -\> JRC2018M -\>
JRC2018U. Must be called once per session.

`mcns_download_xforms2` downloads JRCFIB2022M_JRC2018M and
JRC2018U_JRC2018M h5 deformation fields (~3 GB total) from figshare.
Only needs to be run once; the download is resumable and will skip files
already present. Calls `mcns_register_xforms2` automatically after
downloading.

## Usage

``` r
mcns_register_xforms2()

mcns_download_xforms2()
```

## Examples

``` r
if (FALSE) { # \dontrun{
# first time only
mcns_download_xforms2()
# then once per session
mcns_register_xforms2()
xform_brain(cbind(100000, 100000, 50000), sample='malecns', reference='JRC2018U')
} # }
```
