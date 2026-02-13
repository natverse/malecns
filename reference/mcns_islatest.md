# Check if a bodyid still exists in the specified malecns DVID node

Check if a bodyid still exists in the specified malecns DVID node

## Usage

``` r
mcns_islatest(ids, node = "neutu", method = c("auto", "size", "sparsevol"))
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)

- node:

  A DVID node (defaults to the current neutu node, see
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html))

- method:

  Which DVID endpoint to use. Expert use only.

## Value

A logical vector ordered by input ids

## Details

For details (and there are some) please see `manc_islatest`

## Examples

``` r
# \donttest{
# giant fibre neuron
mcns_islatest(10001)
#> [1] TRUE

# an expired body
mcns_islatest(49891)
#> [1] FALSE
# }
```
