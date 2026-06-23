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
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
mcns_ids("DA2_lPN", integer64=TRUE)
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
# You can also do more complex queries using regular expressions
mcns_ids("/VL2a.+")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
dns=mcns_ids("/type:DN.+")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.

# you can also use Neo4J cypher queries by using the where: prefix
# note that each field of the neuron must prefixed with "n."
bigneurons_nosuperclass <-
mcns_ids("where:NOT exists(n.superclass) AND n.synweight>5000")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.

bignogroupids <-
mcns_ids("where:NOT exists(n.group) AND n.synweight>5000 AND n.superclass CONTAINS 'neuron'")
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.

if (FALSE) { # \dontrun{
# you can paste ids onto the clipboard for inspection
clipr::write_clip(bignogroupids)

# throws an error
mcns_ids("rhubarb")
} # }
# returns a length 0 vector
mcns_ids("rhubarb", mustWork = FALSE)
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
```
