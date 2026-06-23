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
#> Error in neuprintr::neuprint_read_neurons(ids, meta = F, connectors = connectors,     heal.threshold = heal.threshold, conn = conn, ...): Error reading bodyids. Likely no valid ids or no connection to neuPrint!
# neuronlist
n30102
#> Error: object 'n30102' not found
boundingbox(n30102)
#> Error: object 'n30102' not found
# neuron
n30102[[1]]
#> Error: object 'n30102' not found
if (FALSE) { # \dontrun{
nclear3d()
plot3d(malecns.surf, alpha=.1)
plot3d(n30102, lwd=2, soma=2000)
} # }
```
