#!/bin/bash

set -e

MONTH=$1

RANDOM="$(openssl rand --hex 4)"
IC_TIMESTAMP="2016${MONTH}01.000000"
export IC_URL="gs://vcm-ml-raw/2020-11-05-GFS-month-start-initial-conditions-year-2016/2016${MONTH}0100"
OUTPUT=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/weather-forecasts/$IC_TIMESTAMP

envsubst < "prognostic-run.yaml" > "prognostic-run-with-IC.yaml"

# submit prognostic run forecasts
for MODEL_NAME in "rf-control" "rf-dQ1-dQ2-only"; do
    MODEL_URL=gs://vcm-ml-experiments/2020-10-30-nudge-to-obs-GRL-paper/${MODEL_NAME}/trained_model

    argo submit \
        --from workflowtemplate/prognostic-run \
        --name prognostic-forecast-init-${MONTH}-${RANDOM} \
        -p output="${OUTPUT}_${MODEL_NAME}" \
        -p trained-ml=$ML_MODEL \
        -p reference-restarts=gs://vcm-ml-experiments/2020-06-02-fine-res/coarsen_restarts \
        -p initial-condition=$IC_TIMESTAMP \
        -p config="$(< prognostic-run-with-IC.yaml)" \
        -p memory="10Gi" \
        -p flags="--nudge-to-observations --model_url ${MODEL_URL}"
done


# submit baseline run forecast
argo submit \
    --from workflowtemplate/prognostic-run \
    --name baseline-forecast-init-${MONTH}-${RANDOM} \
    -p output="${OUTPUT}_baseline" \
    -p trained-ml=$ML_MODEL \
    -p reference-restarts=gs://vcm-ml-experiments/2020-06-02-fine-res/coarsen_restarts \
    -p initial-condition=$IC_TIMESTAMP \
    -p config="$(< prognostic-run-with-IC.yaml)" \
    -p memory="10Gi" \
    -p flags="--nudge-to-observations --diagnostic_ml --model_url ${MODEL_URL}"
