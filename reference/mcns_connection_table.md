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
#> Warning: NAs introduced by coercion to integer64 range
#>   bodyid partner prepost weight       name     type  group        superclass
#> 1 523769  800561       1    209 IN08A006_L IN08A006 800561     vnc_intrinsic
#> 2  10360  801437       1    195 IN08A006_R IN08A006 800561     vnc_intrinsic
#> 3  10360   11158       1    168  DNge026_R  DNge026  11158 descending_neuron
#> 4 523769  800511       1    156 IN08A006_L IN08A006 800511     vnc_intrinsic
#> 5  10360  800687       1    150 IN19A003_R IN19A003 800461     vnc_intrinsic
#> 6  10360  524150       1    150    PS137_R    PS137  13165      cb_intrinsic
#>   somaSide
#> 1        L
#> 2        R
#> 3        R
#> 4        L
#> 5        R
#> 6        R
mcns_connection_table('DNa02', partners = 'out', summary = TRUE) %>% head()
#> Warning: NAs introduced by coercion to integer64 range
#> # A tibble: 6 × 9
#>   partner prepost weight name       type         n  group superclass    somaSide
#>     <dbl>   <dbl>  <int> <chr>      <chr>    <int>  <int> <chr>         <chr>   
#> 1  800561       1    209 IN08A006_L IN08A006     1 800561 vnc_intrinsic L       
#> 2  801437       1    195 IN08A006_R IN08A006     1 800561 vnc_intrinsic R       
#> 3   11158       1    168 DNge026_R  DNge026      1  11158 descending_n… R       
#> 4  800511       1    156 IN08A006_L IN08A006     1 800511 vnc_intrinsic L       
#> 5  800687       1    150 IN19A003_R IN19A003     1 800461 vnc_intrinsic R       
#> 6  524150       1    150 PS137_R    PS137        1  13165 cb_intrinsic  R       
# return weight of outputs in the brain specifically (see ROIweight column)
mcns_connection_table('DNa02', partners = 'out', roi='CentralBrain') %>% head()
#> Warning: NAs introduced by coercion to integer64 range
#>   bodyid partner prepost weight           name    type ROIweight          roi
#> 1  10360   11158       1    168      DNge026_R DNge026       168 CentralBrain
#> 2  10360  524150       1    150        PS137_R   PS137       150 CentralBrain
#> 3  10360   10101       1    107        PS100_R   PS100       107 CentralBrain
#> 4 523769   11424       1    106      DNge026_L DNge026       106 CentralBrain
#> 5  10360   13165       1     91        PS137_R   PS137        91 CentralBrain
#> 6 523769  519896       1     89 DNa06(PS039)_L   DNa06        85 CentralBrain
#>    group        superclass somaSide
#> 1  11158 descending_neuron        R
#> 2  13165      cb_intrinsic        R
#> 3     NA      cb_intrinsic        R
#> 4  11158 descending_neuron        L
#> 5  13165      cb_intrinsic        R
#> 6 519896 descending_neuron        L

# \donttest{
joffrey.id=mcns_xyz2bodyid(cbind(24590, 13816, 26102)+4096, node = 'neuprint')
joffrey.us=mcns_connection_table(joffrey.id, partners = 'in')
joffrey.uss=mcns_connection_table(joffrey.id, partners = 'in', summary=TRUE)
# }
if (FALSE) { # \dontrun{
# open top 10 partners in neuroglancer,
# NB segmentation / meshes to match neuprint
mcns_scene(joffrey.uss$partner[1:10], open = TRUE, node='neuprint')
} # }
```
