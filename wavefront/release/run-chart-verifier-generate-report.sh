#!/usr/bin/env bash
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source "$REPO_ROOT"/wavefront/release/k8s-utils.sh

cd "$REPO_ROOT"

yellow "NOTE: Ensure that your current kube config is targeting a clean environment with an IP accessible from the docker container"
yellow "NOTE: Typical usage would be to set your context to a GKE or EKS cluster"

pushd "$REPO_ROOT/wavefront"
helm dependency update
popd

${REPO_ROOT}/release.sh wavefront

VERIFY_YAML=$(docker run --rm \
  -v "$REPO_ROOT":/charts \
  -v ~/.kube/config:/etc/kubernetes/config \
  -e KUBECONFIG=/etc/kubernetes/config \
  quay.io/redhat-certification/chart-verifier verify \
    --set chart-testing.namespace=wavefront \
    --openshift-version 4.9 \
    --output yaml \
    --chart-set clusterName=test,wavefront.url=test,wavefront.token=test \
  "/charts/_build/wavefront-1.7.11.tgz" 2>&1)

echo "${VERIFY_YAML}" >"${REPO_ROOT}/_build/report.yaml"