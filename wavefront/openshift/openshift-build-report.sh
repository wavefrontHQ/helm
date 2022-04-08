#!/bin/bash -e

# Runs the chart-verifier test
# TODO: Revisit if we should send password (install other tools like sshpass?)
# TODO-cont: or setup ssh keys in the VM instead
# TODO-cont: or use a Jenkins plugin
retcode=$(sshpass -p "${OPENSHIFT_CREDS_PSW}" ssh root@${OPENSHIFT_VM} 'bash -s' < test-and-generate-report.sh)
if [ $retcode -ne 0 ]; then
  echo "Chart verification failed with exit code $retcode."
  exit $retcode
fi
