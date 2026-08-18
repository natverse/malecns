# Cosine plot

Cosine plot

## Usage

``` r
mcns_cosine_plot(
  ids,
  partners = c("output", "input"),
  group = FALSE,
  groupfun = NULL,
  labRow = "{name}_{group}",
  predict.manc = FALSE,
  heatmap = TRUE,
  metadata.source = c("neuprint", "clio"),
  interactive = FALSE,
  action = NULL,
  threshold = 10,
  ...
)
```

## Arguments

- ids:

  Bodyids in any form understood by
  [`mcns_ids`](https://flyconnectome.github.io/malecns/reference/mcns_ids.md)

- partners:

  Whether to cluster based on connections to input or output partner
  neurons (default both).

- group:

  Optional character vector specifying the grouping column for the
  partner neurons when constructing the cosine similarity matrix. `TRUE`
  implies to `'group'`.

- groupfun:

  A function which receives the metadata for all partner neurons and
  returns a single grouping vector (see the **details** section).

- labRow:

  A string interpolated by `glue` using the dataframe of metadata
  fetched by
  [`mcns_neuprint_meta`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md).
  Alternatively a character vector with as many elements as `ids`
  directly specifying the rows.

- predict.manc:

  whether to use `manc_bodyid` *predicted* matches to define grouping
  information in addition to curated `manc_group` matches. See
  [`mcns_predict_group`](https://flyconnectome.github.io/malecns/reference/mcns_predict_group.md)
  for details.

- heatmap:

  A logical indicating whether or not to plot the heatmap *OR* a
  function to plot the heatmap whose argument names are compatible with
  `stats::`[`heatmap`](https://rdrr.io/r/stats/heatmap.html).
  `gplots::heatmap.2` is a good example. Defaults to `TRUE` therefore
  plotting the full heatmap with
  `stats::`[`heatmap`](https://rdrr.io/r/stats/heatmap.html).

- metadata.source:

  Whether to use neuprint
  ([`mcns_neuprint_meta`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md))
  and clio ()

- interactive:

  Whether to plot an interactive heatmap (allowing zooming and id
  selection). See details.

- action:

  Whether to zero out or drop any NA values in the cosine matrix (these
  may be present when some columns have no entries)

- threshold:

  An integer threshold (connections \>= this will be returned)

- ...:

  additional arguments passed to `neuprint_cosine_plot` and eventually
  to `heatmap`.

## Value

The result of [`heatmap`](https://rdrr.io/r/stats/heatmap.html)
invisibly including the row and column dendrograms.

## Examples

``` r
# \donttest{
# cosine clustering based on grouped output partners (mainly DNs right now)
r=mcns_cosine_plot("/name:LAL.+", partners='out', group=TRUE)
#> Warning: Dropping: 93/24092 neurons representing 1646/862740 synapses due to missing ids!
#> Warning: diag(V) has non-positive or non-finite entries; finite result is doubtful

# }
if (FALSE) { # \dontrun{
# fancier labelling of rows including soma side of neurons
r=mcns_cosine_plot("/name:LAL.+", partners='out', group=TRUE,
  labRow = '{name}_{group}_{mcns_soma_side(data.frame(bodyid, name, somaLocation))}')

r2=mcns_cosine_plot("/name:LAL.+", partners='out', group=TRUE,
  labRow = '{instance}_{group}_{soma_side}', metadata.source='clio')

# interactive version (open in browser)
mcns_cosine_plot('/name:Pm2.*R', group=T, interactive = T)

# just return an hclust (dendrogram) object without plotting anything
pm2.hc=mcns_cosine_plot('/name:Pm2.*R', group=T, heatmap=FALSE)
plot(pm2.hc)
} # }
```
