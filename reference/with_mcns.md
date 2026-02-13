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
  dataset = getOption("malecns.dataset", default = "male-cns:v0.9")
)

choose_mcns(
  dataset = getOption("malecns.dataset", default = "male-cns:v0.9"),
  set = TRUE,
  use_clio = NA
)
```

## Arguments

- expr:

  An expression involving malecns/malevnc functions to evaluate with the
  specified autosegmentation. .

- dataset:

  The name of the dataset as reported in Clio e.g. `CNS`,
  `male-cns:v0.9` etc.

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
[`choose_mcns_dataset()`](https://flyconnectome.github.io/malecns/reference/choose_mcns_dataset.md),
[`dr_malecns()`](https://flyconnectome.github.io/malecns/reference/dr_malecns.md),
[`malecns-package`](https://flyconnectome.github.io/malecns/reference/malecns-package.md)

## Examples

``` r
if (FALSE) { # \dontrun{
with_mcns(malevnc::manc_dvid_node(type = 'clio'))
} # }
# \donttest{
# This should work for both clio and neuprint calls, here clio:
# this body was typed after the v0.9 snapshot
with_mcns(mcns_body_annotations(194965), dataset = "male-cns:v0.9")
#>   bodyid celltype_predicted_nt celltype_predicted_nt_confidence
#> 1 194965         acetylcholine                         0.952291
#>   celltype_total_nt_predictions  consensus_nt flywire_type group instance
#> 1                         22356 acetylcholine         Sm01 29457    Cm2_L
#>    predicted_nt predicted_nt_confidence soma_side   status   superclass
#> 1 acetylcholine               0.9597166         L Reviewed ol_intrinsic
#>   total_nt_predictions type  auto
#> 1                   66  Cm2 FALSE
with_mcns(mcns_body_annotations(194965), dataset = "CNS")
#> switching CNS dataset from `male-cns:v0.9` to `CNS`
#>   bodyid celltype_predicted_nt celltype_predicted_nt_confidence
#> 1 194965         acetylcholine                        0.9478553
#>   celltype_total_nt_predictions  consensus_nt flywire_type group instance
#> 1                         22356 acetylcholine         Sm01 29457    Cm2_L
#>    predicted_nt predicted_nt_confidence soma_side   status   superclass
#> 1 acetylcholine               0.9552417         L Reviewed ol_intrinsic
#>   total_nt_predictions type  user  auto
#> 1                   66  Cm2 bergs FALSE
# }
```
