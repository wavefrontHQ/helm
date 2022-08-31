pipeline {
  agent any

  environment {
    OPENSHIFT_VM = credentials("OPENSHIFT_VM")
    OPENSHIFT_CREDS_PSW = credentials("OPENSHIFT_CREDS_PSW")
    GITHUB_CREDS_PSW = credentials("GITHUB_TOKEN")
    WAVEFRONT_TOKEN = credentials('WAVEFRONT_TOKEN_NIMBA')
  }

  stages {
    stage("Setup Tools") {
      steps {
        sh './wavefront/release/setup-for-release.sh'
      }
    }

    stage("Openshift Build Report") {
      options {
        timeout(time: 30, unit: 'MINUTES')
      }
      steps {
        sh './wavefront/openshift/openshift-build-report.sh'
      }
    }

    stage("Create Helm Release PR") {
      steps {
        sh './wavefront/openshift/openshift-release.sh'
      }
    }
}

  post {
    // Notify only on null->failure or success->failure or failure->success
    failure {
      script {
        if(currentBuild.previousBuild == null) {
          slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "OPENSHIFT RELEASE JOB FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
        }
      }
    }
    regression {
      slackSend (channel: '#tobs-k8po-team', color: '#FF0000', message: "OPENSHIFT RELEASE JOB FAILED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    fixed {
      slackSend (channel: '#tobs-k8po-team', color: '#008000', message: "OPENSHIFT RELEASE JOB FIXED: <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>")
    }
    always {
      cleanWs()
    }
  }
}