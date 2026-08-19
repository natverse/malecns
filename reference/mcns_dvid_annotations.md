# Return all DVID body annotations

Return all DVID body annotations

## Usage

``` r
mcns_dvid_annotations(
  ids = NULL,
  node = "neutu",
  rval = c("data.frame", "list"),
  columns_show = NULL,
  cache = FALSE,
  ...
)
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.html)

- node:

  A DVID node as returned by
  [`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html).
  The default is to return the current active (unlocked) node being used
  through neutu.

- rval:

  Whether to return a fully parsed data.frame (the default) or an R
  list. The data.frame is easier to work with but typically includes NAs
  for many values that would be missing in the list.

- columns_show:

  Whether to show all columns, or just with '\_user', or '\_time'
  suffix. Accepted options are: 'user', 'time', 'all'.

- cache:

  Whether to cache the result of this call for 5 minutes.

- ...:

  Additional arguments passed to
  [`pblapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

## Value

A `tibble` containing with columns including

- bodyid as a `numeric` value

- status

- user

- naming_user

- instance

- status_user

- comment

NB only one `bodyid` is used regardless of whether the key-value
returned has 0, 1 or 2 bodyid fields. When the `ids` are specified,
missing ids will have a row containing the `bodyid` in question and then
all other columns will be `NA`.

## Details

See [this Slack
post](https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1619201195032400)
from Stuart Berg for details.

Note that the original api call was `<rootuuid>:master`, but I have now
just changed this to `<neutu-uuid>` as returned by
[`manc_dvid_node`](https://natverse.org/malevnc/reference/manc_dvid_node.html).
This was because the range query stopped working 16 May 2021, probably
because of a bad node.

## See also

Other annotations:
[`mcns_body_annotations()`](https://natverse.org/malecns/reference/mcns_body_annotations.md),
[`mcns_neuprint_meta()`](https://natverse.org/malecns/reference/mcns_neuprint_meta.md),
[`mcns_soma_side()`](https://natverse.org/malecns/reference/mcns_soma_side.md)

## Examples

``` r
# \donttest{
mda=mcns_dvid_annotations()
head(mda)
#> # A tibble: 6 × 49
#>   bodyid birthtime celltype_predicted_nt celltype_predicted_nt_confidence
#>    <dbl> <chr>     <chr>                                            <dbl>
#> 1  10001 early     acetylcholine                                    0.528
#> 2  10002 NA        acetylcholine                                    0.956
#> 3  10003 early     gaba                                             0.875
#> 4  10005 early     gaba                                             0.831
#> 5  10006 NA        acetylcholine                                    0.820
#> 6  10009 NA        gaba                                             0.866
#> # ℹ 45 more variables: celltype_total_nt_predictions <int>, consensus_nt <chr>,
#> #   flywire_type <chr>, group <int>, hemibrain_type <chr>, instance <chr>,
#> #   itolee_hl <chr>, manc_bodyid <dbl>, manc_group <int>, manc_type <chr>,
#> #   predicted_nt <chr>, predicted_nt_confidence <dbl>, soma_side <chr>,
#> #   status <chr>, subclass <chr>, superclass <chr>, synonyms <chr>,
#> #   total_nt_predictions <int>, type <chr>, vfb_id <chr>, notes <chr>,
#> #   supertype <chr>, user <chr>, halfbrain_body <dbl>, class <chr>, …
plot(table(mda$type), ylab='Frequency')


kcs=mcns_dvid_annotations("/KC.*")
mbons=mcns_dvid_annotations("/MBON.+")

head(mbons)
#> # A tibble: 6 × 49
#>   bodyid birthtime celltype_predicted_nt celltype_predicted_nt_confidence
#>    <dbl> <chr>     <chr>                                            <dbl>
#> 1 520151 early     glutamate                                        0.713
#> 2  10013 early     glutamate                                        0.713
#> 3 522749 early     glutamate                                        0.740
#> 4 522444 early     glutamate                                        0.740
#> 5 519373 early     glutamate                                        0.767
#> 6 521526 early     glutamate                                        0.767
#> # ℹ 45 more variables: celltype_total_nt_predictions <int>, consensus_nt <chr>,
#> #   flywire_type <chr>, group <int>, hemibrain_type <chr>, instance <chr>,
#> #   itolee_hl <chr>, manc_bodyid <dbl>, manc_group <int>, manc_type <chr>,
#> #   predicted_nt <chr>, predicted_nt_confidence <dbl>, soma_side <chr>,
#> #   status <chr>, subclass <chr>, superclass <chr>, synonyms <chr>,
#> #   total_nt_predictions <int>, type <chr>, vfb_id <chr>, notes <chr>,
#> #   supertype <chr>, user <chr>, halfbrain_body <dbl>, class <chr>, …
# }
```
