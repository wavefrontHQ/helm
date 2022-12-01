pipeline {
  agent any

  tools {
    go 'Go 1.17'
  }

  environment {
    NEW_APP_VERSION = "${params.NEW_APP_VERSION}"
    NEW_CHART_VERSION = "${params.NEW_CHART_VERSION}"
    GIT_CREDENTIAL_ID = 'wf-jenkins-github'
    TOKEN = credentials('GITHUB_TOKEN')
    GITHUB_CREDS_PSW = credentials("GITHUB_TOKEN")
    WAVEFRONT_TOKEN = credentials('WAVEFRONT_TOKEN_NIMBA')
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
        sh 'git remote set-url origin https://${TOKEN}@github.com/wavefronthq/helm.git'
        sh './wavefront/release/bump-version.sh'
      }
    }
    stage("Create GitHub Pages PR") {
      steps {
        sh 'git config --global user.email "svc.wf-jenkins@vmware.com"'
        sh 'git config --global user.name "svc.wf-jenkins"'
        sh 'git remote set-url origin https://${TOKEN}@github.com/wavefronthq/helm.git'
        sh './wavefront/release/create-release-pr.sh'
      }
    }
  }

  post {
    // Notify only on null->failure or success->failure or failure->success
    failure {
      script {
        if(currentBuild.previousBuild == null) {
          slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "RELEASE BUILD FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
        }
      }
    }
    regression {
      slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "RELEASE BUILD FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    fixed {
      slackSend (channel: '#tobs-k8po-team', color: '#008000', message: "RELEASE BUILD FIXED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    always {
      cleanWs()
    }
  }
}