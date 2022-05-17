# malecns

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/flyconnectome/malecns/workflows/R-CMD-check/badge.svg)](https://github.com/flyconnectome/malecns/actions)
<!-- badges: end -->

The goal of malecns is to provide http://natverse.org/ style access to the
latest datasets from Janelia FlyEM. It is presently a very thin wrapper around the 
[malevnc](https://github.com/flyconnectome/malevnc) package. The goal in due
course would be to provide a slightly more flexible setup to cope with 

## Installation

You can install the released version of malecns from GitHub

``` r
install.packages("natmanager")
natmanager::install(pkgs="flyconnectome/malecns")

```

## Example

This is example shows you how to read some meshes, look up ids by position
and transform positions from FlyWire/FAFB14.

``` r
library(malecns)
## read meshes for some annotated neurons

gs="https://docs.google.com/spreadsheets/d/13e2yboGmSHrkdew0REkqXWrx5PfHrwPbZZArySjIHtA/edit?usp=sharing"
mca=googlesheets4::read_sheet(gs)
# update bodyids based on XYZ position
mca$position=mcns_xyz2bodyid(mca$position)

confirmed_neurondf=subset(mca, !is.na(ontology))
ml=read_mcns_meshes(confirmed_neurondf)
plot3d(ml, col=symbol)

library(natverse)
library(fafbseg)
# transform a point in FlyWire voxel space to malecns voxel space
# and put it on the clipbaord ready to paste into neuroglancer
clipr::write_clip(xform_brain(cbind(109953, 50450, 1660)*c(4,4,40), 
  reference = 'malecns',   sample = 'FlyWire')/8)
```
