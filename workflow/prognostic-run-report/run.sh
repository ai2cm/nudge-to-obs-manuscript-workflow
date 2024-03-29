#!/bin/bash

name=2021-03-15-n2o-weather-forecast
argo submit --from=workflowtemplate/prognostic-run-diags \
    --name $name \
    -p runs="$(< rundirs_weather.json)" \
    -p flags="--verification nudged_c48_fv3gfs_2015_2016"


name=2021-03-15-n2o-climate-runs
argo submit --from=workflowtemplate/prognostic-run-diags \
    --name $name \
    -p runs="$(< rundirs_climate.json)" \
    -p flags="--verification nudged_c48_fv3gfs_2015_2016"

