# Fetch neuprint metadata for malecns neurons

Fetch neuprint metadata for malecns neurons

## Usage

``` r
mcns_neuprint_meta(
  ids = NULL,
  conn = mcns_neuprint(),
  roiInfo = FALSE,
  simplify.xyz = TRUE,
  cache = NA,
  ...
)
```

## Arguments

- ids:

  body ids. When missing all bodies known to DVID are returned.

- conn:

  Optional, a
  [`neuprint_connection`](https://natverse.org/neuprintr/reference/neuprint_login.html)
  object, which also specifies the neuPrint server. Defaults to
  [`manc_neuprint()`](https://natverse.org/malevnc/reference/manc_neuprint.html)
  to ensure that query is against the VNC dataset.

- roiInfo:

  whether to include the `roiInfo` field detailing synapse numbers in
  different locations. This is omitted by default as it is returned as a
  character vector of unprocessed JSON.

- simplify.xyz:

  Whether to simplify columns containing XYZ locations to a simple
  `"x,y,z"` format rather than a longer form referencing a schema at
  `spatialreference.org`. Defaults to `TRUE`.

- cache:

  whether to cache the query. When `cache=NA` (the default) queries are
  cached for neuprint snapshot versions (but not production datasets).
  See details.

- ...:

  Additional arguments passed to
  [`neuprint_get_meta`](https://natverse.org/neuprintr/reference/neuprint_get_meta.html)

## Value

A data.frame with one row for each (unique) input id and NAs for all
columns except bodyid when neuprint holds no metadata.

## Details

in contrast to
[`manc_neuprint_meta`](https://natverse.org/malevnc/reference/manc_neuprint_meta.html)
we leave bodyids as numeric (doubles) since flyem now guarantee them to
be less than 2^53 i.e. within the range in which doubles can exactly
represent numeric ids.

## See also

Other annotations:
[`mcns_body_annotations()`](https://natverse.org/malecns/reference/mcns_body_annotations.md),
[`mcns_dvid_annotations()`](https://natverse.org/malecns/reference/mcns_dvid_annotations.md),
[`mcns_soma_side()`](https://natverse.org/malecns/reference/mcns_soma_side.md)

## Examples

``` r
# \donttest{
library(dplyr)
# fetch metatada for all bodies in neuprint
mnm=mcns_neuprint_meta()
# fetch metadata for all bodies with a somaLocation
mnm.soma=mcns_neuprint_meta("where:exists(n.somaLocation)")

# type or instance present
mnm.ti <- mcns_neuprint_meta('where:exists(n.type) OR exists(n.instance)')

# neurons without a superclass but quite a few synapses
mnm.nc=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.synweight>2000")
mnm.nc %>% arrange(desc(synweight))
#>       bodyid post pre downstream upstream synweight assignedOlHex1
#> 1     519161 2401 322       2717     2401      5118             NA
#> 2     555297  253 632       4061      253      4314             NA
#> 3     806539  202 447       3169      202      3371             NA
#> 4      73540  332 322       3016      332      3348             NA
#> 5     926152 1134 321       2087     1134      3221             NA
#> 6     956675   55 421       3139       55      3194             NA
#> 7      92244 1753 222       1426     1753      3179             NA
#> 8     942401  351 465       2705      351      3056             NA
#> 9     955927  163 401       2644      163      2807             NA
#> 10    104626   55 318       2732       55      2787             NA
#> 11    559672 1395 247       1385     1395      2780             NA
#> 12    110922   62 267       2640       62      2702             NA
#> 13    114076  150 300       2529      150      2679             NA
#> 14 516174168  128 319       2472      128      2600             NA
#> 15    959135   71 364       2507       71      2578             NA
#> 16    955615  450 382       2109      450      2559             NA
#> 17    118423  101 260       2443      101      2544             NA
#> 18    147605 1180 183       1207     1180      2387             NA
#> 19    956674  868 281       1506      868      2374             NA
#> 20    954995  399 305       1971      399      2370             NA
#> 21    555267   64 289       2300       64      2364             NA
#> 22    210839   70 268       2294       70      2364             NA
#> 23    908376   26 235       2318       26      2344             NA
#> 24    809279  107 279       2117      107      2224             NA
#> 25    810259   74 256       2039       74      2113             NA
#> 26    544325  238 254       1820      238      2058             NA
#> 27    147742  257 204       1790      257      2047             NA
#> 28    903906   52 327       1983       52      2035             NA
#> 29    946550  949 128       1067      949      2016             NA
#>    assignedOlHex2 flywireType group          name somaSide      statusLabel
#> 1              NA        <NA>    NA KC_L_fragment        L           Orphan
#> 2              NA        <NA>    NA          <NA>     <NA>           Orphan
#> 3              NA        <NA>    NA          <NA>     <NA>  Orphan-artifact
#> 4              NA        <NA>    NA          <NA>     <NA>       PRT Orphan
#> 5              NA        <NA>    NA          <NA>     <NA>  Orphan-artifact
#> 6              NA        <NA>    NA          <NA>     <NA>             <NA>
#> 7              NA        <NA>    NA          <NA>     <NA>           Orphan
#> 8              NA        <NA>    NA          <NA>     <NA>  Orphan-artifact
#> 9              NA        <NA>    NA          <NA>     <NA>             <NA>
#> 10             NA        <NA>    NA          <NA>     <NA>           Anchor
#> 11             NA        <NA>    NA          <NA>     <NA>           Orphan
#> 12             NA        <NA>    NA          <NA>     <NA>           Anchor
#> 13             NA        <NA>    NA          <NA>     <NA>           Orphan
#> 14             NA        <NA>    NA          <NA>     <NA>       PRT Orphan
#> 15             NA        <NA>    NA          <NA>     <NA>             <NA>
#> 16             NA        <NA>    NA          <NA>     <NA>             <NA>
#> 17             NA        <NA>    NA          <NA>     <NA>           Orphan
#> 18             NA        <NA>    NA          <NA>     <NA>           Orphan
#> 19             NA        <NA>    NA          <NA>     <NA> Partially traced
#> 20             NA        <NA>    NA          <NA>     <NA>             <NA>
#> 21             NA        <NA>    NA          <NA>     <NA>           Orphan
#> 22             NA        <NA>    NA          <NA>     <NA>       PRT Orphan
#> 23             NA        <NA>    NA          <NA>     <NA>  Orphan-artifact
#> 24             NA        <NA>    NA          <NA>     <NA>  Orphan-artifact
#> 25             NA        <NA>    NA          <NA>     <NA>  Orphan-artifact
#> 26             NA        <NA>    NA          <NA>     <NA> RT Hard to trace
#> 27             NA        <NA>    NA          <NA>     <NA>           Orphan
#> 28             NA        <NA>    NA          <NA>     <NA>  Orphan-artifact
#> 29             NA        <NA>    NA          <NA>     <NA>           Orphan
#>    superclass type vfbId hemibrainType itoleeHl supertype birthtime mancBodyid
#> 1        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 2        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 3        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>     153319
#> 4        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 5        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>      11325
#> 6        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 7        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 8        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 9        <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 10       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 11       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 12       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 13       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 14       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 15       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 16       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 17       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 18       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 19       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 20       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 21       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 22       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 23       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 24       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>      16226
#> 25       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>      29891
#> 26       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 27       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 28       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#> 29       <NA> <NA>  <NA>          <NA>     <NA>      <NA>      <NA>         NA
#>    mancGroup mancType subclass synonyms class rootSide somaNeuromere trumanHl
#> 1         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 2         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 3         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 4         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 5         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 6         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 7         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 8         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 9         NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 10        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 11        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 12        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 13        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 14        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 15        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 16        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 17        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 18        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 19        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 20        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 21        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 22        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 23        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 24        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 25        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 26        NA     <NA>     <NA>     <NA>  <NA>        R          <NA>     <NA>
#> 27        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 28        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 29        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#>    dimorphism matchingNotes entryNerve mancSerial mcnsSerial serialMotif fruDsx
#> 1        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 2        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 3        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 4        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 5        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 6        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 7        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 8        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 9        <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 10       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 11       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 12       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 13       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 14       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 15       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 16       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 17       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 18       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 19       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 20       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 21       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 22       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 23       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 24       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 25       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 26       <NA>          <NA>       aPhN         NA         NA        <NA>   <NA>
#> 27       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 28       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 29       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#>    exitNerve receptorType somaLocation tosomaLocation status totalNtPredictions
#> 1       <NA>         <NA>         <NA>           <NA> Orphan                322
#> 2       <NA>         <NA>         <NA>           <NA> Orphan                632
#> 3       <NA>         <NA>         <NA>           <NA> Orphan                447
#> 4       <NA>         <NA>         <NA>           <NA> Traced                322
#> 5       <NA>         <NA>         <NA>           <NA> Orphan                321
#> 6       <NA>         <NA>         <NA>           <NA>   <NA>                421
#> 7       <NA>         <NA>         <NA>           <NA> Orphan                222
#> 8       <NA>         <NA>         <NA>           <NA> Orphan                465
#> 9       <NA>         <NA>         <NA>           <NA>   <NA>                401
#> 10      <NA>         <NA>         <NA>           <NA> Anchor                318
#> 11      <NA>         <NA>         <NA>           <NA> Orphan                247
#> 12      <NA>         <NA>         <NA>           <NA> Anchor                267
#> 13      <NA>         <NA>         <NA>           <NA> Orphan                300
#> 14      <NA>         <NA>         <NA>           <NA> Traced                319
#> 15      <NA>         <NA>         <NA>           <NA>   <NA>                364
#> 16      <NA>         <NA>         <NA>           <NA>   <NA>                382
#> 17      <NA>         <NA>         <NA>           <NA> Orphan                260
#> 18      <NA>         <NA>         <NA>           <NA> Orphan                183
#> 19      <NA>         <NA>         <NA>           <NA> Anchor                281
#> 20      <NA>         <NA>         <NA>           <NA>   <NA>                305
#> 21      <NA>         <NA>         <NA>           <NA> Orphan                289
#> 22      <NA>         <NA>         <NA>           <NA> Traced                268
#> 23      <NA>         <NA>         <NA>           <NA> Orphan                235
#> 24      <NA>         <NA>         <NA>           <NA> Orphan                279
#> 25      <NA>         <NA>         <NA>           <NA> Orphan                256
#> 26      <NA>         <NA>         <NA>           <NA> Traced                254
#> 27      <NA>         <NA>         <NA>           <NA> Orphan                204
#> 28      <NA>         <NA>         <NA>           <NA> Orphan                327
#> 29      <NA>         <NA>         <NA>           <NA> Orphan                128
#>    predictedNtConfidence   predictedNt celltypeTotalNtPredictions
#> 1              0.6559249          gaba                        322
#> 2              0.8826958 acetylcholine                        632
#> 3              0.9682381 acetylcholine                        447
#> 4              0.6700611          gaba                        322
#> 5              0.8886508          gaba                        321
#> 6              0.9747327 acetylcholine                        421
#> 7              0.8789046          gaba                        222
#> 8              0.8518127 acetylcholine                        465
#> 9              0.9723195 acetylcholine                        401
#> 10             0.8460507          gaba                        318
#> 11             0.5412279          gaba                        247
#> 12             0.8841251 acetylcholine                        267
#> 13             0.9682552 acetylcholine                        300
#> 14             0.6037433 acetylcholine                        319
#> 15             0.8917006          gaba                        364
#> 16             0.7437765 acetylcholine                        382
#> 17             0.8141996     glutamate                        260
#> 18             0.8817557          gaba                        183
#> 19             0.9643800 acetylcholine                        281
#> 20             0.9683674 acetylcholine                        305
#> 21             0.8532007          gaba                        289
#> 22             0.8228081 acetylcholine                        268
#> 23             0.8041351          gaba                        235
#> 24             0.9712642 acetylcholine                        279
#> 25             0.8590619          gaba                        256
#> 26             0.8078946     glutamate                        254
#> 27             0.9367103 acetylcholine                        204
#> 28             0.9747327 acetylcholine                        327
#> 29             0.8357252          gaba                        128
#>    celltypePredictedNt celltypePredictedNtConfidence   consensusNt    voxels
#> 1              unclear                            NA          gaba 278587841
#> 2              unclear                            NA acetylcholine 191409375
#> 3              unclear                            NA acetylcholine 204307113
#> 4              unclear                            NA          gaba 164637153
#> 5              unclear                            NA          gaba 833342245
#> 6              unclear                            NA acetylcholine 217610342
#> 7              unclear                            NA          gaba 172460933
#> 8              unclear                            NA acetylcholine 244236620
#> 9              unclear                            NA acetylcholine 291166682
#> 10             unclear                            NA          gaba 118200619
#> 11             unclear                            NA          gaba 139035186
#> 12             unclear                            NA acetylcholine 130934995
#> 13             unclear                            NA acetylcholine 127874261
#> 14             unclear                            NA acetylcholine 148541348
#> 15             unclear                            NA          gaba 254091464
#> 16             unclear                            NA acetylcholine 142895359
#> 17             unclear                            NA     glutamate 115617311
#> 18             unclear                            NA          gaba 118445955
#> 19             unclear                            NA acetylcholine 389656375
#> 20             unclear                            NA acetylcholine 309045905
#> 21             unclear                            NA          gaba 135641183
#> 22             unclear                            NA acetylcholine  66258699
#> 23             unclear                            NA          gaba 115459022
#> 24             unclear                            NA acetylcholine 229596508
#> 25             unclear                            NA          gaba 230638948
#> 26             unclear                            NA     glutamate  93097711
#> 27             unclear                            NA acetylcholine  88932916
#> 28             unclear                            NA acetylcholine 176044266
#> 29             unclear                            NA          gaba 129131037
#>    locationType  soma
#> 1            NA FALSE
#> 2            NA FALSE
#> 3            NA FALSE
#> 4            NA FALSE
#> 5            NA FALSE
#> 6            NA FALSE
#> 7            NA FALSE
#> 8            NA FALSE
#> 9            NA FALSE
#> 10           NA FALSE
#> 11           NA FALSE
#> 12           NA FALSE
#> 13           NA FALSE
#> 14           NA FALSE
#> 15           NA FALSE
#> 16           NA FALSE
#> 17           NA FALSE
#> 18           NA FALSE
#> 19           NA FALSE
#> 20           NA FALSE
#> 21           NA FALSE
#> 22           NA FALSE
#> 23           NA FALSE
#> 24           NA FALSE
#> 25           NA FALSE
#> 26           NA FALSE
#> 27           NA FALSE
#> 28           NA FALSE
#> 29           NA FALSE
# }
library(dplyr)
# Which neurons don't have a superclass, but possibly should
mnm.nsc=mcns_neuprint_meta("where:NOT exists(n.superclass)")
mnm.nsc %>% count(statusLabel)
#>              statusLabel    n
#> 1              0.5assign   11
#> 2                 Anchor  271
#> 3          Hard to trace   65
#> 4                 Leaves  416
#> 5                 Orphan 3457
#> 6        Orphan hotknife  974
#> 7        Orphan-artifact 1936
#> 8           Out of scope 2044
#> 9             PRT Orphan   76
#> 10      Partially traced    9
#> 11 Prelim Roughly traced   17
#> 12      RT Hard to trace    2
#> 13              Reviewed    4
#> 14        Roughly traced    1
#> 15        Sensory Anchor   78
#> 16           Soma Anchor  193
#> 17                  <NA>  168

# neurons that are RT or PRT should probably have a superclass
mnm.nscprt=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.statusLabel CONTAINS 'Roughly'")
mnm.nscprt %>% count()
#>    n
#> 1 18
```
