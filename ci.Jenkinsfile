pipeline {
  agent any

  tools {
    go 'Go 1.17'
  }

  environment {
    WAVEFRONT_TOKEN = credentials('WAVEFRONT_TOKEN_NIMBA')
    PREV_VERSION = sh(returnStdout: true, script: "curl -s -X 'GET' 'https://artifacthub.io/api/v1/packages/helm/wavefront/wavefront' -H 'accept: application/json' | jq -r .version").trim()
  }

  stages {
    stage("Setup Tools") {
      steps {
        sh './wavefront/release/setup-for-release.sh'
      }
    }
    stage("Run Tests") {
      steps {
        sh './wavefront/release/run-local-e2e-test.sh -p ${PREV_VERSION}'
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
