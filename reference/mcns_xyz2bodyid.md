# Map XYZ locations to bodyids for the male cns dataset

Map XYZ locations to bodyids for the male cns dataset

## Usage

``` r
mcns_xyz2bodyid(
  xyz,
  units = c("raw", "nm", "microns", "um"),
  node = "neutu",
  cache = FALSE
)
```

## Arguments

- xyz:

  xyz location (by default in raw malecns pixels)

- units:

  The Optional units of the incoming 3D positions. Defaults to *raw*.

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html).
  The default is to return the current active (unlocked) node being used
  through neutu.

- cache:

  Whether to cache the result of this call for 5 minutes.

## Value

A character vector of body ids (0 is missing somas / missing locations)

## Examples

``` r
# \donttest{
# find the bodyids corresponding to set of soma positions
mcns_xyz2bodyid(mcns_somapos("/LAL04[12]", units='raw'), units='raw')
#> [1]  34187 512750
# }
# the APL
if (FALSE) { # \dontrun{
mcns_xyz2bodyid(cbind(24508, 15674, 26116)+4096)
} # }
```
