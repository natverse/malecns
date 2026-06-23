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
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
# }
# the APL
if (FALSE) { # \dontrun{
mcns_xyz2bodyid(cbind(24508, 15674, 26116)+4096)
} # }
```
