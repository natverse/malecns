# Get Male CNS ids in standard formats

Get Male CNS ids in standard formats

## Usage

``` r
mcns_ids(
  ids,
  mustWork = TRUE,
  as_character = TRUE,
  integer64 = FALSE,
  unique = FALSE,
  ...,
  dataset = getOption("malecns.dataset")
)
```

## Arguments

- ids:

  Either numeric ids (in `character`, `numeric`, `integer` or
  `integer64`format) or a query expression

- mustWork:

  Whether to insist that at least one valid id is returned (default
  `TRUE`)

- as_character:

  Whether to return segments as character rather than numeric vector
  (the default is character for safety).

- integer64:

  whether to return ids with class bit64::integer64.

- unique:

  Whether to ensure that only unique ids are returned (default `TRUE`)

- ...:

  Additional arguments passed to `neuprint_get_meta`

- dataset:

  The name of the dataset, e.g. `male-cns:v1.0`, `male-cns:v0.9`, or
  `CNS`.

## Value

A vector of numeric ids with mode determined by `as_character` and
`integer64`

## Examples

``` r
# exact matches for cell types
mcns_ids("DA2_lPN")
#>  [1] "18776" "20105" "19339" "26423" "23958" "21876" "34301" "18416" "20995"
#> [10] "20311"
mcns_ids("DA2_lPN", integer64=TRUE)
#> integer64
#>  [1] 18776 20105 19339 26423 23958 21876 34301 18416 20995 20311
# You can also do more complex queries using regular expressions
mcns_ids("/VL2a.+")
#> [1] "10039" "10134" "22977" "22224" "33165" "32815" "52616" "25927"
dns=mcns_ids("/type:DN.+")

# you can also use Neo4J cypher queries by using the where: prefix
# note that each field of the neuron must prefixed with "n."
bigneurons_nosuperclass <-
mcns_ids("where:NOT exists(n.superclass) AND n.synweight>5000")

bignogroupids <-
mcns_ids("where:NOT exists(n.group) AND n.synweight>5000 AND n.superclass CONTAINS 'neuron'")

if (FALSE) { # \dontrun{
# you can paste ids onto the clipboard for inspection
clipr::write_clip(bignogroupids)

# throws an error
mcns_ids("rhubarb")
} # }
# returns a length 0 vector
mcns_ids("rhubarb", mustWork = FALSE)
#> character(0)
```
