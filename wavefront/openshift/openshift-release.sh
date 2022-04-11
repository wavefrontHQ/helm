#!/bin/bash -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/wavefront/openshift/VERSION
# 1st time only - Create a fork for openshift-helm-charts/charts repo via jenkins.
#sh '''
#    PR_URL=$(curl \
#      -X POST \
#      -u "svc.wf-jenkins:${TOKEN}" \
#      "https://api.github.com/repos/openshift-helm-charts/charts/forks")
#'''
#

git clone https://github.com/wf-jenkins/charts.git
cd charts
git config --global user.email "svc.wf-jenkins@vmware.com"
git config --global user.name "svc.wf-jenkins"
git remote set-url origin https://${GITHUB_CREDS_PSW}@github.com/wf-jenkins/charts.git

# Reset main branch on forked repo with upstream
git remote add upstream https://github.com/openshift-helm-charts/charts
git fetch upstream
git checkout main
git reset --hard upstream/main
git push origin main --force

# Update fork with the new chart version.
GIT_BRANCH=main
echo ${CHART_VERSION}
mkdir charts/partners/wavefronthq/wavefront/1.10.3
pwd
echo "downloading tar file"
sshpass -p "${OPENSHIFT_CREDS_PSW}" scp root@${OPENSHIFT_VM}:/root/workspace/helm/_build/wavefront-${CHART_VERSION}.tgz charts/partners/wavefronthq/wavefront/1.10.3
echo "downloading report"
sshpass -p "${OPENSHIFT_CREDS_PSW}" scp root@${OPENSHIFT_VM}:/root/workspace/helm/_build/report.yaml charts/partners/wavefronthq/wavefront/1.10.3

# Commit and push the change to your forked version
# Create a new PR against https://github.com/openshift-helm-charts/charts and this should trigger the openshift pipeline

git add . && git commit -am "Build openshift wavefront chart release : ${CHART_VERSION}"
git push origin $GIT_BRANCH

echo "Creating PR"
PR_URL=$(curl \
  -X POST \
  -H "Authorization: token ${GITHUB_CREDS_PSW}" \
  -d "{\"head\":\"wf-jenkins:${GIT_BRANCH}\",\"base\":\"main\",\"title\":\"Build openshift wavefront chart release ${CHART_VERSION}\"}" \
  https://api.github.com/repos/akodali18/openshift-helm-charts/pulls |
  jq -r '.html_url')

echo "Next Human Steps :: Please monitor openshift pipeline for PR - ${PR_URL}"



