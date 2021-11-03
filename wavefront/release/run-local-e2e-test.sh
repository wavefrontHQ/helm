#!/bin/bash -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/wavefront/release/k8s-utils.sh

function main() {

  # REQUIRED
  local WAVEFRONT_TOKEN=

  local WF_CLUSTER=nimba
  local VERSION="$(cat ${REPO_ROOT}/wavefront/release/VERSION)"
  local CONFIG_CLUSTER_NAME=$(whoami)-${VERSION}-release-test

  while getopts ":c:t:n:v:" opt; do
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
    v)
      VERSION="$OPTARG"
      ;;
    \?)
      print_usage_and_exit "Invalid option: -$OPTARG"
      ;;
    esac
  done

  if [[ -z ${WAVEFRONT_TOKEN} ]]; then
    print_msg_and_exit "wavefront token required"
  fi

  local VERSION_IN_DECIMAL="${VERSION%.*}"
  local VERSION_IN_DECIMAL+="$(echo "${VERSION}" | cut -d '.' -f3)"

  helm uninstall wavefront --namespace wavefront &>/dev/null || true

  ${REPO_ROOT}/wavefront/release/run-local-helm-repo.sh

  helm install wavefront wavefront/wavefront --namespace wavefront \
  --set clusterName=${CONFIG_CLUSTER_NAME} \
  --set wavefront.url=https://${WF_CLUSTER}.wavefront.com \
  --set wavefront.token=${WAVEFRONT_TOKEN} \
  --set collector.cadvisor.enabled=true
}

main $@