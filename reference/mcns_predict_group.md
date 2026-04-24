# Predict the group of neurons using instance or type information

Predict the group of neurons using instance or type information

## Usage

``` r
mcns_predict_group(
  ids,
  method = c("auto", "fullauto", "group", "manc", "instance", "type", "pmanc", "all"),
  badtypes = c(NA, "", "Lamina_R1-R6", "Descending", "KC", "ER", "LC", "PB",
    "Ascending Interneuron", "Delta", "P1_L candidate", "LT", "MeMe", "PFGs", "Mi", "VT",
    "ML", "EL", "FB", "Dm", "DNp", "FC", "OL", "T", "Y")
)
```

## Arguments

- ids:

  Body ids in any form understood by
  [`mcns_ids`](https://flyconnectome.github.io/malecns/reference/mcns_ids.md).
  If you have a metadata dataframe as returned by
  [`mcns_neuprint_meta`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md)
  then this is ideal as that function is called under the hood.

- method:

  A string specifying which of 5 methods to use to identify the group.
  `"all"` means to return all 5, while `"fullauto"` means to look at
  each method in turn successively filling in missing group values.
  Method `"auto"` (the default) excludes predicted manc matches (see
  details).

- badtypes:

  Values of the type column which should be ignored for the purposes of
  defining cell type groups. This will be because they contain bad
  values or because the types are too broad to be very useful.

## Value

For `method="all"` a dataframe as returned by
[`mcns_neuprint_meta`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md)
with additional columns `instance_group` and `type_group`. Otherwise a
numeric vector.

## Details

Grouping information for neurons in the male cns is presently scattered
in several locations. These include the numeric group field, the type
field or the instance field. If the type field has the same value, the
neurons should form a group. However there are some values that are
known to be bad and these are excluded.

An additional source of group information comes from matches of VNC
neurons to the MANC dataset. These either come as curated matches (where
the `manc_group` column has been entered in Clio, `method="manc"`) or as
predicted matches (based on the `manc_bodyid` column, `method="pmanc"`).

`method="pmanc"` should be used with caution since a significant
percentage of these matches are wrong. However, since the majority
should be correct, they may still be a useful source of group
information e.g. for connectivity clustering which is typically not that
sensitive to errors.

Given this situation `method='auto'` (the default) only uses curated
matches (`method="manc"`). Select `method='fullauto'` to use the
predicted MANC matches as a fall-back.

## See also

[`mcns_predict_type`](https://flyconnectome.github.io/malecns/reference/mcns_predict_type.md)

## Examples

``` r
# \donttest{
library(dplyr)
# return all body ids with a group type or instance
tig_ids=mcns_ids('where:exists(n.group) OR exists(n.type) OR exists (n.instance)')
#> Warning: NAs introduced by coercion to integer64 range
allg=mcns_predict_group(tig_ids, method = 'all')
# neurons where the recorded group and instance group disagree
allg %>% filter(!is.na(group) & !is.na(instance_group) & group!=instance_group)
#>   bodyid post pre downstream upstream synweight          flywireType group
#> 1  28195  661 133        987      661      1648        CB1761,CB2741 28195
#> 2  52953  751 137        981      751      1732        CB1761,CB2741 28195
#> 3 129990  759 147       1150      759      1909        CB1761,CB2741 28195
#> 4  41250  870 158       1125      870      1995        CB1761,CB2741 28195
#> 5  46029  736 151       1053      736      1789        CB1761,CB2741 28195
#> 6  48918  787 434       3227      787      4014 CB1159,CB2015,CB2669 48918
#> 7  49406  741 471       3117      741      3858 CB1159,CB2015,CB2669 48918
#>   hemibrainType    name       itoleeHl somaSide    statusLabel   superclass
#> 1          <NA> 28915_L LALa1_anterior        L Roughly traced cb_intrinsic
#> 2          <NA> 28915_L LALa1_anterior        L Roughly traced cb_intrinsic
#> 3          <NA> 28915_L LALa1_anterior        L Roughly traced cb_intrinsic
#> 4          <NA> 28915_R LALa1_anterior        R Roughly traced cb_intrinsic
#> 5          <NA> 28915_R LALa1_anterior        R Roughly traced cb_intrinsic
#> 6          <NA> 48919_L           LHp2        L Roughly traced cb_intrinsic
#> 7          <NA> 48919_R           LHp2        R Roughly traced cb_intrinsic
#>   supertype type class entryNerve fruDsx matchingNotes rootSide assignedOlHex1
#> 1     23508 <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 2     23508 <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 3     23508 <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 4     23508 <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 5     23508 <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 6     18606 <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#> 7     18606 <NA>  <NA>       <NA>   <NA>          <NA>     <NA>             NA
#>   assignedOlHex2 mancBodyid mancGroup mancType somaNeuromere subclass trumanHl
#> 1             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 2             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 3             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 4             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 5             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 6             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#> 7             NA         NA        NA     <NA>          <NA>     <NA>     <NA>
#>   dimorphism synonyms birthtime mancSerial mcnsSerial exitNerve serialMotif
#> 1       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 2       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 3       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 4       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 5       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 6       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#> 7       <NA>     <NA>      <NA>         NA         NA      <NA>        <NA>
#>   receptorType      somaLocation tosomaLocation status totalNtPredictions
#> 1         <NA> 66620,24888,15730                Traced                133
#> 2         <NA> 65254,26033,14863                Traced                137
#> 3         <NA> 65850,24844,15111                Traced                147
#> 4         <NA> 30730,36422,22418                Traced                158
#> 5         <NA> 30920,37020,23082                Traced                151
#> 6         <NA> 68976,14832,32846                Traced                434
#> 7         <NA> 28544,10466,32448                Traced                471
#>   predictedNtConfidence   predictedNt celltypeTotalNtPredictions
#> 1             0.8200724          gaba                        133
#> 2             0.8341187          gaba                        137
#> 3             0.7992291          gaba                        147
#> 4             0.8392468          gaba                        158
#> 5             0.7578290          gaba                        151
#> 6             0.8384565 acetylcholine                        434
#> 7             0.6560721 acetylcholine                        471
#>   celltypePredictedNt celltypePredictedNtConfidence   consensusNt    voxels
#> 1             unclear                            NA          gaba 229963626
#> 2             unclear                            NA          gaba 248926814
#> 3             unclear                            NA          gaba 241019652
#> 4             unclear                            NA          gaba 297966845
#> 5             unclear                            NA          gaba 271122994
#> 6             unclear                            NA acetylcholine 457493970
#> 7             unclear                            NA acetylcholine 485994463
#>   soma instance_group type_group mancGroup_group pmanc_group
#> 1 TRUE          28915         NA              NA       28195
#> 2 TRUE          28915         NA              NA       28195
#> 3 TRUE          28915         NA              NA       28195
#> 4 TRUE          28915         NA              NA       28195
#> 5 TRUE          28915         NA              NA       28195
#> 6 TRUE          48919         NA              NA       48918
#> 7 TRUE          48919         NA              NA       48918
# }
if (FALSE) { # \dontrun{
# neurons where the recorded group and type group disagree
type_group_mismatch <- allg %>% filter(!is.na(group) & !is.na(type_group) & group!=type_group)
allg %>%
  filter(group %in% type_group_mismatch$group | type_group %in% type_group_mismatch$type_group) %>%
 select(bodyid, type, name, group, type_group, instance_group) %>%
 arrange(type, group) %>% View
} # }
```
