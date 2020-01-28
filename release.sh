#!/bin/sh

function print_usage_and_exit() {
    echo "Failure: $1"
    echo "Usage: $0 CHART_NAME"
    exit 1
}

CHART_NAME=$1
if [[ -z $CHART_NAME ]] ; then
    print_usage_and_exit "Chart name is required"
fi

helm_path=`which helm`
if [[ -z helm_path ]] ; then
    echo "Failure: helm not found"
    exit 1
fi

# initialize build variables
BUILD_DIR="./_build"
INDEX_FILE=${BUILD_DIR}/index.yaml
TMP_DIR=`mktemp -d /tmp/wavefront.XXXXXX`

rm -rf ${BUILD_DIR}
echo "using build directory: ${BUILD_DIR}"
mkdir ${BUILD_DIR}

# create new tgz
echo "creating new ${CHART_NAME} helm package"
helm package -d ${BUILD_DIR} ./${CHART_NAME}

if [[ "$?" -ne "0" ]] ; then
    echo "Failure: error creating helm package"
    exit 1
fi

# download current index.yaml
echo "downloading latest index.yaml to ${INDEX_FILE}"
curl -sL https://raw.githubusercontent.com/wavefrontHQ/helm/gh-pages/index.yaml > ${INDEX_FILE}

echo "generating updated index.yaml"
helm repo index --url "https://github.com/wavefrontHQ/helm/tree/gh-pages" --merge "${INDEX_FILE}" ${BUILD_DIR}

cp ${BUILD_DIR}/* ${TMP_DIR}

echo "Complete. new index and package files can be found under ${BUILD_DIR}"
echo "Files have also been copied to ${TMP_DIR}"
