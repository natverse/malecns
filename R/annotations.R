#' Return all DVID body annotations

#' @details See
#'   \href{https://flyem-cns.slack.com/archives/C01BT2XFEEN/p1619201195032400}{this
#'    Slack post} from Stuart Berg for details.
#'
#'   Note that the original api call was \code{<rootuuid>:master}, but I have
#'   now just changed this to \code{<neutu-uuid>} as returned by
#'   \code{\link{manc_dvid_node}}. This was because the range query stopped
#'   working 16 May 2021, probably because of a bad node.
#' @inheritParams malevnc::manc_body_annotations
#' @param rval Whether to return a fully parsed data.frame (the default) or an R
#'   list. The data.frame is easier to work with but typically includes NAs for
#'   many values that would be missing in the list.
#' @param node A DVID node as returned by \code{\link{manc_dvid_node}}. The
#'   default is to return the current active (unlocked) node being used through
#'   neutu.
#' @param cache Whether to cache the result of this call for 5 minutes.
#' @param columns_show Whether to show all columns, or just with '_user', or '_time'
#' suffix. Accepted options are: 'user', 'time', 'all'.
#'
#' @return A \code{tibble} containing with columns including \itemize{
#'
#'   \item bodyid as a \code{numeric} value
#'
#'   \item status
#'
#'   \item user
#'
#'   \item naming_user
#'
#'   \item instance
#'
#'   \item status_user
#'
#'   \item comment }
#'
#'   NB only one \code{bodyid} is used regardless of whether the key-value
#'   returned has 0, 1 or 2 bodyid fields. When the \code{ids} are specified,
#'   missing ids will have a row containing the \code{bodyid} in question and
#'   then all other columns will be \code{NA}.
#'
#' @export
#' @family annotations
#' @examples
#' \donttest{
#' mda=mcns_dvid_annotations()
#' head(mda)
#' plot(table(mda$type), ylab='Frequency')
#'
#' kcs=mcns_dvid_annotations("/KC.*")
#' mbons=mcns_dvid_annotations("/MBON.+")
#'
#' head(mbons)
#' }
mcns_dvid_annotations <- function(ids=NULL, node='neutu',
                                  rval=c("data.frame", "list"),
                                  columns_show = NULL,
                                  cache=FALSE, ...) {
  # because malevnc::manc_dvid_annotations does not pass a connection on to
  # manc_ids
  if(!is.null(ids))
    ids=mcns_ids(ids)
  with_mcns(malevnc::manc_dvid_annotations(ids=ids, node=node,
                                           columns_show=columns_show,
                                           rval=rval,cache=F))
}

#' Set the DVID type, instance or group for some malecns neurons
#'
#' @details For the male CNS, the evolving standard seems to be to record the
#'   following fields (examples given for APL) \itemize{
#'
#'   \item \code{type='APL'}
#'
#'   \item \code{instance='APL_R'}
#'
#'   \item \code{group='APL_R'}
#'
#'   \item \code{type_user, instance_user, group_user='jefferisg'} to accompany
#'   all of those.
#'
#'   }
#'
#'   Note that \code{type_user, instance_user, group_user} will be set
#'   automatically using the \code{user} argument. Regrettably you cannot
#'   currently specify different users for different different fields (e.g. one
#'   user for \code{instance} and a different user for \code{type}). Should you
#'   need to do this (e.g. when making annotations on behalf of other users)
#'   then you will need to make separate calls to
#'   \code{mcns_set_dvid_annotations} for each field you need set.
#'
#'   To delete an annotation set e.g. \code{instance=""}. \bold{Be very
#'   careful!}.
#' @param ids Body ids
#' @param type Character vector specifying an authoritative cell type e.g.
#'   \code{"LHAD1g1"} from the hemibrain.
#' @param side Character vector specifying the side of each neuron (\code{"L",
#'   "R"}, \code{"M"} for midline, or \code{""} when it cannot be specified).
#' @param instance Character vector specifying instances (names) for neurons
#'   (see details) \emph{or} a logical value where \code{TRUE} (the default)
#'   means to append the side to the type.
#' @param synonyms Character vector specifying cell type e.g. "LHAD1g1"
#' @param group One or more LR groups (i.e. candidate cell types) to apply.
#'   These should normally be the lowest bodyid of the group. Must be the same
#'   length as \code{ids} unless it has length 1.
#' @param user The DVID user. Defaults to \code{options("malevnc.dvid_user")}.
#' @param ... Additional arguments passed to
#'   \code{malevnc::manc_set_dvid_instance} and thence to
#'   \code{pbapply::pbmapply} when there are multiple body ids.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' mcns_set_dvid_annotations(10297, type = 'LHAD1g1')
#' mcns_set_dvid_annotations(10977, type='APL', side='L', group = 10540)
#' # only set the LR group
#' mcns_set_dvid_annotations(ids=c(13115, 14424), group = 13115)
#'
#' # unset i.e. remove a type (careful!)
#' mcns_set_dvid_annotations(18987, type = "", user = "becketti")
#' }
mcns_set_dvid_annotations <- function(ids, type=NULL, group=NULL,
                                      synonyms=NULL,  side=NULL, instance=T,
                                      user=getOption("malevnc.dvid_user"), ...) {
  if((isTRUE(instance) || isFALSE(instance)) &&
     is.null(type) && is.null(group) && is.null(synonyms))
    stop("You must specify one of type, group or instance")
  # don't try and autoset instance if we have no type information
  if(isTRUE(instance) && is.null(type))
    instance=FALSE
  if(isTRUE(instance)) {
    if(is.null(side))
      stop("You must specify side information to set instances")
    checkmate::check_character(side, max.chars = 1, any.missing = F, len=1L,
                               ignore.case = F, pattern="^(L|R|M|)$")
    instance=paste0(type, "_", side)
  } else if(isFALSE(instance)) {
    instance=NULL
  }
  if(length(type)>0 || length(instance)>0 || length(synonyms)>0) {
    with_mcns(malevnc::manc_set_dvid_instance(ids, type=type, instance = instance, synonyms=synonyms, user=user, ...))
  }
  if(!is.null(group)) {
    if(length(group)!=length(ids)) {
      if(length(group)!=1)
        stop("group must have length 1 or the same length as ids!")
      group=rep(group, length(ids))
    }
    invisible(with_mcns(pbapply::pbmapply(
      mcns_set_group, id=ids, group=group, user=user)))
  }
}

