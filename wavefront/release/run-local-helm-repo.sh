#!/bin/bash -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/wavefront/release/k8s-utils.sh

cd $REPO_ROOT

helm repo add stable https://charts.helm.sh/stable

helm lint wavefront

rm -rf _build

pushd wavefront
  helm dependency update
popd

./release.sh wavefront

pushd _build
  static_count=$(ps -ef | grep static | grep -v grep | wc -l)
  if [ $static_count -gt 0 ]; then
    green "Helm static repo already running!!"
    ps -ef | grep static | grep -v grep
  else
    npm install -g node-static
    green "Starting Helm static repo!!"
    nohup static -p 8000 -H '{"Access-Control-Allow-Origin": "*"}' &
  fi
popd
