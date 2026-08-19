# Return neurojson body annotations via the Clio interface

Return neurojson body annotations via the Clio interface

## Usage

``` r
mcns_body_annotations(
  ids = NULL,
  query = NULL,
  json = FALSE,
  config = NULL,
  show.extra = c("none", "user", "time", "all"),
  cache = FALSE,
  test = FALSE,
  ...
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)

- query:

  A json query string (see examples or documentation) or an R list with
  field names as elements.

- json:

  Whether to return unparsed JSON rather than an R list (default
  `FALSE`).

- config:

  An optional httr::config (expert use only, must include a bearer
  token)

- show.extra:

  Extra columns to show with user/timestamp information.

- cache:

  Whether to cache the result of this call for 5 minutes.

- test:

  Whether to unset the clio-store test server (default `FALSE`)

- ...:

  Additional arguments passed to
  [`pblapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

## Value

A data.frame with metadata

## Details

In comparison with
[`mcns_dvid_annotations`](https://natverse.org/malecns/reference/mcns_dvid_annotations.md),
this allows queries for specific bodies. In comparison with
[`mcns_neuprint_meta`](https://natverse.org/malecns/reference/mcns_neuprint_meta.md),
it provides access to up to the second annotations; it is also presently
faster than these other two calls. Compared with
[`mcns_neuprint_meta`](https://natverse.org/malecns/reference/mcns_neuprint_meta.md),
it does not produce a stable set of columns, only returning those that
exist for the given query ids.

## See also

Other annotations:
[`mcns_dvid_annotations()`](https://natverse.org/malecns/reference/mcns_dvid_annotations.md),
[`mcns_neuprint_meta()`](https://natverse.org/malecns/reference/mcns_neuprint_meta.md),
[`mcns_soma_side()`](https://natverse.org/malecns/reference/mcns_soma_side.md)

## Examples

``` r
# \donttest{
mcns_body_annotations("AOTU019")
#>   birthtime bodyid celltype_predicted_nt celltype_predicted_nt_confidence
#> 1     early  10005                  gaba                        0.8305035
#> 2     early  10070                  gaba                        0.8305035
#>   celltype_total_nt_predictions consensus_nt flywire_type group hemibrain_type
#> 1                          5673         gaba      AOTU019 10005        AOTU019
#> 2                          5673         gaba      AOTU019 10005        AOTU019
#>    instance        itolee_hl predicted_nt predicted_nt_confidence soma_side
#> 1 AOTU019_R putative_primary         gaba               0.8350762         R
#> 2 AOTU019_L putative_primary         gaba               0.8259292         L
#>           status   superclass total_nt_predictions    type       vfb_id  auto
#> 1 Roughly traced cb_intrinsic                 2837 AOTU019 VFB_jrmc3hk6 FALSE
#> 2 Roughly traced cb_intrinsic                 2836 AOTU019 VFB_jrmc3hk5 FALSE
# }
if (FALSE) { # \dontrun{
mcns.superclass=mcns_body_annotations(query=list(superclass="exists/1"))
mcns.superclass %>%
  count(superclass)
} # }
```
