#!/bin/bash -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/wavefront/release/k8s-utils.sh
source ${REPO_ROOT}/wavefront/release/VERSION

function curl_query_to_wf_dashboard() {
  local query=$1
  # NOTE: any output inside this function is concatenated and used as the return value;
  # otherwise we would love to put a log such as this in here to give us more information:
  # echo "=============== Querying '$WF_CLUSTER' for query '${query}'"
  curl -s -X GET --header "Accept: application/json" \
    --header "Authorization: Bearer $WAVEFRONT_TOKEN" \
    "https://$WF_CLUSTER.wavefront.com/api/v2/chart/api?q=${query}&queryType=WQL&s=$AFTER_UNIX_TS&g=s&view=METRIC&sorted=false&cached=true&useRawQK=false" |
    jq '.timeseries[0].data[0][1]'
}

function wait_for_query_match_exact() {
  local query_match_exact=$1
  local expected=$2
  local actual
  local loop_count=0

  printf "Querying for exact match..."
  while true; do
    loop_count=$((loop_count + 1))
    actual=$(curl_query_to_wf_dashboard "${query_match_exact}")
    printf "."
    if [[ $actual == "${expected}" ]] || [[ $loop_count -eq $MAX_QUERY_TIMES ]]; then
      break
    fi
    sleep $CURL_WAIT
  done
  echo "done."

  if [[ $actual != "${expected}" ]]; then
    echo "Checking wavefront dashboard metrics for '$query_match_exact' failed after attempting $MAX_QUERY_TIMES times."
    echo "Actual is '$actual'"
    echo "Expected is '${expected}'"
    return 1
  fi
}

function wait_for_query_non_zero() {
  local query_non_zero=$1
  local actual=0
  local loop_count=0
  printf "Querying for non-zero..."
  while true; do
    loop_count=$((loop_count + 1))
    actual=$(curl_query_to_wf_dashboard "${query_non_zero}")
    printf "."
    if [[ $actual != null && $actual != 0 ]] || [[ $loop_count -eq $MAX_QUERY_TIMES ]]; then
      break
    fi
    sleep $CURL_WAIT
  done
  echo "done."

  if [[ $actual == null || $actual == 0 ]]; then
    echo "Checking wavefront dashboard metrics for $query_non_zero failed after attempting $MAX_QUERY_TIMES times."
    echo "Actual is '$actual'"
    echo "Expected non zero"
    return 1
  fi
}

function print_usage_and_exit() {
  echo "Failure: $1"
  echo "Usage: $0 [flags] [options]"
  echo -e "\t-c wavefront instance name (default: 'nimba')"
  echo -e "\t-t wavefront token (required)"
  echo -e "\t-n config cluster name for metric grouping (default: \$(whoami)-<default version from file>-release-test)"
  echo -e "\t-v collector version (default: load from 'release/VERSION')"
  exit 1
}

function exit_on_fail() {
  # shellcheck disable=SC2068
  $@ # run all arguments as a command
  local exit_code=$?
  if [[ $exit_code != 0 ]]; then
    # shellcheck disable=SC2145
    echo "Command '$@' exited with exit code '$exit_code'"
    exit $exit_code
  fi
}

function main() {
  cd "$(dirname "$0")" # hack/kustomize

  local AFTER_UNIX_TS="$(date '+%s')000"
  local MAX_QUERY_TIMES=20
  local CURL_WAIT=15

  # REQUIRED
  local WAVEFRONT_TOKEN=

  local WF_CLUSTER=nimba
  local EXPECTED_VERSION=${APP_VERSION}

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
      EXPECTED_VERSION="$OPTARG"
      ;;
    \?)
      print_usage_and_exit "Invalid option: -$OPTARG"
      ;;
    esac
  done

  if [[ -z ${WAVEFRONT_TOKEN} ]]; then
    print_msg_and_exit "wavefront token required"
  fi

  if [[ -z ${CONFIG_CLUSTER_NAME} ]]; then
    print_msg_and_exit "config cluster name required"
  fi

  local VERSION_IN_DECIMAL="${EXPECTED_VERSION%.*}"
  local VERSION_IN_DECIMAL+="$(echo "${EXPECTED_VERSION}" | cut -d '.' -f3)"

  wait_for_cluster_ready

  exit_on_fail wait_for_query_match_exact "ts(kubernetes.collector.version%2C%20cluster%3D%22${CONFIG_CLUSTER_NAME}%22%20AND%20installation_method%3D%22helm%22)" "${VERSION_IN_DECIMAL}"
  exit_on_fail wait_for_query_non_zero "ts(kubernetes.cluster.pod.count%2C%20cluster%3D%22${CONFIG_CLUSTER_NAME}%22)"
}

main $@
