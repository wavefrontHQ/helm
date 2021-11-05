#!/bin/bash -ex

cd "$(dirname "$0")"
source ./VERSION

# TODO ??? Assumption: bump components will be in sync for collector and helm versions???

BUMPED_RELEASED_VERSION=$(semver-cli inc ${BUMP_COMPONENT} ${RELEASED_VERSION})
BUMPED_CURRENT_VERSION=$(semver-cli inc ${BUMP_COMPONENT} ${CURRENT_VERSION})
BUMPED_RELEASED_CHART_VERSION=$(semver-cli inc ${BUMP_COMPONENT} ${RELEASED_CHART_VERSION})
BUMPED_CURRENT_CHART_VERSION=$(semver-cli inc ${BUMP_COMPONENT} ${CURRENT_CHART_VERSION})

sed -i "s/RELEASED_VERSION=\"${RELEASED_VERSION}\"/RELEASED_VERSION=\"${BUMPED_RELEASED_VERSION}\"/g" VERSION
sed -i "s/CURRENT_VERSION=\"${CURRENT_VERSION}\"/CURRENT_VERSION=\"${BUMPED_CURRENT_VERSION}\"/g" VERSION
sed -i "s/RELEASED_CHART_VERSION=\"${RELEASED_CHART_VERSION}\"/RELEASED_CHART_VERSION=\"${BUMPED_RELEASED_CHART_VERSION}\"/g" VERSION
sed -i "s/CURRENT_CHART_VERSION=\"${CURRENT_CHART_VERSION}\"/CURRENT_CHART_VERSION=\"${BUMPED_CURRENT_CHART_VERSION}\"/g" VERSION

GIT_BRANCH="wavefront-bump-${BUMPED_CURRENT_CHART_VERSION}"

git checkout -b $GIT_BRANCH

## Bump app version
sed -i "s/appVersion: ${BUMPED_RELEASED_VERSION}/appVersion: ${BUMPED_CURRENT_VERSION}/g" ../Chart.yaml
sed -i "s/${BUMPED_RELEASED_VERSION}/${BUMPED_CURRENT_VERSION}/g" ../values.yaml

## Bump chart version
sed -i "s/version: ${BUMPED_RELEASED_CHART_VERSION}/version: ${BUMPED_CURRENT_CHART_VERSION}/g" ../Chart.yaml

git commit -am "bump helm chart version to $BUMPED_CURRENT_CHART_VERSION"

# TODO: remove the echo and create PR and Merge it after the service account gets permission
git push --set-upstream origin $GIT_BRANCH

PR_URL=$(curl \
  -X POST \
  -H "Authorization: token ${TOKEN}" \
  -d "{\"head\":\"${GIT_BRANCH}\",\"base\":\"master\",\"title\":\"bump helm chart version to ${BUMPED_CURRENT_CHART_VERSION}\"}" \
  https://api.github.com/repos/wavefrontHQ/helm/pulls |
  jq -r '.url')

echo "PR URL: ${PR_URL}"

# TODO ??? Do we need an approver to approve the PR before merge???
echo curl \
  -X PUT \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github.v3+json" \
  "${PR_URL}/merge" \
  -d "{\"commit_title\":\"bump helm chart version to ${BUMPED_CURRENT_CHART_VERSION}\"}"

