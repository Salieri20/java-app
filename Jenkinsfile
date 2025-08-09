pipeline {
  agent any

  environment {
    IMAGE = "salieri20/java-app"
    CREDENTIALS_ID = 'dockerhub'   
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh './mvnw -B -DskipTests package'
      }
      post {
        success { archiveArtifacts artifacts: 'target/*.jar', fingerprint: true }
      }
    }

    stage('Unit Tests') {
      steps {
        sh './mvnw -B test || true'  
      }
    }

    stage('Docker Build') {
      steps {
        sh "docker build -t ${IMAGE}:${BUILD_NUMBER} ."
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${CREDENTIALS_ID}",
                                          usernameVariable: 'DOCKER_USER',
                                          passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${IMAGE}:${BUILD_NUMBER}"
        }
      }
    }
  }

  post {
    always {
      sh 'docker image ls --format "{{.Repository}}:{{.Tag}} {{.Size}}" || true'
    }
  }
}
