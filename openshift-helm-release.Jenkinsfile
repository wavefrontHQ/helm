pipeline {
  agent any

  stages {
    stage ("SSH into dev env") {
      steps {
        script {
          sshagent(['openshift-dev']) {
              sh 'ssh root@10.172.103.25 "ls- la"'
          }

        }
      }
    }
  }
}