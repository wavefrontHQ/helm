#!/bin/bash -e

cd "$(dirname "$0")"
source ./VERSION

cd .. # ./wavefront
helm dependency update

cd .. # ./
./release.sh wavefront

GIT_BRANCH="gh-pages-${CURRENT_CHART_VERSION}"

git fetch
git checkout -b $GIT_BRANCH origin/gh-pages
mv ./_build/* .
git add . && git commit -am "build release for ${CURRENT_CHART_VERSION}"
git push --set-upstream origin $GIT_BRANCH

gh pr create --base gh-pages --fill --head $GIT_BRANCH --web
