# malecns

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/flyconnectome/malecns/workflows/R-CMD-check/badge.svg)](https://github.com/flyconnectome/malecns/actions)
<!-- badges: end -->

The goal of **malecns** is to provide [natverse](https://natverse.org) 
access to the whole male central nervous system dataset from Janelia FlyEM.

## Quick start

```r
install.packages("natmanager")
natmanager::check_pat()
natmanager::install(pkgs="flyconnectome/malecns")

usethis::edit_r_profile()
# paste in this text, appropriately edited, and close the file
options(malevnc.clio_email="myuser@gmail.com")
# e.g. "jefferisg"
options(malevnc.dvid_user="<surname><firstinitial>")

## Set your Neuprint token
# will open your browser
# collect token by clicking on your account icon top right and then Account
browseURL('https://neuprint-cns.janelia.org')
# back in R
usethis::edit_r_environ()
# paste in this text replacing with your neuprint token
# make sure you have a new lined at the end of the file
neuprint_token="eyJhbGci..."

# check everything's configured ok
dr_malecns()

# get some data
pnmeta=mcns_neuprint_meta('/.+_[adl]+PN')
table(pnmeta$type)
vm6=read_mcns_meshes('VM6_adPN')
plot3d(malecns.surf, alpha=.1)

# compare query for production vs snapshot
with_mcns(mcns_body_annotations(194965), dataset = "CNS")
with_mcns(mcns_body_annotations(194965), dataset = "male-cns:v0.9")

```
## Introduction

**malecns** is presently a very thin wrapper around the 
[malevnc](https://github.com/flyconnectome/malevnc) package. 
In due course we would hope to separate out some of the more generic
functionality from the **malevnc** package. However, the current arrangement means that some of the configuration for using the **malecns** package is handled by the **malevnc** package.

## Installation

This package points to private resources
made available by the male CNS project led by the FlyEM team at Janelia.
You will therefore need appropriate authorisation both to install the package
from github and access the data.

You can install the released version of malecns from GitHub

``` r
install.packages("natmanager")
natmanager::install(pkgs="flyconnectome/malecns")

```

Note that you must have been given access to the [github repository](https://github.com/flyconnectome/malecns/) and have a GitHub Personal Access Token (PAT) set up in order
to install the library for as long as it remains private. Do :

```
natmanager::check_pat()
```

to check and follow the instructions if necessary to create. Should you run into any errors with that (there have been some significant changes at 
github recently), you can also try:

```
usethis::create_github_token()
```

### Authentication

Access to neuprint / Clio then depends on authentication. For neuprint, please
see https://github.com/natverse/neuprintr#authentication; you only need to set
a `NEUPRINT_TOKEN` R environment variable. You can display your neuprint token after logging into the neuprint website. For Clio, you will prompted to 
authenticate via a Google OAuth "dance" in your web browser. 
Note that the Clio and neuprint tokens look similar, but are *not* the same.
Your neuprint token appears to be indefinite while the clio token
currently lasts 3 weeks.

### Configuration

For interaction with the Clio/DVID annotation systems you may need to tell R+malecns about the emails that you used to sign up for Clio/neuprint.

```r
options(malevnc.clio_email="myuser@gmail.com")
options(malevnc.dvid_user="<surname><firstinitial>")
```
These should be set in your `.Rprofile` file.

## Example

This example shows you how to read some meshes, look up ids by position
and transform positions from FlyWire/FAFB14.

``` r
library(malecns)
## read meshes for some annotated neurons

ml=read_mcns_meshes("/type:(DA1|DL3)_lPN")
# set metadata for this neuronlist
ml[,]=mcns_neuprint_meta(names(ml))
plot3d(ml, col=type)

library(natverse)
library(fafbseg)
# transform a point in FlyWire voxel space to malecns voxel space
# and put it on the clipboard ready to paste into neuroglancer
clipr::write_clip(xform_brain(cbind(109953, 50450, 1660)*c(4,4,40), 
  reference = 'malecns',   sample = 'FlyWire')/8)
```

## Updating

If you need to update your malecns install, I recommend:

```
natmanager::install(pkgs="flyconnectome/malecns")
```
