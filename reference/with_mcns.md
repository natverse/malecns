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
# this body was typed after the v1.0 snapshot
with_mcns(mcns_body_annotations(194965), dataset = "male-cns:v1.0")
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
with_mcns(mcns_body_annotations(194965), dataset = "CNS")
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
# }
```
