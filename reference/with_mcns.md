# Evaluate an expression after temporarily setting malevnc options

`malecns` is a thin wrapper around `malevnc`. This function temporarily
changes the server/dataset options for the malevnc while running your
expression.

`choose_mcns` swaps out the male vnc dataset for the male cns. This
means that all functions from the `malevnc` package should target the
male cns instead. It is recommended that you use the `with_mcns`
function to do this temporarily unless you have no intention of using
the male vnc dataset. *To switch the default malecns dataset please see
`choose_mcns_dataset`*.

## Usage

``` r
with_mcns(
  expr,
  dataset = getOption("malecns.dataset", default = "male-cns:v1.0")
)

choose_mcns(
  dataset = getOption("malecns.dataset", default = "male-cns:v1.0"),
  set = TRUE,
  use_clio = NA
)
```

## Arguments

- expr:

  An expression involving malecns/malevnc functions to evaluate with the
  specified autosegmentation. .

- dataset:

  The name of the dataset, e.g. `male-cns:v1.0`, `male-cns:v0.9`, or
  `CNS`.

- set:

  Whether to set the relevant package options or just to return a list
  of the required options.

- use_clio:

  Whether to use clio to list datasets (expert use only; default of
  `use_clio=NA` should do the right thing).

## Details

Note that as of 11 Aug 2025 it also switches out the active dataset for
the malecns package if you specify something different using the
`dataset` argument. This is probably what people always expected and
allows you to easily run the same expression for e.g. production vs
snapshot malecns datasets.

## See also

Other malecns-package:
[`choose_mcns_dataset()`](https://natverse.org/malecns/reference/choose_mcns_dataset.md),
[`dr_malecns()`](https://natverse.org/malecns/reference/dr_malecns.md),
[`malecns-package`](https://natverse.org/malecns/reference/malecns-package.md)

## Examples

``` r
if (FALSE) { # \dontrun{
with_mcns(malevnc::manc_dvid_node(type = 'clio'))
} # }
# \donttest{
# This should work for both clio and neuprint calls, here clio:
# this body was typed after the v1.0 snapshot
with_mcns(mcns_body_annotations(194965), dataset = "male-cns:v1.0")
#>   bodyid celltype_predicted_nt celltype_predicted_nt_confidence
#> 1 194965         acetylcholine                        0.9525882
#>   celltype_total_nt_predictions  consensus_nt flywire_type group instance
#> 1                         22356 acetylcholine         Sm01 29457    Cm2_L
#>    predicted_nt predicted_nt_confidence soma_side   status   superclass
#> 1 acetylcholine               0.9600185         L Reviewed ol_intrinsic
#>   total_nt_predictions type  user       vfb_id  auto
#> 1                   66  Cm2 bergs VFB_jrmc35xh FALSE
with_mcns(mcns_body_annotations(194965), dataset = "CNS")
#> switching CNS dataset from `male-cns:v1.0` to `CNS`
#>   bodyid celltype_predicted_nt celltype_predicted_nt_confidence
#> 1 194965         acetylcholine                        0.9525913
#>   celltype_total_nt_predictions  consensus_nt flywire_type group instance
#> 1                         22356 acetylcholine         Sm01 29457    Cm2_L
#>    predicted_nt predicted_nt_confidence soma_side   status   superclass
#> 1 acetylcholine               0.9600217         L Reviewed ol_intrinsic
#>   total_nt_predictions type  user       vfb_id  auto
#> 1                   66  Cm2 bergs VFB_jrmc35xh FALSE
# }
```
