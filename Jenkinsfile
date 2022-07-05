pipeline {
    agent any
    options {
            buildDiscarder(logRotator(numToKeepStr: '10'))
            disableConcurrentBuilds()
            timeout(time: 1, unit: 'HOURS')
    }
    environment {
            AWS_DEFAULT_REGION = 'us-east-1'
            SSH_KEY_FILE = credentials('test')
    }
    stages {
      stage('Git Checkout') {
        steps {
          checkout scm
        }
      }
      /*stage('Build Docker Image') {
        steps {
            sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 416827206337.dkr.ecr.us-east-1.amazonaws.com"
            sh "docker build . -t 416827206337.dkr.ecr.us-east-1.amazonaws.com/upg-app-1:\${BUILD_NUMBER}"
            sh "docker push 416827206337.dkr.ecr.us-east-1.amazonaws.com/upg-app-1:\${BUILD_NUMBER}"
        }
      }*/
      stage('Docker Run') {
        steps {
            sh "ssh -i $SSH_KEY_FILE -o StrictHostKeyChecking=no ubuntu@172.31.29.27"
          /*script {
              sshagent(['test']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@10.0.2.129'
              }
          }*/
        }
      }
    }

    post {
        always {
            deleteDir()
            sh "docker rmi 416827206337.dkr.ecr.us-east-1.amazonaws.com/upg-app-1:\${BUILD_NUMBER}"
            }
        }
}
