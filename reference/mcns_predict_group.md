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
#> Error in check_dataset(conn = conn): Specified dataset: `male-cns:v0.9` does not match those provided by your neuPrint connection:
#>   male-cns:v1.0, optic-lobe:v1.1, manc:v1.2.3, manc:v1.2.1, optic-lobe:v1.0.1, manc:v1.0, hemibrain:v1.2.1, hemibrain:v1.1, fib19:v1.0, mushroombody
#> See ?neuprint_login for details.
allg=mcns_predict_group(tig_ids, method = 'all')
#> Error: object 'tig_ids' not found
# neurons where the recorded group and instance group disagree
allg %>% filter(!is.na(group) & !is.na(instance_group) & group!=instance_group)
#> Error: object 'allg' not found
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
