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

VERIFY_JSON=$(docker run --rm \
  -v "$REPO_ROOT":/charts \
  -v ~/.kube/config:/etc/kubernetes/config -e KUBECONFIG=/etc/kubernetes/config \
  quay.io/redhat-certification/chart-verifier verify \
    --set chart-testing.namespace=wavefront \
    --openshift-version 4.9 \
    --output json \
    --chart-set clusterName=test,wavefront.url=test,wavefront.token=test \
    /charts/wavefront 2>&1 )

REPORTER_QUERY=$(cat <<-'EOF'
  .results[] |
    [ if .outcome == "PASS"
      then ("\u001b[32m " + .outcome + "\u001b[0m")
      else ("\u001b[31m " + .outcome + "\u001b[0m")
      end
    , .reason + " (" + .check + ")"
    ] | @tsv
EOF
)

echo "$VERIFY_JSON" | jq -r "$REPORTER_QUERY"

PASSED=$(echo "$VERIFY_JSON" | jq -r '[.results[] | select(.outcome == "PASS")] | length')
TOTAL=$(echo "$VERIFY_JSON" | jq -r '.results | length')

echo "$PASSED / $TOTAL passed"

kubectl delete serviceaccount test-collector -n wavefront &>/dev/null || true
kubectl delete rolebinding test-collector -n wavefront &>/dev/null || true
kubectl delete role test-collector -n wavefront &>/dev/null || true

[ "$PASSED" -eq "$TOTAL" ] || (exit 1)