mcns_set_group <- function(id, group, user) {
  checkmate::checkInt(id, lower=10000L)
  id=as.integer(id)
  l=list(group=group, group_user=user)
  malevnc::manc_set_dvid_annotations(bodyid = id, annlist = l)
}

#' Set Clio body annotations
#'
#' @details Details of Clio body annotation system are provided in
#'   \href{https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit}{basic
#'    docs from Bill Katz}. Each body has an associated JSON list containing a
#'   set of standard user visible fields. Some of these are constrained. See
#'   \href{https://docs.google.com/spreadsheets/d/1v8AltqyPCVNIC_m6gDNy6IDK10R6xcGkKWFxhmvCpCs/edit?usp=sharing}{Clio
#'    fields Google sheet} for details.
#'
#'   It can take some time to apply annotations, so requests are chunked by
#'   default in groups of 50.
#'
#'   A single column called \code{position} or 3 columns names x, y, z or X, Y,
#'   Z in any form accepted by \code{\link{xyzmatrix}} will be converted to a
#'   position stored with each record. This is recommended when creating
#'   records.
#'
#'   When \code{protect=TRUE} no data in Clio will be overwritten - only new
#'   data will be added. When \code{protect=FALSE} all fields will overwritten
#'   by new data for each non-empty value in \code{x}. If
#'   \code{write_empty_fields=TRUE} then even empty fields in \code{x} will
#'   overwrite fields in the database. Note that these conditions apply per
#'   record i.e. per neuron not per column of data.
#'
#' @section Validation: Validation depends on how you provide your input data.
#'   If \code{x} is a data.frame then each row is checked for some basics
#'   including the presence of a bodyid, and empty fields are removed. In future
#'   we will also check fields which are only allowed to take certain values.
#'
#'   When \code{x} is a character vector, it is checked to see that it is valid
#'   JSON and that there is a bodyid field for each record. This intended
#'   principally for developer use or to confirm that a specific JSON payload
#'   has been applied. You probably should not be using it regularly or for bulk
#'   upload.
#'
#'   When \code{x} is a list, no further validation occurs.
#'
#'   For these reasons, \bold{it is strongly recommended that end users provide
#'   \code{data.frame} input}.
#'
#' @section Users: You should record users with the email address that they use
#'   to authenticate to Clio. At present you are responsible for choosing how to
#'   set the two user fields: \itemize{
#'
#'   \item \code{user} This is intended to be the user that first created the
#'   annotation record for a body. At some point they may have some control over
#'   edits.
#'
#'   \item \code{last_modified_by} This is intended to be the user who provided
#'   the last change to a record; in the case of bulk uploads, this should be
#'   the user providing (or at least guaranteeing) the biological insight if at
#'   all possible.
#'
#'   }
#'
#' @param x A data.frame, list or JSON string containing body annotations.
#'   \bold{End users are strongly recommended to use data.frames.}
#' @param version Optional clio version to associate with this annotation. The
#'   default \code{NULL} uses the current version returned by the API.
#' @param test Whether to use the test clio store (recommended until you are
#'   sure you know what you are doing).
#' @param protect Vector of fields that will not be overwritten if they already
#'   have a value in clio store. Set to \code{TRUE} to protect all fields and to
#'   \code{FALSE} to overwrite all fields for which you provide data. See
#'   details for the rational behind the default value of "user"
#' @param write_empty_fields When \code{x} is a data.frame, this controls
#'   whether empty fields in \code{x} (i.e. \code{NA} or \code{""}) overwrite
#'   fields in the clio-store database (when they are not protected by the
#'   \code{protect} argument). The (conservative) default
#'   \code{write_empty_fields=FALSE} does not overwrite. If you do want to set
#'   fields to an empty value (usually the empty string) then you must set
#'   \code{write_empty_fields=TRUE}.
#' @param chunksize When you have many bodies to annotate the request will by
#'   default be sent 50 records at a time to avoid any issue with timeouts. You
#'   can increase for a small speed up if you find your setup is fast enough.
#'   Set to \code{Inf} to insist that all records are sent in a single request.
#'   \bold{NB only applies when \code{x} is a data.frame}.
#' @param check_types Whether or not it should verify types of columns.
#' @param ... Additional parameters passed to \code{pbapply::\link{pbsapply}}
#'
#' @return \code{NULL} invisibly on success. Errors out on failure.
#' @family manc-annotation
#'
#' @importFrom malevnc manc_annotate_body
#' @export
#'
#' @examples
#' \dontrun{
#' # note use of test server
#' mcns_annotate_body(data.frame(bodyid=10005, group=10005), test=TRUE)
#' }
mcns_annotate_body <- function(x, test=TRUE, version=NULL, write_empty_fields=FALSE,
                               protect=c("user"), chunksize=50, check_types = TRUE, ...) {
  if (isTRUE(check_types))
    schema_compare(x)
  with_mcns(
    manc_annotate_body(x, test=test, version=version,
                       write_empty_fields=write_empty_fields,
                       protect=protect, chunksize=chunksize, query=FALSE, ...)
  )
}

