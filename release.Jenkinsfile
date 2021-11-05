pipeline {
    agent any

    tools {
        go 'Go 1.15'
    }

    environment {
        RELEASE_TYPE = "${params.RELEASE_TYPE}"
        BUMP_COMPONENT = "${params.BUMP_COMPONENT}"
        GIT_BRANCH = getCurrentBranchName()
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

//       stage("Github Release And Slack Notification") {
//         environment {
//           GITHUB_CREDS_PSW = credentials("GITHUB_TOKEN")
//           CHANNEL_ID = credentials("k8s-assist-slack-ID")
//           SLACK_WEBHOOK_URL = credentials("slack_hook_URL")
//           BUILD_USER_ID = getBuildUserID()
//           BUILD_USER = getBuildUser()
//         }
//         when{ environment name: 'RELEASE_TYPE', value: 'release' }
//         steps {
//           sh './hack/jenkins/generate_github_release.sh'
//           sh './hack/jenkins/generate_slack_notification.sh'
//         }
//       }
    }
    post {
        always {
            cleanWs()
        }
    }
}

def getCurrentBranchName() {
      return env.BRANCH_NAME.split("/")[1]
}

def getBuildUser() {
      return "${currentBuild.getBuildCauses()[0].userName}"
}

def getBuildUserID() {
      return "${currentBuild.getBuildCauses()[0].userId}"
}