pipeline {
  agent any

  environment {
    NEW_APP_VERSION = "${params.NEW_APP_VERSION}"
    NEW_CHART_VERSION = "${params.NEW_CHART_VERSION}"
    GITHUB_CREDS_PSW = credentials("GITHUB_TOKEN")
  }

  stages {
    stage("Setup Tools") {
      steps {
        sh './wavefront/release/setup-for-release.sh'
      }
    }
    stage("Create Bump Version PR") {
      steps {
        sh 'git config --global user.email "svc.wf-jenkins@vmware.com"'
        sh 'git config --global user.name "svc.wf-jenkins"'
        sh 'git remote set-url origin https://${GITHUB_CREDS_PSW}@github.com/wavefronthq/helm.git'
        sh './wavefront/openshift/bump-version.sh'
      }
    }
  }

  post {
    // Notify only on null->failure or success->failure or failure->success
    failure {
      script {
        if(currentBuild.previousBuild == null) {
          slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "OPENSHIFT BUMP VERSION JOB FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
        }
      }
    }
    regression {
      slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "OPENSHIFT BUMP VERSION JOB FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    fixed {
      slackSend (channel: '#tobs-k8po-team', color: '#008000', message: "OPENSHIFT BUMP VERSION JOB FIXED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    always {
      cleanWs()
    }
  }
}