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

  local CONFIG_CLUSTER_NAME_UPGRADE="${CONFIG_CLUSTER_NAME}-upgrade"

  helm uninstall wavefront --namespace wavefront &>/dev/null || true

  kubectl create namespace wavefront &>/dev/null || true

  ${REPO_ROOT}/wavefront/release/run-local-helm-repo.sh >/dev/null

  # Test on Freshly Installed Helm
  helm install wavefront wavefront/wavefront --namespace wavefront \
  --set clusterName=${CONFIG_CLUSTER_NAME} \
  --set wavefront.url=https://${WF_CLUSTER}.wavefront.com \
  --set wavefront.token=${WAVEFRONT_TOKEN} \
  --set collector.cadvisor.enabled=true

  ${REPO_ROOT}/wavefront/release/test-e2e.sh -t ${WAVEFRONT_TOKEN} -n ${CONFIG_CLUSTER_NAME}

  # Test on Upgraded Helm
  helm uninstall wavefront --namespace wavefront &>/dev/null || true

  local RELEASED_VERSION=${RELEASED_CHART_VERSION}
  local CONFIG_CLUSTER_NAME_RELEASED_VERSION=$(whoami)-${RELEASED_VERSION}-release-test

  helm install wavefront wavefront/wavefront --namespace wavefront \
  --set clusterName=${CONFIG_CLUSTER_NAME_RELEASED_VERSION} \
  --set wavefront.url=https://${WF_CLUSTER}.wavefront.com \
  --set wavefront.token=${WAVEFRONT_TOKEN} \
  --set collector.cadvisor.enabled=true

  helm upgrade wavefront wavefront/wavefront --namespace wavefront \
  --set clusterName=${CONFIG_CLUSTER_NAME_UPGRADE} \
  --set wavefront.url=https://${WF_CLUSTER}.wavefront.com \
  --set wavefront.token=${WAVEFRONT_TOKEN} \
  --set collector.cadvisor.enabled=true

  ${REPO_ROOT}/wavefront/release/test-e2e.sh -t ${WAVEFRONT_TOKEN} -n ${CONFIG_CLUSTER_NAME_UPGRADE}

  green "Success!"
}

main $@
