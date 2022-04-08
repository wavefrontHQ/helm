#!/bin/bash -e

WAVEFRONT_TOKEN=$1
cd ~/workspace/helm
git clean -dfx
git checkout master
# Also make sure you are in a clean state
git checkout .
git pull
rm -rf _build/*
# Update Chart.yaml and values.yaml template values for OpenShift
yq ea '. as $item ireduce ({}; . * $item )' wavefront/Chart.yaml wavefront/openshift/Chart.yaml > merged-Chart.yaml
mv merged-Chart.yaml wavefront/Chart.yaml
yq ea '. as $item ireduce ({}; . * $item )' wavefront/values.yaml wavefront/openshift/values.yaml > merged-values.yaml
mv merged-values.yaml wavefront/values.yaml
cp wavefront/openshift/README.md wavefront/README.md

oc project wavefront
helm uninstall wavefront
cd wavefront
helm dependency update
cd ..
./release.sh wavefront

export FRESH_INSTALL_CLUSTER_NAME="openshift-helm-test-$(date +%Y%m%d%H%M%S)"
helm install wavefront ./wavefront --namespace wavefront \
--set clusterName=$FRESH_INSTALL_CLUSTER_NAME \
--set wavefront.url=https://nimba.wavefront.com \
--set wavefront.token=${WAVEFRONT_TOKEN}

# Ensure that collector/proxy are at the correct version and the metrics are getting to nimba, then
# TODO: Future (upgrade and downgrade test)
REPO_ROOT=$(git rev-parse --show-toplevel)
${REPO_ROOT}/wavefront/release/test-wavefront-metrics.sh -t ${WAVEFRONT_TOKEN} -n ${FRESH_INSTALL_CLUSTER_NAME}

helm uninstall wavefront

# Run ./wavefront/release/run-chart-verifier-generate-report.sh to generate report.yaml under _build directory.
./wavefront/release/run-chart-verifier-generate-report.sh

cat _build/report.yaml

# Ensure that all checks pass!
# sort _build/report.yaml | uniq -c | grep 'outcome: PASS'
if  grep -q "outcome: FAIL" "_build/report.yaml" ; then
         echo 'ERROR :: Chart verification failed ' ;
         exit 1
else
         echo 'Chart verifier - All checks passed' ;
fi

exit