#!/bin/bash
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

helm_path=$(which helm || echo "")
if [[ -z $helm_path ]] ; then
    echo "Failure: helm not found"
    exit 1
fi

# update helm dependencies
pushd $CHART_NAME
    helm dependency update
popd $CHART_NAME

# initialize build variables
BUILD_DIR="./_build"
INDEX_FILE=${BUILD_DIR}/index.yaml

rm -rf ${BUILD_DIR}
echo "using build directory: ${BUILD_DIR}"
mkdir ${BUILD_DIR}

# create new tgz
echo "creating new \"${CHART_NAME}\" helm package"
if ! helm package -d ${BUILD_DIR} "./${CHART_NAME}"; then
    echo "Failure: error creating helm package"
    exit 1
fi

# download current index.yaml
echo "downloading latest index.yaml to: ${INDEX_FILE}"
curl -sL https://raw.githubusercontent.com/wavefrontHQ/helm/gh-pages/index.yaml > ${INDEX_FILE}

echo "generating updated index.yaml"
helm repo index --merge "${INDEX_FILE}" ${BUILD_DIR}

echo "Complete. new index and package files can be found under: ${BUILD_DIR}"
echo "Next Human Steps :: Run 'git checkout gh-pages && git pull' to update the gh-pages branch"
echo "Next Human Steps :: Run 'git checkout -b gh-pages-${CHART_NAME}-<NEW_VERSION_NUMBER>' to create a new branch"
echo "Next Human Steps :: Run 'cp ${BUILD_DIR}/* .' to copy the contents of the ./_build directory"
echo "Next Human Steps :: Run 'git commit -am \"Release ${CHART_NAME} chart <NEW_CHART_VERSION>\"' to commit and update the helm chart"
echo "Next Human Steps :: Push your changes to GitHub and create a PR against the 'gh-pages' branch"
