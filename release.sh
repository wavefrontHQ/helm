#!/usr/bin/env bash
set -e

function print_usage_and_exit() {
    echo "Failure: $1"
    echo "Usage: $0 <HELM_CHART_NAME>"
    echo "Example: $0 wavefront"
    exit 1
}

CHART_NAME=$1
if [[ -z $CHART_NAME ]] ; then
    print_usage_and_exit "Chart name is required"
fi
echo "Chart name: $CHART_NAME"

if [[ ! -d "./${CHART_NAME}" ]] ; then
    echo "Failure: helm release folder not found"
    exit 1
fi
echo "Helm release folder: ./${CHART_NAME}"

helm_path=$(which helm || echo "")
if [[ -z $helm_path ]] ; then
    echo "Failure: helm not found"
    exit 1
fi

# update helm dependencies
echo "Updating charts/ based on the contents of Chart.yaml"
pushd $CHART_NAME >/dev/null
    helm dependency update
popd >/dev/null

# initialize build variables
BUILD_DIR="./_build"
INDEX_FILE=${BUILD_DIR}/index.yaml

rm -rf ${BUILD_DIR}
echo "Using build directory: ${BUILD_DIR}"
mkdir ${BUILD_DIR}

# create new tgz
echo "Creating new \"${CHART_NAME}\" helm package"
if ! helm package -d ${BUILD_DIR} "./${CHART_NAME}"; then
    echo "Failure: error creating helm package"
    exit 1
fi

# download current index.yaml
echo "Downloading latest index.yaml to: ${INDEX_FILE}"
curl -sSL https://raw.githubusercontent.com/wavefrontHQ/helm/gh-pages/index.yaml > ${INDEX_FILE}

echo "Generating updated index.yaml"
helm repo index --merge "${INDEX_FILE}" ${BUILD_DIR}

echo "Complete. New index and package files can be found under: ${BUILD_DIR}"
echo "Next Human Steps :: Run 'git checkout gh-pages && cp ${BUILD_DIR}/* . && git add .' and commit to update the helm chart"
echo "Next Human Steps :: Run 'git checkout -b gh-pages-${CHART_NAME}-<NEW_VERSION_NUMBER>' to create a new branch"
echo "Next Human Steps :: Run 'git commit -m \"Release ${CHART_NAME} chart version <NEW_CHART_VERSION>\"' to commit and update the helm chart"
echo "Next Human Steps :: Push your changes to GitHub and create a PR against the 'gh-pages' branch"
