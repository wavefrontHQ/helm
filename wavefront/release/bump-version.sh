#!/bin/bash -e

RELEASED_VERSION="1.3.1"
CURRENT_VERSION="1.3.2"

RELEASED_CHART_VERSION="1.3.8"
CURRENT_CHART_VERSION="1.3.9"

## Bump app version
sed -i "" "s/appVersion: ${RELEASED_VERSION}/appVersion: ${CURRENT_VERSION}/g" ../Chart.yaml
sed -i "" "s/${RELEASED_VERSION}/${CURRENT_VERSION}/g" ../values.yaml

## Bump chart version
sed -i "" "s/version: ${RELEASED_CHART_VERSION}/version: ${CURRENT_CHART_VERSION}/g" ../Chart.yaml
