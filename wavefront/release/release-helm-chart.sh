#!/bin/bash -e

cd "$(dirname "$0")"

helm repo add stable https://charts.helm.sh/stable
git checkout master
git pull

source ./VERSION

cd .. # ./wavefront
helm dependency update

cd .. # ./
./release.sh wavefront

GIT_BRANCH="gh-pages-${CURRENT_CHART_VERSION}"

git fetch
git checkout -b $GIT_BRANCH origin/gh-pages
mv ./_build/* .
git add . && git commit -am "Build release for ${CURRENT_CHART_VERSION}"
git push --set-upstream origin $GIT_BRANCH

PR_URL=$(curl \
  -X POST \
  -H "Authorization: token ${TOKEN}" \
  -d "{\"head\":\"${GIT_BRANCH}\",\"base\":\"gh-pages\",\"title\":\"Build release for ${CURRENT_CHART_VERSION}\"}" \
  https://api.github.com/repos/wavefrontHQ/helm/pulls |
  jq -r '.url')

echo "PR URL: ${PR_URL}"