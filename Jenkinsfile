// Jenkins Pipeline Syntax
// https://www.jenkins.io/doc/book/pipeline/syntax/
pipeline {
  agent any
  stages {
    stage('Deploy') {
      // https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-steps
      steps {
        sshagent(['jenkins-deploy']) {
          sh '''
            ssh -o StrictHostKeyChecking=no appuser@deploy 'bash -l -c "/app/deploy_from_nexus.sh"'
          '''
        }
      }
    }
  }
}
