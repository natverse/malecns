# Connectivity query for CNS neurons

Connectivity query for CNS neurons

## Usage

``` r
mcns_connection_table(
  ids,
  partners = c("inputs", "outputs"),
  moredetails = c("group", "superclass", "somaSide"),
  summary = FALSE,
  threshold = 1L,
  roi = NULL,
  by.roi = FALSE,
  conn = mcns_neuprint(),
  ...
)
```

## Arguments

- ids:

  A set of body ids (see `manc_ids` for a range of ways to specify
  these).

- partners:

  Either inputs or outputs. Redundant with `prepost`, but probably
  clearer.

- moredetails:

  Either a logical (to add all fields when `TRUE`) or a character vector
  naming additional fields returned by
  [`mcns_neuprint_meta`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md)
  that will be added to the results data.frame.

- summary:

  Whether to summarise results per partner when giving multiple query
  neurons

- threshold:

  Only return partners \>= to an integer value. Default of 1 returns all
  partners. This threshold will be applied to the ROI weight when the
  `roi` argument is specified, otherwise to the whole neuron.

- roi:

  a single ROI. Use `neuprint_ROIs` to see what is available.

- by.roi:

  logical, whether or not to break neurons' connectivity down by region
  of interest (ROI)

- conn:

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.html)
  to ensure that query is against the VNC dataset.

- ...:

  additional arguments passed to `neuprint_connection_table`

## Value

A data.frame

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:nat’:
#> 
#>     intersect, setdiff, union
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
mcns_connection_table('DNa02', partners = 'out') %>% head()
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
mcns_connection_table('DNa02', partners = 'out', summary = TRUE) %>% head()
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
# return weight of outputs in the brain specifically (see ROIweight column)
mcns_connection_table('DNa02', partners = 'out', roi='CentralBrain') %>% head()
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.

# \donttest{
joffrey.id=mcns_xyz2bodyid(cbind(24590, 13816, 26102)+4096, node = 'neuprint')
joffrey.us=mcns_connection_table(joffrey.id, partners = 'in')
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
joffrey.uss=mcns_connection_table(joffrey.id, partners = 'in', summary=TRUE)
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
# }
if (FALSE) { # \dontrun{
# open top 10 partners in neuroglancer,
# NB segmentation / meshes to match neuprint
mcns_scene(joffrey.uss$partner[1:10], open = TRUE, node='neuprint')
} # }
```
