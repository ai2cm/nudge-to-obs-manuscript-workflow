# nudge-to-obs-manuscript-workflow
Code and configuration to generate the data and figures in Watt-Meyer et al. (2021) "Correcting weather and climate models by machine learning nudged historical simulations".

![Nudging schematic](notebooks/figure1.png)
Figure 1 of Watt-Meyer et al. (2021).

## Overview
The purpose of the repository is to consolidate all of the code used to generate the results in Watt-Meyer et al. (2021) in one place. This may be helpful for readers of that manuscript to understand the tools and details of the method. However, it is not expected that the code here will be easily useable by the public since it uses specific cloud computing resources provisioned for the Vulcan Climate Modeling group.

Describe fv3net repo briefly.

Add note about fv3gfs-wrapper (which is a public-facing tool).

## Repository tree
```
├── fv3net                                     Submodule of fv3net repository.
├── LICENSE
├── Makefile                                   Rules to submit workflows.
├── notebooks                                  Generate manuscript figures.
├── README.md
└── workflow                                   Configuration of workflows.
    ├── baseline-run
    ├── kustomization.yaml
    ├── nudge-to-obs-run
    ├── prognostic-run-report
    ├── train-evaluate-prognostic-run
    └── weather-forecasts
```

## Dependencies

The workflows in this repository are written using [argo](https://argoproj.github.io/projects/argo) and are designed to run on a [Kubernetes](https://kubernetes.io) cluster. The workflows do disparate things such as run the FV3GFS model, train machine learning models and compute diagnostics related to the performance of the ML models and FV3GFS simulations. They all output data to the Vulcan Climate Modeling group's Google Cloud Storage.

The notebooks generate figures for the manuscript using the output on Google Cloud Storage from the argo workflows.

## Directed Acyclic Graph (DAG)

Causal dependencies of various workflows (grey ovals) and notebooks (white ovals):

![DAG](dag.png)

