#!/bin/bash

set -e

MODELS="rf-control rf-dQ1-dQ2-only"
DATA_PATH=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/nudge-to-obs-run-3hr-diags

for MODEL in $MODELS; do
    if [[ "$MODEL" == "rf-control" ]]; then
        TRAINING_CONFIG="training-config.yaml"
    elif [[ "$MODEL" == "rf-dQ1-dQ2-only" ]]; then
        TRAINING_CONFIG="training-config-dQ1-dQ2-only.yaml"
    fi

    argo submit \
        --from workflowtemplate/offline-diags \
        -p ml-model=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/${MODEL}/trained_model \
        -p data-path=$DATA_PATH \
        -p config="$(< $TRAINING_CONFIG)" \
        -p times="$(<  ../../test.json)" \
        -p report-output=gs://vcm-ml-public/offline_ml_diags/2020-10-30-nudge-to-obs-GRL-paper/${MODEL}-redo-v2 \
        -p offline-diags-output=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/${MODEL}/offline_diags-redo-v2
done



