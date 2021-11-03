#!/bin/bash -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/wavefront/release/k8s-utils.sh
source ${REPO_ROOT}/wavefront/release/VERSION

function main() {

  # REQUIRED
  local WAVEFRONT_TOKEN=

  local WF_CLUSTER=nimba
  local VERSION=${CURRENT_CHART_VERSION}
  local CONFIG_CLUSTER_NAME=$(whoami)-${VERSION}-release-test

  while getopts ":c:t:n:" opt; do
    case $opt in
    c)
      WF_CLUSTER="$OPTARG"
      ;;
    t)
      WAVEFRONT_TOKEN="$OPTARG"
      ;;
    n)
      CONFIG_CLUSTER_NAME="$OPTARG"
      ;;
    \?)
      print_usage_and_exit "Invalid option: -$OPTARG"
      ;;
    esac
  done

  if [[ -z ${WAVEFRONT_TOKEN} ]]; then
    print_msg_and_exit "wavefront token required"
  fi

  helm uninstall wavefront --namespace wavefront &>/dev/null || true

  kubectl create namespace wavefront &>/dev/null || true

  nohup ${REPO_ROOT}/wavefront/release/run-local-helm-repo.sh & &>/dev/null || true
  LOCAL_STATIC_PID=$!

  helm install wavefront wavefront/wavefront --namespace wavefront \
  --set clusterName=${CONFIG_CLUSTER_NAME} \
  --set wavefront.url=https://${WF_CLUSTER}.wavefront.com \
  --set wavefront.token=${WAVEFRONT_TOKEN} \
  --set collector.cadvisor.enabled=true

  ${REPO_ROOT}/wavefront/release/test-e2e.sh -t ${WAVEFRONT_TOKEN} -n ${CONFIG_CLUSTER_NAME}

  kill -9 $LOCAL_STATIC_PID
}

main $@