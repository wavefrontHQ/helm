pipeline {
  agent any

  environment {
    OPENSHIFT_VM = credentials("OPENSHIFT_VM")
    OPENSHIFT_CREDS_PSW = credentials("OPENSHIFT_CREDS_PSW")
    GITHUB_CREDS_PSW = credentials("GITHUB_TOKEN")
  }

  stages {
    stage("Setup Tools") {
      steps {
        sh './wavefront/release/setup-for-release.sh'
      }
    }

    stage("Openshift Build Report") {
      steps {
        sh './wavefront/openshift/openshift-helm-build-report.sh'
      }
    }

    stage("Create Helm Release PR") {
      steps {
        sh './wavefront/openshift/openshift-helm-release.sh'
      }
    }

  post {
    // Notify only on null->failure or success->failure or failure->success
    failure {
      script {
        if(currentBuild.previousBuild == null) {
          slackSend (channel: '#open-channel', color: '#FF0000', message: "OPENSHIFT BUMP VERSION JOB FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
        }
      }
    }
    regression {
      slackSend (channel: '#open-channel', color: '#FF0000', message: "OPENSHIFT BUMP VERSION JOB FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    fixed {
      slackSend (channel: '#open-channel', color: '#008000', message: "OPENSHIFT BUMP VERSION JOB FIXED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    always {
      cleanWs()
    }
  }
}