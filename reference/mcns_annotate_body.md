# Set Clio body annotations

Set Clio body annotations

## Usage

``` r
mcns_annotate_body(
  x,
  test = FALSE,
  version = NULL,
  write_empty_fields = FALSE,
  designated_user = NULL,
  protect = c("user"),
  chunksize = 50,
  check_types = TRUE,
  dry_run = TRUE,
  ...
)
```

## Arguments

- x:

  A data.frame, list or JSON string containing body annotations. **End
  users are strongly recommended to use data.frames.**

- test:

  Whether to use the test clio store. Default `FALSE` writes to
  production Clio. See
  [`manc_annotate_body`](https://natverse.org/malevnc/reference/manc_annotate_body.html).

- version:

  Optional clio version to associate with this annotation. The default
  `NULL` uses the current version returned by the API.

- write_empty_fields:

  When `x` is a data.frame, this controls whether empty fields in `x`
  (i.e. `NA` or `""`) overwrite fields in the clio-store database (when
  they are not protected by the `protect` argument). The (conservative)
  default `write_empty_fields=FALSE` does not overwrite. If you do want
  to set fields to an empty value (usually the empty string) then you
  must set `write_empty_fields=TRUE`.

- designated_user:

  Optional email address when one person is uploading annotations on
  behalf of another user. See **Users** section for details.

- protect:

  Vector of fields that will not be overwritten if they already have a
  value in clio store. Set to `TRUE` to protect all fields and to
  `FALSE` to overwrite all fields for which you provide data. See
  details for the rational behind the default value of "user"

- chunksize:

  When you have many bodies to annotate the request will by default be
  sent 50 records at a time to avoid any issue with timeouts. You can
  increase for a small speed up if you find your setup is fast enough.
  Set to `Inf` to insist that all records are sent in a single request.
  **NB only applies when `x` is a data.frame**.

- check_types:

  Whether or not it should verify types of columns.

- dry_run:

  When `TRUE` (the default) no data is written; a preview tibble of the
  POST body is returned. Pass `dry_run = FALSE` to actually write. See
  [`manc_annotate_body`](https://natverse.org/malevnc/reference/manc_annotate_body.html)
  for full details.

- ...:

  Additional parameters passed to
  [`pbsapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

## Value

`NULL` invisibly on success. Errors out on failure.

## Details

Details of Clio body annotation system are provided in [basic docs from
Bill
Katz](https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit).
Each body has an associated JSON list containing a set of standard user
visible fields. Some of these are constrained. See [Clio fields Google
sheet](https://docs.google.com/spreadsheets/d/1v8AltqyPCVNIC_m6gDNy6IDK10R6xcGkKWFxhmvCpCs/edit?usp=sharing)
for details.

It can take some time to apply annotations, so requests are chunked by
default in groups of 50.

A single column called `position` or 3 columns names x, y, z or X, Y, Z
in any form accepted by
[`xyzmatrix`](https://rdrr.io/pkg/nat/man/xyzmatrix.html) will be
converted to a position stored with each record. This is recommended
when creating records.

When `protect=TRUE` no data in Clio will be overwritten - only new data
will be added. When `protect=FALSE` all fields will overwritten by new
data for each non-empty value in `x`. If `write_empty_fields=TRUE` then
even empty fields in `x` will overwrite fields in the database. Note
that these conditions apply per record i.e. per neuron not per column of
data.

## Validation

Validation depends on how you provide your input data. If `x` is a
data.frame then each row is checked for some basics including the
presence of a bodyid, and empty fields are removed. In future we will
also check fields which are only allowed to take certain values.

When `x` is a character vector, it is checked to see that it is valid
JSON and that there is a bodyid field for each record. This intended
principally for developer use or to confirm that a specific JSON payload
has been applied. You probably should not be using it regularly or for
bulk upload.

When `x` is a list, no further validation occurs.

For these reasons, **it is strongly recommended that end users provide
`data.frame` input**.

## Users

Clio now records a user and timestamp for every modification to the
fields in a record. For example if you edit the `type` field then then a
`type_user` field will be filled with the email address that you use to
authenticate to Clio. By default *your* email address will be used since
this is contained within your clio token. You can also specify an
alternate user with the `designated_user` argument. See the
[`manc_annotate_body`](https://natverse.org/malevnc/reference/manc_annotate_body.html)
documentation for further details.

## Examples

``` r
if (FALSE) { # \dontrun{
# note use of test server
mcns_annotate_body(data.frame(bodyid=10005, group=10005), test=TRUE)
} # }
```
