#!/bin/bash

set -e

OUTPUT=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/baseline-run-2016
MODEL_URL=gs://vcm-ml-scratch/test-end-to-end-integration/integration-test-2c1ba84b1350/trained_model

# submit baseline run year-long run
argo submit \
    --from workflowtemplate/prognostic-run \
    -p output=$OUTPUT \
    -p reference-restarts=gs://vcm-ml-experiments/2020-06-02-fine-res/coarsen_restarts \
    -p initial-condition="20160101.000000" \
    -p config="$(< baseline-run.yaml)" \
    -p segment-count="12" \
    -p memory="10Gi" \
    -p chunks="$(< chunks.yaml)" \
    -p flags="--nudge-to-observations --diagnostic_ml --model_url ${MODEL_URL}"
