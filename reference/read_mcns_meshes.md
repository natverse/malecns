# Read a mesh for the current segmentation

Read a mesh for the current segmentation

## Usage

``` r
read_mcns_meshes(
  ids,
  units = c("nm", "raw", "microns"),
  type = c("auto", "dvid", "small"),
  node = "neutu",
  df = NULL,
  ...
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)

- units:

  Units of the returned neurons (default `nm`)

- type:

  One of `"auto"` (the default), `"dvid"` or `"small"` (see details).

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html).
  The default is to return the current active (unlocked) node being used
  through neutu.

- df:

  A data.frame containing information about the neurons for which meshes
  will be fetched. Optional and if `ids` is a data.frame, then that will
  be used.

- ...:

  Additional arguments passed to
  [`httr::GET`](https://httr.r-lib.org/reference/GET.html)

## Value

A [`neuronlist`](https://rdrr.io/pkg/nat/man/neuronlist.html) containing
one or more `mesh3d` objects.

## Details

`dvid` meshes are pre-computed but are automatically deleted and
recomputed after bodies are edited. However this process has a
noticeable lag. `small` meshes are generated on demand in a process that
can be quite slow. `auto` will try the `dvid` method and switch to
`small` if that fails. See
[slack](https://flyem-cns.slack.com/archives/C01BZB05M8C/p1651719608800039)
for details; this is essentially the same behaviour as the flyem clio
fork.

## See also

Other neurons:
[`read_mcns_neurons()`](https://natverse.org/malecns/reference/read_mcns_neurons.md)

## Examples

``` r
if (FALSE) { # \dontrun{
ml=read_mcns_meshes(1796013202)
plot3d(ml)
# or if there's just one mesh, you can get more control with the rgl commands
# like wire3d
wire3d(ml[[1]])
} # }
```
