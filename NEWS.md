# malecns (development version)

# malecns 0.3.6

* fix plotting transforms and switch to version 2 provided by @schlegelp

# malecns 0.3.5

* Improved malecns bridging xform + plotting xform by @jefferis in https://github.com/flyconnectome/malecns/pull/30

**Full Changelog**: https://github.com/flyconnectome/malecns/compare/v0.3.4...v0.3.5

# malecns 0.3.4

* add malecns vnc neuropil surface
* fix soma side test

# malecns 0.3.3

* prefer manc types for ANs + SAs by @jefferis in https://github.com/flyconnectome/malecns/pull/28
* Give `mcns_somapos()` an `as_character` argument (closes #27)
* Specify roi args for `mcns_connection_table()` (ccfb930b79692fb268243f9b759f8cf360f98476)
* more examples for `mcns_ids()` & `mcns_neuprint_meta()`
* extra protection against duplicate columns (b58f6ca730a3cbac6c7e8c50b804bf1dff65eb50)
    * some functions don't like these
    * managed to get this with a `fru/dsx` and `fru_dsx` column in clio

**Full Changelog**: https://github.com/flyconnectome/malecns/compare/v0.3.2...v0.3.3

# malecns 0.3.2

* updates to reflect renaming of class field to superclass 
  by @jefferis in https://github.com/flyconnectome/malecns/pull/25
* fix schema validation error due to format change 
  by @jefferis in https://github.com/flyconnectome/malecns/pull/24

# malecns 0.3.1

* add `mcns_islatest()` (dbe8243)
* give `mcns_predict_type()` an option to predict/prefer a foreign type e.g. 
  flywireType (390e1b5)
* move dataset choice to malevnc (ba01be5)
* Updates as malevnc package supports manc:v1.0 by @jefferis in 
  https://github.com/flyconnectome/malecns/pull/15
* Define malecns groups from manc matches (and use this for clustering) by 
  @jefferis in https://github.com/flyconnectome/malecns/pull/18
* fix bug introduced by changes in glue v1.8.0 (c30d8a7)
* fix mcns_predict_group_manc when no matched bodyids (#20)
* fix: use mcns_ids not manc_ids in mcns_annotate_body (aa252e9)
* fix stop mcns_predict_manc failing when no matches (b3252a1)
* fix: bodyids in mcns_annotate_body must be numeric (957adb34)
* support manc_ids > 32 bit ints (f8cf90de)
* fix: Pass on ... in mcns_neuprint_meta (3c7e72d)
* Update support for recording clio user information (c4951002)
* add cns vnc mesh (5ce3af8, 93f5294)
* harden schema check fn to fix `mcns_annotate_body()` (fc79d2d)

**Full Changelog**: https://github.com/flyconnectome/malecns/compare/v0.3.0...v0.3.1

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
