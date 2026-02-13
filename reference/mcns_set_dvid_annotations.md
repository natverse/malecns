# Set the DVID type, instance or group for some malecns neurons

Set the DVID type, instance or group for some malecns neurons

## Usage

``` r
mcns_set_dvid_annotations(
  ids,
  type = NULL,
  group = NULL,
  synonyms = NULL,
  side = NULL,
  instance = T,
  user = getOption("malevnc.dvid_user"),
  ...
)
```

## Arguments

- ids:

  Body ids

- type:

  Character vector specifying an authoritative cell type e.g.
  `"LHAD1g1"` from the hemibrain.

- group:

  One or more LR groups (i.e. candidate cell types) to apply. These
  should normally be the lowest bodyid of the group. Must be the same
  length as `ids` unless it has length 1.

- synonyms:

  Character vector specifying cell type e.g. "LHAD1g1"

- side:

  Character vector specifying the side of each neuron (`"L", "R"`, `"M"`
  for midline, or `""` when it cannot be specified).

- instance:

  Character vector specifying instances (names) for neurons (see
  details) *or* a logical value where `TRUE` (the default) means to
  append the side to the type.

- user:

  The DVID user. Defaults to `options("malevnc.dvid_user")`.

- ...:

  Additional arguments passed to
  [`malevnc::manc_set_dvid_instance`](https://natverse.org/malevnc/reference/manc_set_dvid_instance.html)
  and thence to
  [`pbapply::pbmapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)
  when there are multiple body ids.

## Details

For the male CNS, the evolving standard seems to be to record the
following fields (examples given for APL)

- `type='APL'`

- `instance='APL_R'`

- `group='APL_R'`

- `type_user, instance_user, group_user='jefferisg'` to accompany all of
  those.

Note that `type_user, instance_user, group_user` will be set
automatically using the `user` argument. Regrettably you cannot
currently specify different users for different different fields (e.g.
one user for `instance` and a different user for `type`). Should you
need to do this (e.g. when making annotations on behalf of other users)
then you will need to make separate calls to `mcns_set_dvid_annotations`
for each field you need set.

To delete an annotation set e.g. `instance=""`. **Be very careful!**.

## Examples

``` r
if (FALSE) { # \dontrun{
mcns_set_dvid_annotations(10297, type = 'LHAD1g1')
mcns_set_dvid_annotations(10977, type='APL', side='L', group = 10540)
# only set the LR group
mcns_set_dvid_annotations(ids=c(13115, 14424), group = 13115)

# unset i.e. remove a type (careful!)
mcns_set_dvid_annotations(18987, type = "", user = "becketti")
} # }
```
