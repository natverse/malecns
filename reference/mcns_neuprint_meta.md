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

  Optional, a `neuprint_connection` object, which also specifies the
  neuPrint server. Defaults to
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

  Additional arguments passed to `neuprint_get_meta`

## Value

A data.frame with one row for each (unique) input id and NAs for all
columns except bodyid when neuprint holds no metadata.

## Details

in contrast to
[`malevnc::manc_neuprint_meta`](https://natverse.org/malevnc/reference/manc_neuprint_meta.html)
we leave bodyids as numeric (doubles) since flyem now guarantee them to
be less than 2^53 i.e. within the range in which doubles can exactly
represent numeric ids.

## See also

Other annotations:
[`mcns_body_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_body_annotations.md),
[`mcns_dvid_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_dvid_annotations.md),
[`mcns_soma_side()`](https://flyconnectome.github.io/malecns/reference/mcns_soma_side.md)

## Examples

``` r
# \donttest{
library(dplyr)
# fetch metatada for all bodies in neuprint
mnm=mcns_neuprint_meta()
#> Error in manc_dvid_node("neuprint"): Unable to find neuprint node
# fetch metadata for all bodies with a somaLocation
mnm.soma=mcns_neuprint_meta("where:exists(n.somaLocation)")

# type or instance present
mnm.ti <- mcns_neuprint_meta('where:exists(n.type) OR exists(n.instance)')

# neurons without a superclass but quite a few synapses
mnm.nc=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.synweight>2000")
mnm.nc %>% arrange(desc(synweight))
#>       bodyid post  pre downstream upstream synweight flywireType group
#> 1     957899 1776 1343       5431     1776      7207        <NA>    NA
#> 2     955684  589  809       5744      589      6333        <NA>    NA
#> 3     519161 2401  322       2717     2401      5118        <NA>    NA
#> 4     511780 1175  423       3721     1175      4896        <NA>    NA
#> 5     555297  236  604       3882      236      4118        <NA>    NA
#> 6      88667 1908  225       1724     1908      3632        <NA>    NA
#> 7     806539  202  447       3169      202      3371        <NA>    NA
#> 8      73540  332  322       3016      332      3348        <NA>    NA
#> 9     926152 1134  321       2087     1134      3221        <NA>    NA
#> 10     66613 1686  245       1527     1686      3213        <NA>    NA
#> 11    956675   55  421       3139       55      3194        <NA>    NA
#> 12     92244 1753  222       1426     1753      3179        <NA>    NA
#> 13    942401  351  465       2705      351      3056        <NA>    NA
#> 14    955927  163  401       2644      163      2807        <NA>    NA
#> 15    523480 1037  211       1766     1037      2803        <NA>    NA
#> 16    104626   53  318       2732       53      2785        <NA>    NA
#> 17    559672 1395  247       1385     1395      2780        <NA>    NA
#> 18    807703 1400  292       1343     1400      2743        <NA>    NA
#> 19    110922   62  267       2640       62      2702        <NA>    NA
#> 20    114076  150  300       2529      150      2679        <NA>    NA
#> 21 516174168  128  319       2472      128      2600        <NA>    NA
#> 22    955155  609  302       1982      609      2591        <NA>    NA
#> 23    955615  450  382       2109      450      2559        <NA>    NA
#> 24    118423  101  259       2436      101      2537        <NA>    NA
#> 25    954991  392  308       2124      392      2516        <NA>    NA
#> 26    147605 1180  183       1207     1180      2387        <NA>    NA
#> 27    956674  868  281       1506      868      2374        <NA>    NA
#> 28    954995  399  305       1971      399      2370        <NA>    NA
#> 29    555267   64  289       2300       64      2364        <NA>    NA
#> 30    210839   70  268       2294       70      2364        <NA>    NA
#> 31    908376   26  235       2318       26      2344        <NA>    NA
#> 32    813118 1244  232       1030     1244      2274        <NA>    NA
#> 33    809279  107  279       2117      107      2224        <NA>    NA
#> 34    909276   57  275       2131       57      2188        <NA>    NA
#> 35    810259   74  256       2039       74      2113        <NA>    NA
#> 36    544325  238  254       1820      238      2058        <NA>    NA
#> 37    147742  257  204       1790      257      2047        <NA>    NA
#> 38    903906   52  327       1983       52      2035        <NA>    NA
#> 39    946550  949  128       1067      949      2016        <NA>    NA
#>    hemibrainType          name itoleeHl somaSide      statusLabel superclass
#> 1           <NA>          <NA>     <NA>     <NA>   Will be merged       <NA>
#> 2           <NA>          <NA>     <NA>     <NA>             <NA>       <NA>
#> 3           <NA> KC_L_fragment     <NA>        L           Orphan       <NA>
#> 4           <NA>          <NA>     <NA>     <NA>   Will be merged       <NA>
#> 5           <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 6           <NA>          <NA>     <NA>     <NA>   Will be merged       <NA>
#> 7           <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 8           <NA>          <NA>     <NA>     <NA>       PRT Orphan       <NA>
#> 9           <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 10          <NA>          <NA>     <NA>     <NA>   Will be merged       <NA>
#> 11          <NA>          <NA>     <NA>     <NA>             <NA>       <NA>
#> 12          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 13          <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 14          <NA>          <NA>     <NA>     <NA>             <NA>       <NA>
#> 15          <NA>          <NA>     <NA>     <NA>   Will be merged       <NA>
#> 16          <NA>          <NA>     <NA>     <NA>           Anchor       <NA>
#> 17          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 18          <NA>          <NA>     <NA>     <NA>   Will be merged       <NA>
#> 19          <NA>          <NA>     <NA>     <NA>           Anchor       <NA>
#> 20          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 21          <NA>          <NA>     <NA>     <NA>       PRT Orphan       <NA>
#> 22          <NA>          <NA>     <NA>     <NA>             <NA>       <NA>
#> 23          <NA>          <NA>     <NA>     <NA>             <NA>       <NA>
#> 24          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 25          <NA>          <NA>     <NA>     <NA>             <NA>       <NA>
#> 26          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 27          <NA>          <NA>     <NA>     <NA> Partially traced       <NA>
#> 28          <NA>          <NA>     <NA>     <NA>             <NA>       <NA>
#> 29          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 30          <NA>          <NA>     <NA>     <NA>       PRT Orphan       <NA>
#> 31          <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 32          <NA>          <NA>     <NA>     <NA>   Will be merged       <NA>
#> 33          <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 34          <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 35          <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 36          <NA>          <NA>     <NA>     <NA> RT Hard to trace       <NA>
#> 37          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#> 38          <NA>          <NA>     <NA>     <NA>  Orphan-artifact       <NA>
#> 39          <NA>          <NA>     <NA>     <NA>           Orphan       <NA>
#>    supertype type class entryNerve fruDsx matchingNotes rootSide assignedOlHex1
#> 1       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 2       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 3       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 4       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 5       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 6       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 7       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 8       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 9       <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 10      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 11      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 12      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 13      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 14      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 15      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 16      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 17      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 18      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 19      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 20      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 21      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 22      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 23      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 24      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 25      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 26      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 27      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 28      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 29      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 30      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 31      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 32      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 33      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 34      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 35      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 36      <NA> <NA>  <NA>       aPhN   <NA>          <NA>        R             NA
#> 37      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 38      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 39      <NA> <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#>    assignedOlHex2 mancBodyid mancGroup mancType somaNeuromere subclass trumanHl
#> 1              NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 2              NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 3              NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 4              NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 5              NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 6              NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 7              NA     153319        NA     <NA>          <NA>     <NA>     <NA>
#> 8              NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 9              NA      11325        NA     <NA>          <NA>     <NA>     <NA>
#> 10             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 11             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 12             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 13             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 14             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 15             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 16             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 17             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 18             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 19             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 20             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 21             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 22             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 23             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 24             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 25             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 26             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 27             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 28             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 29             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 30             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 31             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 32             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 33             NA      16226        NA     <NA>          <NA>     <NA>     <NA>
#> 34             NA      28494        NA     <NA>          <NA>     <NA>     <NA>
#> 35             NA      29891        NA     <NA>          <NA>     <NA>     <NA>
#> 36             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 37             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 38             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 39             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#>    dimorphism synonyms birthtime mancSerial mcnsSerial exitNerve serialMotif
#> 1        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 2        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 3        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 4        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 5        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 6        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 7        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 8        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 9        <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 10       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 11       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 12       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 13       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 14       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 15       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 16       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 17       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 18       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 19       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 20       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 21       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 22       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 23       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 24       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 25       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 26       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 27       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 28       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 29       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 30       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 31       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 32       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 33       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 34       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 35       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 36       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 37       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 38       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 39       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#>    receptorType       somaLocation tosomaLocation status totalNtPredictions
#> 1          <NA>                              <NA> Anchor               1343
#> 2          <NA>                              <NA>   <NA>                809
#> 3          <NA>                              <NA> Orphan                322
#> 4          <NA>                              <NA> Anchor                423
#> 5          <NA>                              <NA> Orphan                604
#> 6          <NA>                              <NA> Anchor                225
#> 7          <NA>                              <NA> Orphan                447
#> 8          <NA>                              <NA> Traced                322
#> 9          <NA>                              <NA> Orphan                321
#> 10         <NA>                              <NA> Anchor                245
#> 11         <NA>                              <NA>   <NA>                421
#> 12         <NA>                              <NA> Orphan                222
#> 13         <NA>                              <NA> Orphan                465
#> 14         <NA>                              <NA>   <NA>                401
#> 15         <NA>                              <NA> Anchor                211
#> 16         <NA>                              <NA> Anchor                318
#> 17         <NA>                              <NA> Orphan                247
#> 18         <NA> 45776,42898,124070           <NA> Anchor                292
#> 19         <NA>                              <NA> Anchor                267
#> 20         <NA>                              <NA> Orphan                300
#> 21         <NA>                              <NA> Traced                319
#> 22         <NA>                              <NA>   <NA>                302
#> 23         <NA>                              <NA>   <NA>                382
#> 24         <NA>                              <NA> Orphan                259
#> 25         <NA>                              <NA>   <NA>                308
#> 26         <NA>                              <NA> Orphan                183
#> 27         <NA>                              <NA> Anchor                281
#> 28         <NA>                              <NA>   <NA>                305
#> 29         <NA>                              <NA> Orphan                289
#> 30         <NA>                              <NA> Traced                268
#> 31         <NA>                              <NA> Orphan                235
#> 32         <NA> 55370,49498,124300           <NA> Anchor                232
#> 33         <NA>                              <NA> Orphan                279
#> 34         <NA>                              <NA> Orphan                275
#> 35         <NA>                              <NA> Orphan                256
#> 36         <NA>                              <NA> Traced                254
#> 37         <NA>                              <NA> Orphan                204
#> 38         <NA>                              <NA> Orphan                327
#> 39         <NA>                              <NA> Orphan                128
#>    predictedNtConfidence   predictedNt celltypeTotalNtPredictions
#> 1              0.4727293       unclear                       1343
#> 2              0.8640445          gaba                        809
#> 3              0.6559761          gaba                        322
#> 4              0.9675383 acetylcholine                        423
#> 5              0.8797594 acetylcholine                        604
#> 6              0.8599118          gaba                        225
#> 7              0.9679350 acetylcholine                        447
#> 8              0.6701043          gaba                        322
#> 9              0.8887218          gaba                        321
#> 10             0.8569361          gaba                        245
#> 11             0.9744267 acetylcholine                        421
#> 12             0.8789750          gaba                        222
#> 13             0.8515577 acetylcholine                        465
#> 14             0.9720145 acetylcholine                        401
#> 15             0.8536807          gaba                        211
#> 16             0.8461176          gaba                        318
#> 17             0.5412667          gaba                        247
#> 18             0.8711325          gaba                        292
#> 19             0.8838590 acetylcholine                        267
#> 20             0.9679516 acetylcholine                        300
#> 21             0.6035618 acetylcholine                        319
#> 22             0.9583629 acetylcholine                        302
#> 23             0.7435609 acetylcholine                        382
#> 24             0.8152437     glutamate                        259
#> 25             0.9744267 acetylcholine                        308
#> 26             0.8818263          gaba                        183
#> 27             0.9640780 acetylcholine                        281
#> 28             0.9680637 acetylcholine                        305
#> 29             0.8532677          gaba                        289
#> 30             0.8225566 acetylcholine                        268
#> 31             0.8041940          gaba                        235
#> 32             0.8845356          gaba                        232
#> 33             0.9709598 acetylcholine                        279
#> 34             0.8977834          gaba                        275
#> 35             0.8591303          gaba                        256
#> 36             0.8091965     glutamate                        254
#> 37             0.9364202 acetylcholine                        204
#> 38             0.9744267 acetylcholine                        327
#> 39             0.8357897          gaba                        128
#>    celltypePredictedNt celltypePredictedNtConfidence   consensusNt     voxels
#> 1              unclear                            NA       unclear 1275432396
#> 2              unclear                            NA          gaba  476087509
#> 3              unclear                            NA          gaba  278587841
#> 4              unclear                            NA acetylcholine  416129220
#> 5              unclear                            NA acetylcholine  183037288
#> 6              unclear                            NA          gaba  199021086
#> 7              unclear                            NA acetylcholine  204307113
#> 8              unclear                            NA          gaba  164205396
#> 9              unclear                            NA          gaba  833342245
#> 10             unclear                            NA          gaba  185592243
#> 11             unclear                            NA acetylcholine  217610342
#> 12             unclear                            NA          gaba  172460933
#> 13             unclear                            NA acetylcholine  244236620
#> 14             unclear                            NA acetylcholine  291166682
#> 15             unclear                            NA          gaba  137277535
#> 16             unclear                            NA          gaba  118186516
#> 17             unclear                            NA          gaba  139035186
#> 18             unclear                            NA          gaba  566895848
#> 19             unclear                            NA acetylcholine  130934995
#> 20             unclear                            NA acetylcholine  127874261
#> 21             unclear                            NA acetylcholine  148541348
#> 22             unclear                            NA acetylcholine  393057814
#> 23             unclear                            NA acetylcholine  142895359
#> 24             unclear                            NA     glutamate  115258843
#> 25             unclear                            NA acetylcholine  291580020
#> 26             unclear                            NA          gaba  118445955
#> 27             unclear                            NA acetylcholine  389656375
#> 28             unclear                            NA acetylcholine  309045905
#> 29             unclear                            NA          gaba  135641183
#> 30             unclear                            NA acetylcholine   66258699
#> 31             unclear                            NA          gaba  115459022
#> 32             unclear                            NA          gaba  491114015
#> 33             unclear                            NA acetylcholine  229596508
#> 34             unclear                            NA          gaba  169169631
#> 35             unclear                            NA          gaba  230638948
#> 36             unclear                            NA     glutamate   93097711
#> 37             unclear                            NA acetylcholine   88932916
#> 38             unclear                            NA acetylcholine  176044266
#> 39             unclear                            NA          gaba  129131037
#>     soma
#> 1  FALSE
#> 2  FALSE
#> 3  FALSE
#> 4  FALSE
#> 5  FALSE
#> 6  FALSE
#> 7  FALSE
#> 8  FALSE
#> 9  FALSE
#> 10 FALSE
#> 11 FALSE
#> 12 FALSE
#> 13 FALSE
#> 14 FALSE
#> 15 FALSE
#> 16 FALSE
#> 17 FALSE
#> 18  TRUE
#> 19 FALSE
#> 20 FALSE
#> 21 FALSE
#> 22 FALSE
#> 23 FALSE
#> 24 FALSE
#> 25 FALSE
#> 26 FALSE
#> 27 FALSE
#> 28 FALSE
#> 29 FALSE
#> 30 FALSE
#> 31 FALSE
#> 32  TRUE
#> 33 FALSE
#> 34 FALSE
#> 35 FALSE
#> 36 FALSE
#> 37 FALSE
#> 38 FALSE
#> 39 FALSE
# }
library(dplyr)
# Which neurons don't have a superclass, but possibly should
mnm.nsc=mcns_neuprint_meta("where:NOT exists(n.superclass)")
mnm.nsc %>% count(statusLabel)
#>              statusLabel    n
#> 1              0.5assign   11
#> 2                 Anchor  271
#> 3          Hard to trace   42
#> 4                 Leaves  416
#> 5                 Orphan 3458
#> 6        Orphan hotknife  975
#> 7        Orphan-artifact 1938
#> 8           Out of scope 2045
#> 9             PRT Orphan   77
#> 10      Partially traced   12
#> 11 Prelim Roughly traced   18
#> 12      RT Hard to trace    1
#> 13              Reviewed    3
#> 14        Roughly traced    1
#> 15        Sensory Anchor   80
#> 16           Soma Anchor  196
#> 17        Will be merged  167
#> 18                  <NA>  169

# neurons that are RT or PRT should probably have a superclass
mnm.nscprt=mcns_neuprint_meta("where:NOT exists(n.superclass) AND n.statusLabel CONTAINS 'Roughly'")
mnm.nscprt %>% count()
#>    n
#> 1 19
```
