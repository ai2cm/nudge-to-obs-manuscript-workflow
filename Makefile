
# do two-year nudge-to-obs run initialized 1 January 2015
nudge_to_obs_run: kustomize
	./kustomize build workflow | kubectl apply -f -
	cd workflow/nudge-to-obs-run; ./run.sh

# do year-long baseline run initialized 1 January 2016
baseline_run: kustomize
	./kustomize build workflow | kubectl apply -f -
	cd workflow/baseline-run; ./run.sh

# train ML models based on nudge-to-obs run and do year-long prognostic runs
train_evaluate_prognostic_run: kustomize
	./kustomize build workflow | kubectl apply -f -
	cd workflow/train-evaluate-prognostic-run; ./run.sh rf-control
	cd workflow/train-evaluate-prognostic-run; ./run.sh rf-dQ1-dQ2-only

# do twelve 10-day weather forecast prognostic and baseline runs
weather_forecast_runs: kustomize
	./kustomize build workflow | kubectl apply -f -
	cd workflow/weather-forecasts; ./run.sh 01
	cd workflow/weather-forecasts; ./run.sh 02
	cd workflow/weather-forecasts; ./run.sh 03
	cd workflow/weather-forecasts; ./run.sh 04
	cd workflow/weather-forecasts; ./run.sh 05
	cd workflow/weather-forecasts; ./run.sh 06
	cd workflow/weather-forecasts; ./run.sh 07
	cd workflow/weather-forecasts; ./run.sh 08
	cd workflow/weather-forecasts; ./run.sh 09
	cd workflow/weather-forecasts; ./run.sh 10
	cd workflow/weather-forecasts; ./run.sh 11
	cd workflow/weather-forecasts; ./run.sh 12

# generate prognostic run reports
prognostic_reports: kustomize
	./kustomize build workflow | kubectl apply -f -
	cd workflow/prognostic-run-report; ./run.sh

create_environment:
	make -C fv3net create_environment

.PHONY: nudge_to_obs_run baseline_run train_evaluate_prognostic_run weather_forecast_runs prognostic_reports

kustomize:
	./install_kustomize.sh 3.10.0

