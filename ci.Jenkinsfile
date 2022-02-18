pipeline {
  agent any

  tools {
    go 'Go 1.17'
  }

  environment {
    GCP_CREDS = credentials("GCP_CREDS")
    GCP_PROJECT = "wavefront-gcp-dev"
    GKE_CLUSTER_NAME = "k8po-jenkins-pr-testing"
    WAVEFRONT_TOKEN = credentials('WAVEFRONT_TOKEN_NIMBA')
    APP_VERSION =
  }

  stages {
    stage("Setup Tools") {
      steps {
        sh './wavefront/release/setup-for-testing.sh'
        withEnv(["PATH+GCLOUD=${HOME}/google-cloud-sdk/bin"]) {
          sh './wavefront/release/setup-for-integration-test.sh'
        }
      }
    }
    stage("Run Tests") {
      steps {
        withEnv(["PATH+EXTRA=${PWD}/node-v16.14.0-linux-x64/bin", "PATH+GCLOUD=${HOME}/google-cloud-sdk/bin"]) {
          sh 'gcloud container clusters get-credentials ${GKE_CLUSTER_NAME} --zone us-central1-c --project ${GCP_PROJECT}'
          script {
            env.PREV_VERSION = sh(returnStdout: true, script: "curl -s -X 'GET' 'https://artifacthub.io/api/v1/packages/helm/wavefront/wavefront' -H 'accept: application/json' | jq -r '.available_versions[1].version'").trim()
            env.PREV_APP_VERSION = sh(returnStdout: true, script: "curl -s -X 'GET' 'https://artifacthub.io/api/v1/packages/helm/wavefront/wavefront/${PREV_VERSION}' -H 'accept: application/json' | jq -r .app_version").trim()
          }
          sh 'PREV_APP_VERSION=${PREV_APP_VERSION} ./wavefront/release/run-local-e2e-test.sh -t ${WAVEFRONT_TOKEN} -p ${PREV_VERSION}'
        }
      }
    }
  }

  post {
    regression {
      slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "TEST FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    fixed {
      slackSend (channel: '#tobs-k8po-team', color: '#008000', message: "TEST FIXED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    success {
      slackSend (channel: '#tobs-k8po-team', color: '#008000', message: "TEST SUCCESS: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    always {
      cleanWs()
    }
  }
}
