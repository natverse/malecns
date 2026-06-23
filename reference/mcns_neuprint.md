# Login to male CNS neuprint server

Login to male CNS neuprint server

## Usage

``` r
mcns_neuprint(
  token = Sys.getenv("neuprint_token"),
  dataset = NULL,
  Force = FALSE,
  ...
)
```

## Arguments

- token:

  Optional neuprint access token (see details and examples if you have
  trouble with multiple tokens).

- dataset:

  Allows you to override the neuprint dataset (which will otherwise be
  chosen based on the value of `options(malecns.dataset)` which would
  normally be changed by using the function
  [`choose_mcns_dataset`](https://natverse.org/malecns/reference/choose_mcns_dataset.md))

- Force:

  Whether to force a new login to the CATMAID server (default `FALSE`)

- ...:

  Additional arguments passed to `neuprint_login`

## Value

a `neuprint_connection` object returned by `neuprint_login`

## Details

It should be possible to use the same token across public and private
neuprint servers if you are using the same email address. However this
does not seem to work for all users. Before giving up on this, do try
using the *most* recently issued token from a private server (e.g. cns
dataset) rather than older tokens e.g. for hemibrain dataset. If you
need to pass a specific token you can use the `token` argument, also
setting `Force=T` to ensure that the specified token is used if you have
already tried to log in during the current session. See examples for
code.

## Examples

``` r
if (FALSE) { # \dontrun{
cnsc=mcns_neuprint()

# log in using specified token rather than the one in the neuprint_token
# environment variable. This should then be cached for the rest of the R
# session.
cnsc=mcns_neuprint(token="XXX", Force=T)

anchorids <- neuprintr::neuprint_ids("status:Anchor", conn=cnsc)
# the last connection will be used by default
anchormeta <- neuprintr::neuprint_get_meta("status:Anchor")

plot(cumsum(sort(anchormeta$pre, decreasing = TRUE)), ylab='Cumulative presynapses')
plot(cumsum(sort(anchormeta$post, decreasing = TRUE)), ylab='Cumulative postsynapses')
} # }
```