# Clio/Dvid DB schema endpoint
.url_clio_schema = function() {
  paste0(servers4dataset('CNS')$dvid,
         "/api/node/:master/segmentation_annotations/json_schema")
}

# allowed types for columns according do Clio schema
TYPES_MAPPING <- list(
  "integer" = c("numeric", "integer", "integer64"),
  "string" = c("character", "factor"),
  "array" = c("list"),
  "boolean" = c("logical")
)

# verifies whether data schema has the right type and throws an informative
# exception if it doesn't
schema_compare <- function(x) {
  types = malevnc:::clio_fetch(.url_clio_schema())
  types = sapply(types$properties, function(x) x$type)
  col_types  = sapply(x, class)
  check_types <- sapply(
    names(col_types),
    function(nm) {
      if (!is.na(types[nm])) {
        col_types[[nm]] %in% TYPES_MAPPING[[types[nm]]]
      } else
        TRUE
    }
  )
  if (isFALSE(all(check_types)))
    stop(
      paste("Wrong types of columns:",
            paste(names(check_types[check_types == FALSE]), collapse = ", "))
    )
}


#' Return neurojson body annotations via the Clio interface
#'
#' @details In comparison with \code{\link{mcns_dvid_annotations}}, this allows
#'   queries for specific bodies. In comparison with
#'   \code{\link{mcns_neuprint_meta}}, it provides access to up to the second
#'   annotations; it is also presently faster than these other two calls.
#'   Compared with \code{\link{mcns_neuprint_meta}}, it does not produce a
#'   stable set of columns, only returning those that exist for the given query
#'   ids.
#'
#' @inheritParams malevnc::manc_body_annotations
#' @return A data.frame with metadata
#' @export
#' @family annotations
#' @examples
#' \donttest{
#' mcns_body_annotations("AOTU019")
#' }
#' \dontrun{
#' mcns.class=mcns_body_annotations(query=list(class="exists/1"))
#' mcns.class %>%
#'   count(class)
#' }
mcns_body_annotations <- function(ids=NULL, query=NULL, json=FALSE, config=NULL,
                                  show.extra = c("none", "user", "time", "all"),
                                  cache=FALSE, test=FALSE, ...) {
  show.extra=match.arg(show.extra)
  with_mcns(malevnc::manc_body_annotations(ids=ids, query=query, json=json, config=config, cache = cache, test=test, show.extra=show.extra, ...))
}
