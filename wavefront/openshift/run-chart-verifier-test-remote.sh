#!/bin/bash -e

OPENSHIFT_DEV_PWD=1Wavefront!
NEW_CHART_VERSION=1.10.3-test

# Runs the chart-verifier test
# TODO: Revisit if we should send password (install other tools like sshpass?)
# TODO-cont: or setup ssh keys in the VM instead
# TODO-cont: or use a Jenkins plugin
retcode=$(sshpass -p "${OPENSHIFT_DEV_PWD}" ssh root@10.172.103.25 'bash -s' < ./openshift-release-verifier.sh)
if [ $retcode -ne 0 ]; then
  echo "Chart verification failed with exit code $retcode."
  exit $retcode
fi
#
# TODO for K8SSAAS-816 from here onwards.
# 1st time only - Create a fork for and subsequently rebase with upstream and clone to jenkins
#sh '''
#    PR_URL=$(curl \
#      -X POST \
#      -u "svc.wf-jenkins:${TOKEN}" \
#      "https://api.github.com/repos/openshift-helm-charts/charts/forks")
#'''
# git clone https://github.com/wf-jenkins/charts.git
#
#cd charts
#git remote add upstream https://github.com/openshift-helm-charts/charts
#git fetch upstream
#git checkout main
#git reset --hard upstream/main
#git push origin main --force
#git checkout -b $GIT_BRANCH
#mkdir charts/partners/wavefronthq/wavefront/${NEW_CHART_VERSION}
#sshpass -p "${OPENSHIFT_DEV_PWD}" scp root@10.172.103.25:/root/workspace/helm/_build/wavefront-${NEW_CHART_VERSION}.tgz ~/workspace/charts/charts/partners/wavefronthq/wavefront/${NEW_CHART_VERSION}
#sshpass -p "${OPENSHIFT_DEV_PWD}" scp root@10.172.103.25:/root/workspace/helm/_build/report.yaml ~/workspace/charts/charts/partners/wavefronthq/wavefront/${NEW_CHART_VERSION}
#
## Commit and push the change to your forked version
## Create a new PR against https://github.com/openshift-helm-charts/charts and this should trigger the pipeline
#
#mv ./_build/* .
#git add . && git commit -am "Build openshift wavefront chart release : ${NEW_CHART_VERSION}"
#git push origin $GIT_BRANCH
#
#PR_URL=$(curl \
#  -X POST \
#  -H "Authorization: token ${TOKEN}" \
#  -d "{\"head\":\"${GIT_BRANCH}\",\"base\":\"main\",\"title\":\"Build openshift wavefront chart release ${NEW_CHART_VERSION}\"}" \
#  https://api.github.com/repos/openshift-helm-charts/charts/pulls |
#  jq -r '.html_url')
#
#echo "PR URL: ${PR_URL}"


