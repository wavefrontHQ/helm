#!/bin/bash -e

source ./VERSION
# 1st time only - Create a fork for and subsequently rebase with upstream and clone to jenkins
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
git remote set-url origin https://${GITHUB_CREDS_PSW}@github.com/openshift-helm-charts/charts.git

# Reset main branch on forked repo with upstream
git remote add upstream https://github.com/openshift-helm-charts/charts
git fetch upstream
git checkout main
git reset --hard upstream/main
git push origin main --force

# Update fork with the new chart version.
GIT_BRANCH=main
mkdir charts/partners/wavefronthq/wavefront/${CHART_VERSION}
sshpass -p "${OPENSHIFT_DEV_PWD}" scp root@${OPENSHIFT_VM}:/root/workspace/helm/_build/wavefront-${CHART_VERSION}.tgz ~/workspace/charts/charts/partners/wavefronthq/wavefront/${CHART_VERSION}
sshpass -p "${OPENSHIFT_DEV_PWD}" scp root@${OPENSHIFT_VM}:/root/workspace/helm/_build/report.yaml ~/workspace/charts/charts/partners/wavefronthq/wavefront/${CHART_VERSION}

# Commit and push the change to your forked version
# Create a new PR against https://github.com/openshift-helm-charts/charts and this should trigger the openshift pipeline

git add . && git commit -am "Build openshift wavefront chart release : ${CHART_VERSION}"
git push origin $GIT_BRANCH

PR_URL=$(curl \
  -X POST \
  -H "Authorization: token ${TOKEN}" \
  -d "{\"head\":\"${GIT_BRANCH}\",\"base\":\"main\",\"title\":\"Build openshift wavefront chart release ${CHART_VERSION}\"}" \
  https://api.github.com/repos/akodali18/openshift-helm-charts/pulls |
  jq -r '.html_url')

echo "Next Human Steps :: Please monitor openshift pipeline for PR - ${PR_URL}"



