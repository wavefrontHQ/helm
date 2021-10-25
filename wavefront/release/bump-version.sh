#!/bin/bash -e

cd "$(dirname "$0")"

source ./VERSION
GIT_BRANCH="wavefront-bump-${CURRENT_CHART_VERSION}"

git checkout -b $GIT_BRANCH

## Bump app version
sed -i "" "s/appVersion: ${RELEASED_VERSION}/appVersion: ${CURRENT_VERSION}/g" ../Chart.yaml
sed -i "" "s/${RELEASED_VERSION}/${CURRENT_VERSION}/g" ../values.yaml

## Bump chart version
sed -i "" "s/version: ${RELEASED_CHART_VERSION}/version: ${CURRENT_CHART_VERSION}/g" ../Chart.yaml

git commit -am "bump helm chart version to $CURRENT_CHART_VERSION"

git push --set-upstream origin $GIT_BRANCH

gh pr create --base master --fill --head $GIT_BRANCH --web
