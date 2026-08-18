# Package index

## Package overview, setup and general functions

- [`malecns`](https://flyconnectome.github.io/malecns/reference/malecns-package.md)
  [`malecns-package`](https://flyconnectome.github.io/malecns/reference/malecns-package.md)
  : malecns: Access to the latest 'Janelia FlyEM' datasets

- [`dr_malecns()`](https://flyconnectome.github.io/malecns/reference/dr_malecns.md)
  : Situation report on your malecns package installation

- [`choose_mcns_dataset()`](https://flyconnectome.github.io/malecns/reference/choose_mcns_dataset.md)
  :

  Switch the default dataset for `mcns_*` functions

- [`with_mcns()`](https://flyconnectome.github.io/malecns/reference/with_mcns.md)
  [`choose_mcns()`](https://flyconnectome.github.io/malecns/reference/with_mcns.md)
  : Evaluate an expression after temporarily setting malevnc options

- [`mcns_scene()`](https://flyconnectome.github.io/malecns/reference/mcns_scene.md)
  : Construct a neuroglancer scene for CNS dataset

## Specify and check body ids

- [`mcns_ids()`](https://flyconnectome.github.io/malecns/reference/mcns_ids.md)
  : Get Male CNS ids in standard formats
- [`mcns_islatest()`](https://flyconnectome.github.io/malecns/reference/mcns_islatest.md)
  : Check if a bodyid still exists in the specified malecns DVID node
- [`mcns_xyz2bodyid()`](https://flyconnectome.github.io/malecns/reference/mcns_xyz2bodyid.md)
  : Map XYZ locations to bodyids for the male cns dataset

## Neuprint queries including connectivity

- [`mcns_neuprint()`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint.md)
  : Login to male CNS neuprint server
- [`mcns_neuprint_meta()`](https://flyconnectome.github.io/malecns/reference/mcns_neuprint_meta.md)
  : Fetch neuprint metadata for malecns neurons
- [`mcns_connection_table()`](https://flyconnectome.github.io/malecns/reference/mcns_connection_table.md)
  : Connectivity query for CNS neurons
- [`mcns_cosine_plot()`](https://flyconnectome.github.io/malecns/reference/mcns_cosine_plot.md)
  : Cosine plot
- [`mcns_predict_group()`](https://flyconnectome.github.io/malecns/reference/mcns_predict_group.md)
  : Predict the group of neurons using instance or type information
- [`mcns_predict_type()`](https://flyconnectome.github.io/malecns/reference/mcns_predict_type.md)
  : Predict the cell type of male cns neurons from type and
  name/instance fields
- [`mcns_soma_side()`](https://flyconnectome.github.io/malecns/reference/mcns_soma_side.md)
  [`mcns_somapos()`](https://flyconnectome.github.io/malecns/reference/mcns_soma_side.md)
  : Find/predict the soma side or position of male cns neurons.

## Neuron skeletons and meshes

- [`read_mcns_meshes()`](https://flyconnectome.github.io/malecns/reference/read_mcns_meshes.md)
  : Read a mesh for the current segmentation
- [`read_mcns_neurons()`](https://flyconnectome.github.io/malecns/reference/read_mcns_neurons.md)
  : Read neuronal skeletons via neuprint

## Clio/DVID Annotations

- [`mcns_annotate_body()`](https://flyconnectome.github.io/malecns/reference/mcns_annotate_body.md)
  : Set Clio body annotations
- [`mcns_body_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_body_annotations.md)
  : Return neurojson body annotations via the Clio interface
- [`mcns_dvid_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_dvid_annotations.md)
  : Return all DVID body annotations
- [`mcns_set_dvid_annotations()`](https://flyconnectome.github.io/malecns/reference/mcns_set_dvid_annotations.md)
  : Set the DVID type, instance or group for some malecns neurons

## Geometry and neuropil meshes

- [`mirror_malecns()`](https://flyconnectome.github.io/malecns/reference/mirror_malecns.md)
  : Mirror points in malecns space
- [`malecns_shell.surf`](https://flyconnectome.github.io/malecns/reference/malecns.surf.md)
  [`malecns.surf`](https://flyconnectome.github.io/malecns/reference/malecns.surf.md)
  [`JRCFIB2022M.surf`](https://flyconnectome.github.io/malecns/reference/malecns.surf.md)
  [`malecnsvnc_shell.surf`](https://flyconnectome.github.io/malecns/reference/malecns.surf.md)
  [`malecnsvnc.surf`](https://flyconnectome.github.io/malecns/reference/malecns.surf.md)
  : Surface models of the malecns brain (in nm)
