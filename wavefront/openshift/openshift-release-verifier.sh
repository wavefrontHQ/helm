#!/bin/bash -e

cd ~/workspace/helm
git clean -dfx
git checkout master
# Also make sure you are in a clean state
git checkout .
git pull
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

export CLUSTER_NAME=${CLUSTER_NAME}
export WAVEFRONT_TOKEN=${WAVEFRONT_TOKEN}
helm install wavefront ./wavefront --namespace wavefront \
--set clusterName=$CLUSTER_NAME \
--set wavefront.url=https://nimba.wavefront.com \
--set wavefront.token=$WAVEFRONT_TOKEN

# Ensure that collector/proxy are at the correct version and the metrics are getting to nimba, then
# TODO: Run e2e ?
helm uninstall wavefront

# Run ./wavefront/release/run-chart-verifier-generate-report.sh to generate report.yaml under _build directory.
./wavefront/release/run-chart-verifier-generate-report.sh

# Ensure that all checks pass!
# sort _build/report.yaml | uniq -c | grep 'outcome: PASS'
if  grep -q "outcome: FAIL" "_build/report.yaml" ; then
         echo 'the string exists' ;
         exit 1
else
         echo 'the string does not exist' ;
fi

#cat _build/report.yaml