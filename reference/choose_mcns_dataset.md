# Switch the default dataset for `mcns_*` functions

`choose_mcns_dataset` This sets the default dataset used by all `mcns_*`
functions. It is the recommended way to access malecns snapshots. Unlike
[`choose_mcns`](https://flyconnectome.github.io/malecns/reference/with_mcns.md)
it does *not* permanently change the default dataset used when callers
use functions from the `malevnc` package (such as
[`malevnc::manc_xyz2bodyid`](https://natverse.org/malevnc/reference/manc_xyz2bodyid.html))
directly.

## Usage

``` r
choose_mcns_dataset(dataset = "male-cns:v0.9")
```

## Arguments

- dataset:

  The name of the dataset as reported in Clio e.g. CNS, etc

## See also

Other malecns-package:
[`dr_malecns()`](https://flyconnectome.github.io/malecns/reference/dr_malecns.md),
[`malecns-package`](https://flyconnectome.github.io/malecns/reference/malecns-package.md),
[`with_mcns()`](https://flyconnectome.github.io/malecns/reference/with_mcns.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# use the v0.9 snapshot for the rest of this R session
choose_mcns_dataset("male-cns:v0.9")
# use production for the rest of this R session
choose_mcns_dataset("CNS")
} # }
```
