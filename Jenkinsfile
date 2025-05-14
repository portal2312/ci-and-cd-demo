pipeline {
  agent any
  stages {
    stage('Deploy') {
      steps {
        sshagent(['jenkins-deploy']) {
          sh '''
            ssh -o StrictHostKeyChecking=no appuser@deploy '
              /app/deploy_from_nexus.sh
            '
          '''
        }
      }
    }
  }
}
