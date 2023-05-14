# malecns (development version)

# malecns 0.3

* add `mcns_cosine_plot()` for within dataset connectivity clustering (works nicely across hemispheres)
* add `mcns_body_annotations()` to get clio annotations (may contain fields not 
  in neuprint; immediately visible).
* add `mcns_annotate_body()` to set annotations via clio (now strongly recommended)
* add `mcns_set_dvid_annotations()` (already deprecated)
* export `export mcns_ids()`
* add `mirror_malecns()`, `mcns_xyz()`, `mcns_somapos()`
* add `mcns_predict_type()` to get best guess at cell type across type/instance
* add mcns_predict_type() to get best guess at cell type across type/instance
* mcns_dvid_annotations supports an option of adding extra suffix columns by @dokato in https://github.com/flyconnectome/malecns/pull/4
* Display group in connection table results by @jefferis in https://github.com/flyconnectome/malecns/pull/9
* mcns_annotate_body function added by @dokato in https://github.com/flyconnectome/malecns/pull/13
* Fix/dataset clash by @jefferis in https://github.com/flyconnectome/malecns/pull/14

## New Contributors
* @dokato made their first contribution in https://github.com/flyconnectome/malecns/pull/4

**Full Changelog**: https://github.com/flyconnectome/malecns/compare/v0.2.0...v0.3

# malecns 0.2.0

* Add transforms for malecns and malehb by @jefferis in #2
* fix `read_mcns_meshes()` for static and on the fly meshes
* add `read_mcns_neurons()`
* add `mcns_dvid_annotations()` and `mcns_neuprint_meta()`
* fix `mcns_connection_table()`
* dev: test infrastructure, pkgdown

[Full Changelog](https://github.com/flyconnectome/malecns/compare/v0.1.2...v0.2.0)

# malecns 0.1.2

* Export and fix `dr_malencs()`.

# malecns 0.1.1

* Added `dr_malencs()` and made package load more forgiving to avoid install 
  issues.
* Added a `NEWS.md` file to track changes to the package.

# malecns 0.1.0

* first released version
