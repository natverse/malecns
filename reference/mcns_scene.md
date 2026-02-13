# Construct a neuroglancer scene for CNS dataset

Construct a neuroglancer scene for CNS dataset

## Usage

``` r
mcns_scene(
  ids = NULL,
  open = FALSE,
  dataset = getOption("malecns.dataset"),
  node = "neutu"
)
```

## Arguments

- ids:

  A set of bodyids

- open:

  Whether to open in your default browser

- dataset:

  Optional CNS dataset

- node:

  Optional node specifier e.g. `"neutu", "neuprint"`. The default is to
  use the latest neutu node since the malecns node specified in Clio is
  rarely updated and nodes are used for longer periods compared with the
  male vnc.

## Value

character vector containing URL

## Examples

``` r
if (FALSE) { # \dontrun{
mcns_scene(4060524874, open=TRUE, node='neuprint')

} # }
```
