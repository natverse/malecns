# Fetch neuprint metadata for malecns neurons

Fetch neuprint metadata for malecns neurons

## Usage

``` r
mcns_neuprint_meta(
  ids = NULL,
  conn = mcns_neuprint(),
  roiInfo = FALSE,
  simplify.xyz = TRUE,
  cache = NA,
  ...
)
```

## Arguments

- ids:

  body ids. When missing all bodies known to DVID are returned.

- conn:

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.html)
  to ensure that query is against the VNC dataset.

- roiInfo:

  whether to include the `roiInfo` field detailing synapse numbers in
  different locations. This is omitted by default as it is returned as a
  character vector of unprocessed JSON.

- simplify.xyz:

  Whether to simplify columns containing XYZ locations to a simple
  `"x,y,z"` format rather than a longer form referencing a schema at
  `spatialreference.org`. Defaults to `TRUE`.

- cache:

  whether to cache the query. When `cache=NA` (the default) queries are
  cached for neuprint snapshot versions (but not production datasets).
  See details.

- ...:

  Additional arguments passed to `neuprint_get_meta`

## Value

A data.frame with one row for each (unique) input id and NAs for all
columns except bodyid when neuprint holds no metadata.

## Details

in contrast to
[`malevnc::manc_neuprint_meta`](https://natverse.org/malevnc/reference/manc_neuprint_meta.html)
we leave bodyids as numeric (doubles) since flyem now guarantee them to
be less than 2^53 i.e. within the range in which doubles can exactly
represent numeric ids.

## See also

Other annotations:
[`mcns_body_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_body_annotations.md),
[`mcns_dvid_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_dvid_annotations.md),
[`mcns_soma_side()`](https://flyconnectome.github.io/malecns/reference/mcns_soma_side.md)

## Examples

``` r
# \donttest{
library(dplyr)
# fetch metatada for all bodies in neuprint
mnm=mcns_neuprint_meta()
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
# fetch metadata for all bodies with a somaLocation
mnm.soma=mcns_neuprint_meta("where:exists(n.somaLocation)")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.

# type or instance present
mnm.ti <- mcns_neuprint_meta('where:exists(n.type) OR exists(n.instance)')
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.

# neurons without a superclass but quite a few synapses
mnm.nc=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.synweight>2000")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
mnm.nc %>% arrange(desc(synweight))
#> Error: object 'mnm.nc' not found
# }
library(dplyr)
# Which neurons don't have a superclass, but possibly should
mnm.nsc=mcns_neuprint_meta("where:NOT exists(n.superclass)")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
mnm.nsc %>% count(statusLabel)
#> Error: object 'mnm.nsc' not found

# neurons that are RT or PRT should probably have a superclass
mnm.nscprt=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.statusLabel CONTAINS 'Roughly'")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
mnm.nscprt %>% count()
#> Error: object 'mnm.nscprt' not found
```
