pipeline {
    agent any
    options {
            buildDiscarder(logRotator(numToKeepStr: '10'))
            disableConcurrentBuilds()
            timeout(time: 1, unit: 'HOURS')
    }
    environment {
            AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
      stage('Git Checkout') {
        steps {
          checkout scm
        }
      }
      stage('Build Docker Image') {
        steps {
            sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 416827206337.dkr.ecr.us-east-1.amazonaws.com"
            sh "docker build . -t 416827206337.dkr.ecr.us-east-1.amazonaws.com/upg-app-1:\${BUILD_NUMBER}"
            sh "docker push 416827206337.dkr.ecr.us-east-1.amazonaws.com/upg-app-1:\${BUILD_NUMBER}"
        }
      }
      stage('Docker Run') {
        steps {
          script {
            sshagent(credentials : ['aws_ec2']) {
              sh 'ssh -o StrictHostKeyChecking=no -i assignment-c7key.pem ubuntu@10.0.2.129'
              sh 'ls -l'
            }
          }
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
