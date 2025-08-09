pipeline {
  agent any
  environment {
    DOCKERHUB_CREDS = credentials('dockerhub-creds') 
    IMAGE_NAME = "${DOCKERHUB_CREDS_USR}/java-app"   
    TAG = "${env.BUILD_NUMBER}"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build (Maven)') {
      steps {
        sh './mvnw -B clean package || mvn -B clean package'
      }
      post {
        success { archiveArtifacts artifacts: 'target/*.jar', fingerprint: true }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          dockerImage = docker.build("${IMAGE_NAME}:${TAG}")
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
            dockerImage.push()
            dockerImage.push('latest')
          }
        }
      }
    }
  }

  post {
    always {
      sh '''
        docker image prune -f || true
      '''
    }
    success {
      echo "Pushed ${IMAGE_NAME}:${TAG} and ${IMAGE_NAME}:latest"
    }
    failure {
      echo "Build or push failed"
    }
  }
}
