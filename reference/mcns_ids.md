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

  The name of the dataset as reported in Clio e.g. `CNS`,
  `male-cns:v0.9` etc.

## Value

A vector of numeric ids with mode determined by `as_character` and
`integer64`

## Examples

``` r
# exact matches for cell types
mcns_ids("DA2_lPN")
#>  [1] "18776" "20105" "20995" "26423" "20311" "21876" "18416" "23958" "34301"
#> [10] "19339"
mcns_ids("DA2_lPN", integer64=TRUE)
#> integer64
#>  [1] 18776 20105 20995 26423 20311 21876 18416 23958 34301 19339
# You can also do more complex queries using regular expressions
mcns_ids("/VL2a.+")
#> [1] "10039" "10134" "25927" "22224" "33165" "52616" "22977" "32815"
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
