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
  [`pbapply::pblapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

## Value

A data.frame with metadata

## Details

In comparison with
[`mcns_dvid_annotations`](https://flyconnectome.github.io/malecns/reference/mcns_dvid_annotations.md),
this allows queries for specific bodies. In comparison with
[`mcns_neuprint_meta`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md),
it provides access to up to the second annotations; it is also presently
faster than these other two calls. Compared with
[`mcns_neuprint_meta`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md),
it does not produce a stable set of columns, only returning those that
exist for the given query ids.

## See also

Other annotations:
[`mcns_dvid_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_dvid_annotations.md),
[`mcns_neuprint_meta()`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md),
[`mcns_soma_side()`](https://flyconnectome.github.io/malecns/reference/mcns_soma_side.md)

## Examples

``` r
# \donttest{
mcns_body_annotations("AOTU019")
#> Error in clio_auth(): Clio/Google auth failure. Do you have access rights to VNC clio?
#> Try specifying the email linked to clio in a call to `clio_auth` or setting `options(malevnc.clio_email)`!
# }
if (FALSE) { # \dontrun{
mcns.superclass=mcns_body_annotations(query=list(superclass="exists/1"))
mcns.superclass %>%
  count(superclass)
} # }
```
