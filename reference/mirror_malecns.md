# Mirror points in malecns space

Mirror points in malecns space

## Usage

``` r
mirror_malecns(x, ...)
```

## Arguments

- x:

  Any objects with 3D vertices (calibrated in nm)

- ...:

  Additional arguments passed to
  [`nat.templatebrains::xform_brain`](https://natverse.org/nat.templatebrains/reference/xform_brain.html)

## Value

The transformed object

## Details

This mirroring could of course be improved. I used Philipp Schlegel's 69
landmarks to map malecns -\> FAFB space followed by the
[`nat.jrcbrains::mirror_fafb`](https://rdrr.io/pkg/nat.jrcbrains/man/mirror_fafb.html)
function to map those landmarks to the opposite side of FAFB and then
brought those back to malecns.

## Examples

``` r
if (FALSE) { # \dontrun{
f3=system.file("landmarks/maleCNS_mirror_landmarks_nm.csv", package = 'malecns')
maleCNS_mirror_landmarks_nm <- read.csv(f3)[-1]
points3d(mirror_malecns(maleCNS_mirror_landmarks_nm[1:3]))
points3d(maleCNS_mirror_landmarks_nm[1:3], col='green')
# almost on top of the black points
points3d(maleCNS_mirror_landmarks_nm[4:6]+500, col='red')
} # }
```
