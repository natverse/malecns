# TRUE when we can authenticate against Clio, so live tests can skip gracefully
# when no (valid) CLIO_TOKEN is available (e.g. in CI).
has_clio <- function() {
  tryCatch({
    malevnc::clio_token()
    TRUE
  }, error = function(e) FALSE)
}
