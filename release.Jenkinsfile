pipeline {
  agent any

  tools {
      go 'Go 1.15'
  }

  environment {
      RELEASE_TYPE = "${params.RELEASE_TYPE}"
      BUMP_COMPONENT = "${params.BUMP_COMPONENT}"
      GIT_CREDENTIAL_ID = 'wf-jenkins-github'
      TOKEN = credentials('GITHUB_TOKEN')
      GITHUB_CREDS_PSW = credentials("GITHUB_TOKEN")
  }

  stages {
    stage("Setup Tools") {
      steps {
        withEnv(["PATH+EXTRA=${HOME}/go/bin"]) {
          sh './wavefront/release/setup-for-release.sh'
        }
      }
    }
    stage("Bump Github Version") {
      steps {
        withEnv(["PATH+EXTRA=${HOME}/go/bin"]) {
          sh 'git config --global user.email "svc.wf-jenkins@vmware.com"'
          sh 'git config --global user.name "svc.wf-jenkins"'
          sh 'git remote set-url origin https://${TOKEN}@github.com/wavefronthq/helm.git'
          sh './wavefront/release/bump-version.sh'
        }
      }
    }
    stage("Release helm chart") {
      steps {
         sh './wavefront/release/release-helm-chart.sh'
      }
    }
  }

  post {
    regression {
      slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "BUILD FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    fixed {
      slackSend (channel: '#tobs-k8po-team', color: '#008000', message: "BUILD FIXED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    success {
      slackSend (channel: '#tobs-k8po-team', color: '#008000', message: "BUILD SUCCESS: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    always {
      cleanWs()
    }
  }
}