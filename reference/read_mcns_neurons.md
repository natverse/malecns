# Read neuronal skeletons via neuprint

Read neuronal skeletons via neuprint

## Usage

``` r
read_mcns_neurons(
  ids,
  connectors = F,
  units = c("nm", "raw", "microns"),
  heal.threshold = Inf,
  ...
)
```

## Arguments

- ids:

  Bodyids in any form compatible with
  `malevnc::`[`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)

- connectors:

  Whether to fetch synaptic connections for the neuron (default `FALSE`
  in contrast to
  [`neuprint_read_neurons`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html)).

- units:

  Units of the returned neurons (default `nm`)

- heal.threshold:

  The threshold for

- ...:

  Additional arguments passed to
  [`neuprint_read_neurons`](https://natverse.org/neuprintr/reference/neuprint_read_neurons.html)

## Value

A [`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html) object
containing one or more
[`neuron`](https://rdrr.io/pkg/nat/man/neuron.html) objects.

## See also

Other neurons:
[`read_mcns_meshes()`](https://flyconnectome.github.io/malecns/reference/read_mcns_meshes.md)

## Examples

``` r
# nb convert
n30102=read_mcns_neurons(30102)
#> Warning: The `father` argument of `dfs()` is deprecated as of igraph 2.2.0.
#> ℹ Please use the `parent` argument instead.
#> ℹ The deprecated feature was likely used in the nat package.
#>   Please report the issue at <https://github.com/natverse/nat/issues>.
# neuronlist
n30102
#> 'neuronlist' containing 1 'neuprintneuron' object and 'data.frame' with 49 vars [165.6 kB]
boundingbox(n30102)
#>        [,1]   [,2]   [,3]
#> [1,] 168448  92160 197632
#> [2,] 279552 169984 274432
#> attr(,"class")
#> [1] "boundingbox"
# neuron
n30102[[1]]
#> 'neuron' with 2154 vertices in 1 tree and additional classes 'neuprintneuron', 'catmaidneuron'
if (FALSE) { # \dontrun{
nclear3d()
plot3d(malecns.surf, alpha=.1)
plot3d(n30102, lwd=2, soma=2000)
} # }
```
