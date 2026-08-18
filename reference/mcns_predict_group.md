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
  [`mcns_ids`](https://natverse.org/malecns/reference/mcns_ids.md). If
  you have a metadata dataframe as returned by
  [`mcns_neuprint_meta`](https://natverse.org/malecns/reference/mcns_neuprint_meta.md)
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
[`mcns_neuprint_meta`](https://natverse.org/malecns/reference/mcns_neuprint_meta.md)
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

[`mcns_predict_type`](https://natverse.org/malecns/reference/mcns_predict_type.md)

## Examples

``` r
# \donttest{
library(dplyr)
# return all body ids with a group type or instance
tig_ids=mcns_ids('where:exists(n.group) OR exists(n.type) OR exists (n.instance)')
allg=mcns_predict_group(tig_ids, method = 'all')
# neurons where the recorded group and instance group disagree
allg %>% filter(!is.na(group) & !is.na(instance_group) & group!=instance_group)
#>   bodyid post pre downstream upstream synweight assignedOlHex1 assignedOlHex2
#> 1 129990  759 147       1150      759      1909             NA             NA
#> 2  28195  661 133        987      661      1648             NA             NA
#> 3  52953  751 137        981      751      1732             NA             NA
#> 4  41250  870 158       1125      870      1995             NA             NA
#> 5  46029  736 151       1053      736      1789             NA             NA
#> 6  49406  741 471       3117      741      3858             NA             NA
#> 7  48918  787 434       3227      787      4014             NA             NA
#>            flywireType group    name somaSide    statusLabel   superclass type
#> 1        CB1761,CB2741 28195 28915_L        L Roughly traced cb_intrinsic <NA>
#> 2        CB1761,CB2741 28195 28915_L        L Roughly traced cb_intrinsic <NA>
#> 3        CB1761,CB2741 28195 28915_L        L Roughly traced cb_intrinsic <NA>
#> 4        CB1761,CB2741 28195 28915_R        R Roughly traced cb_intrinsic <NA>
#> 5        CB1761,CB2741 28195 28915_R        R Roughly traced cb_intrinsic <NA>
#> 6 CB1159,CB2015,CB2669 48918 48919_R        R Roughly traced cb_intrinsic <NA>
#> 7 CB1159,CB2015,CB2669 48918 48919_L        L Roughly traced cb_intrinsic <NA>
#>          vfbId hemibrainType       itoleeHl supertype birthtime mancBodyid
#> 1 VFB_jrmc3k51          <NA> LALa1_anterior     23508      <NA>         NA
#> 2 VFB_jrmc3k4k          <NA> LALa1_anterior     23508      <NA>         NA
#> 3 VFB_jrmc3k4l          <NA> LALa1_anterior     23508      <NA>         NA
#> 4 VFB_jrmc3k7b          <NA> LALa1_anterior     23508      <NA>         NA
#> 5 VFB_jrmc3kfg          <NA> LALa1_anterior     23508      <NA>         NA
#> 6 VFB_jrmc3kam          <NA>           LHp2     18606      <NA>         NA
#> 7 VFB_jrmc3k9m          <NA>           LHp2     18606      <NA>         NA
#>   mancGroup mancType subclass synonyms class rootSide somaNeuromere trumanHl
#> 1        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 2        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 3        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 4        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 5        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 6        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#> 7        NA     <NA>     <NA>     <NA>  <NA>     <NA>          <NA>     <NA>
#>   dimorphism matchingNotes entryNerve mancSerial mcnsSerial serialMotif fruDsx
#> 1       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 2       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 3       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 4       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 5       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 6       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#> 7       <NA>          <NA>       <NA>         NA         NA        <NA>   <NA>
#>   exitNerve receptorType      somaLocation tosomaLocation status
#> 1      <NA>         <NA> 65850,24844,15111                Traced
#> 2      <NA>         <NA> 66620,24888,15730                Traced
#> 3      <NA>         <NA> 65254,26033,14863                Traced
#> 4      <NA>         <NA> 30730,36422,22418                Traced
#> 5      <NA>         <NA> 30920,37020,23082                Traced
#> 6      <NA>         <NA> 28544,10466,32448                Traced
#> 7      <NA>         <NA> 68976,14832,32846                Traced
#>   totalNtPredictions predictedNtConfidence   predictedNt
#> 1                147             0.7991717          gaba
#> 2                133             0.8200117          gaba
#> 3                137             0.8340546          gaba
#> 4                158             0.8391827          gaba
#> 5                151             0.7577716          gaba
#> 6                471             0.6562392 acetylcholine
#> 7                434             0.8387030 acetylcholine
#>   celltypeTotalNtPredictions celltypePredictedNt celltypePredictedNtConfidence
#> 1                        147             unclear                            NA
#> 2                        133             unclear                            NA
#> 3                        137             unclear                            NA
#> 4                        158             unclear                            NA
#> 5                        151             unclear                            NA
#> 6                        471             unclear                            NA
#> 7                        434             unclear                            NA
#>     consensusNt    voxels locationType soma instance_group type_group
#> 1          gaba 241019652           NA TRUE          28915         NA
#> 2          gaba 229963626           NA TRUE          28915         NA
#> 3          gaba 248926814           NA TRUE          28915         NA
#> 4          gaba 297966845           NA TRUE          28915         NA
#> 5          gaba 271122994           NA TRUE          28915         NA
#> 6 acetylcholine 485994463           NA TRUE          48919         NA
#> 7 acetylcholine 457493970           NA TRUE          48919         NA
#>   mancGroup_group pmanc_group
#> 1              NA       28195
#> 2              NA       28195
#> 3              NA       28195
#> 4              NA       28195
#> 5              NA       28195
#> 6              NA       48918
#> 7              NA       48918
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
