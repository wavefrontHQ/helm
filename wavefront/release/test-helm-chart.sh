#!/bin/bash -ex

REPO_ROOT=$(git rev-parse --show-toplevel)
echo ${REPO_ROOT}

helm install wavefront ${REPO_ROOT}/wavefront --namespace wavefront \
--set clusterName=helm-test-pselvaganesa \
--set wavefront.url=https://nimba.wavefront.com \
--set wavefront.token=f248d728-6603-42a7-9475-d5667f359646

helm test wavefront -n wavefront --timeout 10s --logs
