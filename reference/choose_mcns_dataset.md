# Switch the default dataset for `mcns_*` functions

`choose_mcns_dataset` This sets the default dataset used by all `mcns_*`
functions. It is the recommended way to access malecns snapshots. Unlike
[`choose_mcns`](https://natverse.org/malecns/reference/with_mcns.md) it
does *not* permanently change the default dataset used when callers use
functions from the `malevnc` package (such as
[`malevnc::manc_xyz2bodyid`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html))
directly.

## Usage

``` r
choose_mcns_dataset(dataset = "male-cns:v1.0")
```

## Arguments

- dataset:

  The name of the dataset. Defaults to the public `male-cns:v1.0`
  release, but e.g. `CNS` accesses the private production version used
  to collect any fixes.

## See also

Other malecns-package:
[`dr_malecns()`](https://natverse.org/malecns/reference/dr_malecns.md),
[`malecns-package`](https://natverse.org/malecns/reference/malecns-package.md),
[`with_mcns()`](https://natverse.org/malecns/reference/with_mcns.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# use the v1.0 snapshot for the rest of this R session
choose_mcns_dataset("male-cns:v1.0")
# use production for the rest of this R session
choose_mcns_dataset("CNS")
} # }
```
