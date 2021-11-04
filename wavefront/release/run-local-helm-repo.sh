#!/bin/bash -e

echo $(pwd "$1")
cd "$(pwd "$1")"

helm repo add stable https://charts.helm.sh/stable

helm lint wavefront

rm -rf _build

pushd wavefront
helm dependency update
popd

./release.sh wavefront

cd _build

npm install -g node-static
static -p 8000 -H '{"Access-Control-Allow-Origin": "*"}'