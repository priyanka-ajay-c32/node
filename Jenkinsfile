pipeline {
    agent any
    options {
            buildDiscarder(logRotator(numToKeepStr: '10'))
            disableConcurrentBuilds()
            timeout(time: 1, unit: 'HOURS')
    }
    environment {
            AWS_DEFAULT_REGION = 'us-east-1'
            SSH_KEY_FILE = credentials('app-key')
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
      stage('Deploy Docker Image') {
        steps {
          script {
            sh """
            ssh -i $SSH_KEY_FILE -o StrictHostKeyChecking=no ubuntu@10.0.2.132 << EOF
            pwd
            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 416827206337.dkr.ecr.us-east-1.amazonaws.com
            docker pull 416827206337.dkr.ecr.us-east-1.amazonaws.com/upg-app-1:\${BUILD_NUMBER}
            docker stop upg-app-1
            docker rm upg-app-1
            docker run -itd -p 8080:8081 416827206337.dkr.ecr.us-east-1.amazonaws.com/upg-app-1:\${BUILD_NUMBER}
            exit 0
            << EOF
            """
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
