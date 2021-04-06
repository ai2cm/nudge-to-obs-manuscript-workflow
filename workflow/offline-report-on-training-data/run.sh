#!/bin/bash

NAME=$1
EXPERIMENT=2021-03-15-nudge-to-obs-GRL-paper-rev1/$NAME

if [[ "$NAME" == "rf-control" ]]; then
    TRAINING_CONFIG="../train-evaluate-prognostic-run/training-config.yaml"
    WORKFLOW_NAME="rf-control"
elif [[ "$NAME" == "rf-dQ1-dQ2-only" ]]; then
    TRAINING_CONFIG="../train-evaluate-prognostic-run/training-config-dQ1-dQ2-only.yaml"
    WORKFLOW_NAME="rf-dq1-dq2-only"
else
    echo "Configuration not defined for ${NAME}"
    exit 1
fi

# create offline reports using training data as inputs to check for overfitting
MODEL_URL=gs://vcm-ml-experiments/${EXPERIMENT}/trained_model

argo submit \
    --from workflowtemplate/offline-diags \
    --name n2o-offline-diags-${WORKFLOW_NAME} \
    -p ml-model=$MODEL_URL \
    -p config="$(< ${TRAINING_CONFIG})" \
    -p times="$(< ../train-evaluate-prognostic-run/train_times.json)" \
    -p offline-diags-output=gs://vcm-ml-experiments/$EXPERIMENT/offline_diags_evaluated_on_training_data \
    -p report-output=gs://vcm-ml-public/offline_ml_diags/$EXPERIMENT-test-on-training-data \
    -p data-path=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/nudge-to-obs-run-3hr-diags \
    -p memory="10Gi"
