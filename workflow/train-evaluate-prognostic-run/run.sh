#!/bin/bash

set -e

NAME=$1
EXPERIMENT=2020-10-30-nudge-to-obs-GRL-paper/$NAME

if [[ "$NAME" == "rf-control" ]]; then
    TRAINING_CONFIG="training-config.yaml"
elif [[ "$NAME" == "rf-dQ1-dQ2-only" ]]; then
    TRAINING_CONFIG="training-config-dQ1-dQ2-only.yaml"
else
    echo "Configuration not defined for ${NAME}"
    exit 1
fi

argo submit \
    --from workflowtemplate/train-diags-prog \
    -p root=gs://vcm-ml-experiments/$EXPERIMENT \
    -p train-test-data=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/nudge-to-obs-run-3hr-diags \
    -p training-config="$(< ${TRAINING_CONFIG})" \
    -p reference-restarts=gs://vcm-ml-experiments/2020-06-02-fine-res/coarsen_restarts \
    -p initial-condition="20160101.000000" \
    -p prognostic-run-config="$(< prognostic-run.yaml)" \
    -p train-times="$(<  train_times.json)" \
    -p test-times="$(<  test_times.json)" \
    -p public-report-output=gs://vcm-ml-public/offline_ml_diags/$EXPERIMENT \
    -p segment-count=12 \
    -p cpu-prog=6 \
    -p memory-prog="10Gi" \
    -p flags="--nudge-to-observations" \
    -p chunks="$(< chunks.yaml)"

